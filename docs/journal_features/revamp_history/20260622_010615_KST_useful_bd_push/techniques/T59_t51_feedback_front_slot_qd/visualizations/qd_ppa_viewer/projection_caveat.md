# T59 Viewer Projection Caveat

Strict viewer export with classic descriptor recovery failed before the final
non-strict export:

```text
KeyError: "Missing required descriptor metric 'sr_pca_0'."
```

T59 uses SR-PCA archive coordinates. The current classic descriptor recovery
path does not reconstruct those SR-PCA axes for classic candidates, so the
viewer was exported with `--no-classic-descriptor-recovery`. The PPA panes,
timeline, and T59-native archive panes are valid, but classic archive-cell
occupancy is intentionally unavailable.

The saved strict validator output reports `0.000` classic projection coverage
for the hard/tuning problems. That is a projection limitation, not evidence that
classic generated no candidates.
