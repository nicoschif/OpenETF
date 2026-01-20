# TODO

Canonical work queue and durable record for this repo.

## Tasks

- T1 [NEW] Bootstrap repo workflow (AGENTS.md + TODO.md + baseline validation commands)
  Q1 [OPEN] What is the minimum “Definition of Done” validation for this repo (e.g., `pnpm lint && pnpm test`, `pytest`, `make check`)?
  Q2 [OPEN] What runtime(s) must be supported (node/python/both), and what is the package manager (pnpm/npm/yarn/uv/poetry)?

  Notes:
  - Goal: establish the smallest repeatable loop for changes + evidence capture.
  - No code changes until task is moved to [READY].

- T2 [NEW] Add repo-specific guidance entrypoint
  Q1 [OPEN] Do you want a single `PROJECT.md` at repo root, or a `spec/README.md` folder index (or both)?

- T3 [NEW] Establish example data locations (authoritative shapes)
  Q1 [OPEN] Should example payloads live under `examples/data/` or `data/examples/`?
  Q2 [OPEN] Which resources need examples first (DB rows, API payloads, config objects)?

---

## Parking lot

- T90 [NEW] Backlog / ideas (keep short, convert into real tasks when ready)
