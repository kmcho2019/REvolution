# Auxiliary Archive Seed Replication Gate

Status: completed; diagnostic negative, not promoted.

This package tests whether the best diagnostic QD arm,
`masterrtl_aux_archive_high_exploit_8x5`, is robust enough to keep as a
candidate after the periodic review found two problems:

- the result is single-seed;
- the aggregate is heavily influenced by `Prob135_m2014_q6b`.

## Decision

The high-exploit auxiliary archive mechanism should not be promoted to the
final RTLLM comparison in its current fixed form. The three-seed rollup loses
classic on mean hypervolume and remains negative when `Prob135_m2014_q6b` is
removed.

| Slice | Classic mean HV | Aux archive mean HV | Relative delta |
| --- | ---: | ---: | ---: |
| Seeds `1001`-`1003` | `0.1442` | `0.1261` | `-12.51%` |
| Without `Prob135_m2014_q6b` | `0.1648` | `0.1347` | `-18.25%` |

The current preliminary plan is therefore still not finished enough to select
final full-RTLLM QD configs. The next candidate should change the coupling
mechanism, such as adaptive archive pressure, instead of retuning this same
MasterRTL geometry.

## Frozen Arms

| Arm | Seeds | Purpose |
| --- | --- | --- |
| `classic_revolution_8x5` | `1002`, `1003` | Matched classic variance check. |
| `masterrtl_aux_archive_high_exploit_8x5` | `1002`, `1003` | QD variance and robustness check. |

The existing seed `1001` runs remain part of the final three-seed rollup, but
this package launches only the missing seed `1002` and `1003` runs.

## Files

- `preregistration.md`: frozen metrics, gates, and interpretation.
- `commands/run_seed_replication_gate.md`: preflight and launch commands.
- `logs/seed_1002_checkpoint.md`: completed seed `1002` run and validation
  record.
- `logs/seed_1003_and_rollup_checkpoint.md`: completed seed `1003`, final
  validation, and final-analysis package record.
- `seed_replication_rollup_report.md`: three-seed conclusion and artifact map.
- `tables/seed_pair_metrics.csv`: seed-level classic/QD metric pairs.
- `tables/seed_pair_robustness.csv`: all-design, no-Prob135, and RTLLM-only
  robustness slices.
- `figures/`: visually inspected seed-pair, robustness, and problem-delta
  figures.
