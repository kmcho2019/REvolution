# T45 Compact T11 Runtime Graph Methodology

Status: pre-registered; live screen pending.

## Question

T44 showed that live T11-style graph axes are not empty signal: it improved
traffic-light and multi-pipe HV and added pooled raw-PPA front hits. The
blocker was yield. The top-8 archive dropped valid PPA too sharply on ALU and
traffic-light, which suggests the descriptor space may be too sparse for this
small live budget.

T45 asks whether a compact top-4 subset of those same runtime graph axes keeps
the useful front/HV signal while reducing archive sparsity and valid-PPA loss.

## Method Delta

T45 adds descriptor profile `t11_runtime_top4_graph`:

- `hyper_mean_fanout`
- `edge_per_node`
- `log_edge_count`
- `hyper_directed_edge_count`

These are the first four axes from the T44 top-8 profile, preserving the
pre-registered T11 runtime ranking while reducing dimensionality from eight
axes to four.

Everything else stays fixed to the T44 live screen:

- archive type: `grid_quantile`;
- warmup successes: `4`;
- cell mode: `elite_pareto_slot`;
- max elites per cell: `2`;
- parent selection: `nsga2_global_rank`;
- champion lane fraction: `0.80`;
- two-parent probability: `0.00`;
- operator: `eoh_strategies`;
- representation: `code_individual`.

This isolates descriptor dimensionality from archive mechanics and parent
pressure.

## Non-Claim

T45 is not a fitted T11 projection and not a top-16/top-64 escalation. It is a
conservative ablation that tests whether T44's live signal survives after
compressing the archive geometry. A positive result justifies a richer frozen
non-PPA projection. A negative result means the simple ranked graph-axis bridge
is not enough by itself.

## Leakage Rules

The descriptor uses only Yosys graph structure extracted from candidate RTL
before archive insertion. It excludes final PPA, reference PPA, fitness,
hypervolume, Pareto rank, functionality pass labels, test pass rate, and
problem identity. PPA enters only after evaluation for scoring, local Pareto
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
- run output root: `exp/useful_bd_push/`.

## Acceptance Signals

T45 can advance only if it:

- preserves every classic-covered design in the fixed three-problem screen;
- avoids a 50 percent or larger valid-PPA or synthesis-valid decline when the
  matched classic denominator is at least 10;
- improves at least one primary QD/PPA metric versus matched classic, T44, or
  frozen T39/T43 references: global PPA HV, HV-AUC, valid-PPA yield,
  raw-PPA front hits, Pareto spread, archive coverage, or unique front
  families;
- includes both `visualizations/direct_ppa_pareto/` and the full Phase 03.1
  `visualizations/qd_ppa_viewer/` bundle before any result is complete.
