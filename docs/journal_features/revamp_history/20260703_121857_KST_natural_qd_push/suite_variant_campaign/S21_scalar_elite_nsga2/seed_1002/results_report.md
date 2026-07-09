# S21 Scalar-Elite NSGA-II Seed 1002

## Run

- Variant: `S21_scalar_elite_nsga2`
- Change: `qd_cell_mode=scalar_elite`, `qd_max_elites_per_cell=1`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_020320_UTC/live/scalar_elite_nsga2/seed_1002`
- Runtime: 4751.68 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 20 |
| S21 scalar elite | 0.084834 | 0.078138 | 31/46 | 8 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 6 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Two-Seed Read

| Arm | HV | HV-AUC46 | Coverage |
| --- | ---: | ---: | ---: |
| classic REvolution | 0.104479 | 0.085867 | 66/92 |
| S21 scalar elite | 0.086994 | 0.080445 | 65/92 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 |

## Decision

Do not promote S21. Seed 1002 confirms that scalar one-elite retention is
a clean natural MAP-Elites control, but it does not recover the PPA
hypervolume lost by seed 1001. Across two seeds, S21 trails matched
classic on HV, HV-AUC46, and coverage, and trails V2 on HV and HV-AUC46
while tying V2 coverage.

Use S21 as a negative retention-control result: forcing one scalar elite
per cell reduces archive complexity, but it does not translate to a
stronger full-RTLLM PPA/functionality profile under the operator-fair
V2 suite contract.
