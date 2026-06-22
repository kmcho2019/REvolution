# T37 T36 Slot-Count Ablation Methodology

Status: completed replay method.

## Question

T36 found that a very small local area-power Pareto lane can recover useful
front candidates without erasing the T11 contrastive descriptor's HV advantage.
The percentage quotas all collapsed to one retained front slot in the available
groups, so T37 tests the explicit slot-count question: does reserving zero,
one, two, or three local-front slots produce a better replay tradeoff?

## Inputs

- Candidate CSV:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- T07 graph manifest:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- T14 hypergraph features:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Retention fraction: `0.5`, matching T11, T35, and T36.
- Descriptor cell bins: `2` per T11 PCA axis.

## Descriptor

T37 uses the same T11 structural contrastive descriptor as T36. The descriptor
is fitted from RTL count features, T07 standard-cell graph features, and T14
directed-hypergraph features. Canonical netlist and motif duplicate keys weight
features in the T11 contrastive preprocessing.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto rank, validity labels, problem id, corpus, model, method, seed, and
candidate id.

## Archive Retention

For each replay group, T37 keeps the same total number of candidates as T11.
Each T37 arm:

1. selects the first `k - s` candidates from the T11 farthest-first order;
2. fills `s` candidates from descriptor-cell local area-power Pareto order;
3. fills any remaining slots from the T11 farthest-first order.

The tested deployable arms are:

- top-64 T11 descriptor with `0`, `1`, `2`, and `3` local-front slots;
- weighted T11 descriptor with `1` and `2` local-front slots.

PPA is used only after candidate evaluation for archive-retention evidence. It
is not a descriptor input and is not used to fit the structural feature space.

## Controls

T37 is compared against lexical farthest-first, random, fitness-top,
generation-prefix, T11 top-64, T11 weighted, T35 cell-local Pareto, and the T35
front-seeded upper bound. The T35 front-seeded arm remains an upper-bound
diagnostic only.

## Required Artifacts

- `tables/archive_comparison.csv`
- `tables/slot_summary.csv`
- `tables/ppa_front_metrics.csv`
- `tables/ppa_front_plot_points.csv`
- `tables/selected_candidates.csv`
- `figures/t37_hypervolume.png`
- `figures/t37_front_hits.png`
- `figures/t37_multi_problem_ppa_pareto_fronts.png`
- `figures/t37_raw_area_power_pareto_front.png`
- `visualizations/direct_ppa_pareto/index.html`
- `results_report.md`
- `artifacts_manifest.md`

## Tier Rule

T37 can only be promoted above replay-candidate status if one deployable
slot-count arm preserves the T11 HV advantage while improving direct raw PPA
front coverage versus lexical or T11. This replay does not establish a final
useful-BD claim until the selected slot-count is wired into live QD retention.
