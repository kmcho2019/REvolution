# Archive Stagnation Activation Probe

Status: completed; diagnostic negative, not promoted.

This package tests whether archive pressure should turn on only after the
passive QD archive stops growing. It keeps the same MasterRTL structural
archive descriptor and high-exploit parent policy as the closest auxiliary
archive arms, but replaces the fixed generation trigger with an archive-health
trigger.

## Question

Can measured archive stagnation preserve the early classic-like hill-climbing
advantage while activating QD pressure only when passive archive exploration no
longer adds cells or members?

## Files

- `preregistration.md`: frozen setup, metrics, and promotion rule.
- `commands/run_archive_stagnation_activation_probe.md`: exact launch and
  validation commands.
- `logs/run_checkpoint.md`: preflight, launch, completion, and validation log.
- `archive_stagnation_activation_report.md`: result and interpretation.

## Decision

Do not promote this arm to full RTLLM spend. It preserves all eight screened
problems, but mean HV is `0.1089` versus classic `0.1406`, and the result
remains negative after removing `Prob135_m2014_q6b`.

## Result Files

- `figures/archive_stagnation_summary.png`: inspected aggregate and paired
  delta figure.
- `tables/stagnation_aggregate_backend_metrics.csv`: aggregate comparison
  table.
- `tables/stagnation_backend_problem_metrics.csv`: per-problem metrics.
- `tables/stagnation_vs_classic_problem_deltas.csv`: direct paired deltas.
- `tables/ppa_candidates.csv`: raw successful-candidate PPA table.
- `tables/reference_ppa_metrics.csv`: reference PPA table.
