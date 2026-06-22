# T45 Phase 03.1 QD/PPA Viewer

This directory contains the full linked archive/PPA viewer for the completed
T45 live screen.

- `index.html`: filesystem-openable Phase 03.1 viewer.
- `manifest.json`: viewer manifest with three RTLLM datasets.
- `datasets/*.json`: per-problem candidate, archive, and PPA data.
- `descriptor_cache.json`: descriptor values used to project candidates.
- `validation.json` and `validation.md`: strict viewer validation results.
- `screenshot.png`: inspected compact Playwright screenshot.
- `screenshots/`: optional Playwright screenshot matrix.

Validation command:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/tables/live_screen_v0_subset.yaml \
  --strict \
  --playwright
```
