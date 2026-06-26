# T99 Artifacts Manifest

## Live Runs

Classic baseline:

```text
exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b
```

T99 arm:

```text
exp/useful_bd_push/prelim_aurora_raw_impl_delayed_20260626/live/aurora_raw_impl_compact_delayed_8x5/seed_1001/openai_gpt-oss-120b
```

## Generated Reports

| Artifact | Purpose |
| --- | --- |
| `analysis/pareto_analysis/report.md` | Aggregate and per-problem Pareto/HV comparison. |
| `analysis/pareto_analysis/aggregate_backend_metrics.csv` | Backend-level metrics used for headline claims. |
| `analysis/pareto_analysis/backend_problem_metrics.csv` | Per-backend, per-problem metrics. |
| `analysis/ppa_distribution/report.md` | PPA distribution report and figure index. |
| `analysis/ppa_distribution/data/ppa_candidates.csv` | Raw candidate-level PPA rows for regeneration. |
| `analysis/ppa_distribution/data/reference_ppa_metrics.csv` | Reference PPA rows used by normalized comparisons. |
| `analysis/ppa_completeness.csv` | Missing-candidate and missing-reference comparison gate. |
| `tables/method_problem_seed_metrics.csv` | Common-evaluation method/problem/seed rows. |
| `tables/passive_archive_metrics.csv` | Passive archive metrics from the Phase 03.1 viewer projection. |
| `tables/passive_archive_config.json` | Per-problem archive definitions used for the table export. |
| `tables/ppa_completeness.csv` | Copy of the completeness gate used by the common table export. |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/*.csv` | Staged PPA inputs used to regenerate the Phase 03.1 viewer. |

## Visualizations

| Artifact | Purpose |
| --- | --- |
| `visualizations/qd_ppa_viewer/index.html` | Full Phase 03.1 archive/PPA viewer. |
| `visualizations/qd_ppa_viewer/manifest.json` | Viewer manifest. |
| `visualizations/qd_ppa_viewer/datasets/*.json` | Per-problem viewer datasets. |
| `visualizations/qd_ppa_viewer/descriptor_cache.json` | Recovered posthoc descriptor values for projected classic candidates. |
| `visualizations/qd_ppa_viewer/validation.json` | Strict viewer validation result. |
| `visualizations/qd_ppa_viewer/screenshot.png` | Visual inspection screenshot. |
| `visualizations/direct_ppa_pareto/index.html` | Static PPA-front supplement. |
| `visualizations/direct_ppa_pareto/metrics.json` | Reader-facing summary metrics. |
| `visualizations/direct_ppa_pareto/screenshot.png` | Static front screenshot. |

## Commands

The exact run, validation, export, and screenshot commands are recorded in
[`commands/run_aurora_raw_impl_delayed_probe.md`](commands/run_aurora_raw_impl_delayed_probe.md).
