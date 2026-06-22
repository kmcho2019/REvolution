# T37 Visual Inspection Notes

Inspection date: 2026-06-22 UTC.

## Static PNGs

- `t37_multi_problem_ppa_pareto_fronts.png` is readable at desktop scale. It
  shows four representative raw area-power fronts, includes the all-valid
  front, and makes the one-slot, two-slot, and three-slot differences visible.
- `t37_raw_area_power_pareto_front.png` has both a full valid-PPA range and a
  lower-left Pareto zoom. The legend does not cover the front geometry.
- `t37_hypervolume.png` makes the main finding clear: one-slot T37 is close to
  the front-seeded upper bound and above lexical, T11, and fitness-top.
- `t37_front_hits.png` makes the counterpoint clear: two and three slots can
  recover front hits, but the hypervolume plot shows why that is not enough.

## HTML Viewer

`visualizations/direct_ppa_pareto/index.html` was rendered with Playwright and
saved as `visualizations/direct_ppa_pareto/screenshot.png`.

The screenshot shows:

- title: `T37 Direct Raw PPA Pareto Front`;
- summary cards for best T37 HV, HV gain versus lexical, best T37 front hits,
  and lexical front hits;
- a working problem selector;
- raw area and power axes with lower-left-better annotation;
- front lines and hollow rank-1 markers.

No clipped labels, missing points, or `undefined` text were observed.
