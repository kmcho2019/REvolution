# Yosys-Stat BD Control

## 1. Motivation

This control checks whether the weak manual-BD result is mostly a feature
selection problem. It uses simple synthesized-netlist statistics that are
already produced by the normal synthesis evaluator.

## 2. Core Idea

Archive candidates by compact implementation statistics rather than by
manual logic-depth descriptors:

- `cell_count_log`: synthesized mapped-cell count with the registry's
  `log1p` transform
- `seq_ratio`: sequential-cell fraction
- `mux_ratio`: mux-cell fraction

This is a strong simple control, not the intended final paper method. A
future Auto-BD method is not compelling if this control gives the same
result with lower complexity.

## 3. Input Artifacts

- RTL source: used by the normal REvolution evaluation flow.
- Yosys netlist: used by `SynthesisEvaluator._extract_structural_metrics`.
- Synthesis-stage dumps: not used.
- OpenROAD artifacts: used only for PPA objectives, not descriptor input.
- Other: none.

## 4. Descriptor Extraction Algorithm

For an archiveable candidate:

```text
metrics = structural_metrics(synthesized_netlist)
descriptor[cell_count_log] = log1p(metrics.total_cells)
descriptor[seq_ratio] = metrics.sequential_cells / max(total_cells, 1)
descriptor[mux_ratio] = metrics.mux_cells / max(total_cells, 1)
```

The primary profile is exposed through `descriptor_profile.yaml` as
`yosys_stat_compact_3d`. A predeclared secondary ablation,
`yosys_stat_mix_4d`, adds `adder_ratio` if the compact profile collapses
or fails to separate arithmetic-heavy tasks.

## 5. Descriptor Fitting Protocol

- Fitting kind: none
- Training data: none
- Validity filters: candidate must be archiveable and have synthesized
  structural metrics.
- Frozen artifact hashes: none
- Rebinning policy: use the same grid-quantile archive policy as the
  landing Smooth-QD manual-BD baseline.

## 6. Archive Integration

- Archive type: `grid_quantile`
- Internal descriptor dimensions: 3
- Internal binning/cell policy: quantile grid, warmup successes 8
- Common audit descriptor: required by the centralized report
- Common audit binning: fixed by the future report implementation

## 7. Hyperparameters

- Primary axes: `cell_count_log`, `seq_ratio`, `mux_ratio`
- Secondary ablation axes: `cell_count_log`, `seq_ratio`, `mux_ratio`,
  `adder_ratio`
- Cell mode: `pareto_front`
- Objectives: `ppa`
- Max elites per cell: 5
- Champion-lane fraction: 0.5
- Parent selection: `nsga2_global_rank`

## 8. Expected Advantage

This control may outperform the manual trio if implementation size and
coarse cell composition are more useful for archive organization than
logic/FF depth.

## 9. Risks

- It can collapse into a size-only descriptor.
- It may correlate strongly with the manual `comb_width_log` axis.
- It does not yet capture fanout, pathlet, or synthesis-response motifs.

## 10. Implementation Status

Implemented as a descriptor profile using existing structural metrics.
No new runtime branch is required. Not yet run on the development subset.

## 11. Experimental Setup

- Benchmark subset: locked development subset first
- Seeds: seed-1 preliminary, then seed-3 screening if needed
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

No experimental evidence yet. This control is complete enough for a
development-subset run once classic and landing Smooth-QD baseline
coverage are reproduced.
