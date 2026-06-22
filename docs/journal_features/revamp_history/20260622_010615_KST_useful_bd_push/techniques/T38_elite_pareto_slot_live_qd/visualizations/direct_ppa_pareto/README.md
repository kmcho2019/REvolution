# T38 Direct PPA Viewer

- `index.html`: filesystem-openable direct raw PPA viewer.
- `metrics.json`: per-problem counts backing the summary table.
- `screenshot.png`: Playwright-rendered screenshot.

The viewer embeds `../../figures/t38_live_raw_area_power_fronts.png` and a
summary table. It is intentionally simple: the main acceptance question is the
raw area-power front shape, not an interactive UI.
