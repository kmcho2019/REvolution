# T07 Replay Command

Run from `/workspace`:

```bash
uv run python scripts/analyze_t07_deepgate_surrogate.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

Focused validation:

```bash
uv run pytest tests/scripts/test_analyze_t07_deepgate_surrogate.py
uv run ruff check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py
uv run python -m pyright scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py
uv tool run ty check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py
```

The replay writes committed tables and figures under the T07 technique
directory. The primary direct raw PPA-front figure is
`figures/deepgate_multi_problem_ppa_pareto_fronts.png`; its source points are
in `tables/ppa_front_plot_points.csv`.
