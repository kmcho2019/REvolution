# Delayed Archive Activation Probe

Status: preregistered; not yet run.

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

## Current Decision

No decision yet. This arm must beat or near-tie the matched classic `8x5`
reference-complete screen before it can be considered for full RTLLM spend.
