# T99 Results Report

Status: `T0_screened_negative_category_representative`.

T99 completed the frozen eight-design `8x5` screen as
`aurora_raw_impl_compact_delayed_8x5`. It is retained as the current
AURORA/raw-implementation category representative, but it is not promoted for
full RTLLM spend.

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating |
| --- | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` |
| `aurora_raw_impl_compact_delayed_8x5` | `0.1201` | `2.00` | `4.38` |

## Decision

Classic remains ahead on mean HV, Pareto breadth, and reference-beating
candidate count. T99 is stronger than the weak live Qwen and pure DeepGate
representatives by mean HV, but it does not beat matched classic and does not
justify full RTLLM spend.

## Traceability

Full artifacts live in the preliminary package:

```text
../../preliminary_planning/20260626_aurora_raw_impl_delayed_probe/
```

Key files:

- `results_report.md`
- `artifacts_manifest.md`
- `analysis/ppa_completeness.csv`
- `tables/method_problem_seed_metrics.csv`
- `tables/method_seed_summary.csv`
- `tables/passive_archive_metrics.csv`
- `logs/validation_log.md`
- `logs/visual_inspection_notes.md`
