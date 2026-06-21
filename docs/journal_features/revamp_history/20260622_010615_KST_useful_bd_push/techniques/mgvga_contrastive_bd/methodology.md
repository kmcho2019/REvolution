# MGVGA Contrastive BD Methodology

## Intent

Use masked gate and Verilog-to-AIG alignment objectives to learn descriptors
that connect source edits to mapped implementation structure. This tests
whether alignment training can avoid the collapse seen in raw text or graph
embeddings.

## Inputs

- Candidate RTL text.
- Mapped AIG or netlist graph.
- Source-to-graph alignment hints from Yosys names, source spans, or cone
  membership when available.
- Replay corpus of unique canonical netlists.

Training excludes final PPA, reference PPA, fitness, hypervolume, Pareto
labels, and functional pass/fail labels.

## Preprocessing

1. Convert each candidate to a mapped graph/AIG.
2. Build approximate alignments from RTL statements to graph cones.
3. Create paired views: Verilog tokens, graph nodes, masked token spans, and
   masked gate neighborhoods.
4. Record alignment coverage and missing-alignment reasons.

## Descriptor

Train or approximate three self-supervised objectives:

- masked gate prediction from graph context;
- masked Verilog token/span prediction from source context;
- contrastive alignment between source spans and graph cones from the same
  candidate versus negatives from other candidates.

Pool graph/source embeddings into candidate descriptors. If full training is
too expensive, use a lightweight projection over existing text and graph
features with the same positive/negative construction.

## Archive Mapping

Use CVT over the aligned embedding as the primary archive. For figures, show
source-view, graph-view, and fused-view projections side by side.

## Parent Selection Coupling

Use the learned descriptor only for archive cell assignment. Alignment loss or
masked-model loss is not an optimization objective.

## Dependency Plan

Start with a small corpus and bounded epochs. If dependencies fail, try
isolated `uv` or source checkout under `exp/useful_bd_push/envs/`. Record full
training and blocked attempts in the manifest.

## Expected Outputs

- `tables/alignment_coverage.csv`
- `tables/contrastive_training.csv`
- `tables/collapse_diagnostics.csv`
- `figures/aligned_embedding_projection.png`
- `figures/source_graph_agreement.png`
