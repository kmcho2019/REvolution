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
- The first implementation audit returned FAIL on four pre-evidence gaps. The
  review is preserved under `reviews/20260713_claude_implementation_review.md`.
- Commits `21b662441b` and `0bb3fbc51d` close its code/test blockers. The full
  revolution/scripts proxy suite now passes `1039 passed, 4 skipped`.
- Exact launch, output, report, and gate commands are frozen in
  `execution_commands.md`.
- No benchmark is running and no live evidence has been collected.

## Next Actions

1. Re-run the long-timeout read-only implementation audit and require PASS.
2. Recheck the classic hash and run the 128k endpoint preflight.
3. Run and package the matched three-problem seed-42 technical check.
4. Launch full RTLLM seed 1001 only after the smoke and audit pass.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl` after the first launch.
