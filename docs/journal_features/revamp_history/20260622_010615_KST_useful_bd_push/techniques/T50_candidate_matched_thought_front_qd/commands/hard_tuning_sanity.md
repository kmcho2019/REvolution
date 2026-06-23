# T50 Hard/Tuning Sanity Commands

Status: pre-registered; seed `1001` not launched yet.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t50_candidate_matched_thought_front_${RUN_TS}/hard_tuning"
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

## T50 QD Arm

Run seed `1001` first. Add seed `1002` only if seed `1001` improves T49 front
or HV evidence without introducing a classic-covered design loss.

```bash
SEED=1001
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --seed "${SEED}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 8 \
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
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/candidate_matched_thought_front_qd/seed_${SEED}"
```

## Comparators

Use existing T47/T49 roots for the first package:

```bash
CLASSIC_ROOT="exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution"
T49_ROOT="exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning/thought_k_role_separated_repair_qd"
T47_PACKAGE="docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/hard_tuning_package"
T48_PACKAGE="docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/hard_tuning_package"
T49_PACKAGE="docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T49_thought_k_role_separated_repair_qd/hard_tuning_package"
```

## Packaging Plan

Use the generalized hard/tuning packager after seed `1001` exits:

```bash
uv run python scripts/package_t48_gated_probe.py \
  --classic-root "${CLASSIC_ROOT}" \
  --qd-root "${RUN_ROOT}/candidate_matched_thought_front_qd" \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T50_candidate_matched_thought_front_qd/hard_tuning_package \
  --seed 1001 \
  --package-tag t50 \
  --package-title "T50 Candidate-Matched Thought Front" \
  --qd-method candidate_matched_thought_front_qd \
  --qd-label "T50 candidate-matched thought front QD" \
  --counter-stem operator_counters \
  --counter-title "Operator Counters" \
  --counter-keys generated_thought_count,generated_code_sample_count,success_parent_requests,two_parent_attempts
```

The package must include matched classic/T50 tables, candidate-level PPA data,
direct raw PPA-front figures, and visual inspection notes.

After that package is written, add T50-versus-T47/T48/T49 comparison tables
from:

- `${T47_PACKAGE}/tables/t47_aggregate_metrics.csv`
- `${T48_PACKAGE}/tables/t48_aggregate_metrics.csv`
- `${T49_PACKAGE}/tables/t49_aggregate_metrics.csv`
- `hard_tuning_package/tables/t50_aggregate_metrics.csv`

Report that T50 is evaluated-code-candidate matched. Do not call it LLM-call
or token matched unless the run logs prove request/token parity.
