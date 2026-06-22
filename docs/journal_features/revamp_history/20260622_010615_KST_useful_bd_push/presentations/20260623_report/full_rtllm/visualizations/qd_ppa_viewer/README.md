# Full RTLLM Phase 03.1 Viewer

This directory contains the full Phase 03.1 archive/PPA viewer for the
one-seed RTLLM milestone.

Open `index.html` to inspect the linked archive and PPA/Pareto views.

## Scope

- Full milestone benchmark: `50` RTLLM manifest problems.
- Viewer scope: `37` RTLLM problems with at least one valid PPA candidate.
- Omitted from the viewer because both arms had zero valid PPA candidates:
  `Prob006_adder_pipe_64bit`, `Prob014_multi_pipe_4bit`,
  `Prob016_fixed_point_adder`, `Prob017_fixed_point_substractor`,
  `Prob022_ring_counter`, `Prob026_asyn_fifo`, `Prob028_LFSR`,
  `Prob032_freq_divbyeven`, `Prob033_freq_divbyfrac`,
  `Prob034_freq_divbyodd`, `Prob038_pulse_detect`,
  `Prob042_width_8to16`, and `Prob046_clkgenerator`.

The aggregate 50-problem result remains in `../../README.md` and
`../../tables/`. This viewer is the PPA/Pareto inspection surface for the
candidate-producing subset.

## Projection

Classic candidates were projected honestly into the exact T26 SR-PCA archive
using the frozen SR raw PCA artifact:

`docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/fitting_artifacts/sr_raw_pca_dev_seed1001/sr_raw_pca_artifact.json`

Descriptor hash:

`931edf18e9ec5e3a7b2b8d7996c603c64ec82619f6185ea44cf4803e6105ee1b`

Projection coverage:

- classic rows: `352`
- projected rows: `352`
- failed rows: `0`
- source: `code.syn.v`

## Validation

Strict validator status: `passed`.

Command:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/rtllm_valid_ppa_viewer_subset.yaml \
  --strict \
  --playwright
```

Primary inspected screenshots:

- `screenshot.png`: compare-mode archive/PPA view.
- `screenshots/raw_area_power_front.png`: raw area-power front view.
- `visual_parity_report.md`: Playwright visual parity notes.
