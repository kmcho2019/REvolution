# MasterRTL RF Timing Live Smoke

Status: live smoke passed; superseded by completed frozen `8x5` screen.

This package records the first live run that uses the
`source_aligned_rf_timing_state_3d` descriptor profile from T82.

Update: the follow-up screen is complete in
`../20260626_masterrtl_rf_timing_state_screen/`, and the exact profile is not
promoted as-is.

## Run

- run root:
  `exp/useful_bd_push/rf_timing_live_smoke_20260626_0435_UTC/`
- mode:
  `qd_rf_timing_state_2x0_prob015/seed_1001/openai_gpt-oss-120b`
- benchmark/problem: `RTLLM/Prob015_multi_pipe_8bit`
- budget: `population_size=2`, `num_generations=0`
- model: `openai/gpt-oss-120b`
- endpoint preflight: passed with `max_model_len=131072`

## Result

The smoke produced one valid PPA candidate and one archive member. The
candidate-level archive event includes RF timing graph metrics and descriptor
values:

| Metric | Value |
| --- | ---: |
| Valid PPA candidates | `1` |
| Archive members | `1` |
| Global Pareto members | `1` |
| RF timing paths | `51` |
| RF timing unique leaf rows | `17` |
| RF timing unique leaf IDs | `319` |
| RF no-path flag | `0` |

The archive validator passed on the one-problem subset. Because this is only a
single archive observation, descriptor-health reports all axes as collapsed by
sample size. Use T81's offline generated-candidate gate for non-collapse
evidence, not this smoke.

## Decision

This clears the live-smoke blocker. It does not justify a full RTLLM run.
The next gate is the frozen eight-design `8x5` screen with the same
reference-complete and validity-accounting rules used for prior preliminary
arms.
