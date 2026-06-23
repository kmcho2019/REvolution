# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | T51 code-thought front slot | Diagnostic lead | Restores much of the yield and best-score damage from thought-only front control while preserving the one-slot archive idea. | Classic still wins front breadth and HV on the hard/tuning surface. |
| 2 | T26/T30 SR conservative QD | Mechanism clue | Shows champion-biased archive pressure can recover local quality and preserves covered designs in the VerilogEval holdout. | Reference-complete RTLLM comparison is negative; not a headline win. |
| 3 | T63 fused RTL-native QD | Mechanism ablation | Adds RTLLM front, unique-PPA, and reference-beating signal versus T51 while using reviewer-readable RTL structure/timing axes. | Classic still wins mean HV, HV-AUC, and aggregate front points; T64 improves yield and T65 secondary cells are diagnostic only. |
| 4 | Learned/graph encoder lane | Exploratory | T11/T36 show replay signal from graph/structural features and bounded front slots. | Live graph-coordinate archives have not beaten classic. |

## Most Promising Direction

Combine the practical T26/T51 archive machinery with fused RTL-native
descriptors. The archive mechanism should keep hill-climbing pressure and
local front retention, while Yosys-SOG/MasterRTL and RTLTimer-style descriptors
define cells from RTL operator structure, control/dataflow shape,
pipeline/register topology, and timing-risk morphology. T63 is now the current
live clue for this direction: it is reference-complete on the hard/tuning
subset and improves several front-material metrics versus T51, but it is not a
classic headline win. T64's operator/timing ablation raises valid-PPA yield but
loses more front material, so the next RTL-native step should redesign the
generator/archive coupling. T65 tested a pure secondary-cell overlay around
T51/T63/T64 and still lost Classic on problem-paired front-cell coverage, so
the next RTL-native attempt needs to affect parent choice or repair selection,
not just reporting.
This is still more defensible than opaque embedding-only claims and avoids
using final PPA as the descriptor.

## Technique Lanes

| Lane | Examples | Status | Assessment |
| --- | --- | --- | --- |
| RTL-native descriptors | Yosys-SOG/MasterRTL, RTLTimer timing-risk vectors, T15/T60/T61/T62/T63/T64/T65 | Active mechanism | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; T63/T64/T65 are useful diagnostics but do not beat classic headline front metrics. |
| Archive machinery | T26, T30, T51, one-slot local-front variants | Continue selectively | Useful mechanism pieces, but no broad RTLLM win yet. |
| Learned embeddings | Qwen3, DeepGate, T11/T36, AURORA-style features | Exploratory | Useful for replay and analysis, not yet decisive live evidence. |
| Retrospective clustering | PPA cluster replay, Qwen probes, family audits | Diagnostic | Explains failed/won mechanisms but is not direct promotion evidence. |

## Update Rules

- Update after each meaningful run or claim correction.
- Do not promote a technique using defaulted-reference metrics.
- Mark each result as `headline`, `screening`, or `diagnostic`.
- Keep only the current best few methods at the top.
- Link detailed evidence through the technique package, not long prose here.
