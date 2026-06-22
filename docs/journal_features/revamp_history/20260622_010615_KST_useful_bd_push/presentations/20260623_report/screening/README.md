# RTLLM Milestone Screening

Run root:
`exp/useful_bd_push/rtllm_milestone_screen_20260622_130747_UTC`

Screened arms:

- `classic_revolution`
- `sr_raw_conservative_exploit_qd`
- `sr_raw_conservative_exploit_low_fusion_qd`
- `sr_raw_conservative_exploit_mid_fusion_qd`

Selection rule:

- Hard gate: preserve classic-covered designs. If classic has at least one
  valid PPA sample, the QD arm must also have at least one.
- Yield drops are reported as warnings, not launch blockers, for this
  deadline milestone.
- Select by final mean PPA hypervolume, then HV-AUC, then front points.

Screen decision:

- Selected full-run arm: `sr_raw_conservative_exploit_qd` exact T26.
- Rationale: exact T26 has a narrow final mean HV edge versus classic on this
  screen and also improves HV-AUC. This is a confirmatory PPA/HV choice, not a
  front-breadth or yield win. Its ALU and multi-pipe valid-PPA drops are yield
  warnings that must stay visible in the report.

Regeneration:

```bash
uv run python scripts/package_rtllm_milestone_screen.py \
  --run-root exp/useful_bd_push/rtllm_milestone_screen_20260622_130747_UTC \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/screening
```

Visual inspection:

- `figures/screen_problem_metrics.png`: readable grouped bars. It shows exact
  T26's traffic-light HV win, low-fusion's HV-AUC strength, and mid-fusion's
  front-point breadth.
- `figures/screen_aggregate_metrics.png`: readable aggregate view. It makes
  the deadline tradeoff clear: exact T26 is the narrow final-HV choice, while
  mid-fusion is the broader-front diagnostic.
