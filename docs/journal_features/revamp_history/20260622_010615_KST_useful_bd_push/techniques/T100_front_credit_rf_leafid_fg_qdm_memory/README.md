# T100 Front-Credit RF-Leaf FG-QDM Memory

T100 tests whether the existing front-guarded QD-memory scheduler improves
when its descriptor is changed from T97's SR-PCA axes to the validated
MasterRTL RF leaf-ID structural axes used by T83.

This is not a new scheduler implementation. It reuses
`qd_scheduler_mode=front_guarded_memory`, keeps the separate
`qd_primary_success_pool`, keeps T97's stricter front-credit threshold, and
changes only the descriptor source.

## Status

Pre-registered. Live smoke pending.

## Descriptor Axes

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

These axes are the T83 RF-leaf structural descriptor. The first axis uses the
validated MasterRTL RF timing model-state path, while the other two axes keep
the archive tied to source-aligned RTL structure.

## Promotion Gate

T100 can only move beyond the three-problem smoke if:

- every classic-covered smoke problem remains covered;
- mean HV is near T97 or better;
- memory-refine or front-rescue produces global-front material, or a clearly
  quality-productive local-front insertion;
- the descriptor does not collapse on the smoke problems;
- validation logs show the real RF timing descriptor path was used.

If it fails these gates, keep T97 as the FG-QDM representative and do not spend
an eight-design or full-RTLLM budget on this exact variant.
