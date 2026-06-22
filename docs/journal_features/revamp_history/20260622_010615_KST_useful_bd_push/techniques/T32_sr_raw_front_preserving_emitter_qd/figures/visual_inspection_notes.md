# T32 Visual Inspection Notes

Status: inspected after packaging.

`t32_holdout_ppa_pareto_area_power_candidate_zoom.png` is the primary front
figure. It uses conventional raw axes, labels area and power as lower-is
better, and marks each method's rank-1 front with open circles. The plot is
readable and shows the negative result directly: T32 mostly overlaps the T31
points, improves P098 yield only as a count, and does not recover T26's P135
low-area/low-power point.

`t32_holdout_ppa_pareto_area_power.png` is useful context because it includes
reference stars, but the candidate-only zoom should remain the first
reader-facing front figure.

`t32_holdout_ppa_fronts_improvement.png` is readable as a normalized support
view. It shows T32 matching the P150/P098 coarse points but falling behind
T26 on the P135 improvement point that created T30's holdout HV signal.

`t32_holdout_problem_counts.png` is readable after the dynamic bar-width
update. It makes the P098 valid-PPA improvement visible: T32 has 19 P098 valid
PPA samples versus T26's 15 and T31's 14. The same plot also shows T32 has no
P135 reference-beating candidate.

`t32_holdout_live_aggregate.png` and `t32_holdout_family_counts.png` are
legible. They support the same conclusion: T32 improves some count/breadth
proxies versus T31, but only T26 has positive mean HV/HV-AUC.

Visual conclusion: the figures support `T0 diagnostic`. T32 is a useful
ablation because it shows the small near-front success-parent lane can recover
some P098 yield and unique PPA breadth, but it does not preserve the T26
P135 quality/HV signal and does not visibly widen the useful raw PPA front.
