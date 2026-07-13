# Pareto REvolution Restart Handoff

Last updated: 2026-07-13 UTC.

## Current State

- User approved execution of one descriptor-free Pareto selection ablation.
- The seed-42 classic technical-smoke arm completed and validated: three
  problems, 18 generation rows, 144 candidates, EoH-only, `682.73s`.
- The matched seed-42 Pareto arm completed and validated: three problems, 18
  generation rows, 144 candidates, EoH-only, `648.29s`.
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
- The pair is packaged as technical-only evidence under
  `exp/pareto_revolution_validation/packages/smoke_seed_42/`; tracked compact
  results live under `smoke_seed42/`.
- The independent smoke-package audit returned PASS with no blockers. Its
  reconstructed evidence and limitations are preserved at
  `reviews/20260713_claude_smoke_package_review.md`.
- Fresh full-suite preflight passed for `openai/gpt-oss-120b` at context
  `131072`.
- The classic full-RTLLM seed-1001 arm completed and validated: 50 summaries,
  300 generation rows, 2,400 unique evaluated candidates, EoH-only, and
  `4646.99s`.
- Classic used 4,801 LLM calls and 14,870,892 tokens. One empty API response
  on Prob024 generation 3 caused a successful retry without adding an
  evaluated candidate.
- Completed classic root:
  `exp/pareto_revolution_validation/full_rtllm/seed_1001/classic`.
  Classic log:
  `exp/pareto_revolution_validation/logs/full_rtllm_seed1001_classic.log`.
- The Pareto full-RTLLM seed-1001 arm completed and validated: 50 summaries,
  300 generation rows, 2,400 unique evaluated candidates, EoH-only, and
  `4712.14s`.
- Pareto used 4,800 LLM calls and 14,954,728 tokens. Token skew versus classic
  is `+0.564%`; runtime skew is `+1.402%`.
- Completed Pareto root:
  `exp/pareto_revolution_validation/full_rtllm/seed_1001/pareto`.
  Pareto log:
  `exp/pareto_revolution_validation/logs/full_rtllm_seed1001_pareto.log`.
- Runtime configs differ only in `save_path` and `search_mode`. All treatment
  summaries record the frozen NSGA-II methods, descriptors false, post-hoc
  delivered front, and exact normalized/raw objective source.
- The seed-1001 package is complete under
  `exp/pareto_revolution_validation/packages/full_rtllm_seed_1001/`; compact
  tracked evidence is under `full_rtllm_seed1001/`.
- Seed 1001 passes the continuation gate without establishing a win. Pareto
  retains `97.867%` of classic HV46 and trails valid-PPA coverage by one.
- Fresh seed-1002 preflight passed for `openai/gpt-oss-120b` at context
  `131072`.
- The classic full-RTLLM seed-1002 arm launched at
  `2026-07-13T20:35:36Z` under parent process `1886655`.
- Active root:
  `exp/pareto_revolution_validation/full_rtllm/seed_1002/classic`.
  Active log:
  `exp/pareto_revolution_validation/logs/full_rtllm_seed1002_classic.log`.
- Do not launch Pareto seed 1002 until classic exits and validates.

## Next Actions

1. Wait for classic seed 1002 and validate all 50 tasks.
2. Record completion before launching the Pareto seed-1002 arm.
3. Package the pair and apply the locked two-seed gate mechanically.

## Live Resources

- vLLM: `http://20.0.0.103:8000`, `openai/gpt-oss-120b`, context 131072.
- Raw run root: `exp/pareto_revolution_validation/`.
- Goal-local run ledger: `rerun_ledger.jsonl`.
