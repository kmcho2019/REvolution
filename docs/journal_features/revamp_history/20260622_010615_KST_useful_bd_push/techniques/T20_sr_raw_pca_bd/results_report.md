# SR Raw PCA BD Results Report

Status: current replay package for `sr_raw_pca_qd`.

Tier decision: `T0 diagnostic`, projection ablation near-miss.

## Terminology

- `SR raw PCA`: frozen PCA over PPA-free synthesis-response features with no
  random nonlinear feature map.
- `HV AUC`: area under the generation-by-generation mean-hypervolume curve.
- `common-audit QD score`: passive archive score on the shared audit grid used
  for cross-method comparisons.
- `PPA-front unique netlists`: distinct canonical netlists on the final
  nondominated PPA front after archive retention.

## Setup

This package re-scores the historical seed-1 Auto-BD `sr_raw_pca_qd`
standard-result artifacts with the current useful-BD metric policy. The
compared methods are classic REvolution, landing Smooth-QD/manual BD, and SR
raw PCA on the same six-problem development subset, seed `1001`, model
`openai/gpt-oss-120b`, and 288 generated candidates per method.

The central replay source is:

`exp/useful_bd_push/central_replay_20260621_165000_UTC/`

## Tables

- `tables/gate_matrix.csv`
- `tables/validity_funnel.csv`
- `tables/validity_gate.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/per_problem_ppa_diversity.csv`
- `tables/metric_deltas_vs_classic.csv`
- `tables/descriptor_correlations.csv`

## Figures

- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`
- `figures/seed1_metric_deltas_vs_classic.png`
- `figures/seed1_validity_funnel.png`
- `figures/duplicate_accounting.png`

Visual inspection notes are in `figures/visual_inspection_notes.md`.

## Key Results

| Metric | Classic | SR raw PCA | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1208 | -2.94% |
| Mean best fitness | 0.2671 | 0.2404 | -9.97% |
| HV AUC | 0.0728 | 0.0904 | +24.24% |
| Best-fitness AUC | 0.2327 | 0.2206 | -5.16% |
| Valid-PPA candidates | 209 | 209 | 0.00% |
| PPA-front unique netlists | 12 | 14 | +16.67% |
| Unique canonical netlists | 70 | 74 | +5.71% |
| Unique motif signatures | 43 | 48 | +11.63% |
| Common-audit occupied cells | 12 | 12 | 0.00% |
| Common-audit QD score | 2.3163 | 1.9663 | -15.11% |

Gate 0 passes: SR raw PCA covers all six classic-covered problems. The
validity gates are enforced and pass because functionality, synthesis, and
valid-PPA counts exactly match classic at 209 candidates.

The useful signal is front diversity without validity loss: raw PCA increases
PPA-front unique netlists, unique canonical netlists, and unique motif
signatures, while matching classic common-audit occupied cells. It also has
better HV AUC than classic because it reaches most of its final HV earlier.

The blocking signal is quality and passive QD score. Final mean best fitness is
down by nearly 10%, final mean HV is still below classic, and common-audit QD
score is down by 15.11%. The only per-problem HV win is
`VerilogEval-Spec-to-RTL/Prob030_popcount255`; `RTLLM/Prob011_multi_16bit`
causes the main final-HV loss.

## Interpretation

Raw PCA proves that the synthesis-response feature family carries useful
PPA-front and motif diversity signal without harming validity. It also explains
why the nonlinear variants matter: `T19` SR ReLU keeps the early HV behavior
and turns it into a final-HV lead, while this raw-PCA ablation does not.

This is therefore a near-miss ablation, not a promotion candidate. It should be
kept in the synthesis-response lane as evidence that the descriptor family is
worth pursuing, but raw PCA alone should not be the journal method.

## Conclusion

`T20_sr_raw_pca_bd` partially answers the first research question: simple
PPA-free synthesis-response PCA can broaden front and motif diversity under the
same budget, and it preserves every classic-covered design. It does not answer
the stronger QD/MAP-Elites usefulness question because the quality and passive
QD-score regressions are too large.

The next escalation should use raw PCA as the ablation baseline for SR ReLU,
SR-RFF, and local-Pareto archive coupling. A future method should try to keep
raw PCA's extra front material while recovering quality through the T17-style
local-Pareto parent schedule.
