# T35 T11 Pareto-Coupled BD Results Report

Status: completed replay diagnostic.

Tier: mixed `T0/T1 diagnostic`, not promoted.

## Method Summary

T35 keeps the T11 structural contrastive descriptor but changes retention.
Descriptor-only arms still use farthest-first selection. The T35 arms use PPA
only after candidate evaluation: local area-power Pareto retention inside T11
descriptor cells, plus one front-seeded passive upper-bound arm.

The front-seeded arm is not a deployable BD by itself. It is included to test
whether the fixed candidate pool contains enough front material when PPA
retention is allowed.

## Primary PPA Figures

- `figures/t35_multi_problem_ppa_pareto_fronts.png` shows four raw area-power
  Pareto-front panels with all-valid, lexical, T11, and T35 overlays.
- `figures/t35_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`.
- `visualizations/direct_ppa_pareto/index.html` is a filesystem-openable raw
  area-power Pareto viewer over the committed point table.

The plotted points are committed in `tables/ppa_front_plot_points.csv` and
mirrored as `visualizations/direct_ppa_pareto/points.json`.

## Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Graph source:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Hypergraph source:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Candidate rows: 768 total, 682 valid-PPA rows over 114 replay groups.
- Retention budget: keep 50% of candidates per group, matching T11.
- Descriptor cell bins: `2` per PCA axis.

## Results

| Representation | HV | HV Gain Vs Lexical | Front Hits | Front Delta | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `t35_top64_front_seeded` | 3.864198 | +4.39% | 132 | +10 | 171 |
| `fitness_top` | 3.823248 | +3.28% | 122 | 0 | 159 |
| `t11_contrast_top64_farthest` | 3.769259 | +1.82% | 120 | -2 | 186 |
| `lexical_farthest` | 3.701827 | 0.00% | 122 | 0 | 183 |
| `t35_top64_cell_pareto` | 3.369630 | -8.97% | 126 | +4 | 162 |
| `t35_weighted_cell_pareto` | 3.369630 | -8.97% | 126 | +4 | 162 |
| `random` | 3.074167 | -16.96% | 107 | -15 | 166 |

The archive-coupled result is mixed. Descriptor-cell local Pareto retention
does recover direct front hits: `126` versus lexical's `122` and T11's `120`.
But it loses too much selected HV (`-8.97%` versus lexical), so it is not a
better replay method.

The front-seeded upper-bound arm reaches full all-valid HV (`3.864198`) and
improves front hits to `132`. This proves the candidate pool has recoverable
front material, but the mechanism uses global area-power front membership
directly and must not be claimed as a deployable BD.

## Visual Inspection

Manual inspection passed for:

- `t35_multi_problem_ppa_pareto_fronts.png`;
- `t35_raw_area_power_pareto_front.png`;
- `t35_hypervolume.png`;
- `t35_front_hits.png`;
- `visualizations/direct_ppa_pareto/index.html`.

Notes are in `figures/visual_inspection_notes.md`.

## Conclusion

T35 answers the T11 follow-up question partially. Local Pareto coupling can
recover raw PPA-front hits, but the simple T11 descriptor-cell version trades
away too much hypervolume and unique PPA breadth. The deployable
cell-Pareto arms are `T0 diagnostic`.

The front-seeded upper bound is useful evidence, not a method claim. It shows
that front recovery is possible within the fixed candidate pool, so the next
attempt should not abandon T11. The next version should use a gentler
front-retention mixture: preserve the T11 farthest/HV selector, then allocate
a small bounded front lane rather than replacing descriptor novelty with local
Pareto retention.
