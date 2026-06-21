# SR Raw PCA BD Artifacts Manifest

Status: current replay package for `sr_raw_pca_qd`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/sr_raw_pca_qd/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/method_card.md`
- previous method config:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/config.yaml`
- previous descriptor profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml`
- frozen fitting artifact:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/fitting_artifacts/sr_raw_pca_dev_seed1001/sr_raw_pca_artifact.json`

## Fitting Provenance

- training source:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- training candidates: 205
- raw feature schema: `synthesis_response_raw_v1`
- descriptor version: `sr_raw_pca_v1`
- method family: `synthesis_response_kernel_pca`
- random feature map: none
- descriptor axes: `sr_pca_0`, `sr_pca_1`, `sr_pca_2`
- explained variance ratio:
  `[0.437099552626324, 0.22443819250404728, 0.1833523891094817]`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- PCA hash:
  `ef2bd4ee1d8532fb765a002aee01fc10d78bd88ce9f77ad8bf3afe722d127257`
- descriptor hash:
  `931edf18e9ec5e3a7b2b8d7996c603c64ec82619f6185ea44cf4803e6105ee1b`

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
  --method-name sr_raw_pca_qd \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T20_sr_raw_pca_bd
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

This package is the seed-1001 `sr_raw_pca_qd` replay only. It does not claim
that raw PCA is a promoted useful BD. `/aux` remains read-only source evidence;
future generated artifacts should be written under `exp/useful_bd_push/`.
