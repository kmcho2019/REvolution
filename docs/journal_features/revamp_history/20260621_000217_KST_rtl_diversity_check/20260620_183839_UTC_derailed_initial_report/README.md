# Superseded Initial RTLLM-Only Report

This directory archives the derailed initial report bundle generated before the
ASP-DAC 2026 branch corpus was added to the RTL diversity check.

- Timestamp: `20260620_183839_UTC`
- Generation command:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/initial_rtllm_only_20260620_183839_UTC --qwen-real-smoke --qwen-smoke-limit 64`
- Superseded verdict: `C reconstructive`
- Superseded corpus size: 33,813 candidates total; 10,413 legacy RTLLM
  evolution-analysis candidates; 23,400 Auto-BD control candidates; 0 ASP-DAC
  candidates.
- Superseded gate state: D1 FAIL, D2 FAIL, D3 PASS, D4 NOT_RUN, D5 FAIL,
  D6 PASS.

The current authoritative result is the ASP-DAC-backed final report under
`exp/diversity_check/full_20260620/`, with verdict `B illumination_only`.
Use this archive only for audit history and for preserving the visualizations
from the incorrect RTLLM-only framing.

The raw audit dumps were not copied here to keep the documentation tree small:

- `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/candidate_audit.csv`
- `exp/diversity_check/initial_rtllm_only_20260620_183839_UTC/candidate_audit.parquet`

Archived report-facing artifacts:

- `diversity_necessity_report.md`
- `diversity_necessity_report.json`
- `implementation_gallery.md`
- Support CSV/JSON tables for gates, corpus coverage, clusters, case studies,
  encoder diagnostics, Qwen coverage, and DeepGate3 setup diagnostics.
- `figures/` with the 10 superseded visualization PNGs.
