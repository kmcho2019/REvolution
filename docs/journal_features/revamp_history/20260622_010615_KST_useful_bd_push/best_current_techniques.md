# Best Current Techniques

This file is the short operational view. Update it after each meaningful run
or claim correction; keep detailed evidence in the per-technique package,
`current_results_matrix.md`, and `technique_lanes.md`.

## Current Best Techniques

| Rank | Technique | Status | Why It Matters | Current Limitation |
| ---: | --- | --- | --- | --- |
| 1 | MasterRTL auxiliary archive high-exploit | Best replicated QD by mean HV | Treats QD as side-channel archive memory while keeping classic-like exploitation pressure. | Seed replication is negative: three-seed mean HV `0.1261` versus classic `0.1442`. |
| 2 | RF leaf-ID structural delayed QD | Best RF model-state representative | Uses validated MasterRTL RF timing model-state as a secondary coordinate beside source-aligned structure and delayed archive pressure. | Seed replication is negative: three-seed mean HV `0.1260` versus classic `0.1442`, with `0/3` seed wins. |
| 3 | Delayed archive activation | Timing clue | Tests whether QD pressure was paid too early. It keeps passive archive logging and activates archive pressure at generation `3`. | Mean HV `0.1324` still trails classic `0.1406`; not promoted. |
| 4 | T11/T36 graph-like bridge | Category representative | Keeps the best live graph/encoder-like bridge arm in the shortlist. | Live `8x5` mean HV `0.1208` still trails classic `0.1406`. |
| 5 | Qwen3 canonical RTL | Pretrained text/code representative | Real pretrained embedding path with live-screened QD archive coordinates. | Mean HV `0.1108` trails classic `0.1406`; keep as category representative, not spend-ready. |
| 6 | MasterRTL RF timing model-state descriptors | Valid screened negative | T82 exposes T81's upstream timing-DAG/path RF model-state signal as a live descriptor profile and the frozen `8x5` screen is headline-paired. | Mean HV `0.1140` trails classic `0.1406`; several RF timing axes collapse. |
| 7 | RF leaf-ID front-slot delayed QD | Completed negative | Tests whether T83's RF model-state axes need explicit local front-slot parent sampling to recover Pareto breadth. | Mean HV drops to `0.1162`, with `0/8` HV wins; keep only as failed coupling evidence. |
| 8 | FG-QDM memory controls | Completed smoke negative | Tests QD as guarded auxiliary memory rather than a replacement optimizer. | Random-memory FG-QDM slightly beats SR-memory but trails classic, so exact `sr_pca_3d` memory is not descriptor-positive. |
| 9 | T51/T26-family conservative QD | Mechanism base | Gives the cleanest archive machinery so far: local-front pressure, champion bias, and no broad covered-design loss. | Reference-complete RTLLM is negative versus classic; not a headline win. |
| 10 | DeepGate transition/cone bridge | Pretrained netlist representative | Uses official DeepGate vectors; T89 shows residual signal beyond AIG stats, T90 reaches `8/8` offline coverage, and T91 builds candidate-level pooled descriptors. | Live HV evidence is still missing, so it is not spend-ready. |

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

T73 was the immediate source-aligned follow-up. It replaces T72's collapsed
`log_edges/state_class` grid with problem-local quantile cells over MasterRTL
branching, RTL-Timer wire density, and RTL-Timer DFF density. The pre-run audit
shows mean occupied cells rising from `1.0769` for T72's live fixed grid to
`5.6923` for the T73 local-quantile projection on the same T72 candidates.
The bounded live screen completes and passes both registered validators, with
`12/13` successful problems, `85` archive members, `624` generated candidates,
and `294` PPA reports. The matched reference-complete comparison preserves all
`13/13` classic-covered problems and improves valid-PPA samples (`294` versus
classic `257`) plus mean reference-beating candidates (`3.69` versus `3.54`).
It is still not promoted because classic wins the multi-objective read: mean
HV `0.0926007600` versus T73 `0.0890223082`, HV wins `8` versus `5`, and mean
Pareto points `2.31` versus `1.46`. `Prob151_review2015_fsm` also has three
candidate-PPA rows but zero live archive members, so it remains an
archive-health caveat.

