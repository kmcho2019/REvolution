# Qwen3 Preprocessing Ladder BD Results Report

Status: pre-registered method package.

Tier decision: pending. No result is claimed yet.

## Why This Exists

T06 should not be treated as a complete rejection of Qwen-style descriptors.
It rejected raw and identifier-normalized whole-file embeddings as direct BDs:
they carried some hypervolume signal, but nearest neighbors were dominated by
same-problem and same-corpus clustering.

T33 is the planned escalation: normalize the RTL/netlist views, pool stable
chunks into whole-design embeddings, and score whether any view reduces the
T06 nuisance axes while preserving QD/Pareto signal.

## Required Result Tables

- `tables/preprocessing_view_manifest.csv`
- `tables/embedding_cache_manifest.csv`
- `tables/pooling_ablation.csv`
- `tables/collapse_diagnostics.csv`
- `tables/nuisance_axis_diagnostics.csv`
- `tables/replay_aggregate.csv`
- `tables/qwen_ladder_vs_controls.csv`
- `tables/ppa_front_metrics.csv`

## Required Figures

- `figures/t33_raw_area_power_pareto_front.png`
- `figures/t33_hypervolume_by_view.png`
- `figures/t33_duplicate_and_motif_counts.png`
- `figures/t33_same_problem_nn_fraction.png`
- `figures/t33_embedding_projection_diagnostic.png`

Raw area-power PPA Pareto visualization is mandatory when PPA data exists. The
projection diagnostic is supporting evidence only.

## Pending Conclusion Questions

The final T33 report must answer:

1. Which preprocessing view, if any, reduced same-problem and same-corpus
   nearest-neighbor clustering relative to T06?
2. Did that view also improve a claimed QD/Pareto metric versus lexical
   farthest-first and random descriptor controls?
3. Did any gain come from real design diversity rather than duplicates,
   identifiers, text length, or problem identity?
4. Should the next step be a projection head, an SR-raw hybrid descriptor, a
   live side archive, or retirement of this Qwen ladder?

Until those answers are backed by tables and inspected figures, T33 remains
pre-registered and unscored.
