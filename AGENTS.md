<!--
  AUTO-SYNCED FILE — DO NOT EDIT HERE

  Source of truth:
  https://github.com/FastCatalog-ai/engineering-handbook/blob/main/agents.md

  This file is automatically updated across repos.
  Make changes only in the engineering-handbook version.
-->


# AGENTS.md

## Summary

- Canonical work queue + durable record: `./TODO.md` (repo root).
- Canonical process + conventions: `./AGENTS.md`.
- Workflow phases: Clarify/Design → Plan (`P*`) → Approval gate → Implement → Report (`R*`).
- Labels: `Q*` questions, `A*` assumptions/answers, `P*` plans, `R*` reports, `U*` data updates.
- Keep changes minimal and localized; avoid opportunistic refactors.
- **No silent fallbacks**: never hide incorrectness. (This does not forbid reasonable explicit decisions.)
- **Fail fast on contract/schema violations**: do not continue execution with placeholder/scaffold values.
- **It’s OK to be opinionated:** when multiple reasonable options exist (e.g., tech stack), pick the best default and present it as the intended approach with rationale, evidence, and `A* [PROPOSED]` assumptions.
- **Do not mark tasks `[DONE]` by default.** A task may be set to `[DONE]` only when:
  - the user explicitly confirms it’s done, OR
  - the task has explicit DONE criteria the agent can verify are met (e.g., required `Validation:` commands) and evidence is recorded.
  Otherwise, use `[WAITING]` (acceptance/input) or `[BLOCKED]` (cannot proceed).
- **Monthly change log:** every task moved to `[DONE]` must have a corresponding entry in `./docs/change_logs/change_log_YYYYMM.md` (see §9.3).

---

## 1. Task System

### 1.1 Canonical files

- Work queue / durable record: `./TODO.md`
- Process + conventions: `./AGENTS.md`
- Monthly change log (append-only): `./docs/change_logs/change_log_YYYYMM.md`
- Do not maintain a separate task queue elsewhere.

### 1.2 Task format (in TODO.md)

Each task is a single line:

- `- T# [STATE] <one-line objective>`

(There is no leading checkbox.)

### 1.3 Execution order and task selection

- Execution order is numeric order in `TODO.md`.
- Pick work in this order:
  1) lowest-numbered `[READY]`
  2) else lowest-numbered `[NEW]`
  3) else stop and report: “No READY/NEW tasks.”

### 1.4 Dialog context

- Start each message with: `T#`
- Include `[STATE]` only when you changed it (or are about to change it).
- Include the one-line objective only when needed for clarity (e.g., first message on that task).

---

## 2. States, Ownership, and Gates

### 2.1 States

Use exactly one state per task:

- `[NEW]` underspecified; needs clarification/design (no plan yet).
- `[READY]` sufficiently specified to write a plan and request approval.
- `[APPROVED]` plan is approved; implementation may proceed.
- `[WAITING]` agent has completed everything it can; awaiting user acceptance/confirmation or other user input to close.
- `[BLOCKED]` cannot proceed due to missing info/env/dependency (agent cannot make progress).
- `[DONE]` closed (only with explicit user acceptance or verified DONE criteria).

### 2.2 Ownership

- **User owns:** creating/editing task objectives, answering `Q*`, approving/rejecting plans (`P*`), and confirming completion when DONE criteria are not machine-verifiable.
- **Agent owns:** ALL task state transitions in `TODO.md` and all recordkeeping.

**Rule:** never ask the user to “move T# to [READY]/[APPROVED]/[DONE].” The agent updates task state in `TODO.md`.

### 2.3 Readiness (NEW → READY)

Promote a task to `[READY]` when:
- objective is clear and bounded,
- unknowns are resolved (Q answered) **OR explicitly captured as `A* [PROPOSED]` when they are engineering choices with low downside to propose** (e.g., stack/library selection), **without guessing core product behavior**,
- you can list files and write a concrete plan.

