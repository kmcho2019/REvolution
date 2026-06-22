# T35 T11 Pareto-Coupled BD Methodology

## Intent

T11 improved replay hypervolume but still missed lexical direct PPA-front
hits. T35 tests whether the missing piece is archive coupling rather than the
descriptor itself: keep the T11 structural contrastive descriptor, then retain
evaluated candidates with bounded local Pareto pressure.

## Descriptor Inputs

The descriptor is inherited from T11:

- RTL count features;
- T07 standard-cell graph features;
- T14 directed-hypergraph features;
- structural duplicate keys only for self-supervised feature weighting.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, validity labels, problem id, corpus, model, method, seed, and
candidate id.

## Archive Coupling

T35 uses PPA only after candidates are evaluated, as archive retention
evidence. It does not feed PPA into the behavior descriptor.

The replay compares:

- T11 descriptor-only farthest-first controls;
- `t35_top64_cell_pareto`: T11 top-64 descriptor cells with local
  area-power Pareto retention;
- `t35_weighted_cell_pareto`: weighted T11 descriptor cells with local
  area-power Pareto retention;
- `t35_top64_front_seeded`: passive front-seeded upper-bound diagnostic that
  keeps global area-power front candidates first, then fills by T11 novelty.

The front-seeded arm is not a deployable BD by itself. It is included to show
how much front material is recoverable from the fixed candidate pool when PPA
retention is allowed.

## Fixed Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Graph source:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Hypergraph source:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Retention fraction: `0.5`.
- Random seed: `0`.
- Descriptor cell bins: `2` per PCA axis.

## Primary Metrics

- selected hypervolume;
- selected all-valid raw area-power front hits;
- selected Pareto size;
- unique PPA points;
- unique canonical netlists and motif signatures;
- direct raw PPA-front visual inspection.

## Expected Artifacts

- `tables/archive_comparison.csv`
- `tables/ppa_front_metrics.csv`
- `tables/ppa_front_plot_points.csv`
- `figures/t35_multi_problem_ppa_pareto_fronts.png`
- `figures/t35_raw_area_power_pareto_front.png`
- `visualizations/direct_ppa_pareto/index.html`

## Tier Policy

T35 can be at most `T1 near_classic_replay_lead` from this replay alone.
Promotion requires a live same-budget run because the archive-coupled arms use
post-evaluation PPA retention.
