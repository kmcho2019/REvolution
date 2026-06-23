# T65 Visual Inspection Notes

- `secondary_cell_delta_summary.png` uses a zero baseline so positive
  front-cell or occupied-cell deltas are visually separable from losses.
- `front_cell_heatmap.png` uses shared color limits across methods and
  shows the best observed profile: `Control + Pipeline`.
- `timing_risk_projection.png` uses hollow markers for direct method
  Pareto-front candidates and translucent filled markers for all valid
  PPA candidates.
- The descriptors are source-level RTL features. They do not use final
  PPA, reference PPA, hypervolume, Pareto rank, fitness, or tests as BD
  inputs.
