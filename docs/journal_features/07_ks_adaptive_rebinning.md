# KS-Triggered Adaptive Re-Binning

## Goal

Add statistically triggered re-binning after the journal archive semantics are
stable. The archive should update its descriptor-space discretization when
recent successful thought representatives differ significantly from the current
archive-member distribution.

## Current State

Initial quantile binning gives the journal runtime problem-specific bins at
startup. It does not respond when evolution discovers a new descriptor region.

KS-triggered re-binning is intentionally implemented after thought-only
evaluation and Pareto-front archive behavior, because it needs stable answers
to:

- what counts as a recent descriptor sample.
- what counts as an archive member.
- how all Pareto members are reinserted after bins move.

`scipy` is already a project dependency, so the first implementation can use
`scipy.stats.ks_2samp` without adding a new dependency.

KS-triggered re-binning has known risks: moving cell coordinates can destabilize
selection pressure, weaken simple cell interpretation, and make run histories
harder to read. The journal implementation controls those risks with warmup,
cooldown, explicit history artifacts, and fresh re-binning only when the test
finds distributional drift.

## Implementation Specification

- Store a recent descriptor window for archiveable thought representatives.
- Recent samples are successful thought representatives, not every code sample
  in a k-code evaluation.
- Archive samples are every Pareto member, not one row per occupied cell.
- Compare recent descriptor samples against archive-member descriptor samples.
- Run one 1D KS test per active descriptor axis.
- Apply Bonferroni correction:

```text
p_threshold = 0.05 / active_axis_count
```

- Trigger a full re-bin if any axis rejects the same-distribution null
  hypothesis below the corrected threshold.
- Enforce cooldown after a re-bin.
- Recompute quantile bins from archive members only.
- Reinsert every Pareto member into the rebuilt archive.
- Recompute per-cell Pareto fronts after reassignment.
- Do not smooth old and new bin edges. The trigger already indicates meaningful
  drift, so fresh quantile computation is simpler and removes an extra alpha
  parameter.
- Collision handling after re-binning is Pareto-front reconstruction, not scalar
  max-fitness replacement.
- Empty cells after re-binning remain empty and available for future offspring.

## Configuration

Required config:

```yaml
rebinning:
  kind: ks_triggered
  recent_generations: 3
  min_archive_members: 30
  cooldown_generations: 3
  base_p_threshold: 0.05
```

All fields are required. The implementation should assert positive integer
counts and a threshold in `(0, 1)`.

## Artifacts And Reporting

- `archive_history.jsonl` records re-bin events.
- `archive_space.json` records current bin boundaries and re-bin count.
- `archive_summary.json` records total re-bin count and last trigger axis.
- `descriptor_health.json` can compare recent-window and archive-member stats.
- Reports should describe re-binning as a cell-coordinate change, not a change
  in candidate evaluation.
- Each re-bin event records tested axes, p-values, corrected threshold, warmup
  state, cooldown state, old effective bins, and new effective bins.

## Testing Plan

- Unit-test recent-window collection.
- Unit-test KS trigger with deterministic synthetic distributions.
- Unit-test Bonferroni threshold calculation.
- Unit-test cooldown behavior.
- Unit-test rebuilding bins from archive members only.
- Integration-test that every Pareto member is reinserted and fronts are
  rebuilt after re-binning.

## Completion Checklist

Target deadline: `2026-05-12`

- [ ] 7.1 Store recent offspring descriptor windows.
- [ ] 7.2 Add KS test trigger with Bonferroni threshold and cooldown.
- [ ] 7.3 Rebuild quantile bins from archive members only, then reinsert all
  Pareto members.
- [ ] 7.4 Finish docs, config snapshots, report updates, and full validation.
