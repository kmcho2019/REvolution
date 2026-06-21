# Motif Pathlet BD Results Report

Status: current replay result for `T02_motif_pathlet_bd`.

Tier decision: `T0 diagnostic`.

## Setup

This package re-scores the historical seed-1 Auto-BD
`netlist_motif_occupancy` standard-result artifacts with the useful-BD metric
policy. It is recorded under the broader motif/pathlet family because it is
the first deterministic motif-structure member, but it only evaluates the
four-axis motif-occupancy descriptor, not the full pathlet/SVD/CVT method.

The compared methods are classic REvolution, landing Smooth-QD/manual BD, and
netlist motif occupancy on the same six-problem development subset, seed
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

| Metric | Classic | Motif occupancy | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.0606 | -51.35% |
| Mean best fitness | 0.2671 | 0.2350 | -12.00% |
| Valid-PPA candidates | 209 | 192 | -8.13% |
| PPA-front unique netlists | 12 | 13 | +8.33% |
| Unique motif signatures | 43 | 37 | -13.95% |
| Common-audit occupied cells | 12 | 8 | -33.33% |
| Common-audit QD score | 2.3163 | -3.0274 | -230.70% |

Gate 0 passes: motif occupancy covers all six classic-covered problems. The
small-n caveat is not active here because classic has 209 passing samples for
functionality, synthesis, and valid-PPA; the 50 percent collapse gate is
enforced. Motif occupancy passes that validity gate with an 8.13% relative
decline in functionality/synthesis/valid-PPA rate, well below the 50 percent
collapse threshold.

The quality and archive evidence is weak. Mean hypervolume falls by 51.35% and
mean best fitness falls by 12.00%. Common-audit occupied cells fall from 12 to
8, and common-audit QD score becomes negative. The only positive signal is a
small increase in PPA-front unique netlists from 12 to 13, which is not enough
to offset the loss in primary QD and PPA metrics.

Per-problem hypervolume has one win
(`VerilogEval-Spec-to-RTL/Prob021_mux256to1v`), three ties, and two losses.
The large loss on `RTLLM/Prob019_sub_64bit` dominates the mean HV result and
suggests the descriptor over-pressures motif occupancy on at least one larger
arithmetic problem.

## Conclusion

`T02_motif_pathlet_bd` is not promoted. The partial motif-occupancy replay is a
valid and interpretable deterministic netlist descriptor, but it does not reach
`T1 near_classic`: HV and best fitness regress too much, common-audit coverage
and QD score are worse than classic, and the extra PPA-front netlist is too
small to support a useful-BD claim.

The result is still useful because it narrows the design space. Coarse motif
ratios are not enough by themselves. The next motif-family attempt should add
pathlets/reconvergence or combine motif axes with synthesis-trajectory deltas
before retrying archive pressure.
