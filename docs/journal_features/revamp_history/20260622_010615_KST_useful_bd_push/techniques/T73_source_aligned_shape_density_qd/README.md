# T73 Source-Aligned Shape-Density QD

Status: matched classic comparison packaged; `T0 positive_diagnostic`, not
promoted.

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

## Live Screen Result

The live screen ran on `2026-06-23` under:

```text
exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning
```

Registered validators pass:

- single-thought operator validation: `valid=True`;
- Pareto-front validation: `valid=True`, `max_front_size_seen=2`.

The run produced `624` candidate files, `294` PPA reports, and `85` archive
members. It succeeded on `12/13` problems. The missing success is
`VerilogEval-Spec-to-RTL/Prob151_review2015_fsm`, which has a problem root
but zero archive members.

Operator nuance: the QD crossover/fusion setting was disabled with
`qd_two_parent_probability=0.0`, but the inherited single-thought operator
kept `qd_operator_one_parent_fraction=0.90`. The archive therefore contains
`4` two-parent prompt descendants. Treat this as low two-parent prompt
exposure, not as a pure one-parent ablation.

## Navigation

- `methodology.md`: method card, leakage rules, and acceptance gates.
- `commands/live_screen_v0.md`: reproducible audit, preflight, run, and
  validation commands.
- `artifacts_manifest.md`: committed package artifacts and expected live
  outputs.
- `results_report.md`: live-screen conclusion and no-promotion caveat.
- `matched_classic_comparison/`: reference-complete classic-versus-T73
  comparison, summary figures, raw compact data, and Phase 03.1 viewer.
- `tables/`: descriptor probe, collapse audit CSV, summary JSON, and method
  contract.
- `figures/`: inspected descriptor-occupancy audit figure.
- `visualizations/`: visualization policy note; the matched viewer lives under
  `matched_classic_comparison/visualizations/`.

## Current Decision

Keep T73 as a useful positive diagnostic, not a promoted QD win. The
reference-complete matched comparison preserves all `13/13` classic-covered
problems and improves valid-PPA yield (`294` versus classic `257`) plus
reference-beating candidate count (`3.69` mean versus `3.54`). Classic still
wins the multi-objective read: mean HV `0.0926007600` versus T73
`0.0890223082`, HV wins `8` versus `5`, and mean Pareto points `2.31` versus
`1.46`.
