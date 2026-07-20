# H5 Telemetry Schema

Status: `FROZEN_BEFORE_LIVE_EVIDENCE`, revision 2, 2026-07-20. Revision 2
clarifies fresh-control and stopped-row handling after the pre-smoke evidence
audit; it does not change an outcome gate.

The schema supports one causal question: does routing all failed-parent requests
through M-F create more direct valid-PPA repairs at the same 48-candidate
problem budget? It does not assign downstream HV credit to a lineage.

## Candidate Records

Every generated-candidate row in `generation_log.jsonl` must contain:

| Field | Meaning |
| --- | --- |
| `id` | Unique child ID. |
| `parent_ids` | Exact parent IDs; an empty list is valid only for generation 0. |
| `origin_pool` | `initial`, `fail_pool`, or `success_pool`. |
| `strategy` | Exact EoH operator. |
| `status` | Existing terminal evaluation status. |
| `rtl_simulation_success` | Child passed syntax and RTL simulation. |
| `synthesis_success` | Child passed synthesis. |
| `post_synthesis_functionality_success` | Synthesized child passed the configured post-synthesis check. |
| `ppa_success` | Child produced valid PPA and entered Success. |
| `code_file_path` | Existing candidate artifact path. |

`population_ppa_details` remains the source for successful-child score and PPA
metrics. Candidate and parent stages are joined by ID; no probabilistic ancestry
or fractional descendant credit is computed.

## Stage Derivation

Stage is derived exhaustively from status and booleans:

| Terminal condition | Furthest completed stage |
| --- | --- |
| `failed_format` or `failed_diff` | generation format |
| `failed_syntax` | format |
| `failed_functionality` | syntax |
| `failed_synthesis` and `synthesis_success=false` | RTL simulation |
| `failed_synthesis_functionality` | synthesis |
| `failed_synthesis` and synthesis/post-synthesis true, `ppa_success=false` | post-synthesis functionality |
| `success` with all booleans true | valid PPA |

Unknown combinations fail report generation.

## Pool Records

`failed_parent_repair_pool_telemetry.jsonl` contains one row per evolutionary
generation:

| Field | Meaning |
| --- | --- |
| `generation` | One-based generation index. |
| `pre_selection_fail_pool_size` | Failed-parent pool before offspring generation. |
| `pre_selection_success_pool_size` | Successful-parent pool before offspring generation. |
| `post_selection_fail_pool_size` | Failed pool after survivor selection. |
| `post_selection_success_pool_size` | Success pool after survivor selection. |
| `generation_outcome` | `completed` or `stop`. |

The experimental subclass writes this row around the inherited generation
method. It introduces no persistent policy state.

For `generation_outcome=stop`, inherited REvolution returns before survivor
selection. The two post-selection sizes therefore repeat the pre-selection
sizes. A completed-stage report rejects stopped rows; an interrupted artifact
cannot satisfy a mechanism gate.

All H5 stages use fresh instrumented classic controls. Historical classic logs
that predate the candidate fields may support baseline context but cannot enter
the H5 mechanism report or parent-stage joins.

## Frozen Estimands

For each problem-seed unit:

- primary mechanism value: count of rows with `origin_pool=fail_pool` and
  `ppa_success=true`, divided by the fixed 48-candidate budget;
- paired mechanism delta: H5 value minus matched-classic value;
- diagnostic conditional valid-PPA yield: direct valid-PPA repairs divided by
  failed-parent requests;
- diagnostic RTL-simulation repair count and conditional yield;
- diagnostic first direct valid-PPA repair generation, recovered-design
  indicator, and pre/post pool-size trajectory.

Development benefit requires the mean paired primary mechanism delta to be
strictly positive in seed 1001 and independently in seed 1002. Confirmation
requires a strictly positive mean paired delta over all fresh problem-seed
units, exact M-F-only activation, and every separate final-HV/coverage gate in
the H5 card. Confidence intervals and per-seed sensitivity are always reported;
an interval crossing zero supports observed, not statistically resolved, uplift.
