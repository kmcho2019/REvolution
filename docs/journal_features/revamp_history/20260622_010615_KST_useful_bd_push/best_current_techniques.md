# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | T51 code-thought front slot | Diagnostic lead | Restores much of the yield and best-score damage from thought-only front control while preserving the one-slot archive idea. | Classic still wins front breadth and HV on the hard/tuning surface. |
| 2 | T26/T30 SR conservative QD | Mechanism clue | Shows champion-biased archive pressure can recover local quality and preserves covered designs in the VerilogEval holdout. | Reference-complete RTLLM comparison is negative; not a headline win. |
| 3 | RTL-native BD lane | Positive proxy clue | MasterRTL/RTLTimer-style descriptors give a more defensible definition of RTL behavior diversity. | T61 gives only a problem-local front-cell proxy signal; true RTLTimer/MasterRTL extraction still needed. |
| 4 | Learned/graph encoder lane | Exploratory | T11/T36 show replay signal from graph/structural features and bounded front slots. | Live graph-coordinate archives have not beaten classic. |

## Most Promising Direction

Combine the practical T26/T51 archive machinery with RTL-native descriptors.
The archive mechanism should keep hill-climbing pressure and local front
retention, while MasterRTL/RTLTimer-style descriptors define cells from RTL
operator structure, control/dataflow shape, pipeline/register topology, and
timing-risk morphology. This is more defensible than opaque embedding-only
claims and avoids using final PPA as the descriptor.

## Technique Lanes

| Lane | Examples | Status | Assessment |
| --- | --- | --- | --- |
| RTL-native descriptors | MasterRTL SOG, RTLTimer timing-risk vectors, T60/T61 timing-risk proxies | Active proxy | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; T61 is a small positive front-cell clue, not a live win. |
| Archive machinery | T26, T30, T51, one-slot local-front variants | Continue selectively | Useful mechanism pieces, but no broad RTLLM win yet. |
| Learned embeddings | Qwen3, DeepGate, T11/T36, AURORA-style features | Exploratory | Useful for replay and analysis, not yet decisive live evidence. |
| Retrospective clustering | PPA cluster replay, Qwen probes, family audits | Diagnostic | Explains failed/won mechanisms but is not direct promotion evidence. |

## Update Rules

- Update after each meaningful run or claim correction.
- Do not promote a technique using defaulted-reference metrics.
- Mark each result as `headline`, `screening`, or `diagnostic`.
- Keep only the current best few methods at the top.
- Link detailed evidence through the technique package, not long prose here.
