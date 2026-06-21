# VQ-Elites Codebook BD Artifacts Manifest

Status: current replay package for `sr_vq_codebook_qd`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/sr_vq_codebook_qd/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/07_vq_implementation_codebook/method_card.md`
- frozen fitting artifact:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/07_vq_implementation_codebook/fitting_artifacts/sr_vq_codebook_dev_seed1001/sr_vq_codebook_artifact.json`

## Fitting Provenance

- training source:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- training candidates: 205 valid development candidates
- descriptor version: `sr_vq_codebook_v1`
- codebook size: 16
- k-means seed: `20260618`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- codebook hash:
  `393ade44dc56ed7e99cdf563610c270ebc1619741183c2a1c7fb5655c828aa35`
- layout hash:
  `f7d9fe786f7c8e63a356f016f402750ced332bd212cb4472a1e8cd46bf6b407c`
- descriptor hash:
  `a1d9cf5abe52c98e432b35b684261429583dc6f9fed00452b4b633159e54d54b`

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
  --method-name sr_vq_codebook_qd \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T05_vq_elites_codebook_bd
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

This package is the `sr_vq_codebook_qd` replay only. It evaluates a 16-centroid
fixed codebook. Larger codebooks, residual-norm grids, and VQ plus local Pareto
fronts remain future ablations and must not inherit this result without their
own package.
