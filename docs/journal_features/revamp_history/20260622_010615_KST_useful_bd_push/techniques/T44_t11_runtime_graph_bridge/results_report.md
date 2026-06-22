# T44 Results Report

Status: complete live screen; `T0 mixed_diagnostic`.

## Question

Can a live-safe top-8 subset of the T11 structural graph features improve the
T39 one-slot sparse-warmup QD substrate without losing classic-covered designs
or valid-PPA yield?

## Definitions

- Raw PPA point: one candidate with valid synthesized area and power.
- Method raw front: nondominated raw area-power points within one method for
  one problem. Lower area and lower power are both better.
- Pooled raw front: nondominated raw area-power points after pooling all
  compared methods for one problem.
- Hypervolume: normalized PPA dominated volume from the final-analysis Pareto
  report. Higher is better.
- Valid-PPA yield gate: a relative drop of 50% or more is a promotion blocker
  when the matched classic arm has at least 10 passing samples.

## Evidence

- Runtime root:
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC/`.
- vLLM preflight: `openai/gpt-oss-120b` served with `max_model_len=131072`.
- Matched arms: `classic_revolution` ran in 643 seconds;
  `t11_runtime_top8_graph_qd` ran in 702 seconds.
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
  `figures/t44_raw_area_power_fronts.png`.
- Regeneration data:
  `tables/t44_candidate_ppa_points.csv`,
  `tables/t44_problem_method_summary.csv`, and
  `visualizations/qd_ppa_viewer_source/final_analysis/`.

## Direct Raw PPA Results

| Method | Problem | Valid PPA | Method raw front | Pooled raw front | Best score |
| --- | --- | ---: | ---: | ---: | ---: |
| Classic | Prob045_alu | 35 | 1 | 1 | 0.419778 |
| T44 T11 graph | Prob045_alu | 16 | 2 | 0 | 0.404449 |
| Classic | Prob041_traffic_light | 25 | 4 | 2 | 0.389132 |
| T44 T11 graph | Prob041_traffic_light | 7 | 2 | 1 | 0.389132 |
| Classic | Prob015_multi_pipe_8bit | 16 | 1 | 0 | 0.037911 |
| T44 T11 graph | Prob015_multi_pipe_8bit | 13 | 1 | 1 | 0.116397 |

T44 preserves all three classic-covered designs. It also improves the
multi-pipe best score and contributes one multi-pipe pooled raw-front point.
Traffic-light has one pooled raw-front point and ties the matched classic best
score.

The blocker is yield and aggregate breadth. T44 drops valid PPA from 35 to 16
on ALU and from 25 to 7 on traffic-light. Those classic denominators are above
the promotion-gate threshold, and both drops exceed 50%.

## Pareto And Hypervolume

| Metric | Classic | T44 T11 graph |
| --- | ---: | ---: |
| Mean hypervolume | 0.163787 | 0.154221 |
| Hypervolume win count | 1 | 2 |
| Mean Pareto point count | 3.333333 | 3.666667 |
| Mean reference-beating count | 16.333333 | 6.333333 |

Per-problem hypervolume:

| Problem | Classic | T44 T11 graph | Read |
| --- | ---: | ---: | --- |
| Prob045_alu | 0.264929 | 0.220117 | Classic wins. |
| Prob041_traffic_light | 0.226431 | 0.242407 | T44 wins, but yield falls. |
| Prob015_multi_pipe_8bit | 0.000000 | 0.000138 | T44 wins with a small nonzero front. |

This is a real signal, not a blank run: T44 wins hypervolume on two of three
problems and has a slightly larger mean Pareto point count. It is still not a
promotion candidate because aggregate HV, reference-beating count, and valid
PPA yield regress.

## Phase 03.1 Viewer Status

The full viewer exists at `visualizations/qd_ppa_viewer/`. It is the required
Phase 03.1 linked archive/PPA viewer, not the simpler direct-PPA wrapper.

Classic projection is honest. The viewer aliases the baseline as `classic`,
recovers descriptor values from the same top-8 runtime graph axes, and projects
classic candidates into the T44 QD archive posthoc:

| Problem | Classic projected | T44 projected |
| --- | ---: | ---: |
| Prob045_alu | 35/35 | 16/16 |
| Prob041_traffic_light | 25/25 | 7/7 |
| Prob015_multi_pipe_8bit | 16/16 | 13/13 |

The eight descriptor axes are:

- `hyper_mean_fanout`
- `edge_per_node`
- `log_edge_count`
- `hyper_directed_edge_count`
- `hyper_fanout_entropy`
- `hyper_driven_net_count`
- `hyper_sink_net_count`
- `log_net_count`

Strict Playwright validation initially exposed a viewer bug: occupied archive
cells with more than three descriptor coordinates were rendered as samples but
not as filled-cell hover targets. `src/revolution/qd/ppa_visualization_viewer.py`
now renders occupied high-dimensional cells from the actual cell summaries.
After re-export, strict validation passed.

## Visual Inspection

`figures/t44_raw_area_power_fronts.png` is readable, uses raw area on x and
raw power on y, marks lower-left as better, and keeps pooled-front stars
visible. The direct HTML screenshot renders the same figure and table without
overlap.

`visualizations/qd_ppa_viewer/screenshot.png` renders compare mode, linked
classic and QD archive panes, timeline state, and the PPA pane without a blank
canvas or obvious overlap. Use the full viewer for archive/PPA inspection and
the direct viewer for paper-readable raw area-power fronts.

## Conclusion

T44 is a valid live result and a useful diagnostic, but it is `T0
mixed_diagnostic`. It answers the immediate T11-runtime question with a mixed
result: the graph descriptor has real front/HV signal on traffic-light and
multi-pipe, but the top-8 high-dimensional archive is too sparse and loses too
much valid-PPA yield on ALU and traffic-light.

Do not escalate directly to top-16 or top-64 runtime graph axes yet. The next
method should compress or select fewer T11 runtime graph axes first, for
example a pre-registered `T45` top-3/top-4 runtime graph profile or a frozen
non-PPA projection. That follow-up should keep the T44 direct PPA and
Phase 03.1 viewer gates unchanged.
