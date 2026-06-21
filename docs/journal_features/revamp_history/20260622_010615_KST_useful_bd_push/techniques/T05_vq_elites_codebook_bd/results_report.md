# VQ-Elites Codebook BD Results Report

Status: current replay result for `T05_vq_elites_codebook_bd`.

Tier decision: `T0 diagnostic`.

## Setup

This package re-scores the historical seed-1 Auto-BD `sr_vq_codebook_qd`
standard-result artifacts with the useful-BD metric policy. The compared
methods are classic REvolution, landing Smooth-QD/manual BD, and the fixed
16-centroid synthesis-response VQ descriptor on the same six-problem
development subset, seed `1001`, model `openai/gpt-oss-120b`, and 288
generated candidates per method.

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

| Metric | Classic | SR VQ | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1110 | -10.82% |
| Mean best fitness | 0.2671 | 0.2105 | -21.18% |
| HV AUC | 0.0728 | 0.0669 | -8.12% |
| Best-fitness AUC | 0.2327 | 0.1950 | -16.20% |
| Valid-PPA candidates | 209 | 174 | -16.75% |
| PPA-front unique netlists | 12 | 13 | +8.33% |
| Unique canonical netlists | 70 | 45 | -35.71% |
| Unique motif signatures | 43 | 30 | -30.23% |
| Common-audit occupied cells | 12 | 9 | -25.00% |
| Common-audit QD score | 2.3163 | 0.8485 | -63.37% |

Gate 0 passes: SR VQ covers all six classic-covered problems. The small-n
caveat is not active because classic has 209 passing samples for
functionality, synthesis, and valid PPA. The 50 percent collapse gate is
enforced and passes because the method declines by 16.75%, not 50% or more,
on all three pass rates.

The only positive signals are narrow: PPA-front unique netlists increase from
12 to 13, and `VerilogEval-Spec-to-RTL/Prob030_popcount255` has a positive
per-problem HV delta. Those gains are outweighed by worse global HV, worse
best fitness, lower valid-PPA yield, fewer unique canonical netlists, fewer
motif signatures, lower common-audit coverage, and much lower common-audit QD
score.

## Conclusion

`T05_vq_elites_codebook_bd` does not reach `T1`. It is a useful negative
control for the codebook family: a fixed 16-centroid VQ archive can preserve
classic-covered problems, but it fragments parent selection enough to lose PPA
quality and valid-PPA throughput without producing a convincing passive-archive
benefit.

Do not retire all codebook ideas yet. The next codebook attempt should only be
tried as an archive-coupling variant, such as codebook cells with local Pareto
fronts or a residual-norm auxiliary axis, and it should be compared against
the stronger T04 RFF-PCA lead. A direct fixed-codebook descriptor is not a
good live-run candidate under the current evidence.
