# T100 Artifacts Manifest

## Inputs

| Path | Purpose |
| --- | --- |
| `commands/run_t100_front_credit_rf_leafid_fg_qdm.md` | Frozen preflight, descriptor probe, smoke, and validation commands. |
| `methodology.md` | Method definition and promotion gates. |
| `tables/descriptor_probe_rf_leafid_fg_qdm.json` | Descriptor contract probe output. |
| `tables/t100_memory_lane_summary.csv` | Memory-lane contribution summary. |
| `tables/ppa_completeness.csv` | Reference-complete coverage gate. |
| `tables/method_problem_seed_metrics.csv` | Common per-problem method metrics. |
| `tables/method_seed_summary.csv` | Common method summary metrics. |
| `tables/passive_archive_metrics.csv` | Common passive archive metrics. |
| `tables/passive_archive_config.json` | Common archive-axis configuration. |

## Run Output

| Path | Purpose |
| --- | --- |
| `exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626/` | Live T100 run root. |
| `analysis/ppa_distribution/` | Candidate PPA distribution report and raw PPA CSVs. |
| `analysis/pareto_analysis/` | HV and PPA-front report. |
| `visualizations/qd_ppa_viewer/` | Phase 03.1 viewer bundle. |
| `visualizations/direct_ppa_pareto/` | Static reader-facing PPA-front supplement. |
| `results_report.md` | Completed smoke conclusion and promotion decision. |

## Validation

| Check | Status |
| --- | --- |
| vLLM `/v1/models` preflight | Passed for `openai/gpt-oss-120b`. |
| `validate_pareto_front_run.py` | Passed. |
| `validate_single_thought_operator_run.py` | Passed. |
| `report_ppa_distribution.py` | Completed with `207` valid-PPA candidate rows. |
| `report_pareto_analysis.py` | Completed. |
| `report_ppa_completeness.py` | Completed with `3/3` headline problems. |
| `report_common_evaluation_contract.py` | Completed. |
| `export_qd_ppa_visualization.py --strict --no-classic-descriptor-recovery` | Passed. |
| `validate_qd_ppa_visualization.py --strict` | Passed. |
| Playwright validator | Failed because classic RF-leaf archive projection is unavailable and the strict browser suite expects canonical validation problems outside this smoke subset. |

Do not place new live artifacts under `/aux`; it remains read-only historical
evidence.
