# S07 Capacity 3 Seed 1003

## Run

- Variant: `S07_capacity3`
- Change: `qd_max_elites_per_cell=3`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_213030_UTC/live/capacity3/seed_1003`
- Runtime: 4722.00 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.102093 | 0.087210 | 33/46 | 14 |
| S07 capacity 3 | 0.100464 | 0.087032 | 33/46 | 10 |
| Smooth-QD V2 | 0.099854 | 0.090295 | 35/46 | 11 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Three-Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.103684 | 0.086315 | 99/138 | 44 |
| S07 capacity 3 | 0.102130 | 0.089267 | 99/138 | 38 |
| Smooth-QD V2 | 0.098977 | 0.088196 | 100/138 | 20 |

## Decision

S07 remains an HV-AUC-positive capacity near-miss, not a primary final-HV
win. Seed 1003 nearly matches classic on HV/HV-AUC46 and ties classic
coverage, but does not clear the primary gate. Across three seeds S07
beats V2 on HV and HV-AUC46, beats classic on HV-AUC46, and ties classic
coverage, but trails classic final HV by about 1.5%.

Continue the pre-registered confirmation ladder to seed 1004 before
deciding whether S07 deserves the full seed 1005 run. Do not claim S07
as the TCAD primary arm unless the final five-seed aggregate meets or
beats classic final HV while retaining coverage.
