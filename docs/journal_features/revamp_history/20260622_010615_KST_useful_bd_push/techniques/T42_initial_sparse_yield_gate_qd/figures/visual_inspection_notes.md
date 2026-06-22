# T42 Visual Inspection Notes

Status: complete; inspected 2026-06-22 UTC.

## `t42_raw_area_power_fronts.png`

Accepted. The plot uses raw area on x and raw power on y with conventional
non-inverted axes. The caption states that lower-left is better. Open circles
show each method's raw area-power front and black stars show the pooled front.
The three problem panels are readable and the legend does not cover data.

Visual read: T42 initial gate contributes one pooled-front point on ALU and
one on multi-pipe, but it does not contribute traffic-light pooled-front
material. T41 remains the visible traffic-light front winner, and T39 remains
the stronger multi-pipe best-score reference.

## `t42_front_count_summary.png`

Accepted. The count bars are readable and make the mixed result clear: T42 has
valid PPA on every problem and avoids catastrophic yield collapse, but its
pooled-front hits are sparse and problem-specific.

## `visualizations/direct_ppa_pareto/screenshot.png`

Accepted. The local HTML viewer renders the same direct PPA front and the
summary table without clipping or overlap.
