# Delayed Archive Activation Probe

Status: completed; diagnostic negative, not promoted.

This package tests whether the auxiliary archive mechanism failed because QD
pressure was paid too early. The run keeps the same MasterRTL structural
archive descriptor and high-exploit parent policy, but delays archive-driven
fill, backfill, and failure pressure until generation `3`.

## Question

Can passive early archive logging plus later archive activation preserve the
classic hill-climbing advantage while still giving QD enough archive memory to
improve PPA-front metrics?

## Files

- `preregistration.md`: frozen setup, metrics, and promotion rule.
- `commands/run_delayed_archive_activation_probe.md`: exact launch and
  validation commands.
- `logs/run_checkpoint.md`: preflight, launch, completion, and validation log.

## Decision

Do not promote this arm to full RTLLM spend. It improves over the adaptive
sparse-front follow-up and preserves much of the high-exploit signal, but mean
HV remains below classic (`0.1324` versus `0.1406`).

## Result Files

- `delayed_archive_activation_report.md`: result and interpretation.
- `tables/delayed_archive_aggregate.csv`: aggregate comparison table.
- `tables/delayed_archive_problem_metrics.csv`: per-problem metrics.
- `tables/delayed_vs_classic_problem_deltas.csv`: direct paired deltas.
- `tables/ppa_candidates.csv`: raw PPA candidate table from completed
  analysis.
