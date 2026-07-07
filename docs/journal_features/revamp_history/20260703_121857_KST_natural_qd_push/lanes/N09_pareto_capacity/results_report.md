# N09 Pareto Capacity - Result

Run:
`exp/natural_qd_push/n09_pareto_capacity_20260707_142703_UTC/live/pareto_front_7/seed_1001`.

The live screen used the V2 platform with exactly one knob changed:
`qd_max_elites_per_cell=7` instead of 5. Config validation passes,
`qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
and `single_thought_count=0`.

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Pareto pts | Coverage |
| --- | --- | --- | --- | --- | --- | --- |
| classic (ref) | 0.14064 | - | -19.1% | 0.12387 | 3.250 | 8/8 |
| V2 pareto_front_5 (ref) | 0.17376 | +23.5% | - | 0.14366 | 2.625 | 8/8 |
| N09 pareto_front_7 | 0.15928 | +13.3% | -8.3% | 0.14183 | 2.375 | 8/8 |

N09 final-HV W/L/T is `1/4/3` vs classic and `1/3/4` vs V2. It clears
the classic mean-HV and HV-AUC bar, but it does not beat V2 on either
primary metric and has fewer Pareto points than both references.

## Descriptor And Yield Health

| Problem | Initialized | Collapsed axes | Occupied cells |
| --- | --- | --- | --- |
| Prob015_multi_pipe_8bit | yes | 0 | 10 |
| Prob024_fsm | yes | ff_depth | 4 |
| Prob041_traffic_light | yes | 0 | 5 |
| Prob045_alu | yes | ff_depth | 11 |
| Prob049_signal_generator | yes | ff_depth | 3 |
| Prob116_m2014_q3 | yes | ff_depth | 4 |
| Prob135_m2014_q6b | yes | ff_depth | 3 |
| Prob153_gshare | yes | ff_depth | 6 |

Aggregate: `6/8` problems have collapsed axes, all archives initialize,
and the run occupies 46 cells total. Valid-PPA candidates are lower than
V2 overall (`182` vs `196`), with the largest drop on gshare (`8` vs
`13`).

## Verdict: DIAGNOSTIC KEEPER, NO ESCALATION

Cause class: capacity-inert plus front-loss. Raising per-cell capacity
from five to seven keeps the run operator-clean and improves mean HV/AUC
over classic, but it does not add front material relative to V2. The
extra capacity mostly leaves the V2 ordering intact while slightly
taxing valid-PPA yield and Pareto breadth.

Do not escalate N09 to seeds 1002/1003 under the registered rule, because
seed 1001 does not beat V2 on both HV and HV-AUC. Do not scan capacity
values without a new mechanism card.
