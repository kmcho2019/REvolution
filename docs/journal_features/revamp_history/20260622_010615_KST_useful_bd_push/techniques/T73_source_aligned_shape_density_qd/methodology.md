# T73 Methodology

## Status

Pre-registered. Runtime descriptor support exists and the package-local audit
shows a collapse fix, but no live vLLM run has been launched for T73 yet.

## Question

T72 proved that source-aligned MasterRTL/RTL-Timer descriptors can run end to
end in live QD search, but its fixed two-axis cell map collapsed to roughly
one occupied archive cell per problem. T73 asks whether a source-aligned,
problem-local quantile cell map can preserve more RTL implementation families
without changing the search budget.

## Method Delta

T73 inherits the T72 live surface:

| Field | T72 | T73 |
| --- | --- | --- |
| Search surface | hard/tuning 13-problem subset | same |
| Seed | `1001` | same |
| Representation | `code_individual` | same |
| Operator | `single_thought_operator` | same |
| Parent selection | `front_slot_lane_nsga2` | same |
| Two-parent probability | `0.0` | same |
| Repair | `none` | same |
| Archive type | fixed `grid` | `grid_quantile` |
| Descriptor profile | `source_aligned_masterrtl_rtltimer_cell_2d` | `source_aligned_shape_density_3d` |

The change is intentionally narrow: no new emitter, no repair, no fusion, and
no budget change.

## Descriptor Definition

All axes are derived from the same source-aligned extractor path validated by
T70 through T72.

| Axis | Source | Definition |
| --- | --- | --- |
| `source_aligned_masterrtl_branching` | MasterRTL SOG graph | `masterrtl_graph_edges / masterrtl_graph_keys`. |
| `source_aligned_rtltimer_wire_density` | RTL-Timer SOG BOG | `rtltimer_wires / rtltimer_lines`. |
| `source_aligned_rtltimer_dff_density` | RTL-Timer SOG BOG | `rtltimer_dff_refs / rtltimer_lines`. |

The extractor asserts `graph_keys > 0` and `rtltimer_lines > 0` before
forming the ratios.

## Archive Choice

Use `grid_quantile` with `qd_grid_quantile_warmup_successes=4`.

Rationale:

- T72's fixed state/timing class collapsed because all archive candidates
  fell into one state class on the live screen.
- Fixed `0..1` density bounds also underfill because the observed densities
  occupy a narrow numerical band.
- Problem-local quantile binning uses the descriptor rank structure rather
  than global hand-tuned density ranges.

The registry still contains fixed bounds so the profile can resolve under
standard grid tooling, but T73's live method is the quantile archive.

## Leakage Rules

The descriptor must not use:

- final PPA;
- reference PPA;
- fitness or best score;
- test pass rate;
- hypervolume;
- Pareto rank;
- classic results;
- problem identity.

Only source-aligned RTL structure from the candidate itself may define the
archive cell.

## Pre-Run Descriptor Audit

The audit derives T73 axes from the raw counts inside the fixed T72 run:

```text
tools/audit_t73_axes_from_t72.py
```

Measured on `233` archive events across `13` problems:

| Projection | Mean occupied cells | Minimum occupied cells |
| --- | ---: | ---: |
| T72 live fixed grid | `1.0769` | `1` |
| T73 global observed-range grid | `2.4615` | `1` |
| T73 problem-local quantile grid | `5.6923` | `2` |

This supports a live screen because the proposed axes are source-aligned,
PPA-free, and materially less collapsed under a quantile archive.

## Required Measurements

After the live run, package:

- reference-complete PPA completeness table;
- direct raw area-power PPA-front plots;
- Phase 03.1 `qd_ppa_viewer/` bundle if archive artifacts exist;
- descriptor-health summaries with occupied cells and quantile warmup status;
- parent request/hit counters;
- mean HV and HV-AUC deltas versus classic;
- valid-PPA count, Pareto points, unique PPA points, and reference-beating
  candidates versus classic, T51, T66, T67, and T72;
- classic-covered valid-PPA design losses;
- yield warnings only where the classic denominator is large enough to make
  the warning stable.

## Acceptance Signals

T73 can advance only if it:

- preserves every classic-covered valid-PPA design;
- uses reference-complete headline comparisons only;
- improves at least one front-material metric versus T72 without losing T72's
  valid-PPA coverage;
- improves or stays close to classic on HV/HV-AUC under the matched subset;
- avoids duplicate or invalid-candidate diversity claims;
- includes inspected direct PPA figures and the Phase 03.1 viewer when archive
  artifacts are available.

If T73 only increases occupied descriptor cells but loses PPA-front evidence,
mark it as `T0 diagnostic` and move the source-aligned lane toward secondary
cells or front-preserving emitter changes rather than more axis tweaks.
