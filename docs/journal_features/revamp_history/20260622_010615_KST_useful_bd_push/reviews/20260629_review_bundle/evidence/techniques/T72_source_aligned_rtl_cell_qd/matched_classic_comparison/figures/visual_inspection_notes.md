# Visual Inspection Notes

Date: 2026-06-23

## `t72_hv_delta_by_problem.png`

- Readable labels after shortening long benchmark/problem names.
- Zero line is visible and the green/red color split makes wins/losses clear.
- Main message is direct: T72 is close overall, wins a few problems, but has a
  large traffic-light loss.
- Several zero or near-zero bars are intentionally visually tiny; use
  `../tables/backend_problem_metrics.csv` for exact values.

## `t72_valid_ppa_counts.png`

- Side-by-side bars are readable for all 13 problems.
- The figure shows that T72 preserves design coverage but has lower total
  valid-PPA count than classic.

## Pareto Examples

The copied pairwise-front examples are useful diagnostics. They are not the
primary presentation figures because the generated legends and titles are
visually dense.
