# T10 CircuitFusion Multimodal BD

Status: `T0 retrospective_multimodal_proxy_not_promoted`.

This package closes the CircuitFusion-style scaffold with measured proxy
evidence from adjacent text, graph, RTL-native, netlist-encoder, and
implementation-feature experiments. It does not claim a true CircuitFusion
reproduction.

## Scope

The original target was a multimodal descriptor over:

- RTL text or summary embeddings;
- mapped graph or AIG embeddings;
- fixed functional sketches;
- fused non-PPA embeddings.

The current branch has measured the first two families and several structural
or implementation-feature hybrids, but it has not implemented fixed functional
sketch descriptors. The decision is therefore about the cheap multimodal proxy
path, not the full CircuitFusion method.

## Decision

Do not spend on exact primary multimodal proxy archive axes. The strongest
measured hybrid, T96 RF/DeepGate, improves over pure DeepGate but remains below
classic and below its closest RF-only sibling. T99 raw implementation features
are also below classic. A full CircuitFusion-style continuation would need a
new functional-sketch modality or trained cross-modal objective, not another
plain concatenation of existing axes.

## Key Files

- [methodology.md](methodology.md): frozen proxy methodology and leakage rules.
- [results_report.md](results_report.md): evidence and promotion decision.
- [tables/t10_multimodal_proxy_evidence.csv](tables/t10_multimodal_proxy_evidence.csv):
  compact evidence table.
- [figures/](figures/): copied source figures and visual inspection notes.
