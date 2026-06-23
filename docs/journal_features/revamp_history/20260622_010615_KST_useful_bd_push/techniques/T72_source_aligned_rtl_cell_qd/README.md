# T72 Source-Aligned RTL Cell QD

Status: pre-registered; runtime descriptor hook required before execution.

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

## Required Pre-Run Gate

Do not run the live vLLM command until the runtime descriptor probe proves a
profile named `source_aligned_masterrtl_rtltimer_cell_2d` exists and reports:

- no PPA requirement;
- no reference-PPA, fitness, hypervolume, Pareto-rank, or test-pass input;
- MasterRTL graph-edge and RTL-Timer DFF-class axes;
- successful extraction on at least the T70 sample and one fresh generated
  candidate from the active run path.

## Navigation

- `methodology.md`: full method card and acceptance criteria.
- `commands/live_screen_v0.md`: preflight, descriptor-gate, live-run, and
  packaging command templates.
- `artifacts_manifest.md`: expected artifacts and current missing runtime hook.
- `tables/source_aligned_descriptor_contract.json`: machine-readable method
  contract.
- `tables/hard_tuning_subset.yaml`: frozen comparator surface.
- `tables/t72_method_matrix.csv`: compact delta from T51/T66/T67.

## Current Decision

Advance to a narrow runtime-hook implementation. If that probe cannot be made
to match the T71 table within the same generated-candidate sample, do not
launch the live run and record the mismatch as the T72 blocker.
