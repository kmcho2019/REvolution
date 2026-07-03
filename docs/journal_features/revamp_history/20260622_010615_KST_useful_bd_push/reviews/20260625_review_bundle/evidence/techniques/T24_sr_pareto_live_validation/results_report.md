# T24 SR Pareto Live Validation Report

## Status

T24 has a complete live development-screen matrix. The classic baseline,
manual BD, random descriptor, SR-RFF PCA, SR ReLU PCA, and SR raw PCA arms all
completed on the fixed three-problem RTLLM screen.

Tier decision: `T0 diagnostic`.

T24 is not promoted. Every QD arm preserves all three classic-covered designs
and the Pareto-front archive validates structurally, but every QD arm loses too
much best quality on `Prob015_multi_pipe_8bit`. SR raw keeps the strongest
multi-pipe front material and improves ALU best score, while manual BD improves
traffic-light best score. Neither solves the multi-pipe quality-retention
failure.

## Why This Experiment Was Run

T23 showed two complementary synthesis-response leads:

- SR-RFF PCA stayed near classic on final HV/best quality and improved
  common-audit QD/front material.
- SR ReLU PCA had the strongest final-HV and HV-AUC signal.

T24 tested whether those descriptor signals become useful when paired with
bounded local Pareto retention and NSGA-II parent selection. The matrix includes
manual BD and random descriptor controls because positive QD claims must beat
both human-chosen descriptors and arbitrary archive partitioning on the claimed
metric.

## Live Setup

- output root:
  `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/`
- model: `openai/gpt-oss-120b`
- endpoint preflights: `max_model_len=131072`, satisfying the 128000-token
  policy requirement
- seed: `1001`
- population: `12`
- generations: `3`
- generated candidates per problem per arm: `48`
- problems:
  - `RTLLM/Prob045_alu`
  - `RTLLM/Prob041_traffic_light`
  - `RTLLM/Prob015_multi_pipe_8bit`
- completed arms:
  - `classic_revolution/seed_1001/openai_gpt-oss-120b`
  - `landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b`
  - `random_descriptor_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b`
  - `sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b`

## Validator Results

`scripts/validate_pareto_front_run.py` passed for every QD arm.

| Arm | Valid | Failure count | Max front size | Archive members by problem |
| --- | --- | ---: | ---: | --- |
| Manual BD | `True` | 0 | 5 | ALU 18; traffic 21; multi-pipe 14 |
| Random | `True` | 0 | 3 | ALU 13; traffic 8; multi-pipe 13 |
| SR-RFF | `True` | 0 | 4 | ALU 17; traffic 16; multi-pipe 8 |
| SR ReLU | `True` | 0 | 5 | ALU 15; traffic 17; multi-pipe 15 |
| SR raw | `True` | 0 | 4 | ALU 16; traffic 11; multi-pipe 17 |

The validator was run without `--acceptance-hard-subset` for SR-family and
random descriptors because that option currently asserts the manual-BD
descriptor profile. Classic-covered design preservation was checked from the
summary files: classic has a valid result for all three problems, and every QD
arm also has a valid result for all three problems.

## Best-Score And Valid-PPA Comparison

`Best` is the final best PPA score reported by the runner. `Valid-PPA rate` is
the accumulated synthesis-PPA success rate over 48 generated candidates.

| Arm | Problem | Classic best | Method best | Best delta | Classic valid-PPA | Method valid-PPA | Archive members | Global Pareto |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Manual BD | `Prob045_alu` | 0.397675 | 0.401828 | +1.04% | 33.33% | 45.83% | 18 | 1 |
| Manual BD | `Prob041_traffic_light` | 0.414309 | 0.433294 | +4.58% | 62.50% | 54.17% | 21 | 4 |
| Manual BD | `Prob015_multi_pipe_8bit` | 0.212917 | 0.057154 | -73.16% | 41.67% | 31.25% | 14 | 4 |
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

Positive evidence:

- All QD arms preserve all three classic-covered problems.
- Manual BD improves ALU best score by 1.04% and traffic-light best score by
  4.58%, with no 50% relative valid-PPA collapse.
- SR raw improves ALU best score by 1.85% and keeps the strongest multi-pipe
  front material: 17 archive members and 10 global Pareto members.
- SR-RFF is the best SR-family arm on traffic-light best score.
- SR ReLU produces more multi-pipe front material than SR-RFF, but not more
  best quality.
- Random is weaker than SR raw on ALU best score and multi-pipe front material,
  so the SR-family signals are not explained entirely by arbitrary cells.

Promotion blockers:

- Manual BD loses 73.16% relative best score on `Prob015_multi_pipe_8bit`.
- Random loses 71.33% relative best score on `Prob015_multi_pipe_8bit`.
- SR-RFF loses 66.06% relative best score on `Prob015_multi_pipe_8bit`.
- SR ReLU loses 75.20% relative best score on `Prob015_multi_pipe_8bit`.
- SR raw still loses 57.09% relative best score on `Prob015_multi_pipe_8bit`.
- Random traffic-light synthesis-PPA rate falls from 62.50% to 16.67%, a
  73.33% relative drop.
- SR-RFF multi-pipe synthesis-PPA rate falls from 41.67% to 16.67%, a 60.00%
  relative drop.
- SR raw traffic-light synthesis-PPA rate falls from 62.50% to 25.00%, a
  60.00% relative drop.

## Conclusion

T24 answers the immediate archive-coupling question negatively. Local
Pareto-front cells and NSGA-II parent selection run end to end, preserve
classic-covered designs, and expose useful front material, but the unguarded
variant is not a convincing QD/MAP-Elites win for RTL PPA optimization.

The most useful next lead is not a fresh descriptor reset. It is a guarded
archive-coupling variant: keep SR raw's front material and ALU gain, keep
manual BD's traffic-light quality signal as a control, and add quality/yield
guarding or an adaptive exploit/explore/repair emitter so multi-pipe best
quality is not sacrificed.

## Anti-Overclaim Note

This package does not prove QD/MAP-Elites usefulness for RTL PPA optimization.
It records a complete measured live development-screen result and a clear
failure mode for the next T24-derived variant.
