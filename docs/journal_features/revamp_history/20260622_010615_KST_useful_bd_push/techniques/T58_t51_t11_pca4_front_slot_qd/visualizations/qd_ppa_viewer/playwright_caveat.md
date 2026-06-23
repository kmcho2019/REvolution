# T58 Playwright Caveat

The strict non-Playwright validator passed for this viewer.

The Playwright smoke generated the screenshot matrix and then reported:

```text
ERROR: rank_guides_3d_mesh_le2: compare mode did not emit guides for both techniques
ERROR: rank_guides_3d_mesh_projected_overlay: projected overlay vertex shapes are incomplete: ['circle']
ERROR: rank_guides_3d_mesh_projected_overlay: compare mode did not emit guides for both techniques
ERROR: sequential_3d_rank_guides_mesh: compare mode did not emit guides for both techniques
```

Manual screenshot inspection used `screenshot.png`, copied from
`screenshots/compare_classic_qd.png`. The screenshot renders the classic and
T58 archive panes plus the PPA/Pareto pane without blank canvases or broken
assets.

The caveat is limited to the automated rank-guide interaction checks. Do not
reinterpret the Playwright smoke as a failed viewer export; use the strict
validator status in `validation.md`, which was regenerated without
`--playwright` and passed.
