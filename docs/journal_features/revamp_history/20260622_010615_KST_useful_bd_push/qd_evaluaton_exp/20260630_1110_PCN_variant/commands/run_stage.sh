#!/usr/bin/env bash
set -euo pipefail

stage="${1:-screen}"
export PCN_STAGE="$stage"
source "$(dirname "$0")/env.sh"

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$LOG_ROOT/vllm_models_$PCN_STAGE.json"

case "$PCN_STAGE" in
  smoke_credit025)
    stage_methods=("${SMOKE_CREDIT025_METHODS[@]}")
    ;;
  long_20x10)
    stage_methods=("${LONG_20X10_METHODS[@]}")
    ;;
  long_10x20)
    stage_methods=("${LONG_10X20_METHODS[@]}")
    ;;
  *)
    stage_methods=("${METHODS[@]}")
    ;;
esac

for method in "${stage_methods[@]}"; do
  rm -f "$LOG_ROOT/$PCN_STAGE.$method.done" "$LOG_ROOT/$PCN_STAGE.$method.failed"
  script="$(method_script "$method")"
  echo "[$(date -Is)] starting $PCN_STAGE $method"
  set +e
  method_credit="$PCN_MEMORY_MIN_CELL_CREDIT"
  if [[ "$method" == *credit025* ]]; then
    method_credit=0.25
  fi
  METHOD_NAME="$method" PCN_MEMORY_MIN_CELL_CREDIT="$method_credit" bash "$script" > "$LOG_ROOT/$PCN_STAGE.$method.log" 2>&1
  status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    touch "$LOG_ROOT/$PCN_STAGE.$method.done"
    echo "[$(date -Is)] completed $PCN_STAGE $method"
  else
    printf '%s\n' "$status" > "$LOG_ROOT/$PCN_STAGE.$method.failed"
    echo "[$(date -Is)] failed $PCN_STAGE $method with status $status"
  fi
done

echo "[$(date -Is)] stage launcher finished: $PCN_STAGE"
