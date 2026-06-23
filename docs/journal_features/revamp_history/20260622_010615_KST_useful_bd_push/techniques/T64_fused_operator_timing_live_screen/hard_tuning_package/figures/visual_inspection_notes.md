# T64 Visual Inspection Notes

Status: inspected after direct supplement and Phase 03.1 screenshots.

- `t64_metric_delta_summary.png` cleanly shows the main conclusion:
  T64 gains valid-PPA yield but loses HV, HV-AUC, and front metrics.
- `t64_hv_delta_heatmap.png` is sparse but readable; the paired HV signal is
  mostly negative on the RTLLM slice.
- `t64_validity_funnel.png` clearly shows the yield improvement and prevents
  mistaking the result for a functionality collapse.
- `t64_front_counts.png` shows the blocker directly: classic keeps more front
  points despite lower valid-PPA yield.
- `t64_operator_counters.png` confirms the configured two-parent counters are
  inactive for this no-fusion ablation.
- `visualizations/direct_ppa_pareto/screenshot.png` is readable as a static
  report page. The raw area-power panels are dense for 13 problems, but the
  summary cards and aggregate figures carry the decision.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the archive compare
  mode without blank canvases or obvious overlap. Playwright reports the same
  rank-guide compare caveat documented for T63.
