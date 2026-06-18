# Netlist Motif Occupancy

## 1. Motivation

This is the first non-control Auto-BD method. It tests whether a compact
implementation-motif view is a better search behavior space than manual
logic depth, FF depth, and width descriptors.

## 2. Core Idea

Archive candidates by synthesized-netlist motif occupancy:

- `motif_logic_ratio`: logic gate family occupancy
- `motif_control_ratio`: mux/control family occupancy
- `motif_arith_ratio`: arithmetic family occupancy
- `motif_diversity`: normalized cell-type entropy

The descriptor is CAD-native and available at candidate insertion time
after the normal synthesis/PPA path succeeds.

## 3. Input Artifacts

- RTL source: used by the normal REvolution evaluation flow.
- Synthesized netlist: parsed for cell types and pin arities.
- Synthesis-stage dumps: not used.
- OpenROAD artifacts: used only for PPA objectives, not descriptor input.
- Other: none.

## 4. Descriptor Extraction Algorithm

For an archiveable candidate:

```text
instances = synthesized_netlist_cell_instances(netlist)
descriptor[motif_logic_ratio] = logic_family_count / total_cells
descriptor[motif_control_ratio] = control_family_count / total_cells
descriptor[motif_arith_ratio] = arithmetic_family_count / total_cells
descriptor[motif_diversity] = normalized_entropy(cell_type_histogram)
```

The implementation lives in
`src/revolution/auto_bd/motif_descriptor.py` and is exposed through this
method directory's `descriptor_profile.yaml` as
`netlist_motif_occupancy_4d`.

## 5. Descriptor Fitting Protocol

- Fitting kind: none
- Training data: none
- Validity filters: candidate must be archiveable and have a synthesized
  netlist artifact.
- Frozen artifact hashes: none
- Rebinning policy: use the same grid-quantile archive policy as the
  landing Smooth-QD manual-BD baseline.

## 6. Archive Integration

- Archive type: `grid_quantile`
- Internal descriptor dimensions: 4
- Internal binning/cell policy: quantile grid, warmup successes 8
- Common audit descriptor: required by the centralized report
- Common audit binning: fixed by the future report implementation

## 7. Hyperparameters

- Axes: `motif_logic_ratio`, `motif_control_ratio`,
  `motif_arith_ratio`, `motif_diversity`
- Cell mode: `pareto_front`
- Objectives: `ppa`
- Max elites per cell: 5
- Champion-lane fraction: 0.5
- Parent selection: `nsga2_global_rank`

## 8. Expected Advantage

This descriptor should separate implementation styles that manual depth
and width descriptors merge together, especially arithmetic-heavy,
mux-heavy, and logic-rewritten solutions.

## 9. Risks

- Motif families may be too coarse and collapse into existing Yosys-stat
  controls.
- Standard-cell naming conventions may affect motif family assignment.
- Diversity may reward superficial cell-library differences unless
  canonical-netlist and common-audit checks are reported.

## 10. Implementation Status

Implemented as a descriptor profile and synthesized-netlist extraction
path. Not yet run on the development subset.

## 11. Experimental Setup

- Benchmark subset: locked development subset first
- Seeds: seed-1 preliminary, then seed-3 screening if Gate 0 passes
- Model and endpoint: `openai/gpt-oss-120b` at
  `http://20.0.0.103:8000/v1`
- Evaluation budget: follow `auto_bd_run_policy_lock.yaml`
- Worker/thread policy: follow `auto_bd_run_policy_lock.yaml`
- Synthesis/OpenROAD settings: same as landing Smooth-QD manual-BD

## 12. Results

Not run.

## 13. Accept / Reject Decision

Pending.

## 14. Reason

No experimental evidence yet. The method is ready for a development
seed-1 run once the run matrix includes its arm.
