#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../env.sh"

uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks "$ACTIVE_BENCHMARK" \
  --problems "${ACTIVE_PROBLEMS[@]}" \
  --api_backend vllm \
  --vllm_host "$VLLM_HOST" \
  --vllm_port "$VLLM_PORT" \
  --vllm_min_model_len 128000 \
  --model_name "$MODEL_NAME" \
  --max_tokens "$MAX_TOKENS" \
  --diff_max_tokens "$DIFF_MAX_TOKENS" \
  --population_size "$BUDGET_POPULATION" \
  --num_generations "$BUDGET_GENERATIONS" \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots "$COMMON_TOTAL_WORKER_SLOTS" \
  --max_active_problems "$COMMON_MAX_ACTIVE_PROBLEMS" \
  --max_workers_per_problem "$COMMON_MAX_WORKERS_PER_PROBLEM" \
  --seed "$SEED" \
  --no-backend_subdir \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set one_parent \
  --save_path "$(method_save_path classic_no_cf_8x5 "$SEED")"
