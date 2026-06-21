# Qwen Projection BD Results Report

Status: scaffold only. No experimental tier is assigned yet.

## Pre-Run Framing

The next T06 attempt must not simply rerun raw whole-RTL Qwen embeddings.
Prior diagnostics with `Qwen/Qwen3-Embedding-0.6B` showed real, non-collapsed
embeddings, but also strong same-problem nearest-neighbor clustering and high
identifier sensitivity. The useful-BD question is whether canonical RTL,
Yosys-normalized netlist text, or structural-summary embeddings plus a
hardware-specific projection can produce a better descriptor than lexical
farthest-first or the deterministic T04 RFF-PCA lead.

Report raw Qwen, identifier-normalized Qwen, canonical RTL, Yosys-netlist,
structural-summary, and projected variants separately. Do not collapse them
into one "Qwen worked" or "Qwen failed" conclusion.

## Required Tables

- `tables/validity_funnel.csv`
- `tables/ppa_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/qwen_embedding_manifest.csv`
- `tables/preprocessing_view_manifest.csv`
- `tables/projection_training.csv`
- `tables/collapse_diagnostics.csv`
- `tables/nuisance_axis_diagnostics.csv`
- `tables/runtime.csv`

## Required Figures

- `figures/qwen_projection.png`
- `figures/identifier_sensitivity.png`
- `figures/collapse_distance_histogram.png`
- `figures/ppa_delta_vs_classic.png`

## Conclusion

Pending. The report must separate raw Qwen failures from projection-head
failures and identify whether any variant reaches `T1` or `T2`.
