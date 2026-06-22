# T46 Frozen T11 PCA Graph Methodology

Status: complete method card. Live result is in `results_report.md`.

## Question

T44 showed that live T11-style graph features can expose useful raw-PPA front
material, but the top-8 direct axis grid was too sparse and caused large
valid-PPA yield drops. T45 compressed the grid to the first four ranked axes
and preserved coverage, but lost to classic on mean HV, Pareto points,
valid-PPA count, and best score.

T46 asks whether a frozen non-PPA projection over the same top-8 graph feature
family can keep more of T44's graph signal without the raw-axis sparsity that
hurt T44 or the signal loss seen in T45.

## Method Delta

T46 adds descriptor profile `t11_runtime_pca4_graph`:

- `t11_runtime_pca_0`
- `t11_runtime_pca_1`
- `t11_runtime_pca_2`
- `t11_runtime_pca_3`

The four axes are the first four PCA components of the transformed T44 top-8
runtime graph features:

- `hyper_mean_fanout`
- `edge_per_node`
- `log_edge_count`
- `hyper_directed_edge_count`
- `hyper_fanout_entropy`
- `hyper_driven_net_count`
- `hyper_sink_net_count`
- `log_net_count`

The fitting table is `tables/t46_projection_components.csv`. The fit uses the
768 parsed non-PPA rows in
`techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`. It uses
only graph topology and count information. It does not use final PPA,
reference PPA, fitness, hypervolume, Pareto rank, validity labels, pass rate,
problem id, corpus, model, method, seed, or candidate id.

Everything else stays fixed to the T45 live screen:

- archive type: `grid_quantile`;
- warmup successes: `4`;
- cell mode: `elite_pareto_slot`;
- max elites per cell: `2`;
- parent selection: `nsga2_global_rank`;
- champion lane fraction: `0.80`;
- two-parent probability: `0.00`;
- operator: `eoh_strategies`;
- representation: `code_individual`.

This isolates descriptor geometry from archive mechanics and parent pressure.

## Non-Claim

T46 is not a PPA-trained projection and not a learned encoder promotion. It is
a live-safe dimensionality/projection ablation between T44's direct top-8 axes
and T45's direct top-4 axes. A positive result justifies richer frozen
projection or graph-side-archive work. A negative result retires this direct
T11 runtime projection lane and pushes the next graph work toward a secondary
archive role or a genuinely trained encoder.

## Leakage Rules

The in-loop BD uses only graph structure extracted from candidate RTL before
archive insertion. It excludes final PPA, reference PPA, fitness, hypervolume,
Pareto rank, functionality pass labels, test pass rate, and problem identity.
PPA enters only after evaluation for scoring, local Pareto retention, and
reporting.

## Fixed Settings

- model: `openai/gpt-oss-120b`;
- endpoint: `http://20.0.0.103:8000/v1`;
- benchmark subset: `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`,
  `RTLLM/Prob015_multi_pipe_8bit`;
- seed: `1001`;
- population: `12`;
- generations: `3`;
- evaluation mode: `strict_ablation`;
- `max_tokens` and `diff_max_tokens`: `128000`;
- run output root: `exp/useful_bd_push/`.

## Acceptance Signals

T46 can advance only if it:

- preserves every classic-covered design in the fixed three-problem screen;
- reports any 50 percent or larger valid-PPA or synthesis-valid decline when
  the matched classic denominator is at least 10;
- improves at least one primary QD/PPA metric versus matched classic, T45, or
  frozen T44/T39 references: global PPA HV, HV-AUC, valid-PPA yield,
  raw-PPA front hits, Pareto spread, archive coverage, or unique front
  families;
- includes both `visualizations/direct_ppa_pareto/` and the full Phase 03.1
  `visualizations/qd_ppa_viewer/` bundle before any result is complete.

## Outcome

T46 met the coverage and visualization gates, but it did not promote. It wins
ALU HV and contributes one ALU pooled raw-front hit, while classic wins mean
HV, reference-beating count, valid-PPA samples, and traffic-light quality.
The direct graph-axis projection lane is therefore retired as a primary live
archive path for now.
