# T31 Live Holdout V0 Command

Run preflight first:

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight" "${RUN_ROOT}/logs"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

Shared environment:

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src
```

Run T31:

```bash
/workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob150_review2015_fsmonehot Prob098_circuit7 Prob135_m2014_q6b \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 12 \
  --max_active_problems 3 \
  --max_workers_per_problem 4 \
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
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 1.00 \
  --qd_operator_archive_context_size 4 \
  --qd_operator_fail_feedback_chars 1200 \
  --representation_kind code_individual \
  --repair_kind none \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --seed 1001 \
  --save_path "${RUN_ROOT}/sr_raw_fail_feedback_repair_qd/seed_1001" \
  --no-backend_subdir \
  2>&1 | tee "${RUN_ROOT}/logs/sr_raw_fail_feedback_repair_qd_seed_1001.log"
```

After execution, validate the T31 Pareto archive:

```bash
/workspace/.venv/bin/python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T31_sr_raw_fail_feedback_repair_qd/tables/holdout_screen_v0_subset.yaml \
  --pareto-qd-mode sr_raw_fail_feedback_repair_qd/seed_1001/openai_gpt-oss-120b
```

Package with a T31-specific packager or an extension of the T30 packager that
compares T30 classic, T30 T26, and the resolved T31 run root.
