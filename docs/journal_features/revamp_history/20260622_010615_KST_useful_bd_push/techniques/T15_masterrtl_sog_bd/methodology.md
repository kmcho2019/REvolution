# MasterRTL SOG BD Methodology

## Intent

Build behavior descriptors from a Simple Operator Graph (SOG)-style bit-level
RTL representation before full synthesis. This tests whether pre-synthesis
operator structure gives a cheaper and more stable signal than mapped netlist
statistics alone.

T15 is now paired with `T60_rtl_timer_timing_risk_bd` in the RTL-native lane.
T15 focuses on structural/operator graph shape; T60 focuses on timing-risk and
path morphology. Both should be used as behavior descriptors, not as direct PPA
predictors.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Parsed AST or Yosys RTLIL before technology mapping.
- Bit-level operator graph with simple operators, constants, state elements,
  and bit-vector slicing information.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass labels.

## Preprocessing

1. Parse RTL into a stable intermediate representation.
2. Lower vector operations into bit-level simple operators where possible.
3. Preserve operator type, bit width, fanin/fanout, mux/control role,
   arithmetic role, and sequential boundary tags.
4. Record unsupported constructs and lowering failures in the validity funnel.

## Descriptor

Construct a SOG feature vector with:

- bit-level operator counts by type;
- width histograms for arithmetic, mux, comparator, and shift operations;
- control/data mixing ratios;
- SOG depth and critical operator-chain length;
- state-to-output and input-to-state cone summaries;
- graph edit distance or hashed neighborhoods between parent and child when
  lineage data exists.

Normalize per benchmark and compare SOG-only, Yosys-only, and fused
SOG+Yosys descriptors. A later fused variant may add T60 timing-risk features
if both feature families pass collapse and reference-complete comparison
checks.

## Archive Mapping

Use 2D grid axes over arithmetic-width entropy and control/data mixing ratio.
Use CVT over the full SOG or fused vector for higher-dimensional tests.

## Parent Selection Coupling

SOG extraction happens before expensive PPA, so it may support early archive
assignment. It must still be audited after synthesis/PPA to avoid filling cells
with unsynthesizable designs.

## Expected Outputs

- `tables/sog_features.csv`
- `tables/lowering_funnel.csv`
- `tables/sog_yosys_ablation.csv`
- `figures/sog_projection.png`
- `figures/sog_vs_yosys_archive.png`
