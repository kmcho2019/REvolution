# T50 Artifacts Manifest

Status: seed `1001` partial 12-problem screen packaged.

## Method Card

- `methodology.md`
- `commands/hard_tuning_sanity.md`
- `results_report.md`

## Run Root

```text
exp/useful_bd_push/t50_candidate_matched_thought_front_20260623_020738_UTC/hard_tuning/
```

## Preflight Files

- `preflight/models_20260623_020738_UTC.json`
- `preflight/models_summary_20260623_020738_UTC.txt`

## QD Output Root

```text
exp/useful_bd_push/t50_candidate_matched_thought_front_20260623_020738_UTC/hard_tuning/candidate_matched_thought_front_qd/seed_1001/openai_gpt-oss-120b/
```

`Prob153_gshare` did not produce a problem directory, so the committed package
uses the 12 completed problems and labels the result as partial.

## Package

Packaged under `hard_tuning_package/` with:

- `tables/t50_problem_seed_metrics.csv`
- `tables/t50_aggregate_metrics.csv`
- `tables/t50_comparison_deltas.csv`
- `tables/t50_validity_gates.csv`
- `tables/t50_operator_counters.csv`
- `tables/t50_family_comparison_12_problem_subset.csv`
- `tables/t50_family_deltas_12_problem_subset.csv`
- `data/t50_ppa_candidates.csv`
- `figures/t50_hv_delta_heatmap.png`
- `figures/t50_metric_delta_summary.png`
- `figures/t50_validity_funnel.png`
- `figures/t50_front_counts.png`
- `figures/t50_operator_counters.png`
- `figures/t50_direct_ppa_fronts_seed1001.png`
- `figures/visual_inspection_notes.md`

`visualizations/direct_ppa_pareto/` must contain:

- `index.html`
- `metrics.json`
- `screenshot.png`

`visualizations/qd_ppa_viewer/` is omitted because the run is incomplete and
missed final summary artifacts.

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
