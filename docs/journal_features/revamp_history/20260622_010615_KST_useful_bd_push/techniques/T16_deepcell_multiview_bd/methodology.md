# DeepCell Multiview BD Methodology

## Intent

Adapt DeepCell-style multiview post-mapping representation learning to
behavior descriptors. The method should connect standard-cell/post-mapping
features with AIG summaries without requiring a full large-scale pretraining
run before useful diagnostics.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Post-mapping netlist view from the fixed synthesis flow.
- AIG view from ABC or Yosys.
- Optional random-simulation logic probability sketches generated without
  comparing to expected test outputs.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass/fail labels.

## Preprocessing

1. Generate paired post-mapping and AIG views for each candidate.
2. Extract cell-view features: standard-cell/gate type, level, fanin/fanout,
   local cone type, and structural embedding fallback.
3. Extract AIG-view features: node type, inversion, level, reconvergence, and
   cone membership.
4. Record pairability failures in a missing-view funnel.

## Descriptor

Evaluate:

- deterministic multiview concatenation of cell and AIG summaries;
- masked-circuit surrogate that reconstructs masked cell-view summaries from
  AIG context;
- small fused embedding trained on reconstruction only.

Compare against AIG-only, post-mapping-only, and fused views. Report whether
the fused view improves descriptor/PPA alignment or only adds runtime.

## Archive Mapping

Use CVT over fused embeddings as primary. Use 2D PCA only for visualization and
grid diagnostics.

## Parent Selection Coupling

Only pairable candidates can occupy the multiview archive. Missing-view rates
must be reported so dependency/runtime cost is visible.

## Expected Outputs

- `tables/multiview_pairing_funnel.csv`
- `tables/multiview_features.csv`
- `tables/view_ablation.csv`
- `figures/multiview_projection.png`
- `figures/view_ablation.png`
