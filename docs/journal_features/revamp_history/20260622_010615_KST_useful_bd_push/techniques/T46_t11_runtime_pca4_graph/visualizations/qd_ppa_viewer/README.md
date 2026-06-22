# T46 QD/PPA Viewer

This is the full Phase 03.1-compatible viewer for the matched T46 live screen.
It is separate from the simpler `../direct_ppa_pareto/` raw area-power
supplement.

## Contents

- `index.html`: standalone viewer entry point.
- `manifest.json`: backend/problem manifest.
- `datasets/*.json`: one dataset per screened RTLLM problem.
- `validation.{json,md}`: strict validation output.
- `screenshot.png`: inspected compare-mode screenshot.
- `screenshots/`: Playwright screenshot matrix from the validator.

## Validation

The viewer was exported with `scripts/export_qd_ppa_visualization.py` and
validated with:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T46_t11_runtime_pca4_graph/tables/live_screen_v0_subset.yaml \
  --strict \
  --playwright
```

Status: passed.
