# T14 DE-HNN Hypergraph BD Results Report

Status: completed replay diagnostic.

Tier: mixed. `T1 near_classic_replay_lead` for the hypergraph plus
implementation-feature hybrid; `T0 diagnostic` for hypergraph-only
descriptors.

## Method Summary

T14 adapts the DE-HNN idea into a deterministic directed-hypergraph replay.
Each mapped net becomes a hyperedge from driver cells or primary inputs to
sink cells or primary outputs. The descriptors use only non-PPA netlist
structure: fanout buckets, driver/sink role histograms, long-range level
deltas, family-flow hash features, and T13 implementation features for the
hybrid arm.

Descriptor construction excludes final PPA, reference PPA, fitness,
hypervolume, Pareto labels, validity labels, problem id, corpus, model,
method, seed, and candidate id. Those fields are used only after descriptor
selection for scoring and diagnostics.

## Primary PPA Figures

The first figures to inspect are the direct raw PPA-front views:

- `figures/hypergraph_multi_problem_ppa_pareto_fronts.png` overlays all-valid,
  lexical, random, and best T14 selections on four representative raw
  area-power Pareto panels.
- `figures/hypergraph_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`.

The plotted points are committed in `tables/ppa_front_plot_points.csv`.

## Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- T13 implementation feature source:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Candidate rows: 768 total, 682 valid-PPA rows over 114 replay groups.
- Extraction: all 768 candidates parsed; 647 had directed source-to-sink cell
  edges.
- Replay budget: keep 50% of candidates per `(corpus, method, seed, problem)`.
- Controls: lexical farthest-first, random, generation-prefix, and fitness-top.

## Results

| Representation | HV | HV Gain Vs Lexical | Pareto Size | Front Hits | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `fitness_top` | 3.823248 | +3.28% | 300 | 122 | 159 |
| `t14_hyper_impl_combo_farthest` | 3.739236 | +1.01% | 285 | 119 | 187 |
| `lexical_farthest` | 3.701827 | 0.00% | 283 | 122 | 183 |
| `t14_hyper_combo_farthest` | 3.624054 | -2.10% | 289 | 118 | 185 |
| `t14_hyper_hash_farthest` | 3.624054 | -2.10% | 289 | 119 | 185 |
| `t14_hyper_stats_farthest` | 3.614498 | -2.36% | 287 | 119 | 185 |
| `random` | 3.074167 | -16.96% | 303 | 107 | 166 |

The hypergraph-only descriptors are useful diagnostics, not winners. They
increase selected Pareto size and unique PPA points versus lexical, but lose
about `2.1%` to `2.36%` HV and do not recover front hits.

The hybrid `t14_hyper_impl_combo_farthest` preserves most of the T13
implementation-feature HV signal: `3.739236`, or `+1.01%` over lexical. It
improves unique PPA points to `187`, one more than T13 and four more than
lexical. The blocker is still the direct front-hit metric: lexical keeps
`122` all-valid front hits, while the T14 hybrid keeps `119`.

## Collapse Diagnostics

Hypergraph-only descriptors reduce same-problem nearest-neighbor collapse
relative to the T13 raw implementation-feature space. `t14_hyper_hash` has
same-problem fraction `0.690104` and same-corpus fraction `0.783854`.
The hybrid recovers HV but also restores high collapse: same-problem fraction
`0.867188` and same-corpus fraction `0.921875`.

## Visual Inspection

Manual inspection passed for:

- `hypergraph_multi_problem_ppa_pareto_fronts.png`;
- `hypergraph_raw_area_power_pareto_front.png`;
- `dehnn_hypervolume.png`;
- `hypergraph_projection.png`;
- `fanout_entropy_vs_hypervolume.png`.

Notes are in `figures/visual_inspection_notes.md`.

## Conclusion

T14 does not show that directed hypergraph descriptors alone are the missing
BD. Hypergraph-only signals broaden selected PPA counts but lose too much HV
for promotion. The more useful result is the hybrid: adding hypergraph
incidence features to the T13 implementation vector preserves a `+1.01%`
lexical HV gain and increases unique PPA to `187`.

Do not promote T14 as a final useful-BD result because direct front hits still
fall below lexical. The next L4 step should keep the implementation-feature
signal but explicitly optimize feature selection or contrastive training for
front-hit retention, rather than concatenating more structural features.
