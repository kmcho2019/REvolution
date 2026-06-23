# T72 Tables

| Table | Purpose |
| --- | --- |
| `source_aligned_descriptor_contract.json` | Machine-readable descriptor, run, and leakage contract for the T72 pre-registration. |
| `descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json` | Runtime profile probe; confirms source-aligned axes and no PPA/synthesis/simulation requirement. |
| `source_aligned_runtime_regression.csv` | Real external-flow regression against all 19 T70 generated candidates. |
| `vllm_preflight_20260623T201737Z.json` | Raw `/v1/models` response from the local vLLM endpoint. |
| `vllm_preflight_20260623T201737Z.txt` | Human-readable model summary confirming `openai/gpt-oss-120b max_model_len=131072`. |
| `hard_tuning_subset.yaml` | Frozen 13-problem comparator surface reused from T47 through T67. |
| `t72_method_matrix.csv` | Compact delta from T51, T66, and T67 controls. |

Future tables must include the PPA completeness table, parent counters, and
final metric summaries once a live run exists.

Regenerate `source_aligned_runtime_regression.csv` with:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tools/run_t72_runtime_regression.py
```
