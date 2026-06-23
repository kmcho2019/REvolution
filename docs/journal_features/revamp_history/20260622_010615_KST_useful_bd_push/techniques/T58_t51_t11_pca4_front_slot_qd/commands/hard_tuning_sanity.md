# T58 Hard/Tuning Sanity Commands

Status: pre-registered; do not edit after launch except to append actual
paths.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t58_t51_t11_pca4_front_slot_${RUN_TS}/hard_tuning"
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

## Descriptor Probe

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile t11_runtime_pca4_graph \
  --archive_type grid_quantile \
  --circuit_type sequential
```

Expected axes:

```text
t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3
requires_ppa=false
```

Pre-run result: resolves exactly to the four expected axes, reports
`requires_ppa=false`, and reports `requires_graph_metrics=true`.

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

## T58 QD Arm

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
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile t11_runtime_pca4_graph \
  --save_path "${RUN_ROOT}/t51_t11_pca4_front_slot_qd/seed_${SEED}"
```

Before accepting the live run, inspect emitted archive artifacts and confirm
the archive axes are the four `t11_runtime_pca_*` coordinates.

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T58_t51_t11_pca4_front_slot_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_t11_pca4_front_slot_qd \
  --eoh-mode t51_t11_pca4_front_slot_qd \
  --unified-mode t51_t11_pca4_front_slot_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T58_t51_t11_pca4_front_slot_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_t11_pca4_front_slot_qd \
  --pareto-qd-mode t51_t11_pca4_front_slot_qd \
  --require-full-subset
```

## Packaging Plan

```bash
CLASSIC_ROOT="exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution"

uv run python scripts/package_t48_gated_probe.py \
  --classic-root "${CLASSIC_ROOT}" \
  --qd-root "${RUN_ROOT}/t51_t11_pca4_front_slot_qd" \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T58_t51_t11_pca4_front_slot_qd/hard_tuning_package \
  --seed 1001 \
  --package-tag t58 \
  --package-title "T58 T51 T11-PCA4 Front-Slot QD" \
  --qd-method t51_t11_pca4_front_slot_qd \
  --qd-label "T58 T51 T11-PCA4 front-slot QD" \
  --counter-stem operator_counters \
  --counter-title "Operator Counters" \
  --counter-keys success_parent_requests,two_parent_attempts
```
