# T36 T11 Bounded Front-Lane BD Results Report

Status: completed replay diagnostic.

Tier: `T2 replay_candidate`, not a final useful-BD promotion until live
validation.

## Method Summary

T36 keeps the T11 structural contrastive farthest-first selector and reserves
a bounded local-front lane. For each replay group, most selected candidates
come from the T11 farthest-first order; one candidate is filled from local
area-power Pareto order inside T11 descriptor cells.

The tested `5%` to `20%` quotas collapse to the same one-slot lane under this
common-audit replay surface because each replay group has a small retained
count. That collapse is recorded in `tables/lane_summary.csv` and should not
be described as six independent wins.

## Primary PPA Figures

- `figures/t36_multi_problem_ppa_pareto_fronts.png` shows four raw area-power
  Pareto-front panels with all-valid, lexical, T11, T35, and T36 overlays.
- `figures/t36_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`.
- `visualizations/direct_ppa_pareto/index.html` is a filesystem-openable raw
  area-power Pareto viewer over committed point data.

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
- Retention budget: keep 50% of candidates per group, matching T11 and T35.
- Descriptor cell bins: `2` per T11 PCA axis.

## Results

| Representation | HV | HV Gain Vs Lexical | Front Hits | Front Delta | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `t35_top64_front_seeded` | 3.864198 | +4.39% | 132 | +10 | 171 |
| `t36_top64_lane_05` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `t36_top64_lane_10` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `t36_top64_lane_15` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `t36_top64_lane_20` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `t36_weighted_lane_10` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `t36_weighted_lane_20` | 3.851344 | +4.04% | 126 | +4 | 180 |
| `fitness_top` | 3.823248 | +3.28% | 122 | 0 | 159 |
| `t11_contrast_top64_farthest` | 3.769259 | +1.82% | 120 | -2 | 186 |
| `lexical_farthest` | 3.701827 | 0.00% | 122 | 0 | 183 |
| `t35_top64_cell_pareto` | 3.369630 | -8.97% | 126 | +4 | 162 |
| `random` | 3.074167 | -16.96% | 107 | -15 | 166 |

T36 is the first T11-family replay that aligns the two signals that had been
separate in T11 and T35. It preserves and improves the T11 HV lead
(`3.851344` versus T11's `3.769259`) while recovering direct front hits
(`126` versus T11's `120` and lexical's `122`).

T36 also beats the `fitness_top` control on HV (`3.851344` versus
`3.823248`) while keeping more unique PPA tuples (`180` versus `159`). It does
not beat lexical or T11 on unique PPA breadth: lexical has `183` and T11 has
`186`.

## Visual Inspection

Manual inspection passed for:

- `t36_multi_problem_ppa_pareto_fronts.png`;
- `t36_raw_area_power_pareto_front.png`;
- `t36_hypervolume.png`;
- `t36_front_hits.png`;
- `visualizations/direct_ppa_pareto/index.html`.

Notes are in `figures/visual_inspection_notes.md`. Playwright opened the HTML
viewer from the filesystem and saved
`visualizations/direct_ppa_pareto/screenshot.png`.

## Conclusion

T36 answers the T35 follow-up positively on the replay surface. A one-slot
bounded front lane keeps T11's useful HV pressure while recovering the direct
front-hit deficit. This is stronger than T35 cell-local Pareto replacement and
stronger than T11 farthest-first alone.

The result is not a final QD/MAP-Elites win yet. It is a `T2 replay_candidate`
that should move to bounded live validation or a slot-count ablation. The next
step should test whether the one-slot local-front lane survives a same-budget
live run without using front-seeded upper-bound information and without losing
classic-covered valid-PPA designs.
