---
name: technical-documentation
description: Organize technical research, design, validation, operations, incidents, and delivery work into clear, evidence-based technical documents. Use throughout relevant work and when drafting or restructuring technical documentation.
---

# Technical documentation

Use this skill for technical research, architecture/design, deployment, testing, operations, issue analysis, handover, service onboarding, retrospectives, and documents created from that work. Do not apply it to unrelated coding or casual requests.

## Work in two modes

- **Process organization:** During relevant discussion, classify information as verified fact, sourced fact, confirmed decision, unresolved item, or discardable process noise. Keep that classification internal. Do not create a formal document, a claim sheet, or a persistent work log unless the user asks.
- **Formal delivery:** When the user asks to summarize or produce a document, run the delivery pipeline below. Use only claims the user has confirmed. Do not repeat questions already resolved in the discussion.

## Delivery pipeline

Run these steps in order. Do not combine them in one response. Do not read later-step files early.

1. **Claim sheet.** Read [claim sheet](references/claim-sheet.md). If this delivery has no user-confirmed sheet, reply with only the sheet and stop. Do not write the document in that response.
2. **Skeleton.** After the user confirms the sheet, choose the response mode below. Read [scenario guide](references/scenario-guide.md) only when the type is still unclear. Stop only when the reader, document type, or a split is still undecided. If those are already known, do not show an outline and continue.
3. **Body.** Read [common rules](references/common-rules.md), [presentation](references/presentation.md), and only the selected file under `references/document-types/`. Write from confirmed claims only. Do not pull new facts from the chat.
4. **Reader revision.** Re-read [presentation](references/presentation.md) and [quality gates](references/quality-gates.md). Revise the draft internally, then deliver the document alone. Do not show the pre-revision draft, the checklist, or a second copy.

Reading order and connective sentences are fixed by the selected document type and by [presentation](references/presentation.md). The confirmed sheet controls which links are allowed, not the section order.

## Choose one response mode

Before responding to a documentation request, choose exactly one mode. Do not mix them in one response.

Keep the choice and all internal work internal. Never mention this skill, its files, rules, reading steps, tool use, drafting process, or completion state in user-facing output. Start directly with the claim sheet, the requested document, a proposal, or the necessary question.

- **Clarification or decision request:** Use when the document type, reader, critical facts, or evidence state is missing. State only what is known, what is missing, and the decision the user must make. When an unresolved item could be documented as a blocker, ask whether the user wants to stop, record it as pending, or record it as a blocker; do not choose on the user's behalf. Also use when the material is complete enough to draft but its intent is undetermined: before formalizing an operational prohibition whose risk basis is unstated, ask whether it is a concrete safety/compatibility risk or only author preference; and when the material fits two document types it cannot distinguish (e.g., onboarding vs. handover), ask which intent applies rather than silently selecting one.
- **Document architecture proposal:** Use when the request contains multiple readers, independent goals, or document types, or when the user asks to classify, split, or restructure material. Propose the smallest document set, its readers, purposes, boundaries, and reading order. Do not draft a combined document first. Obtain confirmation before creating or restructuring a multi-file set.
- **Formal delivery:** Use only after the claim sheet is confirmed and the document can be written safely. The user-facing result is the revised document and nothing about the drafting process.

## Delivery workflow

1. On a publish request, start at pipeline step 1. Do not write prose before the user confirms the sheet.
2. If verification is incomplete or evidence conflicts, keep that item unresolved on the sheet and ask whether to stop, continue verification, record it as pending, or record it as a blocker. Do not write an unsupported conclusion.
3. If splitting or structural rewriting is needed, read [document splitting](references/document-splitting.md) during the skeleton step and obtain confirmation first.
4. Run the reader revision before delivery. Keep that check internal.

Read [research basis](references/research-basis.md) only when the user asks about template rationale or the skill needs maintenance.

When evaluating or maintaining this skill, read [boundary test suite](references/boundary-test-suite.md). Do not load it for ordinary document work.

## Scope boundaries

- Default to one primary reader and one primary goal. `service-onboarding.md` is the narrow shared-role exception.
- Do not mix concept, procedure, reference, troubleshooting, incident analysis, and retrospective content in one section.
- Do not preserve failed experiments, debugging transcripts, or role-irrelevant notes in formal documents unless they are outcome evidence or required in a retrospective.
- Every user-facing response begins with reader-facing content and ends with reader-facing content. Do not prepend or append a drafting preface, Skill or rule reference, tool output, self-commentary, completion notice, or invitation for further work.
