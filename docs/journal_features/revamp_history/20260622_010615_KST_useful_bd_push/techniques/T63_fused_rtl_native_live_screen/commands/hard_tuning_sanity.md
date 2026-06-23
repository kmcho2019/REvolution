# T63 Hard/Tuning Sanity Commands

Status: completed seed `1001`; exact profile should not be rerun as seed
`1002` without a method change.

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile fused_rtl_state_pipeline_2d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/descriptor_probe_fused_rtl_state_pipeline_2d.json
```

Required properties:

- axes are `state_control_ratio` and `control_pipeline_ratio`;
- `requires_graph_metrics=true`;
- `requires_rtl_metrics=true`;
- `requires_ppa=false`.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t63_fused_rtl_native_${RUN_TS}/hard_tuning"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
uv run python - "${RUN_ROOT}/preflight/models_${RUN_TS}.json" \
  > "${RUN_ROOT}/preflight/models_summary_${RUN_TS}.txt" <<'PY'
import json
import sys

payload = json.load(open(sys.argv[1], encoding="utf-8"))
for model in payload["data"]:
    print(f"{model['id']} max_model_len={model.get('max_model_len')}")
PY
```

Required model line:

```text
openai/gpt-oss-120b max_model_len=131072
```

## Shared Arguments

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM VerilogEval-Spec-to-RTL
  --problems
    Prob004_adder_8bit
    Prob015_multi_pipe_8bit
    Prob024_fsm
    Prob037_parallel2serial
    Prob041_traffic_light
    Prob045_alu
    Prob049_signal_generator
    Prob098_circuit7
    Prob116_m2014_q3
    Prob135_m2014_q6b
    Prob150_review2015_fsmonehot
    Prob151_review2015_fsm
    Prob153_gshare
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
  --total_worker_slots 48
  --max_active_problems 12
  --max_workers_per_problem 4
  --no-backend_subdir
)
```

## T63 QD Arm

```bash
SEED=1001
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --seed "${SEED}" \
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
  --qd_two_parent_probability 0.0 \
  --qd_two_parent_gate none \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 1.0 \
  --qd_operator_archive_context_size 4 \
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile fused_rtl_state_pipeline_2d \
  --save_path "${RUN_ROOT}/fused_rtl_state_pipeline_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml \
  --classic-mode fused_rtl_state_pipeline_qd \
  --eoh-mode fused_rtl_state_pipeline_qd \
  --unified-mode fused_rtl_state_pipeline_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml \
  --classic-mode fused_rtl_state_pipeline_qd \
  --pareto-qd-mode fused_rtl_state_pipeline_qd \
  --require-full-subset
```

Viewer export must follow the Phase 03.1 contract after final analysis data
exists.

## Completed Run

- `RUN_TS=20260623_133903_UTC`.
- `RUN_ROOT=exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning`.
- Preflight passed:
  `openai/gpt-oss-120b max_model_len=131072`.
- T63 completed all 13 hard/tuning problems in `1664.03` seconds.
- Summary log:
  `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001/openai_gpt-oss-120b/20260623_133927_revolution_summary_results.txt`.
- Single-thought validation passed with `--require-full-subset`.
- Pareto/front validation passed with `--require-full-subset`.
- Packaged result:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/hard_tuning_package/`.
- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Strict static viewer validation passed. Playwright produced screenshots but
  returned the documented compare-guide caveat.
- Decision: T63 is `T0 positive_mechanism_ablation_not_promoted`.

## Final Analysis And Viewer Export

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run fused_rtl_state_pipeline_qd=exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer_source/final_analysis

uv run python scripts/export_qd_ppa_visualization.py \
  --run-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer_source \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run fused_rtl_state_pipeline_qd=exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001 \
  --archive_source_backend fused_rtl_state_pipeline_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer \
  --strict

uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/tables/hard_tuning_subset.yaml \
  --strict
```
