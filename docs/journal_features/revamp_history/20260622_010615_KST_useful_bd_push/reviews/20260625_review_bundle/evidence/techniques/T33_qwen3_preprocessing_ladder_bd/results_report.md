# Qwen3 Preprocessing Ladder BD Results Report

Status: completed replay diagnostic with T33a source inventory, T33b
preprocessing-view cache, T33c embedding cache, T33d collapse diagnostics, and
T33e replay/PPA-front scoring.

Tier decision: `T0 diagnostic`. The result is useful follow-up evidence, but
not a useful-BD win.

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

Each pooled row was inspected for shape and unit norm. This was not a T33
success claim by itself; collapse diagnostics and replay/Pareto scoring below
decide the tier.

## T33d Collapse Diagnostics

T33d computes nearest-neighbor collapse metrics over each six-view embedding
matrix. It directly tests T06's main failure mode: same-problem nearest-neighbor
fraction `0.93359375` and same-corpus fraction `0.9479166666666666`.

| View | Same Problem | Delta vs T06 | Same Corpus | Delta vs T06 |
| --- | ---: | ---: | ---: | ---: |
| `canonical_yosys_netlist` | 0.738281250 | -0.195312500 | 0.822916667 | -0.125000000 |
| `summary_plus_netlist` | 0.816406250 | -0.117187500 | 0.910156250 | -0.037760417 |
| `canonical_rtl` | 0.894531250 | -0.039062500 | 0.923177083 | -0.024739583 |
| `identifier_role_rtl` | 0.906250000 | -0.027343750 | 0.930989583 | -0.016927083 |
| `commentless_rtl` | 0.937500000 | +0.003906250 | 0.944010417 | -0.003906250 |
| `raw_rtl` | 0.942708333 | +0.009114583 | 0.949218750 | +0.001302083 |

The result is a meaningful preprocessing signal. Whole-file raw and
commentless RTL remain as bad as T06, but the netlist views reduce
same-problem clustering substantially. `canonical_yosys_netlist` is the
strongest collapse-diagnostic candidate.

This was a meaningful neighborhood diagnostic, but replay/PPA-front scoring
below shows that the netlist views did not translate that collapse improvement
into better selected hypervolume than lexical farthest-first.

## T33e Replay And Direct PPA Fronts

T33e replays each six-view Qwen descriptor with the same retention fraction as
the T06 common audit: `0.5` per `(corpus, method, seed, problem_id)` group. It
compares the six T33 views against lexical farthest-first, random selection,
generation prefix, and fitness-top controls. The BD inputs remain non-PPA text
embeddings; PPA fields are used only for replay scoring and figures.

Selected-hypervolume results:

| Representation | Selected HV | Delta vs Lexical | Selected Pareto Size | Unique Netlists | Unique Motifs |
| --- | ---: | ---: | ---: | ---: | ---: |
| `fitness_top` | 3.823248 | +0.121421 | 300 | 52 | 44 |
| `t33_canonical_rtl_farthest` | 3.799167 | +0.097340 | 287 | 59 | 54 |
| `t33_identifier_role_rtl_farthest` | 3.799118 | +0.097291 | 288 | 61 | 55 |
| `t33_commentless_rtl_farthest` | 3.772692 | +0.070865 | 293 | 59 | 51 |
| `lexical_farthest` | 3.701827 | +0.000000 | 283 | 60 | 54 |
| `t33_summary_plus_netlist_farthest` | 3.686043 | -0.015784 | 285 | 63 | 56 |
| `t33_raw_rtl_farthest` | 3.655540 | -0.046287 | 294 | 57 | 50 |
| `t33_canonical_yosys_netlist_farthest` | 3.578191 | -0.123636 | 287 | 63 | 56 |
| `generation_prefix` | 3.155186 | -0.546641 | 303 | 50 | 45 |
| `random` | 3.074167 | -0.627660 | 303 | 59 | 50 |

Direct area-power front accounting:

