# Common Evaluation Contract

This file freezes the shared comparison surface for useful-BD screens. It
turns the scattered metric guidance into one operational contract for future
T100+ packages.

## Baseline Set

Every screen should use the strongest available matched baseline for the same
subset, seed, model, prompts, operators, budget, and evaluation flow.

| Role | Method Key | Required When | Purpose |
| --- | --- | --- | --- |
| Classic baseline | `classic_revolution` or `classic_revolution_8x5` | Always | Main PPA hill-climbing comparator. |
| Landing Smooth-QD/manual BD | nearest matched `landing_smooth_qd` or manual-BD run | When already available under the same surface | Historical QD comparator. |
| Random descriptor control | deterministic random/hash descriptor arm | When claiming descriptor value | Separates archive/scheduler benefit from descriptor signal. |
| Simple structural control | Yosys/simple structural descriptor arm | When testing learned or RTL-native encoders | Checks whether learned encoders beat cheap CAD features. |
| Current category representative | best current arm from `current_selection_status.md` | When replacing a lane leader | Prevents regressions inside an encoder or coupling family. |

If a baseline is missing, the package must say `not_available_same_surface` and
avoid claims that need that comparator.

## Result Row Schema

Each method package should expose one normalized CSV with one row per
`method`, `seed`, `benchmark`, and `problem`. The preferred path is:

```text
tables/method_problem_seed_metrics.csv
```

Required columns:

| Column | Meaning |
| --- | --- |
| `method_key` | Stable backend or technique key. |
| `method_family` | Lane/category such as `classic`, `sr`, `rtl_native`, `deepgate`, `aurora_raw`, or `archive_coupling`. |
| `seed` | Numeric seed. |
| `benchmark` | Benchmark suite name. |
| `problem` | Problem id. |
| `budget_shape` | `population_size x generations`, for example `8x5`. |
| `generated_count` | Total generated candidates. |
| `syntax_valid_count` | Candidates passing syntax parse. |
| `functional_count` | Candidates passing functional tests. |
| `synthesis_valid_count` | Candidates producing a mapped netlist. |
| `valid_ppa_count` | Candidates with usable area, power, and timing metrics. |
| `unique_valid_netlist_count` | Unique canonical netlists among valid-PPA candidates. |
| `pareto_point_count` | Unique valid-PPA candidates on the normalized PPA front. |
| `global_ppa_hv` | Reference-normalized PPA hypervolume for headline-complete problems. |
| `hv_auc` | Area under the HV curve when generation history is available. |
| `passive_archive_coverage` | Fraction of cells occupied in the common passive archive. |
| `passive_archive_qd_score` | Sum of nonnegative quality in the common passive archive. |
| `passive_archive_qd_auc` | QD-score AUC when generation history is available. |
| `passive_archive_coverage_auc` | Coverage AUC when generation history is available. |
| `pareto_cell_count` | Passive archive cells containing at least one PPA-front candidate. |
| `pareto_spread` | Descriptor-space spread of PPA-front candidates. |
| `unique_front_family_count` | Distinct canonical netlist, motif, or codebook families on the PPA front. |
| `reference_beating_count` | Valid-PPA candidates improving over the reference on active objectives. |
| `classic_covered` | `yes` if matched classic has at least one valid-PPA candidate. |
| `method_covered` | `yes` if this method has at least one valid-PPA candidate. |
| `reference_ppa_valid` | `yes` only when reference PPA exists and is not defaulted. |
| `comparison_status` | `headline`, `diagnostic_only`, or `missing_method_coverage`. |
| `valid_ppa_yield_status` | `pass`, `yield_warning`, `small_n`, or `diagnostic_only`. |
| `runtime_seconds` | Problem-level wall time when available. |
| `notes` | Short caveat such as missing comparator or known small-n issue. |

Do not leave required columns absent. If a metric cannot be computed on a
valid row, write `not_available` and explain why in `notes`.

## Passive Archive Contract

The passive archive is an offline audit archive. It is never used to steer the
run being evaluated.

Required properties:

- same descriptor axes, fitting corpus, cell cutoffs, and cell count for every
  compared method in one report;
- valid-PPA candidates only;
- canonical-netlist duplicate suppression before coverage or QD-score credit;
- maximize-form normalized quality, clipped at zero for QD score;
- one archive config per comparison package, recorded in
  `tables/passive_archive_config.json`;
- one row per method/problem/seed in `tables/passive_archive_metrics.csv`.

Minimum passive archive metric columns:

```text
method_key,seed,benchmark,problem,descriptor_profile,cell_count,
occupied_cell_count,passive_archive_coverage,passive_archive_qd_score,
pareto_cell_count,unique_front_family_count,pareto_spread
```

When generation history exists, add:

```text
passive_archive_qd_auc,passive_archive_coverage_auc,hv_auc
```

## Reporting Bundle

Every completed live screen should include these files or a documented
`not_available_same_surface` reason:

| Path | Purpose |
| --- | --- |
| `tables/method_problem_seed_metrics.csv` | Normalized result rows. |
| `tables/ppa_completeness.csv` | Reference and candidate-PPA comparison gate. |
| `tables/passive_archive_config.json` | Frozen passive archive definition. |
| `tables/passive_archive_metrics.csv` | Common archive metrics for all methods. |
| `analysis/pareto_analysis/report.md` | HV and PPA-front comparison. |
| `analysis/ppa_distribution/data/ppa_candidates.csv` | Raw candidate PPA rows for regeneration. |
| `visualizations/direct_ppa_pareto/` | Static paper-readable PPA-front supplement. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 viewer when archive artifacts exist. |
| `logs/visual_inspection_notes.md` | Manual visual inspection notes. |

Use `scripts/report_common_evaluation_contract.py` to generate the normalized
`tables/` rows from a Phase 03.1 viewer bundle and the run's
`ppa_completeness.csv`.

The exporter is intentionally conservative. If a method has no honest
descriptor projection in the viewer, its passive-archive columns are
`not_available` with `descriptor_projection_missing`. If canonical netlist
hashes are absent, QD score is reported at candidate level and the row is
marked `candidate_level_no_canonical_dedup`.

The current T99 package now includes normalized tables with posthoc classic
projection into the QD archive space. Its rows are still marked
`candidate_level_no_canonical_dedup`, so canonical-netlist duplicate
suppression remains a broader reporting task.

## Promotion Use

A method can be considered `T1` or higher only after the normalized schema
shows:

1. every classic-covered problem is still method-covered;
2. all headline aggregates use `reference_ppa_valid=yes`;
3. any `yield_warning` rows are explicitly discussed;
4. the method is not promoted from average fitness alone;
5. at least one primary QD/PPA metric is near-classic or positive.

The central selection table should prefer mean HV for the operational top-10,
but final promotion still requires the full schema and passive-archive metrics.
