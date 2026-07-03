# Smooth-QD V2 Platform Config (pinned 2026-07-03, corrected same day)

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
  every other qd_target flag carries over.
- The authoritative qd_target flag VALUES:
  `.../20260618_briefing/exp_artifacts/01_integrated_v2_vs_classic/
  config_hard_subset_adaptive_rebinning.yaml` (`rebin_on` mode):
  `qd_num_cells 16`, `qd_grid_quantile_warmup_successes 8`,
  `qd_cell_mode pareto_front`, `qd_max_elites_per_cell 5`,
  `qd_objectives ppa`, `qd_rebinning_kind ks_triggered` with recent 3 /
  min members 20 / cooldown 3 / p 0.05, `qd_fill_target_fraction 0.25`,
  `qd_cell_reservoir 2`. The single-thought-only knobs
  (`qd_two_parent_probability`, `qd_operator_one_parent_fraction`,
  `qd_operator_archive_context_size`,
  `qd_operator_two_parent_allow_intra_bin`) are inert under
  `eoh_strategies` and are not passed.

Correction note (2026-07-03): the first pin omitted three non-default
values (`qd_num_cells 16` vs current default 64;
`qd_grid_quantile_warmup_successes 8` vs 20; `qd_max_elites_per_cell 5`
vs 1). The first anchor launch used that unfaithful pin and was stopped
~10 minutes in; its root is quarantined at
`exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC_INTERRUPTED_UNFAITHFUL/`
and must not be interpreted.

Evaluation-surface ruling: the June-12 matrix ran
`evaluation_mode search_accelerated`; the June-25 screen comparator ran
`strict_ablation`. Evaluation flow must match between compared arms, so
screen-scale anchor and lane runs use `strict_ablation` (the screen
surface); the V2 platform is defined by its mechanism flags below.

## V2 flag set (delta vs a classic run on the same surface)

```
--search_mode revolution_qd
--representation_kind code_individual
--qd_operator_kind eoh_strategies
--qd_champion_lane_fraction 0.5
--qd_parent_selection nsga2_global_rank
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_num_cells 16
--qd_grid_quantile_warmup_successes 8
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_rebinning_kind ks_triggered
```

Remaining `qd_*` knobs match the YAML at current repo defaults
(`qd_objectives ppa`, `qd_fill_target_fraction 0.25`,
`qd_cell_reservoir 2`, rebinning 3/20/3/0.05); the anchor run's launch
log records the fully resolved argument set and is the binding artifact.

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
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
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
