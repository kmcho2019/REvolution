# T100 Preregistration

## Motivation

T97 is the strongest FG-QDM smoke so far, but its SR memory lanes produce no
global-front additions. T83's RF leaf-ID structural descriptor is the strongest
validated pretrained model-state lane. T100 combines those two clues without
adding another scheduler mechanism.

## Frozen Arm

| Field | Value |
| --- | --- |
| Method key | `fg_qdm_rf_leafid_front_credit_12x3` |
| Scheduler | `front_guarded_memory` |
| Descriptor axes | `source_aligned_rf_timing_leaf_ids`, `source_aligned_masterrtl_branching`, `source_aligned_rtltimer_wire_density` |
| Budget | `12x3` |
| Seed | `1001` |
| Problems | `Prob045_alu`, `Prob041_traffic_light`, `Prob015_multi_pipe_8bit` |
| Run root | `exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626/` |

## Stop/Go Gate

Stop after the three-problem smoke unless T100 has:

- no classic-covered coverage loss;
- mean HV close to or above T97's `0.1534`;
- at least one memory-lane global-front addition or clearly quality-productive
  local-front insertion;
- descriptor health showing the RF leaf-ID path is active and nonconstant on
  at least one smoke problem.

If these fail, record a negative result and keep the exact T97 configuration
as the FG-QDM representative.

## Outcome

T100 passed the internal T97/control comparison but failed the classic
promotion comparison.

| Arm | Mean HV | Read |
| --- | ---: | --- |
| `classic_revolution_12x3` | `0.190331` | Still strongest. |
| `fg_qdm_rf_leafid_front_credit_12x3` | `0.156553` | Best FG-QDM smoke so far. |
| `fg_qdm_sr_front_credit_12x3` | `0.153384` | Previous FG-QDM representative. |
| `fg_qdm_random_front_credit_12x3` | `0.104805` | Same-threshold random control. |

The useful mechanism signal is from `front_rescue`, which produced `2`
global-front additions across `4` generated calls. The `memory_refine` lane
still produced `0` global-front additions.
