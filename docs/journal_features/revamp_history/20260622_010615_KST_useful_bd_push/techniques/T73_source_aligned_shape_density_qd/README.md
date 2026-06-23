# T73 Source-Aligned Shape-Density QD

Status: pre-registered successor to T72; not yet a live result.

T73 keeps the source-aligned MasterRTL/RTL-Timer contract from T72, but
changes the descriptor geometry after the matched comparison showed that
T72's fixed `log_edges/state_class` cells were too collapsed to create front
breadth.

## Main Question

Can a problem-local quantile archive over source-aligned RTL shape-density
axes recover front material while preserving T72's coverage?

## Method Summary

T73 keeps the T72 hard/tuning search surface fixed:

- seed `1001`;
- 13-problem hard/tuning subset;
- local `openai/gpt-oss-120b` vLLM endpoint;
- `128000` token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- `elite_pareto_slot` archive cells with two elites per cell;
- champion lane `0.80`;
- `front_slot_lane_nsga2` parent selection;
- no two-parent fusion;
- no repair.

It changes the archive descriptor profile to
`source_aligned_shape_density_3d`:

- `source_aligned_masterrtl_branching = graph_edges / graph_keys`;
- `source_aligned_rtltimer_wire_density = wires / lines`;
- `source_aligned_rtltimer_dff_density = dff_refs / lines`.

The live archive must use `grid_quantile`, not the fallback fixed bounds.
The fixed `0..1` density bounds are recorded only as registry defaults; they
still underfill on the T72 candidate replay.

## Evidence Before Live Spend

The package-local audit replays `233` T72 archive events and derives the T73
axes from the raw source-aligned counts already stored in each event:

```text
tools/audit_t73_axes_from_t72.py
```

Key audit result:

- T72 live fixed cells: mean `1.0769` occupied cells per problem;
- T73 observed-range cells: mean `2.4615`;
- T73 problem-local quantile cells: mean `5.6923`;
- minimum T73 quantile cells: `2`, so every screened problem has at least
  one additional cell versus the T72 live grid.

This is not PPA evidence. It is a descriptor-collapse fix that justifies one
bounded live run.

## Navigation

- `methodology.md`: method card, leakage rules, and acceptance gates.
- `commands/live_screen_v0.md`: reproducible audit, preflight, run, and
  validation commands.
- `artifacts_manifest.md`: committed package artifacts and expected live
  outputs.
- `results_report.md`: current pre-run conclusion and no-promotion caveat.
- `tables/`: descriptor probe, collapse audit CSV, summary JSON, and method
  contract.
- `figures/`: inspected descriptor-occupancy audit figure.
- `visualizations/`: placeholder and requirements for post-run PPA viewers.

## Current Decision

Pre-register T73 as the next source-aligned RTL-native live screen. Do not
claim QD usefulness from T73 until a matched classic comparison on the
reference-complete subset shows front/HV evidence and preserves
classic-covered valid-PPA designs.
