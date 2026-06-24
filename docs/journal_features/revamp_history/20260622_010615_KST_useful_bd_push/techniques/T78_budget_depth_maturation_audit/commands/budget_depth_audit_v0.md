# T78 Budget-Depth Audit Commands

Run from `/workspace`:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T78_budget_depth_maturation_audit/tools/run_t78_budget_depth_audit.py
```

Validation commands used:

```bash
python -m json.tool docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T78_budget_depth_maturation_audit/tables/t78_summary.json
uv run ruff check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T78_budget_depth_maturation_audit/tools/run_t78_budget_depth_audit.py
uv run python -m pyright docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T78_budget_depth_maturation_audit/tools/run_t78_budget_depth_audit.py
uv tool run ty check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T78_budget_depth_maturation_audit/tools/run_t78_budget_depth_audit.py
git diff --check
```
