# S03 Elite Pareto Slot 2 Seed 1002 Result

Date packaged: 2026-07-08.

Variant: `qd_cell_mode=elite_pareto_slot` and
`qd_max_elites_per_cell=2`, otherwise Smooth-QD V2 parity settings. Full
RTLLM was launched over all 50 problems; the headline comparison uses
the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_160650_UTC/live/elite_pareto_slot_2/seed_1002`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s03_elite_pareto_slot_2_seed1002_20260708_160650_UTC.json`.
- Runtime: 4662.90 seconds.
- LLM API calls: 4801 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1002 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 17 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 3 |
| S03 elite-pareto slot 2 | 0.107216 | 0.091135 | 33/46 | 14 |

S03 is `109.9%` of matched classic HV and `112.3%` of matched classic
HV-AUC46 on this seed with equal coverage. It is `106.9%` of matched V2
HV and `100.4%` of matched V2 HV-AUC46, again with equal coverage.

## Two-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.104479 | 0.085867 | 66/92 | 30 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 | 12 |
| S03 elite-pareto slot 2 | 0.103703 | 0.089938 | 65/92 | 25 |

Across seeds 1001 and 1002, S03 is `99.3%` of matched classic HV and
`104.7%` of matched classic HV-AUC46 with one fewer covered
reference-complete problem. It is `105.2%` of matched V2 HV and `103.2%`
of matched V2 HV-AUC46 while tying V2 coverage.

## Interpretation

S03 is the first suite-first variant in this campaign that deserves
five-seed confirmation. The mechanism is still natural and compact:
retain the scalar-quality elite and one local-front slot per occupied
cell, rather than storing a larger Pareto archive in every cell. That
keeps the QD/MAP-Elites story close to the conference system while
reducing archive crowding.

The current read is not yet a manuscript claim because the two-seed HV
is slightly below matched classic and coverage is one problem lower. The
positive signal is still strong: S03 matches the classic HV target within
one percent, improves HV-AUC, and clearly beats Smooth-QD V2 on the
two-seed suite read. Promote S03 to seeds 1003-1005 before opening
combination variants.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
