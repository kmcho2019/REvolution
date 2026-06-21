# SR Pareto Validation Matrix Artifacts Manifest

Status: passive validation package.

## Source Artifacts

- central replay JSON:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- passive local-Pareto aggregate:
  `exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/tables/aggregate.csv`
- generated local artifact root:
  `exp/useful_bd_push/t23_sr_pareto_validation_matrix_20260621_183200_UTC/`
- packaging script:
  `scripts/package_useful_bd_validation_matrix.py`
- focused test:
  `tests/scripts/test_package_useful_bd_validation_matrix.py`

## Package Command

```bash
.venv/bin/python scripts/package_useful_bd_validation_matrix.py \
  --central-json exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json \
  --mome-aggregate exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/tables/aggregate.csv \
  --output-dir exp/useful_bd_push/t23_sr_pareto_validation_matrix_20260621_183200_UTC
```

Committed tables and figures were mirrored from that local artifact root into
this technique package.

## Committed Tables

- `tables/validation_matrix.csv`
- `tables/local_pareto_retention.csv`
- `tables/comparison_deltas.csv`

## Committed Figures

- `figures/validation_hv_summary.png`
- `figures/local_pareto_front_material.png`
- `figures/deltas_vs_classic_random.png`
- `figures/visual_inspection_notes.md`

## Validation Evidence

- `.venv/bin/python -m pytest tests/scripts/test_package_useful_bd_validation_matrix.py`
- `.venv/bin/ruff check scripts/package_useful_bd_validation_matrix.py tests/scripts/test_package_useful_bd_validation_matrix.py`
- `.venv/bin/python -m pyright --pythonpath .venv/bin/python scripts/package_useful_bd_validation_matrix.py`

The plain pyright invocation did not resolve `.venv` plotting/data packages in
this environment. The explicit interpreter path fixed import resolution.

## Scope Caveat

This package is passive validation over existing generated candidates. It does
not prove that local-Pareto parent sampling will improve a live run under the
same budget. That remains the next experiment.
