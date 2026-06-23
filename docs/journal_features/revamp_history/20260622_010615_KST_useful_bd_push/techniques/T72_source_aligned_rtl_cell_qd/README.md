# T72 Source-Aligned RTL Cell QD

Status: descriptor and vLLM preflight gates passed; live execution not launched.

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

## Navigation

- `methodology.md`: full method card and acceptance criteria.
- `commands/live_screen_v0.md`: preflight, descriptor-gate, live-run, and
  packaging command templates.
- `artifacts_manifest.md`: expected artifacts and current runtime-gate status.
- `tables/source_aligned_descriptor_contract.json`: machine-readable method
  contract.
- `tables/hard_tuning_subset.yaml`: frozen comparator surface.
- `tables/t72_method_matrix.csv`: compact delta from T51/T66/T67.

## Current Decision

Advance to a bounded live T72 screen using the recorded preflight and command
template. T72 has not produced PPA results, figures, or a tier decision yet.
