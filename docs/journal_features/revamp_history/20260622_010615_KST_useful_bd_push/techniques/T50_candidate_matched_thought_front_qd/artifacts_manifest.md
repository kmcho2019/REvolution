# T50 Artifacts Manifest

Status: pre-registered; no live artifacts yet.

## Method Card

- `methodology.md`
- `commands/hard_tuning_sanity.md`
- `results_report.md`

## Planned Run Root

```text
exp/useful_bd_push/t50_candidate_matched_thought_front_<timestamp>/hard_tuning/
```

## Required Preflight Files

- `preflight/models_<timestamp>.json`
- `preflight/models_summary_<timestamp>.txt`

## Expected QD Output Root

```text
exp/useful_bd_push/t50_candidate_matched_thought_front_<timestamp>/hard_tuning/candidate_matched_thought_front_qd/seed_1001/openai_gpt-oss-120b/
```

## Planned Package

After seed `1001`, package under `hard_tuning_package/` with:

- `tables/t50_problem_seed_metrics.csv`
- `tables/t50_aggregate_metrics.csv`
- `tables/t50_comparison_deltas.csv`
- `tables/t50_validity_gates.csv`
- `tables/t50_operator_counters.csv`
- `data/t50_ppa_candidates.csv`
- `figures/t50_hv_delta_heatmap.png`
- `figures/t50_metric_delta_summary.png`
- `figures/t50_validity_funnel.png`
- `figures/t50_front_counts.png`
- `figures/t50_operator_counters.png`
- `figures/t50_direct_ppa_fronts_seed1001.png`
- `figures/visual_inspection_notes.md`

Also add T50-versus-T47/T48/T49 comparison tables after the classic/T50 package
is written. The current generalized packager compares one QD arm against
classic; QD-family comparisons are required post-package tables, not implied
third arms inside that command.

`visualizations/direct_ppa_pareto/` must contain:

- `index.html`
- `metrics.json`
- `screenshot.png`

Export `visualizations/qd_ppa_viewer/` only if the archive artifacts support an
honest Phase 03.1 export.

## Comparator Roots

- Classic:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
- T49:
  `exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning/thought_k_role_separated_repair_qd`
- T49 package:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T49_thought_k_role_separated_repair_qd/hard_tuning_package/`
- T47 package:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/hard_tuning_package/`
- T48 package:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/hard_tuning_package/`

## Notes

T50 is not a broader new descriptor. It is a controlled follow-up to determine
whether T49's front loss survives a matched evaluated-candidate budget and
wider local Pareto retention. It is not LLM-call matched unless post-run
request/token accounting proves parity.
