# Encoder Config Screening Plan

This package prepares the next screening run for choosing the final full-RTLLM
QD/MAP-Elites comparison arms.

## Core Question

Can any diversity-aware method compete with or beat classic REvolution on
reference-complete PPA-front metrics when we choose strong behavior
descriptors instead of generic novelty?

## Definitions

| Term | Definition |
| --- | --- |
| Behavior descriptor (BD) | The low-dimensional coordinates used to place an RTL candidate in a QD archive cell. |
| Pretrained encoder | A model trained outside this experiment whose embeddings or model states are used as BD evidence. |
| Encoder-like | A learned or graph representation lane that behaves like an encoder but is not a verified external pretrained model. |
| Spend-ready | A config with a live runtime descriptor path, command line, and non-collapse or parse validation. |
| Bridge-required | A config with good replay evidence but missing live generation-time support or verification. |
| Valid-PPA candidate | A candidate with passing functionality/synthesis and non-missing PPA values. |
| Reference-complete | A problem whose reference `ppa.txt` exists and is valid, so normalized HV/improvement metrics are meaningful. |
| HV | Hypervolume of the PPA Pareto front after converting area/power into minimization objectives against a fixed reference. |
| HV-AUC | Area under the HV-over-time curve; it rewards methods that find useful fronts earlier, not only at the end. |
| Descriptor collapse | A descriptor failure where many candidates map to nearly identical coordinates or only encode problem identity. |

## Current Spend-Ready Screen

The immediate screen uses an 8-problem, reference-complete, medium-difficulty
subset and a deeper fixed budget of `8x5`.

| Arm | Role | Why Included |
| --- | --- | --- |
| `classic_revolution_8x5` | Baseline | Direct hill-climbing comparator. |
| `code_thought_sr_front_slot_8x5` | Custom BD | T51-style conservative archive coupling is the strongest practical custom-BD base. |
| `masterrtl_structural_mix_8x5` | RTL-native BD | T80 showed non-collapsed source-aligned MasterRTL structural axes. |
| `qwen_canonical_rtl_pca3_8x5` | Pretrained encoder BD | Actual Qwen3 embedding hook after model, probe, and smoke validation. |

The launch commands are in `commands/screening_matrix_v0.md`.

## Bridge Work Before Full RTLLM

| Candidate | Current Read | Required Before Live Spend |
| --- | --- | --- |
| Qwen3 canonical RTL | Best actual pretrained replay signal from T33. | Add a runtime embedding descriptor hook and collapse checks. |
| T11/T36 graph lane | Strongest encoder-like replay signal. | Avoid repeating exact T58, which failed live; redesign with front/yield protection. |
| DeepGate3 netlist | Real checkpoints load, but probe embeddings nearly collapsed. | Verify nonconstant embeddings on generated netlists and add a live hook. |
| AURORA-style raw features | Raw implementation-feature replay signal exists. | Define a live profile; do not promote compressed bottlenecks without evidence. |

## Package Contents

| Path | Purpose |
| --- | --- |
| `current_encoder_assessment.md` | Short presentation-oriented ranking and interpretation. |
| `screening_plan.md` | Exact subset, gates, and promotion logic. |
| `live_screen_results.md` | Completed hard-data screen result and decision. |
| `pretrained_encoder_validation.md` | Validation gate for future pretrained-weight live arms. |
| `../20260625_pretrained_encoder_bridge_validation/` | Follow-up package deciding which pretrained or encoder-like lanes are ready for the next live hook. |
| `../20260625_deepgate_generated_bridge_probe/` | Follow-up DeepGate bridge probe after Qwen lost the live screen. |
| `commands/screening_matrix_v0.md` | Launch commands for the live screening arms. |
| `tables/candidate_shortlist.csv` | Machine-readable candidate ranking. |
| `tables/encoder_legitimacy_checks.csv` | Evidence table for pretrained and encoder-like candidates. |
| `tables/descriptor_probe_summary.csv` | Runtime descriptor dependency probe summary. |
| `tables/live_smoke_summary.csv` | Tiny live vLLM smoke outcome for the spend-ready arms. |
| `tables/live_screen_aggregate_pareto_metrics.csv` | Formal aggregate HV/Pareto table from the completed screen. |
| `tables/live_screen_problem_hv_deltas.csv` | Per-problem QD-minus-classic HV deltas. |
| `tables/screening_matrix.csv` | Machine-readable run matrix. |
| `tables/prelim_screen_subset.yaml` | Frozen screening subset. |
| `logs/preliminary_check_log.md` | Commands run and validation outcomes. |

## Decision Rule

Advance at most two QD arms to full RTLLM unless a third arm is clearly the
best pretrained-encoder representative. A QD arm must preserve every
classic-covered design on the screen and be positive or near-tied on HV while
improving at least one front-breadth metric.

## Live Smoke Outcome

A one-problem `1x0` smoke on `Prob045_alu` launched all spend-ready arms
against `openai/gpt-oss-120b`.

| Arm | Launch | Valid-PPA Candidates | Notes |
| --- | --- | --- | --- |
| `classic_revolution_1x0` | Pass | 0/1 | Candidate failed functionality in this tiny smoke. |
| `code_thought_sr_front_slot_1x0` | Pass | 0/1 | QD archive artifacts emitted; candidate failed functionality. |
| `masterrtl_structural_mix_1x0` | Pass | 1/1 | QD archive artifacts emitted; one global Pareto member. |

This does not rank methods. It only verifies that the live command surface and
descriptor paths work before the real 8-problem screen.

## Completed Screen Outcome

The registered `8x5` screen completed for the original three arms and the
follow-up Qwen pretrained-encoder arm.

| Arm | Problem Success | Valid-PPA Files | Mean HV |
| --- | ---: | ---: | ---: |
| `classic_revolution_8x5` | 8/8 | 191 | 0.1406 |
| `code_thought_sr_front_slot_8x5` | 8/8 | 168 | 0.1141 |
| `masterrtl_structural_mix_8x5` | 8/8 | 181 | 0.1218 |
| `qwen_canonical_rtl_pca3_8x5` | 8/8 | 192 | 0.1108 |

Decision: no screened QD arm should be promoted to the full RTLLM run yet. The
best QD arm is `masterrtl_structural_mix_8x5`, but it still trails classic on
headline HV, Pareto-point count, and reference-beating count. Qwen canonical
RTL preserved coverage and had positive deltas on two problems versus classic,
but it lost aggregate HV and front breadth.

DeepGate is no longer blocked only by descriptor collapse: the latch-free
bridge embeds `24` generated rows, and the corrected transition bridge embeds
`60` rows across `5/8` screening problems. It remains blocked by large-design
coverage and same-problem clustering. MasterRTL pretrained-head lanes remain
blocked by generated-candidate collapse.
