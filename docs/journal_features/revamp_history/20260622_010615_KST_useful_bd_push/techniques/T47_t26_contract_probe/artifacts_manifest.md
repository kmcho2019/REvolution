# T47 Artifacts Manifest

Status: hard/tuning package generated; held-out launch blocked.

## Current Files

- `methodology.md`: pre-registered T47 method card.
- `results_report.md`: run-status report and decision placeholder.
- `commands/probe_plan.md`: command plan and execution checklist.
- `commands/hard_tuning_sanity_20260622_203146_UTC.md`: exact preflighted
  hard/tuning launch commands for the current run root.
- `commands/package_hard_tuning_20260622_UTC.md`: package regeneration
  command for the completed hard/tuning run.
- `tables/probe_matrix.csv`: frozen probe ladder matrix.
- `tables/hard_tuning_run_status.csv`: launch/completion ledger for the
  timestamped hard/tuning sanity run.
- `tables/probe_problem_matrix.csv`: expanded pre-run matrix by phase, seed,
  arm, benchmark, and problem.
- `tables/default_reference_quarantine.csv`: known repaired/default-reference
  problems excluded from headline reference-normalized claims.
- `tables/preflight_models_20260622_203146_UTC.json`: local vLLM model
  preflight showing `openai/gpt-oss-120b` with `max_model_len=131072`.
- `tables/README.md`: table semantics and regeneration command.
- `figures/README.md`: required visual outputs and inspection rule.
- `hard_tuning_package/`: generated two-seed hard/tuning analysis package with
  tables, raw PPA candidate data, inspected figures, and package README.

## Expected Run Artifacts

Run outputs should live under:

`exp/useful_bd_push/t47_t26_contract_probe_<timestamp>/`

Generated hard/tuning package artifacts:

- `hard_tuning_package/tables/t47_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t47_aggregate_metrics.csv`
- `hard_tuning_package/tables/t47_comparison_deltas.csv`
- `hard_tuning_package/tables/t47_validity_gates.csv`
- `hard_tuning_package/data/t47_ppa_candidates.csv`
- `hard_tuning_package/figures/t47_hv_delta_heatmap.png`
- `hard_tuning_package/figures/t47_metric_delta_summary.png`
- `hard_tuning_package/figures/t47_validity_funnel.png`
- `hard_tuning_package/figures/t47_front_counts.png`

## Hashes

Hashes are pending until the next claim-candidate package. The current package
is diagnostic and blocks held-out exact T26 escalation.
