# Restart Handoff - 2026-07-09

Last updated: 2026-07-10T01:52:00Z.
Branch: `feat/journal-qd-bd-exp-20260703`.
Current completed result package:
`suite_variant_campaign/S07_capacity3/seed_1005`.

## Immediate State

S07 capacity3 seed 1005 has completed and been packaged. There is no
active benchmark or report process at this handoff.

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

S07 seed 1004 is the only active run from this handoff. Let it finish
before launching another full-suite process. If a restart interrupts it,
inspect the active launch log above and package only if all 50 RTLLM
problems completed.

S07 seed 1003 is already packaged and does not need to be preserved as a
process.

## Audit Feedback To Carry Forward

Read-only narrative audit verdict: V2 remains the primary natural journal
extension unless a later full-suite variant beats classic. S21 should close
the scalar MAP-Elites control, not become a new paper arm on weak coverage
alone.

Read-only organization audit verdict: WARN, not FAIL. Operator parity was
clean in sampled packages, but the campaign has bloat and command-spec
risks:

- `suite_variant_campaign/` is too large because early S01-S03 packages
  kept broad PNG/problem trees. Future packages should stay compact.
- Wave B should get first-class launch documentation before more runs.
- Launch parity pins are easy to omit because `scripts/run_backend.py`
  defaults are not the V2 suite contract.
- Keep future S29/S30 ideas out of central `QDEngine` until a small typed
  module is justified.
- Resolve the typo file `suite_campagin_initial_message.md` later.

Claude CLI review was attempted but unavailable due the weekly limit until
2026-07-10 08:00 UTC.

Read-only experimental-validity audit verdict: completing S21 seed 1002 is
justified as the pre-registered scalar MAP-Elites control, but promotion
language must stay strict. A coverage-only claim would need coverage above
both classic and V2 with a bounded HV tax. The audit recommends
front-slot parent-source interpolation as the strongest next full-suite
direction if the campaign continues after restart.

Read-only post-S07 experimental audit verdict: confirm S07 to five seeds
before opening a new mechanism. S07 is the only current lane within about
1.5% of matched classic final HV while already beating classic HV-AUC46
and tying classic coverage across two seeds.

Read-only post-S07 organization audit verdict: fix stale command state
before launching. The S07 seed 1001/1002 command blocks are now
historical; S10 is blocked by S09/S22 evidence; S08/S19 are deferred;
S12 is blocked behind an S11 signal; and the seed 1003 command block is
self-contained with `classic_operator_kind=eoh_strategies`.

## Next Campaign Step After S07 Two-Seed Closure

The conservative next executable steps are:

1. Let S07 capacity3 seed 1004 finish and package it with the standard
   compact report chain.
2. Keep S22 as an HV-AUC-positive front-slot control, not a primary arm.
3. Keep S04/S05 descriptor completion for descriptor-health evidence if
   S07 confirmation does not clear the primary final-HV gate.

Avoid combination arms unless a single-factor full-suite result gives a
positive signal.

## Post-S22 Launch Guidance

Read-only sub-agent audit after S22 closure recommends stopping launches
before the server restart. Do not launch S10 from the current evidence:
Wave B only justified the stronger 0.40 front-slot lane if S09 showed a
positive HV/AUC signal without major coverage loss, and both S09 and S22
missed the primary classic final-HV gate.

If the campaign resumes after restart, first add an exact launch block
for the selected variant with all V2 parity pins expanded. The generic
command template is not enough; the invalid S09 attempt showed that
missing `qd_champion_lane_fraction=0.5` can silently invalidate a run.
Keep future packages compact and do not copy broad figure trees into
docs.

S07 capacity3 seed 1003 is now packaged. S07 seed 1004 is active. Do not
describe S07 as promotion-ready unless the final five-seed aggregate
clears the primary final-HV and coverage gates.
