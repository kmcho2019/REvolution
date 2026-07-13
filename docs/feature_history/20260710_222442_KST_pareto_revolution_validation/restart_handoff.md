# Pareto REvolution Restart Handoff

Last updated: 2026-07-13 UTC.

## Current State

- User approved execution of one descriptor-free Pareto selection ablation.
- The seed-42 classic technical-smoke arm completed and validated: three
  problems, 18 generation rows, 144 candidates, EoH-only, `682.73s`.
- The matched seed-42 Pareto arm launched from the frozen command at
  `2026-07-13T17:09:47Z` and is running under parent process `1752486`.
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
- The long-timeout implementation re-review returned PASS with no blockers and
  is preserved at `reviews/20260713_claude_implementation_rereview.md`.
- Fresh preflight passed for `openai/gpt-oss-120b` at context `131072` and is
  stored at `exp/pareto_revolution_validation/preflight/latest.json`.
- Active root: `exp/pareto_revolution_validation/smoke/seed_42/pareto`.
  Active log: `exp/pareto_revolution_validation/logs/smoke_seed42_pareto.log`.
  Do not launch full RTLLM until this process exits and the pair is packaged.

## Next Actions

1. Wait for the Pareto smoke process; verify three complete summaries.
2. Package both arms as technical evidence only.
3. Launch full RTLLM seed 1001 only after the smoke passes.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl`.
