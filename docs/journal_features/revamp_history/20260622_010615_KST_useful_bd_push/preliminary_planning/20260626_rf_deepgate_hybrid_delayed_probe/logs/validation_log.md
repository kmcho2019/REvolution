# T96 Validation Log

Status: completed.

## Pre-Run Checks

- Branch: `feat/journal-useful-bd-exp-20260622`
- Pre-registration time: `2026-06-26T12:58:19Z`
- Workspace storage: `/workspace` has about `2.7T` available on a `27T`
  mount.
- T83 prerequisite: RF leaf-ID structural delayed QD is the closest
  single-seed pretrained/model-state screen but fails replication.
- T95 prerequisite: delayed high-exploit DeepGate improves over T94 but remains
  below classic.
- Descriptor probe passed:
  `tables/descriptor_probe_20260626_rf_deepgate_hybrid.json`.
- vLLM preflight passed:
  `openai/gpt-oss-120b`, `max_model_len=131072`.

## Live Run

- Command: [../commands/run_rf_deepgate_hybrid_delayed_probe.md](../commands/run_rf_deepgate_hybrid_delayed_probe.md)
- Run root:
  `exp/useful_bd_push/prelim_rf_deepgate_hybrid_delayed_20260626_125819_UTC/live/rf_deepgate_hybrid_delayed_8x5/seed_1001/openai_gpt-oss-120b`
- Runtime: `1484.98` seconds.
- Model preflight: `openai/gpt-oss-120b`, `max_model_len=131072`.

## Post-Run Checks

- `scripts/validate_pareto_front_run.py`: passed.
- `scripts/validate_single_thought_operator_run.py`: passed.
- `scripts/report_ppa_completeness.py`: all eight problems are `headline`.
  `valid_ppa_yield_status` flags `yield_warning` on
  `Prob015_multi_pipe_8bit` and `Prob045_alu`.
- `scripts/report_pareto_analysis.py`: completed.
- `scripts/report_ppa_distribution.py`: completed without warnings.
- `scripts/validate_qd_ppa_visualization.py --strict`: passed.

## Browser Visual Smoke

Playwright screenshot generation produced screenshots, but the scripted
browser smoke reported the same known strict-check caveats as T95:

- compare technique id `classic` is unavailable because the viewer uses the
  concrete method name `classic_revolution_8x5`;
- compare rank-guide checks did not emit both techniques for every mode;
- archive-hover clear check found no occupied archive cell target.

The retained compare screenshot is nonblank and kept as
`visualizations/qd_ppa_viewer/screenshot.png`. Strict non-browser validation
passed, and the generated screenshots are retained under
`visualizations/qd_ppa_viewer/screenshots/`.
