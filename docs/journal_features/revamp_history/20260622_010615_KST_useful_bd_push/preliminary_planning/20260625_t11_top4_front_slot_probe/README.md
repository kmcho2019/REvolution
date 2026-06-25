# T11 Top-4 Front-Slot Probe

This package records the frozen eight-design `8x5` live follow-up for
`t11_runtime_top4_front_slot_8x5`.

The arm tests raw T11 runtime graph axes with the conservative front-slot
parent lane. It deliberately avoids repeating exact T58, which used the PCA4
graph projection and lost on the hard/tuning comparison.

## Decision

`diagnostic_not_promoted`.

T11 top-4 front-slot completed all eight screen problems and passed the focused
validators. It does not clear the full-RTLLM promotion gate because classic
still wins mean hypervolume, Pareto breadth, reference-beating candidates, and
HV wins.

## Key Artifacts

| Path | Contents |
| --- | --- |
| `t11_top4_front_slot_probe_report.md` | Main human-readable report. |
| `commands/run_t11_top4_front_slot_probe.md` | Run, analysis, and validation commands. |
| `logs/validation_log.md` | Validation and visual inspection notes. |
| `tables/run_summary.json` | Compact machine-readable decision summary. |
| `tables/aggregate_backend_metrics.csv` | Aggregate Pareto/HV comparison. |
| `tables/t11_top4_front_slot_problem_deltas.csv` | Per-problem deltas versus classic. |
| `figures/mean_hv_by_backend.png` | Mean HV comparison across screened arms. |
| `figures/t11_top4_front_slot_hv_delta.png` | Per-problem HV deltas versus classic. |
| `tools/package_t11_top4_front_slot_probe.py` | Regenerates copied tables and figures from `exp/`. |

## Caveat

`report_final_analysis_bundle.py` was interrupted during source-aligned
design-space recovery after the Pareto, PPA distribution, and evolutionary
reports were written. The package uses the completed sections only.
