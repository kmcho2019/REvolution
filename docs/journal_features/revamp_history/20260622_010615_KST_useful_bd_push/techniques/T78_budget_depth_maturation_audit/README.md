# T78 Budget-Depth Maturation Audit

T78 is a diagnostic package for the `L8` budget and benchmark-shape lane. It
does not introduce a new QD method. It asks whether the existing `12 x 3`
screens show signs that QD archives are still maturing when the run ends.

## Result

`T0_budget_hypothesis_support_not_live_ablation`.

The existing T75 archive continues changing late:

- `9/13` problem archives add or replace cells in generation `2` or `3`;
- mean occupied cells rise from `1.54` at generation `0` to `5.15` at
  generation `3`;
- mean archive members rise from `1.62` to `6.23`;
- front-slot parent requests rise from `17` in generation `1` to `77` in
  generation `3`;
- `Prob151_review2015_fsm` remains an empty-archive caveat.

This supports running an equal-candidate budget-shape ablation. It does not
prove that deeper QD will beat classic.

## Files

- `methodology.md`: audit protocol and terminology.
- `results_report.md`: interpretation and roadmap decision.
- `commands/budget_depth_audit_v0.md`: reproduction commands.
- `tables/`: generated CSV and JSON data.
- `figures/`: generated PNG figures and visual inspection notes.
- `tools/run_t78_budget_depth_audit.py`: reproducer script.
