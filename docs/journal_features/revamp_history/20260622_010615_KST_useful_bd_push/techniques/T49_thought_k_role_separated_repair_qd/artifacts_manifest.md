# T49 Artifacts Manifest

Status: seed `1001` completed, packaged, and visually inspected.

## Method Card

- `methodology.md`
- `commands/hard_tuning_sanity.md`
- `results_report.md`

## Seed 1001 Root

```text
exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning/
```

Preflight files:

- `preflight/models_20260623_003408_UTC.json`
- `preflight/models_summary_20260623_003408_UTC.txt`

QD output root:

```text
exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning/thought_k_role_separated_repair_qd/seed_1001/openai_gpt-oss-120b/
```

Completed run files:

- `20260623_003433_revolution_summary_results.txt`
- `20260623_003433_revolution_scheduler_telemetry.json`
- `20260623_003433_revolution_run_log.txt`

## Packaged Output Contract

`hard_tuning_package/` contains:

- `tables/t49_problem_seed_metrics.csv`
- `tables/t49_aggregate_metrics.csv`
- `tables/t49_comparison_deltas.csv`
- `tables/t49_validity_gates.csv`
- `tables/t49_operator_counters.csv`
- `data/t49_ppa_candidates.csv`
- `figures/t49_hv_delta_heatmap.png`
- `figures/t49_metric_delta_summary.png`
- `figures/t49_validity_funnel.png`
- `figures/t49_front_counts.png`
- `figures/t49_operator_counters.png`
- `figures/t49_direct_ppa_fronts_seed1001.png`
- `figures/visual_inspection_notes.md`

`visualizations/direct_ppa_pareto/` contains:

- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/metrics.json`
- `visualizations/direct_ppa_pareto/screenshot.png`

The Phase 03.1 viewer was not exported for this hard/tuning screen package.
If T49 or a descendant advances to a larger archive-backed run, export
`visualizations/qd_ppa_viewer/` from that run rather than treating this direct
PPA supplement as a substitute.

## Comparator Roots

- Classic:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
- T48:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd`

## Notes

The package supports only a `T0 mixed_diagnostic` claim. It preserves
classic-covered valid-PPA coverage but loses mean HV and front coverage.
