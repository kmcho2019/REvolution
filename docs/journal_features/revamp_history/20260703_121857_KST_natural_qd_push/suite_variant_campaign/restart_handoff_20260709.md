# Restart Handoff - 2026-07-09

Last updated: 2026-07-10T05:30:00Z.
Branch: `feat/journal-qd-bd-exp-20260703`.
Current completed result package:
`suite_variant_campaign/S11_warmup12/seed_1001`.
Current live run: none.

## Immediate State

S23 `journal_logic_width_2d` seed 1001 and S11 `warmup12` seed 1001
have completed and been packaged. No benchmark is currently running from
this handoff.

```text
seed 1001 run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001
seed 1001 launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/launch_capacity3_seed1001.log
seed 1001 preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1001_20260709_182124_UTC.json
seed 1001 package:
suite_variant_campaign/S07_capacity3/seed_1001
seed 1002 run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/live/capacity3/seed_1002
seed 1002 launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/launch_capacity3_seed1002.log
seed 1002 preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1002_20260709_195220_UTC.json
seed 1002 package:
suite_variant_campaign/S07_capacity3/seed_1002
seed 1003 run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_213030_UTC/live/capacity3/seed_1003
seed 1003 launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_213030_UTC/launch_capacity3_seed1003.log
seed 1003 preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1003_20260709_213030_UTC.json
seed 1003 package:
suite_variant_campaign/S07_capacity3/seed_1003
seed 1004 run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_225719_UTC/live/capacity3/seed_1004
seed 1004 launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_225719_UTC/launch_capacity3_seed1004.log
seed 1004 preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1004_20260709_225719_UTC.json
seed 1004 package:
suite_variant_campaign/S07_capacity3/seed_1004
seed 1005 run root:
exp/natural_qd_push/suite_variants_wave_b_20260710_002626_UTC/live/capacity3/seed_1005
seed 1005 launch log:
exp/natural_qd_push/suite_variants_wave_b_20260710_002626_UTC/launch_capacity3_seed1005.log
seed 1005 preflight:
suite_variant_campaign/preflights/s07_capacity3_seed1005_20260710_002626_UTC.json
seed 1005 package:
suite_variant_campaign/S07_capacity3/seed_1005
```

Observed at this handoff: S07 seed 1002 completed all 50 RTLLM problems
normally in 4758.87 seconds with 4800 LLM API calls. The package passes
the full 50-problem run validation and operator audit.

Observed after launch: S07 seed 1003 completed all 50 RTLLM problems
normally in 4722.00 seconds with 4800 LLM API calls. The package passes
the full 50-problem run validation and operator audit.

Observed after seed 1004 launch: the vLLM preflight passed with model
`openai/gpt-oss-120b` and `max_model_len=131072`, then the 50-problem
RTLLM run completed normally in 4675.61 seconds with 4800 LLM API calls.
The compact package passes the full 50-problem run validation and the
operator audit.

Observed after seed 1005 launch: the vLLM preflight passed with model
`openai/gpt-oss-120b` and `max_model_len=131072`, then the 50-problem
RTLLM run completed normally in 4731.86 seconds with 4800 LLM API calls.
The compact package passes the full 50-problem run validation and the
operator audit.

The earlier S09 launch rooted at
`exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC` was
stopped before any completed problem because it missed
`qd_champion_lane_fraction=0.5`. Its raw directory is quarantined as
`exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC_INVALID_MISSING_CHAMPION_LANE`
and must not be interpreted.

## Post-S07 Next Lane

S07 is closed as secondary evidence, not the primary final-HV claim.
The last tested follow-up lane is `S23 journal_logic_width_2d`, recorded
in `post_s07_followup_decision.md` and `variant_registry.csv`.

S23 keeps the V2 platform and changes only the behavior descriptor to the
explicit 2D subset:

```text
--qd_descriptor_axes logic_depth comb_width_log
--qd_max_elites_per_cell 5
```

All operator and evaluation parity pins remain unchanged:
`classic_operator_kind=eoh_strategies`, `qd_operator_kind=eoh_strategies`,
`eoh_success_operator_set=classic`, `representation_kind=code_individual`,
`evaluation_mode=strict_ablation`, `max_tokens=128000`, and
`diff_max_tokens=128000`.

