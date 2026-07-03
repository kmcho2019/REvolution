# T36 T11 Bounded Front-Lane BD Methodology

Status: completed replay method.

## Question

T35 showed that T11 descriptor cells contain recoverable raw PPA-front
material, but replacing T11 novelty retention with full cell-local Pareto
retention loses too much HV. T36 tests the gentler hypothesis: keep most of
T11's contrastive farthest-first selector, then reserve only a small fixed
quota for local descriptor-cell Pareto candidates.

## Inputs

- Candidate CSV:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- T07 graph manifest:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- T14 hypergraph features:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Retention fraction: `0.5`, matching T11 and T35.
- Descriptor cell bins: `2` per T11 PCA axis.

## Descriptor

T36 inherits the T11 structural contrastive feature ranking. The descriptor
inputs are RTL count features, T07 standard-cell graph features, and T14
directed-hypergraph features. Self-supervised duplicate keys from canonical
netlist and motif hashes weight features, as in T11.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto rank, validity labels, problem id, corpus, model, method, seed, and
candidate id.

## Archive Retention

For each replay group, T36 keeps the same total number of candidates as T11.
Each bounded-lane arm:

1. selects the first `k - q` candidates from the T11 farthest-first order;
2. fills `q` candidates from descriptor-cell local area-power Pareto order;
3. fills any remaining slots from the T11 farthest-first order.

The tested front-lane quotas are:

- top-64 T11 descriptor: `5%`, `10%`, `15%`, and `20%`;
- weighted T11 descriptor: `10%` and `20%`.

PPA is used only after candidate evaluation for archive-retention evidence. It
is not a descriptor input and is not used to fit the T11 feature space.

## Controls

T36 is compared against lexical farthest-first, random, fitness-top,
generation-prefix, T11 top-64, T11 weighted, T35 cell-local Pareto, and the
T35 front-seeded upper bound. The T35 front-seeded arm remains an upper-bound
diagnostic only.

## Required Artifacts

- `tables/archive_comparison.csv`
- `tables/ppa_front_metrics.csv`
- `tables/ppa_front_plot_points.csv`
- `tables/selected_candidates.csv`
- `figures/t36_multi_problem_ppa_pareto_fronts.png`
- `figures/t36_raw_area_power_pareto_front.png`
- `visualizations/direct_ppa_pareto/index.html`
- `results_report.md`
- `artifacts_manifest.md`

## Tier Rule

T36 can only be promoted above `T0` if at least one deployable bounded-lane arm
preserves T11's HV advantage while improving direct front hits versus lexical
or T11. The T35 front-seeded arm cannot by itself support promotion.
