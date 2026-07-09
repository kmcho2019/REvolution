# S07 Capacity 3 Seed 1001

## Run

- Variant: `S07_capacity3`
- Change: `qd_max_elites_per_cell=3`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001`
- Runtime: 4763.21 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 13 |
| S07 capacity 3 | 0.100296 | 0.091895 | 32/46 | 14 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 6 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Decision

Do not promote S07 from one seed. Capacity 3 is V2-positive on final HV
and beats both matched comparators on HV-AUC46, but it trails classic
final HV by about 10.0% and loses one coverage point against classic.

Classify seed 1001 as an HV-AUC-positive capacity-control signal. A seed
1002 replication is reasonable if the campaign continues the two-seed
probe ladder, but this seed alone does not meet the TCAD primary gate of
matching or improving classic final PPA HV.
