# Full RTLLM Seed 1001

Status: complete, validated, packaged, and mechanically gated on 2026-07-13
UTC.

## Decision

Seed 1001 **passes the continuation gate** but is not a positive result.
Pareto retains `97.867%` of fresh classic final mean HV46, above the locked
`90%` floor, and trails valid-PPA coverage by one design, below the stop
threshold of four. Candidate evaluation counts match exactly and auxiliary
budget skew is inside `+/-10%`.

This authorizes only matched seed 1002. It does not authorize seeds 1003-1005,
a performance claim, a new variant, or parameter tuning.

## Headline Metrics

| Metric | Classic | Pareto | Delta |
| --- | ---: | ---: | ---: |
| Final mean HV46 | 0.101013 | 0.098859 | -0.002154 |
| Mean HV-AUC46 | 0.085385 | 0.081920 | -0.003465 |
| Valid-PPA designs46 | 33 | 32 | -1 |
| Functional-any-pass46 | 38 | 37 | -1 |
| Functional-any-pass50 | 42 | 41 | -1 |
| Reference-beating designs46 | 24 | 26 | +2 |
| Positive-HV designs46 | 20 | 22 | +2 |
| Mean Pareto points46 | 1.586957 | 1.695652 | +0.108696 |
| Mean score improvement46 | 26.544% | 26.378% | -0.166 pp |
| Valid-PPA samples46 | 1008 | 1001 | -7 |
| Evaluated candidates | 2400 | 2400 | 0 |
| LLM calls | 4801 | 4800 | -1 |
| Total tokens | 14870892 | 14954728 | +0.564% |
| Runtime | 4646.99 s | 4712.14 s | +1.402% |

Exact-HV comparison gives nine Pareto wins, eight classic wins, and 29 ties.
This explicit tie rule supersedes report surfaces that use secondary
tie-breakers for a field named `hypervolume_win_count`.

Largest Pareto HV gains were Prob007 (`+0.058317`), Prob031 (`+0.046927`),
and Prob041 (`+0.027322`). Largest losses were Prob019 (`-0.087104`), Prob024
(`-0.075383`), and Prob008 (`-0.030685`). These are diagnostics, not a basis
for changing the frozen method.

The no-reference raw-objective branch received valid PPA on Prob013, Prob018,
and Prob040. The technical-smoke limitation is therefore closed for runtime
execution, although Prob006 again had no valid PPA.

## Completeness

Each arm contains all 50 frozen tasks, one summary per task, six generation
rows per task, and eight unique evaluated candidates per generation. Runtime
configs differ only in `save_path` and `search_mode`. Pareto summaries record
NSGA-II parent and survivor selection, descriptors false, post-hoc delivered
fronts, and the exact normalized or raw objective source.

The report package contains 92 locked-subset problem rows, 2,009 valid-PPA
candidate rows, 65 HV-AUC rows, and passing operator-contract rows for both
arms. Its 27 generic no-PPA warnings correspond exactly to 13 classic and 14
Pareto locked tasks without valid PPA; all 50 generation logs exist per arm.

## Artifacts

- Raw classic:
  `exp/pareto_revolution_validation/full_rtllm/seed_1001/classic`
- Raw Pareto:
  `exp/pareto_revolution_validation/full_rtllm/seed_1001/pareto`
- Reports:
  `exp/pareto_revolution_validation/packages/full_rtllm_seed_1001`
- Compact metrics: `gate_metrics.csv`

Key report SHA-256 pins:

- backend comparison: `43ab96a2e2e5ba729eaef60e25fc842e6bf6194f8b7dffd74f35e13ad92fc929`
- Pareto summary: `19ec3f5404acf0e413ceaf428b170d4007b2c069dba75d488caa6ec957396a6f`
- aggregate metrics: `1f625826b2b7be38d829f64f958893033368b9aeee097de16c7f083cd3dacd04`
- PPA summary: `f0bf0512517523cc71be7ace57903c0f1e69936008e3d30c7b4aae410948cfbb`
- PPA candidates: `a5ebb61e566100b42ad3dd9a4d7db2f9257a20a4fb183cefdf4523bd8f30cc45`
- HV-AUC: `ba2d1a1afbc2b7fa429bb90a7d02c3eeadd18d09046bfc74f1bb29c1e61d002d`
- operator audit: `7051a530a579bedf891f19354153e120bda612b42f81cfe0fa2ae575ca6b7214`
