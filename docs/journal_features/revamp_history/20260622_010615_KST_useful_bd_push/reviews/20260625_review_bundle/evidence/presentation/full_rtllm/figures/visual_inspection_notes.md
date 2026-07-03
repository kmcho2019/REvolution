# Full RTLLM Figure Inspection Notes

Inspection date: 2026-06-22 UTC.

## Summary

The generated figures are usable for the milestone report. They are readable
and convey the main result, but the presentation should state that the positive
aggregate HV/HV-AUC result is outlier-sensitive and that QD loses valid-PPA
yield.

## Figure Notes

`full_representative_ppa_fronts.png`:
the selected panels are populated for both methods after replacing empty
representatives with `Prob027_LIFObuffer`, `Prob009_div_16bit`, and
`Prob043_RAM`. The figure is useful for showing direct raw area-power fronts.

`full_hv_delta_distribution.png`:
the histogram is readable. It makes clear that the mean is pulled positive by a
large QD-side outlier. Use with the text caveat that per-problem HV has 4 QD
wins, 15 losses, and 31 ties.

`full_hv_auc_delta_distribution.png`:
readable and consistent with the HV plot. Use with the caveat that per-problem
HV-AUC has 5 QD wins, 16 losses, and 29 ties.

`full_hv_scatter.png`:
readable. The diagonal comparison is clear, and `Prob040_synchronizer` appears
as the large QD-only outlier. Do not use this plot without the outlier caveat.

`full_win_loss_heatmap.png`:
dense but usable. It is best for showing mixed per-problem evidence rather than
for precise values. Pair it with tables for exact numbers.

`full_validity_funnel.png`:
clear and presentation-ready. It shows QD has slightly more functional
candidates but fewer valid-PPA candidates.

`full_front_counts.png`:
readable and useful for the front-count claim. It shows QD's total front-count
edge is uneven across problems.

## Presentation Guidance

Use the funnel, front-count, HV scatter, and representative PPA fronts in the
main presentation. Keep the delta histograms in the backup or report unless the
speaker has time to explain outlier sensitivity carefully.
