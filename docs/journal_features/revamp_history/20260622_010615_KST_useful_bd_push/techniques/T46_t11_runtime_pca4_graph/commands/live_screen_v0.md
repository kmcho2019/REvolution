# T46 Live Screen V0 Commands

Run preflight first:

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t46_t11_runtime_pca4_graph_${RUN_TS}"
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

T46 frozen T11 PCA graph QD:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_descriptor_profile t11_runtime_pca4_graph \
  --qd_descriptor_file data/configs/qd_descriptor_profiles.yaml \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/t11_runtime_pca4_graph_qd/seed_1001"
```

Validate after completion:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml \
  --classic-mode classic_revolution \
  --pareto-qd-mode t11_runtime_pca4_graph_qd \
  --require-full-subset
```

Package direct PPA-front figures and the reader-facing HTML supplement:

```bash
uv run python scripts/package_t46_t11_runtime_pca4_graph.py \
  --t46-run-root "${RUN_ROOT}" \
  --t45-run-root exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC \
  --t44-run-root exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC \
  --t39-run-root exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph
```

Build the full Phase 03.1-compatible viewer source:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic="${RUN_ROOT}/classic_revolution/seed_1001" \
  --backend_run t11_runtime_pca4_graph_qd="${RUN_ROOT}/t11_runtime_pca4_graph_qd/seed_1001" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml \
  --output-dir "${RUN_ROOT}/qd_ppa_viewer_source/final_analysis"
```

Copy the source bundle into the technique package:

```bash
VIEWER_SOURCE="docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer_source"
mkdir -p "${VIEWER_SOURCE}"
cp -R "${RUN_ROOT}/qd_ppa_viewer_source/final_analysis" "${VIEWER_SOURCE}/"
```

Export and validate the full viewer:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer_source \
  --backend_run classic="${RUN_ROOT}/classic_revolution/seed_1001" \
  --backend_run t11_runtime_pca4_graph_qd="${RUN_ROOT}/t11_runtime_pca4_graph_qd/seed_1001" \
  --archive_source_backend t11_runtime_pca4_graph_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer \
  --strict

uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml \
  --strict \
  --playwright
```

Keep `visualizations/qd_ppa_viewer/validation.json`, inspect Playwright
screenshots, and copy one compact inspected screenshot to
`visualizations/qd_ppa_viewer/screenshot.png`. Also capture and inspect
`visualizations/direct_ppa_pareto/screenshot.png`.
