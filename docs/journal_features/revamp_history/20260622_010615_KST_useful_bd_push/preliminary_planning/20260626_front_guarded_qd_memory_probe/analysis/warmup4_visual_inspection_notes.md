# Warmup-4 Visual Inspection Notes

Checked after generating:

- `analysis/warmup4_ppa_distribution/figures/classic_vs/fg_qdm_sr_memory_warmup4_12x3/RTLLM/Prob045_alu/gain/power_vs_area.png`
- `analysis/warmup4_ppa_distribution/figures/classic_vs/fg_qdm_sr_memory_warmup4_12x3/RTLLM/Prob015_multi_pipe_8bit/gain/power_vs_effective_clock_period.png`

## Readability

The figures are readable enough for preliminary-planning evidence. They use
shared axes, show the reference point with a red star, and make the classic-vs
FG-QDM candidate counts visible in the panel titles.

## Interpretation

`Prob045_alu` makes the main result clear: FG-QDM has more Pareto points in the
formal table, but classic reaches a higher area-gain range at roughly the same
power-gain range.

`Prob015_multi_pipe_8bit` explains why the scalar-score improvement is not a
promotion signal. FG-QDM finds a narrower region with negative timing gain,
while classic preserves a broader tradeoff front.

## Limitation

The auto-generated titles are long because the backend slug is long. They are
acceptable for internal screening, but any presentation slide should use a
shorter display label such as `FG-QDM`.
