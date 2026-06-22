# T40 Sparse-Warmup Control Matrix Methodology

Status: pre-registered validation matrix.

## Question

T39 fixed the T38 sparse-yield archive gap, but it did not compare against
same-budget controls. T40 asks whether the T39 sparse-warmup one-slot result is
still meaningful when judged against matched classic, manual-BD, random, and
full local-Pareto controls.

## Fixed Settings

T40 keeps these settings fixed across all live arms:

- model: `openai/gpt-oss-120b`;
- endpoint: `http://20.0.0.103:8000/v1`;
- benchmark subset: `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`,
  `RTLLM/Prob015_multi_pipe_8bit`;
- seed: `1001`;
- population: `12`;
- generations: `3`;
- evaluation mode: `strict_ablation`;
- `max_tokens` and `diff_max_tokens`: `128000`;
- QD archive type: `grid_quantile`;
- QD warmup: `--qd_grid_quantile_warmup_successes 4`;
- QD parent selection: `nsga2_global_rank`;
- QD champion lane: `0.80`;
- QD two-parent probability: `0.00`;
- QD operator kind: `eoh_strategies`;
- representation: `code_individual`.

The T39 arm is the frozen completed run from
`exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`.
T40 runs the missing controls under the same budget and scheduler settings.

## Arms

| Arm | Role | Descriptor | Cell mode |
| --- | --- | --- | --- |
| `classic_revolution` | scalar hill-climbing reference | none | none |
| `manual_sparse_pareto_qd` | landing Smooth-QD/manual-BD control | `journal_logic_ff_width_3d` | `pareto_front`, max 5 |
| `random_sparse_elite_slot_qd` | random descriptor control for one-slot archive | `random_hash_3d` | `elite_pareto_slot`, max 2 |
| `graph_full_pareto_sparse_qd` | same descriptor, full local-Pareto control | `journal_graph_testability_3d` | `pareto_front`, max 5 |
| `t39_sparse_warmup_elite_slot_qd` | candidate arm, frozen T39 reference | `journal_graph_testability_3d` | `elite_pareto_slot`, max 2 |

## Leakage Rules

Descriptor inputs cannot use PPA, final score, reference PPA, hypervolume,
Pareto rank, test pass rate, or validity labels. The random descriptor hashes
the canonical synthesized netlist hash and a fixed random seed. Manual and
graph descriptors use only structural/runtime descriptor profiles.

## Acceptance Signals

T40 can promote T39 only if the candidate arm:

- preserves every classic-covered design with at least one valid PPA result;
- does not trigger the catastrophic validity/synthesis drop gate where the
  baseline denominator is large enough;
- matches or improves classic/manual/random/full-Pareto on at least one primary
  QD/PPA metric: global PPA hypervolume, HV-AUC, valid-PPA yield, raw Pareto
  spread, active archive coverage, or front-family breadth;
- has direct raw PPA-front figures that support the numerical conclusion.
  These figures must use area on x, power on y, conventional non-inverted
  axes, and a visible lower-left-is-better cue.

If T39 only beats T38 but not the controls, it remains `T0 positive_ablation`.

## Required Artifacts

- `/v1/models` preflight capture;
- exact commands in `commands/live_screen_v0.md`;
- frozen subset in `tables/live_screen_v0_subset.yaml`;
- run matrix in `tables/run_matrix.csv`;
- Pareto validator outputs for QD arms;
- direct raw area-power PPA Pareto figures and HTML viewer, with the raw
  lower-left-better figure first in the report;
- candidate/front tables sufficient to regenerate figures;
- results report with a T0/T1/T2/T3 tier decision;
- visual inspection notes.
