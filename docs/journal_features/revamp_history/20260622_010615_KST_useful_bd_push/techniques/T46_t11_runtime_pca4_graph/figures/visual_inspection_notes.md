# T46 Visual Inspection Notes

Inspected on 2026-06-22 UTC after packaging the live screen.

## `t46_raw_area_power_fronts.png`

- The figure is readable at report scale: title, legend, axes, and the
  lower-left-better footer are clear.
- Open circles mark each method's raw area-power front, and black stars mark
  the pooled front across methods.
- T46's strongest visible signal is on `Prob045_alu`, where it contributes one
  pooled raw-front point near the lower-left cluster.
- `Prob041_traffic_light` visually confirms the metric blocker: classic/T45
  own the lower-left pooled front, while T46 has no pooled-front hit.
- `Prob015_multi_pipe_8bit` shows T46 front members and a slightly lower
  power point than matched classic, but the pooled front is owned by the T44
  and T39 references.

## `t46_front_count_summary.png`

- The valid-PPA count panel is easy to scan and shows that T46 has fewer valid
  PPA samples than matched classic on all three problems.
- The pooled-front panel correctly highlights the narrow signal: T46 has one
  pooled-front hit on ALU and zero on traffic-light and multi-pipe.

## HTML Screenshots

- `visualizations/direct_ppa_pareto/screenshot.png` renders the direct
  raw-PPA figure and summary table without overlap at the captured viewport.
- `visualizations/qd_ppa_viewer/screenshot.png` renders compare mode, the
  archive panes, the PPA/Pareto pane, timeline controls, and advanced controls
  without obvious broken layout.
