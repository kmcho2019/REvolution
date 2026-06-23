# T72 Artifacts Manifest

Status: runtime descriptor gate and bounded live screen passed. No
classic-vs-QD headline result is claimed.

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Package summary and current decision. |
| `methodology.md` | Full pre-registered method card. |
| `commands/live_screen_v0.md` | Preflight, runtime-gate, live-run, validation, and packaging command templates. |
| `tables/source_aligned_descriptor_contract.json` | Machine-readable descriptor and run contract. |
| `tables/descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json` | Runtime profile probe showing no PPA, synthesis, simulation, or graph-proxy requirement. |
| `tables/source_aligned_runtime_regression.csv` | Full 19-candidate regression showing exact T70 MasterRTL edge and RTL-Timer DFF-count reproduction. |
| `tables/vllm_preflight_20260623T201737Z.json` | Raw local vLLM `/v1/models` response before live spend. |
| `tables/vllm_preflight_20260623T201737Z.txt` | One-line model summary: `openai/gpt-oss-120b max_model_len=131072 owned_by=vllm`. |
| `tables/t72_live_screen_status.csv` | Compact per-problem status from the fixed bounded live screen. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem comparator subset. |
| `tables/t72_method_matrix.csv` | Compact comparison against T51/T66/T67. |
| `tables/README.md` | Table inventory. |
| `figures/README.md` | Figure requirements; no packaged comparison figures yet. |
| `results_report.md` | Fixed live-screen result, validation status, and caveats. |
| `tools/run_t72_runtime_regression.py` | Regenerates the full T70 source-aligned runtime regression CSV. |

## Fixed Live Screen

The fixed screen ran at:

```text
exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/
```

It completed with exit status `0`, produced success summaries for all `13`
problems, and passed both run validators. The first live attempt at
`20260623_202136_UTC` is diagnostic only because it exposed the MasterRTL
shared-scratch concurrency bug fixed before the successful rerun.

## Required Future Artifacts

The execution gate is passed. The comparison and visualization package is
still missing:

| Path | Requirement |
| --- | --- |
| `tables/t72_ppa_completeness.csv` | Reference-complete comparison eligibility table. |
| `visualizations/direct_ppa_pareto/` | Static raw area-power PPA-front supplement. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 viewer if archive artifacts are generated. |

## Storage Policy

Do not place new T72 run artifacts under `/aux`. Live outputs should go under:

```text
exp/useful_bd_push/t72_source_aligned_rtl_cell_<timestamp>/
```

The committed package is documentation and small tables only.
