# Synthesis Delta ST-NOD BD Methodology

## Intent

Capture how a design responds to synthesis stages, not just its final mapped
shape. ST-NOD means synthesis-transition netlist-observation descriptor for
this push: a vector of non-PPA deltas across fixed Yosys stages.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Fixed sequence of Yosys stages with JSON/stat dumps after each stage.
- Stage logs limited to structural synthesis diagnostics.

Do not use final PPA, timing closure, fitness, hypervolume, or functional test
pass labels as descriptor inputs.

## Preprocessing

1. Run the same Yosys stage script for every candidate.
2. Dump `stat -json` and mapped JSON after stages such as `proc`, `opt`,
   `fsm`, `memory`, `techmap`, `abc`, and `opt_clean`.
3. Parse each stage into the same structural feature schema.
4. Assert that stage order and feature names are identical across candidates.
5. Mark candidates with missing stage dumps in the validity funnel.

## Descriptor

For every adjacent stage pair, compute:

- signed and absolute cell-count deltas by coarse operation family;
- graph-depth and fanout changes;
- memory/process reduction amounts;
- mux and arithmetic simplification ratios;
- ABC rewrite sensitivity: pre-ABC to post-ABC count/depth deltas;
- normalized transition energy: sum of absolute robust-scaled deltas.

Concatenate stage features and deltas. Normalize within benchmark and seed
using a frozen baseline fit.

## Archive Mapping

Use two descriptors:

- 2D grid over total transition energy and ABC depth reduction;
- CVT over the full stage-delta vector.

This tests whether useful descendants come from designs with different
synthesis trajectories even when final netlist counts look similar.

## Parent Selection Coupling

Archive replacement follows normal QD rules. Stage-delta features may only
determine cell assignment and exploration coverage, not evaluation labels.

## Expected Outputs

- `tables/stage_features.csv`
- `tables/stage_delta_features.csv`
- `figures/stage_delta_projection.png`
- `figures/synthesis_trajectory_examples.png`
