# T85 Validation Log

## 2026-06-26 Stage 0

Commands:

```bash
uv run ruff check \
  src/revolution/qd/engine.py \
  src/revolution/backends/revolution_backend.py \
  src/revolution/algorithm.py \
  scripts/run_backend.py \
  tests/revolution/test_qd_engine.py \
  tests/scripts/test_run_backend.py

uv run pytest \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_requires_matching_parent_selection \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_preserves_primary_pool \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_updates_parent_cell_credit \
  tests/scripts/test_run_backend.py::test_backend_parser_accepts_qd_options \
  -q

uv run python -m pyright \
  src/revolution/algorithm.py \
  src/revolution/qd/engine.py \
  src/revolution/backends/revolution_backend.py \
  scripts/run_backend.py
```

Result:

- `ruff`: pass
- focused `pytest`: `4 passed`
- source `pyright`: `0 errors`

Notes:

- A first pytest invocation used an outdated test name and ran zero tests. The
  corrected focused command above passed.
- Repo-wide pyright still has older test-suite typing debt, so Stage 0 records
  source-file pyright on touched runtime modules.

## 2026-06-26 Warmup-4 Analysis

Commands:

```bash
uv run python scripts/report_ppa_distribution.py \
  --backend_run classic=exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_sr_memory_warmup4_12x3=exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/analysis/warmup4_ppa_distribution

uv run python scripts/report_pareto_analysis.py \
  --backend_run classic=exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_12x3/seed_1001/openai_gpt-oss-120b \
  --backend_run fg_qdm_sr_memory_warmup4_12x3=exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/tables/smoke_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_front_guarded_qd_memory_probe/analysis/warmup4_pareto_analysis
```

Result:

- PPA distribution report: pass, `117` candidates, `3` reference-complete
  problems, `20` generated figures, no warnings.
- Pareto/HV report: pass. Classic mean HV is `0.190331`; T85 warmup-4 mean HV
  is `0.137536`.
- Visual inspection: recorded in
  `analysis/warmup4_visual_inspection_notes.md`.
