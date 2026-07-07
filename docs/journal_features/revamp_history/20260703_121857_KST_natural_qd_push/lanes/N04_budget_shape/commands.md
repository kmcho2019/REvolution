# N04 Budget Shape Commands

Registered 2026-07-07 before any N04 V2 6x7 result.

Run from `/workspace`.

## Baseline Verification

```bash
PUSH=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push
PKG=$PUSH/lanes/N04_budget_shape
SUBSET=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T79_budget_shape_ablation_protocol/tables/budget_shape_subset.yaml
CLASSIC=exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_6x7/seed_1001

uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_6x7="$CLASSIC" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/baseline_verification/pareto_analysis"

uv run python scripts/report_ppa_distribution.py \
  --backend_run classic_revolution_6x7="$CLASSIC" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/baseline_verification/ppa_distribution"

uv run python scripts/report_hv_auc.py \
  --ppa-candidates "$PKG/baseline_verification/ppa_distribution/data/ppa_candidates.csv" \
  --num-generations 7 \
  --output "$PKG/baseline_verification/hv_auc.csv"

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates "$PKG/baseline_verification/ppa_distribution/data/ppa_candidates.csv" \
  --output "$PKG/baseline_verification/operator_contract.csv"

uv run python scripts/validate_natural_qd_run.py \
  --run-root "$CLASSIC" \
  --manifest "$PUSH/tables/screen_manifest.csv" \
  --arm classic \
  --expect-config search_mode=revolution \
  --expect-config classic_operator_kind=eoh_strategies \
  --expect-config representation_kind=code_individual \
  --expect-config population_size=6 \
  --expect-config num_generations=7 \
  --expect-config evaluation_mode=strict_ablation \
  --expect-config seed=1001 \
  --output "$PKG/baseline_verification/run_validation.json"
```

## V2 6x7 Launch

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/natural_qd_push/n04_budget_shape_${RUN_TS}/live"
mkdir -p "${RUN_ROOT}/preflight" "${RUN_ROOT}/logs"

curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"

export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light \
    Prob045_alu Prob049_signal_generator Prob116_m2014_q3 \
    Prob135_m2014_q6b Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 6 \
  --num_generations 7 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 48 \
  --max_active_problems 8 \
  --max_workers_per_problem 6 \
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --representation_kind code_individual \
  --qd_operator_kind eoh_strategies \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_rebinning_kind ks_triggered \
  --save_path "${RUN_ROOT}/smooth_qd_v2_6x7/seed_1001" \
  > "${RUN_ROOT}/logs/launch_smooth_qd_v2_6x7_seed1001.log" 2>&1
```

## Packaging

```bash
V2="${RUN_ROOT}/smooth_qd_v2_6x7/seed_1001"

uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_6x7="$CLASSIC" \
  --backend_run smooth_qd_v2_6x7="$V2" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/pareto_analysis"

uv run python scripts/report_ppa_distribution.py \
  --backend_run classic_revolution_6x7="$CLASSIC" \
  --backend_run smooth_qd_v2_6x7="$V2" \
  --subset-config "$SUBSET" \
  --output-dir "$PKG/ppa_distribution"

uv run python scripts/report_hv_auc.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --num-generations 7 \
  --output "$PKG/tables/hv_auc.csv"

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
  --output "$PKG/tables/operator_contract.csv"

uv run python scripts/validate_natural_qd_run.py \
  --run-root "$V2" \
  --manifest "$PUSH/tables/screen_manifest.csv" \
  --arm qd \
  --expect-config search_mode=revolution_qd \
  --expect-config qd_operator_kind=eoh_strategies \
  --expect-config representation_kind=code_individual \
  --expect-config population_size=6 \
  --expect-config num_generations=7 \
  --expect-config evaluation_mode=strict_ablation \
  --expect-config seed=1001 \
  --expect-config qd_num_cells=16 \
  --expect-config qd_grid_quantile_warmup_successes=8 \
  --expect-config qd_cell_mode=pareto_front \
  --expect-config qd_max_elites_per_cell=5 \
  --expect-config qd_parent_selection=nsga2_global_rank \
  --output "$PKG/tables/run_validation.json"
```
