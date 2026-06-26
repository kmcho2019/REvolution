# Delayed Archive Activation Probe Report

Status: `diagnostic_negative_not_promoted`.

## Conclusion

`masterrtl_delayed_archive_activation_8x5` should not be promoted to the
final full-RTLLM comparison. It is a useful mechanism result because it is
close to the prior high-exploit auxiliary archive arm and improves front
material relative to that arm, but it remains outside the registered `1-2%`
mean-HV tolerance versus classic.

The result supports a narrower lesson: delaying archive pressure is better
than adaptive sparse-front pressure for this MasterRTL auxiliary family, but
it still does not make the family competitive with classic REvolution under
the frozen `8x5` screen.

## Key Numbers

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `5` |
| `masterrtl_aux_archive_high_exploit_8x5` | `0.1339` | `1.75` | `4.00` | `1` |
| `masterrtl_aux_archive_adaptive_sparse_front_8x5` | `0.0946` | `2.38` | `4.88` | `0` |
| `masterrtl_delayed_archive_activation_8x5` | `0.1324` | `2.00` | `6.00` | `2` |

Delayed activation loses classic by `-5.86%` mean HV:

- classic: `0.1406447841`;
- delayed activation: `0.1323991679`;
- absolute delta: `-0.0082456162`.

Removing `Prob135_m2014_q6b` does not change the conclusion:

- classic no-Prob135 mean HV: `0.1607368961`;
- delayed no-Prob135 mean HV: `0.1513133347`;
- relative delta: about `-5.86%`.

## Per-Problem Read

Delayed activation ties or improves HV on three problems:

- `Prob024_fsm`: `+0.001157`;
- `Prob116_m2014_q3`: tie;
- `Prob153_gshare`: `+0.000664`.

It loses the larger aggregate contributors:

- `Prob041_traffic_light`: `-0.030368`;
- `Prob045_alu`: `-0.025053`;
- `Prob049_signal_generator`: `-0.012365`.

`Prob015_multi_pipe_8bit` and `Prob135_m2014_q6b` have zero HV for both
classic and delayed activation in this analysis.

## Mechanism Check

The delayed mechanism was exercised:

- `16` archive-history rows use `phase="delayed"`;
- `24` rows record `qd_archive_pressure_active=false`;
- `25` rows record `qd_archive_pressure_active=true`;
- logs show delayed generations followed by active archive pressure starting
  at generation `3`.

This is therefore a real timing-mechanism result, not a no-op configuration.

## Interpretation

The delayed arm improves over adaptive sparse-front pressure and restores much
of the high-exploit HV level while increasing front material:

- high-exploit mean HV: `0.1339`;
- delayed mean HV: `0.1324`;
- high-exploit mean Pareto points: `1.75`;
- delayed mean Pareto points: `2.00`;
- high-exploit mean reference-beating candidates: `4.00`;
- delayed mean reference-beating candidates: `6.00`.

However, classic remains better on the headline metrics. The current MasterRTL
auxiliary archive family has now failed fixed high-exploit replication,
front-breadth pressure, depth-only pressure, adaptive sparse-front pressure,
and delayed fixed-generation activation.

The next QD candidate should be materially different. Reasonable next options
are measured stagnation-triggered archive activation, validated MasterRTL
pretrained model-state descriptors, or a different front-preserving archive
coupling that does not pay fixed fill/fail pressure.

## Artifacts

- `tables/delayed_archive_aggregate.csv`
- `tables/delayed_archive_problem_metrics.csv`
- `tables/delayed_vs_classic_problem_deltas.csv`
- `tables/ppa_candidates.csv`
- Completed final-analysis source:
  `exp/useful_bd_push/prelim_delayed_archive_activation_20260626_022126_UTC/live/final_analysis_with_delayed_archive_activation`

## Validation Notes

The live run completed `8/8` problems in `1620.73s`. Both preregistered
validators passed with no output:

- `scripts/validate_pareto_front_run.py`;
- `scripts/validate_single_thought_operator_run.py`.

`scripts/report_final_analysis_bundle.py` was interrupted after more than
`10` minutes in source-aligned design-space feature recovery. Backend
comparison, Pareto analysis, PPA distribution, hard-iteration analysis, and
evolutionary reports had already been written. The promotion decision uses
the completed Pareto and PPA tables, not the interrupted design-space section.
