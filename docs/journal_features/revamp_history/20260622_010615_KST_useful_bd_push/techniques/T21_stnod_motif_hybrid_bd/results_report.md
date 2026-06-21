# ST-NOD Motif Hybrid BD Results Report

Status: current replay package for `synthesis_trajectory_motif_nod`.

Tier decision: `T0 diagnostic`, archive-coverage ablation.

## Terminology

- `ST-NOD`: synthesis-trajectory netlist-observation descriptor; it uses
  Yosys stage snapshots to describe synthesis-response behavior.
- `ST-NOD+motif`: the 9D ablation that concatenates final motif ratios with
  five ST-NOD trajectory axes.
- `common-audit occupied cells`: number of cells occupied in the shared passive
  audit grid.
- `common-audit QD score`: quality-diversity score on that same audit grid.

## Setup

This package re-scores the historical seed-1
`synthesis_trajectory_motif_nod` standard-result artifacts with the current
useful-BD metric policy. The compared methods are classic REvolution, landing
Smooth-QD/manual BD, and ST-NOD+motif on the same six-problem development
subset, seed `1001`, model `openai/gpt-oss-120b`, and 288 generated candidates
per method.

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

| Metric | Classic | ST-NOD+motif | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1204 | -3.28% |
| Mean best fitness | 0.2671 | 0.2380 | -10.90% |
| HV AUC | 0.0728 | 0.0903 | +24.09% |
| Best-fitness AUC | 0.2327 | 0.2221 | -4.54% |
| Valid-PPA candidates | 209 | 198 | -5.26% |
| PPA-front unique netlists | 12 | 20 | +66.67% |
| Unique canonical netlists | 70 | 77 | +10.00% |
| Unique motif signatures | 43 | 45 | +4.65% |
| Common-audit occupied cells | 12 | 16 | +33.33% |
| Common-audit QD score | 2.3163 | 1.7144 | -25.98% |

Gate 0 passes: ST-NOD+motif covers all six classic-covered problems. The
validity collapse gate is enforced and passes; functionality, synthesis, and
valid-PPA counts decline by 5.26%, far below the 50% collapse threshold.

The positive signal is broad coverage. ST-NOD+motif has the largest
PPA-front unique-netlist count among the packaged deterministic descriptors so
far, and it occupies four more common-audit cells than classic.

The blocking signal is quality concentration. Final best fitness drops by
10.90%, final HV drops by 3.28%, and common-audit QD score drops by 25.98%.
The method has no per-problem HV wins versus classic; it ties five problems and
loses `RTLLM/Prob011_multi_16bit`.

## Interpretation

T21 confirms that simple descriptor concatenation can illuminate more archive
cells and front families, but those extra cells are not high enough quality.
This supports the user's concern that QD methods need an explicit way to keep
hill-climbing pressure while preserving diversity. The result points toward
local Pareto fronts and quality-safe parent schedules rather than wider
hand-concatenated descriptors.

Against trajectory-only ST-NOD, the hybrid also loses valid-PPA count, final
best fitness, and final HV. It should therefore remain an ablation, consistent
with the older 20260618 accept/reject note.

## Conclusion

`T21_stnod_motif_hybrid_bd` satisfies the minimum package-count requirement by
adding a real tenth current result package, but it is not a promotion
candidate. It answers the deterministic-descriptor question in a useful way:
adding motif axes can broaden archive/front coverage, yet breadth alone is not
enough when passive QD score and quality fall.

The next deterministic follow-up should not concatenate more axes blindly. Use
feature selection, CVT, or local-Pareto archive coupling if this family is
continued.
