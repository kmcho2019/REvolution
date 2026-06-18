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

Implemented descriptor:

```text
for each stage:
    extract motif occupancy, cell counts, and motif signature
compute final-vs-initial cell-count growth
compute motif-ratio swing across all stages
emit stnod_trajectory_5d for archive insertion
```

Implemented ablation descriptor:

```text
extract final synthesized-netlist motif occupancy
extract the same stnod_trajectory_5d stage-swing features
emit stnod_motif_trajectory_9d for archive insertion
```

The stage-dump helper lives in `src/revolution/auto_bd/stage_dumps.py`.
The trajectory descriptor lives in
`src/revolution/auto_bd/trajectory_descriptor.py`.

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
- Internal descriptor dimensions: 5 for `synthesis_trajectory_nod`, 9
  for `synthesis_trajectory_motif_nod`
- Internal binning/cell policy: quantile grid, warmup successes 8
- Common audit descriptor: required by the centralized report
- Common audit binning: fixed by the future report implementation

## 7. Hyperparameters

- Stage names: `00_read`, `01_synth`, `02_opt`, `03_arithmap`,
  `04_dffmap`, `05_abc`, `06_clean`, `07_buffered`
- Descriptor axes: `stnod_cell_growth_log`, `stnod_logic_swing`,
  `stnod_control_swing`, `stnod_arith_swing`,
  `stnod_diversity_swing`
- Ablation axes: `motif_logic_ratio`, `motif_control_ratio`,
  `motif_arith_ratio`, `motif_diversity`,
  `stnod_cell_growth_log`, `stnod_logic_swing`,
  `stnod_control_swing`, `stnod_arith_swing`,
  `stnod_diversity_swing`
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

Implemented and seed-1 development run completed for the trajectory-only
arm. The observational sidecar script writer, runtime execution hook,
trajectory features, descriptor profile, and run-matrix arm are
implemented.

The `synthesis_trajectory_motif_nod` ablation is implemented but not yet
run. It exists only to compare motif-only descriptors against a
trajectory-plus-final-motif descriptor under the same substrate.

Initial seed-1 execution failed because the legacy QD descriptor
extraction path attempted to read ST-NOD stage paths without first
creating the sidecar dumps. Commit `ac0e5d3a4c` fixed that path by
running stage dumps when ST-NOD artifacts are missing.

Observational-equivalence validation passed on the live Yosys fixture:
the baseline final synthesized netlist hash matched the ST-NOD
`07_buffered.v` final snapshot hash.

## 11. Experimental Setup

- Benchmark subset: locked development subset first
- Seeds: seed-1 preliminary, then seed-3 screening if Gate 0 passes
- Model and endpoint: `openai/gpt-oss-120b` at
  `http://20.0.0.103:8000/v1`
- Evaluation budget: follow `auto_bd_run_policy_lock.yaml`
- Worker/thread policy: follow `auto_bd_run_policy_lock.yaml`
- Synthesis/OpenROAD settings: same as landing Smooth-QD manual-BD

## 12. Results

Seed-1 development Gate 0 passed:

- covered problems: 6
- missing problems: 0
- classic-minus-ST-NOD problem delta: 0
- classic-minus-ST-NOD problem-seed delta: 0
- report: `seed1_preliminary_report.md`
- coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_synthesis_trajectory_nod.json`

Runtime sanity:

- RTLLM ST-NOD seed-1 run: 528.97 seconds
- VerilogEval ST-NOD seed-1 run: 554.05 seconds
- comparable motif seed-1 runs: 564.57 and 548.10 seconds

The observed seed-1 runtime is in the same range as motif occupancy, so
no cache is required before seed-3 screening.

## 13. Accept / Reject Decision

Promote to seed-3 screening candidate; reject as the final Auto-BD
method for now.

## 14. Reason

The method passed preliminary Gate 0, has observational-equivalence
evidence for the sidecar flow, and adds a more synthesis-native behavior
signal than final-netlist motif occupancy alone.

It is not yet acceptable as the selected method. The seed-1 result only
proves coverage and artifact sanity. Seed-3 screening must still compare
PPA, hypervolume, common-audit QD behavior, and structural diversity
against motif-only, controls, manual BD, and classic REvolution.
