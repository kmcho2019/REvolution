# Pareto REvolution Restart Handoff

Last updated: 2026-07-13 UTC.

## Current State

- User approved execution of one descriptor-free Pareto selection ablation.
- No benchmark is running.
- Claims addendum V2 and the V2 RTLLM manifest passed independent prelaunch
  re-review. Addendum V3 records the review's optional precision fixes.
- Reporting distinguishes valid-PPA, weak reference-beating, and positive-HV
  coverage; focused reporting tests pass.
- Implementation has not started. `src/revolution/algorithm.py` remains
  unchanged with SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.

## Next Actions

1. Commit the PASS review and V3 precision clarifications.
2. Implement only under `src/revolution/pareto_revolution/`, plus thin backend
   and CLI dispatch.
3. Run focused/full validation, then the matched three-problem seed-42 check.
4. Launch full RTLLM seed 1001 only after the code audit passes.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl` after the first launch.
