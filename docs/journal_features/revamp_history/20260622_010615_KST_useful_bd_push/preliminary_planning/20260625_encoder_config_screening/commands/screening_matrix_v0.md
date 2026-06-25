# Preliminary Screening Matrix V0

Run from `/workspace`. Set `RUN_ROOT` before launching real arms.

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src
RUN_ROOT="exp/useful_bd_push/prelim_encoder_config_screen_$(date -u +%Y%m%d_%H%M%S_UTC)/live"
mkdir -p "${RUN_ROOT}"
```

## classic_revolution_8x5

```bash
uv run python scripts/run_backend.py \
  --backend \
  revolution \
  --benchmarks \
  RTLLM \
  VerilogEval-Spec-to-RTL \
  --problems \
  Prob015_multi_pipe_8bit \
  Prob024_fsm \
  Prob041_traffic_light \
  Prob045_alu \
  Prob049_signal_generator \
  Prob116_m2014_q3 \
  Prob135_m2014_q6b \
  Prob153_gshare \
  --api_backend \
  vllm \
  --vllm_host \
  20.0.0.103 \
  --vllm_port \
  8000 \
  --vllm_min_model_len \
  128000 \
  --model_name \
  openai/gpt-oss-120b \
  --max_tokens \
  128000 \
  --diff_max_tokens \
  128000 \
  --population_size \
  8 \
  --num_generations \
  5 \
  --evaluation_mode \
  strict_ablation \
  --temperature \
  1.0 \
  --top_p \
  1.0 \
  --total_worker_slots \
  32 \
  --max_active_problems \
  8 \
  --max_workers_per_problem \
  4 \
  --seed \
  1001 \
  --no-backend_subdir \
  --search_mode \
  revolution \
  --save_path "${RUN_ROOT}/classic_revolution_8x5/seed_1001"
```

## code_thought_sr_front_slot_8x5

```bash
uv run python scripts/run_backend.py \
  --backend \
  revolution \
  --benchmarks \
  RTLLM \
  VerilogEval-Spec-to-RTL \
  --problems \
  Prob015_multi_pipe_8bit \
  Prob024_fsm \
  Prob041_traffic_light \
  Prob045_alu \
  Prob049_signal_generator \
  Prob116_m2014_q3 \
  Prob135_m2014_q6b \
  Prob153_gshare \
  --api_backend \
  vllm \
  --vllm_host \
  20.0.0.103 \
  --vllm_port \
  8000 \
  --vllm_min_model_len \
  128000 \
  --model_name \
  openai/gpt-oss-120b \
  --max_tokens \
  128000 \
  --diff_max_tokens \
  128000 \
  --population_size \
  8 \
  --num_generations \
  5 \
  --evaluation_mode \
  strict_ablation \
  --temperature \
  1.0 \
  --top_p \
  1.0 \
  --total_worker_slots \
  32 \
  --max_active_problems \
  8 \
  --max_workers_per_problem \
  4 \
  --seed \
  1001 \
  --no-backend_subdir \
  --search_mode \
  revolution_qd \
  --qd_archive_type \
  grid_quantile \
  --qd_grid_quantile_warmup_successes \
  4 \
  --qd_fill_target_fraction \
  0.25 \
  --qd_improve_backfill_fraction \
  0.20 \
  --qd_cell_mode \
  elite_pareto_slot \
  --qd_max_elites_per_cell \
  2 \
  --qd_objectives \
  ppa \
  --qd_champion_lane_fraction \
  0.80 \
  --qd_parent_selection \
  nsga2_global_rank \
  --qd_two_parent_probability \
  0.0 \
  --qd_two_parent_gate \
  none \
  --qd_operator_kind \
  single_thought_operator \
  --qd_operator_one_parent_fraction \
  1.0 \
  --qd_operator_archive_context_size \
  4 \
  --qd_operator_fail_feedback_chars \
  0 \
  --representation_kind \
  code_individual \
  --repair_kind \
  none \
  --repair_max_attempts_per_sample \
  0 \
  --repair_max_attempts_per_thought \
  0 \
  --repair_evidence \
  stage_scoped_logs \
  --qd_descriptor_profile \
  sr_pca_3d \
  --qd_descriptor_file \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/code_thought_sr_front_slot_8x5/seed_1001"
