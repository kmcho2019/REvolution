# T63 Artifacts Manifest

Status: seed `1001` hard/tuning package complete.

## Raw Run

- QD root:
  `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Primary T51 comparator table:
  `hard_tuning_package/tables/t63_vs_t51_deltas.csv`
- vLLM endpoint:
  `http://20.0.0.103:8000/v1/models`
- Required model:
  `openai/gpt-oss-120b max_model_len=131072`

## Package

| Path | Purpose |
| --- | --- |
| `methodology.md` | Pre-registered live-screen method card. |
| `results_report.md` | Completed result and tier decision. |
| `commands/hard_tuning_sanity.md` | Descriptor probe, preflight, and run command. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem hard/tuning comparator surface. |
| `tables/descriptor_probe_fused_rtl_state_pipeline_2d.json` | PPA-free graph-plus-RTL descriptor profile probe. |
| `hard_tuning_package/README.md` | Packaged metric summary. |
| `hard_tuning_package/tables/t63_ppa_completeness.csv` | Reference-complete comparison eligibility table. |
| `hard_tuning_package/tables/t63_vs_t51_deltas.csv` | T63 versus T51 lineage comparison. |
| `hard_tuning_package/data/t63_ppa_candidates.csv` | Candidate-level PPA rows used for figures. |
| `hard_tuning_package/figures/` | Generated summary and PPA-front figures. |
| `tables/README.md` | Table guide. |
| `figures/README.md` | Figure guide. |

## Visualizations

| Path | Purpose |
| --- | --- |
| `visualizations/direct_ppa_pareto/` | Direct raw PPA-front supplement with screenshot. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 linked archive/PPA viewer. |
| `visualizations/qd_ppa_viewer_source/final_analysis/` | Source analysis bundle for the viewer export. |

## Validation

- `scripts/validate_single_thought_operator_run.py --require-full-subset`:
  passed.
- `scripts/validate_pareto_front_run.py --require-full-subset`: passed.
- `scripts/validate_qd_ppa_visualization.py --strict`: passed.
- Playwright generated screenshots but returned two compare-guide debug-hook
  errors, documented in `visualizations/qd_ppa_viewer/playwright_caveat.md`.
