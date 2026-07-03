# DE-HNN Hypergraph BD Methodology

## Intent

Represent RTL netlists as directed hypergraphs so long-range net interactions
and multi-pin nets are not reduced to ordinary pairwise graph edges. This is a
practical adaptation of DE-HNN-style netlist representation for BD search.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Mapped netlist or post-synthesis JSON with cells, pins, and nets.
- Optional placement-independent net attributes such as fanout count and pin
  roles.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass labels.

## Preprocessing

1. Convert each mapped net into a directed hyperedge from driver pins to sink
   pins.
2. Represent cells as typed nodes with pin-role features.
3. Preserve net direction, fanout, and hierarchy summaries.
4. Assert schema consistency and record extraction failures in the funnel.

## Descriptor

Start with a deterministic hypergraph summary:

- hyperedge fanout buckets;
- directed cut counts across topological levels;
- source/sink role histograms by cell type;
- long-range dependency summaries from level distance and reconvergence;
- hypergraph spectral or incidence-matrix sketch if cheap enough.

Escalate to a small DE-HNN surrogate only if deterministic hypergraph features
produce non-collapsed replay signal. The surrogate may train on masked
node/hyperedge reconstruction or next-level prediction, never on PPA labels.

## Archive Mapping

Use CVT over the hypergraph vector as the main archive. Use a 2D grid over
hyperedge fanout entropy and long-range dependency density for interpretability.

## Parent Selection Coupling

Archive cells guide exploration only. Hypergraph descriptors must be compared
against ordinary motif/pathlet descriptors to justify added complexity.

## Expected Outputs

- `tables/hypergraph_features.csv`
- `tables/extraction_funnel.csv`
- `tables/collapse_diagnostics.csv`
- `figures/hypergraph_projection.png`
- `figures/fanout_entropy_vs_hypervolume.png`

## Completed Replay Route

The completed bounded replay uses the common 768-candidate Qwen audit surface.
It parses each mapped netlist into directed hyperedges, computes deterministic
fanout, role, long-range-level, and family-flow hash features, and replays
50% farthest-first retention against lexical and random controls.

T14 tests four descriptor arms:

- `t14_hyper_stats_farthest`: scalar hypergraph statistics;
- `t14_hyper_hash_farthest`: hashed directed family-flow features;
- `t14_hyper_combo_farthest`: concatenated hypergraph statistics and hashes;
- `t14_hyper_impl_combo_farthest`: hypergraph combo plus the T13
  implementation-feature vector.

Generated primary artifacts:

- `tables/hypergraph_features.csv`;
- `tables/extraction_funnel.csv`;
- `tables/ppa_comparison.csv`;
- `tables/ppa_front_metrics.csv`;
- `tables/ppa_front_plot_points.csv`;
- `figures/hypergraph_multi_problem_ppa_pareto_fronts.png`;
- `figures/hypergraph_raw_area_power_pareto_front.png`.

The completed result separates hypergraph-only signal from the hybrid. The
hypergraph-only arms improve selected PPA breadth but lose HV; the hybrid
preserves a near-classic HV lead but still misses lexical direct front hits.
