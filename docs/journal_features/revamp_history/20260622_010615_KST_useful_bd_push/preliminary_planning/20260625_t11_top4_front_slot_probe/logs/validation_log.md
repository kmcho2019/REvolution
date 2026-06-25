# T11 Top-4 Front-Slot Validation Log

## Run Completion

- Live run completed `8/8` problems.
- Total runtime: `1691.70s`.
- Summary:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001/openai_gpt-oss-120b/20260625_200436_revolution_summary_results.txt`.
- Scheduler telemetry:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001/openai_gpt-oss-120b/20260625_200436_revolution_scheduler_telemetry.json`.

## Focused Validators

Both commands exited successfully with no diagnostics:

- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`

## Analysis Caveat

`scripts/report_final_analysis_bundle.py` wrote the completed Pareto, PPA
distribution, hard-iteration, backend comparison, and evolutionary report
sections, then stalled in source-aligned design-space feature recovery. The
process was interrupted there. This package uses the completed report sections.

## Visual Inspection

- `figures/mean_hv_by_backend.png` clearly shows classic ahead of all QD arms.
- `figures/t11_top4_front_slot_hv_delta.png` clearly shows the two large
  losses on `Prob041_traffic_light` and `Prob045_alu`.
- Near-zero bars are intentionally unlabeled to keep the figure readable.
