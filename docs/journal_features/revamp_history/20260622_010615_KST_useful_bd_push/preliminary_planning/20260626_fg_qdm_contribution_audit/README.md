# FG-QDM Contribution Audit

This package summarizes what the completed T85/T86/T87 front-guarded QD
memory smokes actually showed before any further live spend.

## Question

Did FG-QDM memory lanes earn their evaluation budget by producing valid-PPA or
front-adding children?

## Short Answer

Not yet. FG-QDM itself is implemented and runs, but exact SR memory and
source-aligned shape-density memory are not promoted. Random-memory FG-QDM
slightly beats SR-memory FG-QDM on the smoke, and shape-density memory produces
zero valid-PPA memory-lane children.

## Files

- [results_report.md](results_report.md): concise conclusion and next action.
- [preregistration_t97_front_credit_memory.md](preregistration_t97_front_credit_memory.md):
  stricter follow-up spec that uses existing FG-QDM knobs before adding code.
- [tables/fg_qdm_lane_contribution.csv](tables/fg_qdm_lane_contribution.csv):
  lane-level generated, valid-PPA, and front-add rates from T85/T86/T87.
- [tables/fg_qdm_headline_metrics.csv](tables/fg_qdm_headline_metrics.csv):
  headline smoke metrics used to interpret the lane audit.
- [commands/reproduce.md](commands/reproduce.md): source tables and commands.
