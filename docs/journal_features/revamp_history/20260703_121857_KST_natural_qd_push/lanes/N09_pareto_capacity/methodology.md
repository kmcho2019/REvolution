# N09 Pareto Capacity - Pre-Registration

Registered: 2026-07-07 before any N09 live result.

## Purpose

N09 tests the simplest remaining MAP-Elites-native idea: the V2 archive
may be too tight at five elites per cell. The N01 retention ladder showed
that richer per-cell retention carried most of the screen-scale gain, and
the N04/N07 follow-ups both diagnosed front-loss. This probe asks whether
slightly more per-cell Pareto capacity adds front material without changing
the algorithmic story.

## Mechanism

REvolution-QD V2, but each MAP-Elites cell keeps up to seven
non-dominated elites instead of five:

- unchanged: `qd_cell_mode=pareto_front`;
- changed: `qd_max_elites_per_cell=7`;
- unchanged: descriptor profile, archive type, parent selection,
  champion lane, operators, representation, prompts, budgets, and
  evaluation flow.

This is one existing config knob, no new code, no scheduler trigger, and
no descriptor change.

## Why This Before Other Follow-Ups

- N07b is external-descriptor due diligence. N07a/N07c already show that
  descriptor-only corrected-suite variants are not the missing HV lever.
- SR ReLU PCA is a replay lead but needs a frozen projection spec and
  leakage-clean holdout before any run; it is a descriptor project, not
  the cheapest next QD mechanism.
- compact_8d is a health-grounds swap candidate, not an HV winner.
- Capacity directly targets front-loss with the least implementation
  surface: one existing V2 archive parameter.

## Natural-Extension Criterion

One sentence: "REvolution-QD V2, but each MAP-Elites cell keeps a
slightly larger bounded Pareto front." The only changed knob is
`qd_max_elites_per_cell`. This is a standard MOME/MAP-Elites archive
capacity question and does not introduce credit, stagnation, activation,
repair, or fallback logic.

## Surface And Gates

Run one frozen 8-design 8x5 seed-1001 screen against the pinned classic
and V2 seed-1001 references. Use the P0 V2 command with only
`--qd_max_elites_per_cell 7` and the save path changed.

- Close on coverage loss or mean HV below `0.95x` matched classic.
- Keep as diagnostic if it beats classic but not V2.
- Escalate to seeds 1002/1003 only if seed 1001 beats V2 on both HV and
  HV-AUC with coverage retained and no operator-contract violation.
- Do not scan capacity values. If seven fails, retire the capacity-above
  five idea unless a separate diagnosis justifies a new card.

## Required Evidence

- vLLM preflight with `max_model_len=131072`.
- Run validation with `qd_operator_kind=eoh_strategies`,
  `representation_kind=code_individual`, `qd_cell_mode=pareto_front`,
  and `qd_max_elites_per_cell=7`.
- Operator audit: `single_thought_count=0`.
- Pareto/HV-AUC/descriptor-health package and cause-class decision.

## Live Screen Result

N09 seed 1001 completed under the V2 platform. It retained coverage and
scored mean HV `0.15928`, `113.3%` of matched classic but only `91.7%`
of V2. HV-AUC was `0.14183`, `114.5%` of classic and `98.7%` of V2.
The run is a diagnostic keeper but does not escalate because it fails
the registered V2-beating rule. Cause class: capacity-inert plus
front-loss.
