# Administration and Operations Runbook

Use for administrator, operator, or implementer configuration, maintenance, recovery, or operational troubleshooting; do not use for ordinary-user business tasks.

Path: responsibility and impact → prerequisites/risk → standard procedure → verification and rollback/recovery → exception and escalation.

Required: responsibility/goal/impact; permissions/tools/backups; ordered standard action; validation; rollback or recovery condition; exception/escalation boundary. Optional: routine checklist, monitoring thresholds, change window, approval, record template. Exclude tenant usage instructions and unverified production commands. Split each independently executable operational outcome into a runbook.

Check: risky actions have a clear stop, validation, and recovery path.

Do not substitute vague on-the-spot-confirmation filler (e.g. “若不存在则现场确认”) for an unknown resource owner, application/approval path, or acceptance criterion. When a required element is unknown, mark it as a gap and pause to offer stop / record-as-pending / record-as-blocker; do not claim the runbook is complete or executable while such gaps remain.
