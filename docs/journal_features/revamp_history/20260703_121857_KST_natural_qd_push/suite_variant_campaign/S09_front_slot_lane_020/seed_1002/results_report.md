# S09 Front-Slot Lane 0.20 Seed 1002

## Run

- Variant: `S09_front_slot_lane_020`
- Change: `elite_pareto_slot` retention with
  `qd_front_slot_lane_fraction=0.20`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_134750_UTC/live/front_slot_lane_020/seed_1002`
- Runtime: 4731.28 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 18 |
| S09 front-slot lane 0.20 | 0.090574 | 0.077897 | 32/46 | 9 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 7 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Two-Seed Read

| Arm | HV | HV-AUC46 | Coverage |
| --- | ---: | ---: | ---: |
| classic REvolution | 0.104479 | 0.085867 | 66/92 |
| S09 front-slot lane 0.20 | 0.096357 | 0.085650 | 66/92 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 |

## Decision

Do not promote S09 to five seeds. Seed 1001 was a real positive probe,
but seed 1002 reverses the result: S09 trails matched classic and V2 on
HV and HV-AUC46 and covers one fewer reference-complete problem than
both comparators.

Classify S09 as `front-loss`. Across two seeds it ties classic coverage
and covers one more problem than V2, but the retained fronts are weaker:
mean HV trails classic by 7.8% and V2 by 2.2%, and HV-AUC46 is just
below classic while clearly below V2. The natural mechanism remains
interesting as a parent-source interpolation control, but this exact
0.20 lane is not a TCAD primary-arm candidate.
