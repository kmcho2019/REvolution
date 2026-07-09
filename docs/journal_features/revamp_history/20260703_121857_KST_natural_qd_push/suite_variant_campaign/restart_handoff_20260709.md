# Restart Handoff - 2026-07-09

Last updated: 2026-07-09T03:28:16Z.
Branch: `feat/journal-qd-bd-exp-20260703`.
Previous completed result package: `20762fb77c` (`docs(qd): Package S21 seed 1001`).

## Immediate State

Do not launch another long full-suite run before the planned server restart.
The S21 seed 1002 long-running benchmark has completed and been packaged.
There is no active full-suite process from this handoff.

```text
run root:
exp/natural_qd_push/suite_variants_wave_b_20260709_020320_UTC/live/scalar_elite_nsga2/seed_1002
launch log:
exp/natural_qd_push/suite_variants_wave_b_20260709_020320_UTC/launch_scalar_elite_nsga2_seed1002.log
preflight:
suite_variant_campaign/preflights/s21_scalar_elite_nsga2_seed1002_20260709_020320_UTC.json
package:
suite_variant_campaign/S21_scalar_elite_nsga2/seed_1002
```

Observed at this handoff: S21 seed 1002 completed all 50 RTLLM problems
normally in 4751.68 seconds with 4800 LLM API calls. The package passes
the full 50-problem run validation and operator audit.

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

Seed 1002 was packaged with the same compact structure as seed 1001:

```text
MANIFEST_YAML=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml
MANIFEST_CSV=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_full_manifest.csv
CLASSIC=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5/seed_1002
V2=exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5/seed_1002
ARM=exp/natural_qd_push/suite_variants_wave_b_20260709_020320_UTC/live/scalar_elite_nsga2/seed_1002
PKG=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/S21_scalar_elite_nsga2/seed_1002
```

The standard package chain was run:

```text
uv run python scripts/report_pareto_analysis.py
uv run python scripts/report_ppa_distribution.py
uv run python scripts/report_hv_auc.py
uv run python scripts/audit_operator_contract.py
uv run python scripts/validate_natural_qd_run.py
```

Validation expectations included every S21 pin above. The run would be
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

S21 is classified as a negative scalar-retention control.

Compute HV-AUC46 with the fixed 46-problem denominator. Do not use a row
mean over `hv_auc.csv`, because sparse arms omit zero-coverage problems
and that inflates the score.

## If The Server Restarts

No S21 process needs to be preserved. After restart, verify the package
and docs are present, then decide whether to stop for analysis or prepare
the next registered full-suite run only after the user confirms the
server is ready.

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

## Next Campaign Step After S21

No new long process should start before the restart. After restart and
S21 closure, the conservative next executable options are:

1. S09/S22 front-slot interpolation as an AUC/utility check with a
   fresh mechanism card.
2. S04/S05 descriptor completion to five seeds if descriptor-health
   evidence is needed.
3. S07/S08 capacity interpolation only if coverage remains worth probing.

Avoid combination arms unless a single-factor full-suite result gives a
positive signal.
