# Claim sheet

Build this sheet when the user asks for a document and has not confirmed one in this delivery. The reply is only the sheet. Do not add a document, an outline, or a drafting note.

One row per claim:

`状态 | 主张 | 数字类型`

Status is exactly one of:

- 已验证事实
- 资料事实
- 已确认决定
- 未决事项
- 应丢弃的过程噪音

Number type is exactly one of: 设计常量, 判定结果, 测量结果, 实验夹具. Use `—` when the claim has no number.

Rules:

- Rewrite each claim as a standalone proposition. Do not quote the user's colloquial wording.
- Mark ports, sample IDs, temporary configuration, failed commands, and superseded measurements as 实验夹具 and 应丢弃的过程噪音, unless that failure itself proves a hard requirement is unmet. In that case keep the outcome as 已验证事实 and type the number 判定结果.
- A sourced description is 资料事实, not a measured result.
- A user or project choice is 已确认决定, not a technical necessity.
- Conflicting evidence stays 未决事项. Ask whether to stop, keep verifying, record it as pending, or record it as a blocker. Do not choose for the user.
- Do not write the document until the user confirms or corrects the sheet. After confirmation, do not add claims from the chat that are not on the confirmed sheet.
