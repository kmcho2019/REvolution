# CircuitFusion Multimodal BD Methodology

## Intent

Fuse RTL text, mapped graph structure, and lightweight functional summaries to
test whether multimodal circuit representations are more useful than any
single modality for QD archives.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Canonical RTL text view.
- Mapped graph or AIG view.
- Fixed non-reward functional sketches, such as random-vector output sketches
  or Boolean summaries, generated without comparing to expected outputs.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass/fail labels.

## Preprocessing

1. Produce text, graph, and functional-sketch records for each unique
   canonical netlist.
2. Normalize each modality independently.
3. Record missing modality reasons: text parse, graph conversion, sketch
   timeout, or dependency failure.
4. Freeze train/replay splits before fitting projections.

## Descriptor

Build one descriptor per modality and one fused descriptor:

- text: Qwen or hashed RTL/summary projection with identifier controls;
- graph: motif/pathlet, DeepGate surrogate, or text-graph pooled embedding;
- function: fixed-stimulus output sketch, toggle sketch, or Boolean hash;
- fusion: concatenate normalized modality embeddings, then fit PCA, CCA, or a
  shallow autoencoder using only non-PPA reconstruction or cross-modal losses.

Report modality ablations so a fused win can be explained.

## Archive Mapping

Use CVT over the fused embedding as the primary archive. Use fixed 2D PCA for
figures and compare against single-modality archives with the same cell count.

## Parent Selection Coupling

Only candidates with enough modalities for the frozen descriptor schema can
occupy the multimodal archive. Missing-modality rates are part of the validity
and runtime report.

## Dependency Plan

Start with concatenated deterministic vectors. Escalate to learned fusion only
if deterministic fusion reaches a non-collapsed diagnostic and dependency cost
is justified.

## Expected Outputs

- `tables/modality_manifest.csv`
- `tables/fusion_ablation.csv`
- `tables/missing_modality_funnel.csv`
- `figures/fusion_projection.png`
- `figures/modality_ablation.png`
