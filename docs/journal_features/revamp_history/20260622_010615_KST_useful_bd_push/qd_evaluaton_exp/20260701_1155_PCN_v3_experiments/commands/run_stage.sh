#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

curl -sS --max-time 20 "http://$VLLM_HOST:$VLLM_PORT/v1/models" \
  > "$(log_file vllm_models.json)"

for seed in "${ACTIVE_SEEDS[@]}"; do
  for method in "${ACTIVE_METHODS[@]}"; do
    done_file="$(log_file "seed_${seed}.${method}.done")"
    failed_file="$(log_file "seed_${seed}.${method}.failed")"
    rm -f "$done_file" "$failed_file"
    script="$(method_script "$method")"
    echo "[$(date -Is)] starting seed=$seed method=$method"
    set +e
    SEED="$seed" bash "$script" > "$(log_file "seed_${seed}.${method}.log")" 2>&1
    status=$?
    set -e
    if [ "$status" -eq 0 ]; then
      touch "$done_file"
      echo "[$(date -Is)] completed seed=$seed method=$method"
    else
      printf '%s\n' "$status" > "$failed_file"
      echo "[$(date -Is)] failed seed=$seed method=$method status=$status"
    fi
  done
done

echo "[$(date -Is)] stage launcher finished"
