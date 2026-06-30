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

The corrected `smoke_v2` stage finished and is packaged under
`analysis/smoke_v2/`. PCN-v2 now passes the mechanism sanity checks that the
old `smoke` failed: the EoH operator stack is preserved and the memory-refine
lane fires with valid-PPA children.

The performance result is not yet a scale-up signal. RF memory retains 97.3
percent of classic mean HV and beats the random-memory control, but it still
trails classic on mean HV. The passive EoH archive control is slightly ahead
of both classic and RF memory on this three-problem smoke, so the active memory
lane has not earned a 20x10 escalation as-is.

## Core Rule

PCN must remain an auxiliary memory to classic REvolution. It cannot fill empty
archive cells, chase descriptor novelty, use PPA as a descriptor, use
two-parent fusion, or replace the classic primary success pool.
