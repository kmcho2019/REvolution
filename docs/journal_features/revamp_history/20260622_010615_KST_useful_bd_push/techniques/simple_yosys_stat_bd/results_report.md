# Simple Yosys Stat BD Results Report

Status: current replay result.

Tier decision: `T0 diagnostic`.

## Setup

This package re-scores the historical seed-1 Auto-BD
`simple_yosys_stat_bd` standard-result artifacts with the useful-BD metric
policy. The compared methods are classic REvolution, landing Smooth-QD/manual
BD, and simple Yosys-stat BD on the same six-problem development subset,
seed `1001`, model `openai/gpt-oss-120b`, and 288 candidates per method.

The replay source is:

`/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/`

The central report was generated under:

`exp/useful_bd_push/central_replay_20260621_165000_UTC/`

## Tables

- `tables/gate_matrix.csv`
- `tables/validity_funnel.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/metric_deltas_vs_classic.csv`

## Figures

- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`

Visual inspection notes are in `figures/visual_inspection_notes.md`.

## Key Results

| Metric | Classic | Simple Yosys-stat | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1242 | -0.24% |
| Mean best fitness | 0.2671 | 0.2512 | -5.93% |
| Valid-PPA candidates | 209 | 201 | -3.83% |
| PPA-front unique netlists | 12 | 16 | +33.33% |
| Unique motif signatures | 43 | 45 | +4.65% |
| Common-audit occupied cells | 12 | 11 | -8.33% |
| Common-audit QD score | 2.3163 | 2.0779 | -10.29% |

Gate 0 passes: simple Yosys-stat covers all six classic-covered problems and
does not lose any problem where classic has valid functional PPA. The validity
drop is not catastrophic: valid-PPA rate is 69.79% versus 72.57% for classic.

Per-problem hypervolume is mixed: one win
(`VerilogEval-Spec-to-RTL/Prob030_popcount255`), three ties, and two losses.
The mean hypervolume loss is small enough to be a useful near-miss signal, but
best fitness falls beyond the 2% `T1` tolerance and common-audit QD score is
lower than classic.

## Conclusion

Simple Yosys-stat BD remains a strong simple control and a useful diagnostic
baseline, but it is not promoted. It comes close on mean hypervolume and
slightly increases PPA-front netlist and motif diversity, yet it loses best
fitness and common-audit QD score. Under the current tier policy this is `T0
diagnostic`, not `T1 near_classic`, because the quality loss is too large and
the primary QD metrics are mixed.

Next step: use this as the transparent CAD-native lower bound. A follow-up
should test whether motif/pathlet or synthesis-delta descriptors can keep the
near-classic hypervolume while recovering common-audit QD score and best
fitness.
