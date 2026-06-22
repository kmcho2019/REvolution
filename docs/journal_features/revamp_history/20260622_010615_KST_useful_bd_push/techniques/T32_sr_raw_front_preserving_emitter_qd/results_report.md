# T32 Results Report

Status: completed and assigned `T0 diagnostic`.

## Question

Can a modest front-preserving success-parent lane improve P098 yield or raw
PPA-front breadth while preserving T26's P135 holdout quality/HV signal?

## Setup

T32 keeps the T26/T30 SR raw PCA descriptor, grid-quantile local-Pareto
archive, NSGA-II global-rank parent selection, and code-individual
`eoh_strategies` emitter. It changes only the parent schedule:

- `qd_champion_lane_fraction=0.72`, down from T26/T31 `0.80`;
- `qd_two_parent_probability=0.08`, up from T26/T31 `0.00`;
- no T31-style fail-feedback text and no expanded repair loop.

The live run used the frozen VerilogEval holdout screen, seed `1001`,
`openai/gpt-oss-120b`, `--max_tokens 128000`, and
`--diff_max_tokens 128000`. Runtime was `651.99` seconds. The vLLM preflight
reported `max_model_len=131072`.

## Primary Figures

- `figures/t32_holdout_ppa_pareto_area_power_candidate_zoom.png` is the first
  reader-facing PPA/front figure: raw area on x, raw power on y, conventional
  axes, lower-left better.
- `figures/t32_holdout_ppa_pareto_area_power.png` adds reference stars.
- `figures/t32_holdout_ppa_fronts_improvement.png` is the normalized support
  view.
- `figures/t32_holdout_problem_counts.png` shows per-problem valid-PPA,
  reference-beating, and front-point counts.

The direct raw Pareto plot is the decisive visualization. It shows T32 mostly
overlapping T31 and not recovering T26's P135 low-area/low-power point.

## Aggregate Metrics

| Method | Valid PPA | Mean Best | Mean HV | Mean HV AUC | Front Points | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 103 | 0.224246 | 0.000000 | 0.000000 | 3 | 11 |
| T26 conservative exploit | 68 | 0.246463 | 0.066206 | 0.016552 | 3 | 8 |
| T31 fail-feedback repair | 56 | 0.201770 | 0.000000 | 0.000000 | 3 | 6 |
| T32 front-preserving emitter | 67 | 0.201770 | 0.000000 | 0.000000 | 3 | 9 |

T32 improves valid-PPA count versus T31 (`67` versus `56`) and nearly matches
T26 (`68`). It also improves unique PPA points versus T26/T31 (`9` versus
`8/6`). These are useful diagnostic signals, but they do not preserve T26's
quality/HV result.

## Per-Problem Read

| Problem | Classic Valid PPA | T26 | T31 | T32 | T32 Read |
| --- | ---: | ---: | ---: | ---: | --- |
| P150 fsmonehot | 32 | 26 | 13 | 17 | Better than T31, worse than T26/classic. |
| P098 circuit7 | 31 | 15 | 14 | 19 | T32 repairs some of the P098 yield warning. |
| P135 m2014 q6b | 40 | 27 | 29 | 31 | Yield improves, but quality/HV stays collapsed. |

T32 final-best scores are `0.329686`, `0.012006`, and `0.263617` for P150,
P098, and P135. The P135 score matches T31 and is far below T26's `0.397698`.
This is why T32 has zero mean HV/HV-AUC despite better count metrics.

## Family And Duplicate Accounting

T32 has `8` front unique netlists, better than T26/T31 (`6/6`) and close to
classic (`9`). It has `3` front unique families, tying every comparator. The
candidate rows in `tables/t32_holdout_family_candidate_rows.csv` contain the
raw area, power, front flag, RTL hash, netlist hash, and family signature
needed to regenerate the front figures.

The family result is a diagnostic hint, not a promotion: the extra netlist
breadth does not include the P135 reference-beating front material that made
T26 useful.

## Validation

Pareto archive validation passed:

- valid: `True`;
- failure count: `0`;
- problem invalid count: `0`;
- max front size seen: `3`.

Focused validation for the packaging code passed:

- `pytest tests/scripts/test_package_t30_holdout_front_audit.py tests/scripts/test_package_t31_holdout_repair_audit.py tests/scripts/test_package_t32_front_preserving_emitter_audit.py`;
- `ruff check scripts/package_t30_holdout_front_audit.py scripts/package_t32_front_preserving_emitter_audit.py tests/scripts/test_package_t32_front_preserving_emitter_audit.py`;
- `uv tool run ty check scripts/package_t30_holdout_front_audit.py scripts/package_t32_front_preserving_emitter_audit.py tests/scripts/test_package_t32_front_preserving_emitter_audit.py`.

## Conclusion

T32 is `T0 diagnostic`.

The small near-front success-parent lane is not enough. It improves P098
valid-PPA count and recovers some unique PPA/netlist breadth versus T31, but it
does not preserve T26's P135 quality/HV signal, does not improve mean best
score, and does not visibly widen the useful raw area-power Pareto front.

Do not continue by only nudging champion fraction or two-parent probability.
The next method should either restore T26 champion pressure while adding a
separate bounded repair lane, or move to a different mechanism such as
explicit local rank-1 parent quotas, side-archive emitters, or learned/structural
descriptor branches.
