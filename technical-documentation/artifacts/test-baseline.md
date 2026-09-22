# Boundary harness baseline

## Execution context

- PowerShell: `5.1.19041.6456`
- Caller working directory: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness`
- `$PSScriptRoot`: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\tests`
- Harness: `technical-documentation/tests/run-boundary-tests.ps1`
- Suite: `technical-documentation/references/boundary-test-suite.md`
- Default paths: `...\tests\results`, `...\tests\sandbox`

## Reproduction (pre-fix failure)

With a successful local stand-in and **relative** `-OutputDirectory` / `-SandboxDirectory`, the pre-fix harness joined output paths after `Push-Location` into the sandbox. Full stderr from that failure:

```text
FAILED: BT-01, trial 1. Could not find a part of the path 'C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\artifacts\pre-fix-sandbox\artifacts\pre-fix-results\BT-01-trial1-claude-20260922-101707.stderr.txt'.
```

Full PowerShell error record:

```text
C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\tests\run-boundary-tests.ps1 : FAILED: BT-01, trial 1. Could not find a part of the path '...\artifacts\pre-fix-sandbox\artifacts\pre-fix-results\BT-01-trial1-claude-20260922-101707.stderr.txt'.
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,run-boundary-tests.ps1
```

Separately, under `$ErrorActionPreference = 'Stop'`, native stderr redirected with `2>` still became a terminating error record in Windows PowerShell 5.1, so a successful runner that wrote stderr was treated as a failed trial.

## Root cause

1. Relative output paths were resolved after `Push-Location` into the sandbox.
2. Native stderr + `Stop` turned diagnostics into terminating errors even when redirected.
3. `Write-Error` under `Stop` aborted the suite after the first failed trial, so later BT cases produced no evidence.
4. `$exitCode -ne 0` treated `$null` `LASTEXITCODE` as failure.

## Fix

- Resolve `-OutputDirectory` / `-SandboxDirectory` to absolute paths before entering the sandbox.
- Temporarily set `$ErrorActionPreference = 'Continue'` around the native invocation.
- Count failed trials, continue the suite, throw once at the end if any failed.
- Treat only non-null non-zero exit codes as trial failures.

## Post-fix verification

Captured stderr from a successful relative-path trial (fake runner) begins with:

```text
fake-claude.cmd : fake runner stderr
At ...\run-boundary-tests.ps1:115 char:31
+ ...                   $result = & $runnerCommand @arguments 2> $errorPath
```

Full suite command (Mandatory-check contract per BT-01..BT-34: checks present, task/input parsed, checks not leaked into agent prompt; plus relative-path/stderr infra check):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File technical-documentation\tests\run-boundary-tests.suite.ps1 -EvidenceDirectory <dir> -Index <n>
```

Two consecutive full runs: both `total=34 passed=34 failed=0`.

## Known limits

- This gate scores harness readiness for Mandatory-check evaluation (parse + non-leakage + evidence paths), not live-agent document quality against those checks.
- Live Claude/Cursor matrix remains separate; sample historical BT-01 agent output still fails “no mixed manual” and is out of scope for this harness-only worktree.
