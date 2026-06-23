# T63 Playwright Caveat

The full viewer exported successfully and strict static validation passed:

```text
QD/PPA viewer validation passed
```

The Playwright smoke generated the screenshot matrix and the representative
compare screenshot copied to `screenshot.png`, but returned:

```text
ERROR: rank_guides_3d_mesh_le2: compare mode did not emit guides for both techniques
ERROR: sequential_3d_rank_guides_mesh: compare mode did not emit guides for both techniques
```

Manual screenshot inspection found the generated viewer nonblank and readable.
Treat the failed Playwright result as an interaction/debug-hook caveat, not a
data-export failure.
