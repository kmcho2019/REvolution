# MasterRTL Front-Slot Probe

This package records a bounded follow-up to the completed preliminary
encoder/config screen. The tested arm is
`masterrtl_structural_front_slot_8x5`: the same frozen eight-design `8x5`
screen and source-aligned MasterRTL structural descriptor as
`masterrtl_structural_mix_8x5`, but with `front_slot_lane_nsga2` parent
selection enabled.

## Verdict

`diagnostic_not_promoted`.

The arm is a small improvement over plain MasterRTL structural mix on mean HV
and reference-beating candidates, but it still trails classic REvolution on the
headline HV and Pareto-front breadth metrics.

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `6` |
| `masterrtl_structural_front_slot_8x5` | `0.1227` | `1.75` | `6.62` | `1` |
| `masterrtl_structural_mix_8x5` | `0.1218` | `2.00` | `5.50` | `1` |

## Navigation

- Method/result report: `masterrtl_front_slot_probe_report.md`
- Run command: `commands/run_masterrtl_front_slot_probe.md`
- Validation log: `logs/validation_log.md`
- Regeneration script:
  `tools/package_masterrtl_front_slot_probe.py`
- Aggregate table: `tables/aggregate_backend_metrics.csv`
- Per-problem deltas:
  `tables/masterrtl_front_slot_problem_deltas.csv`
- Mean HV figure: `figures/mean_hv_by_backend.png`
- Per-problem HV delta figure:
  `figures/masterrtl_front_slot_hv_delta.png`

## Caveat

`scripts/report_final_analysis_bundle.py` was interrupted during
source-aligned design-space feature recovery. Pareto analysis, PPA
distribution, and evolutionary reports were already written and are used for
this package. The interrupted stage was extra design-space recovery, not the
headline HV/Pareto computation.
