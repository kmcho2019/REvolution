# T96 Run Command

```bash
RUN_ROOT=exp/useful_bd_push/prelim_rf_deepgate_hybrid_delayed_20260626_125819_UTC/live
OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
PYTHONPATH=src \
uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light Prob045_alu Prob049_signal_generator Prob116_m2014_q3 Prob135_m2014_q6b Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 8 \
  --num_generations 5 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 \
  --top_p 1.0 \
  --total_worker_slots 32 \
  --max_active_problems 8 \
  --max_workers_per_problem 4 \
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 4 \
  --qd_archive_activation_generation 3 \
  --qd_fill_target_fraction 0.10 \
  --qd_improve_backfill_fraction 0.05 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.90 \
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
  --qd_descriptor_profile rf_deepgate_hybrid_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml \
  --save_path "$RUN_ROOT/rf_deepgate_hybrid_delayed_8x5/seed_1001"
```

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root "$RUN_ROOT" \
  --pareto-qd-mode rf_deepgate_hybrid_delayed_8x5/seed_1001/openai_gpt-oss-120b \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml
```

```bash
uv run python scripts/validate_single_thought_operator_run.py \
  --run-root "$RUN_ROOT" \
  --classic-mode rf_deepgate_hybrid_delayed_8x5 \
  --eoh-mode rf_deepgate_hybrid_delayed_8x5 \
  --unified-mode rf_deepgate_hybrid_delayed_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```

## Common Evaluation Tables

```bash
uv run python scripts/report_common_evaluation_contract.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/visualizations/qd_ppa_viewer \
  --ppa-completeness docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/analysis/ppa_completeness.csv \
  --pareto-problem-metrics docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/analysis/pareto_analysis/backend_problem_metrics.csv \
  --seed 1001 \
  --budget-shape 8x5 \
  --method-family classic_revolution_8x5=classic \
  --method-family rf_deepgate_hybrid_delayed_8x5=hybrid_encoder \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables
```
