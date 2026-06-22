# T43 Results Report

Status: complete live screen; `T0 mixed_diagnostic`.

## Question

Does lowering champion-lane pressure only after adaptive sparse-yield archive
initialization preserve T41's traffic-light signal while keeping T42's ALU and
multi-pipe pooled-front recovery?

## Definitions

- Raw PPA point: one candidate with valid synthesized area and power.
- Method raw front: nondominated raw area-power points within one method for
  one problem. Lower area and lower power are both better.
- Pooled raw front: nondominated raw area-power points after pooling all
  compared methods for one problem. Pooled-front hits are the direct visual
  evidence that a method contributes points no compared method dominates.
- Best score: the run's scalar fitness field. It is secondary here because
  this package tests front geometry and candidate spread.

## Evidence

- Runtime root:
  `exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC/`.
- vLLM preflight: `openai/gpt-oss-120b` served with `max_model_len=131072`.
- Matched arms: `classic_revolution` ran in 1025 seconds;
  `staged_sparse_yield_gate_qd` ran in 721 seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Primary figure: `figures/t43_raw_area_power_fronts.png`.
- HTML viewer:
  `visualizations/direct_ppa_pareto/index.html`.
- Regeneration data:
  `tables/t43_candidate_ppa_points.csv` and
  `tables/t43_problem_method_summary.csv`.

## Results

| Method | Problem | Valid PPA | Method raw front | Pooled raw front | Best score |
| --- | --- | ---: | ---: | ---: | ---: |
| T43 Classic | Prob045_alu | 35 | 1 | 1 | 0.414773 |
| T43 staged gate | Prob045_alu | 23 | 3 | 0 | 0.401364 |
| T43 Classic | Prob041_traffic_light | 12 | 2 | 0 | 0.409991 |
| T43 staged gate | Prob041_traffic_light | 26 | 7 | 0 | 0.407742 |
| T43 Classic | Prob015_multi_pipe_8bit | 14 | 2 | 0 | 0.400597 |
| T43 staged gate | Prob015_multi_pipe_8bit | 13 | 1 | 0 | 0.052795 |

T43 preserves all three classic-covered designs and passes the validity gate.
It improves traffic-light candidate yield over the matched classic arm
(`26` valid PPA points versus `12`) and exposes seven traffic-light method
front points. That is useful diagnostic evidence that the archive can preserve
more raw front material than classic on this problem.

The staged sparse-yield condition did not activate in this run. All three QD
archives reached the strict eight-success warmup path, so
`qd_adaptive_warmup_champion_lane_fraction=0.60` was never used. T43 therefore
behaves as a normal strict-warmup, `0.80` champion-lane run for this screen.

T43 is not a promotion candidate. It contributes zero pooled raw area-power
front hits on all three problems. T41 still owns the traffic-light pooled front
with seven pooled hits and best score `0.473631`. T42 keeps a better
multi-pipe pooled-front point than T43, and T39 keeps the stronger multi-pipe
best score (`0.222285` versus T43's `0.052795`).

## Conclusion

T43 answers the staged-gate question negatively for this live screen. The
implementation is valid and the direct PPA visualizations are now adequate, but
the run did not enter the sparse adaptive state the method was designed to
change. The next attempt should either create a true sparse-trigger screen with
a bounded warmup buffer/patience rule, or move to exact T11 runtime projection
so the descriptor itself changes rather than only parent pressure.
