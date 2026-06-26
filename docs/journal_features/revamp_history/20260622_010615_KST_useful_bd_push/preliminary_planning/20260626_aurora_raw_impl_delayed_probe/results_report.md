# T99 Results Report

## Question

Does the raw implementation-feature part of the earlier AURORA-style replay
signal survive as a live QD archive descriptor on the frozen preliminary
screen?

## Method

T99 runs `aurora_raw_impl_compact_delayed_8x5`, a delayed high-exploit QD arm
using the `implemented_structural_compact_3d` descriptor:

```text
comb_ratio
adder_ratio
cell_count_log
```

These axes use candidate synthesis structure, not final PPA, reference PPA,
hypervolume, Pareto rank, pass rate, problem identity, or model identity.

This is an AURORA-style raw implementation-feature representative. It is not a
pretrained encoder result and not a compressed-autoencoder result.

## Headline Result

Classic remains stronger on the frozen eight-design reference-complete screen.

| Backend | Mean HV | Pareto Points | Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `6` |
| `aurora_raw_impl_compact_delayed_8x5` | `0.1201` | `2.00` | `4.38` | `2` |

T99 wins or ties small slices, but not enough to justify full RTLLM spend. It
slightly beats classic on `Prob024_fsm`, ties `Prob116_m2014_q3`, and is nearly
tied on `Prob153_gshare`. It loses the larger front-material RTLLM cases:
`Prob041_traffic_light`, `Prob045_alu`, and `Prob049_signal_generator`.

## Completeness

All eight comparisons are headline-valid: both methods have valid candidate PPA
and every design has a valid reference PPA. `Prob045_alu` has a T99 valid-PPA
yield warning: classic has `36` valid-PPA rows and T99 has `9`.

The completeness table is
[`analysis/ppa_completeness.csv`](analysis/ppa_completeness.csv).

## Common Evaluation Tables

The normalized common-evaluation rows are in
[`tables/method_problem_seed_metrics.csv`](tables/method_problem_seed_metrics.csv).
They add per-problem HV-AUC and passive-archive availability columns beside
the headline PPA metrics.

The T99 QD rows have descriptor-cell coverage, QD score, Pareto-cell count,
coverage AUC, and QD-score AUC from the Phase 03.1 viewer. These rows are
marked `candidate_level_no_canonical_dedup` because the viewer datasets do not
include canonical netlist hashes.

The classic rows are marked `descriptor_projection_missing`. This is expected
for this package: classic candidates were not projected into the T99 archive
space, so the table must not claim passive archive coverage for classic.

## Interpretation

T99 is useful as a category representative, not as a promoted method. It shows
that raw implementation-side feature axes are more competitive than the weaker
live text/netlist encoder representatives, but still do not preserve enough
PPA-front breadth under the delayed high-exploit QD substrate.

The result also narrows the AURORA lane: the next AURORA-like attempt should
not be a plain raw-feature axis swap. It needs either a trained objective that
predicts front-relevant implementation families without PPA leakage, or a
secondary/reporting role rather than primary archive coordinates.

## Decision

Tier: `T0_screened_negative_category_representative`

Keep T99 as the current AURORA/raw-implementation representative and add it to
the top-10 preliminary shortlist by mean HV. Do not run exact T99 on full
RTLLM.
