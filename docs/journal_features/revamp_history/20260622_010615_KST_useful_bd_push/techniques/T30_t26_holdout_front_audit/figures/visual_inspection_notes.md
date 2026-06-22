# T30 Visual Inspection Notes

Status: inspected after packaging.

`t30_holdout_ppa_pareto_area_power_candidate_zoom.png` is the clearest direct
PPA-front figure. It uses conventional raw axes, labels both axes as
lower-is-better, and keeps candidates readable without the reference star
stretching the scale. The front markers are visible on all three panels.

`t30_holdout_ppa_pareto_area_power.png` is useful for reference context, but
the reference design stretches the y-axis on P150 and P135. Do not use this
figure alone to judge candidate-front separation.

`t30_holdout_ppa_fronts_improvement.png` is readable and useful for
cross-problem directionality because higher is better on both axes. It should
be paired with the raw candidate-zoom plot so reviewers see the original PPA
units as well as normalized improvement.

`t30_holdout_ppa_fronts_area_power_zoom.png` remains readable, but the
inverted axes make it less straightforward. Keep it as continuity with earlier
T29 packaging, not as the primary figure.

`t30_holdout_live_aggregate.png`, `t30_holdout_problem_counts.png`, and
`t30_holdout_family_counts.png` are legible. The family-count figure correctly
shows the mixed result: front-family count ties classic, but T26 has fewer
front netlists.

Visual conclusion: the new raw candidate-zoom Pareto plot fixes the missing
straightforward PPA-front view. The figures support a conservative reading:
T26 finds a useful P135 tradeoff and preserves all holdout designs, but the
fronts are sparse and do not demonstrate broader illumination than classic.
