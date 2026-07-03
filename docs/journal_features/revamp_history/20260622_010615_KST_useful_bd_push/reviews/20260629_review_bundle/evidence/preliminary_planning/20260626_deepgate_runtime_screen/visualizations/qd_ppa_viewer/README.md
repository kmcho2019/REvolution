# T94 QD/PPA Viewer

This is the full Phase 03.1-compatible viewer for the T94 DeepGate runtime
screen.

Open:

```text
index.html
```

Primary files:

- `manifest.json`: viewer manifest.
- `datasets/*.json`: per-problem linked archive and PPA datasets.
- `validation.json`: strict schema/control/data validation result.
- `screenshot.png`: inspected compare-mode render.
- `screenshots/`: Playwright smoke screenshots from the attempted render pass.

## Validation

Strict non-Playwright validation passed:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_screen/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --strict
```

Playwright rendered screenshots, but its stricter scripted smoke returned
extra assertions because it expects a technique named `classic` and could not
find an occupied archive hover target in one default check. The inspected
compare screenshot is nonblank and usable as a diagnostic viewer render.

## Projection Note

Classic candidates were not projected into DeepGate archive cells in this
export. The exporter was run with `--no-classic-descriptor-recovery` to avoid
silently recomputing DeepGate descriptors for classic candidates outside the
registered T94 run. The PPA/Pareto comparison is still paired and
reference-complete; the archive projection should be read as DeepGate's native
archive, not as a full posthoc classic-in-DeepGate-cell projection.
