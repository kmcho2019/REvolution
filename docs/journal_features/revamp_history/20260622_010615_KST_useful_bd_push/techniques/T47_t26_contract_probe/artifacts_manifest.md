# T47 Artifacts Manifest

Status: pre-run manifest.

## Current Files

- `methodology.md`: pre-registered T47 method card.
- `results_report.md`: pending result report and decision placeholder.
- `commands/probe_plan.md`: command plan and execution checklist.
- `tables/probe_matrix.csv`: frozen probe ladder matrix.
- `figures/README.md`: required visual outputs and inspection rule.

## Expected Run Artifacts

Run outputs should live under:

`exp/useful_bd_push/t47_t26_contract_probe_<timestamp>/`

Expected copied or generated package artifacts:

- `tables/preflight_models_<timestamp>.json`
- `tables/run_matrix.csv`
- `tables/problem_method_metrics.csv`
- `tables/default_reference_quarantine.csv`
- `tables/budget_parity.csv`
- `tables/paired_metric_deltas.csv`
- `figures/raw_area_power_fronts.png`
- `figures/validity_funnel.png`
- `figures/hv_without_default_reference.png`
- `figures/visual_inspection_notes.md`
- `visualizations/direct_ppa_pareto/`
- `visualizations/qd_ppa_viewer/`

## Hashes

Hashes are pending until run artifacts exist. Record SHA-256 hashes for the
subset configs, preflight metadata, method manifest, and candidate-level PPA
table before any result report claims are made.
