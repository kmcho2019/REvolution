# T72 Source-Aligned RTL Cell QD

Status: bounded live screen passed and diagnostic visualizations packaged.

T72 is the first proposed live method that uses the exact T71 source-aligned
MasterRTL/RTL-Timer cell idea instead of the earlier proxy
`fused_rtl_state_pipeline_2d` and `fused_rtl_operator_timing_2d` profiles.

## Main Question

Do source-aligned RTL implementation-family cells help QD search create better
PPA fronts than classic and the current T51/T66/T67 controls?

## Method Summary

T72 keeps the hard/tuning surface and most of the T66 machinery fixed, then
changes the descriptor to the T71 cell map:

- MasterRTL SOG operator scale: `log(1 + masterrtl_graph_edges)`;
- RTL-Timer state/timing class from DFF references:
  `comb`, `low_seq`, `mid_seq`, or `high_seq`.

T72 intentionally disables two-parent fusion. T66's fusion gate did not
trigger, and the next test should isolate source-aligned cells before adding
another recombination variable.

## Runtime Descriptor Gate

The runtime descriptor hook now resolves profile
`source_aligned_masterrtl_rtltimer_cell_2d` and reports:

- no PPA requirement;
- no reference-PPA, fitness, hypervolume, Pareto-rank, or test-pass input;
- MasterRTL graph-edge and RTL-Timer DFF-class axes;
- exact reproduction of the T70 MasterRTL edge and RTL-Timer DFF counts on
  all 19 generated-candidate samples.

Evidence:

- `tables/descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json`
- `tables/source_aligned_runtime_regression.csv`
- `tables/vllm_preflight_20260623T201737Z.json`
- `tables/vllm_preflight_20260623T201737Z.txt`

## Live Screen Result

The fixed live screen ran at:

```text
exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/
```

It completed all 13 hard/tuning problems with `success` summary status. The
run produced 13 archive summaries, 13 global Pareto summaries, and 13
descriptor-health files. It also passed the single-thought and Pareto-front
run validators using the frozen T72 subset.

This is not yet a headline classic-vs-QD comparison. It proves the
source-aligned descriptor can run end to end under the bounded hard/tuning
surface after the MasterRTL scratch-directory fix.

## Navigation

- `methodology.md`: full method card and acceptance criteria.
- `commands/live_screen_v0.md`: preflight, descriptor-gate, live-run, and
  packaging command templates.
- `artifacts_manifest.md`: expected artifacts and current package status.
- `results_report.md`: fixed live-screen result and caveats.
- `visualizations/direct_ppa_pareto/`: static PPA plots and raw data.
- `visualizations/qd_ppa_viewer/`: Phase 03.1 archive/PPA viewer bundle.
- `tables/source_aligned_descriptor_contract.json`: machine-readable method
  contract.
- `tables/t72_live_screen_status.csv`: compact per-problem fixed-run status.
- `tables/hard_tuning_subset.yaml`: frozen comparator surface.
- `tables/t72_method_matrix.csv`: compact delta from T51/T66/T67.

## Current Decision

Use the packaged plots and viewer for diagnostic inspection only. The live
screen is useful evidence that the RTL-native lane is executable; it is not a
promotion result without matched classic/QD metrics.
