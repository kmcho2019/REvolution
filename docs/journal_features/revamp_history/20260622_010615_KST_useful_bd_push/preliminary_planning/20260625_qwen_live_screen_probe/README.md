# Qwen Live-Screen Candidate Probe

This package probes `Qwen/Qwen3-Embedding-0.6B` on the generated RTL candidates
from the completed preliminary `8x5` live screen.

The goal is not to claim a live QD result. The goal is to test whether the
current generated-candidate distribution looks usable for a future Qwen3
canonical-RTL live descriptor hook.

## Inputs

- Run root:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live`
- Analysis root:
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis`
- Model:
  `Qwen/Qwen3-Embedding-0.6B`
- View:
  T33-style canonical RTL.

## Contents

| Path | Purpose |
| --- | --- |
| `tools/run_qwen_live_screen_probe.py` | Probe script, run inside the isolated Qwen env. |
| `tools/plot_qwen_live_screen_probe.py` | Figure generator for the PCA/collapse summary. |
| `qwen_descriptor_profile.yaml` | Package-local live descriptor profile using the frozen Qwen projection artifact. |
| `commands/qwen_live_hook_smoke.md` | Env prep, real descriptor smoke, and bounded launch-smoke commands. |
| `qwen_live_screen_probe_report.md` | Generated decision report. |
| `tables/qwen_live_screen_probe_summary.json` | Main collapse and variation metrics. |
| `tables/qwen_live_screen_probe_candidates.csv` | Candidate rows with canonical hashes and PCA projection axes. |
| `tables/qwen_live_screen_probe_nearest.csv` | Nearest-neighbor diagnostics. |
| `tables/qwen_live_screen_probe_axis_correlations.csv` | Simple Qwen-PCA versus PPA-gain correlations. |
| `tables/qwen_projection_artifact_v0.json` | Frozen PCA projection artifact used by the live hook. |
| `tables/qwen_live_hook_smoke_summary.csv` | Bounded live-hook smoke outcomes. |
| `figures/qwen_live_screen_probe.png` | PCA scatter plus nearest-neighbor collapse summary. |

## Live-Hook Status

The live descriptor hook is implemented and smoke-tested:

- `Prob045_alu` `1x0` launched but produced no valid-PPA candidate.
- `Prob135_m2014_q6b` `2x0` produced one valid-PPA candidate and one archive
  member with Qwen descriptor values.

The matched `qwen_canonical_rtl_pca3_8x5` screen is now complete in the
encoder screening package. Qwen preserved `8/8` problem coverage but lost the
headline aggregate comparison: mean HV `0.1108` versus classic `0.1406`.
Treat the hook as valid but not promoted as-is.

The live-screen numbers are tabulated in
`../20260625_encoder_config_screening/tables/live_screen_aggregate_pareto_metrics.csv`.
The generated probe recorded a cosine max above one because the script used
float32 normalized embeddings; future regenerated probe tables clip cosine
values to `[-1, 1]`.
