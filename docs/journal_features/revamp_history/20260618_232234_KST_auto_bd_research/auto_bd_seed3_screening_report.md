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

| Method | Gate0 Seeds | Avg Valid | Avg Valid Rate | Avg Fitness | Fitness W/T/L | Avg HV | HV W/T/L | Avg PPA Grid Cells | Avg PPA Grid Cov | Avg Unique Netlists | Avg PPA-Front Netlists | Avg Audit Cells | Avg Audit QD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | 3/3 | 735.0 | 0.4712 | 0.2776 | 0/39/0 | 0.1202 | 0/39/0 | 31.3 | 0.1074 | 323.7 | 54.0 | 39.3 | 8.0494 |
| `landing_smooth_qd_manual_bd` | 3/3 | 797.0 | 0.5109 | 0.2887 | 6/30/3 | 0.1284 | 9/22/8 | 32.7 | 0.1138 | 339.7 | 59.3 | 39.7 | 8.5144 |
| `random_descriptor_qd` | 3/3 | 648.3 | 0.4156 | 0.2764 | 6/28/5 | 0.1154 | 7/21/11 | 32.7 | 0.1078 | 293.0 | 56.0 | 38.0 | 7.8712 |
| `synthesis_trajectory_nod` | 3/3 | 632.0 | 0.4051 | 0.2832 | 5/30/4 | 0.1211 | 7/21/11 | 31.7 | 0.1102 | 284.0 | 58.3 | 39.0 | 8.7738 |
| `sr_random_relu_pca_qd` | 3/3 | 635.3 | 0.4073 | 0.2691 | 4/31/4 | 0.1222 | 8/20/11 | 31.7 | 0.1090 | 300.0 | 58.0 | 38.0 | 8.0503 |

## Screening Interpretation

All five seed-3 arms pass Gate 0 on the 13-problem main subset for all
three seeds. This means the promoted QD arms did not miss any
classic-covered problem at the problem level.

No promoted Auto-BD arm is a clean final-method candidate:

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
- `sr_random_relu_pca_qd` is not the hoped-for recovery from the seed-1
  result. It passes Gate 0, but its average valid-PPA rate is 40.7
  percent versus 47.1 percent for classic and 51.1 percent for landing
  manual-BD. Its average HV is only about 1.6 percent above classic,
  below the predeclared 5 percent seed-3 bar, while average fitness,
  unique canonical netlists, and common-audit cells all trail classic.
  PPA-front unique netlists improve from 54.0 to 58.0 versus classic,
  but that is about 7.4 percent, below the 20 percent target. Its fixed
  PPA-grid coverage is 0.1090 versus 0.1074 for classic, a small gain
  that does not offset the robustness and diversity failures.

## Decision

Do not select ST-NOD or `sr_random_relu_pca_qd` as the final journal
method from seed-3 evidence.

Keep ST-NOD as the hardware-native synthesis-response control. Keep
`sr_random_relu_pca_qd` as a projected AutoQD-style ablation that passes
Gate 0 but does not justify seed-5 final evaluation. The next P5 method,
if compute permits, should be `sr_rff_pca_qd` as a kernel control only
after the fixed PPA-grid coverage evidence is reviewed.
