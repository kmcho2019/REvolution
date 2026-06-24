# Visual Inspection Notes

Date: 2026-06-24 UTC.

## Summary Figures

- `t73_hv_delta_by_problem.png`: readable at full width. The zero line,
  green positive bars, and red negative bars make the dominant traffic-light
  loss and the ALU win clear.
- `t73_valid_ppa_counts.png`: readable at full width. The grouped bars show
  T73's valid-PPA yield gain without hiding losses on `Prob098` and
  `Prob150`.

## Representative PPA Panels

- `rtllm_prob045_alu_gain_power_area.png`: readable side-by-side classic/T73
  comparison; T73's larger valid sample set and stronger area gain are clear.
- `rtllm_prob041_traffic_gain_power_area.png`: selected as the main negative
  case; useful for explaining why aggregate HV is not promoted.
- `rtllm_prob015_pipe_gain_power_period.png`: useful caveat for front breadth.
- `verilogeval_prob153_gshare_gain_power_period.png`: useful sequential
  positive case.

## Phase 03.1 Viewer

`visualizations/qd_ppa_viewer/screenshot.png` was opened after capture. The
viewer is nonblank, compare mode is visible, both archive panes render, the
PPA pane renders samples/reference, and controls are legible. Strict
non-Playwright validation passes. Browser hover validation still reports known
interactive bridge caveats; see `playwright_caveat.md`.
