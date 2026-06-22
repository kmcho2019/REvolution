# Screening V0 Commands

These commands are templates. Fill `RUN_TS` at execution time and save the
preflight JSON under the run root and later under `data/`.

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/rtllm_milestone_screen_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM
  --problems Prob045_alu Prob041_traffic_light Prob015_multi_pipe_8bit
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --max_tokens 128000
  --diff_max_tokens 128000
  --population_size 12
  --num_generations 3
  --evaluation_mode strict_ablation
  --temperature 1.0
  --top_p 1.0
  --total_worker_slots 12
  --max_active_problems 3
  --max_workers_per_problem 4
  --seed 1001
  --no-backend_subdir
)
```

Classic screening control:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/classic_revolution/seed_1001"
```

Exact T26:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/sr_raw_conservative_exploit_qd/seed_1001"
```

T26.1 low-fusion:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.10 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/sr_raw_conservative_exploit_low_fusion_qd/seed_1001"
```

Gated T26.1 is intentionally omitted until the gate is implemented and tested.
