# RF Timing-State Screen Validation Log

## Run Completion

The `masterrtl_rf_timing_state_8x5` screen completed all eight frozen
screening problems in `1441.49` seconds.

Problem summary rows:

```text
Prob015_multi_pipe_8bit,success,...,0.23250999677398254
Prob024_fsm,success,...,0.5002335522886039
Prob041_traffic_light,success,...,0.3891321713870733
Prob045_alu,success,...,0.390096918325777
Prob049_signal_generator,success,...,0.23477469440256318
Prob116_m2014_q3,success,...,0.46535233160621764
Prob135_m2014_q6b,success,...,0.2636173393124066
Prob153_gshare,success,...,0.13092220310027677
```

## Validators

`scripts/validate_pareto_front_run.py` completed with no reported errors.

`scripts/validate_single_thought_operator_run.py` completed with no reported
errors.

## Comparison Completeness

`tables/comparison_completeness.csv` records all eight problems as
`headline_paired`. Both methods have at least one valid PPA candidate on every
problem, and the selected subset is treated as reference-complete for headline
comparison.

## Visual Inspection

`figures/rf_timing_state_screen_summary.png` was inspected after generation.
It is readable and suitable for reporting the aggregate screen result.

Representative generated problem-level fronts were inspected:

- `Prob041_traffic_light` shows the largest RF timing HV loss.
- `Prob153_gshare` shows a small RF timing HV win.

The generated problem-level front PNGs are useful diagnostics, but some titles
and legends are clipped. They should be re-rendered before slide use.

## Decision

The screen is valid and negative. The exact
`source_aligned_rf_timing_state_3d` profile should not be promoted to the full
RTLLM comparison.
