# T48 Visual Inspection Notes

Status: manually inspected after regeneration.

- `t48_hv_delta_heatmap.png` should expose seed/problem HV wins
  and losses without hiding paired failures.
- `t48_metric_delta_summary.png` should show whether the method
  wins through HV/front material or only through best score.
- `t48_validity_funnel.png` should make yield collapse visible.
- `t48_gate_counters.png` should show whether the gate is actually
  participating or mostly falling back.
- `t48_direct_ppa_fronts_seed*.png` should make raw area-power
  distribution differences easy to inspect by problem.

Inspection notes:

- The aggregate metric summary is consistent with the CSV deltas: T48 is
  positive only on mean best score and negative on HV, HV-AUC, valid-PPA
  count, and front count.
- The direct area-power panels have readable titles, legend, and shared axes.
  The empty grid cells are unused subplot slots, not missing problems.
- The heatmap is readable but has many white cells because several
  problem/seed pairs have tied or zero HV.