Seed 1001 completed and was packaged at:

```text
run root:
exp/natural_qd_push/suite_variants_wave_c_20260710_021651_UTC/live/journal_logic_width_2d/seed_1001
launch log:
exp/natural_qd_push/suite_variants_wave_c_20260710_021651_UTC/launch_journal_logic_width_2d_seed1001.log
preflight:
suite_variant_campaign/preflights/s23_journal_logic_width_2d_seed1001_20260710_021651_UTC.json
package:
suite_variant_campaign/S23_journal_logic_width_2d/seed_1001
```

The vLLM preflight passed with model `openai/gpt-oss-120b` and
`max_model_len=131072`. The run completed normally in 5223.39 seconds
with 4800 LLM API calls. The package passes the full 50-problem
validation manifest and operator audit.

S23 seed 1001 is a negative descriptor-reduction control:
S23 `0.084403` HV / `0.076832` HV-AUC46 / `31/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`. It reduces descriptor-collapse events to `4/50`
archives but reaches only 75.8% of classic final HV, so the
pre-registered smoke stop rule closes S23 after seed 1001.

Do not launch broad BD scans from this handoff. Compact8d/CVT is deferred
because it changes descriptor family and geometry and had prior extraction
fragility. GT3D/testability is deferred to a coverage appendix because the
existing suite signal is HV-weak. `S31 s07_logic_width_2d` remains
blocked because S23 did not provide the required non-catastrophic
single-factor signal.

## S11 Warmup12 Closure

S11 is a bounded warmup-family closure run, not a new primary TCAD lane.
It keeps the V2 platform and changes only:

```text
--qd_grid_quantile_warmup_successes 12
```

All operator and evaluation parity pins remain unchanged:
`classic_operator_kind=eoh_strategies`, `qd_operator_kind=eoh_strategies`,
`eoh_success_operator_set=classic`, `representation_kind=code_individual`,
`evaluation_mode=strict_ablation`, `max_tokens=128000`, and
`diff_max_tokens=128000`.

Seed 1001 completed and was packaged at:

```text
run root:
exp/natural_qd_push/suite_variants_wave_b_20260710_035929_UTC/live/warmup12/seed_1001
launch log:
exp/natural_qd_push/suite_variants_wave_b_20260710_035929_UTC/launch_warmup12_seed1001.log
preflight:
suite_variant_campaign/preflights/s11_warmup12_seed1001_20260710_035929_UTC.json
package:
suite_variant_campaign/S11_warmup12/seed_1001
```

The vLLM preflight passed with model `openai/gpt-oss-120b` and
`max_model_len=131072`. The run completed normally in 4793.56 seconds
with 4800 LLM API calls. The package passes the full 50-problem
validation manifest and operator audit.

S11 seed 1001 is a negative warmup interpolation control:
S11 `0.095807` HV / `0.085702` HV-AUC46 / `33/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`. It ties matched classic coverage but is far below
classic on final HV and HV-AUC46. Close S11 after seed 1001 and keep S12
warmup24 blocked from current evidence.

## S09 Contract

S09 is the front-slot interpolation probe:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_parent_selection front_slot_lane_nsga2
--qd_front_slot_lane_fraction 0.20
--qd_champion_lane_fraction 0.5
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is already packaged. It is a positive single-seed probe:
S09 `0.102139` HV / `0.093403` HV-AUC46 / `34/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`.

Seed 1002 is packaged. It did not replicate seed 1001:
S09 `0.090574` HV / `0.077897` HV-AUC46 / `32/46` coverage vs matched
classic `0.097557` / `0.081183` / `33/46` and V2 `0.100310` /
`0.090753` / `33/46`.

Across two seeds, S09 is a front-loss control, not a promotion arm:
S09 `0.096357` HV / `0.085650` HV-AUC46 / `66/92` coverage vs classic
`0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` /
`65/92`.

## S22 Contract

S22 is the conservative front-slot interpolation probe:

