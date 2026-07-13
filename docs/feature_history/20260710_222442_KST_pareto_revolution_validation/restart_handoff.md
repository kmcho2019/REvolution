# Pareto REvolution Restart Handoff

Last updated: 2026-07-13 UTC.

## Current State

- User approved execution of one descriptor-free Pareto selection ablation.
- No benchmark is running.
- Claims addendum V1 and the RTLLM manifest are drafted for independent review.
- Reporting now distinguishes valid-PPA, weak reference-beating, and
  positive-HV coverage; tests are pending.
- Implementation has not started. `src/revolution/algorithm.py` remains
  unchanged with SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.

## Next Actions

1. Run focused reporting tests and commit the prelaunch contract.
2. Run a long-timeout read-only review of the claims addendum.
3. Implement only under `src/revolution/pareto_revolution/`, plus thin backend
   and CLI dispatch.
4. Run focused/full validation, then the matched two-problem seed-42 check.
5. Launch full RTLLM seed 1001 only after the code audit passes.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl` after the first launch.
