# MasterRTL/Yosys-SOG BD Methodology

## Intent

Build behavior descriptors from a Simple Operator Graph (SOG)-style RTL
operator representation before technology mapping. This tests whether
pre-synthesis operator structure gives a cheaper and more stable signal than
mapped netlist statistics alone.

T15 is paired with `T60_rtl_timer_timing_risk_bd` and
`T61_rtl_timer_problem_local_bd` in the RTL-native lane. T15 focuses on
structural/operator graph shape; T60/T61 focus on timing-risk and path
morphology. These are behavior descriptors, not direct PPA predictors.

The current T15 package is a Yosys-backed SOG proxy, not a full MasterRTL
implementation. It uses Yosys JSON after `read_verilog -sv; hierarchy
-auto-top; proc; flatten; opt` as the reproducible frontend while keeping the
MasterRTL-style goal of RTL-native operator-family descriptors.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Yosys JSON before technology mapping.
- Flattened RTL operator cells, ports, wires, state elements, and
  connection-bit counts.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass labels.

## Preprocessing

1. Parse candidate RTL with Yosys.
2. Run hierarchy, process lowering, flattening, and simple optimization.
3. Write Yosys JSON and count operator families.
4. Record every lowering status in `tables/lowering_funnel.csv`.

## Descriptor

The current proxy constructs a SOG feature vector with:

- module, port, wire, wire-bit, and cell counts;
- arithmetic, multiply, mux, comparator, logic, shift, state, memory, and
  module-instance counts;
- maximum and mean cell connection-bit counts;
- operator-mix score;
- control/data operator ratio;
- state/control ratio;
- SOG complexity score;
- operator-family entropy.

Cells are assigned problem-locally with a 4x4 quantile grid over operator-mix
score and state/control ratio. A later fused variant may add T61 timing-risk
features if both feature families pass collapse and reference-complete
comparison checks.

## Archive Mapping

Use 2D grid axes over operator-mix score and state/control ratio. Use CVT over
the full SOG or fused SOG+timing vector for higher-dimensional tests.

## Parent Selection Coupling

SOG extraction happens before expensive PPA, so it may support early archive
assignment. It must still be audited after synthesis/PPA to avoid filling cells
with unsynthesizable designs.

## Expected Outputs

- `tables/sog_features.csv`
- `tables/lowering_funnel.csv`
- `figures/sog_projection.png`
- `figures/sog_projection_zoom.png`
- `figures/archive_coverage_heatmap.png`
