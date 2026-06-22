# T30 Results Report

Status: completed live holdout audit.

Tier decision: T1 near-classic holdout support with a yield warning. This is
not a T2/T3 quality-diversity win because T26 improves mean best score and
normalized HV on this small holdout, but it does not broaden the raw PPA front
or canonical netlist-family coverage versus classic.

## Question

Does T26 conservative-exploit SR raw generalize from the three-problem RTLLM
development screen to the frozen VerilogEval holdout screen?

Answer: partially. It preserves a passing final-best result on all three
classic-covered holdout designs, matches classic on two designs, improves the
P135 final-best score, and produces the only positive normalized PPA
hypervolume. It also generates fewer valid PPA samples and fewer unique
candidate/family variants, so it is evidence that the T26 exploitation lane is
competitive on this holdout, not evidence that it is already a persuasive QD
illumination method.

## Setup

Run root:
`exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/`

Both arms used seed `1001`, model `openai/gpt-oss-120b`, endpoint
`http://20.0.0.103:8000/v1`, `--max_tokens 128000`,
`--diff_max_tokens 128000`, population size `12`, and `3` generations.

Problems:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`

## Primary PPA Pareto Figures

Open these first when judging the PPA front behavior:

- `figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png` is the
  straightforward raw PPA Pareto view: area on x, power on y, no inverted axes,
  and lower-left is better. This is the clearest candidate-front comparison.
- `figures/t30_holdout_ppa_pareto_area_power.png` adds the reference design
  star on the same conventional axes. The reference stretches the y-axis on
  P150 and P135, so use it for context rather than detailed front shape.
- `figures/t30_holdout_ppa_fronts_improvement.png` shows normalized area/power
  improvement where higher is better on both axes.

Open circles mark each method's active-objective rank-1 front in all three
plots.

## Definitions

`valid_ppa_count` is the synthesis-PPA success count from the run summary
across all generated/evaluated samples. It is a yield metric, not a unique
design count.

`candidate_count` and `unique_ppa_points` count deduplicated candidate IDs and
unique objective vectors seen in `generation_log.jsonl`.

`ppa_front_points` is the deduplicated candidate-level rank-1 front size from
`revolution.qd.pareto_analysis`.

`ppa_front_count` in the family tables counts candidate rows assigned to the
rank-1 front before family/netlist hashing, so it can be much larger than
`ppa_front_points` when duplicate objective points recur across generations.

`global_ppa_hypervolume` is computed in normalized improvement space against
the reference design. A zero value means the method has no positive dominated
area in that normalized space for the problem; it does not mean the method had
no valid PPA candidates.

## Aggregate Result

| Metric | Classic | T26 conservative exploit | Interpretation |
| --- | ---: | ---: | --- |
| Valid PPA samples | 103 | 68 | T26 drops aggregate yield by 34.0%. |
| Final-best covered problems | 3 | 3 | T26 preserves classic coverage. |
| Mean final-best score | 0.224246 | 0.246463 | T26 is +9.91% over classic. |
| Mean normalized PPA HV | 0.000000 | 0.066206 | T26 gains HV from P135. |
| Mean HV AUC | 0.000000 | 0.016552 | Same signal as HV. |
| Candidate-level front points | 3 | 3 | No broader deduplicated front. |
| Reference-beating points | 4 | 4 | Tie. |
| Unique PPA points | 11 | 8 | T26 explores fewer unique PPA points. |
| Front unique families | 3 | 3 | Tie. |
| Front unique netlists | 9 | 6 | T26 has fewer front netlists. |

The package-level catastrophic validity gate is not triggered if evaluated in
aggregate because T26 keeps 66.0% of classic's valid PPA sample count. However,
P098 is a per-problem yield warning: T26 has 15 valid PPA samples versus
classic's 31, just under the 50% per-design threshold. This should prevent us
from calling T30 a clean acceptance result.

## Per-Problem Read

| Problem | Classic best | T26 best | PPA yield read | Front read |
| --- | ---: | ---: | --- | --- |
| P150_fsmonehot | 0.329686 | 0.329686 | T26 26 vs classic 32 valid PPA samples. | T26 reaches the low-area/low-power candidate cluster, but front count ties. |
| P098_circuit7 | 0.012006 | 0.012006 | T26 15 vs classic 31, the main yield warning. | Best/front point ties classic; no HV gain. |
| P135_m2014_q6b | 0.331046 | 0.397698 | T26 27 vs classic 40 valid PPA samples. | T26 produces the only positive HV and the best score, but front breadth remains sparse. |

## Pareto Archive Validation

`tables/holdout_t26_pareto_validation.md` reports:

- valid: `True`
- failure_count: `0`
- problem_invalid_count: `0`
- max_front_size_seen: `3`

This confirms that the exported T26 archive is structurally valid on the
holdout. It does not by itself prove quality improvement.

## Local Validation

- `/workspace/.venv/bin/pytest tests/scripts/test_package_t30_holdout_front_audit.py`
  passed.
- `/workspace/.venv/bin/ruff check scripts/package_t30_holdout_front_audit.py tests/scripts/test_package_t30_holdout_front_audit.py`
  passed.
- `git diff --check` passed.
- `/workspace/.venv/bin/python -m pyright scripts/package_t30_holdout_front_audit.py tests/scripts/test_package_t30_holdout_front_audit.py`
  reported unresolved `matplotlib` imports only. This matches the existing
  plotting-script pyright environment noise in T27/T28/T29 packaging scripts.

## Conclusion

T30 strengthens T26 as the current exploitation baseline because it survives a
frozen VerilogEval holdout and improves mean best score without losing any
classic-covered design. The most useful signal is P135: T26 finds a better
area/power tradeoff and produces positive normalized HV where classic's
holdout HV is zero.

The result is still not enough for the journal claim we want. A persuasive QD
method should show broader or better-distributed PPA-front exploration, not
only a better scalar best score on one holdout problem. T30 shows no increase
in candidate-level front points, no increase in front families, fewer front
netlists, fewer unique PPA points, and a P098 yield regression warning.

Next step: keep T26's conservative-exploit lane as the champion comparator, but
start T31 as a repair/yield/front-preserving emitter. The target is to retain
T26's P135 quality gain while improving P098 yield and front-family breadth.
