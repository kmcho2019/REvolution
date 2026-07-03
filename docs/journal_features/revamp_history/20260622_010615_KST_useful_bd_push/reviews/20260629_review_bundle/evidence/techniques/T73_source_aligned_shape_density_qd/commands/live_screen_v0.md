# T73 Live Screen V0 Commands

Status: pre-registered; do not run before storage and vLLM preflight.

## Storage Check

```bash
df -h /workspace
df -ih /workspace
```

Observed before package registration:

```text
/workspace: 27T total, 23T used, 3.5T available, 87% used
```

Keep large run artifacts under `exp/`. Do not place new run outputs under
`/aux`.

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile source_aligned_shape_density_3d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/tables/descriptor_probe_source_aligned_shape_density_3d.json
```

Required probe properties:

- axes are `source_aligned_masterrtl_branching`,
  `source_aligned_rtltimer_wire_density`, and
  `source_aligned_rtltimer_dff_density`;
- `requires_ppa=false`;
- `requires_synthesis=false`;
- `requires_source_aligned_rtl=true`.

## Collapse Audit

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/tools/audit_t73_axes_from_t72.py
```

It writes:

```text
tables/t73_descriptor_collapse_audit.csv
tables/t73_axis_screen_summary.json
figures/t73_descriptor_occupancy_audit.png
```

## vLLM Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t73_source_aligned_shape_density_${RUN_TS}/hard_tuning"
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

## T73 QD Arm

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
  --qd_two_parent_probability 0.0 \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 0.90 \
  --qd_operator_archive_context_size 4 \
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile source_aligned_shape_density_3d \
  --save_path "${RUN_ROOT}/source_aligned_shape_density_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode source_aligned_shape_density_qd \
  --eoh-mode source_aligned_shape_density_qd \
  --unified-mode source_aligned_shape_density_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --classic-mode source_aligned_shape_density_qd \
  --pareto-qd-mode source_aligned_shape_density_qd \
  --require-full-subset
```

Observed `2026-06-23` run:

```text
run_root: exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning
runtime: 1706.23 seconds
storage: 143M
summary: 12/13 success; Prob151_review2015_fsm failed
single_thought_operator_validation: valid=True
pareto_front_validation: valid=True
max_front_size_seen: 2
```

The stored config has `qd_two_parent_probability=0.0`, so QD
crossover/fusion was disabled. The inherited `single_thought_operator`
setting `qd_operator_one_parent_fraction=0.90` still allowed low two-parent
prompt exposure; the archive contains `4` two-parent prompt descendants.

## Packaging Requirements

Package against:

- T47 classic seed `1001`;
- T51 code-thought front-slot seed `1001`;
- T66 guarded parent seed `1001`;
- T67 seeded thought-code seed `1001`;
- T72 source-aligned cell QD seed `1001`.

The package must include direct raw PPA-front plots, `ppa_completeness.csv`,
descriptor-health summaries, parent counters, and the Phase 03.1 viewer if
archive artifacts exist.

## Matched Classic Comparison

Observed matched package run:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC/final_analysis
```

Compact package:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/tools/package_t73_matched_summary.py
```

Phase 03.1 viewer:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --archive_source_backend source_aligned_shape_density_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict
```

Validation:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/visualizations/qd_ppa_viewer \
  --strict
```

Observed decision: `T0 positive_diagnostic_not_promoted`. T73 preserves
matched valid-PPA coverage and improves valid-PPA samples, but classic wins
mean HV and Pareto breadth.