When promoting to READY, add under the task in TODO.md:
- `Ready rationale:` (1–3 bullets)

### 2.4 Plan gating (strict)

- **Do not write a plan (`P*`) unless the task is `[READY]`.**
- For `[NEW]` tasks:
  - do discovery/clarification only (`Q*`, and optional `A* [PROPOSED]`),
  - then either promote to `[READY]` (if criteria met) or move to `[BLOCKED]`.

### 2.5 Approval gate (repo changes are blocked)

- For `[READY]` tasks:
  - write `P* [DRAFT]` in TODO.md (include files + any `U*` data updates),
  - then stop: **no code/doc/schema changes** until plan approval.
- **Important:** The approval gate blocks *modifying the repo*, not *explaining*, *analyzing*, or *designing*.  
  You may always provide explanations, tradeoffs, and design proposals when asked.
- If the user approves the plan:
  - update to `P* [APPROVED YYYY-MM-DD]`,
  - move task state to `[APPROVED]`.
- If the user rejects the plan:
  - record notes,
  - typically move to `[NEW]`.

### 2.6 Allowed transitions (agent-controlled)

- `[NEW] → [READY]` when ready to plan.
- `[NEW] → [BLOCKED]` when missing access/dependency prevents progress.

- `[READY] → [NEW]` if new ambiguity appears.
- `[READY] → [BLOCKED]` if dependency/env blocks planning.
- `[READY] → [APPROVED]` only after user approves plan (`P* [APPROVED ...]` recorded).

- `[APPROVED] → [WAITING]` when implementation/reporting is complete but closure requires user acceptance (or DONE criteria are missing/not verifiable).
- `[APPROVED] → [DONE]` only if DONE criteria are verifiably met (and evidenced), or the user explicitly confirms done (recorded).
- `[APPROVED] → [BLOCKED]` if implementation/validation cannot proceed (record unblock steps).
- `[APPROVED] → [READY]` if plan must change materially (new `P* [DRAFT]`, re-approve).

- `[WAITING] → [DONE]` when the user confirms done OR newly-added/verifiable DONE criteria are met and evidenced.
- `[WAITING] → [NEW]/[READY]` if the user requests changes or new scope (agent re-triages).
- `[WAITING] → [BLOCKED]` if you discover a real blocker preventing completion.

- `[BLOCKED] → [NEW]` if blocker removed but clarifications needed.
- `[BLOCKED] → [READY]` if blocker removed and task is ready to plan.
- `[DONE]` has no transitions.

### 2.7 Consistency rules

- If a task is `[APPROVED]` but no `P* [APPROVED ...]` exists under it in TODO.md:
  - move back to `[READY]`, repair plan record, request approval.
- If a task is marked `[DONE]` but there is no recorded user acceptance AND no explicit verified DONE criteria/evidence:
  - treat as inconsistent → move to `[WAITING]` and record what’s needed to close.

---

## 3. Collaboration Artifacts (live in TODO.md)

For each task, keep artifacts inside that task block in `TODO.md`:

- `Q*` questions (with status)
- `A*` assumptions/answers (with status)
- `P*` plan steps (with status + file list)
- `R*` report items (final outcomes)
- `Evidence:` commands + exit codes + brief output summary (or artifact/log path)
- `Files changed:` list of paths
- Optional `Validation:` commands
- Optional `DONE criteria:` (if non-command-based but still verifiable)
- Optional `Acceptance:` (user confirmation with date)
- `Changelog:` path to monthly entry (required when transitioning to `[DONE]`)

### 3.1 Status conventions (required)

Questions:
- `Q# [OPEN] ...`
- `Q# [ANSWERED YYYY-MM-DD] ...`
  - indented: `A#: <answer>`
- `Q# [DROPPED YYYY-MM-DD] ...` (reason)

