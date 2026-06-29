#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

SESSION=rtllm_full_suite_20260629

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "tmux session already exists: $SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n run \
  "cd /workspace && bash '$DOC_ROOT/commands/run_all_methods.sh' 2>&1 | tee '$LOG_ROOT/run_all_methods.log'"

tmux new-window -t "$SESSION" -n package \
  "cd /workspace && bash '$DOC_ROOT/commands/package_full_suite.sh' 2>&1 | tee '$LOG_ROOT/package.log'"

tmux new-window -t "$SESSION" -n monitor \
  "cd /workspace && watch -n 60 'date; df -h /workspace; ls -1 \"$LOG_ROOT\" | tail -40'"

echo "launched tmux session: $SESSION"
echo "attach with: tmux attach -t $SESSION"
