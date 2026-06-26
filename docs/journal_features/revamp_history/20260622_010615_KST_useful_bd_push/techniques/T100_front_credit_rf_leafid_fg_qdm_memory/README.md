# T100 Front-Credit RF-Leaf FG-QDM Memory

T100 tests whether the existing front-guarded QD-memory scheduler improves
when its descriptor is changed from T97's SR-PCA axes to the validated
MasterRTL RF leaf-ID structural axes used by T83.

This is not a new scheduler implementation. It reuses
`qd_scheduler_mode=front_guarded_memory`, keeps the separate
`qd_primary_success_pool`, keeps T97's stricter front-credit threshold, and
changes only the descriptor source.

## Status

Completed three-problem smoke. T100 is now the best FG-QDM smoke by mean HV,
but it is not promoted for an eight-design or full-RTLLM run.

The matched smoke result is:

| Arm | Mean HV | Mean Pareto points | Mean reference-beating count |
| --- | ---: | ---: | ---: |
| `classic_revolution_12x3` | `0.190331` | `3.00` | `17.33` |
| `fg_qdm_rf_leafid_front_credit_12x3` | `0.156553` | `2.00` | `12.00` |
| `fg_qdm_sr_front_credit_12x3` | `0.153384` | `1.67` | `9.33` |
| `fg_qdm_random_front_credit_12x3` | `0.104805` | `2.67` | `7.00` |

T100 improves slightly over T97's SR descriptor under the same front-credit
FG-QDM policy and clearly beats the same-threshold random-memory control, but
classic still wins all three per-problem HV comparisons.

Mechanism read: `front_rescue` produced `4/4` valid-PPA children and `2`
global-front additions; `memory_refine` produced `2/6` valid-PPA children and
`0` global-front additions. That is a better mechanism signal than T97, but
not enough to promote the exact configuration.

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

Outcome: the HV gate is near T97 and the front-rescue mechanism gate passes,
but the classic comparison fails. Keep T100 as the FG-QDM category
representative and do not escalate it without a new reason.
