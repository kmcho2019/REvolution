# T96 RF DeepGate Hybrid Delayed Results

## Summary

T96 is reference-complete and valid, but it is not promoted.

It tests a compact hybrid descriptor:

- `source_aligned_rf_timing_leaf_ids`: MasterRTL RF timing model-state;
- `source_aligned_masterrtl_branching`: RTL-native structural shape;
- `deepgate_pool_pc0`: official DeepGate pooled netlist embedding.

This improves over exact T95 DeepGate-only mean HV, but it remains below the
classic REvolution `8x5` baseline and does not recover front breadth.
It also regresses versus its closest sibling T83: T96 replaces T83's
`rtltimer_wire_density` axis with `deepgate_pool_pc0`, and the same-seed
mean HV drops from T83 `0.1369` to T96 `0.1199`.

| Method | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Outcome |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `3` strict wins, `3` ties |
| `deepgate_delayed_high_exploit_8x5` | `0.1153` | `1.88` | `5.25` | `1` strict win |
| `rf_deepgate_hybrid_delayed_8x5` | `0.1199` | `1.625` | `5.375` | `2` strict wins, `3` ties |

## Problem-Level Read

T96 beats classic by HV on `Prob024_fsm` and `Prob153_gshare`, ties the flat
zero or equal-HV cases on `Prob015_multi_pipe_8bit`, `Prob116_m2014_q3`, and
`Prob135_m2014_q6b`, and loses on the larger RTLLM front-material cases:
`Prob041_traffic_light`, `Prob045_alu`, and `Prob049_signal_generator`.

The detailed table is:
`tables/rf_deepgate_hybrid_problem_deltas.csv`.

The aggregate report's `hypervolume_win_count` uses the existing script
convention. Interpreted symmetrically for the paired T96 comparison, the HV
record is classic `3` wins, `3` ties, and T96 `2` wins.

## Completeness

`analysis/ppa_completeness.csv` marks all eight problems as `headline`.
Both classic and T96 have valid-PPA candidates for every problem, and every
problem has valid reference PPA. There is no missing-reference loophole in the
headline comparison.

There are still yield warnings: T96 valid-PPA counts drop from `24` to `10`
on `Prob015_multi_pipe_8bit` and from `36` to `11` on `Prob045_alu`. The run
is not promoted, so this is not a promotion-gate violation, but it is part of
why the hybrid is not a final RTLLM candidate.

## Common Evaluation Tables

Normalized common-evaluation rows are now available under `tables/`:

```text
tables/method_problem_seed_metrics.csv
tables/method_seed_summary.csv
tables/passive_archive_metrics.csv
```

The summary row records T96 mean HV `0.119921` versus classic `0.140645`.
Classic passive archive fields are `not_available` because this viewer was
intentionally exported with `--no-classic-descriptor-recovery`.

## Visualizations

Full Phase 03.1 viewer:

```text
visualizations/qd_ppa_viewer/index.html
```

Reader-facing direct PPA supplement:

```text
visualizations/direct_ppa_pareto/index.html
```

The full viewer was exported with `--no-classic-descriptor-recovery`, so
classic candidates are not silently projected through the RF/DeepGate hybrid
descriptor. QD archive cells are shown from recorded hybrid archive artifacts,
while classic remains the PPA comparator.

## Decision

Keep T96 as a category representative for the RF/DeepGate hybrid lane. Do not
spend final full-RTLLM budget on exact T96. The pre-registered rule required
clear improvement over both T83 and T95; T96 improves over T95 but fails the
T83 leg. The result suggests that combining pretrained model-state and netlist
embeddings is not enough by itself; the next candidate needs a stronger
archive/search-policy change or a materially better descriptor, not another
minor axis substitution.
