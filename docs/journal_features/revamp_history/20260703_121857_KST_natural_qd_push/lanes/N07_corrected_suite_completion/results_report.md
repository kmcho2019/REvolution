# N07 Corrected-Suite Completion - Results

N07 is due diligence for unfinished corrected-suite descriptor profiles.
Both live arms used the V2 platform with exactly one mechanism change:
`qd_descriptor_profile`. Config validation passes,
`qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
and `single_thought_count=0`.

Run roots:

- N07a: `exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001`
- N07c: `exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001`

Package artifacts in this directory use the `n07a_*` and `n07c_*`
prefixes.

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Coverage |
| --- | --- | --- | --- | --- | --- |
| classic (ref) | 0.14064 | - | -19.1% | 0.12387 | 8/8 |
| V2 trio (ref) | 0.17376 | +23.5% | - | 0.14366 | 8/8 |
| N07a source-aligned RF timing | 0.12759 | -9.3% | -26.6% | 0.10013 | 8/8 |
| N07c implemented structural compact | 0.12395 | -11.9% | -28.7% | 0.10457 | 8/8 |

N07a final-HV W/L/T is `2/3/3` vs classic and `2/3/3` vs V2. N07c
final-HV W/L/T is `1/4/3` vs classic and `1/4/3` vs V2. Both arms fail
the registered close rule because their mean HV is below `0.95x` matched
classic. N07c HV-AUC is `84.4%` of classic and `72.8%` of V2.

## N07a Descriptor Health

The N07a reference-only extraction smoke was healthy, but live generated
candidates were not:

| Problem | Initialized | Collapsed axes | Occupied cells |
| --- | --- | --- | --- |
| Prob015_multi_pipe_8bit | yes | 0 | 10 |
| Prob024_fsm | no | 0 | 0 |
| Prob041_traffic_light | yes | 0 | 9 |
| Prob045_alu | yes | 2 | 3 |
| Prob049_signal_generator | yes | 1 | 3 |
| Prob116_m2014_q3 | yes | 2 | 4 |
| Prob135_m2014_q6b | yes | 2 | 3 |
| Prob153_gshare | yes | 2 | 3 |

Aggregate: `5/8` problems have collapsed axes, `1/8` never initializes,
and the run occupies 35 cells total.

## N07c Descriptor Health

The N07c smoke was healthy on existing V2 generated-candidate synthesis
metrics, but the live run still degraded on the generated distribution:

| Problem | Initialized | Collapsed axes | Occupied cells |
| --- | --- | --- | --- |
| Prob015_multi_pipe_8bit | yes | 0 | 9 |
| Prob024_fsm | yes | adder_ratio | 4 |
| Prob041_traffic_light | yes | 0 | 13 |
| Prob045_alu | no | 0 | 0 |
| Prob049_signal_generator | yes | 0 | 3 |
| Prob116_m2014_q3 | yes | comb_ratio; adder_ratio | 1 |
| Prob135_m2014_q6b | yes | comb_ratio; adder_ratio; cell_count_log | 1 |
| Prob153_gshare | no | 0 | 0 |

Aggregate: `3/8` problems have collapsed axes, `2/8` never initialize,
and the run occupies 31 cells total.

## Verdict: CLOSE N07a and N07c

Cause class: descriptor-collapse plus front-loss. Both descriptor ideas
are natural, but descriptor-only corrected-suite variants do not add
front material under the V2 engine. N07c also shows that a smoke-healthy
feature path can still collapse during live generation.

Do not escalate N07a or N07c to seeds 1002/1003. N07b remains
bounded-extraction-smoke gated and should stay low priority unless the
campaign explicitly wants to finish the last corrected-suite
due-diligence arm.
