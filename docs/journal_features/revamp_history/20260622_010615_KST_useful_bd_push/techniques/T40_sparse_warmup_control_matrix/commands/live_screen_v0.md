# T40 Live Screen V0 Commands

Run preflight first:

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t40_sparse_warmup_control_matrix_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

Shared environment and common arguments:

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

QD_COMMON_ARGS=(
  --search_mode revolution_qd
  --qd_archive_type grid_quantile
  --qd_grid_quantile_warmup_successes 4
  --qd_fill_target_fraction 0.25
  --qd_improve_backfill_fraction 0.20
  --qd_objectives ppa
  --qd_champion_lane_fraction 0.80
  --qd_parent_selection nsga2_global_rank
  --qd_two_parent_probability 0.00
  --qd_operator_kind eoh_strategies
  --representation_kind code_individual
)
```

Classic reference:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/classic_revolution/seed_1001"
```

Manual-BD sparse-warmup control:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  "${QD_COMMON_ARGS[@]}" \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --save_path "${RUN_ROOT}/manual_sparse_pareto_qd/seed_1001"
```

Random-descriptor one-slot control:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  "${QD_COMMON_ARGS[@]}" \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_descriptor_profile random_hash_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/random_sparse_elite_slot_qd/seed_1001"
```

Graph-descriptor full local-Pareto control:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  "${QD_COMMON_ARGS[@]}" \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_descriptor_profile journal_graph_testability_3d \
  --qd_descriptor_file data/configs/qd_descriptor_profiles.yaml \
  --save_path "${RUN_ROOT}/graph_full_pareto_sparse_qd/seed_1001"
```

Validate each QD arm after completion:

```bash
for mode in \
  manual_sparse_pareto_qd \
  random_sparse_elite_slot_qd \
  graph_full_pareto_sparse_qd
do
  uv run python scripts/validate_pareto_front_run.py \
    --run-root "${RUN_ROOT}" \
    --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T40_sparse_warmup_control_matrix/tables/live_screen_v0_subset.yaml \
    --classic-mode classic_revolution \
    --pareto-qd-mode "${mode}" \
    --require-full-subset
done
```

The T39 candidate arm is the frozen reference run:

```text
exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b/
```

Before assigning a tier, package T39 and all completed controls into a direct
raw PPA Pareto comparison. The primary figure must use area on x, power on y,
no inverted axes, and lower-left marked as better. Archive-space or
descriptor-space visualizations are supporting evidence only.