T74 tested whether the existing low-rate two-parent prompt exposure could help
T73's cells create front material by gating pairs through
`near_front_descriptor`. It is now retired: coverage is preserved, but mean HV
falls to `0.0851926237`, HV wins drop to `1`, and valid-PPA samples drop to
`237`. T75 changed front creation directly with
`qd_front_slot_lane_fraction=0.30` and one-parent-only prompts. It is now
packaged as `T0 positive_diagnostic_not_promoted`: mean HV improves over T73
and T74, and valid-PPA samples improve over classic, but classic still wins
mean HV, Pareto breadth, and reference-beating count.

The current strategic correction is that classic should be treated as a strong
small-budget hill climber, not a weak baseline waiting for generic diversity to
beat it. The next promoted idea should show that QD preserves
PPA-competitive RTL implementation families while keeping classic-like
exploitation pressure. This does not reject QD/MAP-Elites; it says RTL needs
constrained diversity pressure that earns its evaluation cost.

T85/T86 sharpen that correction. Front-guarded memory can run, and its memory
lanes do fire, but exact `sr_pca_3d` memory loses classic and does not beat a
random-hash memory control on the three-problem smoke. Any next FG-QDM attempt
needs a materially stronger descriptor or a simpler, justified memory-credit
mechanism.

T87 tested that descriptor swap after simplifying the FG-QDM credit rule and
metadata handling. The source-aligned shape-density descriptor is registered
and RTL-native, but the smoke is negative: mean HV `0.1264` trails SR memory
`0.1375`, random memory `0.1382`, and classic `0.1903`. The key mechanism
failure is sharper than the aggregate metric: memory-refine and front-rescue
lanes produce zero valid-PPA children across the three-problem smoke. Treat
exact shape-density FG-QDM as negative coupling evidence, not as a candidate
for the frozen eight-design screen.

T85 implements that correction directly as FG-QDM, or front-guarded QD memory.
It keeps a separate classic-style primary success pool, inserts valid-PPA
candidates into the archive passively, gives no budget to empty-cell fill, and
samples memory parents only from credited retained cells. The warmup-4 smoke
fixes the initial `Prob015_multi_pipe_8bit` coverage failure, but it is
negative on the headline PPA-front read: classic mean HV is `0.1903` and T85
mean HV is `0.1375`. Classic wins `2/3` nonzero-HV comparisons and ties
`Prob015` at zero HV for both arms. T86 has now run the random-memory control:
random memory reaches mean HV `0.1382`, slightly above SR memory, so exact
`sr_pca_3d` memory is not descriptor-positive.

T78 adds evidence for that ablation but does not replace it. In the existing
T75 `12 x 3` logs, `9/13` problem archives still add or replace cells in
generation `2` or later, occupied cells rise through generation `3`, and
front-slot parent traffic continues increasing. That supports the hypothesis
that QD may need deeper equal-budget shapes, but it is not a live
classic-vs-QD budget result.

T79 completed the budget-shape gate on the frozen eight-design subset. Exact
T75 loses matched classic on mean Pareto HV for every tested equal-candidate
shape: `-0.0804` at `12x3`, `-0.0183` at `8x5`, and `-0.0507` at `6x7`. The
least negative QD shape is `8x5`, but it still trails classic on Pareto
points, reference-beating count, synthesis yield, and best score. Treat T79 as
evidence that exact T75 does not benefit more from depth than classic.

The 20260625 auxiliary-archive preliminary probe applies the same strategic
correction more directly: keep MasterRTL structural archive cells, lower forced
fill/backfill pressure, and sample parents through global NSGA-II rank with a
`0.90` champion lane. The first screen made it the closest QD arm by mean HV
(`0.1339` versus classic `0.1406`), but the seed-replication gate retires this
fixed configuration as a full-RTLLM candidate. Across seeds `1001`, `1002`, and
`1003`, classic wins every seed-level mean-HV comparison and averages `0.1442`
versus auxiliary archive `0.1261`. Removing `Prob135_m2014_q6b` leaves a
`-18.25%` relative HV gap. Treat the arm as a mechanism clue, not a near-win.
The next follow-up must change the pressure schedule, rather than only retuning
the same MasterRTL geometry.

That follow-up, `masterrtl_aux_archive_front_breadth_8x5`, completed the same
frozen screen and failed the promotion gate. The bounded front-slot lane
improves mean Pareto points versus high-exploit auxiliary archive (`2.125`
versus `1.75`), but mean HV drops to `0.1134`, below every stronger live QD
screened arm. This suggests that simply reintroducing explicit front-slot
pressure on the same MasterRTL geometry is too expensive under the current
budget.

