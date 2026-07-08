# S01 Capacity 7 Seed 1001 Result

Date packaged: 2026-07-08.

Variant: `qd_max_elites_per_cell=7`, otherwise Smooth-QD V2 parity
settings. Full RTLLM was launched over all 50 problems; the headline
comparison uses the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_104148_UTC/live/capacity7/seed_1001`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s01_capacity7_seed1001_20260708_104148_UTC.json`.
- Runtime: 4746.45 seconds.
- LLM API calls: 4801 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1001 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 18 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 7 |
| S01 capacity7 | 0.089605 | 0.077978 | 34/46 | 9 |

S01 is `80.4%` of matched classic HV and `93.0%` of matched V2 HV on
this seed. It is `86.1%` of matched classic HV-AUC46 and `93.3%` of
matched V2 HV-AUC46. The only favorable primary-style signal is
coverage: S01 has 34 reference-complete valid-PPA problems versus 33 for
classic and 32 for V2.

## Interpretation

This is not a promotion result. Increasing per-cell Pareto capacity from
5 to 7 improves coverage by one problem on seed 1001, but it does not
protect PPA HV or HV-AUC. The result supports the prior suspicion that
larger in-cell fronts can increase valid material while diluting the
selection pressure that drives suite-scale HV.

Because Wave A explicitly treats one full-suite seed as a runtime and
extraction gate rather than a quality kill, S01 should still complete
the pre-registered seed 1002 probe before retirement or promotion.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
