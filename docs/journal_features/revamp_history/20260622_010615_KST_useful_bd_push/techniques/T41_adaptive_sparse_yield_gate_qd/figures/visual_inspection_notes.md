# T41 Visual Inspection Notes

Status: accepted for `T0 mixed_diagnostic`.

Inspected artifacts:

- `figures/t41_raw_area_power_fronts.png`
- `figures/t41_front_count_summary.png`
- `visualizations/direct_ppa_pareto/screenshot.png`

The raw PPA figure uses area on x, power on y, no inverted axes, and an
explicit lower-left-better caption. The pooled-front stars and method-front
open circles are visible. The figure makes the result easy to read:

- ALU: the only pooled point is T41 classic.
- Traffic-light: T41 adaptive owns the pooled front.
- Multi-pipe: T39 owns the strongest low-power/low-area front material.

The count summary is readable and confirms the same result: T41 adaptive has
seven traffic-light pooled-front hits, but zero ALU and multi-pipe pooled hits.

The HTML screenshot opens from the filesystem, renders the primary figure, and
shows the summary table without overlap or clipped text.
