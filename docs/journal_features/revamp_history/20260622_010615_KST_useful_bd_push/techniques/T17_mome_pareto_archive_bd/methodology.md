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

## Passive Audit Instantiation

The current T17 package is a passive archive audit over the completed seed-1001
standard-result tables. It does not start a new vLLM run and does not write
anything under `/aux`; `/aux` is read-only source evidence for older runs.

The audit compares two retention rules in the same fixed common-audit cell
space for classic, landing Smooth-QD/manual-BD, and every completed Auto-BD
method:

- `scalar_cell_elite`: retain the highest finite-fitness valid-PPA candidate in
  each common-audit cell. This approximates the hill-climbing pressure that made
  classic strong on scalar PPA improvement metrics.
- `bounded_local_pareto`: retain the nondominated valid-PPA set inside each
  common-audit cell, capped at four candidates. If a cell has more than four
  nondominated candidates, prune by NSGA-II-style crowding distance, then by
  finite fitness and generation as deterministic tie-breakers.

Candidates are archiveable only if they are valid-PPA, have finite normalized
objective improvements, and have finite fitness. This keeps the scalar and
Pareto retention rules comparable without counting invalid or unscored rows as
diversity.

## Archive Mapping

Start with CVT over a strong deterministic descriptor such as ST-NOD+motif or
SOG+Yosys. Compare against the same descriptor with standard MAP-Elites.

## Parent Selection Coupling

Parent selection can alternate:

- exploit: high local hypervolume cells;
- explore: low-occupancy or high-novelty cells;
- repair: cells with recent invalid-to-valid transitions.

The alternation schedule must be frozen before live runs.

For the next live Smooth-QD-v2-style variant, do not select parents by a raw
weighted-sum score alone. Use evaluated PPA only after insertion into the
archive:

- 50 percent from local Pareto fronts by per-cell crowded tournament;
- 30 percent from underfilled or sparsely covered descriptor cells;
- 20 percent from the current global nondominated front, with crowding-distance
  preference over scalar-fitness preference.

This keeps hill-climbing pressure through nondominated candidates while leaving
cell assignment controlled by the non-PPA descriptor.

## Expected Outputs

- `tables/cell_pareto_fronts.csv`
- `tables/global_pareto_front.csv`
- `tables/mome_vs_single_elite.csv`
- `figures/cell_hypervolume_heatmap.png`
- `figures/global_pareto_scatter.png`
