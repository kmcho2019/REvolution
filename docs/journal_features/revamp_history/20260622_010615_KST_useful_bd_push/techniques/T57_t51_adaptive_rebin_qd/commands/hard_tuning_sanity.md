# T57 Hard/Tuning Sanity Commands

Status: pre-registered; do not edit after launch except to append actual
paths.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t57_t51_adaptive_rebin_${RUN_TS}/hard_tuning"
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
  --profile sr_pca_3d \
  --descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --archive_type grid_quantile \
  --circuit_type sequential
```

Pre-run result: resolves to `["sr_pca_0", "sr_pca_1", "sr_pca_2"]` and
reports `requires_ppa=false`.

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

## T57 QD Arm

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
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --qd_rebinning_kind ks_triggered \
  --qd_rebinning_recent_generations 1 \
  --qd_rebinning_min_archive_members 8 \
  --qd_rebinning_cooldown_generations 2 \
  --qd_rebinning_base_p_threshold 0.05 \
  --save_path "${RUN_ROOT}/t51_adaptive_rebin_qd/seed_${SEED}"
```

Before accepting the live run, inspect emitted archive artifacts and confirm
`qd_rebinning_kind` is `ks_triggered`.

## Validators

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_adaptive_rebin_qd \
  --eoh-mode t51_adaptive_rebin_qd \
  --unified-mode t51_adaptive_rebin_qd \
  --require-full-subset

uv run python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/tables/hard_tuning_subset.yaml \
  --classic-mode t51_adaptive_rebin_qd \
  --pareto-qd-mode t51_adaptive_rebin_qd \
  --require-full-subset
```

For adaptive-rebinning validation, stage classic, T51 off-mode, and T57
on-mode under one validation root, then run:

```bash
uv run python scripts/validate_adaptive_rebinning_run.py \
  --run-root "${VALIDATION_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/tables/hard_tuning_subset.yaml \
  --classic-mode classic_revolution \
  --off-mode code_thought_front_slot_qd \
  --on-mode t51_adaptive_rebin_qd \
  --require-full-subset
```

## Packaging Plan

```bash
CLASSIC_ROOT="exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution"

uv run python scripts/package_t48_gated_probe.py \
  --classic-root "${CLASSIC_ROOT}" \
  --qd-root "${RUN_ROOT}/t51_adaptive_rebin_qd" \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/hard_tuning_package \
  --seed 1001 \
  --package-tag t57 \
  --package-title "T57 T51 Adaptive-Rebin QD" \
  --qd-method t51_adaptive_rebin_qd \
  --qd-label "T57 T51 adaptive-rebin QD" \
  --counter-stem rebinning_counters \
  --counter-title "Rebinning Counters" \
  --counter-keys total_rebin_count,rebin_recent_sample_count,rebin_replay_member_count
```

## Completed Run

- `RUN_TS=20260623_083945_UTC`.
- `RUN_ROOT=exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning`.
- Preflight passed:
  `openai/gpt-oss-120b max_model_len=131072`.
- T57 completed all 13 hard/tuning problems in `1811.33` seconds.
- Summary log:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/t51_adaptive_rebin_qd/seed_1001/openai_gpt-oss-120b/20260623_083946_revolution_summary_results.txt`.
- Single-thought validation passed with `--require-full-subset`.
- Pareto/front validation passed with `--require-full-subset`.
- Adaptive-rebinning validation wrote diagnostics and returned invalid because
  localized trigger evidence was inconclusive: `26` checks, `0` rebin events,
  and no selected localized healthy/occupied-cell improvement.
- Packaged result:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/hard_tuning_package/`.
- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Strict viewer validation passed. Playwright generated screenshots but
  reported the caveats recorded in
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
