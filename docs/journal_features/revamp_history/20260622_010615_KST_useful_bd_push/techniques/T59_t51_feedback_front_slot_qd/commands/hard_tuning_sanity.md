# T59 Hard/Tuning Sanity Commands

Status: completed; pre-registration commands retained with actual paths below.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t59_t51_feedback_front_slot_${RUN_TS}/hard_tuning"
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

## T59 QD Arm

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
  --qd_two_parent_gate none \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 1.0 \
  --qd_operator_archive_context_size 4 \
  --qd_operator_fail_feedback_chars 600 \
  --representation_kind code_individual \
  --repair_kind none \
  --repair_max_attempts_per_sample 0 \
  --repair_max_attempts_per_thought 0 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/t51_feedback_front_slot_qd/seed_${SEED}"
```

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T59_t51_feedback_front_slot_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_feedback_front_slot_qd \
  --eoh-mode t51_feedback_front_slot_qd \
  --unified-mode t51_feedback_front_slot_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T59_t51_feedback_front_slot_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_feedback_front_slot_qd \
  --pareto-qd-mode t51_feedback_front_slot_qd \
  --require-full-subset
```

Viewer export must follow the Phase 03.1 contract after final analysis data
exists.

## PPA Completeness

```bash
uv run python scripts/report_ppa_completeness.py \
  --ppa-candidates exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/ppa_candidates.csv \
  --reference-ppa-metrics exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv \
  --classic-method classic \
  --qd-method t51_feedback_front_slot_qd \
  --output docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T59_t51_feedback_front_slot_qd/hard_tuning_package/tables/t59_ppa_completeness.csv
```

## Completed Run

- `RUN_TS=20260623_110249_UTC`.
- `RUN_ROOT=exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/hard_tuning`.
- Preflight passed:
  `openai/gpt-oss-120b max_model_len=131072`.
- T59 completed all 13 hard/tuning problems in `1624.69` seconds.
- Summary log:
  `exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/hard_tuning/t51_feedback_front_slot_qd/seed_1001/openai_gpt-oss-120b/20260623_110317_revolution_summary_results.txt`.
- Single-thought validation passed with `--require-full-subset`.
- Pareto/front validation passed with `--require-full-subset`.
- PPA completeness report generated; all 13 rows are `headline`.
- Packaged result:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T59_t51_feedback_front_slot_qd/hard_tuning_package/`.
- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Non-strict viewer validation passed. Strict validation fails with the
  documented classic SR-PCA projection caveat.
- Decision: exact T59 is `T0 diagnostic_no_promotion`; do not spend seed
  `1002` on this exact feedback front-slot path.
