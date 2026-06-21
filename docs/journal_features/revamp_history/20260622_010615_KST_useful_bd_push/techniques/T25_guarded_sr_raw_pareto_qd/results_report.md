# T25 Guarded SR Raw Pareto QD Results Report

Status: completed live development-screen run.

Tier decision: `T0 diagnostic`.

## Question

Can the SR raw descriptor keep its T24 ALU gain and multi-pipe front material
while a guarded schedule reduces the multi-pipe best-quality collapse and
traffic-light synthesis-validity drop?

## Run Summary

- Run root:
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/`.
- Model endpoint: `http://20.0.0.103:8000/v1/models`.
- Model: `openai/gpt-oss-120b`, `max_model_len=131072`.
- Token budgets: `max_tokens=128000`, `diff_max_tokens=128000`.
- Budget: seed 1001, population 12, three generations, strict ablation
  evaluation, same three-problem T24 development screen.
- Runtime: 750.54 seconds.
- Scheduler guard:
  `qd_fill_target_fraction=0.10`,
  `qd_improve_backfill_fraction=0.05`,
  `qd_two_parent_probability=0.25`,
  `qd_champion_lane_fraction=0.50`.

## Comparators

T25 is compared against the completed T24 rows:

- classic REvolution;
- landing Smooth-QD/manual BD;
- random descriptor QD;
- unguarded SR raw Pareto QD.

Primary table:
`tables/live_guarded_vs_t24_controls.csv`.

Primary figure:
`figures/live_guarded_vs_t24_controls.png`.

Pareto archive validation:
`tables/live_guarded_pareto_validation.{json,md}`.

## Key Results

| Problem | T25 best delta vs classic | T25 valid-PPA delta vs classic | T25 archive members | T25 global Pareto members |
| --- | ---: | ---: | ---: | ---: |
| `Prob045_alu` | +1.23% | +4.17 points | 16 | 2 |
| `Prob041_traffic_light` | -3.48% | -43.75 points | 8 | 2 |
| `Prob015_multi_pipe_8bit` | -75.20% | -12.50 points | 13 | 6 |

T25 preserves all three classic-covered designs and the Pareto archive
validator passes with zero failures. The archive has 16 members on ALU, 8 on
traffic light, and 13 on multi-pipe, with max local front size 2.

## Comparison To SR Raw

The guard did not improve the failure it was designed to fix.

- ALU best score remains positive versus classic (+1.23%), but is slightly
  below unguarded SR raw.
- Traffic-light best score improves over unguarded SR raw by 0.008806 absolute
  score, but valid-PPA count falls to 9 versus classic's 30, a 70% relative
  drop with a large denominator.
- Multi-pipe front material remains nontrivial at 6 global Pareto members, but
  unguarded SR raw retained 10 and had a much better best score. T25 falls to
  -75.20% relative best-score delta versus classic, worse than SR raw's
  -57.09%.

## Conclusion

T25 is a useful negative diagnostic, not a promotion candidate. Lowering the
improve-phase backfill and two-parent fusion did not recover quality/yield; it
reduced multi-pipe front material relative to SR raw and worsened the
multi-pipe best-score collapse. The traffic-light valid-PPA regression also
fails the promotion gate because the classic denominator is 30 passing samples.

Next iteration should not keep tuning this exact guard alone. The follow-up
should add an explicit exploit/explore/repair emitter schedule or a
quality-preserving parent source that can keep SR raw front material while
recovering best quality.
