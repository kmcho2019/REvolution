#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

method=qwen_canonical_rtl_pca3_eoh_8x5

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$(log_file vllm_models.json)"

rm -f "$(log_file "$method.done")" "$(log_file "$method.failed")"

echo "[$(date -Is)] starting $method on gpu $QWEN_CUDA_VISIBLE_DEVICES"
set +e
bash "$(method_script "$method")" > "$(log_file "$method.log")" 2>&1
status=$?
set -e

if [ "$status" -eq 0 ]; then
  touch "$(log_file "$method.done")"
  echo "[$(date -Is)] completed $method"
else
  printf '%s\n' "$status" > "$(log_file "$method.failed")"
  echo "[$(date -Is)] failed $method with status $status"
  exit "$status"
fi
