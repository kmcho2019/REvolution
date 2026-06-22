# Direct PPA Front Visual Inspection Notes

Inspection date: 2026-06-22 UTC refresh.

## `live_key_ppa_fronts_area_power_zoom.png`

- Size: 3257 x 1023.
- Candidate-level area-power geometry is readable on all three panels.
- Open-circle front markers stand out from the translucent candidate cloud.
- Raw axes are conventional and non-inverted; lower-left is better. This is the
  best first-look figure for the user's direct PPA-front concern.

## `live_key_ppa_fronts_area_power.png`

- Size: 3257 x 1023.
- Reference star is visible, but `Prob045_alu` has large whitespace because the
  reference power is far worse than the generated candidates.
- Keep this as scale context; use the zoomed version for front geometry.
- Raw axes are conventional and non-inverted.

## `live_key_ppa_fronts_improvement.png`

- Size: 3257 x 1023.
- Axes make the direction of improvement explicit: up/right is better.
- The figure clearly shows Conservative exploit's strong high-quality points,
  while `Prob015_multi_pipe_8bit` still has fewer active-objective front
  options than Classic and SR raw.

## `live_all_ppa_fronts_area_power_zoom.png`

- Size: 3257 x 1023.
- The all-method legend fits and does not cover data.
- This view is dense but useful for checking SR-RFF, SR ReLU, and Guarded SR
  raw against the key methods.
- Raw axes are conventional and non-inverted.

## `live_all_ppa_fronts_area_power.png`

- Size: 3257 x 1023.
- Accepted as a reference-context view, with the same `Prob045_alu` scale
  caveat as the key-method reference-context plot.

## `live_all_ppa_fronts_improvement.png`

- Size: 3257 x 1023.
- Accepted as the all-method normalized view. It is busier than the key-method
  view but still readable.

## `live_front_count_summary.png`

- Size: 3328 x 940.
- Initial generation had a title/legend overlap; regenerated version moves the
  legend below the panels.
- The summary separates raw area-power front points from active-objective
  front points. Classic retains more of both than Conservative exploit on
  `Prob015_multi_pipe_8bit`; SR raw matches Conservative exploit on raw
  area-power front count but keeps more active-objective front points.

## Decision

Accept the direct-front audit figures. Cite exact values from
`tables/problem_front_counts.csv` and candidate coordinates from
`tables/candidate_ppa_points.csv`.
