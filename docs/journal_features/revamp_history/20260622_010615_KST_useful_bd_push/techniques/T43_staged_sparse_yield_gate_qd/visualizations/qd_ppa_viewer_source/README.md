# T43 QD/PPA Viewer Source

This directory contains the minimal committed source CSVs used to regenerate
`../qd_ppa_viewer/`.

Files:

- `final_analysis/ppa_distribution/data/ppa_candidates.csv`
- `final_analysis/ppa_distribution/data/reference_ppa_metrics.csv`
- `final_analysis/design_space_analysis/successful_candidates.csv`

The source was generated from the live T43 run with the baseline aliased as
`classic` for Phase 03.1 viewer compatibility:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic=exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC/classic_revolution/seed_1001 \
  --backend_run staged_sparse_yield_gate_qd=exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC/staged_sparse_yield_gate_qd/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T43_staged_sparse_yield_gate_qd/tables/live_screen_v0_subset.yaml \
  --output-dir exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC/qd_ppa_viewer_source/final_analysis
```

Only the three source CSVs are committed here; the larger generated report
bundle remains under `exp/`.
