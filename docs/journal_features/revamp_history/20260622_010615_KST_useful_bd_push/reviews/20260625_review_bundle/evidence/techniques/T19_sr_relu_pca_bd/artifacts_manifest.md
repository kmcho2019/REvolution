# SR ReLU PCA BD Artifacts Manifest

Status: current replay package for `sr_random_relu_pca_qd`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/sr_random_relu_pca_qd/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/method_card.md`
- previous method config:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/config_random_relu.yaml`
- previous descriptor profile:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile_random_relu.yaml`

## Fitting Provenance

- training source:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- raw feature schema: `synthesis_response_raw_v1`
- descriptor version: `sr_random_relu_pca_v1`
- method family: `synthesis_response_kernel_pca`
- random feature map: ReLU, 128 features, seed `20260618`
- descriptor axes: `sr_pca_0`, `sr_pca_1`, `sr_pca_2`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- random feature map hash:
  `566f32269d2396455718e7a444a5c7aead1a60d52996b3d3f2a4e1b293e46d3a`
- PCA hash:
  `9915d4d7b7bfb4e504949ef6115bf5949f132b0db08b8d4c43c2dc6f905f86b8`
- descriptor hash:
  `5a4c6690deca43d298ec385ad65186fd053f73caef00e29a00e6b4ac6ba6e88a`

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
  --method-name sr_random_relu_pca_qd \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T19_sr_relu_pca_bd
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

This package is the seed-1001 `sr_random_relu_pca_qd` replay only. It does not
claim that SR ReLU PCA is a promoted journal-positive result, and it does not
include a new local-Pareto live run. `/aux` remains read-only source evidence;
any future generated artifacts should be written under `exp/useful_bd_push/`.
