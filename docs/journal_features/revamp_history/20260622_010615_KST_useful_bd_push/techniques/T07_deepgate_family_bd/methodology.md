# DeepGate Family BD Methodology

## Intent

Test AIG-oriented learned circuit representations more completely than the
previous bounded DeepGate attempt. Try DeepGate2/3/4 where runnable, and use a
faithful lightweight surrogate only when dependencies or checkpoints block the
full model.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- AIG or mapped Boolean network generated with fixed Yosys/ABC commands.
- Optional cone splits around outputs, FF boundaries, and high-fanout nodes.
- Public DeepGate-family code or checkpoint if available.

Descriptor training and selection exclude final PPA, reference PPA, fitness,
hypervolume, Pareto labels, and test pass labels.

## Preprocessing

1. Convert RTL to AIG with a fixed command and write graph artifacts.
2. Canonicalize node ordering with topological order and stable tie-breaking.
3. Build node features: gate type, inversion flags, topological level,
   fanin/fanout degree, sequential boundary markers, and cone id.
4. Split large graphs into cones when model memory requires it.
5. Record failures separately: conversion, graph size limit, model load, and
   inference.

## Descriptor

Evaluate these variants in order:

- frozen DeepGate checkpoint embeddings if a compatible checkpoint exists;
- DeepGate-style surrogate GNN/graph transformer trained on reconstruction or
  masked-node objectives over the replay corpus;
- cone-level embeddings pooled by mean, max, attention-free weighted average,
  and histogram statistics;
- handcrafted AIG feature fallback using the same graph schema.

Collapse checks are mandatory: pairwise distances, duplicate alignment,
nearest-neighbor motif agreement, and graph-size correlation.

## Archive Mapping

Use CVT over 8 to 32 graph-embedding dimensions as the primary archive. For
interpretable figures, plot two fixed PCA axes and color by benchmark,
validity, and PPA labels after evaluation.

## Parent Selection Coupling

Use graph-embedding cells for exploration only. If inference is too slow for
live use, run replay diagnostics first and record inference cost before any
bounded live sampling.

## Dependency Plan

Try dependency installation in this order: existing environment, `uv add`,
isolated `exp/useful_bd_push/envs/deepgate_family_bd/`, then source checkout or
submodule. Record exact commands and blockers.

## Expected Outputs

- `tables/aig_conversion_funnel.csv`
- `tables/deepgate_embedding_manifest.csv`
- `tables/collapse_diagnostics.csv`
- `figures/deepgate_projection.png`
- `figures/graph_size_vs_embedding.png`

## Completed Replay Route

The completed T07 replay records the full DeepGate-family dependency blocker
and uses a standard-cell graph surrogate instead of stopping at the blocker.
The surrogate parses every synthesized netlist into a directed cell graph,
extracts WL-hashed graph colors and graph statistics, and replays
farthest-first retention at the same 50% budget used by the T33/T34 common
audit.

Generated primary artifacts:

- `tables/netlist_graph_manifest.csv`;
- `tables/ppa_comparison.csv`;
- `tables/ppa_front_metrics.csv`;
- `tables/ppa_front_plot_points.csv`;
- `figures/deepgate_multi_problem_ppa_pareto_fronts.png`;
- `figures/deepgate_raw_area_power_pareto_front.png`.

The surrogate is not labeled as a full DeepGate checkpoint result. It is a
graph-encoder diagnostic that tests whether graph-structured descriptors are
more useful than whole-design text embeddings on the common replay surface.
