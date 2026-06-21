# AutoQD MMD Synthesis BD Artifacts Manifest

Status: current replay package for `sr_rff_pca_qd`.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- source run root:
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/sr_rff_pca_qd/seed_1001/standard_results`
- previous method card:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/method_card.md`
- frozen fitting artifact:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/fitting_artifacts/sr_rff_pca_dev_seed1001/sr_rff_pca_artifact.json`

## Fitting Provenance

- training source:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- training candidates: 205 valid development candidates
- raw feature schema: `synthesis_response_raw_v1`
- descriptor version: `sr_rff_pca_v1`
- random feature map: RFF, 128 features, seed `20260618`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- random feature map hash:
  `e5982aa2a4ab4fb15a556f6a313c84305ed06b40466b42780406692ae8799dc2`
- PCA hash:
  `20504a27892706765c1c48abc493cdd5d06d0c2366321fcadc87ec08d8708446`
- descriptor hash:
  `cef74673a3136470e1ec3f14613f6f2160d6b6e2ad90f10615bce83c6423a09c`
- explained variance ratio:
  `[0.1923650880473621, 0.17299119210380623, 0.16588050097890297]`

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
  --method-name sr_rff_pca_qd \
  --technique-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T04_autoqd_mmd_synthesis_bd
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

This package is the `sr_rff_pca_qd` replay only. It does not include the
`sr_raw_pca_qd` or `sr_random_relu_pca_qd` ablations, and it does not claim a
full AutoQD MMD objective. Those variants should be packaged separately if
needed for the negative map or for a seed-3 validation screen.
