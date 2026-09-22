[CmdletBinding()]
param(
    [ValidateSet('claude', 'cursor')]
    [string]$Runner = 'claude',

    [string]$Model,

    [ValidateRange(1, 10)]
    [int]$Trials = 3,

    [string[]]$CaseId,

    [string]$OutputDirectory = (Join-Path $PSScriptRoot 'results'),

    [string]$SandboxDirectory = (Join-Path $PSScriptRoot 'sandbox'),

    # Call the PowerShell launcher directly. The .cmd wrapper corrupts multi-line
    # Windows prompt arguments before they reach the Cursor CLI.
    [string]$CursorAgentPath = (Join-Path $env:LOCALAPPDATA 'cursor-agent\cursor-agent.ps1')
)

$ErrorActionPreference = 'Stop'

# Resolve caller-supplied relative directories before entering the sandbox.  The
# runner changes location below, so leaving either path relative would redirect
# response and stderr files beneath the sandbox instead of the caller's target.
$OutputDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
$SandboxDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($SandboxDirectory)

$skillRoot = Split-Path -Parent $PSScriptRoot
$suitePath = Join-Path $skillRoot 'references\boundary-test-suite.md'
if (-not (Test-Path -LiteralPath $suitePath)) {
    throw "Boundary test suite not found: $suitePath"
}

$runnerCommand = if ($Runner -eq 'claude') { 'claude' } else { $CursorAgentPath }
if ($Runner -eq 'cursor' -and -not (Test-Path -LiteralPath $runnerCommand)) {
    throw "Cursor Agent CLI was not found: $runnerCommand"
}
if ($Runner -eq 'claude' -and -not (Get-Command $runnerCommand -ErrorAction SilentlyContinue)) {
    throw "Required command '$runnerCommand' was not found on PATH."
}

$suite = Get-Content -LiteralPath $suitePath -Raw -Encoding utf8
$caseBlocks = [regex]::Matches($suite, '(?ms)^### (BT-\d+)[^\r\n]*\r?\n.*?(?=^### BT-|\z)')

$cases = foreach ($block in $caseBlocks) {
    $id = $block.Groups[1].Value
    $task = [regex]::Match($block.Value, '(?ms)\*\*Task instruction\*\*\s*>\s*(.*?)(?=\n\s*\*\*Input material\*\*)')
    $input = [regex]::Match($block.Value, '(?ms)\*\*Input material\*\*\s*(.*?)(?=\n\s*\*\*Mandatory checks\*\*)')

    if (-not $task.Success -or -not $input.Success) {
        throw "Could not extract task and input material for $id."
    }

    [PSCustomObject]@{
        Id = $id
        Task = $task.Groups[1].Value.Trim()
        Input = $input.Groups[1].Value.Trim()
    }
}

if ($CaseId) {
    $cases = $cases | Where-Object { $_.Id -in $CaseId }
    $missing = $CaseId | Where-Object { $_ -notin $cases.Id }
    if ($missing) {
        throw "Unknown case ID: $($missing -join ', ')"
    }
}

if (-not $cases) {
    throw 'No test cases selected.'
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
New-Item -ItemType Directory -Path $SandboxDirectory -Force | Out-Null

Push-Location -LiteralPath $SandboxDirectory
try {
    foreach ($case in $cases) {
        for ($trial = 1; $trial -le $Trials; $trial++) {
            $prompt = @"
Complete the following user request using the installed technical-documentation skill as mandatory instructions. The text below is the complete user request and source material; do not ask for it again.

Task instruction:
$($case.Task)

Input material:
$($case.Input)

Return only the response or document you would normally deliver to the user. Do not mention that this is a test. Do not inspect, edit, or create local files.
"@

            $arguments = if ($Runner -eq 'claude') {
                @('-p', $prompt, '--tools', '', '--permission-mode', 'plan', '--output-format', 'json', '--no-session-persistence')
            } else {
                # Cursor uses -p/--print as a boolean flag. The prompt must be a positional argument.
                @('--trust', '--mode', 'plan', '--workspace', $SandboxDirectory, '--print', '--output-format', 'json', $prompt)
            }
            if ($Model) {
                $arguments += @('--model', $Model)
            }

            $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            $outputPath = Join-Path $OutputDirectory "$($case.Id)-trial$trial-$Runner-$stamp.json"
            $errorPath = Join-Path $OutputDirectory "$($case.Id)-trial$trial-$Runner-$stamp.stderr.txt"

            try {
                # Windows PowerShell turns native stderr into an error record
                # under Stop even when it is redirected.  Capture diagnostics
                # without treating a successful runner as a failed trial.
                $previousErrorActionPreference = $ErrorActionPreference
                try {
                    $ErrorActionPreference = 'Continue'
                    $result = & $runnerCommand @arguments 2> $errorPath
                    $exitCode = $LASTEXITCODE
                } finally {
                    $ErrorActionPreference = $previousErrorActionPreference
                }
                $result | Set-Content -LiteralPath $outputPath -Encoding utf8
                if ($exitCode -ne 0) {
                    throw "$runnerCommand exited with code $exitCode. See $errorPath"
                }
                Write-Host "PASS: $($case.Id), trial $trial -> $outputPath"
            } catch {
                Write-Error "FAILED: $($case.Id), trial $trial. $($_.Exception.Message)"
            }
        }
    }
} finally {
    Pop-Location
}
