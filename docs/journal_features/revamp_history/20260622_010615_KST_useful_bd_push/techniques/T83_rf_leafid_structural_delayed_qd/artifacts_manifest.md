# T83 Artifacts Manifest

## Pre-Run Artifacts

| Artifact | Purpose |
| --- | --- |
| `methodology.md` | Pre-registered algorithm and descriptor axes. |
| `commands/run_t83_rf_leafid_structural_delayed.md` | Frozen run command. |
| `tables/preflight_models_20260626_rf_leafid.txt` | vLLM model metadata copied from the preliminary-planning package. |
| `tables/descriptor_probe_20260626_rf_leafid.json` | Axis-resolution probe proving the BD requires source-aligned RTL/RF timing metrics but not PPA. |

## Result Artifacts

The completed result package is stored under
`../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/`.

| Artifact | Purpose |
| --- | --- |
| `results_report.md` | Technique-level decision and concise metric summary. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/results_report.md` | Detailed screen result and terminology. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/analysis/pareto_analysis/` | Generated Pareto/HV report, tables, and diagnostic per-problem plots. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/tables/screen_decision_metrics.csv` | Aggregate promotion metrics. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/tables/problem_hv_deltas.csv` | Per-problem HV deltas. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/tables/comparison_completeness.csv` | Candidate/reference completeness. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/tables/descriptor_health_summary.csv` | Descriptor collapse and archive-health summary. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/tables/sensitivity_no_prob135.csv` | Robustness check excluding the largest T83 win. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/figures/rf_leafid_structural_delayed_summary.png` | Inspected reader-facing summary figure. |
| `../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/logs/validation_log.md` | Validator commands, result, and visual-inspection notes. |

The run artifacts should remain under `exp/useful_bd_push/`, not under `aux/`.
