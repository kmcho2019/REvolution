# T31 Visual Inspection Notes

Status: inspected after packaging.

`t31_holdout_ppa_pareto_area_power_candidate_zoom.png` is the primary front
figure. It uses conventional raw axes, labels area and power as lower-is
better, and marks each method's rank-1 front with open circles. The figure is
readable and makes the negative result visible: T31 mostly overlaps the sparse
P098 point, does not recover T26's P135 low-power/low-area point, and does not
broaden the front.

`t31_holdout_ppa_pareto_area_power.png` is useful context because it includes
the reference stars. The reference stretches the P150 and P135 power axes, so
the candidate-only zoom should be used for front-shape judgment.

`t31_holdout_ppa_fronts_improvement.png` is readable as a normalized support
view. It shows T31 matching the P150/P098 coarse points but falling behind T26
on the P135 improvement signal that created T30's positive HV.

`t31_holdout_live_aggregate.png`, `t31_holdout_problem_counts.png`, and
`t31_holdout_family_counts.png` are legible. The aggregate plot correctly
shows that only T26 has positive mean HV/HV-AUC on this holdout. The counts
plot shows T31's P098 valid-PPA count is still low, and the family plot shows
no front-netlist recovery versus T26.

Visual conclusion: the figures support `T0 diagnostic`. T31 preserves a
passing final-best result on all three holdout designs, but it does not repair
P098 yield, does not preserve the P135 quality/HV signal, and does not widen
the raw PPA Pareto front.
