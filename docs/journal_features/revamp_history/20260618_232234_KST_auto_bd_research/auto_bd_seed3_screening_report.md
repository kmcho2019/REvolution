# Auto-BD Seed-3 Screening Report

Status: generated from completed main-screening standard-results
artifacts for seeds 1001, 1002, and 1003.

## Report Artifacts

| Seed | Markdown | JSON | Figures |
| --- | --- | --- | --- |
| 1001 | `auto_bd_seed3_seed1001_centralized_report.md` | `auto_bd_seed3_seed1001_centralized_report.json` | `figures/seed3_seed1001/` |
| 1002 | `auto_bd_seed3_seed1002_centralized_report.md` | `auto_bd_seed3_seed1002_centralized_report.json` | `figures/seed3_seed1002/` |
| 1003 | `auto_bd_seed3_seed1003_centralized_report.md` | `auto_bd_seed3_seed1003_centralized_report.json` | `figures/seed3_seed1003/` |

## Aggregate Screening Table

| Method | Gate0 Seeds | Avg Valid | Avg Valid Rate | Avg Fitness | Fitness W/T/L | Avg HV | HV W/T/L | Avg Unique Netlists | Avg PPA-Front Netlists | Avg Audit Cells | Avg Audit QD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | 3/3 | 735.0 | 0.4712 | 0.2776 | 0/39/0 | 0.1202 | 0/39/0 | 323.7 | 54.0 | 39.3 | 8.0494 |
| `landing_smooth_qd_manual_bd` | 3/3 | 797.0 | 0.5109 | 0.2887 | 6/30/3 | 0.1284 | 9/22/8 | 339.7 | 59.3 | 39.7 | 8.5144 |
| `random_descriptor_qd` | 3/3 | 648.3 | 0.4156 | 0.2764 | 6/28/5 | 0.1154 | 7/21/11 | 293.0 | 56.0 | 38.0 | 7.8712 |
| `synthesis_trajectory_nod` | 3/3 | 632.0 | 0.4051 | 0.2832 | 5/30/4 | 0.1211 | 7/21/11 | 284.0 | 58.3 | 39.0 | 8.7738 |

## Screening Interpretation

All four seed-3 arms pass Gate 0 on the 13-problem main subset for all
three seeds. This means the promoted QD arms did not miss any
classic-covered problem at the problem level.

Neither promoted Auto-BD arm is a clean final-method candidate:

- `random_descriptor_qd` remains useful as a control but has lower
  valid-PPA rate, mean HV, unique netlists, and audit QD than the landing
  manual-BD baseline.
- `synthesis_trajectory_nod` has the best average common-audit QD score
  and slightly improves average HV over classic REvolution, but its
  average valid-PPA rate is 40.5 percent versus 47.1 percent for classic
  and 51.1 percent for landing manual-BD.
- ST-NOD therefore fails the robustness bar for final selection even
  though it remains a useful synthesis-response control and provides the
  best current evidence that hardware-native synthesis descriptors can
  organize archives differently.

## Decision

Do not select ST-NOD as the final journal method from seed-3 evidence.
Keep it as a baseline/control for synthesis-response descriptors and move
to the P5 projected method family:
`04_synthesis_response_kernel_pca/`.

The next candidate should be `sr_raw_pca_qd` followed by
`sr_random_relu_pca_qd`, with frozen fitting artifacts and no PPA,
fitness, hypervolume, testbench pass-rate, reference PPA, or problem-ID
descriptor leakage.
