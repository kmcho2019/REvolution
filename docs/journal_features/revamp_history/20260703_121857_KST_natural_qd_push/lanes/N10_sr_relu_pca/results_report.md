# N10 SR-ReLU PCA - Result

Run:
`exp/natural_qd_push/n10_sr_relu_pca_20260707_152554_UTC/live/sr_relu_pca_3d/seed_1001`.

The live screen used the V2 platform with exactly one mechanism change:
`qd_descriptor_file=lanes/N10_sr_relu_pca/descriptor_profile.yaml` and
`qd_descriptor_profile=sr_pca_3d`. Config validation passes,
`qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
and `single_thought_count=0`.

## Probe Result

The bounded extraction smoke completed on 2026-07-07 at
`smokes/sr_relu_pca_20260707_151320_UTC/`.

| Check | Result |
| --- | --- |
| Frozen profile resolves | pass (`sr_pca_0`, `sr_pca_1`, `sr_pca_2`) |
| PPA-free requirement | pass (`requires_ppa=false`) |
| Screen/training overlap | pass (`[]`) |
| ST-NOD extraction | pass on 8/8 existing V2 candidates |
| Descriptor health | pass: initialized `4x4x4`, 8 occupied cells |
| Collapsed axes | none |

This is not an HV or functionality result. It only clears the registered
gate for one seed-1001 V2-faithful live screen.

## Live Read (frozen 8-design 8x5, seed 1001)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Pareto pts | Valid PPA | Coverage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| classic (ref) | 0.14064 | - | -19.1% | 0.12387 | 3.250 | 191 | 8/8 |
| V2 pareto_front_5 (ref) | 0.17376 | +23.5% | - | 0.14366 | 2.625 | 196 | 8/8 |
| N10 SR-ReLU PCA | 0.15683 | +11.5% | -9.7% | 0.13411 | 2.125 | 139 | 8/8 |

N10 final-HV W/L/T is `2/3/3` vs classic and `1/2/5` vs V2. HV-AUC
W/L/T is `3/3/2` vs classic and `1/5/2` vs V2. It clears the classic
mean-HV and mean-HV-AUC bars but does not beat V2 on either primary
metric.

## Descriptor And Yield Health

| Problem | Initialized | Collapsed axes | Occupied cells |
| --- | --- | --- | --- |
| Prob015_multi_pipe_8bit | yes | 0 | 11 |
| Prob024_fsm | yes | 0 | 6 |
| Prob041_traffic_light | yes | 0 | 7 |
| Prob045_alu | yes | 0 | 14 |
| Prob049_signal_generator | yes | 0 | 2 |
| Prob116_m2014_q3 | yes | 0 | 2 |
| Prob135_m2014_q6b | yes | sr_pca_0, sr_pca_1, sr_pca_2 | 1 |
| Prob153_gshare | yes | 0 | 7 |

Aggregate: `7/8` problems keep all SR-PCA axes live, but the run still
has lower valid-PPA yield than both references (`139` vs V2's `196`) and
lower Pareto breadth (`2.125` vs V2's `2.625`). The descriptor triggers
the QD fill/backfill lanes (`other_strategy_count=27`, all M-T/C-D) while
remaining single-thought clean.

## Verdict: DIAGNOSTIC KEEPER, NO ESCALATION

Cause class: yield-loss plus front-loss. SR-ReLU PCA is a natural
descriptor-only extension and smoke health transferred better than N07a/N07c,
but it does not improve the V2 search outcome. The PCA space finds the V2
best point on fsm and ties key VerilogEval points, but loses too much valid
front material on traffic_light, alu, and the sequential tasks.

Do not escalate N10 to seeds 1002/1003 under the registered rule, because
seed 1001 does not beat V2 on both HV and HV-AUC. Full-RTLLM use would
also require a new holdout-clean SR-ReLU artifact because the old T19
fitting corpus includes RTLLM problems.
