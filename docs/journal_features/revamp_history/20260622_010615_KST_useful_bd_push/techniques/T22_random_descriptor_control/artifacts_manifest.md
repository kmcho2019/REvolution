# Random Descriptor Control Artifacts Manifest

Status: current replay package for `random_descriptor_qd`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/method_card.md`
- previous method config:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/config.yaml`
- previous descriptor profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/descriptor_profile.yaml`
- previous accept/reject note:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor/accept_reject.md`

## Descriptor Provenance

- method family: `random_descriptor`
- method arm: `random_descriptor_qd`
- descriptor version: `random_hash_3d`
- fitting protocol: none
- descriptor seed: `20260618_auto_bd_random_descriptor`
- descriptor axes:
  `random_hash_0`, `random_hash_1`, `random_hash_2`
- descriptor source: canonical synthesized-netlist hash
- prompt hash:
  `bc5842520b592ac67ff7cdb6995f1d4d4ab888ce5cfa55621712f367864cadb1`
- source helper:
  `src/revolution/auto_bd/random_descriptor.py`

## Replay Command

```bash
python scripts/report_auto_bd_standard_results.py \
  --run-root /aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1 \
  --output-dir exp/useful_bd_push/central_replay_20260621_165000_UTC \
  --seed 1001
```

## Package Command

```bash
.venv/bin/python scripts/package_useful_bd_replay_method.py \
  --central-json exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json \
  --method-name random_descriptor_qd \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T22_random_descriptor_control
```

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
- `figures/visual_inspection_notes.md`

## Scope Caveat

This package documents the random descriptor as a required negative control. It
must not be cited as a meaningful behavior descriptor or final journal method.
