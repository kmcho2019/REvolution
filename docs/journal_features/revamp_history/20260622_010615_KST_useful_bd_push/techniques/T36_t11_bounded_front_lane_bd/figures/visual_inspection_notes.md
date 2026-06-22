# T36 Visual Inspection Notes

Date: 2026-06-22 UTC.

## Inspected Figures

- `t36_multi_problem_ppa_pareto_fronts.png`
- `t36_raw_area_power_pareto_front.png`
- `t36_hypervolume.png`
- `t36_front_hits.png`
- `visualizations/direct_ppa_pareto/index.html`

## Findings

- The multi-problem raw PPA front figure is readable and keeps the expected
  lower-left-better axis convention. Overlapping T36 quota arms are expected
  because all quotas reserve one local-front slot under this replay group
  size.
- The raw area-power zoom clearly shows the difference between T11's broad
  selected front and T36's bounded front recovery on `Prob018_float_multi`.
- The HV and front-hit bar charts make the main result easy to read: T36 is
  close to the T35 front-seeded upper bound on HV and recovers front hits
  above lexical.
- The HTML viewer opened from the filesystem in Playwright, rendered SVG
  points, and had no `undefined` summary text. Screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`.

## Verdict

Visual inspection passed. These figures are suitable as the primary T36 replay
evidence, with the caveat that all T36 quota labels represent the same one-slot
bounded-front lane on this replay surface.
