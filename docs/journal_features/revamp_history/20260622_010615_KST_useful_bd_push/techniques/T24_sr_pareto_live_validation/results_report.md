# T24 SR Pareto Live Validation Report

## Status

T24 now has partial live results: the classic baseline, random descriptor,
SR-RFF PCA, SR ReLU PCA, and SR raw PCA Pareto-QD arms completed on the fixed
three-problem RTLLM screen. The manual BD live arm is still pending.

Tier decision: `pending_live_matrix`.

Completed-QD read: not promoted. Random and all three SR arms preserve all
classic-covered problems and validate the local-Pareto archive mechanics, but
none protects best quality on `Prob015_multi_pipe_8bit`. Random and SR raw
also violate the synthesis-validity regression gate on
`Prob041_traffic_light`.

## Why This Is The Next Experiment

T23 showed that the two best transformed SR-family leads have complementary
strengths:

- SR ReLU PCA beats classic and T22 random on final HV and HV AUC.
- SR-RFF PCA stays near classic on final HV/best quality and beats classic and
  T22 random on common-audit QD score and local front material.

T24 turns that passive signal into a live same-budget screen. The random
descriptor arm is required because the earlier replay showed random partitioning
can look strong on AUC and front material, so any positive QD claim must beat
random on the metric being claimed.

## Live Setup

- output root:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/`
- completed arms:
  - `classic_revolution/seed_1001/openai_gpt-oss-120b`
  - `random_descriptor_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b`
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

`scripts/validate_pareto_front_run.py` passed for the random descriptor and
all three completed SR-family Pareto archives.

Random:

- valid: `True`
- failure count: `0`
- problem invalid count: `0`
- max front size seen: `3`
- archive members:
  - `Prob045_alu`: 13 members, max front size 2
  - `Prob041_traffic_light`: 8 members, max front size 1
  - `Prob015_multi_pipe_8bit`: 13 members, max front size 3

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

SR raw:

- valid: `True`
- failure count: `0`
- problem invalid count: `0`
- max front size seen: `4`
- archive members:
  - `Prob045_alu`: 16 members, max front size 2
  - `Prob041_traffic_light`: 11 members, max front size 1
  - `Prob015_multi_pipe_8bit`: 17 members, max front size 4

The validator was run without `--acceptance-hard-subset` because that option
currently asserts the manual-BD descriptor profile. The classic-covered design
preservation gate was checked from the run summaries instead: classic has a
valid result for all three problems, and all completed QD arms also have valid
results for all three problems.

## Best-Score And Valid-PPA Comparison

`Best` is the final best PPA score reported by the runner. `Valid-PPA rate` is
the accumulated synthesis-PPA success rate over 48 generated candidates.

| Arm | Problem | Classic best | Method best | Best delta | Classic valid-PPA | Method valid-PPA | Archive members | Global Pareto |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Random | `Prob045_alu` | 0.397675 | 0.403452 | +1.45% | 33.33% | 29.17% | 13 | 1 |
| Random | `Prob041_traffic_light` | 0.414309 | 0.369479 | -10.82% | 62.50% | 16.67% | 8 | 1 |
| Random | `Prob015_multi_pipe_8bit` | 0.212917 | 0.061050 | -71.33% | 41.67% | 31.25% | 13 | 5 |
| SR-RFF | `Prob045_alu` | 0.397675 | 0.395398 | -0.57% | 33.33% | 39.58% | 17 | 1 |
| SR-RFF | `Prob041_traffic_light` | 0.414309 | 0.420875 | +1.58% | 62.50% | 37.50% | 16 | 2 |
| SR-RFF | `Prob015_multi_pipe_8bit` | 0.212917 | 0.072262 | -66.06% | 41.67% | 16.67% | 8 | 6 |
| SR ReLU | `Prob045_alu` | 0.397675 | 0.397589 | -0.02% | 33.33% | 33.33% | 15 | 1 |
| SR ReLU | `Prob041_traffic_light` | 0.414309 | 0.403821 | -2.53% | 62.50% | 35.42% | 17 | 4 |
| SR ReLU | `Prob015_multi_pipe_8bit` | 0.212917 | 0.052795 | -75.20% | 41.67% | 33.33% | 15 | 6 |
| SR raw | `Prob045_alu` | 0.397675 | 0.405031 | +1.85% | 33.33% | 37.50% | 16 | 4 |
| SR raw | `Prob041_traffic_light` | 0.414309 | 0.391093 | -5.60% | 62.50% | 25.00% | 11 | 2 |
| SR raw | `Prob015_multi_pipe_8bit` | 0.212917 | 0.091371 | -57.09% | 41.67% | 39.58% | 17 | 10 |

## Interpretation

The positive evidence is real but narrow:

- All completed QD arms preserve all three classic-covered problems.
- Random improves `Prob045_alu` best score by 1.45%, but loses its valid-PPA
  rate and has little front material.
- SR raw improves `Prob045_alu` best score by 1.85% and improves its valid-PPA
  rate.
- SR-RFF is the only completed QD arm that improves `Prob041_traffic_light`
  best score.
- SR raw has the best completed-QD `Prob015_multi_pipe_8bit` front material:
  17 archive members and 10 global Pareto members.
- The Pareto archive implementation is structurally valid for random and all
  completed SR descriptors.

The blockers are stronger:

- Random loses 71.33% relative best score on `Prob015_multi_pipe_8bit`.
- SR-RFF loses 66.06% relative best score on `Prob015_multi_pipe_8bit`.
- SR ReLU loses 75.20% relative best score on `Prob015_multi_pipe_8bit`.
- SR raw still loses 57.09% relative best score on
  `Prob015_multi_pipe_8bit`, so the raw descriptor does not solve quality
  retention.
- Random synthesis-PPA rate falls from 62.50% to 16.67% on
  `Prob041_traffic_light`, a 73.33% relative drop.
- SR raw synthesis-PPA rate falls from 62.50% to 25.00% on
  `Prob041_traffic_light`, a 60% relative drop.
- The manual BD live arm is not yet run, so no full T24 family-level claim can
  be made from this partial matrix.

## Conclusion

The completed T24 QD arms answer two narrow questions. First, the existing
`pareto_front` cell mode and NSGA-II parent selection can run end to end with
random, SR-RFF, SR ReLU, and SR raw descriptors on the local vLLM endpoint.
Second, the random live control is not stronger than the SR-family arms on this
three-problem screen. It is worse than SR raw on ALU best score and multi-pipe
front material, and worse than SR-RFF on traffic-light best score and valid-PPA
rate.

The paper question is still not answered positively. SR raw sharpens the next
variant: keep its multi-pipe front material and ALU gain, but add
quality/yield-guarded parent pressure or adaptive emitter scheduling so the
search does not sacrifice traffic-light yield and multi-pipe best quality.

The next T24 execution step should run the manual BD arm. Until that lands, T24
stays `pending_live_matrix`.

## Anti-Overclaim Note

This package still does not prove QD/MAP-Elites usefulness for RTL PPA
optimization. It records a measured partial live result and a promotion blocker
that should shape the next archive-coupling variant.
