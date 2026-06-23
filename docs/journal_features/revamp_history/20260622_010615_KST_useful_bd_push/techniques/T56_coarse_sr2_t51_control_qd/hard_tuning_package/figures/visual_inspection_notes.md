# T56 Coarse SR2 T51-Control QD Visual Inspection Notes

Status: visually inspected.

- `t56_hv_delta_heatmap.png` should expose seed/problem HV wins
  and losses without hiding paired failures. It is readable, with isolated
  T56 wins but a clear negative aggregate.
- `t56_metric_delta_summary.png` should show whether the method
  wins through HV/front material or only through best score. It clearly shows
  a best-score gain with HV, HV-AUC, valid-PPA, and front losses.
- `t56_validity_funnel.png` should make yield collapse visible.
  It clearly shows lower functional and valid-PPA totals.
- `t56_operator_counters.png` should show whether the
  configured counters are active or degenerate. It is intentionally empty
  because T56 disables success-parent and two-parent lanes.
- `t56_direct_ppa_fronts_seed*.png` should make raw area-power
  distribution differences easy to inspect by problem. The panels are compact
  but readable enough for this 13-problem screen.

The direct HTML supplement screenshot was also inspected and is readable. The
full Phase 03.1 screenshot is nonblank and shows classic projection beside
T56's two-axis archive slab.
