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
| `qwen_live_screen_probe_report.md` | Generated decision report. |
| `tables/qwen_live_screen_probe_summary.json` | Main collapse and variation metrics. |
| `tables/qwen_live_screen_probe_candidates.csv` | Candidate rows with canonical hashes and PCA projection axes. |
| `tables/qwen_live_screen_probe_nearest.csv` | Nearest-neighbor diagnostics. |
| `tables/qwen_live_screen_probe_axis_correlations.csv` | Simple Qwen-PCA versus PPA-gain correlations. |
| `figures/qwen_live_screen_probe.png` | PCA scatter plus nearest-neighbor collapse summary. |
