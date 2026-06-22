# T44 Visual Inspection Notes

Status: complete; inspected 2026-06-22 UTC.

Inspected:

- `figures/t44_raw_area_power_fronts.png`
- `figures/t44_front_count_summary.png`
- `visualizations/direct_ppa_pareto/screenshot.png`
- `visualizations/qd_ppa_viewer/screenshot.png`

The raw area-power figure is readable, uses conventional non-inverted axes,
labels lower-left as better, and keeps open method-front circles plus black
pooled-front stars visible. The count summary is legible and makes the yield
drop visible.

The direct HTML screenshot renders the raw PPA figure and metric table without
obvious text overlap. It is the reader-facing supplement, not the full
Phase 03.1 archive/PPA viewer.

The full Phase 03.1 screenshot renders linked classic and QD archive panes,
compare mode, a timeline state, and the PPA pane without a blank canvas or
obvious overlap. The optional Playwright screenshot matrix was inspected
locally and can be regenerated with
`validate_qd_ppa_visualization.py --strict --playwright`.

Interpretation from the inspected figures:

- T44 adds one traffic-light pooled raw-front point and one multi-pipe pooled
  raw-front point.
- T44 improves multi-pipe best score and final-analysis HV versus matched
  classic.
- T44 loses valid-PPA yield too sharply on ALU and traffic-light, so the
  correct tier is `T0 mixed_diagnostic`.
