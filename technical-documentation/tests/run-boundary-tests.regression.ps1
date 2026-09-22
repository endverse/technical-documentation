[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$EvidenceDirectory
)

$ErrorActionPreference = 'Stop'

$runnerPath = Join-Path $PSScriptRoot 'run-boundary-tests.ps1'
$fixturePath = Join-Path $PSScriptRoot 'fixtures\fake-claude.cmd'
$EvidenceDirectory = [System.IO.Path]::GetFullPath($EvidenceDirectory)
New-Item -ItemType Directory -Path $EvidenceDirectory -Force | Out-Null

Push-Location -LiteralPath $EvidenceDirectory
try {
    # The runner must keep relative result paths anchored at the caller, even
    # after it enters its sandbox. Cursor's configurable launcher lets this
    # test use a local stand-in without reaching an external agent service.
    & $runnerPath -Runner cursor -CursorAgentPath $fixturePath -CaseId BT-01 -Trials 1 -OutputDirectory 'output' -SandboxDirectory 'sandbox'
    if ($LASTEXITCODE -ne 0) {
        throw "Harness exited with code $LASTEXITCODE."
    }

    $response = Get-ChildItem -LiteralPath (Join-Path $EvidenceDirectory 'output') -Filter 'BT-01-trial1-cursor-*.json' | Select-Object -First 1
    $stderr = Get-ChildItem -LiteralPath (Join-Path $EvidenceDirectory 'output') -Filter 'BT-01-trial1-cursor-*.stderr.txt' | Select-Object -First 1
    if (-not $response -or -not $stderr) {
        throw 'Expected response and stderr files were not written to the caller output directory.'
    }
    if (Test-Path -LiteralPath (Join-Path $EvidenceDirectory 'sandbox\output')) {
        throw 'Output was incorrectly resolved relative to the sandbox.'
    }
    $stderrText = [string](Get-Content -LiteralPath $stderr.FullName -Raw)
    if ($stderrText -notmatch 'fake runner stderr') {
        throw 'The fake runner stderr was not captured.'
    }

    [PSCustomObject]@{
        passed = $true
        responsePath = $response.FullName
        stderrPath = $stderr.FullName
        stderr = $stderrText
    } | ConvertTo-Json -Compress | Set-Content -LiteralPath (Join-Path $EvidenceDirectory 'regression-result.json') -Encoding utf8
} finally {
    Pop-Location
}
