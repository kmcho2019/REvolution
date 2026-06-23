# T73 Results Report

## Current Tier

`pending_live_screen`.

T73 has not produced a live vLLM result yet. It must not be used as evidence
that QD/MAP-Elites beats classic REvolution.

## What Is Answered So Far

The pre-run audit answers a narrower descriptor-design question:

Does T72 fail partly because its source-aligned descriptor cells collapse?

Yes. On the fixed T72 run, the live archive occupied a mean of only `1.0769`
fixed cells per problem. The second T72 axis,
`rtltimer_state_timing_class`, had one unique value for every problem in the
archive-event replay.

Does T73 offer a plausible source-aligned fix without PPA leakage?

Yes, as a screen candidate. The three T73 axes are derived only from
MasterRTL/RTL-Timer source-aligned counts. A posthoc problem-local quantile
projection over the same T72 candidates gives a mean of `5.6923` occupied
cells per problem and a minimum of `2`.

## What Is Not Answered

The audit does not prove better PPA, better HV, or better QD utility. It only
shows that the proposed source-aligned axes are less collapsed before live
spend.

## Figure Inspection

`figures/t73_descriptor_occupancy_audit.png` was inspected after regeneration.
The figure is readable at full width, uses conventional grouped bars, labels
T72 fixed-grid occupancy separately from T73 observed-range and local-quantile
projections, and makes the descriptor-collapse fix visually clear.

## Next Required Step

Run the bounded hard/tuning live screen from `commands/live_screen_v0.md`.
Then package a matched classic comparison with reference-complete headline
metrics. Promote T73 only if it preserves classic-covered designs and improves
front-material or HV/HV-AUC evidence without relying on missing-reference or
duplicate diversity artifacts.
