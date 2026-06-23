# T70 Generated RTL Extractor Smoke Results

## Tier Decision

`T0 extractor_smoke_unblocker`.

T70 is not a live QD method. It answers the narrower gate raised by T69:
whether source-aligned MasterRTL and RTL-Timer preprocessing can run on
generated REvolution RTL candidates.

## Result

| Group | Count | MasterRTL pass | RTL-Timer pass | Both pass |
| --- | ---: | ---: | ---: | ---: |
| all | `19` | `19` | `19` | `19` |
| first raw | `7` | `7` | `7` | `7` |
| first synthesized | `5` | `5` | `5` | `5` |
| last synthesized | `7` | `7` | `7` | `7` |

The sample spans seven RTLLM problems from the T67 hard/tuning run:
`Prob004_adder_8bit`, `Prob015_multi_pipe_8bit`, `Prob024_fsm`,
`Prob037_parallel2serial`, `Prob041_traffic_light`, `Prob045_alu`, and
`Prob049_signal_generator`.

Five sampled candidates did not already have `code.syn.v`, so the smoke is not
limited to previously successful synthesis outputs.

## Output Richness

The extractors produced differentiated artifacts:

| Metric | Min | Max | Sum |
| --- | ---: | ---: | ---: |
| MasterRTL graph edges | `75` | `4097` | `16645` |
| MasterRTL node-dict entries | `70` | `4098` | `16864` |
| RTL-Timer cleaned BOG lines | `116` | `9965` | `38576` |
| RTL-Timer DFF references | `0` | `51` | `170` |

The pass-rate figure is
`figures/t70_generated_rtl_extractor_smoke.png`.
The artifact-richness figure is
`figures/t70_extractor_richness_by_candidate.png`.

## Interpretation

T70 removes the immediate candidate-distribution concern for the RTL-native
lane. The source-aligned open-Yosys path works on this small but real generated
RTL sample, including raw candidates, simple combinational designs, FSMs,
pipeline logic, and sequential signal generators.

This does not prove that MasterRTL or RTL-Timer descriptors improve PPA search.
It only means the next RTL-native attempt can use real source-aligned extractor
outputs instead of proxy Yosys-stat features.

## Next Decision

Advance to a descriptor-design package that extracts features from a larger
candidate set and defines archive cells from operator/control/dataflow and
timing-risk morphology. Do not launch a broad live RTL-native QD run until the
descriptor feature table and archive-cell mapping are documented and checked
for non-PPA leakage.
