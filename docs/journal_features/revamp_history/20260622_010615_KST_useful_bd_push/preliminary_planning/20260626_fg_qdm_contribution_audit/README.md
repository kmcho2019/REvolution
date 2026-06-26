# FG-QDM Contribution Audit

This package summarizes what the completed T85/T86/T87 front-guarded QD
memory smokes showed before any further live spend, and records the T97
front-credit follow-up and random-control outcomes.

## Question

Did FG-QDM memory lanes earn their evaluation budget by producing valid-PPA or
front-adding children?

## Short Answer

Not yet. FG-QDM itself is implemented and runs, but no completed variant is
promoted. T97 is the best FG-QDM smoke by mean HV and beats same-threshold T98
random memory, but it still trails classic and memory lanes still do not add
quality-productive global-front material.

## Files

- [results_report.md](results_report.md): concise conclusion and next action.
- [preregistration_t97_front_credit_memory.md](preregistration_t97_front_credit_memory.md):
  stricter follow-up spec that uses existing FG-QDM knobs before adding code.
- [../../techniques/T97_front_credit_fg_qdm_memory/](../../techniques/T97_front_credit_fg_qdm_memory/):
  completed T97 follow-up package.
- [../../techniques/T98_front_credit_random_memory_control/](../../techniques/T98_front_credit_random_memory_control/):
  completed same-threshold random-control package.
- [tables/fg_qdm_lane_contribution.csv](tables/fg_qdm_lane_contribution.csv):
  lane-level generated, valid-PPA, and front-add rates from T85/T86/T87.
- [tables/fg_qdm_headline_metrics.csv](tables/fg_qdm_headline_metrics.csv):
  headline smoke metrics used to interpret the lane audit.
- [commands/reproduce.md](commands/reproduce.md): source tables and commands.
