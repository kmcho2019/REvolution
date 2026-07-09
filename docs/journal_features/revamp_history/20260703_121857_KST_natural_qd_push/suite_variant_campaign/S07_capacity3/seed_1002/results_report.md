# S07 Capacity 3 Seed 1002

## Run

- Variant: `S07_capacity3`
- Change: `qd_max_elites_per_cell=3`
- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/live/capacity3/seed_1002`
- Runtime: 4758.87 seconds
- LLM API calls: 4800
- Validation: `tables/run_validation.json` passes the full 50-problem
  RTLLM manifest.
- Operator contract: `tables/operator_contract.csv` passes with
  `single_thought_count=0`.

## Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 17 |
| S07 capacity 3 | 0.105630 | 0.088873 | 34/46 | 14 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 3 |

Coverage is successful-candidate coverage over the 46
reference-complete problems. HV-AUC46 uses the fixed 46-problem
denominator.

## Two-Seed Read

| Arm | HV | HV-AUC46 | Coverage | HV wins |
| --- | ---: | ---: | ---: | ---: |
| classic REvolution | 0.104479 | 0.085867 | 66/92 | 30 |
| S07 capacity 3 | 0.102963 | 0.090384 | 66/92 | 28 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 | 9 |

## Decision

Do not claim S07 as a primary final-HV win. Capacity 3 is the strongest
capacity/retention near-miss so far: it beats V2 on all two-seed
aggregate metrics, beats classic on HV-AUC46, and ties classic coverage,
but it still trails classic final HV by about 1.5%.

Classify S07 as an HV-AUC-positive, coverage-neutral capacity-control
result. It is useful evidence that smaller per-cell Pareto capacity can
improve trajectory quality and reduce the larger-capacity HV tax, but it
does not yet satisfy the strict TCAD primary gate of matching or
improving classic final PPA HV.
