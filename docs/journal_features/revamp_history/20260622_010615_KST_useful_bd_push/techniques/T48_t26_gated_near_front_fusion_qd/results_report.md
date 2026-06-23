# T48 Gated Near-Front Fusion Results

Status: two-seed hard/tuning screen packaged. Tier decision:
`T0 diagnostic`.

T48 seed `1001` was launched at run root:

`exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`

The run passed the in-command vLLM preflight for `openai/gpt-oss-120b` with
`max_model_len=131072` and completed `13/13` problems with exit code `0`.
Total runtime was `1572.27` seconds.

Preliminary seed-1001 readout:

- summary best-status count: `11` success, `2` failed;
- QD artifact coverage: `13/13` `archive_summary.json` and `13/13`
  `qd_metrics.json`;
- global PPA-front coverage: `13/13`, including the two summary-level failed
  problems;
- summary best-score comparison versus T47 classic seed `1001`: `3` wins,
  `3` losses, `5` ties, and `2` missing summary best scores;
- total archive members: `65`;
- total global Pareto candidates: `25`;
- two-parent attempts: `21`;
- near-front gate attempts: `6`;
- near-front gate accepts: `5`;
- near-front gate rejects: `1`;
- one-parent fallbacks after two-parent requests: `16`.

The two summary-level failures need package-level handling rather than a
simple failure label. `Prob024_fsm` has two global-Pareto PPA candidates and
matches the T47 classic best score. `Prob151_review2015_fsm` has one
global-Pareto PPA candidate, but its best quality is worse than the T47
classic seed-1001 best score.

Seed `1002` completed with exit code `0` after `1593.16` seconds. It produced
`13/13` problem summaries, `13/13` `archive_summary.json` files, and `13/13`
`qd_metrics.json` files.

The paired package is:

`hard_tuning_package/`

Key files:

- `hard_tuning_package/README.md`;
- `hard_tuning_package/tables/t48_problem_seed_metrics.csv`;
- `hard_tuning_package/tables/t48_aggregate_metrics.csv`;
- `hard_tuning_package/tables/t48_comparison_deltas.csv`;
- `hard_tuning_package/tables/t48_validity_gates.csv`;
- `hard_tuning_package/tables/t48_gate_counters.csv`;
- `hard_tuning_package/data/t48_ppa_candidates.csv`;
- `hard_tuning_package/figures/t48_metric_delta_summary.png`;
- `hard_tuning_package/figures/t48_direct_ppa_fronts_seed1001.png`;
- `hard_tuning_package/figures/t48_direct_ppa_fronts_seed1002.png`.

T48 was implemented because T47 exact T26 was diagnostic but not
held-out-ready:

- mean HV delta: `-0.015483`;
- mean HV-AUC delta: `-0.018435`;
- mean best-score delta: `+0.024728`;
- valid-PPA candidates: `428` versus `538`;
- aggregate PPA-front points: `53` versus `61`;
- classic-covered valid-PPA losses: `0`;
- yield warnings: `4`.

## Planned Decision

The package assigns `T0 diagnostic`, not a held-out candidate.

T48 improves over T47 exact T26 on some secondary diagnostics: it has fewer
yield warnings than T47 (`3` versus `4`), more valid-PPA candidates than T47
QD (`452` versus `428`), and a less negative mean HV/HV-AUC delta. It also
keeps a small positive mean best-score delta versus classic.

However, it still loses to classic on the primary QD evidence:

- mean HV delta: `-0.010183` (`-9.5%`);
- mean HV-AUC delta: `-0.015628` (`-17.9%`);
- valid-PPA count: `452` versus `538` (`-16.0%`);
- aggregate PPA-front points: `51` versus `61` (`-16.4%`);
- unique PPA points: `148` versus `203` (`-27.1%`);
- reference-beating count: `69` versus `112` (`-38.4%`);
- yield warnings: `3`.

The valid-PPA warnings occur where classic has enough samples for the warning
to matter:

- seed `1001`, `Prob024_fsm`: `6` T48 valid-PPA candidates versus `16`
  classic;
- seed `1002`, `Prob024_fsm`: `4` versus `18`;
- seed `1002`, `Prob041_traffic_light`: `9` versus `21`.

The conclusion is that near-front gated fusion is a useful diagnostic
mitigation, but not enough to justify a full RTLLM launch. The next variant
should keep the gate only if it also adds a stronger valid-PPA yield floor or
uses accepted two-parent fusion as a rare archive-local mutation, not as a
general exploration path.

## Visualization Status

Full Phase 03.1 viewer:

`visualizations/qd_ppa_viewer/`

The viewer was exported for seed `1002` with the baseline aliased as
`classic`. Non-strict validation passes. Strict validation fails because
classic candidates do not have honest `sr_pca_0/1/2` descriptor projections;
descriptor recovery cannot reconstruct the learned SR-PCA coordinates from
raw RTL/graph metrics. The viewer should therefore be used for QD archive
inspection and paired PPA browsing, not for claims about classic archive-cell
occupancy.

Direct reader-facing PPA supplement:

`visualizations/direct_ppa_pareto/index.html`

The direct plots were manually inspected after regeneration. The aggregate
metric summary, heatmap, validity funnel, and seed-level area-power panels are
readable and consistent with the package tables.

## Decision Rule Reference

The planned decision was:

- `T0 diagnostic` if T48 repeats T47's HV/HV-AUC or yield losses;
- `T1 near_classic` if it improves T47 on HV/HV-AUC or front points while
  preserving classic-covered designs and avoiding additional yield warnings;
- `T2 validation_candidate` only after direct PPA-front figures, candidate raw
  data, and gate-counter tables show that the win is not a denominator trick.

T48 does improve part of the T47 signal, but still has three large valid-PPA
yield warnings and negative aggregate HV/HV-AUC/front evidence versus classic.
That fails the active goal's T1+ guardrail.
