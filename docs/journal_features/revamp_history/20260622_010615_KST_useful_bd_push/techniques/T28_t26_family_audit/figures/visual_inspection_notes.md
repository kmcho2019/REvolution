# T28 Figure Visual Inspection Notes

Inspection date: 2026-06-21 UTC.

## `family_aggregate_counts.png`

- Size: 3006 x 889.
- Method labels fit after rotation and colors remain distinguishable.
- The figure clearly shows the central tradeoff: T26 has the highest valid
  family ratio, but lower front-family and front-netlist counts than classic
  and SR raw.
- Supported claim: duplicate collapse does not explain T26's valid-candidate
  pool, but T26 is not a front-family diversity win.

## `family_problem_front_counts.png`

- Size: 3186 x 926.
- The grouped bars are readable, and legends do not hide material bars.
- The multi-pipe panel makes the front-family blocker visible: T26 has 5 front
  families versus classic's 12 and SR raw's 10.
- Supported claim: T26's front-family deficit is concentrated in multi-pipe,
  with smaller differences on ALU and traffic-light.

## `ppa_pareto_fronts_area_power.png`

- Size: 3149 x 953.
- The legend, axes, and explanatory note fit without overlap after layout
  adjustment.
- Open-circle front markers are visible across all three problems.
- The figure is intentionally a raw area-power projection; for P015 the clock
  period objective is active, so the HTML viewer should be used for the full
  3D PPA view.

## `ppa_pareto_fronts_improvement.png`

- Size: 3149 x 953.
- The normalized improvement axes make the direction of improvement explicit:
  up/right is better.
- The traffic-light and ALU panels show T26's strong PPA points, while the
  multi-pipe panel still shows fewer distinct front markers than classic and
  SR raw.

## HTML Viewer

- `visualizations/qd_ppa_viewer/index.html` opens and renders Classic versus
  T26 for all three audited problems.
- 2026-06-22 update: the viewer now includes a `raw A-P front` PPA mode.
  `visualizations/qd_ppa_viewer/screenshots/raw_area_power_front.png` was
  inspected and is readable: raw area is on x, raw power is on y, lower-left is
  marked as better, and hollow front outlines are visible by method. For P015,
  the screenshot correctly states that timing is omitted from this 2D
  projection.
- Static validation passed with `scripts/validate_qd_ppa_visualization.py`.
- Playwright generated screenshots under `visualizations/qd_ppa_viewer/screenshots/`.
  It reports one scoped-viewer caveat: Classic has no honest SR-PCA archive
  projection, so the archive-hover check for Classic has no occupied cell.

## Decision

Accept the figures and scoped HTML viewer for the T28 audit package. Exact
values should be cited from `tables/family_aggregate_metrics.csv`,
`tables/family_problem_metrics.csv`, and `tables/family_candidate_rows.csv`.
