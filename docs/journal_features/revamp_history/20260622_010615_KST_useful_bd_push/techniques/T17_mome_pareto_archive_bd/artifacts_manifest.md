# MOME Pareto Archive BD Artifacts Manifest

## Run Identity

- Technique: `T17_mome_pareto_archive_bd`
- Result tier: `T0 diagnostic`
- Audit type: passive local-Pareto retention audit
- Local generated run root:
  `exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/`
- Source evidence root: `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/development_preliminary_seed1/`
- `/aux` policy: read-only source evidence; no generated T17 files were written
  under `/aux`.

## Regeneration Command

```bash
.venv/bin/python scripts/package_useful_bd_mome_pareto_audit.py \
  --central-json exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json \
  --technique-dir exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC \
  --repo-root /workspace \
  --capacity 4
```

The committed technique package mirrors the generated `tables/*.csv` and
`figures/*.png` files from that local run root.

## Source Hashes

`tables/source_manifest.csv` records the SHA-256 hashes for every source
`candidates.parquet`, `method_summary.json`, and `run_manifest.json` used by the
audit.

## Generated Tables

- `tables/source_manifest.csv`
- `tables/aggregate.csv`
- `tables/deltas.csv`
- `tables/problem_metrics.csv`
- `tables/retained_candidates.csv`

## Generated Figures

- `figures/mome_retention_hypervolume.png`
- `figures/mome_global_pareto_points.png`
- `figures/mome_vs_scalar_deltas.png`
- `figures/mome_retained_candidates_heatmap.png`

## Validation

- `pytest tests/scripts/test_package_useful_bd_mome_pareto_audit.py`
- `ruff check scripts/package_useful_bd_mome_pareto_audit.py tests/scripts/test_package_useful_bd_mome_pareto_audit.py`
- `pyright --pythonpath .venv/bin/python scripts/package_useful_bd_mome_pareto_audit.py tests/scripts/test_package_useful_bd_mome_pareto_audit.py`
- `uv tool run ty check scripts/package_useful_bd_mome_pareto_audit.py tests/scripts/test_package_useful_bd_mome_pareto_audit.py`
