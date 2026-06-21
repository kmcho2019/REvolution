# Qwen Projection BD Results Report

Status: current diagnostic package for `T06_qwen_projection_bd`.

Tier decision: `T0 diagnostic`.

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

## Tables

- `tables/qwen_embedding_manifest.csv`
- `tables/preprocessing_view_manifest.csv`
- `tables/collapse_diagnostics.csv`
- `tables/nuisance_axis_diagnostics.csv`
- `tables/replay_aggregate.csv`
- `tables/qwen_vs_lexical_deltas.csv`

## Figures

- `figures/qwen_replay_hypervolume.png`
- `figures/qwen_vs_lexical_hv_delta.png`
- `figures/qwen_diversity_counts.png`
- `figures/qwen_collapse_diagnostics.png`

Visual inspection notes are in `figures/visual_inspection_notes.md`.

## Key Results

The source diagnostic retained 341 of 682 valid-PPA candidates across 114
problem groups. The baseline hypervolume over all valid candidates was 3.8642.

| Representation | Selected HV | HV vs lexical | Selected best fitness | Unique netlists | Unique motifs |
| --- | ---: | ---: | ---: | ---: | ---: |
| Fitness top | 3.8232 | +3.28% | 0.7498 | 52 | 44 |
| Generation prefix | 3.1552 | -14.77% | 0.6951 | 50 | 45 |
| Lexical farthest | 3.7018 | 0.00% | 0.6881 | 60 | 54 |
| Qwen identifier | 3.8258 | +3.35% | 0.7498 | 59 | 51 |
| Qwen raw | 3.6555 | -1.25% | 0.6951 | 57 | 50 |
| Random | 3.0742 | -16.96% | 0.6951 | 59 | 50 |

Qwen identifier-normalized farthest-first is the best Qwen variant in this
diagnostic. It improves selected HV by 3.35% over lexical farthest-first and
matches the fitness-top selected best fitness. However, it still gives up
diversity counts versus lexical farthest-first: unique canonical netlists drop
from 60 to 59 and unique motif signatures drop from 54 to 51.

The collapse and nuisance-axis diagnostics explain why this is not promoted:

- nearest-neighbor cosine mean is 0.9798;
- nearest-neighbor same-problem fraction is 0.9336;
- nearest-neighbor same-corpus fraction is 0.9479;
- same canonical-netlist nearest fraction is only 0.1406;
- same motif-signature nearest fraction is only 0.1888;
- raw/comment cosine mean is 0.9493;
- raw/identifier cosine mean is 0.6389.

These values indicate that raw Qwen embeddings are real and non-degenerate, but
the dominant neighborhood structure is problem/corpus identity rather than
canonical netlist or motif similarity. Identifier normalization can improve HV
retention, but it also strongly changes the embedding space and does not yet
produce a robust BD.

## Conclusion

Raw whole-file Qwen and identifier-normalized whole-file Qwen do not reach
`T1` as behavior descriptors. The result is nevertheless useful: it shows that
Qwen embeddings can carry PPA-relevant signal in a retention audit, but the
signal is entangled with nuisance axes and loses diversity counts versus a
lexical control.

The next T06 attempt should not rerun this raw diagnostic. It should implement
the normalized-view projection plan in `methodology.md`: canonical RTL,
Yosys-normalized netlist text, and compact structural-summary views; pooled
whole-design embeddings; then projection or CVT axes with explicit
same-problem, identifier, and duplicate-netlist collapse checks. This package
does not reject those future variants.
