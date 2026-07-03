# Suggested Decisive Experiment

## Goal

Run one registered comparison that is strong enough to answer whether the
current QD/MAP-Elites direction deserves further TCAD investment.

The experiment should compare classic REvolution against a small set of
selected QD candidates on RTLLM with the same model, seed, prompts, budget, and
evaluation pipeline.

## Candidate Arms

Required baseline:

| Arm | Role |
| --- | --- |
| `classic_revolution` | Strong non-QD hill-climbing baseline. |

Recommended QD arms:

| Arm | Category | Rationale |
| --- | --- | --- |
| `qd_sr_guarded_conservative` | Custom synthesis-response BD | Based on T04/T19/T20/T26. Best automatic descriptor family, but needs quality/yield guarding. |
| `qd_t36_bounded_front_graph` | Learned graph/structural replay family | Best replay HV/front-hit signal. Must be implemented live without post-hoc global-front leakage. |
| `qd_rtl_native_structural_mix` | RTL-native custom BD | Based on T72/T75/T80. Best reviewer-readable descriptor story. |
| `qd_qwen3_canonical_rtl` | Pretrained text/code embedding | Best lightweight pretrained embedding lane. Include as a reality check, not because it is currently strongest. |

Conditional arm:

| Arm | Condition |
| --- | --- |
| `qd_deepgate_verified_netlist` | Include only if a real DeepGate checkpoint/model path is verified on generated netlists. Otherwise label it as a graph surrogate and do not claim pretrained DeepGate use. |

Do not include a candidate only because it has high archive occupancy. Every
QD arm should have a clear mechanism for preserving PPA-competitive fronts.

## Budget

Use one fixed budget shape for all arms. Reasonable choices:

| Shape | Reason |
| --- | --- |
| `8x5` | Least negative exact-T75 shape in T79; gives more maturation than `12x3` while preserving 48 candidates/problem. |
| `12x3` | Best continuity with prior RTLLM and T26 milestone results. |

If only one can be afforded, use `8x5` and record that classic also gets the
same budget shape.

## Benchmark

Use RTLLM, but headline aggregates must be reference-complete:

- include all 50 in the inventory if desired;
- exclude missing-reference designs from headline normalized HV/HV-AUC claims;
- label missing-reference designs as diagnostic-only.

Known missing-reference designs from the T26 correction:

- `Prob006_adder_pipe_64bit`
- `Prob013_multi_booth_8bit`
- `Prob018_float_multi`
- `Prob040_synchronizer`

## Primary Metrics

1. Mean HV delta versus classic on reference-complete paired subset.
2. Mean HV-AUC delta versus classic.
3. Per-problem win/loss/tie count.
4. PPA-front point count.
5. Unique PPA point count.
6. Reference-beating candidate count.
7. Valid-PPA coverage of classic-covered designs.
8. Functionality/synthesis/valid-PPA yield warnings.

Secondary metrics:

- archive coverage;
- QD score;
- occupied cells;
- descriptor collapse diagnostics;
- unique netlist or implementation-family counts;
- runtime and worker utilization.

## Decision Rule

Promote a QD candidate only if it satisfies all of the following:

- preserves every classic-covered problem at the PPA stage;
- has no hidden reference-PPA issue in headline metrics;
- beats or near-ties classic on mean HV and HV-AUC;
- improves at least one front-breadth metric such as Pareto points, unique PPA
  points, or reference-beating candidates;
- does not show catastrophic yield collapse where classic has enough samples
  for the rate to be meaningful;
- has descriptor evidence that is not merely problem identity, text length, or
  duplicate artifacts.

If all selected QD arms lose classic under this protocol, the research should
stop claiming that the current QD implementation is effective. The TCAD story
should pivot to a rigorous negative result and a narrower future-work thesis:
generic QD pressure is insufficient; RTL-native auxiliary-memory diversity may
still be worth studying.
