# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | T51/T26-family conservative QD | Diagnostic lead | Gives the cleanest archive machinery so far: local-front pressure, champion bias, and no broad covered-design loss. | Reference-complete RTLLM is negative versus classic; not a headline win. |
| 2 | T26.1 gated/low-fusion variants | Mechanism candidate | Tests whether limited, descriptor-compatible recombination can keep hill-climbing quality without global parent mismatch. | T48 reduced some damage but still lost classic on HV, HV-AUC, valid-PPA, and front points. |
| 3 | RTL-native BD lane | High priority | MasterRTL/Yosys-SOG and RTLTimer-style features give a reviewer-readable definition of RTL diversity: operator/control/dataflow shape, pipeline/register topology, and timing-risk morphology. | T63/T64/T65 are diagnostic only; the descriptors must affect parent choice or repair, not just reporting cells. |
| 4 | Learned/graph encoder lane | Exploratory | T11/T36 show replay signal from graph/structural features and bounded front slots. | Live graph-coordinate archives have not beaten classic, and opaque embeddings need stronger collapse controls. |

## Most Promising Direction

Combine the practical T51/T26-family archive machinery with RTL-native
behavior descriptors. The archive mechanism should keep hill-climbing pressure
and local front retention, while Yosys-SOG/MasterRTL and RTLTimer-style
descriptors define archive cells from RTL operator structure, control/dataflow
shape, pipeline/register topology, and timing-risk morphology.

The next promotion candidate should use these RTL-native descriptors to affect
parent choice, repair selection, or another measured coupling point. Do not
use them only as direct PPA predictors or posthoc visual labels. This is the
strongest methodology story because it defines diversity in RTL terms rather
than opaque embedding space, while the PPA claim remains gated by
reference-complete paired comparisons.

## Technique Lanes

| Lane | Examples | Status | Assessment |
| --- | --- | --- | --- |
| RTL-native descriptors | Yosys-SOG/MasterRTL, RTLTimer timing-risk vectors, T15/T60/T61/T62/T63/T64/T65 | Accelerate with coupling | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; T63/T64/T65 are useful diagnostics but do not beat classic headline front metrics. |
| Archive machinery | T26, T30, T48, T51, one-slot local-front variants | Continue selectively | Useful mechanism pieces, but no broad RTLLM win yet. |
| Learned embeddings | Qwen3, DeepGate, T11/T36, AURORA-style features | Exploratory | Useful for replay and analysis, not yet decisive live evidence. |
| Retrospective clustering | PPA cluster replay, Qwen probes, family audits | Diagnostic | Explains failed/won mechanisms but is not direct promotion evidence. |

## Update Rules

- Update after each meaningful run or claim correction.
- Do not promote a technique using defaulted-reference metrics.
- Direct classic-vs-QD claims must use the reference-complete paired subset.
- Mark each result as `headline`, `screening`, or `diagnostic`.
- Keep only the current best few methods at the top.
- Link detailed evidence through the technique package, not long prose here.
