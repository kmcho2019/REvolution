# T24 SR Pareto Live Validation Readiness Report

## Status

T24 is ready for live execution but has not produced comparable live results
yet. Its purpose is to validate whether the T04/T19 synthesis-response leads
improve when paired with live bounded local-Pareto retention and quality-aware
parent sampling.

Tier decision: `pending_live_run`.

## Why This Is The Next Experiment

T23 showed that the two best SR-family leads have complementary strengths:

- SR ReLU PCA beats classic and T22 random on final HV and HV AUC.
- SR-RFF PCA stays near classic on final HV/best quality and beats classic and
  T22 random on common-audit QD score and local front material.

The unresolved question is whether this passive signal survives live sampling
when parent selection must balance exploration, local Pareto preservation, and
hill-climbing pressure.

## What Would Count As A Useful Result

A useful T24 result would show at least one of:

- better global PPA hypervolume than classic and T22 random;
- better HV AUC than classic and T22 random without a validity collapse;
- more global Pareto points or unique PPA-front netlist families than classic
  and T22 random;
- higher passive archive QD score or coverage while staying near classic
  final quality;
- preserved classic-covered designs under the same budget.

Average best fitness is secondary diagnostic evidence only.

## Current Evidence

The live endpoint is reachable:

- endpoint: `http://20.0.0.103:8000/v1`
- model id: `openai/gpt-oss-120b`
- `max_model_len`: `131072`
- preflight mirror:
  `tables/preflight_models_20260621_184346_UTC.json`

The existing code path already supports the required archive mechanism:

- bounded fronts per cell via `qd_cell_mode=pareto_front`;
- max five retained members per cell via `qd_max_elites_per_cell=5`;
- NSGA-II style global parent pool via `qd_parent_selection=nsga2_global_rank`;
- champion lane via `qd_champion_lane_fraction=0.5`.

## Open Work

1. Execute the command matrix in `commands/live_screen_v0.md`.
2. Validate each QD run with `scripts/validate_pareto_front_run.py`.
3. Package central comparison tables and figures under this T24 directory.
4. Inspect figures manually and write `figures/visual_inspection_notes.md`.
5. Decide T0/T1/T2/T3 only from completed artifacts.

## Anti-Overclaim Note

This package does not prove QD/MAP-Elites usefulness yet. It is the concrete
live validation bridge from T23 passive evidence to a measured SR-family
archive-coupling result.
