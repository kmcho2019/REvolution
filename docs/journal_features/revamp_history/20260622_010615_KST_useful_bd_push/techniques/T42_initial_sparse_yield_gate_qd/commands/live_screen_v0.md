# T42 Live Screen V0 Commands

Run preflight first:

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t42_initial_sparse_yield_gate_qd_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

Shared environment and arguments:

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

Matched classic control:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/classic_revolution/seed_1001"
```

Initial sparse-yield gate:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_grid_quantile_adaptive_warmup_successes 4 \
  --qd_grid_quantile_adaptive_warmup_generation 0 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_descriptor_profile journal_graph_testability_3d \
  --qd_descriptor_file data/configs/qd_descriptor_profiles.yaml \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/initial_sparse_yield_gate_qd/seed_1001"
```

Validate after completion:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T42_initial_sparse_yield_gate_qd/tables/live_screen_v0_subset.yaml \
  --classic-mode classic_revolution \
  --pareto-qd-mode initial_sparse_yield_gate_qd \
  --require-full-subset
```

Package direct PPA-front figures and the HTML viewer:

```bash
uv run python scripts/package_t42_initial_sparse_yield_gate.py \
  --t42-run-root "${RUN_ROOT}" \
  --t41-run-root exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_20260622_083629_UTC \
  --t40-run-root exp/useful_bd_push/t40_sparse_warmup_control_matrix_20260622_070540_UTC \
  --t39-run-root exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T42_initial_sparse_yield_gate_qd
```

The primary generated figure is
`figures/t42_raw_area_power_fronts.png`. It must be inspected before the run
is interpreted. Use raw area on x, raw power on y, no inverted axes, and
lower-left as better.

The T42 report should compare against the matched T42 classic arm, T41
adaptive gate, frozen T40 manual/random/full-Pareto controls, and the frozen
T39 one-slot reference.
