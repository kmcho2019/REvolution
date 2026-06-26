# MasterRTL RF Timing Runtime Hook

Status: implementation gate passed; live QD smoke still pending.

This package records T82, the runtime hook that turns T81's offline
MasterRTL RF timing-state evidence into a selectable live descriptor profile.

## Decision

The preliminary plan is still not finished. T82 clears the implementation
blocker for a new pretrained model-state arm, but no QD/PPA screen has run.

## Next Gate

Run a tiny live vLLM smoke with:

- descriptor profile `source_aligned_rf_timing_state_3d`;
- frozen endpoint/model preflight;
- one problem, preferably `Prob015_multi_pipe_8bit`;
- explicit archive-artifact and descriptor-value checks.

Advance to the frozen `8x5` screen only if the smoke emits valid archive
artifacts and descriptor values without breaking candidate evaluation.
