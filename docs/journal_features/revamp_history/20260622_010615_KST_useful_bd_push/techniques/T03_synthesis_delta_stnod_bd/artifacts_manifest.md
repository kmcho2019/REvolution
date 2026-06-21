# Synthesis Delta ST-NOD BD Artifacts Manifest

Status: current replay package for `T03_synthesis_delta_stnod_bd`.

## Scope Caveat

This package reuses the historical `synthesis_trajectory_nod` seed-1
standard-results arm as the base ST-NOD diagnostic. It does not include the
`synthesis_trajectory_motif_nod` hybrid ablation in the committed method-local
tables.

## Source Artifacts

- Historical standard-results root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- Baseline root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results`
- Manual-BD root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results`
- Prior method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/`

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

## Package Command

```bash
.venv/bin/python scripts/package_useful_bd_replay_method.py \
  --central-json exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json \
  --method-name synthesis_trajectory_nod \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T03_synthesis_delta_stnod_bd
```

## Ignored Output Root

- `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.md`
- `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- `exp/useful_bd_push/central_replay_20260621_165000_UTC/figures/`

## Committed Tables

- `tables/gate_matrix.csv`
- `tables/validity_funnel.csv`
- `tables/validity_gate.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/per_problem_ppa_diversity.csv`
- `tables/metric_deltas_vs_classic.csv`
- `tables/descriptor_correlations.csv`

## Committed Figures

- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`
- `figures/seed1_metric_deltas_vs_classic.png`
- `figures/seed1_validity_funnel.png`
- `figures/duplicate_accounting.png`

## Reproducibility Notes

- The central replay report was already generated under
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/`.
- The method-local package was generated from that JSON with the script above.
- The descriptor itself is historical and was not refit in this replay.
- The current package is seed-1 development evidence only and is not promoted.
