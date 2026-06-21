# T27 Figure Visual Inspection Notes

Inspection date: 2026-06-21 UTC.

## `live_qd_problem_metrics.png`

- Size: 3186 x 926.
- The three panels are readable on a normal desktop display.
- Method colors are distinct, and the legend does not cover the bars.
- Axis labels and problem labels fit without clipping.
- The near-zero multi-pipe hypervolume values are visually compressed, but this
  reflects the data rather than a plotting failure.
- Supported claim: T26 has strong HV on ALU and traffic-light, but does not
  dominate PPA-front point count.

## `live_qd_aggregate_metrics.png`

- Size: 3006 x 889.
- The aggregate bars are readable and method labels fit after rotation.
- The figure makes the main tradeoff visible: T26 is near the top on mean HV
  and HV AUC, while SR raw keeps more active Pareto members.
- Supported claim: T26 is a live audit lead, not a finished useful-BD win.

## Decision

Accept both figures for the T27 audit package. The report must cite
`tables/live_qd_aggregate_metrics.csv` for exact values because the aggregate
figure is intended as a quick comparison, not the complete evidence surface.
