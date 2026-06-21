# ST-NOD Motif Hybrid BD Artifacts Manifest

Status: current replay package for `synthesis_trajectory_motif_nod`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/method_card.md`
- previous method config:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/config_motif_trajectory.yaml`
- previous ablation report:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/seed1_hybrid_ablation_report.md`
- previous accept/reject note:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/hybrid_ablation_accept_reject.md`

## Descriptor Provenance

- method family: `synthesis_trajectory_nod`
- method arm: `synthesis_trajectory_motif_nod`
- descriptor version: `stnod_motif_trajectory_9d`
- fitting protocol: none
- descriptor axes:
  `motif_logic_ratio`, `motif_control_ratio`, `motif_arith_ratio`,
  `motif_diversity`, `stnod_cell_growth_log`, `stnod_logic_swing`,
  `stnod_control_swing`, `stnod_arith_swing`, `stnod_diversity_swing`
- prompt hash:
  `3af8243082b5475af5c6bd22da7afc9af3ffeb72bcba1be9798d6c3ad51feb73`
- source helpers:
  `src/revolution/auto_bd/motif_descriptor.py`,
  `src/revolution/auto_bd/stage_dumps.py`, and
  `src/revolution/auto_bd/trajectory_descriptor.py`

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
  --method-name synthesis_trajectory_motif_nod \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T21_stnod_motif_hybrid_bd
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

This package is the seed-1001 hybrid replay only. It documents the ablation in
the current useful-BD surface; it does not override the earlier decision that
trajectory-only ST-NOD is the simpler deterministic control.
