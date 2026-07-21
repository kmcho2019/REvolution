# Classic Feedback Contract Audit

This audit covers 4,800 candidates from 100 fresh classic full-suite logs.

## Contract Results

| Status | Compliant | Mismatch | Undefined |
| --- | ---: | ---: | ---: |
| `success` | 2063 | 4 | 0 |
| `failed_format` | 2 | 1 | 0 |
| `failed_syntax` | 510 | 416 | 0 |
| `failed_functionality` | 1110 | 270 | 0 |
| `failed_synthesis` | 0 | 0 | 5 |
| `failed_synthesis_functionality` | 0 | 0 | 419 |

The clear failure statuses disagree with the critic score contract in 687/2309 cases (29.75%). Functional failures include 215 false score-10 records. Success disagrees in 4/2067 cases.

## Selected Failed Parents

| Run | Parent contract | Children | Valid PPA | Rate |
| --- | --- | ---: | ---: | ---: |
| 1001 | compliant | 478 | 23 | 4.81% |
| 1001 | mismatch | 218 | 10 | 4.59% |
| 1001 | undefined | 141 | 3 | 2.13% |
| 1002 | compliant | 494 | 26 | 5.26% |
| 1002 | mismatch | 197 | 6 | 3.05% |
| 1002 | undefined | 130 | 5 | 3.85% |

Contract disagreement is premise evidence only. It is not a causal
estimate of repair quality, and the critic score is not consumed by
classic parent prompts.

## Reproduction

```bash
uv run python scripts/report_revolution_feedback_contract.py \
  --run 1001=/workspace/exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe/seed_1001/classic \
  --run 1002=/workspace/exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/full_suite_probe/seed_1002/classic \
  --output-dir /workspace/docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/shared/verified_status_feedback_premise
```
