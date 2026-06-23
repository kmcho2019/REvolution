# T50 Candidate-Matched Thought Front Visual Inspection Notes

Status: manually inspected after Playwright screenshot capture.

- `t50_hv_delta_heatmap.png` should expose seed/problem HV wins
  and losses without hiding paired failures.
- `t50_metric_delta_summary.png` should show whether the method
  wins through HV/front material or only through best score.
- `t50_validity_funnel.png` should make yield collapse visible.
- `t50_operator_counters.png` should show whether the
  configured counters are active or degenerate.
- `t50_direct_ppa_fronts_seed*.png` should make raw area-power
  distribution differences easy to inspect by problem.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without text
  overlap and makes the diagnostic result easy to read.
- The figures are suitable for documenting the negative T50 decision: the
  best-score bar is positive, but HV, HV-AUC, valid PPA, and front coverage
  are visibly negative.
