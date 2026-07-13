# Pareto REvolution Restart Handoff

Last updated: 2026-07-13 UTC.

## Current State

- User approved execution of one descriptor-free Pareto selection ablation.
- No benchmark is running.
- Claims addendum V2 and the V2 RTLLM manifest passed independent prelaunch
  re-review. Addendum V3 records the review's optional precision fixes.
- Reporting distinguishes valid-PPA, weak reference-beating, and positive-HV
  coverage; focused reporting tests pass.
- Commit `f376236d6e` implements the isolated `revolution_pareto` mode and its
  focused tests. `src/revolution/algorithm.py` remains unchanged with SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- Focused pytest, ruff, pyright, and ty pass. The broader revolution/scripts
  suite has four pre-existing parity-fixture failures documented in history.
- No benchmark is running and no live evidence has been collected.

## Next Actions

1. Commit the implementation provenance and repository navigation update.
2. Run a long-timeout read-only code and direction audit; resolve every FAIL.
3. Freeze exact commands, output roots, and report commands.
4. Run and package the matched three-problem seed-42 technical check.
5. Launch full RTLLM seed 1001 only after all prelaunch gates pass.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl` after the first launch.
