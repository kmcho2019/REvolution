# T52 Artifacts Manifest

Status: seed `1001` hard/tuning package complete.

## Planned Inputs

| Artifact | Purpose |
| --- | --- |
| `commands/hard_tuning_sanity.md` | Exact preflight, run, validation, and packaging command plan. |
| `tables/run_matrix.csv` | Frozen method and comparator matrix for seed `1001`. |
| `tables/hard_tuning_subset.yaml` | Validator manifest for the planned 13-problem hard/tuning surface. |
| `methodology.md` | Paper-grade method specification and anti-leakage contract. |
| `results_report.md` | Result summary after the run is packaged. |

## Planned Outputs

Seed `1001` added:

- `hard_tuning_package/` with matched classic/T52 tables and figures;
- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`;
- `visualizations/qd_ppa_viewer/` with Phase 03.1 export, validation files,
  and `screenshot.png`;
- `hard_tuning_package/validation/` with operator and Pareto validators.

## Raw Roots

- T52:
  `exp/useful_bd_push/t52_code_thought_full_pareto_20260623_035857_UTC/hard_tuning/code_thought_full_pareto_qd/seed_1001`.
- Classic:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`.
