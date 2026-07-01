#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

SESSION=pcn_v3_20260701_${EXP_STAGE}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "tmux session already exists: $SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n run \
  "cd /workspace && EXP_STAGE='$EXP_STAGE' bash '$DOC_ROOT/commands/run_stage.sh' 2>&1 | tee '$(log_file run_stage.log)'"

tmux new-window -t "$SESSION" -n package \
  "cd /workspace && EXP_STAGE='$EXP_STAGE' bash '$DOC_ROOT/commands/package_stage.sh' 2>&1 | tee '$(log_file package.log)'"

tmux new-window -t "$SESSION" -n monitor \
  "cd /workspace && watch -n 60 'date; df -h /workspace; ls -1 \"$LOG_ROOT\" | grep \"^$EXP_STAGE\\.\" | tail -50'"

echo "launched tmux session: $SESSION"
echo "attach with: tmux attach -t $SESSION"
