# T86 Results Report

Status: completed smoke; control-negative.

## Definition

T86 keeps the T85 front-guarded QD memory scheduler fixed and changes only the
descriptor to the deterministic `random_hash_3d` control. The purpose is to
ask whether exact `sr_pca_3d` memory is doing more than generic random memory
retention under the same FG-QDM policy.

## Run

| Run | Root | Read |
| --- | --- | --- |
| Random-memory smoke | `exp/useful_bd_push/front_guarded_memory_controls_20260626/fg_qdm_random_memory_12x3/seed_1001/openai_gpt-oss-120b` | Completed `3/3` smoke problems in `698.27s` after vLLM preflight. |

Preflight confirmed `openai/gpt-oss-120b` with `max_model_len=131072`.

## Headline Metrics

| Backend | Problems | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | 3 | 0.190331 | 3.00 | 17.33 | 3 |
| `fg_qdm_random_memory_12x3` | 3 | 0.138162 | 2.67 | 9.67 | 0 |
| `fg_qdm_sr_memory_warmup4_12x3` | 3 | 0.137536 | 2.00 | 9.00 | 0 |

Classic remains clearly stronger. Random-memory FG-QDM is slightly above
SR-memory FG-QDM on mean HV and front count, which means exact `sr_pca_3d`
memory does not beat the random-memory control on this smoke.

## Mechanism Read

Random memory has noncollapsed descriptor axes on all three problems and the
grid initializes on all three. It also produces memory-refine global-front
adds on `Prob015_multi_pipe_8bit` and `Prob041_traffic_light`, while the
matched SR-memory warmup-4 run has zero memory-lane global-front adds.

This does not promote random memory. It blocks the claim that the current
`sr_pca_3d` descriptor is earning FG-QDM memory budget.

## Decision

`T0_control_negative_not_promoted`.

Do not continue exact `sr_pca_3d` FG-QDM. A future FG-QDM continuation needs a
materially different descriptor or a simplified/rejustified memory-credit
mechanism, and it should not be launched until the code-complexity findings
from the periodic review are addressed.
