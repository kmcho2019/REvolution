# N07 Corrected-Suite Completion - N07a Result

Run: `exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/`.
Package artifacts in this directory use the `n07a_*` prefix.

The live screen used the V2 platform with only one mechanism change:
`qd_descriptor_profile=source_aligned_rf_timing_state_3d`. Config
validation passes, `qd_operator_kind=eoh_strategies`,
`representation_kind=code_individual`, and `single_thought_count=0`.

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Coverage |
| --- | --- | --- | --- | --- | --- |
| classic (ref) | 0.14064 | - | -19.1% | 0.12387 | 8/8 |
| V2 trio (ref) | 0.17376 | +23.5% | - | 0.14366 | 8/8 |
| N07a source-aligned RF timing | 0.12759 | -9.3% | -26.6% | 0.10013 | 8/8 |

N07a final-HV W/L/T is `2/3/3` vs classic and `2/3/3` vs V2, but the
mean read fails the registered close rule: mean HV is only `90.7%` of
matched classic, below the `0.95x` threshold. HV-AUC is weaker still at
`80.8%` of classic and `69.7%` of V2.

## Descriptor Health

The reference-only extraction smoke was healthy, but live generated
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
and the run occupies 35 cells total. This is a live-candidate
descriptor-collapse signal, not just a reference-extraction issue.

## Verdict: CLOSE N07a

Cause class: descriptor-collapse plus front-loss. Source-aligned RF
timing is a natural descriptor idea, but under the V2 engine it mostly
degenerates on generated candidates and loses both final HV and HV-AUC.
Do not escalate N07a to seeds 1002/1003.

N07b and N07c remain smoke-gated due-diligence arms. They should only run
if their extraction smoke clears and the campaign still needs this
low-priority corrected-suite completion read.
