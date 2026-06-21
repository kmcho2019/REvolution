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

Do not make raw full-file text the primary descriptor. Prior Qwen3 diagnostics
showed raw/comment-stripped embeddings were stable, but nearest neighbors were
mostly same-problem and identifier normalization changed the embedding space
substantially. The next attempt should therefore embed normalized design views
and then learn or fit a hardware-specific projection.

Use three frozen text views:

1. `canonical_rtl_view`: strip comments and non-semantic whitespace, format the
   parsed module deterministically, normalize generated identifiers to
   role-based names, preserve port names only as roles, and keep widths,
   signedness, operators, always/assign structure, clock/reset polarity, and
   parameter values.
2. `yosys_netlist_view`: run a fixed non-PPA Yosys normalization script, then
   write a canonical gate/netlist text where cells are sorted by topological
   level and each row records cell type, input roles, output role, bit width,
   fanout bucket, and sequential boundary tag. Strip attributes and generated
   temporary names.
3. `structural_summary_view`: write a compact deterministic summary with
   module I/O shape, operator histogram, cell-family histogram, stage-delta
   buckets, motif ratios, pathlet/reconvergence counts, sequential-state
   counts, and optional fixed random-simulation sketches. Exclude PPA,
   reference PPA, fitness, hypervolume, Pareto labels, and pass/fail labels.

For large designs, chunk each view at stable syntactic boundaries, embed the
chunks with the same prompt and tokenizer settings, L2-normalize chunk
embeddings, and pool to a whole-design embedding by deterministic weighted
mean. Weights are PPA-free counts such as token count, cell count, or signal
count. Record the chunk policy, max characters, truncation count, model id,
revision, tokenizer, pooling rule, and embedding hashes.

## Descriptor

Compare three descriptors:

- frozen PCA/whitened PCA over the pooled embeddings from each view;
- contrastive projection trained with positives from same-candidate view pairs,
  same canonical-netlist duplicates, and deterministic formatting
  augmentations, with negatives from different canonical netlists and different
  structural clusters;
- small linear projection trained only on non-PPA structural buckets such as
  motif cluster, codebook id, stage-delta cluster, or sequential-state bucket.

Extract behavior descriptors from the projected space, not the raw language
embedding. Candidate BD choices are:

- CVT over 8, 16, or 32 projected dimensions;
- 2D grid over the first two leakage-checked PCA axes;
- hybrid grid pairing one Qwen projection axis with one deterministic
  synthesis-response axis from T03/T04.

Collapse checks are mandatory: embedding norm distribution, pairwise distance
histogram, identifier/comment sensitivity, raw-vs-canonical stability,
same-problem nearest-neighbor fraction, duplicate-netlist alignment, and
correlation with text length, identifier churn, canonical-netlist hash,
motif-signature hash, and problem id.

## Archive Mapping

Use 2D PCA/UMAP-for-visualization only for reports. Archive assignment should
use either fixed PCA axes or CVT over 8 to 32 projected dimensions. UMAP must
not be the only archive coordinate unless frozen and justified.

## Current Diagnostic Scope

The completed `T06` package does not yet run the full normalized-view
projection method above. It packages the prior Qwen common-audit diagnostic as
the first learned/projection evidence point:

- model: `Qwen/Qwen3-Embedding-0.6B`;
- corpus: 768 valid-PPA candidates across 127 problems;
- views: raw RTL, comment-stripped RTL, and identifier-normalized RTL;
- selection replay: farthest-first retention at 50% selection fraction,
  compared with lexical farthest-first, random, generation-prefix, and
  fitness-top controls;
- leakage policy: Qwen and lexical selection use only RTL text/features; PPA
  fields are used only after selection for replay evaluation.

This scope is enough to decide whether raw or identifier-normalized whole-RTL
Qwen embeddings are promising as-is. It is not enough to reject the planned
canonical RTL, Yosys-netlist, structural-summary, or projection-head variants.

## Parent Selection Coupling

Use projected embedding cells for exploration only. Do not use language-model
similarity as a direct reward. Any live sampling follows a successful replay
or diagnostic result.

## Dependency Plan

If dependencies are missing, first try `uv add` in the project environment.
If that conflicts with the repo, create an isolated `exp/useful_bd_push/envs/`
environment and record the lockfile or install command in the manifest.

The prior diversity-check run used an isolated Qwen environment successfully,
so dependency friction is not a valid stopping point for T06 unless the new
embedding model or tokenizer fails in both the repo environment and an
isolated uv environment.

## Expected Outputs

- `tables/qwen_embedding_manifest.csv`
- `tables/projection_training.csv`
- `tables/collapse_diagnostics.csv`
- `figures/qwen_projection.png`
- `figures/identifier_sensitivity.png`