| Representation | Unique All-Valid Front Hits | Selected Front Points | Unique PPA Points |
| --- | ---: | ---: | ---: |
| `t33_commentless_rtl_farthest` | 123 | 130 | 180 |
| `lexical_farthest` | 122 | 127 | 183 |
| `fitness_top` | 122 | 122 | 159 |
| `t33_summary_plus_netlist_farthest` | 121 | 129 | 188 |
| `t33_identifier_role_rtl_farthest` | 120 | 129 | 184 |
| `t33_canonical_rtl_farthest` | 120 | 129 | 183 |
| `t33_canonical_yosys_netlist_farthest` | 119 | 127 | 186 |
| `t33_raw_rtl_farthest` | 117 | 128 | 177 |
| `generation_prefix` | 110 | 124 | 163 |
| `random` | 107 | 128 | 166 |

The raw area-power Pareto figure is now a primary artifact:
`figures/t33_raw_area_power_pareto_front.png`. It uses the richest valid-PPA
group, `Prob018_float_multi`, and shows both the full valid-PPA cloud and a
lower-left Pareto zoom. This directly addresses whether descriptor selection
keeps useful PPA-front material.

Interpretation:

- Canonical RTL, identifier-role RTL, and commentless RTL beat lexical on
  selected hypervolume by `+2.63%`, `+2.63%`, and `+1.91%` respectively.
- The strongest collapse-fix view, canonical Yosys netlist, loses
  `-3.34%` selected HV versus lexical. Summary-plus-netlist also loses
  `-0.43%`.
- Netlist views select slightly more unique netlists and motif signatures, but
  that does not improve HV or unique all-valid area-power front hits.
- The RTL-view HV lift is real enough to justify a follow-up ablation, but not
  enough for promotion because it does not improve direct PPA-front coverage,
  and its same-problem clustering remains high.

## Result Tables

- `tables/t33_embedding_cache_manifest.csv`
- `tables/t33_collapse_diagnostics.csv`
- `tables/t33_replay_aggregate.csv`
- `tables/t33_qwen_ladder_vs_controls.csv`
- `tables/t33_ppa_front_metrics.csv`
- `tables/t33_replay_rows.csv`
- `tables/t33_selected_candidates.csv`

## Figures

- `figures/t33_raw_area_power_pareto_front.png`
- `figures/t33_hypervolume_by_view.png`
- `figures/t33_duplicate_and_motif_counts.png`

Raw area-power PPA Pareto visualization is mandatory when PPA data exists. T33
now satisfies that requirement with a directly inspected two-panel figure.

## Conclusion Questions

1. Which preprocessing view, if any, reduced same-problem and same-corpus
   nearest-neighbor clustering relative to T06?

   Yes. `canonical_yosys_netlist` reduced same-problem nearest-neighbor
   fraction from T06's `0.93359375` to `0.738281250`, and same-corpus fraction
   from `0.9479166666666666` to `0.822916667`. `summary_plus_netlist` was the
   second-best collapse fix.

2. Did that view also improve a claimed QD/Pareto metric versus lexical
   farthest-first and random descriptor controls?

   No. `canonical_yosys_netlist` beat random but lost to lexical on selected
   hypervolume by `-0.123636` (`-3.34%`). `summary_plus_netlist` also lost to
   lexical by `-0.015784` (`-0.43%`). The RTL views beat lexical on HV, but
   they did not solve the nuisance-axis collapse as strongly.

3. Did any gain come from real design diversity rather than duplicates,
   identifiers, text length, or problem identity?

   Only partially. Netlist views improved unique-netlist and motif counts but
   did not improve HV. RTL views improved HV but not unique all-valid
   area-power front hits. The result is evidence for more ablation, not a
   claim of useful design diversity.

4. Should the next step be a projection head, an SR-raw hybrid descriptor, a
   live side archive, or retirement of this Qwen ladder?

   Do not retire the lane, but do not promote direct Qwen whole-design
   farthest-first. The next reasonable step is a small projection/head ablation
   that uses canonical RTL or identifier-role RTL as the PPA-signal source and
   adds an explicit anti-problem/corpus objective inspired by the netlist
   collapse diagnostic. A direct netlist-view BD should be parked unless paired
   with another descriptor.
