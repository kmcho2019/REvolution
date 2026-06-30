#!/usr/bin/env bash
set -euo pipefail

stage="${1:-screen}"
export PCN_STAGE="$stage"
source "$(dirname "$0")/env.sh"

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$LOG_ROOT/vllm_models_$PCN_STAGE.json"

case "$PCN_STAGE" in
  smoke_v2)
    stage_methods=("${SMOKE_V2_METHODS[@]}")
    ;;
  smoke_v3)
    stage_methods=("${SMOKE_V3_METHODS[@]}")
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
  METHOD_NAME="$method" bash "$script" > "$LOG_ROOT/$PCN_STAGE.$method.log" 2>&1
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
