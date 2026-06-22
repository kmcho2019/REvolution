# T41 Adaptive Sparse-Yield Gate Methodology

Status: pre-registered live method.

## Question

T40 showed that uniform sparse warmup is mixed: T39 wins the hard multi-pipe
slice, but classic still owns ALU and traffic-light raw area-power fronts. T41
asks whether the one-slot sparse-yield lane can be gated per design instead of
applied uniformly.

## Method Delta

T41 keeps the T38/T40 stricter primary warmup threshold of `8` successes. It
adds an adaptive fallback:

- fallback threshold: `4` valid PPA successes;
- trigger generation: `1`;
- fallback mode: `adaptive_sparse_yield_fallback`;
- fallback condition: the per-problem grid-quantile archive is still in
  warmup, has at least four buffered valid PPA samples, and has enough
  descriptor variation to form an active quantile grid.

This means easy designs can keep the stricter eight-success archive warmup,
while sparse-yield designs can activate after the first generation instead of
remaining archive-empty.

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

The adaptive trigger uses only in-run archive state and valid PPA sample count.
It does not use final PPA, reference PPA, hypervolume, Pareto rank, test pass
rate, problem identity, or any post-hoc front label as a descriptor input.

## Acceptance Signals

T41 can advance only if it:

- preserves every classic-covered design in the T40 screen;
- avoids a catastrophic functionality or synthesis-validity drop where the
  classic denominator is large enough;
- improves over T39 on ALU or traffic-light raw area-power pooled-front hits,
  best score, or valid-PPA yield without losing the T39 multi-pipe signal;
- beats random one-slot on the claimed metric;
- leads with a direct raw area-power PPA Pareto figure using conventional
  lower-left-better axes.

If T41 only reproduces T39's multi-pipe behavior while still losing ALU and
traffic-light, it remains `T0`.
