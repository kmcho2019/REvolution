# PCN Algorithm Specification

## Name

`pcn_quality_memory` means Pareto-Competitive Novelty memory.

## Research Hypothesis

Classic REvolution is strong because it spends nearly all budget on direct PPA
hill climbing. PCN keeps that pressure and adds only a small descriptor-indexed
memory. The memory may recall a candidate only after that descriptor cell has
shown evidence of useful valid-PPA material.

## State

Each problem maintains three structures:

- `PrimaryPool`: the classic valid-PPA success pool. This remains the parent
  source for about 90 percent of calls.
- `QDMemoryArchive`: descriptor-indexed cells populated passively from
  evaluated valid-PPA candidates.
- `GlobalParetoFront`: nondominated PPA candidates, used only for retention and
  memory credit.

The descriptor must not use final PPA, reference PPA, HV, pass rate, problem
identity, or the generation index. PPA can be used for selection, retention,
and credit because classic REvolution already uses evaluated quality feedback.

## Valid-PPA Gate

A candidate enters memory accounting only if:

1. Verilog evaluation succeeds.
2. Synthesis succeeds.
3. PPA metrics are present.
4. The descriptor tuple is available.

Missing candidate PPA is an invalid candidate for that method. Missing
reference PPA removes the design from headline normalized comparisons.

## Activation Gate

PCN memory recall is inactive until both conditions hold:

- current generation is at least `max(2, qd_archive_activation_generation)`;
- the problem has at least `qd_memory_min_valid_ppa` valid-PPA candidates seen.

The first staged setting uses:

```text
qd_archive_activation_generation = 2
qd_memory_min_valid_ppa = 8
```

Before activation, every offspring call follows the classic lane.

## Credit Rule

For each descriptor cell, PCN keeps an exponential moving credit score. The
observed credit values are:

| Outcome | Credit |
| --- | ---: |
| child enters global PPA front | 1.0 |
| child enters local credited cell front | 0.7 |
| child improves cell champion | 0.4 |
| child has valid PPA only | 0.2 |
| invalid or no-PPA child | 0.0 |

The update uses the existing QD memory smoothing factor:

```text
new_credit = 0.75 * old_credit + 0.25 * observed_credit
```

A cell is sampleable only if:

```text
cell_credit >= qd_memory_min_cell_credit
```

The first staged setting uses:

```text
qd_memory_min_cell_credit = 0.50
```

## Local Credit Definition

An inserted local candidate receives local-front credit only when it is valid
PPA and at least one of these is true:

- it entered the global Pareto front;
- its front gap is at most `qd_memory_front_gap_epsilon`;
- its archive result is rank-1 under the local archive view;
- its quality score is at least the current valid-PPA p75 threshold.

The first staged setting uses:

```text
qd_memory_front_gap_epsilon = 0.03
```

## Parent Schedule

At 8x5, PCN recalls at most one memory parent per generation:

```text
classic lane = 90 percent
memory_refine lane = 10 percent
front_rescue lane = 0 percent
probe lane = 0 percent
two-parent fusion = 0 percent
```

Memory parents use the same PPA-first one-parent operator as classic. The
prompt may mention that the parent is retained as an implementation family, but
it must not ask the LLM to move along descriptor axes.

## Hard Invariants

- No empty-cell fill budget.
- No novelty reward.
- No descriptor-targeting prompt.
- No two-parent fusion in v1.
- No repair path in v1.
- No replacement of `PrimaryPool` by archive view.
- Same model, seed, benchmark, and budget as the matched classic arm.
