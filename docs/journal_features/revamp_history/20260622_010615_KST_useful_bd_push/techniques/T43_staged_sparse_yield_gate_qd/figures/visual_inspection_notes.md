# T43 Visual Inspection Notes

Status: complete; inspected 2026-06-22 UTC.

Inspected:

- `figures/t43_raw_area_power_fronts.png`
- `figures/t43_front_count_summary.png`
- `visualizations/direct_ppa_pareto/screenshot.png`

The raw area-power figure uses conventional non-inverted axes, labels
lower-left as better, keeps the legend outside the data panels, and marks
pooled raw-front points with black stars. The HTML screenshot renders the same
figure and an accompanying metric table without overlap.

Interpretation from the inspected figure:

- T43 staged gate has zero pooled raw area-power front hits.
- T43 staged gate broadens the traffic-light method front to seven points, but
  those points are dominated by other methods in the pooled comparison.
- The staged sparse champion-lane policy did not activate because all three QD
  archives completed strict eight-success warmup.
