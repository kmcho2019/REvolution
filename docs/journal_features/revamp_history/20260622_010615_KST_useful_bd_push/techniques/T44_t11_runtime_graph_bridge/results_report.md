# T44 Results Report

Status: pre-registered; one-problem smoke completed; full live result pending.

Tier: pending. The smoke is not a tier decision.

## Smoke Summary

Run root:
`exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_113144_UTC/`.

Smoke arm:
`t11_runtime_top8_smoke_qd/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/`.

The smoke completed in `42.29` seconds with model
`openai/gpt-oss-120b` and `max_model_len=131072`. It generated four initial
candidates and wrote the expected QD archive files:

- `archive_summary.json`
- `archive_space.json`
- `archive_cells.csv`
- `archive_history.jsonl`

The archive summary records descriptor profile `t11_runtime_top8_graph` and
the expected eight axes. No candidate passed functionality or synthesis-PPA,
so the archive did not initialize and the smoke cannot support any PPA claim.

## Visualization Status

- Full Phase 03.1 viewer: not present yet. The required final path is
  `visualizations/qd_ppa_viewer/`.
- Direct raw PPA supplement: not present yet. The required final path is
  `visualizations/direct_ppa_pareto/`.
- Classic projection into the QD archive: not attempted for the smoke. The
  smoke has no matched classic arm and no valid PPA candidates, so projection
  would be meaningless.
- Direct raw PPA-front figure/table: not present yet because the smoke has no
  valid PPA candidates.

The full result must follow
`../../phase_03_1_visualization_contract.md`: keep the direct raw PPA view as
the reader-facing supplement and generate the full linked archive/PPA viewer
with `scripts/export_qd_ppa_visualization.py`.

## Interpretation

The runtime bridge is wired, but it is unmeasured as a BD method. The next
step is the full three-problem live screen in `commands/live_screen_v0.md`.
That run should be compared against matched classic plus the frozen T39/T40
controls before any T44 tier is assigned.

## Required Full-Run Outputs

After full execution, this report must be replaced with:

- direct raw area-power PPA-front figure interpretation;
- validity funnel and valid-PPA yield comparison;
- global PPA HV/HV-AUC comparison;
- archive coverage/QD score and active archive readout;
- duplicate/front-family accounting when data is available;
- Phase 03.1 `qd_ppa_viewer/` location, validation status, and screenshot;
- direct `direct_ppa_pareto/` location, metric table, and screenshot;
- explicit note on whether classic candidates project honestly into the QD
  archive cells, or why projection failed;
- final `T0` to `T3` tier decision.
