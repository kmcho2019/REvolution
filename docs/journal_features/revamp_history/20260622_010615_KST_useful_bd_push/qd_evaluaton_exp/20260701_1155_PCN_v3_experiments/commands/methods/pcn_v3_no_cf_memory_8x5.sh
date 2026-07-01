#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../env.sh"

METHOD_NAME=pcn_v3_no_cf_memory_8x5

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
  --search_mode revolution_qd \
  --classic_operator_kind eoh_strategies \
  --eoh_success_operator_set one_parent \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_archive_activation_generation 2 \
  --qd_fill_target_fraction 0.00 \
  --qd_improve_backfill_fraction 0.00 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_scheduler_mode pcn_classic_preserving_memory \
  --qd_parent_selection pcn_classic_preserving_memory \
  --qd_memory_classic_fraction 0.90 \
  --qd_memory_refine_fraction 0.10 \
  --qd_memory_rescue_fraction 0.00 \
  --qd_memory_probe_fraction 0.00 \
  --qd_memory_min_cell_credit "$PCN_MEMORY_MIN_CELL_CREDIT" \
  --qd_memory_front_gap_epsilon 0.03 \
  --qd_memory_min_valid_ppa 8 \
  --qd_memory_trigger stagnation \
  --qd_memory_target_front_size 2 \
  --qd_memory_cooldown_attempts 3 \
  --qd_memory_cooldown_generations 2 \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --repair_kind none \
  --qd_descriptor_axes \
    source_aligned_rf_timing_leaf_ids \
    source_aligned_masterrtl_branching \
    source_aligned_rtltimer_wire_density \
  --save_path "$(method_save_path "$METHOD_NAME" "$SEED")"
