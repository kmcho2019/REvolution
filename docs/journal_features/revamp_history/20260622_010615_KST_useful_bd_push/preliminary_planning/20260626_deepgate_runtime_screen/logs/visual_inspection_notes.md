# T94 Visual Inspection Notes

Representative figures were inspected before recording the selection status.

## Pareto Figures

- `analysis/pareto_analysis/problems/RTLLM/Prob024_fsm/pairwise_fronts.png`
  is readable and shows the slight DeepGate HV win, but the auto-generated
  title and legend overlap at the top. Keep it as diagnostic evidence, not as
  a final presentation slide without relabeling.
- `analysis/pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png`
  clearly shows the main DeepGate loss: classic owns the stronger
  area-improvement front segment while DeepGate is restricted to a narrower
  vertical tradeoff. It has the same title/legend overlap issue.

## Direct PPA Distribution Figures

- `analysis/ppa_distribution/figures/all_backends/RTLLM/Prob045_alu/gain/power_vs_area.png`
  is cleaner and useful for explaining the front-breadth loss. Both methods
  reach high power gain, but classic has more candidates and a wider area-gain
  range.

## Presentation Read

Use the direct PPA distribution plots for colleague-facing discussion. Use the
auto-generated Pareto figures as backup evidence unless they are regenerated
with shorter titles and legend placement.
