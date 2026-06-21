# Synthesis Delta ST-NOD BD Results Report

Status: current replay result for `T03_synthesis_delta_stnod_bd`.

Tier decision: `T0 diagnostic`, prioritized near-miss.

## Setup

This package re-scores the historical seed-1 Auto-BD
`synthesis_trajectory_nod` standard-result artifacts with the useful-BD metric
policy. The compared methods are classic REvolution, landing Smooth-QD/manual
BD, and base ST-NOD on the same six-problem development subset, seed `1001`,
model `openai/gpt-oss-120b`, and 288 generated candidates per method.

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

| Metric | Classic | ST-NOD | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1208 | -2.94% |
| Mean best fitness | 0.2671 | 0.2511 | -5.98% |
| Valid-PPA candidates | 209 | 205 | -1.91% |
| PPA-front unique netlists | 12 | 13 | +8.33% |
| Unique canonical netlists | 70 | 72 | +2.86% |
| Unique motif signatures | 43 | 52 | +20.93% |
| Common-audit occupied cells | 12 | 11 | -8.33% |
| Common-audit QD score | 2.3163 | -2.0643 | -189.12% |

Gate 0 passes: ST-NOD covers all six classic-covered problems. The small-n
caveat is not active because classic has 209 passing samples for functionality,
synthesis, and valid PPA; the 50 percent collapse gate is enforced. ST-NOD
passes that gate with only a 1.91% relative decline in all three pass rates.

This is a much stronger near-miss than coarse motif occupancy. ST-NOD wins
hypervolume on two problems, ties on three, and loses on one. Final mean
hypervolume is only 2.94% below classic, and the anytime curve shows ST-NOD
ahead of classic at generation 1 before converging near it by the final
generation.

The blocking issue is passive archive quality. ST-NOD increases unique motif
signatures by 20.93% and keeps PPA-grid coverage slightly above classic, but
its common-audit QD score is negative and common-audit occupied cells fall from
12 to 11. That means the descriptor finds more structural variation but does
not place high-quality elites into the common audit archive.

## Conclusion

`T03_synthesis_delta_stnod_bd` is not promoted to `T1` yet. It preserves
classic-covered designs, nearly matches classic hypervolume, and produces the
best deterministic signal so far for structural diversity. However, its mean
HV is still outside the 2% near-classic tolerance, best fitness is down 5.98%,
and the common passive archive score is much worse than classic.

This result should not be retired. It is the first useful lead: synthesis
trajectory features appear to preserve search quality far better than coarse
motif occupancy. The next attempt should hybridize ST-NOD with quality-safe
archive coupling, such as ST-NOD plus Pareto-cell retention or ST-NOD plus a
small motif/pathlet auxiliary axis, while keeping classic exploitation pressure
strong enough to avoid low-quality archive fill.
