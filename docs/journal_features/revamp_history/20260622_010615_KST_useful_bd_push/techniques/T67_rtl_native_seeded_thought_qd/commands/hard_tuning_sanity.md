# T67 Hard/Tuning Sanity Commands

Status: pre-registered; do not edit after launch except to append actual paths.

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile fused_rtl_state_pipeline_2d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T67_rtl_native_seeded_thought_qd/tables/descriptor_probe_fused_rtl_state_pipeline_2d.json
```

Required properties:

- axes are `state_control_ratio` and `control_pipeline_ratio`;
- `requires_graph_metrics=true`;
- `requires_rtl_metrics=true`;
- `requires_ppa=false`.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t67_rtl_native_seeded_thought_${RUN_TS}/hard_tuning"
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

## T67 QD Arm

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
  --qd_operator_fail_feedback_chars 0 \
  --representation_kind thought_only \
  --code_samples_per_thought 3 \
  --qd_thought_code_seeded \
  --qd_seed_sample_fraction 0.67 \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile fused_rtl_state_pipeline_2d \
  --save_path "${RUN_ROOT}/rtl_native_seeded_thought_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T67_rtl_native_seeded_thought_qd/tables/hard_tuning_subset.yaml \
  --classic-mode rtl_native_seeded_thought_qd \
  --eoh-mode rtl_native_seeded_thought_qd \
  --unified-mode rtl_native_seeded_thought_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T67_rtl_native_seeded_thought_qd/tables/hard_tuning_subset.yaml \
  --classic-mode rtl_native_seeded_thought_qd \
  --pareto-qd-mode rtl_native_seeded_thought_qd \
  --require-full-subset
```

The existing `validate_thought_only_k_code_run.py` is tied to the old K=4
matrix shape. Do not use it as the primary T67 validator unless it is
separately generalized and tested for K=3 single-arm runs.

## Packaging Requirements

Package against the matched completed comparators:

- T47 classic seed `1001`;
- T50 candidate-matched thought-only seed `1001`;
- T51 code-thought front-slot seed `1001`;
- T63 fused state/pipeline seed `1001`;
- T66 RTL-native guarded-parent seed `1001`.

The package must include `t67_ppa_completeness.csv`, direct raw area-power PPA
fronts, thought/code-sample counters, and the Phase 03.1 viewer if archive
artifacts are available.

## Packaging Template

```bash
uv run python scripts/package_t48_gated_probe.py \
  --classic-root exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution \
  --qd-root "${RUN_ROOT}/rtl_native_seeded_thought_qd" \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T67_rtl_native_seeded_thought_qd/hard_tuning_package \
  --seed 1001 \
  --package-tag t67 \
  --package-title T67 \
  --qd-method rtl_native_seeded_thought_qd \
  --qd-label "T67 RTL-native seeded thought QD" \
  --counter-stem thought_seed_counters \
  --counter-title "Thought/Seed Counters" \
  --counter-keys generated_thought_count,generated_code_sample_count,success_parent_requests,two_parent_attempts
```
