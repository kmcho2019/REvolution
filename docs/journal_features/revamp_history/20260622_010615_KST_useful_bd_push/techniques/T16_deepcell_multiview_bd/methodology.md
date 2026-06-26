# DeepCell Multiview BD Methodology

## Intent

Adapt DeepCell-style multiview post-mapping representation learning to
behavior descriptors. The method should connect standard-cell/post-mapping
features with AIG summaries without requiring a full large-scale pretraining
run before useful diagnostics.

This package is a retrospective proxy audit. It does not reproduce DeepCell
and does not train a paired masked-circuit multiview model.

## Inputs

- T14 directed hypergraph and implementation-feature replay evidence.
- T95 official DeepGate pooled AIG/cone evidence.
- T96 RF/DeepGate hybrid evidence.
- T99 raw implementation-view live evidence.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass/fail labels.

## Proxy Views

| View | Measured Proxy | Source |
| --- | --- | --- |
| Cell or hypergraph view | Directed source-to-sink hypergraph features | T14 |
| AIG view | Official DeepGate pooled transition/cone embeddings | T95 |
| Paired hybrid | RF timing leaf IDs, branching, and DeepGate axis | T96 |
| Implementation view | Comb/adder/cell-count descriptor | T99 |
| Masked multiview training | Not implemented | none |

## Descriptor

The measured proxies are:

- T14 hypergraph plus implementation-feature replay;
- T96 compact live RF/DeepGate hybrid;
- T99 implementation-view live archive coordinates.

These are enough to decide against another simple concatenation, but not
enough to reject a true DeepCell-style learned multiview model.

## Archive Mapping

The live proxy screens use existing delayed high-exploit QD archive settings.
Figures are copied from source packages and source hashes are recorded.

## Leakage Exclusions

The source packages exclude final PPA, reference PPA, hypervolume, Pareto
rank, pass/fail labels, problem identity, and model identity from descriptor
inputs. T16 uses PPA only for retrospective scoring.

## Reopen Rule

Reopen only after paired cell-view and AIG-view extraction exists, or after a
trained masked multiview objective is available in an isolated environment.
