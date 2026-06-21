# Simple Yosys Stat BD Artifacts Manifest

Status: current replay package.

## Source Artifacts

- Historical standard-results root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results`
- Baseline root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results`
- Manual-BD root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results`
- Prior method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/01_yosys_stat_bd/`

## Replay Command

```bash
.venv/bin/python scripts/report_auto_bd_standard_results.py \
  --results-root /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1 \
  --output-md exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.md \
  --output-json exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json \
  --figure-dir exp/useful_bd_push/central_replay_20260621_165000_UTC/figures \
  --phase development_preliminary_seed1 \
  --seed 1001
```

## Ignored Output Root

- `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.md`
- `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- `exp/useful_bd_push/central_replay_20260621_165000_UTC/figures/`

## Committed Tables

- `tables/gate_matrix.csv`
- `tables/validity_funnel.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/metric_deltas_vs_classic.csv`

## Committed Figures

- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`

## Reproducibility Notes

- Repo commit used to generate/package the replay before these docs were
  staged: `912a5e3ae9a6da2a7342fa9c2c64004cf3e180b7`.
- The committed package is recorded by the git commit containing this manifest.
- The descriptor itself is historical and was not refit in this replay.
- The current package is seed-1 development evidence only; it is a control and
  not a promoted method.
