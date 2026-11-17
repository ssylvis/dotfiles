---
name: tech-design
description: Write or revise a technical design proposal in two passes (first the objective, goals and current state; then the options considered, the approach, risks and open questions), recording settled decisions as ADRs and checking the draft with an independent review. Use when the user wants to decide how to build or change a system, compare approaches, or write or update a design doc or RFC. Hand off to tech-spec once the design is Ready. Not for investigations whose answer comes from measurement or analysis (use investigate), and not for small changes that need no written decision.
---

# Technical design proposal

Produce a document that lets its readers agree on what to build and why. It decides the approach; detailed requirements and tasks belong in `tech-spec`.

## Document shape

Numbered items use a one-letter ID with no hyphen: goals G1, open questions Q1, decisions D1. A spec built from the design continues the scheme with requirements R1 and tasks T1.

1. **Title:** `[Design] <topic>`, e.g. "[Design] Service catalog CI trigger". Below the header line, a block quote links each related document as it comes to exist: the spec, a parent doc, a design this one replaces or that replaces it. One link per paragraph:

   ```
   > **Spec:** [[Spec] Service catalog CI trigger](<url>)
   >
   > **Parent:** [<title>](<url>)
   ```
2. **Header line:** author, created date, status. Status is one of:
   - **Draft:** being framed or decided in passes 1 and 2.
   - **Ready:** the user has said the approach is decided, and no open question blocks building it. If one does, point it out before changing the status. Then suggest `tech-spec`, and add the spec's link once it exists.
   - **Superseded:** replaced by a later design, linked from the block quote (`> **Superseded by:** …`).

   Change the status only when the user says so.
3. **Objective:** what is manual, broken or missing today, what this design sets out to achieve, and why it matters now. Define the system's names and terms in the first sentences so a reader from outside the team can follow.
   - **Goals and constraints** (subsection): a bulleted list with IDs G1, G2, …, each a bold ID and label plus one sentence, e.g. "- **G3. Non-blocking:** a failed call never fails the service's CI." These are the criteria options are judged against, not the detailed requirements a spec adds. Refer to them by ID ("G3").
4. **Current state:** the existing system, platform behavior and precedents the design can rely on, each stated as fact with its source. Mark anything inferred rather than verified.
5. **Options considered:** each with a short name, a one-sentence description, and bullets for the tradeoffs that matter here (change required, latency, cost, effort, drawbacks), judged against the goals by ID. Exactly one option is recommended; a phased answer (one for a prototype, another after) is fine when stated. Rejected options say why in one line.
6. **Approach:** the recommended option at the level needed to agree on it: components, the main flow, and interfaces or contracts only where they decide something. Leave field-level detail and task breakdown to `tech-spec`.
7. **Risks:** only the few that could sink the design: an assumption that might prove false, a dependency or owner that might not come through, a cost or scale limit that might not hold. Each states what would go wrong for the design as a whole and how it is mitigated or detected early. Ordinary failure modes the Approach already handles (retries, caps, non-fatal calls) belong in the Approach; implementation-level hazards belong in `tech-spec`.
8. **Open questions:** a bulleted list with IDs Q1, Q2, …, each saying what it blocks, e.g. "- **Q3:** …". Body text cross-references them by ID ("see Q3").
9. **Decisions:** ADRs with IDs D1, D2, …, newest last (format below). Open the section with one line saying so, since D is less familiar than ADR.
10. **Sources:** the code, PRs, threads and docs the evidence came from.

### ADR format

Each element on its own line, separated by blank lines:

```
#### D3: <decision in a few words>

**Context:** the forces and constraints, citing the goals and open questions it resolves.

**Decision:** what was chosen, in one or two sentences.

**Alternatives:** each alternative considered and why it was rejected.

**Consequences:** what follows, good and bad, including new risks or work.
```

An ADR records a decision once it is made, usually by answering an open question or choosing an option; a decision still being weighed is an open question, not an ADR. ADRs are not edited in substance: to change a decision, add a new ADR and add "**Superseded by D5.**" as the first line of the old one. The rest of the document always describes the current design.

## Workflow

### Pass 1: Frame

1. Establish the audience, the decision to be made and any known constraints. Ask one concise question only when a missing answer would change the framing.
2. Gather evidence for the current state before writing: read the relevant code, configs, PRs, docs, metrics and threads. Record each fact with its source and whether it was verified (read in code, tested, measured) or inferred. Prefer testing an assumption cheaply, such as a probe request or a query, over asserting it.
3. Write the header, Objective with its goals and constraints, and Current state, with the remaining headings as one-line placeholders.
4. Stop and confirm the framing with the user: is this the right objective, are the goals right, is anything missing from the current state.

### Pass 2: Decide

5. Develop the options considered, judged against the goals. Recommend one.
6. Write the Approach for the recommended option, then Risks and Open questions.
7. Discuss with the user. As decisions settle, add ADRs and update the affected sections.

### Independent review

8. Run `doc-review` with type **design** before the user shares the draft, and again after any substantial revision.

Publish to the user's document tool if one is connected and the user wants it there; otherwise return Markdown. Do not invent a destination.

## Writing rules

- Lead every section with its conclusion. Keep claims next to their evidence.
- Use specific nouns and exact identifiers: file paths, endpoint names, config keys, PR numbers with their repository.
- Estimates are measured where possible, stated as ranges, and use straight-line formulas (fixed part + rate × size), never invented precision.
- Tables only for real comparisons (options, test results, measurements). Diagrams only when a flow or topology is hard to follow in prose.
- No generic praise, scene-setting, or AI attribution.

## Keeping the document current

The document is a snapshot of the current design, not a record of how it was reached; ADRs hold the decision trail.

- When a finding changes the design, edit the affected text, and add a risk, open question or ADR as needed. Do not add dated narrative, event counts or "update:" paragraphs; keep that evidence in chat or the linked thread.
- When an open question is answered, record a decision, delete the question, and point every reference to it at the new decision. Do not renumber the remaining questions or reuse the ID, so existing references stay valid.
