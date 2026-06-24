# T79 Phase 03.1 QD/PPA Viewers

This directory contains one Phase 03.1-compatible viewer per matched T79 QD
budget shape:

- `12x3/`
- `8x5/`
- `6x7/`

Each viewer compares the matched classic arm against the T75
`shape_density_front_pressure_qd` arm for the same budget shape. All three
viewer bundles passed strict schema validation with
`scripts/validate_qd_ppa_visualization.py --strict`.

Non-strict Playwright render smoke produced screenshots for each shape. The
tracked package keeps the compare-mode render as `screenshot.png` in each
viewer directory. Strict Playwright interaction validation did not fully pass
because the checker expects the built-in `RTLLM/Prob004_adder_8bit` validation
problem and several hover checks assume denser archive cells than the T79
subset provides.
