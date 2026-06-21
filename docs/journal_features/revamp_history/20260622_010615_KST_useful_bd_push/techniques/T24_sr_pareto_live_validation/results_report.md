# T24 SR Pareto Live Validation Report

## Status

T24 now has a partial live result: the classic baseline arm and the SR-RFF PCA
Pareto-QD arm completed on the fixed three-problem RTLLM screen. The manual BD,
random descriptor, SR raw PCA, and SR ReLU PCA live arms are still pending.

Tier decision: `pending_live_matrix`.

SR-RFF live-arm read: not promoted. It preserves all three classic-covered
problems and validates the local-Pareto archive mechanics, but it loses too
much best quality and valid-PPA rate on `Prob015_multi_pipe_8bit`.

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

`scripts/validate_pareto_front_run.py` passed for the SR-RFF Pareto archives:

- valid: `True`
- failure count: `0`
- problem invalid count: `0`
- max front size seen: `4`
- archive members:
  - `Prob045_alu`: 17 members, max front size 4
  - `Prob041_traffic_light`: 16 members, max front size 2
  - `Prob015_multi_pipe_8bit`: 8 members, max front size 1

The validator was run without `--acceptance-hard-subset` because that option
currently asserts the manual-BD descriptor profile. The classic-covered design
preservation gate was checked from the run summaries instead: classic has a
valid result for all three problems, and SR-RFF also has a valid result for all
three problems.

## Best-Score And Valid-PPA Comparison

`Best` is the final best PPA score reported by the runner. `Valid-PPA rate` is
the accumulated synthesis-PPA success rate over 48 generated candidates.

| Problem | Classic best | SR-RFF best | Best delta | Classic valid-PPA | SR-RFF valid-PPA | SR-RFF archive members | SR-RFF global Pareto |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `Prob045_alu` | 0.397675 | 0.395398 | -0.57% | 33.33% | 39.58% | 17 | 1 |
| `Prob041_traffic_light` | 0.414309 | 0.420875 | +1.58% | 62.50% | 37.50% | 16 | 2 |
| `Prob015_multi_pipe_8bit` | 0.212917 | 0.072262 | -66.06% | 41.67% | 16.67% | 8 | 6 |

## Interpretation

The positive evidence is narrow:

- SR-RFF preserves all three classic-covered problems on this screen.
- SR-RFF slightly improves `Prob041_traffic_light` best score.
- SR-RFF improves `Prob045_alu` valid-PPA rate while staying within 1% best
  score of classic.
- The Pareto archive implementation is structurally valid and retains useful
  local-front material.

The blockers are stronger:

- `Prob015_multi_pipe_8bit` loses 66.06% relative best score.
- `Prob015_multi_pipe_8bit` valid-PPA rate falls from 41.67% to 16.67%, a
  60% relative drop. Since classic produced 20 valid-PPA samples, this is not
  a small-denominator artifact.
- `Prob041_traffic_light` improves best score but valid-PPA rate falls by
  40% relative.
- The random descriptor, manual BD, SR raw PCA, and SR ReLU live arms are not
  yet run, so no QD usefulness claim can be made from this partial matrix.

## Conclusion

The first T24 live arm answers one narrow question: the existing
`pareto_front` cell mode and NSGA-II parent selection can run end to end with
SR-RFF descriptors on the local vLLM endpoint. It does not answer the paper
question positively yet. SR-RFF local-Pareto live sampling is a useful
diagnostic, but not a promoted BD technique under the current gate.

The next T24 decision should run either the SR ReLU PCA arm, because T19 had
the strongest replay HV signal, or a quality-safer SR-RFF variant that protects
per-problem valid-PPA yield before spending budget on a larger live matrix.

## Anti-Overclaim Note

This package still does not prove QD/MAP-Elites usefulness for RTL PPA
optimization. It records a measured partial live result and a promotion
blocker that should shape the next archive-coupling variant.
