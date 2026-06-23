# T49 Artifacts Manifest

Status: seed `1001` launched; completion artifacts are not packaged yet.

## Method Card

- `methodology.md`
- `commands/hard_tuning_sanity.md`
- `results_report.md`

## Planned Run Root

```text
exp/useful_bd_push/t49_thought_k_role_separated_repair_<timestamp>/hard_tuning/
```

## Active Seed 1001 Root

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

## Planned Output Contract

After the first live seed, this package must contain:

- `tables/t49_problem_seed_metrics.csv`
- `tables/t49_comparison_deltas.csv`
- `tables/t49_validity_gates.csv`
- `tables/t49_repair_counters.csv`
- `data/t49_ppa_candidates.csv`
- `figures/t49_metric_delta_summary.png`
- `figures/t49_validity_funnel.png`
- `figures/t49_direct_ppa_fronts_seed1001.png`
- `figures/visual_inspection_notes.md`
- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/metrics.json`
- `visualizations/direct_ppa_pareto/screenshot.png`
- `visualizations/qd_ppa_viewer/index.html`, if archive artifacts are usable;
- `visualizations/qd_ppa_viewer/validation.json`, if the viewer is exported.

## Comparator Roots

- Classic:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
- T48:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd`

## Notes

Do not claim a tier above `T0` until the package includes matched metrics,
direct raw-PPA figures, repair accounting, and a visual inspection note.
