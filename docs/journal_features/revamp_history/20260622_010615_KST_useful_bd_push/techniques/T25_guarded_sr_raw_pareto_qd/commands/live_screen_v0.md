# T25 Live Screen V0 Command

Run root:

`exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/`

Preflight:

```bash
mkdir -p exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/preflight
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/preflight/models_20260621_210402_UTC.json
```

Shared environment:

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src
```

Live guarded SR raw arm:

```bash
/workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob045_alu Prob041_traffic_light Prob015_multi_pipe_8bit \
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
  --qd_fill_target_fraction 0.10 \
  --qd_improve_backfill_fraction 0.05 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.25 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --seed 1001 \
  --save_path exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/guarded_sr_raw_pareto_qd/seed_1001 \
  --no-backend_subdir
```

Validate the Pareto archive after the run:

```bash
/workspace/.venv/bin/python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T25_guarded_sr_raw_pareto_qd/tables/live_screen_v0_subset.yaml \
  --classic-mode t24_sr_pareto_live_validation_20260621_184346_UTC/classic_revolution/seed_1001/openai_gpt-oss-120b \
  --pareto-qd-mode t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b \
  --require-full-subset
```
