# Smooth-QD V2 Platform Config (pinned 2026-07-03)

The platform every lane extends. Reconstructed from tracked sources
because the original launchers (`exp/smooth_qd_*_launch.sh`,
`exp/finals_matrix_1004_1005_launch.sh`) are gone from disk:

- `docs/journal_features/16_smooth_qd_integration_track.md` (V1/V2 ladder,
  NSGA-II spec, "1 flag + 1 helper" rule).
- `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/
  journal_revamp_consolidated_record.md` section 8: smooth-QD V1/V2 differ
  from the qd_target arm by exactly `--representation_kind code_individual`
  + `--qd_operator_kind eoh_strategies` + `--qd_champion_lane_fraction 0.5`
  + `--qd_parent_selection {cell_crowded_tournament|nsga2_global_rank}`;
  all other qd_target flags carry over (`--qd_cell_mode pareto_front`,
  `--qd_archive_type grid_quantile`,
  `--qd_descriptor_profile journal_logic_ff_width_3d`,
  `--qd_rebinning_kind ks_triggered`).

## V2 flag set (delta vs a classic run)

```
--search_mode revolution_qd
--representation_kind code_individual
--qd_operator_kind eoh_strategies
--qd_champion_lane_fraction 0.5
--qd_parent_selection nsga2_global_rank
--qd_cell_mode pareto_front
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_rebinning_kind ks_triggered
```

All other `qd_*` knobs stay at repo defaults; the anchor run's launch log
records the fully resolved argument set and is the binding artifact.

## Anchor command (8-design screen, matches the June-25 classic card)

Identical to `../../20260622_010615_KST_useful_bd_push/preliminary_planning/
20260625_encoder_config_screening/commands/screening_matrix_v0.md`
`classic_revolution_8x5` except `--search_mode` and the V2 flags:

```bash
RUN_ROOT=exp/natural_qd_push/p0_v2_anchor_<UTC>/live
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
  --qd_cell_mode pareto_front \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_rebinning_kind ks_triggered \
  --save_path "${RUN_ROOT}/smooth_qd_v2_8x5/seed_1001"
```

Comparator: classic seed-1001 metrics in `classic_baselines.csv` (reused;
do not relaunch classic). Operator-contract audit is mandatory on the
anchor before any lane comparison uses it.

## Known V2 evidence (13-problem hard tuning set, for context only)

- 5-seed quality delta vs classic: -0.016, CI [-0.045, +0.007],
  functionality tied (F23, doc 13). Screen-scale (8-design) V2 numbers do
  not exist yet — producing them is the point of the P0 anchor.
