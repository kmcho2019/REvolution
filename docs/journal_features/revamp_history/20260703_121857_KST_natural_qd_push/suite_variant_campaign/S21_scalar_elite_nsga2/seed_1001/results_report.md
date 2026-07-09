# S21 Scalar-Elite NSGA-II Seed 1001

## Run

- Variant: `S21_scalar_elite_nsga2`
- Change: `qd_cell_mode=scalar_elite`, `qd_max_elites_per_cell=1`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_003700_UTC/live/scalar_elite_nsga2/seed_1001`
- Runtime: 4735.83 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 18 |
| S21 scalar elite | 0.089155 | 0.082753 | 34/46 | 10 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 7 |

## Decision

S21 seed 1001 is a weak coverage-only signal, not a primary HV signal. It
covers one more reference-complete problem than matched classic and two
more than matched V2, but it loses too much final HV and slightly trails
V2 on HV-AUC46.

Complete seed 1002 before closing S21. The variant is the canonical
one-elite MAP-Elites control and is a useful retention baseline for the
negative S20 parent-selection result, but it should not be promoted
unless seed 1002 strongly recovers HV/AUC or the two-seed read exposes a
clear coverage-only manuscript utility.
