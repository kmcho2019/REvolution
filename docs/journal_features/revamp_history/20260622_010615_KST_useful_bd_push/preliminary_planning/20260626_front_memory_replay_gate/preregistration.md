# Preregistration

## Method

Run a deterministic replay over the T96 candidate-level PPA table. For each
backend/problem pair:

1. Compute the final nondominated PPA front from all valid-PPA candidates.
2. Reconstruct scalar top-k retention using `score_from_run` through each
   candidate birth generation.
3. Measure how many final-front candidates are outside scalar top-k at birth
   and outside scalar top-k at the end of the run.

## Metrics

- `final_front_count`: nondominated valid-PPA candidates at the end.
- `topk_final_front_count`: final-front candidates retained by final scalar
  top-k.
- `evicted_final_front_count`: final-front candidates missing from final
  scalar top-k.
- `evicted_final_front_rate`: `evicted_final_front_count / final_front_count`.
- `not_topk_at_birth_count`: final-front candidates missing from scalar top-k
  immediately after their birth generation.

## Decision Rule

This replay can justify a new memory mechanism only if at least one backend has
a visible scalar-retention gap: final-front candidates exist that scalar top-k
would discard. It cannot promote a QD method by itself.

If the gap is concentrated in classic, the next method should be a classic-like
optimizer with a small front-family memory. If the gap is concentrated in QD,
the issue is less memory existence and more parent-selection quality.
