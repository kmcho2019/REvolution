# T49 Hard/Tuning Sanity Commands

Status: pre-registered; do not run before committing the method card.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t49_thought_k_role_separated_repair_${RUN_TS}/hard_tuning"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
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
  --population_size 9
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

## T49 QD Arm

Run seed `1001` first. Add seed `1002` only after seed `1001` preserves
classic-covered designs and is not clearly dominated by T48.

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
  --qd_max_elites_per_cell 5 \
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
  --repair_kind bounded_local_repair \
  --repair_max_attempts_per_sample 1 \
  --repair_max_attempts_per_thought 1 \
  --repair_evidence stage_scoped_logs \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/thought_k_role_separated_repair_qd/seed_${SEED}"
```

## Comparators

Use existing T47 and T48 roots for the first package:

```bash
CLASSIC_ROOT="exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution"
T48_ROOT="exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd"
```

## Packaging Plan

Add or reuse a generalized hard/tuning probe packager after the seed `1001`
run exits. The package must include:

- matched classic/T48/T49 tables;
- repair-attempt and repair-success counts;
- direct raw PPA-front figures;
- candidate-level PPA CSVs;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts are present.
