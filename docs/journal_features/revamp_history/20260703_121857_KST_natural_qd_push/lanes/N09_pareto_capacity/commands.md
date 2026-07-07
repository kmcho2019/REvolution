# N09 Commands

Registered: 2026-07-07 before any N09 live result.

## Live Screen Template

Use the P0 V2 platform command and change only
`--qd_max_elites_per_cell` plus the save path.

```bash
RUN_ROOT=exp/natural_qd_push/n09_pareto_capacity_<UTC>/live
curl -sS http://20.0.0.103:8000/v1/models \
  > docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/preflight_vllm_models_<UTC>.json

uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light \
    Prob045_alu Prob049_signal_generator Prob116_m2014_q3 \
    Prob135_m2014_q6b Prob153_gshare \
  --api_backend vllm --vllm_host 20.0.0.103 --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 --diff_max_tokens 128000 \
  --population_size 8 --num_generations 5 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 --top_p 1.0 \
  --total_worker_slots 32 --max_active_problems 8 \
  --max_workers_per_problem 4 \
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --representation_kind code_individual \
  --qd_operator_kind eoh_strategies \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 7 \
  --qd_rebinning_kind ks_triggered \
  --save_path "${RUN_ROOT}/pareto_front_7/seed_1001"
```

## Package Template

```bash
uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n09_pareto_front_7=exp/natural_qd_push/n09_pareto_capacity_<UTC>/live/pareto_front_7/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/pareto_analysis

uv run python scripts/report_ppa_distribution.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n09_pareto_front_7=exp/natural_qd_push/n09_pareto_capacity_<UTC>/live/pareto_front_7/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/ppa_distribution

uv run python scripts/report_hv_auc.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/ppa_distribution/data/ppa_candidates.csv \
  --num-generations 5 \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/hv_auc.csv

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/ppa_distribution/data/ppa_candidates.csv \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/operator_contract.csv

uv run python scripts/validate_natural_qd_run.py \
  --run-root exp/natural_qd_push/n09_pareto_capacity_<UTC>/live/pareto_front_7/seed_1001 \
  --manifest docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv \
  --arm qd \
  --expect-config search_mode=revolution_qd \
  --expect-config qd_operator_kind=eoh_strategies \
  --expect-config representation_kind=code_individual \
  --expect-config population_size=8 \
  --expect-config num_generations=5 \
  --expect-config evaluation_mode=strict_ablation \
  --expect-config seed=1001 \
  --expect-config qd_num_cells=16 \
  --expect-config qd_grid_quantile_warmup_successes=8 \
  --expect-config qd_cell_mode=pareto_front \
  --expect-config qd_max_elites_per_cell=7 \
  --expect-config qd_parent_selection=nsga2_global_rank \
  --expect-config qd_descriptor_profile=journal_logic_ff_width_3d \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N09_pareto_capacity/run_validation.json
```
