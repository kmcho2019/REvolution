# T31 Results Report

Status: completed live holdout audit.

Tier decision: T0 diagnostic. T31 is useful negative evidence for the
failure-feedback emitter lane, but it is not a useful-QD win or a near-classic
follow-up. It preserves final-best coverage on all three holdout problems, but
it worsens aggregate valid-PPA yield, does not repair P098, loses T26's P135
quality/HV signal, and does not broaden the raw PPA front.

## Pre-Registered Question

Can a same-budget failure-feedback repair emitter improve T30's P098 yield and
front-breadth warning while preserving T26's holdout quality signal?

Answer: no. T31 keeps all three final-best problems passing, but it fails the
pre-registered repair target. P098 valid-PPA count is `14`, below T26's already
weak `15` and far below classic's `31`. P135 final-best score drops from T26's
`0.397698` to `0.263617`, and T31 has zero normalized HV/HV-AUC.

## Setup

Run root:
`exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/`

The new arm used seed `1001`, model `openai/gpt-oss-120b`, endpoint
`http://20.0.0.103:8000/v1`, `--max_tokens 128000`,
`--diff_max_tokens 128000`, population size `12`, and `3` generations. The
run completed in `681.97` seconds.

Comparators are the packaged T30 classic and T26 roots:

- `classic_revolution`
- `sr_raw_conservative_exploit_qd`
- `sr_raw_fail_feedback_repair_qd`

Problems:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`

## Primary PPA Pareto Figures

Open these first when judging the PPA front behavior:

- `figures/t31_holdout_ppa_pareto_area_power_candidate_zoom.png` is the
  primary raw PPA Pareto view: area on x, power on y, no inverted axes, and
  lower-left is better.
- `figures/t31_holdout_ppa_pareto_area_power.png` adds the reference design
  stars. Use it for context because the reference stretches P150 and P135.
- `figures/t31_holdout_ppa_fronts_improvement.png` shows normalized
  area/power improvement where higher is better on both axes.

Open circles mark each method's active-objective rank-1 front.

## Aggregate Result

| Metric | Classic | T26 conservative exploit | T31 fail-feedback repair | Interpretation |
| --- | ---: | ---: | ---: | --- |
| Valid PPA samples | 103 | 68 | 56 | T31 is worse than both controls. |
| Final-best covered problems | 3 | 3 | 3 | T31 preserves all covered designs. |
| Mean final-best score | 0.224246 | 0.246463 | 0.201770 | T31 loses 10.02% versus classic and 18.14% versus T26. |
| Mean normalized PPA HV | 0.000000 | 0.066206 | 0.000000 | T31 loses the T26 P135 HV signal. |
| Mean HV AUC | 0.000000 | 0.016552 | 0.000000 | Same loss as HV. |
| Candidate-level front points | 3 | 3 | 3 | No broader deduplicated front. |
| Reference-beating points | 4 | 4 | 2 | T31 halves the reference-beating count. |
| Unique PPA points | 11 | 8 | 6 | T31 explores fewer unique PPA points. |
| Front unique families | 3 | 3 | 3 | Tie, not a breadth win. |
| Front unique netlists | 9 | 6 | 6 | T31 does not recover classic's front-netlist breadth. |

## Per-Problem Read

| Problem | Classic valid PPA | T26 valid PPA | T31 valid PPA | T31 read |
| --- | ---: | ---: | ---: | --- |
| P150_fsmonehot | 32 | 26 | 13 | T31 keeps the same best score, but triggers the 50% per-problem valid-PPA drop warning versus classic. |
| P098_circuit7 | 31 | 15 | 14 | T31 fails the intended P098 repair target. |
| P135_m2014_q6b | 40 | 27 | 29 | Yield is slightly better than T26, but final-best score and HV regress. |

## Pareto Archive Validation

`tables/t31_holdout_pareto_validation.md` reports:

- valid: `True`
- failure_count: `0`
- problem_invalid_count: `0`
- max_front_size_seen: `2`

This confirms archive structural validity. It does not change the negative
PPA/yield result.

## Local Validation

- `/workspace/.venv/bin/python scripts/validate_pareto_front_run.py` passed for
  the T31 run root.
- `/workspace/.venv/bin/python -m scripts.package_t31_holdout_repair_audit`
  generated the package tables and figures.
- Figure inspection accepted the raw PPA Pareto PNGs as readable and
  conclusion-supporting.
- `/workspace/.venv/bin/pytest` passed for
  `tests/scripts/test_package_t30_holdout_front_audit.py` and
  `tests/scripts/test_package_t31_holdout_repair_audit.py`.
- `/workspace/.venv/bin/ruff check` passed for the touched packagers and
  tests.
- `uv tool run ty check` passed for the touched packagers and tests.
- `git diff --check` passed.
- `/workspace/.venv/bin/python -m pyright` reported unresolved `matplotlib`
  imports in the plotting packager only, matching the existing T30/T31
  plotting-script environment noise.

## Conclusion

T31 should be retired as a direct failure-feedback repair emitter. It answered
the immediate question cleanly: same-budget fail-pool feedback through
`single_thought_operator` did not repair P098 yield and did not preserve the
T26 holdout quality signal. The raw PPA Pareto plot shows no front widening,
and the aggregate table shows lower valid PPA, lower mean final-best score, no
HV/HV-AUC gain, fewer reference-beating points, and fewer unique PPA points.

The follow-up should not be another blind repair-emitter retry. The next
reasonable lane is an explicit front-preserving emitter schedule or archive
ensemble that keeps T26 champion pressure while separately sampling local
rank-1 or near-front candidates. If repair is revisited, it should be bounded
and measured as a separate lane, not mixed into every archive-parent request.
