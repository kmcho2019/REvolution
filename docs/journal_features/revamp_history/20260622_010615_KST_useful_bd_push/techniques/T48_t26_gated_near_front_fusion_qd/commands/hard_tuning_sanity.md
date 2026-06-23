# T48 Hard/Tuning Sanity Commands

Status: seeds `1001` and `1002` complete. The narrow
`qd_two_parent_gate` implementation and focused tests have landed.

## Preflight

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t48_t26_gated_near_front_fusion_${RUN_TS}/hard_tuning"
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

## T48 QD Arm

```bash
for SEED in 1001 1002; do
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
    --qd_two_parent_probability 0.10 \
    --qd_two_parent_gate near_front_descriptor \
    --qd_operator_kind eoh_strategies \
    --representation_kind code_individual \
    --qd_descriptor_profile sr_pca_3d \
    --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
    --save_path "${RUN_ROOT}/t26_gated_near_front_fusion_qd/seed_${SEED}"
done
```

## Comparator

Use the already completed T47 classic roots for the first T48 package:

```bash
CLASSIC_ROOT="exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution"
```

The T48 package script must compare each T48 seed against the matching T47
classic seed. Rerun classic only if those roots are unavailable or fail a
pre-packaging integrity check.

## Packaging

```bash
uv run python scripts/package_t48_gated_probe.py \
  --classic-root exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution \
  --qd-root exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd \
  --matrix docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/probe_problem_matrix.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/hard_tuning_package
```

## Phase 03.1 Viewer

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1002 \
  --backend_run t26_gated_near_front_fusion_qd=exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd/seed_1002 \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/qd_ppa_viewer_source/final_analysis

uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/qd_ppa_viewer_source \
  --backend_run classic=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1002 \
  --backend_run t26_gated_near_front_fusion_qd=exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd/seed_1002 \
  --archive_source_backend t26_gated_near_front_fusion_qd \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/visualizations/qd_ppa_viewer \
  --strict \
  --no-classic-descriptor-recovery
```
