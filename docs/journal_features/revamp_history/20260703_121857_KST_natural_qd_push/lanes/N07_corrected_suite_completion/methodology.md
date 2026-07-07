# N07 Corrected-Suite Completion - Pre-Registration

Registered: 2026-07-07 before any N07 V2-faithful live result.

## Purpose

N07 is due diligence for the unfinished June-30 corrected suite, not a
headline mechanism. The old report left three encoder-flavored arms
unfinished under corrected operators. This card keeps that gap visible,
but re-scopes it to the natural-QD push contract.

The valid N07 question is: if the V2 platform is unchanged, do any of
the unfinished descriptor families beat the frozen trio by descriptor
choice alone?

## Admissible Mechanism

Each admissible N07 arm is Smooth-QD V2 with exactly one change:
the behavior descriptor. Operators, representation, parent selection,
cell retention, archive size, warmup, budget, evaluation mode, and token
budgets stay identical to the P0 V2 anchor.

Do not copy the 20260630 command recipes. Those commands used delayed
archive activation, `elite_pareto_slot`, 0.90 champion lane fraction,
fill/backfill fractions, and other non-V2 archive knobs. That would be
a multi-factor lane here.

## Operator And Scale Loop

All live QD/MAP-Elites arms in this campaign must use the conference
operator stack: `qd_operator_kind=eoh_strategies` over
`code_individual`. Prior `single_thought_operator` runs are contamination
context only and must not be used as mechanism evidence.

The operating loop is: write a natural mechanism card, run the cheapest
probe or small screen that can falsify it, escalate only non-catastrophic
reads to the larger suite, diagnose failures by cause class, and use that
diagnosis plus relevant QD literature to formulate the next simple idea.
No broad RTLLM spend occurs before the small-scale gate clears.

## Arms

- N07a: `source_aligned_rf_timing_state_3d`; extraction-smoke passed,
  live seed-1001 screen eligible.
  Probe: `probes/probe_source_aligned_rf_timing_state_3d.json`.
- N07b: `rf_deepgate_hybrid_3d` with the frozen June-26 descriptor file;
  extraction-smoke pending. Probe: `probes/probe_rf_deepgate_hybrid_3d.json`.
- N07c: `implemented_structural_compact_3d`; extraction-smoke pending.
  Probe: `probes/probe_implemented_structural_compact_3d.json`.

N07c is only the compact structural proxy used by the June-30
`aurora_raw_impl_compact_eoh_8x5` command. It must not be described as
an AURORA reproduction.

## Probe Result

All three lightweight descriptor probes resolve and report
`requires_ppa=false`.

N07a axes:
`source_aligned_rf_timing_leaf_rows`,
`source_aligned_rf_timing_path_count`,
`source_aligned_masterrtl_branching`. Extra requirement:
source-aligned RF timing.

N07b axes:
`source_aligned_rf_timing_leaf_ids`,
`source_aligned_masterrtl_branching`, `deepgate_pool_pc0`. Extra
requirement: source-aligned RF timing plus DeepGate pooled embedding.

N07c axes: `comb_ratio`, `adder_ratio`, `cell_count_log`. Extra
requirement: synthesis metrics.

## Extraction Smoke Result

N07a passed the extraction gate on the frozen 8-design reference RTLs:
`smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC/`.
Descriptor extraction completed for all 8 inputs, grid-quantile warmup
initialized with effective shape `4x4x4`, occupied 7 cells, and reported
no collapsed axes. This is not an optimization result and makes no HV or
functionality claim; it only permits considering the N07a seed-1001 live
screen under the command template.

## Launch Gate

No 8-design N07 screen may launch until the relevant arm has passed a
bounded extraction smoke that writes descriptor-health artifacts. The
smoke is not evidence for promotion; it only proves that the external
feature path resolves under the current repo and environment.

After a smoke passes, launch a seed-1001 frozen 8-design 8x5 screen with
the V2 anchor command and only the descriptor argument changed. Preflight
the vLLM endpoint and keep `--max_tokens 128000`,
`--diff_max_tokens 128000`, and `--vllm_min_model_len 128000`.

## Gates

- Close an arm on coverage loss or mean HV below 0.95x matched classic.
- Keep a diagnostic arm if it beats classic but not V2.
- Escalate to seeds 1002/1003 only if seed 1001 beats V2 on both HV and
  HV-AUC with coverage retained and clean descriptor health.
- No N07 result can displace the manuscript's V2/N03b characterization
  without the same 3-seed screen and full-suite rules used elsewhere.

## Diagnosis Labels

Use the standard cause classes: yield-loss, front-loss,
exploration-tax, descriptor-collapse, or mechanism-inert. For N07,
descriptor-collapse includes extraction failure, fully collapsed axes,
or descriptor-health artifacts missing after a run.
