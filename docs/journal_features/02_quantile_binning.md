# Initial QD Binning: Quantile Adaptive Grid

## Goal

Add an initial quantile-based MAP-Elites grid for the journal QD runtime. The
first implementation should compute descriptor-space bins from successful
warmup samples rather than relying on fixed global bounds.

## Current State

The current QD archive supports fixed grid axes and CVT warmup behavior. Grid
axis bounds can come from descriptor config files, but fixed bounds can collapse
useful variation on one problem and over-expand another.

The journal runtime should start with a simple adaptive grid:

- four intended bins per axis.
- 25/50/75 percentile boundaries.
- duplicate quantiles collapse into fewer effective bins.

This should be implemented as a simpler sibling of the current `CVTArchive`
warmup behavior in `src/revolution/qd/archive.py`, not as a CVT special case.
The existing fixed `GridArchive` can provide the insertion and cell-assignment
shape, but its global axis bounds should not be reused for this mode.

Fixed bins are not the journal default because descriptor ranges vary by
problem. A small adder and a larger multiplier can have very different natural
logic-depth and width ranges, and fixed global bounds can place most candidates
in one cell for one benchmark while spreading another benchmark too thin.

## Implementation Specification

- Add an `adaptive_grid` archive kind.
- Buffer successful descriptor samples until the warmup requirement is met.
- Before thought-only evaluation lands, warmup can use successful archiveable
  code candidates from the existing evaluator. After k-code lands, warmup should
  use successful thought representatives only.
- Compute per-axis quantiles at 25/50/75 percent.
- Convert sorted unique quantile boundaries into effective bin intervals.
- Assign every warmup success into the new grid.
- Rebuild archive contents after initial bin creation.
- Treat quantile collapse as expected behavior, not an error. For example, if
  all `ff_depth` values are `0`, that axis has one effective bin and the archive
  naturally behaves like a lower-dimensional grid for that problem.
- Cell IDs must be derived from effective bins, while artifacts must record both
  intended bins and effective bins.
- Initial multi-prompt warmup is allowed later for stronger coverage, but it
  should stay separate from the single journal mutation operator.

## Configuration

Required config:

```yaml
archive:
  kind: adaptive_grid
  bins_per_axis: 4
  warmup_successes: 20
```

`bins_per_axis` is required. The default journal plan uses `4`.
`warmup_successes` is required for reproducibility.

## Artifacts And Reporting

- `archive_space.json` records quantile boundaries and effective bin count per
  axis.
- `archive_space.json` also records intended bins per axis so collapsed axes
  are visible in reports.
- `archive_space_report.md` explains collapsed axes.
- `archive_summary.json` records warmup sample count and initialized state.
- `archive_cells.csv` uses adaptive cell IDs derived from effective bins.

## Testing Plan

- Unit-test quantile boundary calculation.
- Unit-test duplicate quantile collapse to one, two, or three effective bins.
- Unit-test cell assignment at lower, interior, and upper boundaries.
- Integration-test archive initialization from warmup samples.
- Regression-test archive-space artifacts.

## Completion Checklist

Target deadline: `2026-05-04`

- [ ] 2.1 Add new `adaptive_grid` mode with quantile-based 25/50/75
  boundaries and four bins per axis.
- [ ] 2.2 Initialize bin edges from initial warmup successful descriptor samples
  using per-axis quantiles.
- [ ] 2.3 Support quantile collapse, such as a combinational design producing
  one effective FF-depth bin, and test assignment/rebuild behavior.