Assumptions:
- `A# [PROPOSED] ...`
- `A# [CONFIRMED YYYY-MM-DD] ...`
- `A# [REJECTED YYYY-MM-DD] ...`

Plans:
- `P# [DRAFT] ...`
- `P# [APPROVED YYYY-MM-DD] ...`
- `P# [SUPERSEDED YYYY-MM-DD] ...` (link to replacement `P#`)

Reports:
- `R# ...` (final)

### 3.2 Mirroring

- Decisions made in chat/CLI must be mirrored into TODO.md with statuses + dates.
- If chat/CLI and TODO.md disagree, ask which is authoritative, then update TODO.md.

---

## 4. Discovery & Design (clarify only when needed)

### 4.1 Asking questions vs making decisions

- Ask targeted `Q*` **only when ambiguity affects correctness, requirements, or user-visible behavior**.
- Do **not** bounce normal engineering judgement back to the user.
- Prefer **proposal-first**: propose a concrete default as `A* [PROPOSED]` and/or a plan step, include short rationale/evidence, and ask for **confirm/veto**.
- If the user explicitly asks you to explain something or propose a design:
  - provide a direct explanation/design,
  - include a recommended approach,
  - ask only the minimum questions needed to avoid implementing the wrong thing.

### 4.2 When you must stop, say why (and what unblocks)

If you stop due to a guardrail (approval gate, unknown schema, unclear requirements, etc.):
- say which rule is triggering the stop (one line),
- state exactly what input/decision would unblock you.

---

## 5. Repo Knowledge & Schemas (authoritative shapes, fail fast)

### 5.1 READMEs and specs

- Check:
  - root `README.md`,
  - referenced specs,
  - relevant folder `README.md`.
- If introducing new patterns/structure:
  - propose doc updates and ask before treating them as canonical.

### 5.2 Example data and authoritative shapes

For complex objects (DB records, API payloads, configs):
- inspect `examples/data` or `data/examples` if present,
- treat documented examples/schemas as authoritative.

Rules:
- No “handle anything” logic that lets execution continue in an invalid state.
- **If a field is required for identity/correctness** (IDs, routing keys, join keys, persistence keys, invariants):
  - missing/wrong-type/invalid value is a **hard error** (raise with context).
  - do not fabricate substitute values (e.g., `"missing_x(asset_id=...)"`) to continue.
- If shapes don’t match:
  - fail fast (explicit error) or ask a `Q*` before implementing a behavior change.

### 5.3 Unknown libraries / private APIs (design allowed, guessing in code not allowed)

- For implementation: do **not** guess interface shapes/fields. Ask for I/O schema or find in-repo examples.
- For explanation/design: you may propose likely patterns and a candidate schema, but:
  - label it as `A* [PROPOSED]`,
  - do not encode guessed field names/contracts into code until confirmed.

---

## 6. Data & Persistence (explicit, minimal, verifiable)

### 6.1 Enumerate data updates (U-labels)

If code inserts/updates data:
- list each logical write as `U*` in the plan:
  - target store,
  - object key/ID,
  - exact fields written/updated.

### 6.2 Upsert strategy

- Prefer partial updates over full replacements.
- Full replacement only for:
  - new records, or
  - structural changes requiring replacement.
- Never describe mutations vaguely—list fields.

### 6.3 Time and time zones

- Timestamps must be timezone-aware.
- Backend: UTC.
- Frontend: user timezone.
- No silent conversions.

---

## 7. Code Design & Modification

### 7.1 Respect existing conventions

- Reuse existing naming, layering, patterns, error/logging style.
- If introducing a new pattern (no precedent in repo):
  - call it out and ask before proceeding.
- If given a user snippet:
  - assume it’s intentional; don’t rewrite/remove “weird” parts without asking.
- If instructions conflict with existing code:
  - ask which is source of truth.

### 7.2 Minimal, localized changes

- Minimal viable change only.
- Avoid opportunistic refactors.
- Prefer localized edits over rewriting entire files unless the plan calls for it.

