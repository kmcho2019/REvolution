# T47 Tables

Status: pre-run generated tables.

`probe_matrix.csv` is the human-readable ladder: hard/tuning sanity,
held-out dry run, and final-style escalation.

`probe_problem_matrix.csv` expands the planned hard/tuning and held-out
phases to one row per phase, seed, arm, benchmark, and problem. The current
matrix has 92 planned rows and all 92 have `reference_available`, so the
probe does not depend on missing or zero benchmark reference PPA files.

`default_reference_quarantine.csv` records the known repaired/default-reference
RTLLM problems that must not carry a headline reference-normalized claim. The
current table lists `Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`; all three are outside the T47 probe matrix.

`preflight_models_20260622_203146_UTC.json` records the current local vLLM
preflight. It shows `openai/gpt-oss-120b` with `max_model_len=131072`.

Regenerate the tables with:

```bash
uv run python scripts/build_t47_contract_probe_tables.py
```
