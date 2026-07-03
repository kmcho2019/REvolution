# Imagegen Concept Trials

This directory stores AI-generated raster concept alternatives for selected
manual concept diagrams. These are optional visual aids; they are not data
figures and should not replace precise quantitative plots.

## Files

| Path | Meaning |
| --- | --- |
| `images/replacement_vs_memory_imagegen.png` | Generated alternative for QD replacement versus guarded memory. |
| `images/pcn_architecture_imagegen.png` | Generated alternative for PCN-v3 guarded memory architecture. |
| `images/scalar_vs_pareto_imagegen.png` | Generated alternative for scalar fitness versus Pareto/HV intuition. |
| `images/classic_revolution_methodology_imagegen.png` | Generated high-level visual for classic REvolution's success-pool hill-climbing loop. |
| `images/generic_qd_map_elites_methodology_imagegen.png` | Generated high-level visual for generic descriptor-grid MAP-Elites pressure. |
| `images/pcn_v3_methodology_imagegen.png` | Generated high-level visual for PCN-v3 as classic REvolution plus guarded QD memory. |
| `images/classic_revolution_methodology_paper_imagegen.png` | Paper-style imagegen flowchart for classic REvolution. |
| `images/generic_qd_map_elites_methodology_paper_imagegen.png` | Paper-style imagegen flowchart for generic QD/MAP-Elites. |
| `images/pcn_v3_methodology_paper_imagegen.png` | Paper-style imagegen flowchart for PCN-v3 guarded memory. |
| `captions/*.md` | Prompt, caption, manual counterpart, and usage recommendation for each image. |

## Current Read

The generated images are more polished than the manual concept boxes, but less
precise. Use them for narrative transition slides or optional visual emphasis.
Keep the manual deterministic diagrams for slides where exact method mechanics
or metric definitions matter.

The methodology trio is best used as a visual sequence:

1. classic REvolution: concentrated success-pool refinement;
2. generic QD/MAP-Elites: descriptor-grid coverage pressure;
3. PCN-v3: a small memory sidecar rather than archive replacement.

Use the `*_paper_imagegen.png` trio for appendix method explanation. The older
imagegen methodology trio is more illustrative and should remain optional only.
