# T65 RTL-Native Secondary Cells Results

## Result

Tier: `T0 diagnostic_secondary_cell_not_promoted`.

T65 does not promote RTL-native secondary cells as a winning method. On the
direct unique-PPA candidate surface, every tested RTL-native secondary profile
has negative mean front-cell delta versus Classic. The closest result is T63
with the `control_pipeline` profile at `-0.076923` mean front-cell delta.

## Aggregate Metrics

| Method | Profile | Mean Front Cell Delta | Mean Occupied Cell Delta |
| --- | --- | ---: | ---: |
| T51 code-thought | `timing_risk` | -0.461538 | -0.769231 |
| T51 code-thought | `operator_timing` | -0.307692 | -0.076923 |
| T51 code-thought | `control_pipeline` | -0.384615 | -0.230769 |
| T64 operator/timing | `timing_risk` | -0.538462 | -0.846154 |
| T64 operator/timing | `operator_timing` | -0.384615 | -0.692308 |
| T64 operator/timing | `control_pipeline` | -0.384615 | -0.307692 |
| T63 state/pipeline | `timing_risk` | -0.307692 | -0.692308 |
| T63 state/pipeline | `operator_timing` | -0.307692 | -0.076923 |
| T63 state/pipeline | `control_pipeline` | -0.076923 | -0.461538 |

The secondary-cell table also shows Classic has `30` direct Pareto-front
unique PPA points on this surface, versus T51 `21`, T63 `25`, and T64 `23`.
T63 under `control_pipeline` reaches `11` front cells versus Classic `10` in
the all-problem aggregate, but the problem-paired mean remains slightly
negative. That makes the signal interesting but not promotable.

## Interpretation

T65 strengthens the T63/T64 conclusion. RTL-native axes are still useful for
explaining implementation families, but simply using source-level RTLTimer
secondary cells around the existing T51/T63/T64 candidate pools does not create
a positive front-cell story versus Classic.

The next RTL-native method should not be another exact primary geometry or a
pure secondary-reporting overlay. A stronger follow-up would couple RTL-native
cells to emitter behavior, for example:

- keep T51-style code/front-slot exploitation as the primary quality pressure;
- use RTL-native cells only to choose among near-front parents or repair
  candidates;
- explicitly measure whether that coupling improves direct front points,
  front-cell count, and valid-PPA yield without duplicate collapse.

## Figures

- `figures/secondary_cell_delta_summary.png`: mean front-cell and occupied-cell
  deltas versus Classic.
- `figures/front_cell_heatmap.png`: front candidate occupancy for the best
  secondary profile, `control_pipeline`.
- `figures/timing_risk_projection.png`: RTLTimer-style projection of unique
  PPA candidates, with direct front candidates hollow-marked.

Visual inspection found the figures readable. The delta plot makes the
negative result obvious; the heatmap shows why T63 `control_pipeline` is the
closest secondary-cell clue; the projection has some overlap but front markers
remain visible.

## Decision

Do not promote T65. Do not run a live method that only adds these source-level
secondary cells as reporting overlays. Keep RTL-native descriptors in the
active lane only if the next method changes generator/archive coupling.
