# PCN-v3 Statistical And C-F Ablation Experiments

This package tests whether `pcn_v3_rf_stagnation_memory_8x5` is genuinely
better than the classic REvolution conference baseline, and whether the
apparent gain is confounded by disabling `C-F`.

Core questions:

1. Does PCN-v3 beat classic across five RTLLM seeds?
2. Does removing `C-F` alone explain the observed gain?
3. Does a C-F-restored PCN memory variant preserve the result?
4. Does the result generalize to VerilogEval Spec-to-RTL holdout designs?

## Navigation

- `experiment_plan.md`: frozen protocol and claim rules.
- `experiment_todo.md`: live execution checklist and result tracker.
- `method_configs.md`: exact method definitions and CLI flags.
- `commands/`: reproducible launch and packaging scripts.
- `tables/`: method and benchmark manifests.
- `analysis/`: generated per-seed PPA/Pareto data.
- `figures/`: generated comparison plots.
- `reports/`: generated and hand-written conclusions.
- `logs/`: run, packaging, and preflight logs.

## Status

Last updated: 2026-07-01 06:02 UTC.

- `rtllm_smoke` is complete and packaged.
- `rtllm_full_5seed` is running in tmux session
  `pcn_v3_20260701_rtllm_full_5seed`.
- One full run has completed so far:
  `seed_1001.classic_revolution_8x5`.
- The active full run is `seed_1001.classic_no_cf_8x5`.
- No publication-safe PCN claim is allowed until the five-seed paired RTLLM
  comparison is complete and the operator-count audit passes.
