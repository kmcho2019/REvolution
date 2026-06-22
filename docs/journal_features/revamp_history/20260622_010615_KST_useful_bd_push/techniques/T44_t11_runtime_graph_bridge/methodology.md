# T44 T11 Runtime Graph Bridge Methodology

Status: methodology fixed; full live screen complete. See `results_report.md`
for the tier decision.

## Question

T36 and T37 found that T11 structural-contrastive graph features plus one
bounded local-front slot are the strongest replay lead. T38 through T43 tested
archive mechanics with the existing `journal_graph_testability_3d` runtime
descriptor, so they do not directly answer whether the T11 descriptor signal
survives online generation.

T44 asks whether a live-safe subset of T11's highest-ranked structural graph
features can replace `journal_graph_testability_3d` in the same one-slot QD
substrate.

## Method Delta

T44 adds first-class runtime graph descriptor axes derived from T11's replay
feature manifest:

- `hyper_mean_fanout`
- `edge_per_node`
- `log_edge_count`
- `hyper_directed_edge_count`
- `hyper_fanout_entropy`
- `hyper_driven_net_count`
- `hyper_sink_net_count`
- `log_net_count`

The full screen uses profile `t11_runtime_top8_graph`. It keeps the T39
one-slot sparse-warmup archive substrate:

- archive type: `grid_quantile`;
- warmup successes: `4`;
- cell mode: `elite_pareto_slot`;
- max elites per cell: `2`;
- parent selection: `nsga2_global_rank`;
- champion lane fraction: `0.80`;
- two-parent probability: `0.00`.

This isolates the descriptor change from the T39/T40/T41/T42/T43
archive-trigger sequence.

## Non-Claim

This is not the full T11 replay projection. T11 also used replay-fitted
structural-contrastive weights, top-64 feature selection, and farthest-first
candidate selection over a historical pool. T44 only makes the highest-ranked
T11-style graph features available online without PPA leakage. A positive T44
result would justify implementing a richer fitted projection; a negative T44
result would show that the simple live bridge is not enough.

## Leakage Rules

The descriptor uses only Yosys graph structure extracted from the candidate
RTL before archive insertion. It excludes final PPA, reference PPA, fitness,
hypervolume, Pareto rank, test pass rate, functionality labels, and problem
identity. PPA enters only after evaluation for quality scoring, local Pareto
retention, and reporting.

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
- operator kind: `eoh_strategies`;
- representation: `code_individual`.

## Acceptance Signals

T44 can advance only if it:

- preserves every classic-covered design in the fixed three-problem screen;
- avoids the 50 percent catastrophic valid-PPA or synthesis-valid decline
  where the classic denominator is at least 10;
- improves at least one direct QD/PPA metric against matched classic and the
  frozen T39/T40 controls, such as raw area-power front hits, HV/HV-AUC,
  valid-PPA count, Pareto spread, archive coverage, or unique front families;
- includes a direct raw area-power PPA-front figure, the
  `visualizations/direct_ppa_pareto/` supplement, and the full Phase 03.1
  `visualizations/qd_ppa_viewer/` bundle.

## Smoke Result

The smoke run used `Prob041_traffic_light`, population `4`, generation `0`,
warmup `4`, and `t11_runtime_top8_graph`. It completed the CLI/runtime path
and wrote archive metadata with the expected descriptor axes. It generated no
valid functional PPA candidate, so it is a profile wiring check only and not a
method result.
