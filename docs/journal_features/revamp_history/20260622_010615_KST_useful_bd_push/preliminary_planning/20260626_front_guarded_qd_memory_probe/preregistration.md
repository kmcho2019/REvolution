# T85 FG-QDM Preregistration

## Hypothesis

Classic REvolution is strong because it acts as a small-budget hill climber.
Naive MAP-Elites spends too much budget filling descriptor cells. FG-QDM
should perform better than prior QD variants if QD is useful mainly as memory:
it retains PPA-competitive RTL families that classic survivor selection would
discard, then refines them with a small guarded budget.

## Fixed Configuration

| Field | Value |
| --- | --- |
| Descriptor | `sr_pca_3d` from the T26 SR raw PCA profile |
| Scheduler | `front_guarded_memory` |
| Parent selection | `front_guarded_memory` |
| Archive type | `grid_quantile` |
| Cell mode | `elite_pareto_slot` |
| Max elites per cell | `2` |
| Classic fraction | `0.80` |
| Memory refine fraction | `0.15` |
| Front rescue fraction | `0.05` |
| Probe fraction | `0.00` |
| Two-parent probability | `0.00` |
| Operator | `single_thought_operator` |
| Representation | `code_individual` |
| Rebinning | disabled |

## Stage 0 Gate

Before live LLM spend:

- parser accepts the new scheduler and memory flags;
- mode validation rejects mismatched scheduler/parent selection;
- archive rebuild preserves the separate primary success pool;
- memory parent credit updates after a valid child;
- `ruff`, focused `pytest`, and source `pyright` pass.

## Stage 1 Smoke

Run matched classic and T85 on:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

Use `12x3` first to compare against the earlier T26/T24 smoke lineage.

## Stage 2 Screen

Only if Stage 1 passes, run the frozen reference-complete eight-design screen
at `8x5`. Compare against the existing classic `8x5` screen and, if budget
allows, a random-memory control under the same scheduler.

## Metrics

Primary metrics are reference-complete paired mean HV, HV-AUC, Pareto points,
unique PPA points, reference-beating candidates, and valid-PPA yield.

Mechanism metrics are memory-lane generated count, valid-PPA count,
global-front additions, local-front additions, sampleable cells, cooldown
cells, and mean cell credit.
