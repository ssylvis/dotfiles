---
name: doc-review
description: Independently review a technical document (design proposal, implementation spec, investigation, or any other doc) with a fresh subagent that sees only the document, then verify each finding before acting. Fixes wording on the user's own documents and brings design gaps to the user; on anyone else's document it only reports. Use when the user asks to review a doc, and as the review step of skills that write documents.
---

# Independent document review

A reviewer that never saw how a document was written catches what its author cannot: claims that lean on context the reader doesn't have, promises the design doesn't keep, and references that no longer line up. The value comes from that independence, and from checking the reviewer's findings before acting on them.

## 1. Identify the document

- **Type:** design, spec, investigation or general. A calling skill names the type; otherwise infer it from the document's sections and confirm with the user if unclear.
- **Ownership:** whether the user owns the document. On anyone else's document this skill only reports: no edits, no comments, no messages, unless the user asks for exactly that.
- **Scope:** the whole document, or the sections the user names. For a spec, both REQ and PLAN together.

## 2. Brief a fresh reviewer

Start a subagent that receives only:

- how to read the document (its location and the tool to read it with, or the text itself), with an instruction to read all of it and not to edit, comment on, or read anything else
- the check list for its type (below), asking for a short quote and the section for each finding
- the instruction to label each finding **WORDING** (a clarity or consistency fix that does not change what the document promises) or **DESIGN** (a gap that would change goals, guarantees, limits, scope or risks)
- the instruction to be specific and skeptical but not invent problems, and to answer "none" for an empty category
- a limit of about 600 words, returning only the report

Never pass the conversation, the author's intent, or your own opinion of the document. An agent handed a conclusion tends to confirm it.

## 3. Verify each finding

Reviewers without context get some things wrong. Before acting, check every finding against the document and, where it concerns facts, against the sources:

- Drop findings that misread the document, flag terms common across the organization as undefined, or call current-state facts history.
- Drop findings that reopen points the user has already decided, such as an approved risk or a deliberately left-open question, and list them as dropped for that reason.
- Downgrade or upgrade the label when it is wrong, e.g. a "missing limit" that is a sentence lost in an edit is WORDING.
- Keep the rest, noting briefly why each holds.

## 4. Act

On the user's own document:

- **WORDING:** fix directly, in the smallest edits that resolve the finding.
- **DESIGN:** bring to the user with a recommendation for each: a new risk, an open question, a goal or scope change, or a decision record. Never change what the document promises without the user's agreement.

On anyone else's document: change nothing. Report the findings, grouped by label, in a form the user can pass on.

## 5. Report

Tell the user, briefly:

- what was fixed (WORDING)
- what was dropped and why
- what needs a decision (DESIGN), each with the recommendation

Offer to re-run the review after a substantial revision.

## Check lists

### Design

1. Claims with no source, or whose source does not support them.
2. Goals that no option comparison or part of the approach addresses, or that the approach claims to meet but does not.
3. Options without a clear recommendation, or a recommendation the evidence does not support.
4. Open questions never referenced in the body, and references to open questions or decision records that do not exist.
5. Decision records whose decision or alternatives contradict the current text.
6. Text written as history (dates of events, "after N attempts", progress narration) instead of the current design.
7. Names specific to this team or system that the document doesn't explain. Terms common across the organization need no definition.
8. Risks that are routine failure modes rather than threats that could sink the design, and design-level threats the risks miss.

### Spec

1. Acceptance criteria that name no goal, and goals with no acceptance criterion.
2. Acceptance criteria that no task covers, and tasks that cover none.
3. Acceptance criteria or task acceptance that cannot be tested as written.
4. Dependencies that are missing, circular, or contradicted by the task order.
5. File paths, APIs or behaviors stated as fact with no sign they were verified.
6. Scope in the PLAN that the REQ lists as a non-goal, and REQ scope the PLAN omits.
7. Contradictions with the design document or its decision records, where the spec links one.

### Investigation

1. Conclusions the evidence does not support, or that stronger evidence in the document contradicts.
2. Measurements without method: no query, window, filter or unit, so they cannot be reproduced.
3. Comparisons that mix incompatible measures (different windows, populations, percentiles, or units).
4. Plan steps that do not follow from the evidence, or that lack a validation check.
5. Claims with no source, and scope the evidence does not cover.
6. Names specific to this team or system that the document doesn't explain. Terms common across the organization need no definition.

### General

1. Claims with no source, or whose source does not support them.
2. Internal contradictions between sections.
3. Missing context a reader from another team would need, and names specific to this team or system that the document doesn't explain.
4. Sections whose content does not match their heading.
5. Text written as history instead of the current state.
