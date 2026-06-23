# T56 Phase 03.1 Playwright Caveat

Strict schema validation without Playwright passes. The optional Playwright
smoke generated screenshots, but it reports compare and hover interaction
warnings:

```text
ERROR: Playwright compare technique unavailable: classic
ERROR: rank_guides_3d_mesh_le2: compare mode did not emit guides for both techniques
ERROR: Playwright archive hover clear check found no occupied archive cell
ERROR: sequential_archive_3d: archive scene has no sample-level hit targets
ERROR: sequential_archive_3d: archive hover bridge found no occupied cell
ERROR: sequential_archive_3d: archive sample hover bridge found no sample
ERROR: combinational_projected_archive: archive scene has no sample-level hit targets
ERROR: combinational_projected_archive: projected archive does not report collapsed ff_depth
ERROR: combinational_projected_archive: archive hover bridge found no occupied cell
ERROR: combinational_projected_archive: archive sample hover bridge found no sample
```

Manual inspection uses `screenshot.png`, copied from the generated
`compare_classic_qd.png` screenshot. The screenshot renders the two-axis
archive as a `4 x 4 x 1` canvas slab with visible `sr_pca_0` and `sr_pca_1`
axis labels. The direct static PPA supplement remains the recommended figure
for paper-readable area-power front inspection.
