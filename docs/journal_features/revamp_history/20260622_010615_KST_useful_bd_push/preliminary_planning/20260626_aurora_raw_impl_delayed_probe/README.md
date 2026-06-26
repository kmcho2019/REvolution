# T99 AURORA Raw Implementation Delayed Probe

This package records the completed live screen for
`aurora_raw_impl_compact_delayed_8x5`.

The method is not a pretrained encoder claim. It is the live representative for
the useful part of T13: raw implementation-side structural features, not the
compressed AURORA bottleneck that lost replay HV.

## Decision

Screened negative, but retained as the AURORA/raw-implementation category
representative.

Classic wins the frozen eight-design reference-complete comparison on mean HV
(`0.1406` versus `0.1201`), mean Pareto points (`3.25` versus `2.00`), and
mean reference-beating candidates (`8.00` versus `4.38`). T99 stays useful as
coverage for the AURORA-style raw-feature lane because it is stronger than
Qwen canonical RTL and pure DeepGate on mean HV, but it is not a final RTLLM
spend candidate.

## Files

| File | Purpose |
| --- | --- |
| `preregistration.md` | Frozen hypothesis, method, metrics, and decision rule. |
| `commands/run_aurora_raw_impl_delayed_probe.md` | Exact run, validation, and analysis commands. |
| `results_report.md` | Final result, comparison, and decision. |
| `artifacts_manifest.md` | Local artifact map for raw runs, reports, figures, and viewer bundles. |
| `analysis/` | Generated Pareto, PPA-distribution, and completeness reports. |
| `tables/` | Common-evaluation rows, passive archive metrics, and copied completeness gate. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1-compatible archive/PPA viewer. |
| `visualizations/direct_ppa_pareto/` | Static reader-facing PPA front supplement. |
| `logs/` | Validation and visual inspection notes. |

## Status

Completed. Do not promote exact T99 to full RTLLM spend.
