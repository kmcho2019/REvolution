# T43 Figures

Status: complete and visually inspected.

The first accepted figure is a direct raw area-power PPA Pareto plot with area
on x, power on y, no inverted axes, and lower-left marked as better.

Generated files:

- `t43_raw_area_power_fronts.png`: candidate-level area-power scatter, method
  raw fronts, and pooled raw-front markers.
- `t43_front_count_summary.png`

The front plot shows the conclusion directly: T43 staged gate has no pooled
raw area-power front hits. It broadens the traffic-light method front but does
not recover T41's traffic-light pooled front or T39/T42 multi-pipe signals.

Regenerate figures with `scripts/package_t43_staged_sparse_yield_gate.py`.
