# T87 Visual Inspection Notes

Inspected:

- `figures/t87_smoke_summary.png`: clear and presentation-usable for the
  headline smoke comparison.
- `figures/shape_density_prob045_gain_power_vs_area.png`: readable diagnostic
  PPA panel; shows T87 improving over SR/random on `Prob045_alu` while still
  trailing classic.
- `figures/shape_density_prob041_gain_power_vs_area.png`: readable diagnostic
  PPA panel; shows the main T87 failure case.
- `analysis/shape_density_pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png`:
  useful as a diagnostic plot, but not presentation-ready because the
  auto-generated legend/title overlaps with long backend names.

Conclusion: use the summary chart and direct PPA panels in reports. Treat the
generated pairwise Pareto fronts as raw diagnostic artifacts unless labels are
shortened in a future plotting pass.
