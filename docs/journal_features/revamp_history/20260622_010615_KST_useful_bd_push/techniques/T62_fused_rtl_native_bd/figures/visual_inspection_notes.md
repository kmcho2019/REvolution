# Fused RTL-Native Visual Inspection Notes

- `profile_cell_delta_summary.png` cleanly shows that each fused profile
  should be read as a delta versus classic, not as a standalone quality
  score.
- `best_profile_archive_heatmap.png` uses `Operator Mix + Timing Risk`, the profile
  with the largest mean front-cell delta in this retrospective audit.
- The heatmap uses shared color scaling and reader-facing method labels.
- Axes are descriptor-only RTL structural/timing features; they exclude
  final PPA, reference PPA, fitness, hypervolume, Pareto rank, and tests.
