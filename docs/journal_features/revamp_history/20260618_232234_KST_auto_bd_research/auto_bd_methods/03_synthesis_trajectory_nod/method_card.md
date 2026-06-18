# Synthesis-Trajectory NOD

## 1. Motivation

Manual BDs summarize the final implementation with depth and size axes.
ST-NOD tests whether the synthesis response itself is a better behavior
space: candidates are distinguished by how their netlists transform
through Yosys stages.

## 2. Core Idea

Generate sidecar Yosys snapshots at fixed stages and derive compact
trajectory features from motif, cell-count, and structural changes across
those snapshots. The descriptor should capture implementation behavior
that a final netlist or manual RTL descriptor may merge away.

## 3. Input Artifacts

- RTL source: read by the observational Yosys stage-dump script.
- Yosys JSON/netlist: planned per-stage JSON and Verilog snapshots.
- Synthesis-stage dumps: primary descriptor input.
- OpenROAD artifacts: PPA objective only, never descriptor input.
- Other: final synthesized netlist may be used for motif features.

## 4. Descriptor Extraction Algorithm

Current helper:

```text
plan = write_yosys_stage_dump_script(candidate, top, output_dir, pdk, ref)
run plan.script_path as a sidecar observation
consume plan.json_paths() or plan.verilog_paths()
```

Planned descriptor:

```text
for each stage:
    extract motif occupancy, cell counts, and motif signature
compute trajectory deltas between adjacent stages
emit a compact fixed-axis vector for archive insertion
```

The stage-dump helper lives in
`src/revolution/auto_bd/stage_dumps.py`.

## 5. Descriptor Fitting Protocol

- Fitting kind: none
- Training data: none
- Validity filters: candidate must pass the normal synthesis/PPA path
  before ST-NOD artifacts can be used for archive insertion.
- Frozen artifact hashes: none
- Rebinning policy: same grid-quantile archive policy as landing
  Smooth-QD manual-BD baseline.

## 6. Archive Integration

- Archive type: `grid_quantile`
- Internal descriptor dimensions: pending
- Internal binning/cell policy: quantile grid, warmup successes 8
- Common audit descriptor: required by the centralized report
- Common audit binning: fixed by the future report implementation

## 7. Hyperparameters

- Stage names: `00_read`, `01_synth`, `02_opt`, `03_arithmap`,
  `04_dffmap`, `05_abc`, `06_clean`, `07_buffered`
- Cell mode: `pareto_front`
- Objectives: `ppa`
- Parent selection: `nsga2_global_rank`
- Champion-lane fraction: 0.5

## 8. Expected Advantage

This should capture how RTL structure responds to synthesis passes, not
only what the final mapped netlist contains. That is the main
hardware-native claim: useful diversity may live in the transformation
trajectory.

## 9. Risks

- Stage dumping may add too much runtime cost unless cached.
- The sidecar script may drift from the scoring synthesis flow.
- Trajectory features may collapse into final cell-count statistics.
- Snapshot artifacts may become large if emitted for every failed
  candidate.

## 10. Implementation Status

Partial. The observational sidecar script writer and path manifest are
implemented. Runtime execution, observational-equivalence validation,
trajectory features, descriptor profile, and development run are pending.

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

No method-level experimental evidence exists yet. The next required step
is to prove the sidecar stage-dump path is observationally equivalent to
the baseline scoring synthesis path before it is used for descriptors.
