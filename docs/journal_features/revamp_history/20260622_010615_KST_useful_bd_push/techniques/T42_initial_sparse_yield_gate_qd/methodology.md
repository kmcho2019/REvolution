# T42 Initial Sparse-Yield Gate Methodology

Status: complete live method; interpreted as `T0 mixed_diagnostic`.

## Question

T41 showed that adaptive sparse-yield gating is useful on traffic-light but
too late or too weak for multi-pipe. T42 tests the smallest timing change:
allow the sparse-yield fallback immediately after the initial population,
before the first evolved generation.

## Method Delta

T42 keeps T41's archive, descriptor, parent selection, operator, model, seed,
subset, and budget. It changes only the adaptive fallback trigger:

- primary grid-quantile warmup threshold: `8` valid PPA successes;
- fallback threshold: `4` valid PPA successes;
- trigger generation: `0`;
- fallback mode: `adaptive_sparse_yield_fallback`;
- fallback condition: the per-problem grid-quantile archive is still in
  warmup, has at least four buffered valid PPA samples, and has enough
  descriptor variation to form an active quantile grid.

This tests whether sparse-yield designs need archive pressure before generation
1. High-yield designs still use the strict eight-success warmup when enough
initial samples exist. The measured screen initialized all three archives with
`8` warmup successes, so the result should be read as a conservative timing
ablation, not as proof that the fallback threshold fired on every problem.

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
- cell mode: `elite_pareto_slot`;
- max elites per cell: `2`;
- parent selection: `nsga2_global_rank`;
- champion lane: `0.80`;
- two-parent probability: `0.00`;
- operator kind: `eoh_strategies`;
- representation: `code_individual`.

## Leakage Rules

The trigger uses only in-run archive warmup state and valid PPA sample count.
It does not use final PPA, reference PPA, hypervolume, Pareto rank, test pass
rate, problem identity, or any post-hoc front label as a descriptor input.

## Acceptance Signals

T42 can advance only if it:

- preserves every classic-covered design in the fixed three-problem screen;
- avoids a catastrophic functionality or synthesis-validity drop where the
  classic denominator is large enough;
- keeps T41's traffic-light gain or explains a tradeoff with stronger
  multi-pipe recovery;
- recovers the T39 multi-pipe best-score or pooled-front signal better than
  T41 did;
- beats random one-slot on the claimed metric;
- leads with a direct raw area-power PPA Pareto figure using conventional
  lower-left-better axes.

Measured outcome: T42 preserved all classic-covered problems and added one
pooled raw area-power front hit on ALU and one on multi-pipe, but lost T41's
traffic-light front advantage and did not recover T39's multi-pipe best score.
It remains `T0 mixed_diagnostic`.
