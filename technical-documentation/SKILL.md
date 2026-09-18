---
name: technical-documentation
description: Organize technical research, design, validation, operations, incidents, and delivery work into clear, evidence-based technical documents. Use throughout relevant work and when drafting or restructuring technical documentation.
---

# Technical documentation

Use this skill for technical research, architecture/design, deployment, testing, operations, issue analysis, handover, service onboarding, retrospectives, and documents created from that work. Do not apply it to unrelated coding or casual requests.

## Work in two modes

- **Process organization:** During relevant discussion, classify information as verified fact, sourced fact, confirmed decision, unresolved item, or discardable process noise. Do not create a formal document or persistent work log unless the user asks.
- **Formal delivery:** When the user asks to summarize or produce a document, use only material relevant to the target reader that is verified or confirmed. Do not repeat questions already resolved in the discussion.

## Delivery workflow

1. Read [common rules](references/common-rules.md).
2. If type is unclear, read [scenario guide](references/scenario-guide.md); ask only necessary unanswered questions.
3. If verification is incomplete or evidence conflicts, do not write a formal conclusion. State what is known, missing, and needs a user decision.
4. Read only the selected file under `references/document-types/`.
5. If splitting or structural rewriting is needed, read [document splitting](references/document-splitting.md) and obtain confirmation first.
6. Before delivery, read [quality gates](references/quality-gates.md). Keep this check internal.

Read [research basis](references/research-basis.md) only when the user asks about template rationale or the skill needs maintenance.

When evaluating or maintaining this skill, read [boundary test suite](references/boundary-test-suite.md). Do not load it for ordinary document work.

## Scope boundaries

- Default to one primary reader and one primary goal. `service-onboarding.md` is the narrow shared-role exception.
- Do not mix concept, procedure, reference, troubleshooting, incident analysis, and retrospective content in one section.
- Do not preserve failed experiments, debugging transcripts, or role-irrelevant notes in formal documents unless they are outcome evidence or required in a retrospective.
