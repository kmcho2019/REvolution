# T18 Adaptive Emitter CVT BD

Status: `T0 retrospective_retired`.

T18 is closed as a retrospective synthesis rather than a new live run. The
intended idea was to combine adaptive archive geometry with separate exploit,
explore, and repair/front-preserving emitters. Two later measured packages
already test those ingredients closely enough to make a fresh T18 spend
unjustified:

- `T57_t51_adaptive_rebin_qd`: adaptive grid-quantile archive geometry.
- `T32_sr_raw_front_preserving_emitter_qd`: front-preserving emitter schedule.

The result is negative for the exact T18 line. T57's rebin mechanism never
actuated and lost headline HV/HV-AUC/front breadth versus classic. T32 improved
some validity and unique-PPA counters versus a repair variant, but did not
preserve T26's holdout HV/quality signal.

Use this package to understand why the adaptive-emitter/CVT direction should
not continue as another small schedule or boundary tweak. A future emitter lane
would need a materially different source-level direct-code repair or
front-rescue mechanism with explicit per-lane yield and front-add counters.
