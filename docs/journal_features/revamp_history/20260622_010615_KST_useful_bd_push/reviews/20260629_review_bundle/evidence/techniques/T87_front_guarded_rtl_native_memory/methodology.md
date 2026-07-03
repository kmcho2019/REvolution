# T87 Methodology

T87 is a descriptor-swap test for FG-QDM.

## Fixed Search Policy

Keep the front-guarded memory scheduler fixed:

- `qd_scheduler_mode=front_guarded_memory`
- `qd_parent_selection=front_guarded_memory`
- `qd_memory_classic_fraction=0.80`
- `qd_memory_refine_fraction=0.15`
- `qd_memory_rescue_fraction=0.05`
- `qd_memory_probe_fraction=0.00`
- `qd_two_parent_probability=0.00`
- `qd_grid_quantile_warmup_successes=4`
- `qd_fill_target_fraction=0.00`
- `qd_improve_backfill_fraction=0.00`

The archive remains passive memory. Empty-cell fill receives no budget. The
primary success pool remains the classic-style parent pool.

## Descriptor

Use `source_aligned_shape_density_3d`. This is an RTL-native descriptor over
source-aligned MasterRTL/RTLTimer features:

| Axis | Meaning |
| --- | --- |
| `source_aligned_masterrtl_branching` | Graph-edge density from the source-aligned MasterRTL SOG extraction. |
| `source_aligned_rtltimer_wire_density` | Wire declarations normalized by RTL line count. |
| `source_aligned_rtltimer_dff_density` | DFF references normalized by RTL line count. |

This tests whether FG-QDM works better when memory cells represent RTL
implementation-family shape rather than synthesis-response PCA or random
hashes.

## Matched Comparators

Compare against:

- classic `12x3` smoke;
- `fg_qdm_sr_memory_warmup4_12x3`;
- `fg_qdm_random_memory_12x3`.

Primary metrics are mean HV, Pareto point count, reference-beating candidates,
classic-covered design preservation, and memory-lane front contribution.
