# T38 Visual Inspection Notes

Inspected:

- `t38_live_raw_area_power_fronts.png`
- `t38_live_improvement_fronts.png`
- `t38_live_archive_counts.png`
- `visualizations/direct_ppa_pareto/screenshot.png`

The raw area-power figure is readable and marks local rank-1 points, global
front points, and active archive members with distinct markers. It uses
conventional non-inverted axes: lower area and lower power move toward the
lower-left. The multi-pipe panel clearly shows three front/global points but
no active archive squares.

The normalized improvement figure is readable and makes the multi-pipe
negative power/timing tradeoff visible. The count summary is readable and
shows the central blocker: multi-pipe has seven valid PPA points and three
front points, but zero active archive members.

The HTML screenshot rendered correctly with the raw PPA figure and summary
table visible. No overlap or broken image was observed.
