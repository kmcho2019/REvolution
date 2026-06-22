# RTLLM Milestone Screen Selection

Run root: `exp/useful_bd_push/rtllm_milestone_screen_20260622_130747_UTC`

## Decision

Selected full-run QD arm: `sr_raw_conservative_exploit_qd`.

This is a screen decision, not a final research claim. The full RTLLM
one-seed run remains the first deadline milestone, with multi-seed
replication deferred until after the presentation package.

## Aggregate Metrics

| Method | Mean HV | Mean HV-AUC | Valid PPA | Front Points | Unique PPA Points |
| --- | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.181382 | 0.119509 | 66 | 10 | 55 |
| Exact T26 | 0.183839 | 0.133872 | 40 | 6 | 33 |
| T26.1 Low Fusion | 0.145351 | 0.142890 | 53 | 8 | 46 |
| T26.1 Mid Fusion | 0.156546 | 0.126159 | 56 | 15 | 51 |

## Gate Notes

- Full-run selection must still be reviewed adversarially before launch.
- Any one-seed win is paired engineering evidence, not seed-stable
  significance.
- The hard launch gate is classic-covered retention: if classic has
  at least one valid-PPA sample for a problem, the selected QD arm
  must also have at least one.
- A 50% or larger valid-PPA drop is reported as a yield warning,
  not a launch blocker, because the deadline milestone prioritizes
  PPA optimization and design coverage.