```text
--qd_cell_mode elite_pareto_slot
--qd_max_elites_per_cell 2
--qd_parent_selection front_slot_lane_nsga2
--qd_front_slot_lane_fraction 0.10
--qd_champion_lane_fraction 0.5
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is packaged. It is V2-positive and coverage-positive against
classic, but still below classic on final HV and HV-AUC46:
S22 `0.102589` HV / `0.088878` HV-AUC46 / `34/46` coverage vs classic
`0.111401` / `0.090551` / `33/46` and V2 `0.096767` / `0.083539` /
`32/46`.

Seed 1002 is packaged. It beats matched classic on final HV and HV-AUC46
but loses one coverage point: S22 `0.100856` HV / `0.089351` HV-AUC46 /
`32/46` coverage vs classic `0.097557` / `0.081183` / `33/46` and V2
`0.100310` / `0.090753` / `33/46`.

Across two seeds, S22 is HV-AUC-positive but not a primary HV win:
S22 `0.101722` HV / `0.089115` HV-AUC46 / `66/92` coverage vs classic
`0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` /
`65/92`.

## S07 Contract

S07 is the smaller per-cell Pareto capacity interpolation probe:

```text
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 3
--qd_parent_selection nsga2_global_rank
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_champion_lane_fraction 0.5
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is packaged. It is HV-AUC-positive and V2-positive on final HV,
but not a primary classic win: S07 `0.100296` HV / `0.091895` HV-AUC46 /
`32/46` coverage vs matched classic `0.111401` / `0.090551` / `33/46`
and V2 `0.096767` / `0.083539` / `32/46`.

Seed 1002 is packaged. It beats matched classic on final HV and coverage
but not HV-AUC46: S07 `0.105630` HV / `0.088873` HV-AUC46 / `34/46`
coverage vs classic `0.097557` / `0.081183` / `33/46` and V2
`0.100310` / `0.090753` / `33/46`.

Across two seeds, S07 is the strongest capacity-control near-miss:
S07 `0.102963` HV / `0.090384` HV-AUC46 / `66/92` coverage vs classic
`0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` /
`65/92`.

Seed 1003 is packaged. It nearly ties matched classic but does not win:
S07 `0.100464` HV / `0.087032` HV-AUC46 / `33/46` coverage vs classic
`0.102093` / `0.087210` / `33/46` and V2 `0.099854` / `0.090295` /
`35/46`.

Across three seeds, S07 remains the strongest capacity-control near-miss:
S07 `0.102130` HV / `0.089267` HV-AUC46 / `99/138` coverage vs classic
`0.103684` / `0.086315` / `99/138` and V2 `0.098977` / `0.088196` /
`100/138`.

Seed 1004 is packaged and positive: S07 `0.112252` HV / `0.093789`
HV-AUC46 / `33/46` coverage vs matched classic `0.103555` /
`0.089027` / `32/46` and V2 `0.101008` / `0.086425` / `33/46`.

Across four seeds, S07 is now the leading natural extension:
S07 `0.104661` HV / `0.090397` HV-AUC46 / `132/184` coverage vs
classic `0.103652` / `0.086993` / `131/184` and V2 `0.099485` /
`0.087753` / `133/184`.

Seed 1005 is packaged and negative for S07 against matched classic:
S07 `0.093760` HV / `0.078565` HV-AUC46 / `33/46` coverage vs classic
`0.104404` / `0.086940` / `33/46` and V2 `0.096063` / `0.086125` /
`33/46`.

Across five seeds, S07 closes as a secondary near miss:
S07 `0.102481` HV / `0.088031` HV-AUC46 / `165/230` coverage vs
classic `0.103802` / `0.086982` / `164/230` and V2 `0.098801` /
`0.087428` / `166/230`.

Do not claim S07 as the primary PPA-HV win. It beats classic on
HV-AUC46 and coverage and beats V2 on HV/HV-AUC46, but it reaches only
98.7% of classic final HV. The next primary search should shift away
from capacity-only variants.

S07 final statistics and case-study artifacts are packaged under:

