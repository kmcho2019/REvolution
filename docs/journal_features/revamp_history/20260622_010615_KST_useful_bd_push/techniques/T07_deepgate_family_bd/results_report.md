# T07 DeepGate-Family BD Results Report

Status: completed replay diagnostic.

Tier: `T1 near_classic_replay_lead`, not a promoted useful-BD win.

## Method Summary

T07 tested a DeepGate-family graph route after earlier DeepGate3 probes showed
that the full checkpoint path was not yet reliable for a full 768-candidate
replay. The completed run therefore uses a standard-cell graph surrogate:
parse each synthesized netlist into a directed cell graph, encode it with
Weisfeiler-Lehman-style hashed colors plus graph statistics, and replay
farthest-first descriptor retention on the same common audit surface used by
T33/T34.

The descriptor excludes final PPA, reference PPA, fitness, hypervolume, Pareto
rank, validity labels, problem id, and corpus id. PPA and labels are used only
after selection for scoring and diagnostics.

## Primary PPA Figures

The first result to inspect is the direct raw PPA Pareto geometry:

- `figures/deepgate_multi_problem_ppa_pareto_fronts.png` shows four
  representative raw area-power Pareto panels with conventional axes, all-valid
  fronts, lexical/random controls, and the best graph-combo descriptor.
- `figures/deepgate_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`, the richest focus group.

The plotted raw points are committed in `tables/ppa_front_plot_points.csv`.
This is deliberate: embedding projections and HV bars are not substitutes for
the actual PPA-front shape.

## Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Candidate rows: 768 total, 682 valid-PPA rows over 114 problem groups.
- Replay budget: keep 50% of candidates per `(corpus, method, seed, problem)`.
- Controls: lexical farthest-first, random, generation-prefix, and fitness-top.
- T07 variants:
  `t07_graph_wl_farthest`, `t07_graph_stats_farthest`, and
  `t07_graph_combo_farthest`.

## Dependency Evidence

The prior DeepGate3 AIG probe reached only a tiny usable sample: 9 AIG exports,
6 latch-free parses, and 3 latch-bearing rejects. The prior tokenizer probe
produced nearly collapsed embeddings with pairwise cosine mean `0.999970734`.
The current isolated environment imports `deepgate 2.0.1` and `torch`, but not
`deepgate3` or `dgl`. For this replay, T07 records that blocker and uses the
standard-cell graph surrogate over all 768 synthesized netlists instead of
claiming a full DeepGate checkpoint result.

## Results

| Representation | HV | HV Gain Vs Lexical | Pareto Size | Front Hits | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `fitness_top` | 3.823248 | +3.28% | 300 | 122 | 159 |
| `t07_graph_wl_farthest` | 3.704413 | +0.07% | 285 | 120 | 185 |
| `t07_graph_combo_farthest` | 3.704413 | +0.07% | 285 | 120 | 185 |
| `lexical_farthest` | 3.701827 | 0.00% | 283 | 122 | 183 |
| `t07_graph_stats_farthest` | 3.585724 | -3.14% | 286 | 117 | 185 |
| `generation_prefix` | 3.155186 | -14.77% | 303 | 110 | 163 |
| `random` | 3.074167 | -16.96% | 303 | 107 | 166 |

`t07_graph_wl_farthest` and `t07_graph_combo_farthest` are the useful signal:
they barely beat lexical HV, preserve the best fitness found by `fitness_top`,
and improve unique PPA points from 183 to 185. They also beat random by a wide
margin on HV.

The front evidence is weaker. Lexical keeps 122 all-valid front hits; the graph
WL/combo variants keep 120. The graph variants therefore should not be claimed
as a broader Pareto-front win even though they have a tiny HV and unique-PPA
edge.

## Collapse Diagnostics

| Representation | Same Problem | Same Corpus | Same Netlist | Same Motif |
| --- | ---: | ---: | ---: | ---: |
| `t07_graph_wl_farthest` | 0.635417 | 0.761719 | 0.694010 | 0.723958 |
| `t07_graph_stats_farthest` | 0.734375 | 0.792969 | 0.705729 | 0.735677 |
| `t07_graph_combo_farthest` | 0.720052 | 0.785156 | 0.707031 | 0.736979 |

Compared with the Qwen whole-design probes, the graph surrogate reduces
same-problem nearest-neighbor collapse materially. However, the reduced
collapse does not yet translate into direct front-hit superiority.

## Visual Inspection

Manual inspection passed for:

- `deepgate_multi_problem_ppa_pareto_fronts.png`;
- `deepgate_raw_area_power_pareto_front.png`;
- `deepgate_surrogate_hypervolume.png`;
- `deepgate_projection.png`;
- `graph_size_vs_embedding.png`.

Notes are in `figures/visual_inspection_notes.md`.

## Conclusion

T07 gives a real L4 signal but not a final claim. The graph WL/combo descriptor
is a near-classic replay lead because it slightly improves selected HV over
lexical, improves unique PPA points, avoids the extreme Qwen-style
same-problem collapse, and remains far above random. It is not a promoted
useful-BD result because the direct raw PPA-front accounting is slightly worse
than lexical on all-valid front hits and the run is still a replay surrogate,
not a live MAP-Elites/QD optimization.

Next step: do not spend live budget on this exact surrogate alone. Use it as
evidence that graph-structured encoders are worth a stronger attempt: either a
true DeepGate/AIG dependency path in an isolated environment or a small
contrastive/fine-tuned graph encoder that explicitly rewards implementation
family and PPA-front separation without leaking final PPA into descriptor
construction.
