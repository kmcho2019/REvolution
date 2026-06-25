# MasterRTL Front-Slot Probe Commands

Run from `/workspace`.

## Preflight

```bash
curl -sS http://20.0.0.103:8000/v1/models
```

Result:

- model: `openai/gpt-oss-120b`
- `max_model_len`: `131072`

## Live Arm

```bash
env OPENAI_API_KEY=vllm-local-placeholder PYTHONPATH=src uv run python scripts/run_backend.py \
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
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode elite_pareto_slot \
  --qd_max_elites_per_cell 2 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection front_slot_lane_nsga2 \
  --qd_front_slot_lane_fraction 0.10 \
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
  --qd_descriptor_profile source_aligned_masterrtl_structural_mix_3d \
  --save_path exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_front_slot_8x5/seed_1001
```

Result:

- status: completed `8/8` problems;
- runtime: `1520.65` seconds;
- PPA reports: `182`;
- scheduler telemetry:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_front_slot_8x5/seed_1001/openai_gpt-oss-120b/20260625_191459_revolution_scheduler_telemetry.json`.

## Final Analysis

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run code_thought_sr_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/code_thought_sr_front_slot_8x5/seed_1001 \
  --backend_run masterrtl_structural_mix_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_mix_8x5/seed_1001 \
  --backend_run qwen_canonical_rtl_pca3_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/qwen_canonical_rtl_pca3_8x5/seed_1001 \
  --backend_run masterrtl_structural_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_front_slot_8x5/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis_with_masterrtl_front_slot
```

This command was interrupted during source-aligned design-space feature
recovery after Pareto, PPA distribution, and evolutionary reports were written.
Those completed sections are packaged here.

## Package Regeneration

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_masterrtl_front_slot_probe/tools/package_masterrtl_front_slot_probe.py
```
