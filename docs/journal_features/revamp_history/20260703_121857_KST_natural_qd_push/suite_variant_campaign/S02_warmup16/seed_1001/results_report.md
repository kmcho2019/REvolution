# S02 Warmup 16 Seed 1001 Result

Date packaged: 2026-07-08.

Variant: `qd_grid_quantile_warmup_successes=16`, otherwise Smooth-QD V2
parity settings. Full RTLLM was launched over all 50 problems; the
headline comparison uses the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_120949_UTC/live/warmup16/seed_1001`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s02_warmup16_seed1001_20260708_120949_UTC.json`.
- Runtime: 6345.74 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1001 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 18 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 9 |
| S02 warmup16 | 0.097150 | 0.089942 | 31/46 | 6 |

S02 is `87.2%` of matched classic HV and `99.3%` of matched classic
HV-AUC46 on this seed. It is `100.4%` of matched V2 HV and `107.7%` of
matched V2 HV-AUC46, but it covers two fewer reference-complete problems
than classic and one fewer than V2.

## Interpretation

Warmup 16 is not a one-seed promotion result, but it is worth completing
the pre-registered seed 1002 probe. The natural mechanism is clean:
delay quantile-grid commitment until more successful candidates define
the descriptor ranges. Seed 1001 suggests that this may improve V2's
HV-AUC behavior without adding operator complexity, but the current
coverage loss means it cannot yet support a TCAD primary claim.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
