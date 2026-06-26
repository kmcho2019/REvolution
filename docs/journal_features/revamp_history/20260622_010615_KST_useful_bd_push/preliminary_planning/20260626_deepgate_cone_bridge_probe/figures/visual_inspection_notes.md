# Visual Inspection Notes

## `deepgate_cone_embedding_pca.png`

- The PCA panel is nonblank and the three previously skipped problems are
  visible.
- The count panel makes the bridge-coverage result clear: `36` cones each for
  `Prob015_multi_pipe_8bit`, `Prob045_alu`, and `Prob153_gshare`.
- `Prob045_alu` forms a tight cluster with one outlier, while `Prob015` and
  `Prob153` overlap. This reinforces that cone embeddings need candidate-level
  pooling before they can be used as a behavior descriptor.
- The x-axis labels in the count panel are readable enough for preliminary
  notes. Redraw before final slides if this becomes a main presentation figure.
