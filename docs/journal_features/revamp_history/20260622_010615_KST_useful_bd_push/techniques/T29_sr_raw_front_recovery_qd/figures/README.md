# T29 Figures

Status: complete and visually inspected.

| Figure | Purpose |
| --- | --- |
| `t29_ppa_fronts_area_power_zoom.png` | Direct raw area-power PPA scatter. Axes are inverted so up/right means better. Open circles mark each method's active-objective rank-1 PPA front. |
| `t29_ppa_fronts_improvement.png` | Normalized area/power improvement scatter where higher is better on both axes. This is easier for cross-problem directionality. |
| `t29_live_problem_front_counts.png` | Per-problem front-point, reference-beating, and valid-PPA counts for classic, controls, SR raw variants, and T29. |
| `t29_live_aggregate_metrics.png` | Aggregate mean HV, mean HV-AUC, and total PPA-front count across the three-problem screen. |
| `t29_family_aggregate_counts.png` | Canonical/family duplicate audit for front families, front netlists, and valid-family ratio. |

The direct PPA-front figures are the primary response to the visualization
gap: they show plain PPA coordinates and mark front candidates directly,
instead of requiring a reader to infer PPA shape from descriptor-space archive
views.
