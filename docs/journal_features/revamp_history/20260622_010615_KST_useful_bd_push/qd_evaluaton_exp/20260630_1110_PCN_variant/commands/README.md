# PCN Commands

Run from `/workspace`.

Diagnostic smoke:

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh smoke
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh smoke
```

Corrected PCN-v2 smoke:

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh smoke_v2
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh smoke_v2
```

Stagnation-triggered PCN-v3 smoke:

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh smoke_v3
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh smoke_v3
```

Screen:

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh screen
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh screen
```

Long budget:

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh long_20x10
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh long_20x10
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/run_stage.sh long_10x20
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/package_pcn_results.sh long_10x20
```

The tmux helper launches `smoke_v3` by default. Set `PCN_LAUNCH_STAGE` to run
another stage.

```bash
bash docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260630_1110_PCN_variant/commands/launch_pcn_tmux.sh
```
