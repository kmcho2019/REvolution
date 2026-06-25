# Auxiliary Archive Front-Breadth Probe

## Question

Can the auxiliary-archive variant recover the PPA-front breadth that the
high-exploit auxiliary archive lost by adding a small front-slot lane?

## Method

This probe keeps the same source-aligned MasterRTL structural descriptor as the
high-exploit run. It relaxes exploitation pressure by lowering the champion lane
from `0.90` to `0.80`, raising improve backfill from `0.05` to `0.10`, and using
`front_slot_lane_nsga2` parent selection with a `0.20` front-slot lane.

## Result

| Metric | Classic | Front-breadth QD | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.140645 | 0.113443 | -0.027202 |
| Relative HV | 0.00% | -19.34% | -19.34% |
| Mean Pareto points | 3.250 | 2.125 | -1.125 |
| Mean reference-beating candidates | 8.000 | 5.250 | -2.750 |
| Problem HV wins vs classic | - | 1/8 | - |

## Decision

Do not promote this variant. The front-slot lane did not recover enough
PPA-front material: mean HV dropped below both classic and the prior high-exploit
auxiliary-archive probe. It improved mean Pareto points relative to the
high-exploit auxiliary run, but still remained below classic and paid a large HV
penalty.

## Evidence

- `tables/run_summary.json`: machine-readable run summary.
- `tables/front_breadth_problem_deltas.csv`: per-design comparison against
  classic.
- `figures/mean_hv_by_backend.png`: screen-wide mean HV comparison.
- `figures/front_breadth_hv_delta.png`: per-design HV delta.
- `reports/pareto_report.md`: copied final-analysis Pareto report.
- `reports/ppa_distribution_report.md`: copied PPA distribution report.

## Caveat

report_final_analysis_bundle hit the 600 second timeout during source-aligned design-space feature recovery after backend, Pareto, PPA, hard-iteration, and evolutionary reports were written.
