# T29 Visual Inspection Notes

Status: inspected after packaging.

## Direct PPA-Front Figures

`t29_ppa_fronts_area_power_zoom.png` is readable. The legend is not crowded,
problem panels are separated, and open circles clearly mark each method's
candidate-level rank-1 PPA front. The axis labels explicitly state that raw
area and power are lower-is-better but inverted, so the visual direction is
up/right-is-better.

`t29_ppa_fronts_improvement.png` is also readable and gives the clearest
cross-problem directionality because both axes are higher-is-better. The
`Prob015_multi_pipe_8bit` panel honestly notes that the active front is based
on area, power, and effective clock period even though the scatter shows only
area and power.

## Count And Aggregate Figures

`t29_live_problem_front_counts.png` is the most direct failure summary. It
shows T29 with two multi-pipe front points and six valid multi-pipe PPA
samples, below classic, SR raw, and T26.

`t29_live_aggregate_metrics.png` is readable but should not be used alone:
T29's mean final best score is based on only two solved problems. The report
therefore emphasizes final-best problem count, HV/HV-AUC, direct fronts, and
multi-pipe valid-PPA coverage.

`t29_family_aggregate_counts.png` is readable and shows that T29's front
families are not duplicate collapse, but the total front-family count remains
well below classic and SR raw.

No label overlap, clipped text, or broken image artifacts were observed.
