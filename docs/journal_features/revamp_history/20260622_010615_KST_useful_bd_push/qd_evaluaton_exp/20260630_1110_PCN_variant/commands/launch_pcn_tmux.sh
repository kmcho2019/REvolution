#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

SESSION=pcn_variant_20260630_1110
PCN_LAUNCH_STAGE="${PCN_LAUNCH_STAGE:-smoke_v3}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "tmux session already exists: $SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n "$PCN_LAUNCH_STAGE" \
  "cd /workspace && bash '$DOC_ROOT/commands/run_stage.sh' '$PCN_LAUNCH_STAGE' 2>&1 | tee '$LOG_ROOT/$PCN_LAUNCH_STAGE.run_stage.log'"

tmux new-window -t "$SESSION" -n package \
  "cd /workspace && bash '$DOC_ROOT/commands/package_pcn_results.sh' '$PCN_LAUNCH_STAGE' 2>&1 | tee '$LOG_ROOT/$PCN_LAUNCH_STAGE.package.log'"

tmux new-window -t "$SESSION" -n monitor \
  "cd /workspace && watch -n 60 'date; df -h /workspace; ls -1 \"$LOG_ROOT\" | tail -60'"

echo "launched tmux session: $SESSION"
echo "attach with: tmux attach -t $SESSION"
