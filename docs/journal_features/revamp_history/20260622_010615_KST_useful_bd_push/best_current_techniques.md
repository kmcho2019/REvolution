# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | T51/T26-family conservative QD | Diagnostic lead | Gives the cleanest archive machinery so far: local-front pressure, champion bias, and no broad covered-design loss. | Reference-complete RTLLM is negative versus classic; not a headline win. |
| 2 | T26.1 gated/low-fusion variants | Mechanism candidate | Tests whether limited, descriptor-compatible recombination can keep hill-climbing quality without global parent mismatch. | T48 reduced some damage but still lost classic on HV, HV-AUC, valid-PPA, and front points. |
| 3 | RTL-native BD lane | High priority | MasterRTL/Yosys-SOG and RTLTimer-style features give a reviewer-readable definition of RTL diversity: operator/control/dataflow shape, pipeline/register topology, and timing-risk morphology. | T73 passes a bounded live screen but is not matched against classic yet; T72 is executable and near-classic on mean HV, but classic still wins front breadth. |
| 4 | Learned/graph encoder lane | Exploratory | T11/T36 show replay signal from graph/structural features and bounded front slots. | Live graph-coordinate archives have not beaten classic, and opaque embeddings need stronger collapse controls. |

## Most Promising Direction

Combine the practical T51/T26-family archive machinery with source-aligned
RTL-native behavior descriptors. The archive mechanism should keep
hill-climbing pressure and local front retention, while Yosys-SOG/MasterRTL
and RTLTimer-style descriptors define archive cells from RTL operator
structure, control/dataflow shape, pipeline/register topology, and timing-risk
morphology.

T72 tested that idea with T71's source-aligned MasterRTL/RTL-Timer cells
inside T66-style front-slot parent pressure, with two-parent fusion disabled
to isolate the descriptor. Its runtime descriptor gate passes without PPA
leakage on the full T70 generated-candidate regression, and the live screen
preserves all `13/13` classic-covered designs. The reference-complete matched
comparison is near-classic on mean HV (`0.0920` versus classic `0.0926`) but
not promoted because classic wins HV wins, Pareto points, and
reference-beating candidates.

T73 is the immediate source-aligned follow-up. It replaces T72's collapsed
`log_edges/state_class` grid with problem-local quantile cells over MasterRTL
branching, RTL-Timer wire density, and RTL-Timer DFF density. The pre-run audit
shows mean occupied cells rising from `1.0769` for T72's live fixed grid to
`5.6923` for the T73 local-quantile projection on the same T72 candidates.
The bounded live screen completes and passes both registered validators, with
`12/13` successful problems, `85` archive members, `624` generated candidates,
and `294` PPA reports. It is not promoted yet because
`Prob151_review2015_fsm` has zero archive members and no matched classic
reference-complete comparison has been packaged.

T67 tested the next version of this direction by keeping the RTL-native
state/pipeline archive cells and using seeded thought-code realization so the
generator could refine successful parent RTL. It improves aggregate valid-PPA
count (`304` versus classic `257`), but loses front points (`18` versus
`30`), unique PPA points (`67` versus `87`), reference-beating candidates
(`41` versus `46`), and misses `Prob153_gshare`. Treat seeded realization as
a yield clue, not a promoted QD method.

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
| RTL-native descriptors | Yosys-SOG/MasterRTL, RTLTimer timing-risk vectors, T15/T60/T61/T62/T63/T64/T65/T66/T67/T68/T69/T70/T71/T72/T73 | Package T73 matched comparison | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; exact T72 is executable but too cell-collapsed to beat classic front breadth, and T73 is the live quantile-cell follow-up. |
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

## Source-Verification Caveat

T68 shows that T15/T60/T61 are proxy lanes, not source-equivalent upstream
MasterRTL or RTL-Timer runs. T69 narrows the fresh-conversion blocker on
TinyRocket examples, T70 shows the same open-Yosys path parses `19/19`
sampled generated T67 candidates with both MasterRTL and RTL-Timer flows, and
T71 defines a source-aligned 4 by 4 archive-cell map with `9/16` occupied
cells. T72 evaluates those cells live and lands near classic, but exact T72 is
not promoted because classic still wins the front-breadth metrics.
