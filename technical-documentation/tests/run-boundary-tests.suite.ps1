[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$EvidenceDirectory,

    [ValidateRange(1, 10)]
    [int]$Index = 1
)

$ErrorActionPreference = 'Stop'

$testsRoot = $PSScriptRoot
$runnerPath = Join-Path $testsRoot 'run-boundary-tests.ps1'
$fixtureCmd = Join-Path $testsRoot 'fixtures\fake-claude.cmd'
$fixtureAgent = Join-Path $testsRoot 'fixtures\fake-cursor-agent.ps1'
$suitePath = Join-Path (Split-Path -Parent $testsRoot) 'references\boundary-test-suite.md'

$EvidenceDirectory = [System.IO.Path]::GetFullPath($EvidenceDirectory)
New-Item -ItemType Directory -Path $EvidenceDirectory -Force | Out-Null

function Get-BoundaryCases {
    param([string]$Path)
    $suite = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    $caseBlocks = [regex]::Matches($suite, '(?ms)^### (BT-\d+)[^\r\n]*\r?\n.*?(?=^### BT-|\z)')
    foreach ($block in $caseBlocks) {
        $id = $block.Groups[1].Value
        $task = [regex]::Match($block.Value, '(?ms)\*\*Task instruction\*\*\s*>\s*(.*?)(?=\n\s*\*\*Input material\*\*)')
        $input = [regex]::Match($block.Value, '(?ms)\*\*Input material\*\*\s*(.*?)(?=\n\s*\*\*Mandatory checks\*\*)')
        $mandatory = [regex]::Match($block.Value, '(?ms)\*\*Mandatory checks\*\*\s*(.*?)(?=\n\s*\*\*Fail if|\n\s*### |\z)')
        $failIf = [regex]::Match($block.Value, '(?ms)\*\*Fail if output contains\*\*\s*(.*?)(?=\n\s*### |\z)')
        $checks = @()
        if ($mandatory.Success) {
            $checks = @(
                [regex]::Matches($mandatory.Groups[1].Value, '(?m)^\s*-\s+(.*\S)\s*$') |
                    ForEach-Object { $_.Groups[1].Value.Trim() }
            )
        }
        [PSCustomObject]@{
            Id = $id
            Task = if ($task.Success) { $task.Groups[1].Value.Trim() } else { '' }
            Input = if ($input.Success) { $input.Groups[1].Value.Trim() } else { '' }
            MandatoryChecks = $checks
            MandatoryRaw = if ($mandatory.Success) { $mandatory.Groups[1].Value.Trim() } else { '' }
            FailIfRaw = if ($failIf.Success) { $failIf.Groups[1].Value.Trim() } else { '' }
        }
    }
}

$cases = @(Get-BoundaryCases -Path $suitePath)
if ($cases.Count -eq 0) {
    throw "No boundary cases parsed from $suitePath"
}
if ($cases.Count -lt 60) {
    throw "Expanded suite requires >= 60 cases; found $($cases.Count)."
}

$caseResults = @()
$passed = 0
$failed = 0

# --- A2 machine check: scenario-guide routing rows ↔ document-types files ---
$skillRoot = Split-Path -Parent $testsRoot
$scenarioPath = Join-Path $skillRoot 'references\scenario-guide.md'
$typesDir = Join-Path $skillRoot 'references\document-types'
$scenario = Get-Content -LiteralPath $scenarioPath -Raw -Encoding utf8
$routeIds = @(
    [regex]::Matches($scenario, '(?m)^\|[^|\r\n]+\|\s*`([a-z0-9-]+)(?:\.md)?`\s*\|') |
        ForEach-Object { $_.Groups[1].Value } |
        Select-Object -Unique
)
if ($routeIds.Count -lt 11) {
    throw "scenario-guide routing table yielded fewer than 11 type ids ($($routeIds.Count))."
}
$missingTypes = @()
foreach ($id in $routeIds) {
    $typeFile = Join-Path $typesDir "$id.md"
    if (-not (Test-Path -LiteralPath $typeFile)) {
        $missingTypes += $id
    }
}
if ($missingTypes.Count -gt 0) {
    throw "Routing integrity failed; missing document-types files: $($missingTypes -join ', ')"
}
$extraTypeFiles = @(
    Get-ChildItem -LiteralPath $typesDir -Filter '*.md' |
        Where-Object { $_.BaseName -notin $routeIds } |
        ForEach-Object { $_.BaseName }
)
if ($extraTypeFiles.Count -gt 0) {
    throw "Routing integrity failed; document-types without routing rows: $($extraTypeFiles -join ', ')"
}
Write-Host "PASS routing-integrity (types=$($routeIds.Count))"

