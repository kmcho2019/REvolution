# Method Configurations

This file records the intent and descriptor definition for each full-suite arm.
Exact flags are in `commands/methods/*.sh`.

## Terminology

- **PPA**: power, performance, and area. In this repo the normalized objectives
  are maximize-form improvements over each problem reference.
- **HV**: hypervolume of the PPA Pareto front in normalized objective space.
- **HV-AUC**: area under the generation-by-generation hypervolume curve.
- **BD**: behavior descriptor, the coordinates used to place candidates in a
  QD archive. A valid BD must not include final PPA, reference PPA, pass rate,
  hypervolume, Pareto rank, or problem identity.
- **Reference-complete subset**: RTLLM designs whose reference `ppa.txt` is
  valid. Only these designs support headline normalized comparisons.
- **Diagnostic-only design**: a design that can show raw candidates or logs but
  is excluded from headline aggregate comparison because reference PPA is
  missing.

## Selected Arms

### classic_revolution_8x5

Classic REvolution baseline under the same model, prompt, seed, and candidate
budget. This is the required comparator.

### qwen_canonical_rtl_pca3_8x5

Pretrained text/code embedding lane. The descriptor embeds canonical RTL with
Qwen3 in the isolated Qwen environment, then projects to the frozen PCA3
profile from the preliminary screen.

Reason for inclusion: best strict pretrained text/code embedding signal to
date, even though it is not yet a live full-suite win.

### masterrtl_rf_leafid_structural_delayed_8x5

MasterRTL model-state and RTL-native structure lane. The descriptor uses
MasterRTL RF timing leaf-ID state plus MasterRTL branching and RTLTimer wire
density. The archive is delayed until generation 3 to reduce early archive-fill
tax.

Reason for inclusion: representative hardware-native pretrained/model-state
lane with source-aligned structural axes.

### deepgate_delayed_high_exploit_8x5

Synthesized-netlist encoder lane using the frozen `deepgate_pooled_pc3`
profile. The method uses delayed archive activation and high champion-lane
pressure.

Reason for inclusion: representative netlist graph embedding lane.

### rf_deepgate_hybrid_delayed_8x5

Hybrid encoder lane combining MasterRTL RF state and DeepGate graph embedding
projection. It keeps the delayed/high-exploit archive schedule.

Reason for inclusion: strongest mixed learned-structure lane, covering the
possibility that neither source-only nor netlist-only descriptors are enough.

### aurora_raw_impl_compact_delayed_8x5

AURORA-style raw implementation-feature lane using compact implemented
structural descriptors under the delayed/high-exploit schedule.

Reason for inclusion: representative learned/auto-BD style lane without
claiming pretrained encoder status.

### masterrtl_delayed_archive_activation_8x5

Custom RTL-native delayed archive activation method using the
`source_aligned_masterrtl_structural_mix_3d` profile.

Reason for inclusion: one of the best custom hardware-native QD variants from
the preliminary planning track.

### fg_qdm_rf_leafid_front_credit_8x5

Front-guarded QD memory with RF leaf-ID and source-aligned RTL structure axes.
Classic-style exploitation remains dominant; the QD archive acts as guarded
memory and front rescue rather than a fill-driven MAP-Elites optimizer.

Reason for inclusion: strongest recent algorithmic variant. The earlier T100
evidence was a 12x3 smoke; this full suite adapts it to 8x5 for equal-budget
comparison against the selected full-run arms.

## Caveats

- None of these QD methods should be promoted from all-RTLLM/defaulted-reference
  aggregates.
- DeepGate and MasterRTL names refer to the validated descriptor profiles in
  this branch. Any report must distinguish model-state/embedding descriptors
  from a claim of full upstream predictor reproduction.
- `fg_qdm_rf_leafid_front_credit_8x5` is an adapted full-suite configuration,
  not the exact 12x3 T100 smoke command.
