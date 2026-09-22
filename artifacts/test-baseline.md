# Boundary harness baseline

## Execution context

- PowerShell: `5.1.19041.6456`
- Caller working directory: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness`
- `PSScriptRoot`: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\tests`
- Harness: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\tests\run-boundary-tests.ps1`
- Suite: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\references\boundary-test-suite.md`
- Initial default paths: `...\technical-documentation\tests\results` and `...\technical-documentation\tests\sandbox`

## Initial external-run observation

The default Claude invocation created `BT-01-trial1-claude-20260922-101553.stderr.txt` (0 bytes) and did not complete within the 30-second execution window. Full captured stderr was empty.

```text

```

## Deterministic pre-fix failure

Using a local successful stand-in with relative paths (`artifacts\pre-fix-results` and `artifacts\pre-fix-sandbox`) reproduced the harness error before any source edit. After `Push-Location`, the harness tried to redirect stderr to a path relative to the sandbox:

```text
FAILED: BT-01, trial 1. Could not find a part of the path 'C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\artifacts\pre-fix-sandbox\artifacts\pre-fix-results\BT-01-trial1-claude-20260922-101707.stderr.txt'.
```

The full PowerShell error record emitted by that run was:

```text
C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\technical-documentation\tests\run-boundary-tests.ps1 : FAILED: BT-01, trial 1. Could not find a part of the path 'C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness\artifacts\pre-fix-sandbox\artifacts\pre-fix-results\BT-01-trial1-claude-20260922-101707.stderr.txt'.
At line:2 char:291
+ ... ; exit 0 }; & '.\technical-documentation\tests\run-boundary-tests.ps1 ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,run-boundary-tests.ps1
```

## Cause

`Push-Location` changes the PowerShell location before per-trial output paths are joined. Relative output paths therefore resolve from the sandbox. Separately, native stderr becomes a terminating error record under `ErrorActionPreference = Stop` in Windows PowerShell, even when redirected.
