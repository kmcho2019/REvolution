#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$LOG_ROOT/vllm_models.json"

for method in "${METHODS[@]}"; do
  rm -f "$LOG_ROOT/$method.done" "$LOG_ROOT/$method.failed"
  script="$(method_script "$method")"
  echo "[$(date -Is)] starting $method"
  set +e
  bash "$script" > "$LOG_ROOT/$method.log" 2>&1
  status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    touch "$LOG_ROOT/$method.done"
    echo "[$(date -Is)] completed $method"
  else
    printf '%s\n' "$status" > "$LOG_ROOT/$method.failed"
    echo "[$(date -Is)] failed $method with status $status"
  fi
done

echo "[$(date -Is)] method launcher finished"
