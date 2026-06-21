# T27 T26 Live QD Audit Methodology

Status: completed live audit package for the T26 active lead.

## Purpose

T27 is not a new behavior descriptor. It is the audit package requested after
`T26_sr_raw_conservative_exploit_qd` recovered best-quality pressure on the
three-problem live development screen. The purpose is to test whether the T26
signal also appears in QD-facing live metrics such as PPA hypervolume,
hypervolume AUC, PPA-front material, active archive coverage, and front spread.

## Source Runs

The audit reads already-completed live runs under `exp/useful_bd_push/`:

| Source | Methods |
| --- | --- |
| `t24_sr_pareto_live_validation_20260621_184346_UTC` | Classic, manual BD, random descriptor, SR raw PCA QD. |
| `t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC` | Guarded SR raw Pareto QD. |
| `t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC` | Conservative exploit SR raw QD. |

All rows use the same fixed three-problem development screen:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

## Algorithm

`scripts/package_t27_t26_live_qd_audit.py` reads each problem's live
`generation_log.jsonl`, summary JSON, archive summary, global Pareto summary,
and archive history when those files exist. It then computes:

- final valid-PPA count and rate;
- final best PPA score;
- global PPA hypervolume from the nondominated live candidates;
- hypervolume AUC over generations;
- final PPA-front point count;
- count of candidates that beat the reference PPA tuple on at least one axis;
- unique PPA improvement tuples as a proxy duplicate metric;
- mean nearest-neighbor distance inside the final PPA front;
- PPA-front bounding-box volume;
- active archive coverage, QD score, member count, and Pareto-member count for
  QD methods with archive summaries.

The audit uses only post-generation PPA information. It does not change any
in-loop behavior descriptor, archive rule, parent sampler, or live candidate.

## Leakage Policy

The T26 method itself used SR raw PCA descriptor values and local Pareto archive
mechanics without PPA in the descriptor. T27 uses PPA metrics only after the
run has completed for evaluation. The audit must therefore be cited as
post-hoc validation evidence, not as a descriptor definition.

## Limitations

The live logs do not expose canonical netlist hashes, motif-family hashes, or a
common passive descriptor archive for all compared methods. T27 therefore
cannot satisfy the final unique-implementation-family gate. It reports unique
PPA tuples only as a rough duplicate proxy, and it keeps canonical duplicate
accounting as a required follow-up.

T27 also remains a development-screen audit. It does not replace holdout or
multi-seed confirmation.

## Reproducibility

Run command:

`commands/package_audit.md`

Generated tables:

`tables/live_qd_problem_metrics.csv`

`tables/live_qd_aggregate_metrics.csv`

`tables/live_qd_comparison_deltas.csv`

`tables/live_qd_method_manifest.csv`

Generated figures:

`figures/live_qd_problem_metrics.png`

`figures/live_qd_aggregate_metrics.png`
