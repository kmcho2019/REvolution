# PCN Variant Experiment Package

This directory defines the staged experiment for `pcn_quality_memory`, a
Pareto-competitive novelty memory variant of REvolution. The package is
intended to answer whether a very conservative QD memory can improve classic
REvolution without paying the archive-fill and descriptor-overtrust costs seen
in the 20260629 RTLLM full suite.

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

The implementation adds `pcn_quality_memory` as a narrow QD scheduler mode.
The initial package is ready for staged runs, but no result claim should be
made until the commands under `commands/` complete and `report.md` is updated
from run artifacts.

## Core Rule

PCN must remain an auxiliary memory to classic REvolution. It cannot fill empty
archive cells, chase descriptor novelty, use PPA as a descriptor, use
two-parent fusion, or replace the classic primary success pool.
