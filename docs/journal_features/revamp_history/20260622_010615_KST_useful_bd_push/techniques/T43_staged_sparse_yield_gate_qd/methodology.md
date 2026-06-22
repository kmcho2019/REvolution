# T43 Staged Sparse-Yield Gate Methodology

Status: pre-registered live method; not yet interpreted.

## Question

T42 showed that moving the sparse-yield fallback to generation `0` shifts
some front material to ALU and multi-pipe, but it loses T41's traffic-light
front advantage. T43 tests a staged version: keep high-yield problems on the
T41/T42 exploit-heavy parent policy, and reduce champion-lane pressure only
for a problem whose archive actually initializes through the adaptive
sparse-yield fallback.

## Method Delta

T43 keeps T42's descriptor, archive, operator, seed, model, subset, and
budget. It changes only the post-initialization parent pressure for sparse
archives:

- primary grid-quantile warmup threshold: `8` valid PPA successes;
- fallback threshold: `4` valid PPA successes;
- fallback trigger generation: `0`;
- default champion lane: `0.80`;
- adaptive-fallback champion lane: `0.60`;
- parent selection: `nsga2_global_rank`;
- cell mode: `elite_pareto_slot`;
- max elites per cell: `2`.

The staged gate is per problem. It is active only when the archive
initialization mode is `adaptive_sparse_yield_fallback`. Archives that reach
the strict eight-success warmup keep the `0.80` champion lane.

## Leakage Rules

The staged trigger uses only in-run archive state: whether the archive was
initialized by the adaptive sparse-yield fallback. It does not use final PPA,
reference PPA, final Pareto rank, hypervolume, best score, test pass rate, or
problem identity.

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
- archive type: `grid_quantile`;
- descriptor: `journal_graph_testability_3d`;
- descriptor file: `data/configs/qd_descriptor_profiles.yaml`;
- operator kind: `eoh_strategies`;
- representation: `code_individual`.

## Acceptance Signals

T43 can advance only if it:

- preserves every classic-covered design in the fixed three-problem screen;
- avoids the 50 percent catastrophic valid-PPA drop where the classic
  denominator is at least 10;
- keeps T41's traffic-light pooled-front or best-score signal better than T42;
- keeps or improves T42's ALU and multi-pipe pooled-front hits;
- beats T39 on multi-pipe or explains a smaller but useful tradeoff;
- leads with a direct raw area-power PPA Pareto figure using conventional
  lower-left-better axes.

If T43 does not preserve T41 traffic-light while improving T42/T39 multi-pipe
evidence, it remains `T0`.
