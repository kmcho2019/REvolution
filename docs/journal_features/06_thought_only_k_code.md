# Thought-Only Individuals And k-Code Evaluation

## Goal

Make the thought, not the single generated RTL file, the evolutionary
individual. Each thought is evaluated by generating and testing `k` code
samples. This reduces code-generation noise and makes archive entries represent
hardware design ideas.

## Current State

The current runtime uses `Heuristic` objects that carry thought, code,
feedback, status, score, and artifacts together. QD archive insertion happens
per successful code candidate.

The journal runtime should split these concepts:

- thought individual: the evolvable design idea.
- code sample: one RTL realization of the thought.
- thought evaluation: aggregate result across code samples.

`src/revolution/runtime/candidate_evaluator.py` should remain the code-sample
evaluation workhorse. The new layer should orchestrate multiple code samples
per thought and aggregate their results instead of duplicating simulation,
synthesis, scoring, or descriptor extraction.

The existing `_format_parent_for_prompt` behavior in `src/revolution/algorithm.py`
is not suitable for journal thought mutation because it can include parent code
and feedback. Thought-only prompts need a narrower prompt payload.

## Implementation Specification

- Add typed runtime objects for:
  - `ThoughtIndividual`
  - `CodeSample`
  - `ThoughtEvaluation`
- Generate thoughts first with the single thought operator.
- For each thought, generate `k=4` independent code samples by default.
- Evaluate every code sample with the existing evaluator.
- Keep total evaluation budget explicit. For a budget of 20 code evaluations,
  `k=4` means generating 5 new thoughts rather than 20 new thoughts.
- If all code samples fail, store the thought evaluation in the fail pool.
- If at least one code sample succeeds:
  - choose the best successful code by scalar PPA score as the representative
    for descriptor assignment and code artifact references.
  - compute `success_rate = successful_samples / k`.
  - store all sample outcomes for reporting.
  - insert the thought into the archive using Pareto-front replacement.
- Pareto dominance remains PPA-only. Success rate is recorded for analysis and
  ablation, not used as an objective.
- Descriptor assignment uses the representative code's descriptor values in the
  first implementation. Centroid, mean, median, and most-frequent-cell
  aggregation are deferred ablation knobs.
- Code-sample diversity comes from LLM sampling temperature and independent
  calls. Do not add hand-authored code-generation modifiers in the first pass.

## Configuration

Required config:

```yaml
representation:
  kind: thought_only
  code_samples_per_thought: 4
  representative_sample: best_successful_quality
```

`code_samples_per_thought` must be a positive integer. The first journal
experiments use `4`. `representative_sample` has one supported first-pass value.

## Artifacts And Reporting

- Write `thought_evaluation.json` for each thought.
- Write code sample artifacts under stable per-sample directories, for example
  `code_sample_0/`, `code_sample_1/`, and so on.
- Record representative sample ID and all sample statuses.
- Summary files report success-rate distributions.
- Archive events link archive members back to the thought and representative
  code sample.

## Testing Plan

- Unit-test all-fail, partial-success, and all-success aggregation.
- Unit-test representative-code selection.
- Unit-test success-rate recording.
- Integration-test fake LLM thought generation followed by k code samples.
- Regression-test that failed samples do not receive archive descriptors unless
  their evaluation produced valid descriptors.

## Completion Checklist

Target deadline: `2026-05-10`

- [ ] 6.1 Add simple typed runtime objects for thought individuals, code
  samples, and thought evaluations.
- [ ] 6.2 Split thought generation from code generation.
- [ ] 6.3 Generate `k=4` code samples per thought and evaluate each sample with
  the existing evaluator.
- [ ] 6.4 Aggregate thought evaluation: best successful code chooses BD/code
  artifact, success rate is recorded, and all-fail thoughts enter the fail
  pool.
