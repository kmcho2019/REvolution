#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

SESSION=rtllm_full_suite_20260630_qwen_${RUN_STAGE}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "tmux session already exists: $SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n qwen \
  "cd /workspace && RUN_STAGE='$RUN_STAGE' QWEN_CUDA_VISIBLE_DEVICES='$QWEN_CUDA_VISIBLE_DEVICES' bash '$DOC_ROOT/commands/run_qwen_gpu0_addon.sh' 2>&1 | tee '$(log_file qwen_gpu0_addon.log)'"

tmux new-window -t "$SESSION" -n package \
  "cd /workspace && RUN_STAGE='$RUN_STAGE' bash '$DOC_ROOT/commands/package_full_suite.sh' 2>&1 | tee -a '$(log_file package.log)'"

tmux new-window -t "$SESSION" -n monitor \
  "cd /workspace && watch -n 60 'date; nvidia-smi --query-gpu=index,memory.used,memory.free,utilization.gpu --format=csv,noheader,nounits; df -h /workspace; ls -1 \"$LOG_ROOT\" | grep \"^$RUN_STAGE\\.\" | tail -40'"

echo "launched tmux session: $SESSION"
echo "attach with: tmux attach -t $SESSION"
