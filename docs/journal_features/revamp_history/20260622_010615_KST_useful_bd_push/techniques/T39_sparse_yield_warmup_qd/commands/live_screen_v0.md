# T39 Live Screen V0 Command

Run preflight first:

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t39_sparse_yield_warmup_qd_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

Shared environment:

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src
```

T39 sparse-yield one-slot arm:

```bash
uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob045_alu Prob041_traffic_light Prob015_multi_pipe_8bit \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 12 \
  --max_active_problems 3 \
  --max_workers_per_problem 4 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_graph_testability_3d \
  --qd_descriptor_file data/configs/qd_descriptor_profiles.yaml \
  --seed 1001 \
  --save_path "${RUN_ROOT}/sparse_warmup_elite_slot_qd/seed_1001" \
  --no-backend_subdir
```

Validate the T39 arm:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T39_sparse_yield_warmup_qd/tables/live_screen_v0_subset.yaml \
  --classic-mode "" \
  --pareto-qd-mode sparse_warmup_elite_slot_qd \
  --require-full-subset
```

Package direct PPA figures after validation:

```bash
uv run python scripts/package_t38_elite_pareto_slot_live.py \
  --run-root "${RUN_ROOT}" \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T39_sparse_yield_warmup_qd \
  --mode-root sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b/RTLLM \
  --file-prefix t39_live \
  --plot-title-prefix "T39 Sparse-Yield Warmup" \
  --viewer-title "T39 Sparse-Yield Direct PPA Fronts"
```
