# AutoQD MMD Synthesis BD Results Report

Status: current replay result for `T04_autoqd_mmd_synthesis_bd`.

Tier decision: `T1 near_classic`, validation candidate.

## Setup

This package re-scores the historical seed-1 Auto-BD `sr_rff_pca_qd`
standard-result artifacts with the useful-BD metric policy. The compared
methods are classic REvolution, landing Smooth-QD/manual BD, and the
RFF-PCA synthesis-response descriptor on the same six-problem development
subset, seed `1001`, model `openai/gpt-oss-120b`, and 288 generated candidates
per method.

The central replay source is:

`exp/useful_bd_push/central_replay_20260621_165000_UTC/`

The older 20260618 decision rejected this method for seed-3 promotion under a
stricter "material uplift" rule. Under the current useful-BD tiering, it is a
legitimate near-classic lead because it keeps final HV and best fitness within
2% of classic and improves passive QD score.

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

| Metric | Classic | RFF-PCA | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1229 | -1.24% |
| Mean best fitness | 0.2671 | 0.2630 | -1.53% |
| HV AUC | 0.0728 | 0.0801 | +10.06% |
| Best-fitness AUC | 0.2327 | 0.2340 | +0.59% |
| Valid-PPA candidates | 209 | 197 | -5.74% |
| PPA-front unique netlists | 12 | 20 | +66.67% |
| Unique canonical netlists | 70 | 63 | -10.00% |
| Unique motif signatures | 43 | 43 | 0.00% |
| Common-audit occupied cells | 12 | 10 | -16.67% |
| Common-audit QD score | 2.3163 | 2.8111 | +21.36% |

Gate 0 passes: RFF-PCA covers all six classic-covered problems. The small-n
caveat is not active because classic has 209 passing samples for
functionality, synthesis, and valid PPA. The 50 percent collapse gate is
enforced and passes: all three pass rates decline by 5.74% relative to classic.

Per-problem HV is not better than classic: RFF-PCA ties five problems and loses
one (`RTLLM/Prob011_multi_16bit`). The reason to keep it alive is instead the
combination of near-classic final quality, better anytime HV AUC, much larger
PPA-front unique-netlist count, and higher common-audit QD score.

The main caveat is archive shape. RFF-PCA improves QD score but uses fewer
common-audit occupied cells than classic and has fewer unique canonical
netlists. That means its gain is not "more cells everywhere"; it is better
quality concentration in a smaller passive archive footprint.

## Conclusion

`T04_autoqd_mmd_synthesis_bd` is the strongest packaged lead so far and should
be treated as `T1 near_classic`, not as a finished journal-positive method.
It answers the first research question partially: an automatic descriptor can
come close to classic while improving useful archive evidence. It does not yet
answer the reproducibility question because this package is still seed-1 replay
evidence and does not show per-problem HV wins.

The next step should be a quality-safe validation path rather than immediate
promotion: compare `sr_rff_pca_qd`, `sr_random_relu_pca_qd`, and an ST-NOD plus
RFF hybrid under the same passive archive; if the RFF result survives another
seed or holdout replay, use it as the first candidate for a bounded live run or
for a MOME-style local-Pareto archive.
