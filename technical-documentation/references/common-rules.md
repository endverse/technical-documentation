# Common rules

- Identify the primary reader and outcome before drafting. Split role-specific material by default; do not tell one role what another role does not need to do.
- Classify statements as **verified fact**, **sourced fact**, or **confirmed business decision**. A key conclusion needs traceable evidence. If evidence is missing or conflicts, pause and ask the user how to proceed.
- Use one forward reading path: context and conditions before decisions or action. Each section answers one question. Define terms before later use and use one canonical term per concept.
- Keep concepts, procedures, reference facts, troubleshooting, incident analysis, and retrospective learning separate. Link to a source of truth instead of duplicating it.
- Keep final effective paths. Remove failed attempts, transcripts, parenthetical asides, vague headings, repeated explanations, and any text whose removal would not make the reader misunderstand or fail.
- **Write only reader-needed information. Do not write author-side exclusions or comparison narratives in a formal document.** Delete text that explains document organization, why material was split, what this document does not replace, which former document or reader it cannot cover, which routes or products were intentionally not written, or what other roles do not do. Examples to delete include “不替代 how-to/ 下原文件”, “原用户手册不能覆盖……”, “普通用户不要读……”, “本页不写命令”, and “不写 HelmOp……”. The reader needs the applicable path, next step, or responsible role—not the drafting rationale.
- Keep a negative statement only when omitting it would create a concrete safety, authorization, compatibility, or irreversible-operation risk. State the required positive action first; make the prohibition short and operational. For example: “凭据通过工单提交；不得写入 Git。” Do not use a negative statement merely to describe scope, history, alternatives, or an excluded audience.
- Write Chinese unless asked otherwise. Keep commands, identifiers, paths, fields, APIs, and errors verbatim in code style. Use direct verbs and observable statements; avoid vague phrases such as “应该”, “一般来说”, and “相关配置即可”.
- Use diagrams for relationships or flows, tables for comparison/conditions/responsibility/results, code blocks for copyable commands, and screenshots only when visuals clarify location or evidence.
- Never include passwords, tokens, private keys, production data, or internal endpoints. Use placeholders and secure-transfer instructions.
- When relevant state version, date, owner, and last verification time. Use clear relevant links, not “见前文” or “见相关文档”.
