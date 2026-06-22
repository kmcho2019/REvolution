# T45 Results Report

Status: complete live screen; `T0 mixed_diagnostic`.

## Question

T44 showed that top-8 T11 runtime graph axes have real traffic-light and
multi-pipe signal, but the archive was too sparse and valid-PPA yield dropped
too far. T45 asks whether the first four ranked graph axes keep that signal
while reducing yield loss.

## Definitions

- Raw PPA point: one candidate with valid synthesized area and power.
- Method raw front: nondominated raw area-power points within one method for
  one problem. Lower area and lower power are better.
- Pooled raw front: nondominated raw area-power points after pooling all
  compared methods for one problem.
- Hypervolume: normalized PPA dominated volume from the final-analysis Pareto
  report. Higher is better.
- Valid-PPA yield gate: a 50 percent or larger relative drop is a promotion
  blocker when matched classic has at least 10 passing samples.

## Evidence

- Runtime root:
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC/`.
- vLLM preflight: `openai/gpt-oss-120b` served with `max_model_len=131072`.
- Matched arms: `classic_revolution` ran in 595 seconds;
  `t11_runtime_top4_graph_qd` ran in 718 seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Full viewer validation:
  `visualizations/qd_ppa_viewer/validation.json` reports `passed` with zero
  errors after strict schema/control validation and Playwright smoke.
- Direct raw-PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Primary raw PPA figure:
  `figures/t45_raw_area_power_fronts.png`.
- Regeneration data:
  `tables/t45_candidate_ppa_points.csv`,
  `tables/t45_problem_method_summary.csv`, and
  `visualizations/qd_ppa_viewer_source/final_analysis/`.

## Direct Raw PPA Results

| Method | Problem | Valid PPA | Method raw front | Pooled raw front | Best score |
| --- | --- | ---: | ---: | ---: | ---: |
| Classic | Prob045_alu | 18 | 2 | 2 | 0.407418 |
| T45 T11 top-4 | Prob045_alu | 13 | 2 | 0 | 0.406625 |
| Classic | Prob041_traffic_light | 24 | 4 | 2 | 0.450848 |
| T45 T11 top-4 | Prob041_traffic_light | 17 | 2 | 1 | 0.420875 |
| Classic | Prob015_multi_pipe_8bit | 19 | 3 | 0 | 0.145536 |
| T45 T11 top-4 | Prob015_multi_pipe_8bit | 11 | 2 | 0 | 0.070951 |

T45 preserves all three classic-covered designs. It also avoids the 50 percent
valid-PPA yield-warning threshold on this screen: valid PPA drops from `61` to
`41` total samples, with per-problem drops of `18 -> 13`, `24 -> 17`, and
`19 -> 11`.

The quality result is still negative. T45 contributes only one pooled
raw-area-power front point, on traffic-light. It loses every best-score
comparison against matched classic, with the multi-pipe result especially weak.

## Pareto And Hypervolume

| Metric | Classic | T45 T11 top-4 |
| --- | ---: | ---: |
| Mean hypervolume | 0.2043 | 0.1775 |
| Hypervolume value read | 2 wins + 1 tie | 0 wins + 1 tie |
| Mean Pareto point count | 3.67 | 3.33 |
| Mean reference-beating count | 10.00 | 8.67 |

Per-problem hypervolume:

| Problem | Classic | T45 T11 top-4 | Read |
| --- | ---: | ---: | --- |
| Prob045_alu | 0.2287 | 0.2264 | Near classic, but still a classic win. |
| Prob041_traffic_light | 0.3843 | 0.3062 | T45 loses the T44 traffic-light HV signal. |
| Prob015_multi_pipe_8bit | 0.0000 | 0.0000 | Tie at zero HV; T45 has weaker best score. |

This is a valid live ablation, but not a useful-BD promotion. The top-4
compression improves traffic-light valid-PPA yield versus T44, but it does not
keep T44's traffic-light/multi-pipe HV advantage and does not improve aggregate
front material versus classic.

The generated final-analysis table reports classic HV wins as `3` versus `0`
because its deterministic winner count assigns the zero-HV multi-pipe tie to
the overall winner. The value-level read above treats that row as a tie.

## Phase 03.1 Viewer Status

The full viewer exists at `visualizations/qd_ppa_viewer/`. It is the required
Phase 03.1 linked archive/PPA viewer, not the simpler direct-PPA wrapper.

Classic projection is honest. The viewer aliases the baseline as `classic`,
recovers descriptor values from the same top-4 runtime graph axes, and projects
classic candidates into the T45 QD archive posthoc:

| Problem | Classic projected | T45 projected |
| --- | ---: | ---: |
| Prob045_alu | 18/18 | 13/13 |
| Prob041_traffic_light | 24/24 | 17/17 |
| Prob015_multi_pipe_8bit | 19/19 | 11/11 |

The four descriptor axes are:

- `hyper_mean_fanout`
- `edge_per_node`
- `log_edge_count`
- `hyper_directed_edge_count`

Strict viewer validation passed with Playwright. The generated screenshot
matrix includes compare mode, single-method views, raw/improvement/normalized
coordinate modes, raw area-power front mode, rank-guide modes, and archive
projection controls.

## Visual Inspection

`figures/t45_raw_area_power_fronts.png` is readable, uses raw area on x and
raw power on y, marks lower-left as better, and keeps pooled-front stars
visible. The direct HTML screenshot renders the same figure and table without
broken image links or obvious overlap.

`visualizations/qd_ppa_viewer/screenshot.png` renders compare mode, linked
classic and QD archive panes, timeline state, and the PPA pane without a blank
canvas or obvious overlap. Use the full viewer for archive/PPA inspection and
the direct viewer for paper-readable raw area-power fronts.

## Conclusion

T45 is `T0 mixed_diagnostic`.

The compact top-4 graph profile confirms that T11 runtime graph axes are
operational in the live QD loop and can preserve classic-covered design
coverage. However, this ablation does not recover T44's positive HV/front
signal and remains worse than classic on aggregate HV, HV wins, Pareto points,
reference-beating count, valid-PPA count, and best score.

Do not escalate this exact ranked-axis bridge to top-16/top-64. The next
learned-graph follow-up should either use a frozen non-PPA projection selected
from replay evidence or change the archive coupling so the graph axes are used
as a secondary lane rather than the primary archive geometry.
