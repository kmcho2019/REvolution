# T72 Methodology

## Status

Pre-registered. Runtime support for the exact T71 descriptor axes is required
before any live vLLM spend.

## Question

T71 showed that source-aligned MasterRTL/RTL-Timer outputs produce a readable
and noncollapsed cell map over generated RTL candidates. T72 asks whether those
cells are useful when they affect live QD archive behavior, not merely
posthoc reporting.

## Method Delta

T72 keeps the T66 hard/tuning surface fixed:

- hard/tuning 13-problem subset;
- seed `1001`;
- local vLLM model `openai/gpt-oss-120b`;
- `128000` max-token and diff-token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=front_slot_lane_nsga2`;
- no bounded local repair.

T72 changes only the source of the archive cells and removes T66's inactive
two-parent fusion path:

| Field | T66 | T72 |
| --- | --- | --- |
| Descriptor profile | `fused_rtl_state_pipeline_2d` | `source_aligned_masterrtl_rtltimer_cell_2d` |
| Descriptor source | proxy Yosys graph and RTL text metrics | T69/T70 source-aligned MasterRTL and RTL-Timer extraction |
| Two-parent probability | `0.10` with gate | `0.0` |
| Archive role | front-slot parent pressure | same |

## Descriptor Definition

The proposed profile has two axes:

| Axis | Source | Definition |
| --- | --- | --- |
| `masterrtl_operator_log_edges` | MasterRTL SOG graph | `log(1 + masterrtl_graph_edges)` from the source-aligned T69/T70 path. |
| `rtltimer_state_timing_class` | RTL-Timer SOG BOG | `0` for `dff_refs=0`, `1` for `1..7`, `2` for `8..20`, and `3` for `>=21`. |

The first axis preserves T71's operator/control/dataflow scale. The second
axis preserves T71's semantically readable state/timing classes without
splitting identical zero-DFF designs by quantile rank.

## Archive Choice

Use a fixed `grid` archive for this first source-aligned test:

- `masterrtl_operator_log_edges`: 4 bins, lower bound `4.0`, upper bound `8.8`;
- `rtltimer_state_timing_class`: 4 bins, lower bound `0.0`, upper bound `4.0`.

The MasterRTL bounds include the T71 observed range
`4.330733..8.318254` with margin. If a fresh candidate lands outside these
bounds, record the out-of-range count and do not silently change the grid
after seeing outcomes.

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

Synthesis availability may be reported as provenance, but it must not be an
axis or parent-selection input.

## Comparator Surface

Use the same 13-problem hard/tuning surface as T47 through T67:

- classic comparator: T47 `classic_revolution`;
- QD controls: T51, T63, T66, and T67;
- subset: `tables/hard_tuning_subset.yaml`;
- seed: `1001`.

Do not change the subset after seeing T72 outcomes.

## Required Pre-Run Probe

Before the live run, implement the narrow runtime hook and run a descriptor
probe that proves:

- profile name resolves to the two T72 axes;
- `requires_ppa=false`;
- source-aligned extraction succeeds on the full T70 candidate table;
- descriptor values for the 19 T70 candidates reproduce the T71
  `operator_scale_bin` and `state_timing_class` assignments;
- one fresh generated candidate from the active live output path is accepted.

The probe output should be committed as:

```text
tables/descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json
```

## Required Measurements

If the live run is launched, package:

- `ppa_completeness.csv` with reference-complete headline eligibility;
- direct raw area-power PPA-front plots for all 13 problems;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts exist;
- cell occupancy and out-of-range cell counts;
- front-slot parent requests and hits;
- mean HV and HV-AUC deltas versus classic;
- valid-PPA count, aggregate front points, unique PPA points, and
  reference-beating candidates versus classic, T51, T63, T66, and T67;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples.

## Acceptance Signals

T72 can advance only if it:

- preserves every classic-covered valid-PPA design;
- uses reference-complete headline comparisons only;
- improves at least one front-material metric versus T66 or T67 without losing
  T51's valid-PPA count by more than 10 percent;
- avoids duplicate or invalid-candidate diversity claims;
- includes inspected direct PPA figures and the Phase 03.1 viewer when
  archive artifacts are available.

If the source-aligned runtime hook fails to reproduce T71's table, mark T72 as
blocked by extractor/runtime mismatch and do not spend live model budget.
