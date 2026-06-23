# T70 Artifacts Manifest

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `tools/run_t70_extractor_smoke.py` | Deterministic runner for candidate selection, extraction, tables, and figures. |
| `tables/t70_candidate_manifest.csv` | Selected candidate paths, top modules, hashes, and synthesis-stratification labels. |
| `tables/t70_extractor_results.csv` | Per-candidate extractor pass/fail and artifact-size metrics. |
| `tables/t70_extractor_summary.csv` | Pass-count summary by candidate group. |
| `tables/t70_extractor_metrics.json` | Machine-readable source root, output root, pass counts, and byte count. |
| `figures/t70_generated_rtl_extractor_smoke.png` | Parse pass-rate figure. |
| `figures/t70_extractor_richness_by_candidate.png` | MasterRTL edge and RTL-Timer DFF-reference figure. |

## Local Generated Artifacts

Local output root:

`exp/verification/t70_generated_rtl_extractor_smoke`

The generated directory is intentionally under `exp/verification`, not `/aux`.
It is about `6.7M` on disk and contains per-candidate:

- MasterRTL generated SOG Verilog;
- cleaned MasterRTL SOG Verilog;
- upstream `analyze.py` graph and node-dictionary pickles;
- RTL-Timer generated SOG BOG Verilog;
- cleaned RTL-Timer SOG BOG Verilog;
- stdout, stderr, and return-code logs for each command.

## Source Inputs

| Source | Path |
| --- | --- |
| Candidate RTL | `exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/.../RTLLM` |
| MasterRTL parser | `exp/external_repos/MasterRTL/vlg2ir/analyze.py` |
| MasterRTL isolated env | `exp/venvs/rtl_native_verify/bin/python` |
| RTL-Timer Liberty | `exp/external_repos/RTL-Timer/vlg2bog/scr_ys/lib/nangate45_sog.lib` |

## Regeneration

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tools/run_t70_extractor_smoke.py
```