```text
suite_variant_campaign/S07_capacity3/five_seed_analysis/summary.md
suite_variant_campaign/S07_capacity3/five_seed_analysis/seed_paired_deltas.csv
suite_variant_campaign/S07_capacity3/five_seed_analysis/statistical_tests.json
suite_variant_campaign/S07_capacity3/five_seed_analysis/per_problem_win_loss_map.csv
suite_variant_campaign/S07_capacity3/five_seed_analysis/case_study_summary.csv
```

The descriptive seed-paired tests show mean HV delta `-0.001322`,
HV-AUC46 delta `+0.001049`, and coverage delta `+0.2` problems per seed.
`Prob015_multi_pipe_8bit` and `Prob024_fsm` are the positive mechanism
examples. Use this posture before launching targeted descriptor/BD
follow-ups.

## S21 Contract

S21 is the canonical one-elite MAP-Elites retention control:

```text
--qd_cell_mode scalar_elite
--qd_max_elites_per_cell 1
--qd_parent_selection nsga2_global_rank
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 8
--qd_rebinning_kind ks_triggered
--qd_operator_kind eoh_strategies
--classic_operator_kind eoh_strategies
--eoh_success_operator_set classic
--representation_kind code_individual
--max_tokens 128000
--diff_max_tokens 128000
--evaluation_mode strict_ablation
```

Seed 1001 is already packaged. It was coverage-positive but HV-negative:
S21 `0.089155` HV / `0.082753` HV-AUC46 / `34/46` coverage vs matched
classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` /
`0.083539` / `32/46`.

Seed 1002 is packaged. Do not promote S21: the two-seed read trails
classic on HV, HV-AUC46, and coverage and trails V2 on HV/HV-AUC46 while
only tying V2 coverage.

## Package Pointers

S07 seed 1001 was packaged with the same compact S20/S21/S22 structure:

```text
MANIFEST_YAML=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
MANIFEST_CSV=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_full_manifest.csv
CLASSIC=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5/seed_1001
V2=exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5/seed_1001
ARM=exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001
PKG=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/S07_capacity3/seed_1001
```

The standard package chain was run:

```text
uv run python scripts/report_pareto_analysis.py
uv run python scripts/report_ppa_distribution.py
uv run python scripts/report_hv_auc.py
uv run python scripts/audit_operator_contract.py
uv run python scripts/validate_natural_qd_run.py
```

Validation expectations included every S07 pin above. The run would be
invalid as a headline comparison if `single_thought_count` were nonzero
or if the QD config drifted from the registered flags.

Updated:

```text
suite_variant_campaign/README.md
suite_variant_campaign/results_log.md
suite_variant_campaign/variant_registry.csv
natural_qd_push_implementation_history.md
docs/journal_features/13_findings_dashboard.md
suite_variant_campaign/restart_handoff_20260709.md
```

S07 seed 1001 is classified as an HV-AUC-positive capacity-control
signal, not a promotion arm on one seed.
S09 is classified as a two-seed front-loss parent-source interpolation
control and should not be promoted to five seeds.
S21 remains classified as a negative scalar-retention control.

Compute HV-AUC46 with the fixed 46-problem denominator. Do not use a row
mean over `hv_auc.csv`, because sparse arms omit zero-coverage problems
and that inflates the score.

## If The Server Restarts

No benchmark process is active from this handoff. S07, S23, and S11 are
already packaged. There is no in-flight run to preserve across restart.

Do not launch another full-suite process from this handoff. The current
post-S11 decision is recorded in `post_s11_suite_decision.md`: the
registered config-first primary queue is closed negative/near-miss, and
S04/S05/S06 are reserve appendix options only unless a fresh decision note
selects one.

## Audit Feedback To Carry Forward

Recent read-only audits agree on the current posture:

- S07 is secondary trajectory/coverage evidence, not a primary PPA-HV
  win.
- S23 closes descriptor reduction as a primary path and blocks S31.
- S11 closes warmup interpolation and blocks S12.
- S04/S05/S06 are appendix-specific descriptor/coverage controls, not the
  next primary HV lane.
- A new primary experiment requires a mechanism card that explains which
  existing failure class it should defeat.

Historical audit guidance above this section is superseded when it talks
about active S07 seeds or front-slot/warmup launches. The live current
state is the top of this handoff plus `post_s11_suite_decision.md`.