The depth follow-up, `masterrtl_aux_archive_high_exploit_6x7`, also failed.
It keeps the high-exploit mechanism unchanged and changes only the
equal-candidate shape. Mean HV is `0.1229` versus matched classic `6x7`
`0.1701`, and below the same QD mechanism at `8x5` (`0.1339`). This closes the
simple depth-only continuation for the current auxiliary-archive mechanism.

The adaptive sparse-front follow-up also failed. It used the existing
`sparse_front_triggered_nsga2` selector to cap champion pressure only when
local archive fronts were thin. The trigger fired on three RTLLM problems, and
mean Pareto points improved over fixed high-exploit auxiliary archive
(`2.38` versus `1.75`), but mean HV fell to `0.0946` versus classic `0.1406`.
This retires fixed and sparse-front MasterRTL auxiliary archive pressure as a
full-RTLLM candidate family.

The delayed archive activation follow-up is now complete. It changes timing
rather than descriptor geometry: archive-driven fill, backfill, and failure
pressure are delayed until generation `3`, while passive archive logging runs
from the start. This is better than adaptive sparse-front pressure and close
to fixed high-exploit (`0.1324` mean HV versus `0.1339`), but classic remains
ahead at `0.1406` mean HV and `3.25` mean Pareto points. Treat fixed delayed
activation as a timing clue, not a promoted arm.

As of the 2026-06-25 periodic review, seed-replication gate, adaptive
sparse-front probe, and delayed activation probe, no current screened QD or
pretrained encoder configuration is ready for full RTLLM spend. The next
credible gate is not another fixed front-slot, sparse-front, depth-only, or
fixed-MasterRTL geometry variant; it must be a materially different mechanism
such as measured stagnation-triggered archive pressure or validated
pretrained MasterRTL model-state descriptors.

The stagnation-triggered archive-pressure gate is now complete and negative.
It used only scheduler-visible archive growth signals, `occupied_cells` and
`archive_member_count`, to decide when archive pressure turns on. This kept
the anti-gaming boundary intact, but it fired on only `3/8` problems and
`7/49` archive-history rows. Mean HV regressed to `0.1089`, below delayed
activation (`0.1324`) and classic (`0.1406`). The next live-candidate lane
should shift to validated MasterRTL pretrained model-state descriptors or
another materially different coupling mechanism.

T81 completes the first positive offline check for that pretrained
model-state lane. It uses MasterRTL's saved `rfr_model.pkl` timing model, the
upstream timing-DAG split, delay initialization, and path-feature flow rather
than direct scalar Area leaves. On the T70 generated RTL corpus, it evaluates
`13/19` candidates, captures `166` timing paths, and finds `53` unique RF leaf
rows with `414` unique leaf IDs.

T82 then turns that signal into a live descriptor profile:
`source_aligned_rf_timing_state_3d`. A generated-candidate evaluator smoke
emits `51` RF timing paths, `14` unique RF leaf rows, `161` unique RF leaf
IDs, and no no-path fallback. The follow-up one-problem live smoke on
`Prob015_multi_pipe_8bit` emits one valid PPA/archive member with `51` RF
timing paths, `17` unique RF leaf rows, and `319` unique RF leaf IDs. The
frozen eight-design `8x5` screen is now complete and negative for this exact
profile: mean HV is `0.1140` versus classic `0.1406`, mean Pareto points are
`2.00` versus classic `3.25`, and RF timing QD wins only `2/8` HV
comparisons. Several screened problems collapse the RF path-count axis, so the
next RF timing attempt must change the descriptor coupling rather than rerun
the same profile.

T83 is that follow-up and is now seed-replicated. It runs RF timing leaf-ID
breadth, MasterRTL branching, and RTLTimer wire density as explicit axes,
combined with delayed archive activation. The single-seed screen was close
(`0.1369` versus classic `0.1406`), but the three-seed gate blocks promotion:
classic averages `0.1442`, T83 averages `0.1260`, T83 has `0/3` seed-level HV
wins, and the RTLLM-only slice remains negative (`0.1085` versus classic
`0.1509`).

T84 tested that obvious failure mode without changing the descriptor after
seeing T83's result. It keeps the same axes and delayed archive activation but
switches parent selection to `front_slot_lane_nsga2`, with `0.20` local
front-slot traffic and `0.80` champion pressure. The result is negative:
mean HV falls to `0.1162`, HV wins fall to `0/8`, and front material does not
recover. Retire exact T84 and keep T83 as the current RF model-state
representative.

