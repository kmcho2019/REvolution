# T11 MGVGA Contrastive BD Results Report

Status: completed replay diagnostic.

Tier: `T1 near_classic_replay_lead`, not promoted.

## Method Summary

T11 implements a lightweight MGVGA-style structural contrastive proxy. Full
masked-gate and Verilog-AIG training is not required for this bounded replay:
the descriptor uses RTL count features, T07 graph features, and T14 hypergraph
features, then scores each feature by how well it separates nonmatching
structural keys while keeping duplicate canonical-netlist/motif keys close.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, validity labels, problem id, corpus, model, method, seed, and
candidate id. Structural duplicate keys are used only for self-supervised
feature weighting.

## Primary PPA Figures

The first figures to inspect are direct raw PPA-front views:

- `figures/mgvga_multi_problem_ppa_pareto_fronts.png` overlays all-valid,
  lexical, random, and best T11 selections on four representative raw
  area-power Pareto panels.
- `figures/mgvga_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`.
- `visualizations/direct_ppa_pareto/index.html` is a filesystem-openable
  raw area-power Pareto viewer over the same committed points.

The plotted points are committed in `tables/ppa_front_plot_points.csv` and
mirrored as `visualizations/direct_ppa_pareto/points.json`.

## Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Graph feature source:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Hypergraph feature source:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Candidate rows: 768 total, 682 valid-PPA rows over 114 replay groups.
- Structural keys: 658 unique keys; 153 rows share a duplicate key; 521 rows
  have no canonical-netlist/motif key and are treated as unique unlabeled rows.
- Replay budget: keep 50% of candidates per `(corpus, method, seed, problem)`.
- Controls: lexical farthest-first, random, generation-prefix, and fitness-top.

## Results

| Representation | HV | HV Gain Vs Lexical | Pareto Size | Front Hits | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `fitness_top` | 3.823248 | +3.28% | 300 | 122 | 159 |
| `t11_contrast_top64_farthest` | 3.769259 | +1.82% | 286 | 120 | 186 |
| `t11_contrast_weighted_farthest` | 3.769259 | +1.82% | 286 | 120 | 186 |
| `t11_contrast_top32_farthest` | 3.710703 | +0.24% | 289 | 120 | 185 |
| `lexical_farthest` | 3.701827 | 0.00% | 283 | 122 | 183 |
| `t11_contrast_top16_farthest` | 3.524682 | -4.79% | 288 | 119 | 185 |
| `random` | 3.074167 | -16.96% | 303 | 107 | 166 |

T11 is the strongest L4 replay HV lead so far. Top-64 and weighted
contrastive descriptors select HV `3.769259`, a `+1.82%` gain over lexical.
They also keep unique PPA at `186`, matching T13 and staying below T14's `187`.

The front blocker remains. T11 improves front hits over T14's best hybrid
(`120` versus `119`) and matches T13's `120`, but lexical still keeps `122`.

## Collapse Diagnostics

Top-16 and top-32 reduce same-problem collapse (`0.690104` and `0.721354`) but
do not preserve the full HV signal. Top-64 and weighted variants recover the
HV lead but return to high same-problem collapse (`0.873698`) and high
same-corpus collapse (`0.933594`). The useful signal is therefore still tied
to problem/corpus-like structural size axes.

## Visual Inspection

Manual inspection passed for:

- `mgvga_multi_problem_ppa_pareto_fronts.png`;
- `mgvga_raw_area_power_pareto_front.png`;
- `visualizations/direct_ppa_pareto/index.html`;
- `mgvga_contrastive_hypervolume.png`;
- `contrastive_feature_scores.png`;
- `aligned_embedding_projection.png`;
- `source_graph_agreement.png`.

Notes are in `figures/visual_inspection_notes.md`.

## Conclusion

T11 validates structural contrastive feature selection as a better replay
direction than blind T14 concatenation. It raises HV gain to `+1.82%` over
lexical and recovers one front hit versus T14. It still does not solve the
front-hit blocker, so it remains a `T1 near_classic_replay_lead`, not a
promoted useful-BD method.

The next L4 attempt should keep T11 top-64/weighted as the feature-selection
baseline and add an explicit front-retention archive mechanism or a
problem/corpus-collapse penalty. The next live-budget decision should not be
based on descriptor HV alone.
