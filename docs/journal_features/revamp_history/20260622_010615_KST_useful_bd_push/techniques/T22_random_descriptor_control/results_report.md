# Random Descriptor Control Results Report

Status: current replay package for `random_descriptor_qd`.

Tier decision: `T0 control`, required negative comparator.

## Terminology

- `random descriptor`: deterministic pseudo-random coordinates derived from a
  canonical synthesized-netlist hash.
- `negative control`: a method that should not support the final thesis, but
  must be beaten by proposed semantic descriptors.
- `common-audit QD score`: passive archive score on the shared audit grid used
  for cross-method comparisons.

## Setup

This package re-scores the historical seed-1 `random_descriptor_qd`
standard-result artifacts with the current useful-BD metric policy. The
compared methods are classic REvolution, landing Smooth-QD/manual BD, and the
random descriptor control on the same six-problem development subset, seed
`1001`, model `openai/gpt-oss-120b`, and 288 generated candidates per method.

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

| Metric | Classic | Random BD | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1175 | -5.61% |
| Mean best fitness | 0.2671 | 0.2645 | -0.95% |
| HV AUC | 0.0728 | 0.0987 | +35.69% |
| Best-fitness AUC | 0.2327 | 0.2451 | +5.32% |
| Valid-PPA candidates | 209 | 213 | +1.91% |
| PPA-front unique netlists | 12 | 21 | +75.00% |
| Unique canonical netlists | 70 | 64 | -8.57% |
| Unique motif signatures | 43 | 41 | -4.65% |
| Common-audit occupied cells | 12 | 8 | -33.33% |
| Common-audit QD score | 2.3163 | 1.7008 | -26.57% |

Gate 0 passes: random BD covers all six classic-covered problems. The
validity gates are enforced and pass; functionality, synthesis, and valid-PPA
counts are slightly higher than classic.

The important control signal is that random BD is not weak. It has better HV
AUC than classic, two per-problem HV wins, near-classic best quality, more
valid-PPA candidates, and more PPA-front unique netlists. A semantic descriptor
that only beats manual BD is therefore not enough for a persuasive claim.

The reason random BD remains a negative control is equally clear. It loses
final mean HV, common-audit occupied cells, common-audit QD score, unique
canonical netlists, and motif signatures versus classic. Its cell assignment is
also intentionally meaningless and cannot support a hardware-native BD claim.

## Interpretation

Random BD demonstrates how much apparent exploration can come from archive
fragmentation and stochastic parent pressure alone. It raises the bar for
`T04`, `T19`, and future local-Pareto variants: they need to show meaningful
descriptor or archive-coupling value beyond this control.

The control should remain in central tables and figures, but it should never be
promoted even if it wins an isolated metric. Its only role is to falsify weak
BD claims.

## Conclusion

`T22_random_descriptor_control` is a required `T0 control`. It does not answer
the journal question positively, but it makes the research attempt more
rigorous by preventing us from mistaking random archive partitioning for a
useful behavior descriptor.

The next validation matrix for SR-RFF, SR-ReLU, or local-Pareto coupling should
include T22 as a comparator.
