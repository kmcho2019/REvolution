# T42 Figures

Status: complete and visually inspected.

Primary figure:

- `t42_raw_area_power_fronts.png` shows the direct raw area-power Pareto fronts
  for T42 Classic, T42 initial gate, T41 adaptive gate, T40 controls, and T39.
  Area is on x, power is on y, axes are not inverted, and lower-left is better.

Supporting figure:

- `t42_front_count_summary.png` summarizes valid-PPA counts and pooled raw
  area-power front hits by problem and method.

Regenerate both with `scripts/package_t42_initial_sparse_yield_gate.py`.
