# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | T51/T26-family conservative QD | Diagnostic lead | Gives the cleanest archive machinery so far: local-front pressure, champion bias, and no broad covered-design loss. | Reference-complete RTLLM is negative versus classic; not a headline win. |
| 2 | T26.1 gated/low-fusion variants | Mechanism candidate | Tests whether limited, descriptor-compatible recombination can keep hill-climbing quality without global parent mismatch. | T48 reduced some damage but still lost classic on HV, HV-AUC, valid-PPA, and front points. |
| 3 | RTL-native BD lane | High priority | MasterRTL/Yosys-SOG and RTLTimer-style features give a reviewer-readable definition of RTL diversity: operator/control/dataflow shape, pipeline/register topology, and timing-risk morphology. | T63/T64/T65/T66 are diagnostic only; the descriptors must affect front creation or repair more directly, not just weak parent pressure or reporting cells. |
| 4 | Learned/graph encoder lane | Exploratory | T11/T36 show replay signal from graph/structural features and bounded front slots. | Live graph-coordinate archives have not beaten classic, and opaque embeddings need stronger collapse controls. |

## Most Promising Direction

Combine the practical T51/T26-family archive machinery with RTL-native
behavior descriptors. The archive mechanism should keep hill-climbing pressure
and local front retention, while Yosys-SOG/MasterRTL and RTLTimer-style
descriptors define archive cells from RTL operator structure, control/dataflow
shape, pipeline/register topology, and timing-risk morphology.

T66 tested that idea with T63 state/pipeline RTL-native cells, front-slot
parent pressure, and low-rate near-front descriptor-compatible fusion. It
improves valid-PPA and best-score diagnostics, but loses classic on HV,
HV-AUC, and front points. Do not use RTL-native descriptors only as direct PPA
predictors, weak parent-pressure labels, or posthoc visual cells. This is still
the strongest methodology story because it defines diversity in RTL terms
rather than opaque embedding space, while the PPA claim remains gated by
reference-complete paired comparisons.

T67 is the next registered test of this direction: keep the RTL-native
state/pipeline archive cells, but use seeded thought-code realization so the
generator can refine successful parent RTL instead of regenerating every code
sample from scratch.

## Current Assessment After Reference Fix

The full RTLLM T26 result is diagnostic, not positive. Direct classic-vs-QD
claims must use the reference-complete paired subset because four RTLLM
designs lack valid benchmark reference PPA:
`Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
`Prob018_float_multi`, and `Prob040_synchronizer`.

On the 46 reference-complete problems, exact T26 loses classic on mean HV,
HV-AUC, best score, valid-PPA yield, and unique PPA points. On the stricter
31-problem paired-valid-PPA headline subset, it also loses PPA-front points.
Do not promote any technique from all-50/defaulted-reference aggregates.

## RTL-Native Descriptor Split

| Lane | Descriptor Meaning | QD Use | Current Read |
| --- | --- | --- | --- |
| MasterRTL/Yosys-SOG | RTL operator graph, control/dataflow shape, arithmetic structure, muxing, pipeline/register topology, module interaction, and signal dependencies. | Define archive cells for distinct RTL implementation families before synthesis. | Strong methodology lane; needs tighter coupling to front creation or repair. |
| RTLTimer | Timing-risk and path-structure morphology: likely critical-path depth, fanout, pipeline distance, control gating, and timing-sensitive operator chains. | Preserve timing-risk families while the optimizer still chases PPA. | Good reviewer-readable BD candidate; current runs are diagnostic, not promoted. |

## Technique Lanes

| Lane | Examples | Status | Assessment |
| --- | --- | --- | --- |
| RTL-native descriptors | Yosys-SOG/MasterRTL, RTLTimer timing-risk vectors, T15/T60/T61/T62/T63/T64/T65 | Accelerate with coupling | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; T63/T64/T65 are useful diagnostics but do not beat classic headline front metrics. |
| Archive machinery | T26, T30, T48, T51, one-slot local-front variants | Continue selectively | Useful mechanism pieces, but no broad RTLLM win yet. |
| Learned embeddings | Qwen3, DeepGate, T11/T36, AURORA-style features | Exploratory | Useful for replay and analysis, not yet decisive live evidence. |
| Retrospective clustering | PPA cluster replay, Qwen probes, family audits | Diagnostic | Explains failed/won mechanisms but is not direct promotion evidence. |

## Update Rules

- Update after each meaningful run or claim correction.
- Separate missing candidate PPA from missing reference PPA in every new run
  package.
- Do not promote a technique using missing/defaulted-reference metrics.
- Direct classic-vs-QD claims must use the reference-complete paired subset.
- Mark each result as `headline`, `screening`, or `diagnostic`.
- Keep only the current best few methods at the top.
- Link detailed evidence through the technique package, not long prose here.
