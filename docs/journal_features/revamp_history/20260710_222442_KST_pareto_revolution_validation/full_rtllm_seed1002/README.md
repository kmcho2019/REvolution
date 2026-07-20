# Full RTLLM Seed 1002

Status: complete, validated, and packaged on 2026-07-13 UTC.

## Decision

Seed 1002 is a mixed seed-level result. Pareto beats fresh classic final
mean HV46 by `0.000645` and adds one valid-PPA design, but loses HV-AUC46 by
`0.010903` and mean scalar-score improvement by `5.604 pp`. Functional
any-pass is tied.

This result must be combined with seed 1001 under the frozen two-seed gate. It
does not independently authorize seeds 1003-1005, a performance claim, a new
variant, or parameter tuning.

## Headline Metrics

| Metric | Classic | Pareto | Delta |
| --- | ---: | ---: | ---: |
| Final mean HV46 | 0.108477 | 0.109122 | +0.000645 |
| Mean HV-AUC46 | 0.095615 | 0.084713 | -0.010903 |
| Valid-PPA designs46 | 32 | 33 | +1 |
| Functional-any-pass46 | 37 | 37 | 0 |
| Functional-any-pass50 | 41 | 41 | 0 |
| Reference-beating designs46 | 27 | 27 | 0 |
| Positive-HV designs46 | 22 | 22 | 0 |
| Mean Pareto points46 | 1.391304 | 1.478261 | +0.086957 |
| Mean score improvement46 | 29.034% | 23.430% | -5.604 pp |
| Valid-PPA samples46 | 1009 | 977 | -32 |
| Evaluated candidates | 2400 | 2400 | 0 |
| LLM calls | 4801 | 4800 | -1 |
| Total tokens | 14852813 | 14857515 | +0.032% |
| Runtime | 4679.01 s | 4651.81 s | -0.581% |

Exact-HV comparison gives seven Pareto wins, 11 classic wins, and 28 ties.
The seed-level mean win is concentrated: `Prob038_pulse_detect` contributes
`+0.342995`, while `Prob050_square_wave` contributes `-0.177937` and
`Prob037_parallel2serial` contributes `-0.146868`.

The raw-objective branch received valid PPA on Prob013, Prob018, and Prob040
for both arms. Prob006 again had no valid PPA. The runtime raw-objective path
is therefore exercised beyond unit tests.

## Completeness

Each arm contains all 50 frozen tasks, one summary per task, six generation
rows per task, and eight unique evaluated candidates per generation. Runtime
configs differ only in `save_path` and `search_mode`. Treatment summaries
record the frozen NSGA-II methods, no descriptors, post-hoc delivered fronts,
and exact normalized or raw objective routing. No runtime QD state appears.

The report package contains 92 locked-subset problem rows, 1,986 valid-PPA
candidate rows, 65 HV-AUC rows, and passing operator-contract rows for both
arms. Its 27 generic no-PPA warnings equal the 14 classic and 13 Pareto
backend/problem units with zero valid PPA; all 50 generation logs exist per
arm.

## Artifacts

- Raw classic:
  `exp/pareto_revolution_validation/full_rtllm/seed_1002/classic`
- Raw Pareto:
  `exp/pareto_revolution_validation/full_rtllm/seed_1002/pareto`
- Reports:
  `exp/pareto_revolution_validation/packages/full_rtllm_seed_1002`
- Compact metrics: `gate_metrics.csv`

Key report SHA-256 pins:

- backend comparison: `91d03842ea5ce1c683d71b056bc330df58785a886c9eae4ac396b578eb841810`
- Pareto summary: `9985d25d0426ed46f37d1118a4527c4f59e092910c1f823f61f445218b7a8884`
- aggregate metrics: `1e4d177ad0ee4ccfcad7f7bf240d40f8bf7297af15e3e7c8dc6bf43d17eb4e49`
- PPA summary: `9d9f33f5ff55938e4527d9283164b1d4bf51d63d63e9eb25c8912f9d85e88a5c`
- PPA candidates: `6147a524cd42115338fda3d8b4c141b7522d04b6f2da3213edc016004bb6f056`
- HV-AUC: `f981d6bf46f2d206c38d2a76599df67be88f2e4ed98e6fd1e2981e6cd46ab720`
- operator audit: `b9ba25d9b0fd7ac1b156f495831b6ff4cac30ce868b52bec10eeaf8127751992`
