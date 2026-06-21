# MOME Pareto Archive BD Methodology

## Intent

Replace one-elite-per-cell QD with a multi-objective QD archive that keeps a
local Pareto front in each descriptor cell. This directly targets the journal
argument that QD can explore broader RTL PPA tradeoff space than classic
single-objective evolution.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- A chosen non-PPA descriptor from a deterministic or learned technique.
- Valid-PPA objective vectors for area, power, and timing after evaluation.

The descriptor itself must not use final PPA, fitness, hypervolume, Pareto
rank, reference PPA, or test pass labels.

## Preprocessing

1. Normalize area, power, and timing to fixed maximize objectives per problem.
2. Define a common reference point for hypervolume before runs.
3. Fix the descriptor and archive cell count.
4. Configure passive MOME archives for classic and landing Smooth-QD.

## Archive Rule

Each cell stores a bounded nondominated set instead of one elite:

- insert unique valid-PPA candidate into its descriptor cell;
- remove dominated candidates within the cell;
- if the cell exceeds capacity, prune by crowding distance or local
  hypervolume contribution;
- parent selection samples cells and then samples within-cell Pareto candidates.

Report both local-cell hypervolume and global PPA hypervolume.

## Archive Mapping

Start with CVT over a strong deterministic descriptor such as ST-NOD+motif or
SOG+Yosys. Compare against the same descriptor with standard MAP-Elites.

## Parent Selection Coupling

Parent selection can alternate:

- exploit: high local hypervolume cells;
- explore: low-occupancy or high-novelty cells;
- repair: cells with recent invalid-to-valid transitions.

The alternation schedule must be frozen before live runs.

## Expected Outputs

- `tables/cell_pareto_fronts.csv`
- `tables/global_pareto_front.csv`
- `tables/mome_vs_single_elite.csv`
- `figures/cell_hypervolume_heatmap.png`
- `figures/global_pareto_scatter.png`