```

## masterrtl_structural_mix_8x5

```bash
uv run python scripts/run_backend.py \
  --backend \
  revolution \
  --benchmarks \
  RTLLM \
  VerilogEval-Spec-to-RTL \
  --problems \
  Prob015_multi_pipe_8bit \
  Prob024_fsm \
  Prob041_traffic_light \
  Prob045_alu \
  Prob049_signal_generator \
  Prob116_m2014_q3 \
  Prob135_m2014_q6b \
  Prob153_gshare \
  --api_backend \
  vllm \
  --vllm_host \
  20.0.0.103 \
  --vllm_port \
  8000 \
  --vllm_min_model_len \
  128000 \
  --model_name \
  openai/gpt-oss-120b \
  --max_tokens \
  128000 \
  --diff_max_tokens \
  128000 \
  --population_size \
  8 \
  --num_generations \
  5 \
  --evaluation_mode \
  strict_ablation \
  --temperature \
  1.0 \
  --top_p \
  1.0 \
  --total_worker_slots \
  32 \
  --max_active_problems \
  8 \
  --max_workers_per_problem \
  4 \
  --seed \
  1001 \
  --no-backend_subdir \
  --search_mode \
  revolution_qd \
  --qd_archive_type \
  grid_quantile \
  --qd_grid_quantile_warmup_successes \
  4 \
  --qd_fill_target_fraction \
  0.25 \
  --qd_improve_backfill_fraction \
  0.20 \
  --qd_cell_mode \
  elite_pareto_slot \
  --qd_max_elites_per_cell \
  2 \
  --qd_objectives \
  ppa \
  --qd_champion_lane_fraction \
  0.80 \
  --qd_parent_selection \
  nsga2_global_rank \
  --qd_two_parent_probability \
  0.0 \
  --qd_two_parent_gate \
  none \
  --qd_operator_kind \
  single_thought_operator \
  --qd_operator_one_parent_fraction \
  1.0 \
  --qd_operator_archive_context_size \
  4 \
  --qd_operator_fail_feedback_chars \
  0 \
  --representation_kind \
  code_individual \
  --repair_kind \
  none \
  --repair_max_attempts_per_sample \
  0 \
  --repair_max_attempts_per_thought \
  0 \
  --repair_evidence \
  stage_scoped_logs \
  --qd_descriptor_profile \
  source_aligned_masterrtl_structural_mix_3d \
  --save_path "${RUN_ROOT}/masterrtl_structural_mix_8x5/seed_1001"
```

## qwen_canonical_rtl_pca3_8x5

This follow-up arm must run in the isolated Qwen env because it loads
`Qwen/Qwen3-Embedding-0.6B` locally for descriptor extraction. Worker
concurrency is lower than the non-encoder arms to avoid loading too many
embedding models at once.

```bash
OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}" \
PYTHONPATH=src \
exp/diversity_check/encoder_envs/qwen3_probe/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems \
  Prob015_multi_pipe_8bit \
  Prob024_fsm \
  Prob041_traffic_light \
  Prob045_alu \
  Prob049_signal_generator \
  Prob116_m2014_q3 \
  Prob135_m2014_q6b \
  Prob153_gshare \
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
  --total_worker_slots 8 \
  --max_active_problems 4 \
  --max_workers_per_problem 2 \
  --seed 1001 \
  --no-backend_subdir \
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
  --qd_descriptor_profile qwen_canonical_rtl_pca3 \
  --qd_descriptor_file \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_qwen_live_screen_probe/qwen_descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/qwen_canonical_rtl_pca3_8x5/seed_1001"
```
