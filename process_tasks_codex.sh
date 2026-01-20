#!/usr/bin/env bash
set -euo pipefail

# Run from repo root (so AGENTS.md and TODO.md resolve predictably).

# MODEL="gpt-5.2-codex"
MODEL="gpt-5.2"

# minimal|low|medium|high|xhigh
EFFORT="${CODEX_EFFORT:-high}"

PROMPT="$(cat <<'EOF'
Read AGENTS.md and TODO.md (repo root). Follow AGENTS.md exactly. TODO.md is the canonical queue + durable record.

Work selection:
- Pick the lowest-numbered task in [READY]; otherwise the lowest-numbered task in [NEW].

While working:
- Start each message with: T#
- Update TODO.md in-place under the active task with the durable artifacts required by AGENTS.md
  (Q*/A*/P*/R*/U*, Evidence with commands+exit codes, Files changed, and State transitions).
- Respect the approval gate: no code/doc/schema changes until the plan is approved (per AGENTS.md).
EOF
)"

# Pass through any extra Codex flags you want (model, sandbox, approvals, cd, etc.).
# Example: ./process_tasks_codex.sh --model gpt-5-codex --ask-for-approval on-request
codex \
  --model "$MODEL" \
  -c "model_reasoning_effort=$EFFORT" \
  "$@" "$PROMPT"
