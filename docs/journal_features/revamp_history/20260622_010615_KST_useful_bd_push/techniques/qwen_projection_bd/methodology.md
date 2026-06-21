# Qwen Projection BD Methodology

## Intent

Revisit Qwen3 embeddings without treating raw language embeddings as the final
descriptor. Add hardware-specific projection and collapse controls so the
method can be judged fairly before being rejected.

## Inputs

- Candidate RTL text after canonical formatting.
- Optional Yosys-derived structural summaries written as text.
- Positive and negative pairs from non-PPA relationships:
  same canonical netlist after formatting changes, same benchmark family,
  parent-child structural edits, and different motif/codebook families.
- A fixed Qwen3 embedding model or local compatible checkpoint.

Do not train or select projection heads using final PPA, reference PPA,
fitness, hypervolume, Pareto labels, or test pass labels.

## Preprocessing

1. Strip comments and normalize identifiers for the primary view.
2. Keep a second raw-text view for an ablation.
3. Generate structural summary text with cell families, stage deltas, motif
   counts, and sequential boundary counts.
4. Embed each view with fixed prompt templates and fixed batch settings.
5. Record model name, revision, tokenizer, pooling rule, and max length.

## Descriptor

Compare three descriptors:

- raw Qwen embedding projected by frozen PCA;
- supervised-free projection trained with SimCLR-style positives and negatives
  from structural equivalence and benchmark splits;
- small linear/MLP projection trained to predict non-PPA structural buckets
  such as motif cluster, codebook id, or stage-delta cluster.

Collapse checks are mandatory: embedding norm distribution, pairwise distance
histogram, identifier/comment sensitivity, and duplicate-netlist alignment.

## Archive Mapping

Use 2D PCA/UMAP-for-visualization only for reports. Archive assignment should
use either fixed PCA axes or CVT over 8 to 32 projected dimensions. UMAP must
not be the only archive coordinate unless frozen and justified.

## Parent Selection Coupling

Use projected embedding cells for exploration only. Do not use language-model
similarity as a direct reward. Any live sampling follows a successful replay
or diagnostic result.

## Dependency Plan

If dependencies are missing, first try `uv add` in the project environment.
If that conflicts with the repo, create an isolated `exp/useful_bd_push/envs/`
environment and record the lockfile or install command in the manifest.

## Expected Outputs

- `tables/qwen_embedding_manifest.csv`
- `tables/projection_training.csv`
- `tables/collapse_diagnostics.csv`
- `figures/qwen_projection.png`
- `figures/identifier_sensitivity.png`
