# T87 Front-Guarded RTL-Native Memory Commands

## VLLM Preflight

```bash
mkdir -p exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/preflight
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/preflight/models.json
```

## Three-Problem Smoke

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

uv run python scripts/run_backend.py \
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
  --qd_grid_quantile_warmup_successes 4 \
  --qd_fill_target_fraction 0.00 \
  --qd_improve_backfill_fraction 0.00 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_scheduler_mode front_guarded_memory \
  --qd_parent_selection front_guarded_memory \
  --qd_memory_classic_fraction 0.80 \
  --qd_memory_refine_fraction 0.15 \
  --qd_memory_rescue_fraction 0.05 \
  --qd_memory_probe_fraction 0.00 \
  --qd_memory_min_cell_credit 0.20 \
  --qd_memory_front_gap_epsilon 0.03 \
  --qd_memory_cooldown_attempts 3 \
  --qd_memory_cooldown_generations 2 \
  --qd_champion_lane_fraction 0.00 \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind single_thought_operator \
  --qd_operator_one_parent_fraction 1.0 \
  --qd_operator_archive_context_size 4 \
  --representation_kind code_individual \
  --repair_kind none \
  --qd_descriptor_profile source_aligned_shape_density_3d \
  --seed 1001 \
  --save_path exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001 \
  --no-backend_subdir
```

## Analysis

```bash
uv run python scripts/report_ppa_distribution.py \
  --backend_run classic=exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_sr_memory_warmup4_12x3=exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_random_memory_12x3=exp/useful_bd_push/front_guarded_memory_controls_20260626/fg_qdm_random_memory_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_shape_density_memory_12x3=exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001/openai_gpt-oss-120b \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T87_front_guarded_rtl_native_memory/analysis/shape_density_ppa_distribution

uv run python scripts/report_pareto_analysis.py \
  --backend_run classic=exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_sr_memory_warmup4_12x3=exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_random_memory_12x3=exp/useful_bd_push/front_guarded_memory_controls_20260626/fg_qdm_random_memory_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_shape_density_memory_12x3=exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001/openai_gpt-oss-120b \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T87_front_guarded_rtl_native_memory/analysis/shape_density_pareto_analysis
```