The DeepGate transition lane is now a legitimate pretrained-netlist category
representative but not a live candidate. T89 compares official DeepGate
transition embeddings with simple AIG size/count statistics on the same `60`
embedded generated candidates. AIG stats are more problem-dominated than
DeepGate (`0.9333` same-problem nearest ratio versus `0.8333`), and DeepGate
residual vectors remain nonconstant after removing AIG statistics (`0.4667`
same-problem nearest ratio). This supports keeping the lane active, but full
RTLLM spend still requires better bridge coverage or a bounded live smoke
because only `5/8` screen problems currently embed.

T90 removes that offline coverage blocker by extracting bounded output cones
from the three large skipped transition AIG problems. It embeds `108` cones,
`36` for each skipped problem, with max selected cone size `245` ANDs and max
embedding time `0.0710s`. Combined with the existing full-transition rows,
DeepGate now covers all `8/8` preliminary screen problems offline. This is a
bridge success, not a QD result: the next step must aggregate full-transition
and cone embeddings into candidate-level descriptors and test them by replay
before any live HV spend.

T91 completes that replay. It pools full-transition embeddings for `60`
candidates and cone embeddings for `36` candidates, covering all `96` sampled
candidates across all `8/8` preliminary screen problems. Mean occupied cells
are `10.875` per problem, mean area-power Pareto cells are `4.625`, and every
problem has at least one Pareto cell. This makes DeepGate a credible bounded
live-smoke candidate, but not a final RTLLM arm until it has matched live HV
data.

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

## Pretrained Model Caveat

Current live RTL-native descriptors use source-aligned extractor/count
features, not verified live pretrained MasterRTL or RTLTimer inference. T76
confirms MasterRTL saved tree artifacts are real and loadable in the isolated
RTL-native environment:

- XGBoost Area, Power, WNS, and TNS heads load with asserted feature lengths;
- the RF timing model loads with `joblib` and has nonconstant leaf assignments
  on saved feature vectors;
- the shipped TinyRocket XGBoost example still predicts all zeros, and
  RTL-Timer has no confirmed packaged pretrained checkpoint in the local clone.

The most promising next BD is therefore a generated-candidate variation gate
for MasterRTL tree-leaf or margin embeddings, combined with raw RTL-native
structure. Do not use direct scalar predicted-PPA axes as the primary archive
coordinates.

T77 runs that first variation gate for the source-faithful MasterRTL Area
head. The result is negative: `17/19` generated candidates have unique Area
feature rows, but the pretrained Area head emits one prediction and one leaf
row for every candidate. Retire direct Area-head leaves unless the model is
retrained or replaced. Power and timing remain blocked by missing required
toggle-rate and timing-DAG/path feature flows.

Any future MasterRTL submodule or external-source integration should first
produce a reproduction package: hashes, upstream inference command, internal
loader equivalence, schema assertions, and generated-candidate variation.

## Technique Lanes

| Lane | Examples | Status | Assessment |
| --- | --- | --- | --- |
| RTL-native descriptors | Yosys-SOG/MasterRTL, RTLTimer timing-risk vectors, T15/T60/T61/T62/T63/T64/T65/T66/T67/T68/T69/T70/T71/T72/T73/T74/T75/T76/T77/T80/T81/T82/T83 and the 20260625 auxiliary archive probes | Best methodology lane | Strongest methodology story if it preserves meaningful RTL families while optimizing PPA; exact T72 is near-classic, T73 improves yield/occupancy, T74 regresses, T75 is positive diagnostic, T76 opens the pretrained tree-model lane, T77 retires direct Area-head leaves, T80 advances raw MasterRTL structural mix as a live-candidate gate, T81 finds noncollapsed RF timing model-state descriptors, T82 exposes them through the live descriptor registry, high-exploit auxiliary archive and T83 both narrow the live-screen gap at seed `1001`, but seed replication retires both exact configurations as full-spend candidates. |
| Archive machinery | T26, T30, T48, T51, one-slot local-front variants | Continue selectively | Useful mechanism pieces, but no broad RTLLM win yet. |
| Budget-shape evaluation | T78 audit and T79 `12 x 3`/`8 x 5`/`6 x 7` equal-budget ablation | T79 diagnostic-negative | T78 shows archive maturation can continue late, but T79 shows exact T75 still loses classic at every tested equal-candidate shape. |
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
not promoted because classic still wins the front-breadth metrics. T73 widens
source-aligned archive occupancy and valid-yield signal, but its matched
comparison still leaves classic ahead on mean HV and Pareto breadth.
