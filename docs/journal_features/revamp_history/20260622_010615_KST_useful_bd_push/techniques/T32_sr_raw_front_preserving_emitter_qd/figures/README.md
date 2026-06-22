# T32 Figures

Status: generated and visually inspected.

| Figure | Purpose |
| --- | --- |
| `t32_holdout_ppa_pareto_area_power_candidate_zoom.png` | Primary direct raw PPA Pareto view. Area on x, power on y, no inverted axes, lower-left is better, candidate-only zoom. |
| `t32_holdout_ppa_pareto_area_power.png` | Same conventional raw PPA view with reference stars included. |
| `t32_holdout_ppa_fronts_improvement.png` | Normalized area/power improvement view where higher is better on both axes. |
| `t32_holdout_ppa_fronts_area_power_zoom.png` | Secondary continuity plot with inverted raw axes. Do not use as the primary figure. |
| `t32_holdout_live_aggregate.png` | Aggregate HV, HV AUC, and candidate-level front-point summary. |
| `t32_holdout_problem_counts.png` | Per-problem front-point, reference-beating, and valid-PPA counts. |
| `t32_holdout_family_counts.png` | Canonical family/netlist accounting for front candidates. |

Use `t32_holdout_ppa_pareto_area_power_candidate_zoom.png` first when judging
whether T32 changes the raw PPA Pareto front. It shows T32 mostly overlapping
T31 and failing to recover T26's useful P135 low-area/low-power point.
