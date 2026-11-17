---
name: tech-spec
description: Turn a Ready design into an implementation spec, one document with an Objective (context, flows, out of scope), Requirements (numbered, testable statements) and a Plan (tasks that each cover requirements, with files, checks and status), traceable end to end and checked by an independent review. Use after tech-design, or when the approach is already settled and the user wants a detailed spec or task breakdown for building it. Keep the Plan's task status current as work lands. Not for choosing between approaches (use tech-design).
---

# Implementation spec

Produce one document in three parts: the **Objective** says what this spec covers, **Requirements** say what must be true when the work is done, and the **Plan** says how it gets built, task by task. Every requirement traces to a goal, and every task covers at least one requirement.

The spec adds detail to the design; it does not repeat it. Cite the design's goals, decisions and open questions by ID (G1, D1, Q1), and its sections by name, instead of restating them, so each fact lives in one place.

## Inputs

A design with status Ready (usually from `tech-design`), or an approach the user states as settled. If the design is still Draft, or key decisions are open, say which ones and suggest resolving them in the design first. Do not decide them silently in the spec.

## Document shape

1. **Title:** `[Spec] <topic>`, using the design's topic, e.g. "[Spec] Service catalog CI trigger". Below the header line, a block quote links the design and any other related document, one per paragraph:

   ```
   > **Design:** [[Design] Service catalog CI trigger](<url>)
   ```

   Add the spec's link to the design's block quote too.
2. **Header line:** author, created date, status. Status is one of:
   - **Draft:** being written. Do not build from a Draft spec.
   - **In progress:** the user has confirmed the Objective and Requirements, the review is done, and building has started. Task statuses track the detail.
   - **Done:** every task is DONE, or dropped with a reason.

   Change the status only when the user says so.

### Objective

3. **Context:** a sentence or two on which part of the design this spec implements and which decisions, plus any scope decisions the user made for the spec that the design doesn't record. With no design document, state what is being built and why here.
4. **Flows:** the target flows this work enables, as sequence diagrams when more than two components interact. Mark what is in scope versus shown for context. Name the requirements each flow covers.
5. **Out of scope:** work within the design's scope, or that a reader would expect here, that this spec leaves out, and where it is tracked (an open question, a later spec). Do not list options the design already rejected.

With no design document, add a numbered **Goals** subsection to the Objective, in the design's format.

### Requirements

6. Requirements, numbered R1, R2, …, each with an **Implements** sub-bullet naming the design goal it serves and the decisions it carries out:

   ```
   - **R4:** <the requirement>
     - **Implements:** G2, D3
   ```

   Group them under bold labels by component, in the order of the design's Approach, when there are more than a handful. Each is a concrete, testable statement: exact shapes, field names, error behavior, and what must never happen (e.g. no plaintext in logs).

### Plan

7. The Plan opens with which repository and root the file paths are relative to, and which tasks can proceed in parallel, noting where they change the same files. Do not restate what the **Depends on** lines already say. Then one section per task, in a valid dependency order, headed with its ID and title, e.g. `### T3: Hide catalogs on off-boarding`. Each section has:
    - **Status:** one of ⚪ TODO, 🟢 IN PROGRESS, 🔵 DONE, 🔴 BLOCKED. The emoji give the status a colour, since document tools rarely keep coloured text.
    - **Description:** what changes and the constraints on it, specific enough to implement without rereading the design. Name the existing code it reuses, and any implementation choice it makes with its tradeoff (e.g. a column versus a table). Cite the design decision it carries out (D3) rather than restating it.
    - **Covers:** the requirements it satisfies.
    - **Depends on:** the tasks, or open questions, that must land first; "none" if nothing.
    - **Files:** the paths it touches, verified in the repository, and the build or check command that verifies it. Mark new paths NEW and unverified ones inferred.
    - **Acceptance:** what is observably true when the task is done.
    - **Tests:** the tests it adds or changes, and what each one proves.
    - **PRs:** links as they open. A task is one PR unless its description says otherwise; say so too for a task that needs no PR, and for any gate a PR must pass before it merges. Merge order follows **Depends on**.

    Once a task is DONE, its section needs only Status, Description, Covers, Depends on and PRs.

## Workflow

1. Read the design, its ADRs and open questions. Confirm with the user which design and scope the spec implements.
2. Read the code that will change: call sites, tests, configs and deployment files. Verify every path and API named in the Plan. When an API detail can only be confirmed at implementation time, say so in the task.
3. List the choices the design leaves open. One that changes what the system does or promises (who may onboard, what an alert counts) is a design decision: propose it to the user and record it as a new D in the design before relying on it. One that only shapes the code belongs in its task's Description.
4. Write the header, Objective and Requirements, with a one-line placeholder for the Plan. Confirm the requirements and what is out of scope with the user before writing the Plan.
5. Write the Plan.
6. Run `doc-review` with type **spec** before the user relies on the spec, and again after any substantial revision.
7. Publish to the user's document tool if one is connected and the user wants it there; otherwise return Markdown. Do not invent a destination.

## Keeping the spec current

- As tasks land, update their Status and add PR links to their sections. The Status lines are the progress tracker; do not append progress notes.
- When implementation reveals a needed change, update the affected task and its requirements. If it changes the design itself, record an ADR in the design doc first.
- When a task splits, give the new tasks new IDs and keep the old ID's coverage accounted for.

## Writing rules

- Use exact identifiers: file paths, types, method names, config keys, commands.
- Prefer short paragraphs to one dense block; each task section should be readable on its own.
- No generic praise, scene-setting, or AI attribution.
