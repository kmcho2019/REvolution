# RTLLM Full Suite 20260630

This directory is the operator-corrected rerun package for the RTLLM QD
comparison. It exists because the 20260629 package compared classic
REvolution's EoH operator stack against QD arms using
`single_thought_operator`, which confounded descriptor/archive effects with a
known weaker generation formulation.

## Scope

The corrected suite keeps classic REvolution's thought/code/feedback EoH
operators for all standard QD arms and adds QD only through descriptor archive
selection. The PCN arm uses `pcn_classic_preserving_memory`, which is the
EoH-preserving auxiliary memory scheduler validated in the PCN smoke work.

Representative lanes:

- Qwen3 RTL embedding.
- MasterRTL/RF source-aligned model-state descriptors.
- DeepGate-style synthesized-netlist graph descriptors.
- RF/DeepGate hybrid descriptors.
- AURORA-style raw implementation descriptors.
- MasterRTL structural delayed archive descriptors.
- PCN-v3 RF stagnation memory.

## Key Files

- [`experiment_plan.md`](experiment_plan.md): smoke and full-run protocol.
- [`method_configs.md`](method_configs.md): exact corrected method definitions.
- [`tables/method_manifest.csv`](tables/method_manifest.csv): method inventory.
- [`commands/env.sh`](commands/env.sh): shared constants, stage switch, paths.
- [`commands/methods/`](commands/methods): exact CLI for every technique.
- [`commands/run_all_methods.sh`](commands/run_all_methods.sh): method launcher.
- [`commands/package_full_suite.sh`](commands/package_full_suite.sh): staged
  report, figure, completeness, viewer, and operator-contract packaging.
- [`tools/audit_operator_contract.py`](tools/audit_operator_contract.py):
  rejects any corrected run that emits `single_thought_operator` candidates.
- [`tools/summarize_full_suite.py`](tools/summarize_full_suite.py): creates
  stage-level tables, figures, and Markdown reports.

## Launch

Smoke first:

```bash
RUN_STAGE=smoke bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/commands/launch_full_suite_tmux.sh
```

Full RTLLM after smoke passes:

```bash
RUN_STAGE=full bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/commands/launch_full_suite_tmux.sh
```

Qwen GPU-0 add-on after the shared run:

```bash
RUN_STAGE=full \
QWEN_CUDA_VISIBLE_DEVICES=0 \
QWEN_TOTAL_WORKER_SLOTS=2 \
QWEN_MAX_ACTIVE_PROBLEMS=2 \
QWEN_MAX_WORKERS_PER_PROBLEM=1 \
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/commands/launch_qwen_gpu0_addon_tmux.sh
```

## Output Roots

- Live runs: `/workspace/exp/useful_bd_push/rtllm_full_suite_20260630/live/<stage>`
- Logs: `logs/<stage>.*`
- Analysis: `analysis/<stage>/`
- Figures: `figures/<stage>/`
- Reports: `reports/<stage>_report.md`
- Viewers: `visualizations/<stage>/qd_ppa_viewers/`

## Headline Rule

Missing candidate PPA counts as invalid/non-PPA for that method. Missing
reference PPA excludes the design from headline normalized comparison. The
full-stage headline subset is the 46 reference-complete RTLLM designs.
