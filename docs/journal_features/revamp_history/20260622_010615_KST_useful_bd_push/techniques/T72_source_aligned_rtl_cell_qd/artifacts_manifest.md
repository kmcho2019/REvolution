# T72 Artifacts Manifest

Status: runtime descriptor gate, bounded live screen, diagnostic visualization
packaging, and matched classic comparison packaging passed. Exact T72 is
`T1 near_classic_not_promoted`.

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
| `visualizations/README.md` | Visualization package index and claim caveat. |
| `visualizations/direct_ppa_pareto/` | Static PPA plots, raw CSVs, summary JSON, and compact HTML index. |
| `visualizations/qd_ppa_viewer/` | Phase 03.1 viewer bundle for single-method T72 archive/PPA inspection. |
| `matched_classic_comparison/` | Reference-complete matched classic-vs-T72 comparison package. |
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

## Matched Comparison

The comparison package is compact and committed locally. The full generated
final-analysis scratch output remains under:

```text
exp/useful_bd_push/t72_matched_classic_comparison_20260623_213900_UTC/final_analysis
```

Do not promote exact T72: the matched result preserves design coverage and is
near-classic on mean HV, but classic wins the primary front-breadth metrics.

## Storage Policy

Do not place new T72 run artifacts under `/aux`. Live outputs should go under:

```text
exp/useful_bd_push/t72_source_aligned_rtl_cell_<timestamp>/
```

The committed package is documentation and small tables only.
