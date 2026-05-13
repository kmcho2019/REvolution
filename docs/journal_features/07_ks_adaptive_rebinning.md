# KS-Triggered Adaptive Re-Binning

## Goal

Add statistically triggered re-binning to QD/MAP-Elites archive geometries. The
archive should update its descriptor-space discretization when recent
archiveable candidates differ significantly from the current retained archive
distribution.

Feature 07 is validated first on the current journal path:

- thought-only evaluation.
- `grid_quantile` archive geometry.
- `pareto_front` cell mode.

The implementation should not make the feature journal-only. It should attach
to QD archive behavior and work for every supported MAP-Elites archive geometry
that can rebuild its cell assignment from retained archive members.

## Current State

Initial `grid_quantile` binning gives the journal runtime problem-specific bins
at startup. Uniform `grid` and `cvt` archives also freeze their cell assignment
after initialization. None of these geometries respond when evolution discovers
a new descriptor region.

KS-triggered re-binning is implemented after thought-only evaluation and
Pareto-front archive behavior because the journal validation path needs stable
answers to:

- what counts as a recent descriptor sample.
- what counts as an archive member.
- how all Pareto members are reinserted after bins move.

The generalized implementation should answer those questions through QD archive
and representation contracts, not through journal-only branches.

`scipy` is already a project dependency, so the first implementation can use
`scipy.stats.ks_2samp` without adding a new dependency.

KS-triggered re-binning has known risks: moving cell coordinates can destabilize
selection pressure, weaken simple cell interpretation, and make run histories
harder to read. The journal implementation controls those risks with warmup,
cooldown, explicit history artifacts, and fresh re-binning only when the test
finds distributional drift.

## Implementation Specification

- Store a recent descriptor window for archiveable QD candidates.
- The recent-window sample is the same unit that the archive attempts to
  insert:
  - current code-candidate QD modes record successful archiveable code
    candidates.
  - thought-only QD modes record successful thought representatives, not every
    code sample in a k-code evaluation.
- Archive samples are retained archive members:
  - `scalar_elite` contributes one elite per occupied cell.
  - `pareto_front` contributes every retained front member in every occupied
    cell.
  - unknown cell modes fail immediately.
- Compare recent descriptor samples against archive-member descriptor samples.
- Run one 1D KS test per active descriptor axis.
- Apply Bonferroni correction:

```text
p_threshold = 0.05 / active_axis_count
```

- Trigger a full re-bin if any axis rejects the same-distribution null
  hypothesis below the corrected threshold.
- Enforce cooldown after a re-bin.
- Rebuild the archive geometry from retained archive members only.
- Preserve the archive replacement mode, objectives, descriptor axes, and
  configured capacity.
- Reinsert every retained archive member into the rebuilt archive.
- Recompute per-cell state after reassignment:
  - `scalar_elite` uses scalar elite replacement.
  - `pareto_front` reconstructs the bounded Pareto front.
  - unknown cell modes fail immediately.
- Do not smooth old and new bin edges. The trigger already indicates meaningful
  drift, so fresh quantile computation is simpler and removes an extra alpha
  parameter.
- Empty cells after re-binning remain empty and available for future offspring.

Archive geometry handling is exhaustive:

- `grid_quantile`: recompute quantile boundaries from retained members.
- `grid`: recompute per-axis bounds from retained members and preserve the
  configured bin counts.
- `cvt`: refit the descriptor scaler from retained members and regenerate
  centroids with the configured deterministic seed.
- unknown archive geometries fail immediately.

## Configuration

The config is a discriminated union. Re-binning is disabled unless the mode
explicitly chooses the KS trigger.

Disabled config:

```yaml
rebinning:
  kind: disabled
```

KS-triggered config:

```yaml
rebinning:
  kind: ks_triggered
  recent_generations: 3
  min_archive_members: 30
  cooldown_generations: 3
  base_p_threshold: 0.05
```

All `ks_triggered` fields are required. The implementation should assert
positive integer counts and a threshold in `(0, 1)`. `kind` is required in every
config. Unknown `kind` values fail immediately.

Do not add archive-specific override fields in the first pass. The archive type
already determines how geometry is rebuilt.

## Artifacts And Reporting

- `archive_history.jsonl` records re-bin events.
- `archive_space.json` records current bin boundaries and re-bin count.
- `archive_summary.json` records total re-bin count, last trigger axis, and
  re-binning config kind.
- `descriptor_health.json` can compare recent-window and archive-member stats.
- Reports should describe re-binning as a cell-coordinate change, not a change
  in candidate evaluation.
- Each re-bin event records archive type, cell mode, tested axes, p-values,
  corrected threshold, warmup state, cooldown state, old geometry, new geometry,
  retained member count, and reinserted member count.

## Implementation Guidance

- Keep code extremely simple and skimmable.
- Minimize possible states by keeping argument lists short and required.
- Use discriminated unions for config objects with multiple shapes.
- Exhaustively handle archive types, cell modes, and config kinds.
- Fail on unknown types instead of adding defensive fallbacks.
- Use asserts when loading data that must exist.
- Do not make arguments optional when the caller must provide them.
- Remove changes that are not strictly required for Feature 07.
- Bias for fewer lines and early returns.
- Avoid clever code and excessive helper extraction.
- Pass overrides only when they are strictly necessary.

## Commit Guidance

- Keep commits atomic.
- Use Conventional Commit subjects.
- Capitalize the subject, use imperative mood, and do not end with a period.
- Keep the subject at 50 characters or less when practical.
- Separate subject and body with a blank line when a body is needed.
- Use the body to explain what changed and why, wrapped at 72 columns.
- After committing, inspect the commit message to catch visible `\n`, missing
  signoff when required, or other broken formatting.

## Testing Plan

- Unit-test recent-window collection.
- Unit-test KS trigger with deterministic synthetic distributions.
- Unit-test Bonferroni threshold calculation.
- Unit-test cooldown behavior.
- Unit-test config loading for `disabled`, `ks_triggered`, and unknown `kind`.
- Unit-test archive rebuild behavior for `grid_quantile`, `grid`, and `cvt`.
- Unit-test scalar-elite and Pareto-front reinsertion after re-binning.
- Integration-test that every retained Pareto member is reinserted and fronts
  are rebuilt after re-binning.
- Validate the first full acceptance path on thought-only evaluation plus
  `grid_quantile` plus `pareto_front`.

## Completion Checklist

Target deadline: `2026-05-12`

- [ ] 7.1 Store recent archiveable-candidate descriptor windows.
- [ ] 7.2 Add KS test trigger with Bonferroni threshold and cooldown.
- [ ] 7.3 Rebuild supported archive geometries from retained members, then
  reinsert all retained members.
- [ ] 7.4 Finish docs, config snapshots, report updates, and full validation.
