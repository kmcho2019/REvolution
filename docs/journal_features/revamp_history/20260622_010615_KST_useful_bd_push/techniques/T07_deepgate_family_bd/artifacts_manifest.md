# T07 DeepGate-Family BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

Reproduction command:

```bash
uv run python scripts/analyze_t07_deepgate_surrogate.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

Detailed command and validation notes: `commands/replay_v0.md`.

## Inputs

- Candidate table:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Synthesized netlists are referenced by the candidate table's `netlist_path`
  column.
- Prior dependency evidence is summarized in `tables/dependency_status.csv`.

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/archive_metrics.csv` | 8 | `5c5fc9ab4cb2d0dbc2b9b282a6e1840a6e1d59a85017965cd1d393f6f9f9d03f` |
| `tables/collapse_diagnostics.csv` | 4 | `d3e31e0f4fd44d45dfe3c415072f597ee0c933c33ae09e8543a7ed35622f6426` |
| `tables/dependency_status.csv` | 5 | `d74c76bef997900e4c054ce6ddf6c97af104eb73993736e00b5545fb9c014a2d` |
| `tables/netlist_graph_manifest.csv` | 769 | `5f7646478bd01baac354d4cc40e219d653e2b3955debd9b847c75c12f3559a3e` |
| `tables/ppa_comparison.csv` | 8 | `eb0a29a7ea95b21f0a4fbf15cf1a075b68abe9eddcfe4db59a623ccc7ba8d939` |
| `tables/ppa_front_metrics.csv` | 8 | `762a75ae0b8314ff99977f5a795add917fa1da5c521a5b66def2e56febd397bf` |
| `tables/ppa_front_plot_points.csv` | 61 | `09ce693464e08267ac3601d499f935942a94004137039e92d1f6ff0994ecee5b` |
| `tables/replay_rows.csv` | 799 | `b738d580480ce0b328f9ced23457253188f69fa61b112cf2f6859a9eabb54328` |
| `tables/selected_candidates.csv` | 2388 | `5735468caed641693b58ab18e4dc5ccd53a2b5fc3d90954d7d2606d7e67a1e8d` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/deepgate_multi_problem_ppa_pareto_fronts.png` | `278542d6cc4d009c3d3e1c5b75f210f20c6c9719a545299c85b3242e90eb9158` |
| `figures/deepgate_raw_area_power_pareto_front.png` | `db2f6a8158d4b85c708eaf9299878bd38dbba99d69816210415ac75950cad2f7` |
| `figures/deepgate_surrogate_hypervolume.png` | `861cfe14579d508e474969e15640793cd49103c76a1be585e6c162aac7ed9fa8` |
| `figures/deepgate_projection.png` | `4f993031891905e5389b1d6b1ff42dcffc3ea55a174983c79a4ed872c6f13f8d` |
| `figures/graph_size_vs_embedding.png` | `14f4ac8d831e88decdf0f97240ba02820d0adf72e7949ca2cc9c56e10b1851d1` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t07_deepgate_surrogate.py` | `179ea3e3e363888241c1be56a162ccfa5e499d6aa9bb120e3e385a23fb7a3bf2` |
| `tests/scripts/test_analyze_t07_deepgate_surrogate.py` | `ca13cac3321713719eae97fcf188c492aefd005221635b6e4c9f7e1da72998e2` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t07_deepgate_surrogate.py`
- `uv run ruff check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`
- `uv run python -m pyright scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`
- `uv tool run ty check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`

All four passed after adding the direct PPA-front outputs.
