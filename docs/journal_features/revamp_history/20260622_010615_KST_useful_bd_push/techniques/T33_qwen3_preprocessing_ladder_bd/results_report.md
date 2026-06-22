# Qwen3 Preprocessing Ladder BD Results Report

Status: pre-registered method package with T33a source inventory, T33b
preprocessing-view cache, and T33c embedding cache.

Tier decision: pending. No result is claimed yet.

## Why This Exists

T06 should not be treated as a complete rejection of Qwen-style descriptors.
It rejected raw and identifier-normalized whole-file embeddings as direct BDs:
they carried some hypervolume signal, but nearest neighbors were dominated by
same-problem and same-corpus clustering.

T33 is the planned escalation: normalize the RTL/netlist views, pool stable
chunks into whole-design embeddings, and score whether any view reduces the
T06 nuisance axes while preserving QD/Pareto signal.

## T33a Source Inventory

The T33a inventory records the exact prior Qwen sources before new
preprocessing starts:

- `tables/t33_source_inventory.csv`: 15 source artifacts from the live prior
  Qwen directory and the committed 20260621 Qwen bundle, with bytes and SHA256.
- `tables/t33_prior_qwen_summary.csv`: key T06 baseline facts copied from the
  source summary.
- `tables/t33_preprocessing_ladder_plan.csv`: the six planned preprocessing
  views and leakage exclusions.

Key source facts: model `Qwen/Qwen3-Embedding-0.6B`, `768` candidates,
`127` problems, `768x1024` embeddings for the prior raw/commentless/identifier
views, same-problem nearest-neighbor fraction `0.93359375`, and
identifier-Qwen selected-HV gain `0.033499553667026144` versus lexical.

These are source facts from T06, not new T33 performance evidence.

## T33b Preprocessing-View Cache

The T33b cache generated all six planned text views for the 768 prior Qwen
candidates:

- output root:
  `exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC`;
- `4608` view files, covering 768 candidates times six views;
- compact committed manifests:
  `tables/t33_preprocessing_cache_manifest.csv`,
  `tables/t33_preprocessing_view_manifest.csv`, and
  `tables/t33_preprocessing_view_summary.csv`.

Mean character counts by view are:

| View | Mean Chars | Max Chars |
| --- | ---: | ---: |
| `canonical_rtl` | 561.63 | 3854 |
| `commentless_rtl` | 627.82 | 4488 |
| `identifier_role_rtl` | 763.30 | 4796 |
| `raw_rtl` | 783.17 | 4904 |
| `canonical_yosys_netlist` | 22742.37 | 711482 |
| `summary_plus_netlist` | 23099.05 | 711847 |

The cache inspection found and fixed one preprocessing bug before this manifest
was accepted: Verilog base-literal payloads such as `2'b00` must not be
identifier-normalized. The committed manifest points at the corrected cache.

These are preprocessing artifacts only. They do not answer whether Qwen3 BDs
work until embeddings, collapse diagnostics, and replay/PPA-front scoring run.

## T33c Embedding Cache

The existing isolated Qwen env at `exp/diversity_check/encoder_envs/qwen3_probe`
was reused because the repo uv environment lacks `sentence_transformers`,
`torch`, and `sklearn`. The env reports `sentence_transformers 5.6.0`,
`torch 2.6.0+cu124`, and CUDA on an NVIDIA RTX A6000.

All six views now have chunk-pooled Qwen embeddings:

| View | Shape | Chunks | Encode Seconds |
| --- | ---: | ---: | ---: |
| `canonical_rtl` | `768x1024` | 768 | 26.606 |
| `canonical_yosys_netlist` | `768x1024` | 4738 | 426.972 |
| `commentless_rtl` | `768x1024` | 773 | 12.376 |
| `identifier_role_rtl` | `768x1024` | 777 | 16.123 |
| `raw_rtl` | `768x1024` | 773 | 13.869 |
| `summary_plus_netlist` | `768x1024` | 4765 | 430.032 |

The `.npy` matrices are stored under:

`exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC/embeddings/`

Each pooled row was inspected for shape and unit norm. This is still not a
T33 success claim: the next step is collapse diagnostics, then replay/Pareto
scoring against lexical and random controls.

## Required Result Tables

- `tables/t33_embedding_cache_manifest.csv`
- `tables/t33_collapse_diagnostics.csv`
- `tables/t33_nuisance_axis_diagnostics.csv`
- `tables/t33_replay_aggregate.csv`
- `tables/t33_qwen_ladder_vs_controls.csv`
- `tables/t33_ppa_front_metrics.csv`

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
