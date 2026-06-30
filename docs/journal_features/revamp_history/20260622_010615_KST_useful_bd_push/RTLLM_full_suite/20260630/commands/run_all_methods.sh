#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$(log_file vllm_models.json)"

for method in "${METHODS[@]}"; do
  rm -f "$(log_file "$method.done")" "$(log_file "$method.failed")"
  script="$(method_script "$method")"
  echo "[$(date -Is)] starting $method"
  set +e
  bash "$script" > "$(log_file "$method.log")" 2>&1
  status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    touch "$(log_file "$method.done")"
    echo "[$(date -Is)] completed $method"
  else
    printf '%s\n' "$status" > "$(log_file "$method.failed")"
    echo "[$(date -Is)] failed $method with status $status"
  fi
done

echo "[$(date -Is)] method launcher finished"
