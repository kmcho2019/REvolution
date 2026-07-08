# S02 Warmup 16 Seed 1002 Result

Date packaged: 2026-07-08.

Variant: `qd_grid_quantile_warmup_successes=16`, otherwise Smooth-QD V2
parity settings. Full RTLLM was launched over all 50 problems; the
headline comparison uses the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_140623_UTC/live/warmup16/seed_1002`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s02_warmup16_seed1002_20260708_140623_UTC.json`.
- Runtime: 6257.36 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1002 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 19 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 6 |
| S02 warmup16 | 0.097839 | 0.081757 | 32/46 | 9 |

S02 is `100.3%` of matched classic HV and `100.7%` of matched classic
HV-AUC46 on this seed, but covers one fewer reference-complete problem.
It is `97.5%` of matched V2 HV and `90.1%` of matched V2 HV-AUC46.

## Two-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage |
| --- | --- | --- | --- |
| classic REvolution | 0.104479 | 0.085867 | 66/92 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 |
| S02 warmup16 | 0.097494 | 0.085850 | 63/92 |

Across seeds 1001 and 1002, S02 is `93.3%` of matched classic HV and
approximately ties matched classic HV-AUC46. It remains below V2 on mean
HV and HV-AUC46, and it has the weakest two-seed coverage of the three
arms.

## Interpretation

Warmup 16 is a clean natural mechanism, but the two-seed full-suite read
does not justify promotion to five seeds as a primary TCAD extension arm.
It improves archive-front breadth relative to V2 on seed 1002 and nearly
matches classic AUC across two seeds, but the coverage loss and lower
mean HV make the mechanism a secondary warmup-interpolation lead rather
than a manuscript-grade candidate. If revisited, prefer S11/S12 warmup
interpolation over combining warmup16 with another knob.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
