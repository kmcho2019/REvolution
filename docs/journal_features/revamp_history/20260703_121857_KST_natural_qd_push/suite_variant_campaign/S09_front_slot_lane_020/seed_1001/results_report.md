# S09 Front-Slot Lane 0.20 Seed 1001

## Run

- Variant: `S09_front_slot_lane_020`
- Change: `elite_pareto_slot` retention with
  `qd_front_slot_lane_fraction=0.20`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_103042_UTC/live/front_slot_lane_020/seed_1001`
- Runtime: 4809.40 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 17 |
| S09 front-slot lane 0.20 | 0.102139 | 0.093403 | 34/46 | 7 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 10 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Decision

Complete seed 1002 after the planned server restart. S09 seed 1001 is a
clean positive probe for the front-slot interpolation idea: it beats V2
on final HV, beats both classic and V2 on HV-AUC46, and covers one more
reference-complete problem than classic.

Do not treat this as a manuscript-grade conclusion yet. Final HV still
trails matched classic by about 8.3%, and prior full-suite probes have
shown seed volatility. The correct next step is a second full-RTLLM seed
with the same parity pins before considering any five-seed confirmation.
