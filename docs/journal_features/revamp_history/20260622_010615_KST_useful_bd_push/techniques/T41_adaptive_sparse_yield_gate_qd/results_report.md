# T41 Results Report

Status: pending live run.

Tier decision: pending.

T41 is the adaptive sparse-yield gate that follows T40. It keeps the stricter
primary grid-quantile warmup threshold of `8`, but allows archive activation
after generation `1` when a problem has at least `4` buffered valid PPA
samples and descriptor geometry is ready.

The first accepted result figure must be
`figures/t41_raw_area_power_fronts.png`: a direct raw area-power PPA Pareto
comparison against the matched T41 classic arm, frozen T40
manual/random/full-Pareto controls, and the frozen T39 one-slot arm. Use area
on x, power on y, no inverted axes, and lower-left marked as better.

Do not assign `T1` or higher until the report includes validator output,
direct-front figures, valid-PPA counts, pooled-front hits, and visual
inspection notes.
