# S32 Capacity4 Seed 1001 Results

Date packaged: 2026-07-10.

Raw run:
`exp/natural_qd_push/suite_variants_wave_f_20260710_083829_UTC/live/capacity4/seed_1001`.

Package:
`suite_variant_campaign/S32_capacity4/seed_1001`.

## Contract

S32 changes only `qd_max_elites_per_cell` from 5 to 4. It keeps the V2
and S07 platform fixed: EoH operators, code-individual representation,
strict ablation, frozen BD trio, grid-quantile archive, NSGA-II global
rank parent selection, 128k token budgets, and
`eoh_success_operator_set=classic`.

## Validation

- Runtime completed normally in 4828.71 seconds with 4800 LLM API calls.
- vLLM preflight passed with `max_model_len=131072`.
- `validate_natural_qd_run.py` passes the full 50-problem manifest and
  the registered config pins.
- `audit_operator_contract.py` passes:
  `single_thought_count=0`, `eoh_strategy_count=800`, and
  `candidate_count=1007`.

## Seed Read

Fixed 46 reference-complete denominator:

| Arm | Mean HV | HV-AUC46 | Coverage |
| --- | ---: | ---: | ---: |
| classic | 0.111401 | 0.090551 | 24/46 |
| V2 | 0.096767 | 0.083539 | 23/46 |
| S07 capacity3 | 0.100296 | 0.091895 | 21/46 |
| S32 capacity4 | 0.096196 | 0.080789 | 21/46 |

S32 is below matched classic by `-0.015205` final HV and `-0.009762`
HV-AUC46. It also trails S07 seed 1001 by `-0.004100` final HV and
`-0.011106` HV-AUC46 while tying S07 coverage.

## Per-Problem Read

Against matched classic, S32 wins final HV on 6 problems, loses on 12,
and ties on 28.

Largest S32 final-HV gains:

| Problem | Delta HV | Delta AUC |
| --- | ---: | ---: |
| Prob002_adder_16bit | 0.140520 | 0.140520 |
| Prob037_parallel2serial | 0.061329 | 0.042972 |
| Prob008_comparator_4bit | 0.030368 | 0.000121 |
| Prob011_multi_16bit | 0.004299 | -0.002229 |
| Prob009_div_16bit | 0.004238 | 0.006228 |
| Prob012_multi_8bit | 0.000868 | 0.000260 |

Largest S32 final-HV losses:

| Problem | Delta HV | Delta AUC |
| --- | ---: | ---: |
| Prob036_edge_detect | -0.538825 | -0.161647 |
| Prob024_fsm | -0.230748 | -0.115067 |
| Prob005_adder_bcd | -0.066113 | -0.085979 |
| Prob025_sequence_detector | -0.043390 | -0.013017 |
| Prob041_traffic_light | -0.020756 | 0.023503 |
| Prob045_alu | -0.014241 | -0.018969 |

## Decision

Close S32 after seed 1001. The mechanism-card stop rule triggers because
S32 reaches only 86.3% of matched classic final HV, below the 90% floor.

Do not launch seed 1002 from current evidence. Capacity4 does not recover
S07's final-HV gap and loses the S07 HV-AUC benefit, so the simple
capacity interpolation path should be classified negative.
