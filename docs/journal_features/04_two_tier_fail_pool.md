# Two-Tier Archive And Fail Pool

## Goal

Make the QD runtime use two explicit parent sources:

- success archive: archiveable thought evaluations with at least one successful
  code sample.
- fail pool: thought evaluations where every code sample failed or no
  archiveable code exists.

This preserves the conference version's useful fail-success separation while
keeping the journal operator simple and thought-centric.

## Current State

The current engine already has `fail_pool`, `success_archive`, and
`success_view`, but fail handling is still coupled to code-level candidates,
feedback, and prompt strategies. The journal runtime should make the pools
explicit thought sources instead.

The existing pool names in `src/revolution/qd/engine.py` are useful, but their
contents should move from code-level `Heuristic` candidates toward typed
thought evaluations after thought-only work lands.

## Failure Layers

The first implementation should use the following routing rules:

| Layer | Meaning | Journal routing |
| --- | --- | --- |
| A | Parsed thought is empty or structurally invalid. | Reject only when the thought parser can prove it; otherwise treat as all-fail after code sampling. |
| B | All k code samples fail syntax, simulation, or synthesis. | Insert the thought into the fail pool. |
| C | At least one code sample succeeds and at least one fails. | Insert the thought into the success archive with `success_rate < 1.0`. |
| D | Simulation succeeds but synthesis fails for a sample. | Count that sample as failed unless another sample fully succeeds. |

Layer A should stay narrow. Do not add an LLM judge or fuzzy nonsense detector
for the first pass.

## Implementation Specification

- Store failed thought evaluations in the fail pool.
- Store successful thought evaluations in the success archive.
- Select parent source by adaptive pool-size probability:

```text
p_fail = fail_pool_size / (fail_pool_size + archive_member_count)
```

- If the archive is empty, select from the fail pool or generate seed thoughts.
- If the fail pool is empty, select from the success archive.
- Keep fail-pool eviction simple: oldest or most-retried thoughts leave first.
- Do not use individual code feedback as parent prompt input.
- `archive_member_count` means total Pareto members, not occupied cell count.
- Fail-pool parent prompts may state that the parent thought failed to produce
  functioning code. They must not include code text, synthesis logs, simulator
  logs, or individual feedback.
- Failure-pattern summaries are deferred. If added later, they must be
  descriptive summaries across many fail-pool thoughts, not prescriptive
  mutation modifiers.

## Configuration

Required config:

```yaml
fail_pool:
  max_size_multiplier: 2
  source_selection: adaptive_size_ratio
```

`max_size_multiplier` is relative to the target thought population size.
`source_selection` has one supported value in the first implementation.

## Artifacts And Reporting

- Generation logs record parent source: `archive` or `fail_pool`.
- `thought_evaluation.json` records all-fail and partial-success outcomes.
- Summary files record fail-pool size, archive member count, and observed
  source-selection rates.
- Prompt snapshots record only the abstract failure fact for fail-pool parents.

## Testing Plan

- Unit-test source probability for empty, mixed, and full pools.
- Unit-test fail-pool insertion and eviction.
- Integration-test all-fail thought routing to fail pool.
- Integration-test partial-success thought routing to archive.
- Regression-test prompts do not include individual feedback.

## Completion Checklist

Target deadline: `2026-05-07`

- [ ] 4.1 Make success archive and fail pool the two explicit parent sources.
- [ ] 4.2 Implement adaptive source probability from pool sizes.
