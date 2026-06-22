# T42 Results Report

Status: complete live screen; tier `T0 mixed_diagnostic`.

## Question

Does triggering the sparse-yield fallback immediately after the initial
population recover T39's multi-pipe signal while preserving T41's
traffic-light gain?

## Direct PPA Definitions

`Direct raw area-power Pareto front` means a candidate is nondominated in raw
area and raw power for the same problem and method. Lower area and lower power
are both better. `Pooled front` means nondominated after pooling candidates
from all compared methods for the same problem. This is separate from the
active objective front, which can include timing-aware objectives.

## Setup

The live run used `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`, and
`RTLLM/Prob015_multi_pipe_8bit` with seed `1001`, population `12`, generations
`3`, `strict_ablation`, model `openai/gpt-oss-120b`, and
`128000` token caps. The run root is:

`exp/useful_bd_push/t42_initial_sparse_yield_gate_qd_20260622_093940_UTC/`

T42 keeps T41's descriptor, archive, parent selection, operator, budget, and
subset. It changes only the adaptive warmup trigger from generation `1` to
generation `0`.

## Primary Evidence

The primary reader-facing figure is
`figures/t42_raw_area_power_fronts.png`. It uses raw area on x, raw power on y,
conventional non-inverted axes, and lower-left as better. Open circles mark
each method's raw area-power front; black stars mark the pooled front across
methods.

The local HTML viewer is
`visualizations/direct_ppa_pareto/index.html`. The inspected screenshot is
`visualizations/direct_ppa_pareto/screenshot.png`.

Regeneration data:

- candidate rows: `tables/t42_candidate_ppa_points.csv`
- problem summary: `tables/t42_problem_method_summary.csv`
- method manifest: `tables/t42_method_manifest.csv`
- validator output: `tables/initial_sparse_yield_gate_qd_validation.md`

## Result Summary

| Problem | Comparator | Valid PPA | Raw front | Pooled front | Best score |
| --- | --- | ---: | ---: | ---: | ---: |
| `Prob045_alu` | T42 Classic | 31 | 5 | 0 | 0.393031 |
| `Prob045_alu` | T42 initial gate | 17 | 1 | 1 | 0.406419 |
| `Prob041_traffic_light` | T42 Classic | 27 | 4 | 2 | 0.436181 |
| `Prob041_traffic_light` | T42 initial gate | 16 | 2 | 0 | 0.391093 |
| `Prob015_multi_pipe_8bit` | T42 Classic | 13 | 1 | 0 | 0.037911 |
| `Prob015_multi_pipe_8bit` | T42 initial gate | 15 | 1 | 1 | 0.116397 |

Against T41 and T39 controls:

- T42 recovers one ALU pooled-front point and one multi-pipe pooled-front point.
- T42 improves multi-pipe versus T41's best score
  `-0.000378`, reaching `0.116397`.
- T42 does not recover T39's multi-pipe best score `0.222285`.
- T42 loses T41's traffic-light result: T41 has seven traffic-light pooled
  front hits and best score `0.473631`; T42 has zero pooled hits and best score
  `0.391093`.

## Validity

T42 preserves every classic-covered problem in the fixed three-problem screen.
The matched T42 classic arm has valid PPA on all three problems, and T42 also
has valid PPA on all three. Valid-PPA counts are:

- ALU: 17 for T42 versus 31 for classic;
- traffic-light: 16 for T42 versus 27 for classic;
- multi-pipe: 15 for T42 versus 13 for classic.

The ALU and traffic-light valid-PPA drops are material, but they do not cross
the 50 percent catastrophic-drop gate where the classic denominator is at
least 10. Pareto archive validation passed with `failure_count=0`,
`problem_invalid_count=0`, and `acceptance_error_count=0`.

## Archive Read

The T42 QD archives initialized on all three problems. The archive summaries
report `warmup_successes=8` for ALU, traffic-light, and multi-pipe. That means
this screen did not clearly exercise a new sparse-initialization regime; the
generation-0 hook is operational, but the observed outcome is mostly an
archive-timing ablation rather than proof that earlier sparse fallback solves
the hard cases.

## Conclusion

T42 is `T0 mixed_diagnostic`.

It is useful evidence because the direct PPA front shows that generation-0
triggering can move some pooled-front material to ALU and multi-pipe while
preserving classic-covered problem coverage. It is not promoted because it
loses the traffic-light advantage that made T41 interesting and still does not
recover the T39 multi-pipe best score. The straightforward raw area-power
Pareto figure is therefore negative for a screen-wide useful-QD claim: T42
shifts where the front material appears, but it does not dominate the T39/T41
tradeoff.

Next step: do not keep shifting one global warmup trigger. The follow-up should
use a per-design or staged sparse-yield classifier that keeps the T41/T42
strict path for healthy-yield problems and activates the sparse one-slot path
only for designs with measured initial archive sparsity.
