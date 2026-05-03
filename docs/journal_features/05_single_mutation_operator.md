# Single Thought Mutation Operator

## Goal

Replace QD-specific prompt strategies with one minimal thought-generation
operator. The journal runtime should let the LLM generate a new design strategy
from one or two parent thoughts without prescribing a hand-authored mutation
direction.

## Current State

The current engine uses strategy routing and QD-specific prompt operators such
as targeted mutation and diverse fusion. That creates many states and keeps the
runtime tied to code-level prompt behavior.

The journal runtime should remove strategy-bandit routing from `revolution_qd`.

This is a deliberate shift from the conference/EoH-style prompt strategy set
toward a FunSearch/AlphaEvolve-style minimal operator. Diversity should come
from archive sampling, stochastic LLM decoding, one-parent versus two-parent
variation, and adaptive behavior-space coverage, not from hand-authored
modifier prompts.

The implementation should remove or bypass QD strategy surfaces in
`src/revolution/qd/engine.py`, including QD strategy-bandit routing and
strategy-specific success/fail accounting for the journal path.

## Implementation Specification

- Use one prompt path: generate a new design strategy.
- Parent count controls the only operator variant:
  - one parent: mutation-like.
  - two parents: crossover-like.
- Prompt inputs:
  - problem specification.
  - one or two parent thoughts.
  - compact archive context when available.
  - optional abstract failure-pattern summary when that future feature is
    enabled.
- Prompt inputs must not include:
  - parent code.
  - individual feedback.
  - code-level error logs.
- Default parent-count mix:
  - 70 percent one-parent generation.
  - 30 percent two-parent generation when at least two parents exist.
- Archive context is a small uniformly sampled list of existing thoughts. The
  first default is `archive_context_size: 4`.
- The prompt output schema should require a thought/design strategy only. Code
  generation belongs to the k-code evaluation stage.
- If a future ablation reintroduces conference strategies, it should be a
  separate operator variant, not hidden behavior inside
  `single_thought_operator`.

## Configuration

Required config:

```yaml
operator:
  kind: single_thought_operator
  one_parent_fraction: 0.70
  archive_context_size: 4
```

The implementation should assert that `one_parent_fraction` is in `[0, 1]`.
`archive_context_size` is required and must be non-negative. No strategy list is
configured in the journal path.

## Artifacts And Reporting

- Generation logs record `parent_count` instead of strategy name.
- Existing strategy fields may be removed from journal QD artifacts or mapped
  to a single stable value such as `single_thought_operator`.
- Prompt snapshots should make it easy to verify that code and individual
  feedback were excluded.

## Testing Plan

- Unit-test parent-count sampling.
- Unit-test prompt payloads for one-parent and two-parent cases.
- Regression-test absence of parent code and individual feedback.
- Integration-test generated thought materialization.

## Completion Checklist

Target deadline: `2026-05-08`

- [ ] 5.1 Remove QD strategy-bandit routing from `revolution_qd`.
- [ ] 5.2 Add one prompt path for generating a new design strategy with one or
  two parent thoughts.
- [ ] 5.3 Verify prompts contain no parent code and no individual feedback.
