# T72 Viewer Playwright Caveat

Playwright validation was run with:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/final_analysis/visualizations/qd_ppa_viewer \
  --strict \
  --playwright
```

It failed with these checks:

- `Playwright compare technique unavailable: classic`
- `sequential_archive_3d: layer-panel hover bridge found no occupied cell`
- `combinational_ppa_2d: PPA hover bridge did not expose sample axis labels`
- `combinational_projected_archive: projected archive does not report
  collapsed ff_depth`
- `combinational_projected_archive: layer-panel hover bridge found no
  occupied cell`

The first failure is expected for this package because T72 is a single-method
screen, not a matched classic-vs-QD viewer. Manual inspection of the generated
`raw_area_power_front` and `sequential_3d` screenshots showed nonblank,
readable panels. The A/B compare surface duplicates the T72 backend because no
classic backend was exported.

Use the strict non-Playwright `validation.json` as the structural viewer
validation. Treat the Playwright result as a browser-interaction caveat, not
as a failed T72 run.
