# T11 Top-4 Front-Slot Probe Commands

Run from `/workspace`.

## Preflight

```bash
curl -s http://20.0.0.103:8000/v1/models
```

The endpoint returned `openai/gpt-oss-120b` with `max_model_len=131072`.

## Descriptor Profile Check

```bash
uv run python - <<'PY'
from revolution.qd.descriptors import descriptor_requirements, load_descriptor_profiles

profiles = load_descriptor_profiles()
axes = profiles["t11_runtime_top4_graph"]
print(axes)
print(descriptor_requirements(axes))
PY
```

The profile resolved to graph metrics only and did not require PPA,
synthesis, source-aligned RTL, or pretrained Qwen metrics.

## Live Run

```bash
env OPENAI_API_KEY=vllm-local-placeholder PYTHONPATH=src \
uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light \
    Prob045_alu Prob049_signal_generator Prob116_m2014_q3 \
    Prob135_m2014_q6b Prob153_gshare \
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
  --qd_descriptor_profile t11_runtime_top4_graph \
  --save_path exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001
```

## Analysis

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run code_thought_sr_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/code_thought_sr_front_slot_8x5/seed_1001 \
  --backend_run masterrtl_structural_mix_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_mix_8x5/seed_1001 \
  --backend_run qwen_canonical_rtl_pca3_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/qwen_canonical_rtl_pca3_8x5/seed_1001 \
  --backend_run masterrtl_structural_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_front_slot_8x5/seed_1001 \
  --backend_run t11_runtime_top4_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis_with_t11_top4_front_slot
```

This was interrupted during source-aligned design-space recovery after the
Pareto, PPA distribution, and evolutionary reports were written.

## Validators

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --classic-mode classic_revolution_8x5 \
  --pareto-qd-mode t11_runtime_top4_front_slot_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset

uv run python scripts/validate_single_thought_operator_run.py \
  --run-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --classic-mode t11_runtime_top4_front_slot_8x5 \
  --eoh-mode t11_runtime_top4_front_slot_8x5 \
  --unified-mode t11_runtime_top4_front_slot_8x5 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --require-full-subset
```