### 7.3 Function granularity

- Avoid “function slicing” into tiny helpers.
- Create helpers only when reused, conceptually meaningful, or needed for clarity.

### 7.4 Fail fast; no correctness fallbacks

Goal: prevent code from continuing in a quietly-wrong state.  
**Observability is not a substitute for correctness.**

Default behavior on contract/schema violations:
- raise an explicit error (with context) and stop execution for that path.

Allowed (good):
- fail fast with explicit exceptions,
- explicit validation with clear error messages,
- logging/metrics **in addition to** failing (optional).

Not allowed (bad):
- swallowing errors,
- silently substituting defaults,
- **synthesizing substitute identifiers/labels to keep execution going** (e.g., `"missing_internal_portal_id (...)"`),
- “best-effort” behavior that preserves control flow when required invariants are violated.

If “degrade gracefully” behavior is truly desired:
- it must be an explicit product requirement,
- it must be unambiguous and observable,
- it must be proposed in the plan and approved before implementation.

---

## 8. Project Structure & UI Guardrails

### 8.1 Group by functionality

- Keep related UI + helpers + tests together.
- Follow existing directory/file naming patterns.

### 8.2 Shared components

- Before modifying a shared component:
  - identify consumers and impacts.
- If consumers need different behavior:
  - prefer a dedicated component over complex conditionals.

### 8.3 “Same UI” assumptions

- Treat “same UI / similar behavior” as guidance.
- Clarify whether to reuse, clone-and-adjust, or implement new.
- Don’t silently couple components based on appearance.

---

## 9. Evidence and Completion

### 9.1 Recording verifiable DONE criteria

Preferred: define DONE criteria as commands under `Validation:` (or in the approved plan).  
When run, record each in `Evidence:` with:
- command,
- exit code,
- brief output summary (or artifact/log path).

### 9.2 When to move to DONE vs WAITING vs BLOCKED

Move a task to `[DONE]` only when:
1) at least one of the completion conditions below is true, AND
2) the §9.3 changelog entry is written and referenced under the task in TODO.md.

Completion conditions:

1) **User acceptance**:
   - the user explicitly confirms the task is done.
   - record under the task:
     - `Acceptance: user confirmed DONE YYYY-MM-DD`

2) **Verified DONE criteria**:
   - the task has explicit DONE criteria the agent can verify (typically `Validation:` commands),
   - all required criteria succeeded (exit code 0) and are recorded in `Evidence:`.

If implementation/reporting is complete but neither completion condition is true:
- set `[WAITING]` and record exactly what is needed to close (acceptance or DONE criteria).

If required validation cannot be run due to env/dependency issues:
- set `[BLOCKED]` with exact unblock steps.

### 9.3 Change log (required for DONE)

When a task is transitioned to `[DONE]`, append a summary entry to:
- `./docs/change_logs/change_log_YYYYMM.md` where `YYYYMM` is based on the DONE transition date (YYYY-MM-DD → YYYYMM).
- Create `./docs/change_logs/` and the monthly file if they do not exist.

**Append-only rule:** change logs are append-only. Do not edit prior entries. No corrections or retroactive edits.
If a mistake is discovered, capture it as a new task in `TODO.md` (and the fix will be reflected when that new task is `[DONE]`).

Also add under the task in `TODO.md`:
- `Changelog: docs/change_logs/change_log_YYYYMM.md (entry: T# …)`

Entry template (keep it short, but complete):
- `T#` + objective + `DONE date:`
- `Decisions/Assumptions:` relevant `A*` (and any key decision not already captured as `A*` must be added to TODO.md before logging)
- `Implementation:` what changed (or `N/A (no repo changes)`)
- `Files changed:` paths (or `none`)
- `Data updates:` list `U*` (or `none`)
- `Validation:` commands run (or `N/A`)
- `Notes:` breaking changes / follow-ups (optional)

