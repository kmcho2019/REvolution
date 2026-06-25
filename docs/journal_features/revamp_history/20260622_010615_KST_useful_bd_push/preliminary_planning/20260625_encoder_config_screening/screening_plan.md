# Screening Plan

## Objective

Choose a small, firm set of QD/MAP-Elites configurations for a later full
RTLLM comparison against classic REvolution.

## Frozen Screen

| Field | Value |
| --- | --- |
| Budget | `population_size=8`, `num_generations=5` |
| Seed | `1001` |
| Endpoint | `http://20.0.0.103:8000/v1/models` |
| Model | `openai/gpt-oss-120b` |
| Token budgets | `max_tokens=128000`, `diff_max_tokens=128000` |
| Worker shape | `total_worker_slots=32`, `max_active_problems=8`, `max_workers_per_problem=4` |
| Evaluation | `strict_ablation` |

## Frozen Subset

| Benchmark | Problem | Reason |
| --- | --- | --- |
| RTLLM | `Prob015_multi_pipe_8bit` | Multi-objective front-sensitive case. |
| RTLLM | `Prob024_fsm` | Moderate control-family case. |
| RTLLM | `Prob041_traffic_light` | Control-heavy and historically method-separating. |
| RTLLM | `Prob045_alu` | Arithmetic/control mix. |
| RTLLM | `Prob049_signal_generator` | Useful archive/yield signal in recent runs. |
| VerilogEval-Spec-to-RTL | `Prob116_m2014_q3` | Reference-complete PPA variation case. |
| VerilogEval-Spec-to-RTL | `Prob135_m2014_q6b` | Useful but watch saturation. |
| VerilogEval-Spec-to-RTL | `Prob153_gshare` | Hard case that exposes coverage failures. |

## Metrics

Headline metrics must use the reference-complete paired subset only.

| Metric | Why It Matters |
| --- | --- |
| HV | Primary final PPA-front quality metric. |
| HV-AUC | Rewards early discovery of useful fronts. |
| Pareto point count | Measures front breadth, not just a single best sample. |
| Unique PPA point count | Detects duplicate-heavy or collapsed fronts. |
| Reference-beating candidates | Shows whether candidates materially improve over reference PPA. |
| Valid-PPA coverage | Ensures a method does not win by dropping hard designs. |
| Archive coverage and QD score | Secondary evidence only; not a headline success metric by itself. |

## Promotion Gate

A QD arm can advance to full RTLLM if it satisfies all of these conditions:

1. It has at least one valid-PPA candidate for every design where classic has
   at least one valid-PPA candidate.
2. It is positive or within about `1-2%` of classic on mean HV.
3. HV-AUC is not materially worse than classic.
4. At least one front-breadth metric improves.
5. There is no severe valid-PPA collapse on designs with enough baseline
   passing samples to judge the rate.
6. Descriptor diagnostics do not show duplicate collapse, problem-ID collapse,
   or missing reference PPA in headline rows.

## Full RTLLM Candidate Rule

Run at most:

- the best custom-BD arm,
- the best RTL-native arm,
- one pretrained-encoder arm only if the bridge work produces a live,
  non-collapsed descriptor path.

If no QD arm survives the screen, do not spend the full RTLLM budget yet.
