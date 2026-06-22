# Method Lineage Selection

Status: screened. Exact T26 is selected for the full one-seed RTLLM run.

## Current Default

Exact T26, `sr_raw_conservative_exploit_qd`, is the selected confirmatory arm
because it is already audited by T26/T27/T28/T30 and is the only screened QD
arm with positive final mean HV versus classic. It supports a PPA/HV
usefulness test, not a front-family diversity claim, because T28 reports
weaker front-family breadth than classic.

## Candidate Screening Arms

| Arm | Role | Selection Status |
| --- | --- | --- |
| Exact T26 | Confirmatory PPA/HV arm. | Selected for full RTLLM. |
| T26.1 low-fusion | Exploratory low two-parent fusion. | Rejected for full run: better HV-AUC/yield, but final mean HV loses to classic. |
| T26.1 mid-fusion | Exploratory 0.05 two-parent fusion. | Rejected for full run: better front points, but final mean HV loses to classic. |
| T26.1 gated fusion | Exploratory only after narrow implementation and tests. | Omitted from deadline screen; not implemented. |

## Required Before Full RTLLM

- Save adversarial pre-launch review after selection and before launch.
- Keep exact T26 yield warnings visible in the report and slides.
