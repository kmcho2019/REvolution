# Pareto-Front Archive: Multiobjective MAP-Elites

## Goal

Replace one elite per cell with a bounded Pareto front per cell. This makes the
journal QD archive preserve behavior diversity across cells and PPA trade-off
diversity inside each cell.

## Current State

The current archive keeps one best candidate per cell using a scalar
`quality_score`. Reports can compute Pareto fronts after a run, but archive
replacement itself is not multiobjective.

The journal runtime should make multiobjective preservation native to the
archive.

The motivation is hardware-specific: power, area, and timing are a trade-off
surface, not one natural scalar. Weighted-sum fitness makes one preference
dominate the archive and can delete designs that would be optimal under another
PPA preference. PPA islands are deferred because they split budget and add
migration policy without solving balanced trade-off preservation inside one
behavior cell.

## Implementation Specification

- Store multiple front members in each occupied cell.
- Use PPA-only dominance for archive replacement.
- Active objectives:
  - sequential tasks: maximize `g_P`, `g_A`, and `g_T`.
  - combinational tasks: maximize `g_P` and `g_A`.
- A member dominates another member when it is at least as good on every active
  objective and strictly better on at least one active objective.
- If a new member is dominated by any existing member in the cell, discard it.
- If the new member dominates existing members, remove those members.
- If the new member is non-dominated, insert it.
- Bound each cell by `max_elites_per_cell`.
- When a front exceeds the limit, evict the member with lowest crowding
  distance while preserving objective extremes.
- Parent sampling is uniform over occupied cells, then uniform over members in
  the selected cell.
- Scalar `quality_score` must not be used for Pareto replacement. It remains
  available for legacy baseline comparisons, representative-code selection in
  k-code evaluation, and post-hoc reporting.
- Re-binning must collect every Pareto member into a flat list, rebuild cell
  coordinates, and reconstruct fronts with the same dominance and crowding
  rules.

## Configuration

Required config:

```yaml
archive:
  max_elites_per_cell: 5
  objectives: ppa
```

`objectives` is intentionally fixed to `ppa` for the first journal
implementation. Success rate from k-code evaluation is stored for analysis but
does not participate in dominance.

## Artifacts And Reporting

- `archive_cells.csv` writes one row per Pareto member.
- Per-member rows include `member_index`, `front_size`, active objective values,
  `objectives_json`, representative sample ID when thought-only evaluation is
  active, and `success_rate` when available.
- `archive_summary.json` records occupied cells, total archive members, mean
  front size, max front size, and objective names.
- `qd_metrics.json` records front statistics across generations.
- Existing Pareto analysis should read archive members without assuming one row
  per cell.

## Testing Plan

- Unit-test dominance for sequential and combinational objective sets.
- Unit-test dominated insertion, dominant insertion, and non-dominated
  insertion.
- Unit-test crowding-distance eviction and objective-extreme preservation.
- Unit-test parent sampling from fronts.
- Integration-test artifact output with multiple members in one cell.

## Completion Checklist

Target deadline: `2026-05-06`

- [ ] 3.1 Replace a single archive entry per cell with bounded front members.
- [ ] 3.2 Implement PPA-only dominance over active objectives, accounting for
  combinational designs.
- [ ] 3.3 Add NSGA-II crowding-distance eviction, preserve PPA extremes, parent
  sampling from fronts, and artifact/report updates.
