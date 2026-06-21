# NetTAG Text-Graph BD Methodology

## Intent

Adapt text-attributed graph netlist modeling to RTL evolution. The method uses
gate graph structure plus short textual attributes so it can capture operator
and Boolean-expression context without relying only on raw RTL embeddings.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Mapped netlist graph from Yosys.
- Node text attributes: gate type, local Boolean expression, cone role,
  source span summary, and optional module-level structural summary.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass labels.

## Preprocessing

1. Generate mapped graph nodes and edges.
2. Build text attributes from canonical non-identifying fields. Strip raw
   signal names unless the ablation explicitly tests name sensitivity.
3. Tokenize text attributes with a fixed tokenizer or hashing vectorizer.
4. Align graph nodes with source spans when available; otherwise record missing
   alignment in the manifest.

## Descriptor

Evaluate a cheap and an escalated variant:

- cheap variant: Weisfeiler-Lehman graph hashes augmented with hashed text
  attributes, followed by TF-IDF or count vectors;
- escalated variant: graph neural network or text-graph transformer trained by
  masked node/text reconstruction over replay candidates.

Pool node embeddings by mean, max, and role-specific histograms. Run collapse
checks against duplicate netlists, graph size, and identifier perturbations.

## Archive Mapping

Use CVT over the pooled text-graph descriptor as the main archive. Use fixed
PCA axes for figures. Also report grid performance over graph-text entropy and
source-span alignment coverage if those axes are interpretable.

## Parent Selection Coupling

Use text-graph cells only for archive coverage. Do not reward natural-language
novelty unless it corresponds to unique canonical netlists and valid designs.

## Dependency Plan

Start with hashing/TF-IDF using existing dependencies. Escalate to learned
text-graph models only after the cheap variant produces a non-collapsed
descriptor or a clear failure needing model capacity.

## Expected Outputs

- `tables/text_graph_schema.csv`
- `tables/text_graph_embeddings.csv`
- `tables/collapse_diagnostics.csv`
- `figures/text_graph_projection.png`
- `figures/name_sensitivity.png`
