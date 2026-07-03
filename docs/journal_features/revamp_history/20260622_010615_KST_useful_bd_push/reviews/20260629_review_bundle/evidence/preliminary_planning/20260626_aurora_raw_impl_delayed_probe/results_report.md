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

The aggregate shortlist row is in
[`tables/method_seed_summary.csv`](tables/method_seed_summary.csv). It reports
T99 mean HV `0.120094` versus classic `0.140645`, mean HV delta `-0.020551`,
and a paired HV record of `2` T99 wins, `3` classic wins, and `3` ties across
the eight headline problems.

Both T99 and classic rows now have descriptor-cell coverage, QD score,
Pareto-cell count, coverage AUC, and QD-score AUC from the Phase 03.1 viewer.
Classic candidates are projected posthoc into the T99 archive space using the
same implemented-structural descriptor axes. The viewer records `191` recovered
classic descriptor entries in `visualizations/qd_ppa_viewer/descriptor_cache.json`.

Rows are now marked `canonical_netlist_dedup`: the Phase 03.1 datasets include
canonical hashes for all `363/363` valid-PPA samples, and the common exporter
deduplicates passive archive coverage and QD score by canonical synthesized
netlist before crediting final fixed archive cells. T99 mean passive archive
coverage is `0.4860` versus classic `0.5082`; T99 mean passive QD score is
`0.8775` versus classic `0.9938`.

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
