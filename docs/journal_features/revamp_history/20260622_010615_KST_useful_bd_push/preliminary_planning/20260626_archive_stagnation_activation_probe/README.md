# Archive Stagnation Activation Probe

Status: preregistered; code hook validated, run pending.

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

## Decision

Pending. This arm is not promoted unless it is within the registered `1-2%`
mean-HV tolerance versus classic or better, preserves classic-covered designs,
and improves at least one front-material metric without depending on
`Prob135_m2014_q6b`.
