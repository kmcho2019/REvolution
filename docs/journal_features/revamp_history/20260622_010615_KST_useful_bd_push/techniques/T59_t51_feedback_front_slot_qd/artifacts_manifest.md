# T59 Artifacts Manifest

Status: pre-registered; no run artifacts yet.

## Planned Raw Run

- Planned QD root:
  `exp/useful_bd_push/t59_t51_feedback_front_slot_${RUN_TS}/hard_tuning/t51_feedback_front_slot_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Primary T51 comparator root:
  `exp/useful_bd_push/t51_code_thought_front_slot_20260623_025906_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001`
- T54 front-slot comparator root:
  `exp/useful_bd_push/t54_front_slot_lane_20260623_061648_UTC/hard_tuning/front_slot_lane_qd/seed_1001`
- T58 learned-geometry comparator root:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001`
- Descriptor file:
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml`
- vLLM endpoint:
  `http://20.0.0.103:8000/v1/models`
- Required model:
  `openai/gpt-oss-120b max_model_len=131072`

## Planned Package

After the run, package:

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t59_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t59_aggregate_metrics.csv`
- `hard_tuning_package/tables/t59_comparison_deltas.csv`
- `hard_tuning_package/tables/t59_validity_gates.csv`
- `hard_tuning_package/tables/t59_operator_counters.csv`
- `hard_tuning_package/data/t59_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Planned Visualizations

T59 must include both visualization bundles if archive artifacts are produced:

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with the full Phase 03.1 export,
  validation files, screenshot matrix, representative screenshot, and any
  honest projection caveat.

## Validation

Before assigning a tier, run:

- `scripts/validate_single_thought_operator_run.py --require-full-subset`;
- `scripts/validate_pareto_front_run.py --require-full-subset`;
- `scripts/validate_qd_ppa_visualization.py --strict` after viewer export;
- visual inspection of the direct PPA screenshot and full viewer screenshot.

## Anti-Gaming Notes

- T59 is same-budget: `population_size=12`, `num_generations=3`, and no
  bounded repair loop.
- `qd_operator_fail_feedback_chars=600` is failure-stage/evaluator-feedback
  context only. It is not a descriptor input and must not include PPA labels.
- The hard/tuning subset is frozen before launch.
