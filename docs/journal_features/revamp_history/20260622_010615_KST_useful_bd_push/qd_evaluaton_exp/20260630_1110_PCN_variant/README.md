# PCN Variant Experiment Package

This directory defines the staged experiment for
`pcn_classic_preserving_memory`, the corrected Pareto-competitive novelty
memory variant of REvolution. The package is intended to answer whether a very
conservative QD memory can improve classic REvolution without paying the
archive-fill, descriptor-overtrust, and operator-mismatch costs seen in earlier
QD runs.

## Navigation

- `algorithm_spec.md`: exact PCN algorithm and invariants.
- `experiment_plan.md`: staged smoke, screen, long-budget, and promotion gates.
- `method_configs.md`: reproducible method definitions and CLI flags.
- `report.md`: results report template and interpretation rules.
- `commands/`: launch, method, and packaging scripts.
- `tables/`: method manifest and frozen problem subsets.
- `figures/`: generated explanatory and result figures.
- `analysis/`: packaged analysis output after runs complete.
- `visualizations/`: Phase 03.1 and direct PPA viewer outputs when available.
- `logs/`: tmux and method logs.
- `reviews/`: adversarial review prompts and outputs.

## Current Status

The old `smoke` result is diagnostic only: it used the single-thought QD
operator and generated zero memory-refine calls. The active next step is
`smoke_v2`, which uses `pcn_classic_preserving_memory` with classic EoH
operators and one forced memory-refine slot after the evidence gate opens.

## Core Rule

PCN must remain an auxiliary memory to classic REvolution. It cannot fill empty
archive cells, chase descriptor novelty, use PPA as a descriptor, use
two-parent fusion, or replace the classic primary success pool.
