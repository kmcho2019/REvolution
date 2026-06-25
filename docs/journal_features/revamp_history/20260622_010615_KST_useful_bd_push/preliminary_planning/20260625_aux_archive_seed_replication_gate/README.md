# Auxiliary Archive Seed Replication Gate

Status: preregistered, not run.

This package tests whether the best diagnostic QD arm,
`masterrtl_aux_archive_high_exploit_8x5`, is robust enough to keep as a
candidate after the periodic review found two problems:

- the result is single-seed;
- the aggregate is heavily influenced by `Prob135_m2014_q6b`.

## Decision

The current plan is not finished enough to select final full-RTLLM QD configs.
This gate must run before any final RTLLM spend based on the auxiliary archive
mechanism.

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
