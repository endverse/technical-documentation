# Deterministic stand-in for the Cursor Agent CLI.
# Captures the final prompt argument when FAKE_AGENT_CAPTURE_DIR is set.
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArgs
)

$ErrorActionPreference = 'Continue'
$captureDir = $env:FAKE_AGENT_CAPTURE_DIR
if ($captureDir) {
    New-Item -ItemType Directory -Path $captureDir -Force | Out-Null
    $RemainingArgs | Set-Content -LiteralPath (Join-Path $captureDir 'args.txt') -Encoding utf8
    if ($RemainingArgs -and $RemainingArgs.Count -gt 0) {
        $RemainingArgs[-1] | Set-Content -LiteralPath (Join-Path $captureDir 'prompt.txt') -Encoding utf8
    }
}

Write-Output '{"status":"ok","runner":"fake-cursor-agent"}'
[Console]::Error.WriteLine('fake runner stderr')
exit 0
