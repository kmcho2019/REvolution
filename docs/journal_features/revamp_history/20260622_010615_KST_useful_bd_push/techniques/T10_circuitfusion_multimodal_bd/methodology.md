# CircuitFusion Multimodal BD Methodology

## Intent

Fuse RTL text, mapped graph structure, and lightweight functional summaries to
test whether multimodal circuit representations are more useful than any
single modality for QD archives.

This package is a retrospective proxy audit. It does not reproduce
CircuitFusion and does not train a multimodal hardware foundation model.

## Inputs

- T33 Qwen3 canonical RTL and netlist text-view evidence.
- T95 official DeepGate pooled synthesized-netlist evidence.
- T96 RF/DeepGate hybrid evidence combining RTL-native model-state,
  structural branching, and DeepGate netlist embedding axes.
- T99 raw implementation-feature evidence from the AURORA-style lane.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass/fail labels.

## Proxy Modalities

| Modality | Measured Proxy | Source |
| --- | --- | --- |
| RTL/code text | Qwen3 canonical RTL and netlist embeddings | T33 |
| Synthesized netlist graph | Official DeepGate pooled AIG/cone embeddings | T95 |
| RTL-native model state | MasterRTL RF timing leaf IDs and branching | T83/T96 |
| Implementation structure | Comb/adder/cell-count features | T99 |
| Functional sketch | Not implemented | none |

## Descriptor

The measured fused descriptors are compact concatenations of existing
non-PPA axes:

- T96: `source_aligned_rf_timing_leaf_ids`,
  `source_aligned_masterrtl_branching`, and `deepgate_pool_pc0`.
- T99: `comb_ratio`, `adder_ratio`, and `cell_count_log`.

T96 is the closest multimodal proxy because it combines an RTL-native
pretrained model-state axis, an RTL structural axis, and a synthesized-netlist
encoder axis in a live QD screen.

## Archive Mapping

The live proxy screens use the same delayed high-exploit QD substrate as their
source packages. Figures are copied from source visualizations instead of
recomputing descriptor cells.

## Leakage Exclusions

The source packages exclude final PPA, reference PPA, hypervolume, Pareto
rank, pass/fail labels, problem identity, and model identity from descriptor
inputs. T10 preserves those decisions and uses PPA only for retrospective
scoring.

## Reopen Rule

Reopen T10 only with a real fixed functional-sketch modality, a trained
cross-modal objective, or a secondary archive/reporting role that improves
front creation without replacing classic hill climbing.
