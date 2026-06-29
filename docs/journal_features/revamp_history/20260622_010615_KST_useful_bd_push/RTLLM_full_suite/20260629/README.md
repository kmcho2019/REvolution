# RTLLM Full Suite 20260629

This directory is the reproducible launch and reporting package for the
representative RTLLM comparison requested on 2026-06-29.

## Scope

The run compares classic REvolution against representative QD/MAP-Elites
variants from the strongest current technique lanes:

- Qwen3 RTL embedding.
- MasterRTL model-state and RTL-native structure.
- DeepGate-style synthesized-netlist embedding.
- RF/DeepGate hybrid learned-structure embedding.
- AURORA-style implementation-feature descriptor.
- Delayed archive activation custom QD.
- Front-guarded QD memory.

The benchmark scope is the 50 RTLLM prompt-file problems. Headline aggregate
comparisons must use only the 46 reference-complete designs listed in
[`tables/rtllm_reference_complete_manifest.csv`](tables/rtllm_reference_complete_manifest.csv).
The four missing-reference designs remain diagnostic-only.

## Key Files

- [`experiment_plan.md`](experiment_plan.md): protocol and decision rules.
- [`method_configs.md`](method_configs.md): descriptor definitions and caveats.
- [`tables/method_manifest.csv`](tables/method_manifest.csv): method inventory.
- [`commands/env.sh`](commands/env.sh): shared constants, problem list, paths.
- [`commands/methods/`](commands/methods): exact CLI for every technique.
- [`commands/run_all_methods.sh`](commands/run_all_methods.sh): serial launcher
  with high internal multiprocessing per method.
- [`commands/package_full_suite.sh`](commands/package_full_suite.sh): waits for
  run completion, exports reports/viewers, and writes suite-level summaries.
- [`commands/launch_full_suite_tmux.sh`](commands/launch_full_suite_tmux.sh):
  tmux entry point.
- [`tools/summarize_full_suite.py`](tools/summarize_full_suite.py): creates the
  final comparison report, tables, and figures after artifacts exist.

## Launch

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260629/commands/launch_full_suite_tmux.sh
```

The tmux session is named `rtllm_full_suite_20260629`.

## Output Roots

- Live runs: `/workspace/exp/useful_bd_push/rtllm_full_suite_20260629/live`
- Logs: `logs/`
- Analysis tables: `analysis/`
- Suite figures: `figures/`
- Phase 03.1 viewers: `visualizations/qd_ppa_viewers/`

## Headline Rule

Missing candidate PPA counts as an invalid/non-PPA candidate for that method.
Missing reference PPA excludes the design from headline normalized comparison.
The missing-reference RTLLM designs are:

- `Prob006_adder_pipe_64bit`
- `Prob013_multi_booth_8bit`
- `Prob018_float_multi`
- `Prob040_synchronizer`