# --- Infra case: relative output + stderr capture (harness defect regression) ---
$infraDir = Join-Path $EvidenceDirectory 'infra-relative'
New-Item -ItemType Directory -Path $infraDir -Force | Out-Null
Push-Location -LiteralPath $infraDir
try {
    & $runnerPath -Runner cursor -CursorAgentPath $fixtureCmd -CaseId BT-01 -Trials 1 -OutputDirectory 'output' -SandboxDirectory 'sandbox'
    if ($LASTEXITCODE -ne 0) {
        throw "Harness exited with code $LASTEXITCODE during infra relative-path check."
    }
    $response = Get-ChildItem -LiteralPath (Join-Path $infraDir 'output') -Filter 'BT-01-trial1-cursor-*.json' | Select-Object -First 1
    $stderr = Get-ChildItem -LiteralPath (Join-Path $infraDir 'output') -Filter 'BT-01-trial1-cursor-*.stderr.txt' | Select-Object -First 1
    if (-not $response -or -not $stderr) {
        throw 'Expected response and stderr files were not written to the caller output directory.'
    }
    if (Test-Path -LiteralPath (Join-Path $infraDir 'sandbox\output')) {
        throw 'Output was incorrectly resolved relative to the sandbox.'
    }
    $stderrText = [string](Get-Content -LiteralPath $stderr.FullName -Raw)
    if ($stderrText -notmatch 'fake runner stderr') {
        throw 'The fake runner stderr was not captured.'
    }
} finally {
    Pop-Location
}

foreach ($case in $cases) {
    $reasons = @()

    # Mandatory-check presence (scoring basis for each BT case).
    if (-not $case.Task) { $reasons += 'Task instruction missing or unparsed.' }
    if (-not $case.Input) { $reasons += 'Input material missing or unparsed.' }
    if ($case.MandatoryChecks.Count -lt 1) {
        $reasons += 'Mandatory checks missing; case cannot be scored.'
    }

    $captureDir = Join-Path $EvidenceDirectory "capture-$($case.Id)"
    if (Test-Path -LiteralPath $captureDir) {
        Remove-Item -LiteralPath $captureDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $captureDir -Force | Out-Null
    $env:FAKE_AGENT_CAPTURE_DIR = $captureDir
    try {
        $outDir = Join-Path $EvidenceDirectory "out-$($case.Id)"
        $sandboxDir = Join-Path $EvidenceDirectory "sandbox-$($case.Id)"
        & $runnerPath -Runner cursor -CursorAgentPath $fixtureAgent -CaseId $case.Id -Trials 1 -OutputDirectory $outDir -SandboxDirectory $sandboxDir
        if ($LASTEXITCODE -ne 0) {
            $reasons += "Harness exited with code $LASTEXITCODE."
        }
    } finally {
        Remove-Item Env:\FAKE_AGENT_CAPTURE_DIR -ErrorAction SilentlyContinue
    }

    $promptPath = Join-Path $captureDir 'prompt.txt'
    if (-not (Test-Path -LiteralPath $promptPath)) {
        $reasons += 'Fake agent did not capture the prompt.'
    } else {
        $prompt = Get-Content -LiteralPath $promptPath -Raw -Encoding utf8
        if ($case.Task -and ($prompt -notmatch [regex]::Escape(($case.Task.Substring(0, [Math]::Min(16, $case.Task.Length)))))) {
            $reasons += 'Prompt does not include the task instruction excerpt.'
        }
        if ($prompt -match '(?m)\*\*Mandatory checks\*\*' -or $prompt -match 'Mandatory checks') {
            $reasons += 'Prompt leaked Mandatory checks section heading.'
        }
        if ($prompt -match '(?m)\*\*Fail if output contains\*\*' -or $prompt -match 'Fail if output contains') {
            $reasons += 'Prompt leaked Fail-if section heading.'
        }
        foreach ($check in $case.MandatoryChecks) {
            $snippet = $check.Substring(0, [Math]::Min(24, $check.Length))
            if ($snippet.Length -ge 12 -and $prompt.Contains($snippet)) {
                $reasons += "Prompt leaked Mandatory check text: $snippet"
                break
            }
        }
        if ($case.FailIfRaw) {
            $failSnippet = ($case.FailIfRaw -split "`n" | Where-Object { $_.Trim().StartsWith('-') } | Select-Object -First 1)
            if ($failSnippet) {
                $failText = $failSnippet.Trim().TrimStart('-').Trim()
                $fs = $failText.Substring(0, [Math]::Min(24, $failText.Length))
                if ($fs.Length -ge 12 -and $prompt.Contains($fs)) {
                    $reasons += "Prompt leaked Fail-if text: $fs"
                }
            }
        }
    }

    $ok = ($reasons.Count -eq 0)
    if ($ok) { $passed++ } else { $failed++ }
    $caseResults += [PSCustomObject]@{
        id = $case.Id
        passed = $ok
        mandatoryCheckCount = $case.MandatoryChecks.Count
        reasons = $reasons
    }
    $status = if ($ok) { 'PASS' } else { 'FAIL' }
    Write-Host "$status $($case.Id) (mandatoryChecks=$($case.MandatoryChecks.Count))"
    if (-not $ok) {
        $reasons | ForEach-Object { Write-Host "  - $_" }
    }
}

$summary = [ordered]@{
    suite = 'boundary'
    index = $Index
    totalCases = $cases.Count
    total = $cases.Count
    passed = $passed
    failed = $failed
    infraRelativePathPassed = $true
    cases = $caseResults
}
$summaryPath = Join-Path $EvidenceDirectory 'suite-result.json'
($summary | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $summaryPath -Encoding utf8

if ($failed -ne 0) {
    throw "Boundary suite run $Index failed: $failed / $($cases.Count) cases."
}

Write-Host "SUITE_OK index=$Index total=$($cases.Count) passed=$passed failed=$failed"
