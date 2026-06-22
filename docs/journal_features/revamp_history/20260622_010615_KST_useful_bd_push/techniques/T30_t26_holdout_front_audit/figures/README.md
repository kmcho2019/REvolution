# T30 Figures

Status: generated and visually inspected.

| Figure | Purpose |
| --- | --- |
| `t30_holdout_ppa_pareto_area_power_candidate_zoom.png` | Primary straightforward PPA Pareto view. Raw area vs raw power, no inverted axes, lower-left is better, candidate-only zoom. |
| `t30_holdout_ppa_pareto_area_power.png` | Same conventional raw PPA view with the reference design star included for context. |
| `t30_holdout_ppa_fronts_improvement.png` | Normalized area/power improvement view where higher is better on both axes. |
| `t30_holdout_ppa_fronts_area_power_zoom.png` | Legacy-style candidate zoom with inverted raw axes so up/right means better. Retained for continuity with T29. |
| `t30_holdout_live_aggregate.png` | Aggregate HV, HV AUC, and candidate-level front-point summary. |
| `t30_holdout_problem_counts.png` | Per-problem front-point, reference-beating, and valid-PPA counts. |
| `t30_holdout_family_counts.png` | Canonical family/netlist accounting for front candidates. |

Use `t30_holdout_ppa_pareto_area_power_candidate_zoom.png` as the first
reader-facing figure when the question is whether the method changes the raw
PPA Pareto front.
