# S07 Five-Seed Statistics and Mechanism Notes

Scope: full RTLLM 46 reference-complete PPA package, seeds 1001-1005.
Treatment is `S07_capacity3`; baseline is matched classic REvolution.

## Headline Read

| Arm | Mean HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.103802 | 0.086982 | 164/230 | 74 |
| S07 | 0.102481 | 0.088031 | 165/230 | 60 |
| V2 | 0.098801 | 0.087428 | 166/230 | 35 |

S07 misses the primary final-HV gate versus classic: `0.102481` vs `0.103802` (-0.001321, 98.7%). It remains positive on HV-AUC46 (+0.001049) and coverage (+1/230), and it beats V2 on final HV and HV-AUC46.

## Seed-Paired Tests

The table uses five seed-paired deltas. Tests are descriptive because n=5.

| Metric | Mean Delta | Median Delta | + / - / tie seeds | Sign p | Wilcoxon p | Paired t p |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Mean HV | -0.001322 | -0.001628 | 2/3/0 | 1.0000 | 0.6250 | 0.7744 |
| HV-AUC46 | 0.001049 | 0.001344 | 3/2/0 | 1.0000 | 0.8125 | 0.7198 |
| Coverage count | 0.200000 | 0.000000 | 2/1/2 | 1.0000 | 1.0000 | 0.6213 |
| HV win count | -2.800000 | -3.000000 | 1/4/0 | 0.3750 | 0.1875 | 0.1079 |

## Per-Problem Win/Loss Map

S07 wins mean final HV on 15 problems, classic wins on 8, and 23 tie. Coverage improves on 3 problems and drops on 4 problems.

Largest S07 mean-HV gains:

| Problem | ΔHV | ΔAUC | S07/classic/tie seed HV wins | Coverage Δ |
| --- | ---: | ---: | ---: | ---: |
| Prob038_pulse_detect | 0.064393 | 0.067008 | 1/1/3 | -1 |
| Prob031_freq_div | 0.037363 | 0.000592 | 3/2/0 | 0 |
| Prob002_adder_16bit | 0.028104 | 0.028104 | 1/0/4 | 0 |
| Prob015_multi_pipe_8bit | 0.022451 | 0.022427 | 2/0/3 | 3 |
| Prob029_barrel_shifter | 0.020503 | 0.006833 | 2/2/1 | 1 |
| Prob037_parallel2serial | 0.018127 | 0.005448 | 1/3/1 | -1 |
| Prob024_fsm | 0.013951 | 0.053169 | 2/1/2 | 0 |
| Prob008_comparator_4bit | 0.012147 | 0.009172 | 2/0/3 | 0 |

Largest S07 mean-HV losses:

| Problem | ΔHV | ΔAUC | S07/classic/tie seed HV wins | Coverage Δ |
| --- | ---: | ---: | ---: | ---: |
| Prob036_edge_detect | -0.170156 | 0.006441 | 1/2/2 | 0 |
| Prob041_traffic_light | -0.060626 | -0.000279 | 1/4/0 | 0 |
| Prob025_sequence_detector | -0.030668 | -0.014973 | 0/5/0 | -2 |
| Prob019_sub_64bit | -0.018709 | -0.135147 | 1/4/0 | 0 |
| Prob045_alu | -0.016841 | -0.017915 | 3/2/0 | 0 |
| Prob009_div_16bit | -0.004274 | -0.003981 | 0/5/0 | 0 |
| Prob005_adder_bcd | -0.000021 | 0.003948 | 0/1/4 | 0 |
| Prob048_pe | -0.000000 | -0.000000 | 0/1/4 | 0 |

## Mechanism Case Studies

### Prob015_multi_pipe_8bit

| Arm | Mean HV | HV-AUC | Covered seeds | Mean ref-beating candidates | Mean Pareto points |
| --- | ---: | ---: | ---: | ---: | ---: |
| classic | 0.000000 | 0.000000 | 0/5 | 0.00 | 5.40 |
| S07 | 0.022451 | 0.022427 | 3/5 | 0.60 | 5.20 |
| V2 | 0.000003 | 0.000002 | 1/5 | 0.20 | 5.80 |

Read:
- S07 is the clear positive case: it improves mean HV and HV-AUC over classic and V2, recovers coverage on 3/5 seeds where classic has 0/5, and has more reference-beating candidates than classic on average. This supports the compact-retention story on a sequential pipeline problem.

### Prob024_fsm

| Arm | Mean HV | HV-AUC | Covered seeds | Mean ref-beating candidates | Mean Pareto points |
| --- | ---: | ---: | ---: | ---: | ---: |
| classic | 0.286544 | 0.162461 | 5/5 | 4.80 | 1.20 |
| S07 | 0.300494 | 0.215630 | 5/5 | 5.00 | 1.20 |
| V2 | 0.205518 | 0.117448 | 4/5 | 4.40 | 1.60 |

Read:
- Prob024 is a positive trajectory case: S07 keeps 5/5 coverage, beats classic and V2 on mean HV/AUC, and slightly increases the mean reference-beating count. It is a useful example of compact retention helping without changing the operator substrate.

## Decision

Classify S07 as `five-seed HV-negative, HV-AUC-positive, coverage-positive`. It is not the primary TCAD final-HV lane. The useful mechanism signal is that smaller per-cell Pareto retention can improve trajectory quality and preserve coverage without changing operators. Next variants should test whether descriptor health or descriptor reduction can recover the remaining final-HV gap.
