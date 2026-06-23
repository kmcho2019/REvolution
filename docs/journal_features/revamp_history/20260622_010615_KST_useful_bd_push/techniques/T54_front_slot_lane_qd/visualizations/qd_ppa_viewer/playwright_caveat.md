# T54 Phase 03.1 Playwright Caveat

Strict schema validation without Playwright passes. The optional Playwright
smoke generated screenshots, but exited nonzero with compare-mode guide and
archive-hover checks:

```text
ERROR: Playwright compare technique unavailable: classic
ERROR: rank_guides_3d_mesh_le2: compare mode did not emit guides for both techniques
ERROR: rank_guides_3d_mesh_projected_overlay: projected overlay vertex shapes are incomplete: ['circle']
ERROR: rank_guides_3d_mesh_projected_overlay: compare mode did not emit guides for both techniques
ERROR: Playwright archive hover clear check found no occupied archive cell
ERROR: sequential_3d_rank_guides_mesh: compare mode did not emit guides for both techniques
```

Manual inspection uses `screenshot.png`, copied from the generated
`compare_classic_qd.png` screenshot.
