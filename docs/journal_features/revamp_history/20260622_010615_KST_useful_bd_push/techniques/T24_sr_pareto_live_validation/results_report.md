# T24 SR Pareto Live Validation Report

## Status

T24 now has partial live results: the classic baseline, SR-RFF PCA, and SR ReLU
PCA Pareto-QD arms completed on the fixed three-problem RTLLM screen. The
manual BD, random descriptor, and SR raw PCA live arms are still pending.

Tier decision: `pending_live_matrix`.

SR-family live-arm read: not promoted. Both SR arms preserve all three
classic-covered problems and validate the local-Pareto archive mechanics, but
neither protects best quality on `Prob015_multi_pipe_8bit`.

## Why This Is The Next Experiment

T23 showed that the two best SR-family leads have complementary strengths:

- SR ReLU PCA beats classic and T22 random on final HV and HV AUC.
- SR-RFF PCA stays near classic on final HV/best quality and beats classic and
  T22 random on common-audit QD score and local front material.

The unresolved question is whether this passive signal survives live sampling
when parent selection must balance exploration, local Pareto preservation, and
hill-climbing pressure.

## Live Setup

- output root:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/`
- completed arms:
  - `classic_revolution/seed_1001/openai_gpt-oss-120b`
  - `sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b`
- model: `openai/gpt-oss-120b`
- endpoint preflight: `max_model_len=131072`, satisfying the 128000-token
  policy requirement
- population: 12
- generations: 3
- generated candidates per problem per arm: 48
- problems:
  - `RTLLM/Prob045_alu`
  - `RTLLM/Prob041_traffic_light`
  - `RTLLM/Prob015_multi_pipe_8bit`

## Validator Results

`scripts/validate_pareto_front_run.py` passed for both completed SR-family
Pareto archives.

SR-RFF:

- valid: `True`
- failure count: `0`
- problem invalid count: `0`
- max front size seen: `4`
- archive members:
  - `Prob045_alu`: 17 members, max front size 4
  - `Prob041_traffic_light`: 16 members, max front size 2
  - `Prob015_multi_pipe_8bit`: 8 members, max front size 1

SR ReLU:

- valid: `True`
- failure count: `0`
- problem invalid count: `0`
- max front size seen: `5`
- archive members:
  - `Prob045_alu`: 15 members, max front size 4
  - `Prob041_traffic_light`: 17 members, max front size 3
  - `Prob015_multi_pipe_8bit`: 15 members, max front size 5

The validator was run without `--acceptance-hard-subset` because that option
currently asserts the manual-BD descriptor profile. The classic-covered design
preservation gate was checked from the run summaries instead: classic has a
valid result for all three problems, and both completed SR arms also have valid
results for all three problems.

## Best-Score And Valid-PPA Comparison

`Best` is the final best PPA score reported by the runner. `Valid-PPA rate` is
the accumulated synthesis-PPA success rate over 48 generated candidates.

| Arm | Problem | Classic best | Method best | Best delta | Classic valid-PPA | Method valid-PPA | Archive members | Global Pareto |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SR-RFF | `Prob045_alu` | 0.397675 | 0.395398 | -0.57% | 33.33% | 39.58% | 17 | 1 |
| SR-RFF | `Prob041_traffic_light` | 0.414309 | 0.420875 | +1.58% | 62.50% | 37.50% | 16 | 2 |
| SR-RFF | `Prob015_multi_pipe_8bit` | 0.212917 | 0.072262 | -66.06% | 41.67% | 16.67% | 8 | 6 |
| SR ReLU | `Prob045_alu` | 0.397675 | 0.397589 | -0.02% | 33.33% | 33.33% | 15 | 1 |
| SR ReLU | `Prob041_traffic_light` | 0.414309 | 0.403821 | -2.53% | 62.50% | 35.42% | 17 | 4 |
| SR ReLU | `Prob015_multi_pipe_8bit` | 0.212917 | 0.052795 | -75.20% | 41.67% | 33.33% | 15 | 6 |

## Interpretation

The positive evidence is narrow:

- Both SR arms preserve all three classic-covered problems on this screen.
- SR-RFF slightly improves `Prob041_traffic_light` best score.
- SR-RFF improves `Prob045_alu` valid-PPA rate while staying within 1% best
  score of classic.
- SR ReLU nearly matches classic on `Prob045_alu` best score and preserves
  `Prob045_alu` valid-PPA rate.
- SR ReLU improves front material relative to SR-RFF on `Prob041_traffic_light`
  and `Prob015_multi_pipe_8bit`: 4 versus 2 global Pareto members on traffic
  light, and 15 versus 8 archive members on multi-pipe.
- The Pareto archive implementation is structurally valid and retains useful
  local-front material.

The blockers are stronger:

- SR-RFF loses 66.06% relative best score on `Prob015_multi_pipe_8bit`.
- SR ReLU loses 75.20% relative best score on `Prob015_multi_pipe_8bit`.
- SR-RFF valid-PPA rate falls from 41.67% to 16.67% on multi-pipe, a 60%
  relative drop. Since classic produced 20 valid-PPA samples, this is not a
  small-denominator artifact.
- SR ReLU avoids that valid-PPA collapse on multi-pipe, but still loses too
  much best quality to qualify as near-classic.
- Both SR arms lose valid-PPA rate on `Prob041_traffic_light`.
- The random descriptor, manual BD, and SR raw PCA live arms are not yet run,
  so no QD usefulness claim can be made from this partial matrix.

## Conclusion

The completed SR-family T24 arms answer one narrow question: the existing
`pareto_front` cell mode and NSGA-II parent selection can run end to end with
both SR-RFF and SR ReLU descriptors on the local vLLM endpoint. They do not
answer the paper question positively yet. Both arms are useful diagnostics, but
neither is promoted under the current gate.

The next T24 decision should run the SR raw PCA ablation and the random
descriptor control before making a family-level claim. In parallel, the next
method variant should add a quality/yield guard or adaptive emitter pressure
for `Prob015_multi_pipe_8bit`, because both SR-RFF and SR ReLU find front
material there without retaining competitive best quality.

## Anti-Overclaim Note

This package still does not prove QD/MAP-Elites usefulness for RTL PPA
optimization. It records a measured partial live result and a promotion
blocker that should shape the next archive-coupling variant.
