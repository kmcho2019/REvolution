# H5 Pre-Implementation Architecture Review

- Date: 2026-07-20
- Mode: read-only independent subagent
- Scope: classic engine, backend dispatch, CLI contract, and tests
- Verdict: `ACCEPT_PENDING_DIFF`

## Smallest Isolated Design

1. Add one experimental `EoHEngine` subclass under
   `src/revolution/failed_parent_repair/`.
2. After classic initialization, narrow `fail_strats` to `['M-F']` and reset
   `fail_strategy_stats` to the same one-key state.
3. Add one `revolution_failed_parent_repair` search-mode discriminant to the
   backend and CLI.
4. Reuse the complete inherited generation, parent selection, success
   evolution, evaluation, survivor, reward, and logging paths.
5. Add only behavior-neutral candidate telemetry to the shared logger and wrap
   the inherited generation method to record treatment pre/post pool sizes.

## Required Contract

The mode must require dual pools, whole-output generation, EoH operators, the
classic success set, UCB, direct-code representation, no repair wrapper, and
strict evaluation. Unknown or incompatible combinations fail before runtime.

## Rejected Designs

- Do not add a generic failed-operator-set knob to classic configuration.
- Do not edit `src/revolution/algorithm.py` or the default config.
- Do not copy `evolve_one_generation` or introduce a fallback path.
- Do not add a new prompt, reward, allocation policy, or telemetry state to the
  engine treatment.
- The generation wrapper may write pool sizes but may not reimplement any
  generation step or retain policy state.

## Closure Check

Before live spend, verify the classic engine and default-config hashes, inspect
the complete diff, and run focused subclass, backend-dispatch, parser, and
invalid-contract tests. This review becomes `ACCEPT` only if the implementation
matches this surface.
