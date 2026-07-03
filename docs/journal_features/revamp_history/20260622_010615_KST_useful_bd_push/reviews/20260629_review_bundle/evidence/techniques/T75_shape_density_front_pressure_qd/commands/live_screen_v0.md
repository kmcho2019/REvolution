# T75 Live Screen V0 Commands

Status: pre-registered; do not run before storage and vLLM preflight.

## Storage Check

```bash
df -h /workspace
df -ih /workspace
```

Observed at registration:

```text
/workspace: 27T total, 23T used, 3.4T available, 87% used
/workspace inodes: 2.7G total, 62M used, 2.6G free, 3% used
```

Keep new run artifacts under `exp/`. Do not write new experiment output under
`/aux`.

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile source_aligned_shape_density_3d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T75_shape_density_front_pressure_qd/tables/descriptor_probe_source_aligned_shape_density_3d.json
```

Required probe properties:

- axes are `source_aligned_masterrtl_branching`,
  `source_aligned_rtltimer_wire_density`, and
  `source_aligned_rtltimer_dff_density`;
- `requires_ppa=false`;
- `requires_synthesis=false`;
- `requires_graph_metrics=false`;
- `requires_simulation=false`;
- `requires_source_aligned_rtl=true`.

## vLLM Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t75_shape_density_front_pressure_${RUN_TS}/hard_tuning"
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

## T75 QD Arm

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
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_front_slot_lane_fraction 0.30 \
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
  --qd_descriptor_profile source_aligned_shape_density_3d \
  --save_path "${RUN_ROOT}/shape_density_front_pressure_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode shape_density_front_pressure_qd \
  --eoh-mode shape_density_front_pressure_qd \
  --unified-mode shape_density_front_pressure_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode shape_density_front_pressure_qd \
  --pareto-qd-mode shape_density_front_pressure_qd \
  --require-full-subset
```

## Matched Package

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run code_thought_front_slot_qd=exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001 \
  --backend_run rtl_native_front_guarded_parent_qd=exp/useful_bd_push/t66_rtl_native_front_guarded_parent_20260623_160756_UTC/hard_tuning/rtl_native_front_guarded_parent_qd/seed_1001 \
  --backend_run rtl_native_seeded_thought_qd=exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/rtl_native_seeded_thought_qd/seed_1001 \
  --backend_run source_aligned_rtl_cell_qd=exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_202136_UTC/hard_tuning/source_aligned_rtl_cell_qd/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --backend_run shape_density_front_slot_hybrid_qd=exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning/shape_density_front_slot_hybrid_qd/seed_1001 \
  --backend_run shape_density_front_pressure_qd="${RUN_ROOT}/shape_density_front_pressure_qd/seed_${SEED}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir "${RUN_ROOT}/final_analysis"
```

## Phase 03.1 Viewer

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --backend_run shape_density_front_slot_hybrid_qd=exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning/shape_density_front_slot_hybrid_qd/seed_1001 \
  --backend_run shape_density_front_pressure_qd="${RUN_ROOT}/shape_density_front_pressure_qd/seed_${SEED}" \
  --archive_source_backend shape_density_front_pressure_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T75_shape_density_front_pressure_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict

uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T75_shape_density_front_pressure_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict
```

Capture and inspect a screenshot before marking the viewer presentation-ready.
