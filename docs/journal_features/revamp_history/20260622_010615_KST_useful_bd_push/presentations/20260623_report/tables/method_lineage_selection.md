# Method Lineage Selection

Status: pending screening.

## Current Default

Exact T26, `sr_raw_conservative_exploit_qd`, is the confirmatory fallback
because it is already audited by T26/T27/T28/T30. It supports a `T1
near_classic` read, not a `T2 useful_qd` claim, because T28 reports weaker
front-family breadth than classic.

## Candidate Screening Arms

| Arm | Role | Selection Status |
| --- | --- | --- |
| Exact T26 | Confirmatory fallback. | Selected unless a screened variant clearly improves without code or yield risk. |
| T26.1 low-fusion | Exploratory low two-parent fusion. | Pending screen. |
| T26.1 gated fusion | Exploratory only after narrow implementation and tests. | Not eligible until implemented and reviewed. |

## Required Before Full RTLLM

- Fill screening metric rows.
- Record exact QD arm chosen for the full run.
- Record why alternatives were rejected.
- Save adversarial pre-launch review after selection and before launch.
