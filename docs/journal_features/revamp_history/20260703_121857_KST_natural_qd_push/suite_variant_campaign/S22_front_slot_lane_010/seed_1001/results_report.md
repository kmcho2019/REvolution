# S22 Front-Slot Lane 0.10 Seed 1001

## Run

- Variant: `S22_front_slot_lane_010`
- Change: `elite_pareto_slot` retention with
  `qd_front_slot_lane_fraction=0.10`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_151403_UTC/live/front_slot_lane_010/seed_1001`
- Runtime: 4748.79 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 15 |
| S22 front-slot lane 0.10 | 0.102589 | 0.088878 | 34/46 | 10 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 9 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Decision

Complete seed 1002. S22 is a cleaner conservative follow-up than S09
0.20 on this seed: it beats V2 on HV, HV-AUC46, coverage, and HV wins,
and it covers one more reference-complete problem than matched classic.

Do not promote on one seed. S22 still trails matched classic by about
7.9% final HV and 1.8% HV-AUC46, so the mechanism is only a candidate
for a coverage-preserving/front-recovery probe until seed 1002 confirms
or reverses the signal.
