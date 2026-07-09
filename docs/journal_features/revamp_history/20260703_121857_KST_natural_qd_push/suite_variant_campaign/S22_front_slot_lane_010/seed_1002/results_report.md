# S22 Front-Slot Lane 0.10 Seed 1002

## Run

- Variant: `S22_front_slot_lane_010`
- Change: `elite_pareto_slot` retention with
  `qd_front_slot_lane_fraction=0.10`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_164211_UTC/live/front_slot_lane_010/seed_1002`
- Runtime: 4747.64 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 18 |
| S22 front-slot lane 0.10 | 0.100856 | 0.089351 | 32/46 | 11 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 5 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Two-Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.104479 | 0.085867 | 66/92 | 33 |
| S22 front-slot lane 0.10 | 0.101722 | 0.089115 | 66/92 | 21 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 | 14 |

## Decision

Do not promote S22 to five seeds as a primary HV arm. The conservative
front-slot lane beats V2 on all two-seed aggregate metrics and beats
classic on HV-AUC46 while tying classic coverage, but it still trails
classic final HV by about 2.6%.

Classify S22 as an HV-AUC-positive front-slot interpolation control. It
is useful evidence that a smaller archive-parent lane can improve
trajectory quality without hurting two-seed functionality coverage, but
it does not meet the TCAD primary gate of matching or improving classic
final PPA HV.
