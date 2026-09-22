# Quality gates

Before formal delivery, first confirm the evidence ledger (see SKILL delivery workflow) is complete and fail-closed. Reject delivery if any ledger row is `verified` without a re-runnable command and observed result, `sourced` without a citable link or ID, `decision` without a named owner, or marked `gap? = yes`. Reject delivery if any conclusion tagged `sourced` or `decision` is phrased in the document as a verified assertion. On any rejection, drop to clarification mode and offer stop / record-as-pending / record-as-blocker — do not soften or downgrade the requirement to deliver anyway.

Then check internally: reader/outcome clear; linear reading path; type and role purity; evidence-backed conclusions; executable procedures with prerequisites/actions/observable results; purposeful artifacts and valid links; no sensitive data; correct split/navigation; no author-side drafting rationale, document-history comparison, or list of intentionally omitted content.

Treat the following as hard failures: Agent self-commentary or tool output; a drafting preface or completion note; invented facts, commands, roles, paths, or approval routes; leaked credentials; an unsupported conclusion; a mixed-audience or mixed-purpose monolith that lacks a usable reading path; or a missing prerequisite presented as an executable step.

Verify every boundary or limitation still satisfies the common-rules boundary/negative-statement test (reader-visible evidence, operational condition, safety/authorization/compatibility constraint, or result-interpretation condition). Remove any that only explains the author's writing decision.

If a gate fails, delete or relocate noise, reorganize, seek evidence, or ask the user for a decision. Do not include this checklist in the final document.
