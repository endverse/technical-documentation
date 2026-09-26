# Quality gates

Run these checks internally. Do not include this checklist, a claim-to-paragraph map, or a drafting note in the document.

Before the body, confirm the evidence ledger (see SKILL delivery workflow) is complete and fail-closed. Reject delivery if any ledger row is `verified` without a re-runnable command, test, or direct observation and its result, `sourced` without a citable link or ID, `decision` without a named owner, or marked as a gap. Reject delivery if any conclusion tagged `sourced` or `decision` is phrased in the document as a verified assertion. On any rejection, return to the claim sheet and offer stop / record-as-pending / record-as-blocker — do not soften or downgrade the requirement to deliver anyway.

## Admission, before the body

Fail and return to the claim sheet when any of these are true: a claim was not confirmed; the draft quotes the user's colloquial wording; an 实验夹具 number appears as a result; a conclusion has no confirmed claim; evidence conflicts and the user has not chosen how to treat it; credentials appear; a missing prerequisite is written as an executable step.

## Presentation, during reader revision

Fail and revise before delivery when any of these are true: a judgment document's first screen does not state the conclusion, the evidence it rests on, and what the reader should believe or do next; a section has no opening judgment before its table; a procedure step lacks a prerequisite, action, or observable result; the order follows the chat instead of the document type; author-side drafting rationale, document-history comparison, or a list of intentionally omitted content remains.

Also fail: Agent self-commentary or tool output; a drafting preface or completion note; invented facts, commands, roles, paths, or approval routes; an unsupported conclusion; a mixed-audience or mixed-purpose monolith that lacks a usable reading path.

Verify every boundary or limitation still satisfies the common-rules boundary/negative-statement test (reader-visible evidence, operational condition, safety/authorization/compatibility constraint, or result-interpretation condition). Remove any that only explains the author's writing decision.

If a gate fails, delete or relocate noise, reorganize, seek evidence, or ask the user for a decision. Do not include this checklist in the final document.
