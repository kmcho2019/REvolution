› We want to check a few things first I want to check if our pcn_v3_rf_stagnation_memory_8x5 outperforming classsic REvolution is valid statistically so we
  might compare across 5 runs to check if our pcn_v3 outperforms it satistically. Another thing I want to check is if the presence or absence of c-f operator
  is a confounder. Example of experiments we can run to check:  What Happened

    In pcn_v3_rf_stagnation_memory_8x5, the config sets:

    --qd_two_parent_probability 0.00
    --qd_two_parent_gate none

    The QD engine then uses _success_parent_arity() to decide whether success-pool requests are one-parent or two-parent. Because qd_two_parent_probability =
    0.00, _success_parent_arity() always returns 1.

    In the PCN success-request branch, arity == 1 restricts the available success strategies to:

    M-S, M-E, M-R, M-I

    and excludes:

    C-F

    So although the method is labeled eoh_strategies, it is not exactly the same success-operator set as classic REvolution. It is EoH-style, but one-parent
    only.

    Observed Counts

    Full RTLLM generated strategy counts:

     Method                             C-F Count    Main Success Operators
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━
     classic_revolution_8x5                   231    M-S, M-E, M-R, M-I, C-F
    ─────────────────────────────────  ───────────  ─────────────────────────
     pcn_v3_rf_stagnation_memory_8x5            0    M-S, M-E, M-R, M-I

    So yes: PCN differed from classic in two ways:

    1. It added guarded QD memory.
    2. It removed C-F.

    That means the current full-run result is not a perfectly isolated test of PCN memory.

    Why Was It Disabled?

    The immediate reason is implementation/configuration: PCN memory mode disables two-parent fusion globally through qd_two_parent_probability = 0.00.

    The research reason was probably reasonable at the time: prior QD variants showed that two-parent fusion, especially descriptor-diverse/archive fusion,
  often
    hurt RTL quality by mixing structurally incompatible parents. So the PCN design intentionally avoided two-parent QD fusion.

    But the implementation made that broader than intended. It also disabled classic C-F inside the “classic-preserving” segment. That is not ideal, because
  the
    premise was supposed to be:

    > preserve classic REvolution, then add small memory recall.

    The actual run was closer to:

    > classic one-parent EoH mutation/refinement plus small memory recall.

    Does This Invalidate The Result?

    It does not invalidate the result, but it changes the interpretation.

    The safe interpretation is:

    > A conservative, one-parent EoH + PCN memory variant beat classic by a small margin.

    The unsafe interpretation is:

    > QD memory alone beat classic.

    We do not yet know that. We need an ablation.

    Needed Ablation

    To separate the effects, we need at least these arms:

     Arm                              Purpose
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     classic_revolution_8x5           Original baseline with C-F
    ───────────────────────────────  ──────────────────────────────────────────────────────────────────
     classic_no_cf_8x5                Tests whether disabling C-F alone improves classic
    ───────────────────────────────  ──────────────────────────────────────────────────────────────────
     pcn_v3_no_cf_memory_8x5          Current PCN behavior
    ───────────────────────────────  ──────────────────────────────────────────────────────────────────
     pcn_v3_cf_restored_memory_8x5    Tests PCN memory while restoring classic C-F in the classic lane

    The key comparisons are:

    classic_no_cf - classic

    measures the benefit or harm of disabling C-F.

    pcn_v3_no_cf_memory - classic_no_cf

    measures memory’s benefit after controlling for C-F.

    pcn_v3_cf_restored_memory - classic

    measures the cleanest version of the original claim.

    My Assessment

    This is an important catch. The PCN result is still promising, but we should not present it as clean proof that QD memory alone caused the gain. The next
    rigorous step is a C-F ablation. If PCN still beats classic_no_cf, then the QD-memory mechanism has real evidence. If classic_no_cf matches PCN, then the
    “win” was mostly an operator simplification result..

    Also another thing I am considering is if the   one scalar champion + one locally useful tradeoff
  slot, max_elites_per_cell = 2 setup currently used in pcn_v3_rf_stagnation_memory_8x5 could also be enhanced as well because scalar champion might mean that
  we have to use hyperparameters because of weighted average of ppa improvements (it would be a lot cleaner if we could do something like just pareto front
  elite samples + ngsa-ii based crowding metric for selecting elites per cell, we could maybe also experiment with increasing the elites per cell to 3 or more
  to check if it helps with performance). Finally I think we might want to also check if our pcn_v3 config compares against classic REvolution on VerilogEval
  spec-to-RTL as well. Maybe we could place the entire experiments logs, report, analysis, figures, tables, data, conclusions within /workspace/docs/
  journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments with the report/log/figure/analysis
  structure taken from the RTLLM_full_suite practices

  # PCN-v3 Statistical And C-F Ablation Plan

  ## Summary

  Create a new experiment package at:

  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments

  The goal is to answer three questions cleanly:

  1. Is the observed pcn_v3_rf_stagnation_memory_8x5 advantage over classic statistically credible across 5 seeds?
  2. Is the apparent gain actually caused by disabling C-F rather than PCN memory?
  3. Does the RF/MasterRTL/RTLTimer memory design generalize beyond RTLLM, including VerilogEval Spec-to-RTL?

  Defaults chosen because no answer was provided to the prompt:

  - Stage then expand.
  - RTLLM first, VerilogEval second.
  - Keep 8x5 for the main ablation.

  ## Key Changes

  Add one narrow operator-control interface:

  --eoh_success_operator_set {classic,one_parent}

  - classic: M-S, M-E, M-R, M-I, C-F.
  - one_parent: M-S, M-E, M-R, M-I.
  - Default: classic.
  - This must affect classic REvolution and the PCN classic lane.
  - It must not enable QD/archive two-parent fusion.
  - PCN can keep --qd_two_parent_probability 0.00 while still allowing classic-lane C-F when --eoh_success_operator_set classic.

  Run these RTLLM core arms across seeds 1001..1005:

   Arm                              Purpose
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   classic_revolution_8x5           Original baseline with C-F
  ───────────────────────────────  ──────────────────────────────────────────
   classic_no_cf_8x5                Tests whether removing C-F alone helps
  ───────────────────────────────  ──────────────────────────────────────────
   pcn_v3_no_cf_memory_8x5          Current PCN behavior, explicit no-C-F
  ───────────────────────────────  ──────────────────────────────────────────
   pcn_v3_cf_restored_memory_8x5    Clean PCN test with classic C-F restored

  Then run elite-cell variants only if the core ablation validates PCN memory:

   Arm                               Purpose
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   pcn_v3_cf_restored_pareto3_8x5    Pure local Pareto/crowding cell, 3 elites
  ────────────────────────────────  ───────────────────────────────────────────
   pcn_v3_cf_restored_elite3_8x5     Current champion+slots model, 3 elites

  Use existing qd_cell_mode=pareto_front for the pure Pareto variant; avoid new archive code unless tests show existing behavior is insufficient.

  Run VerilogEval Spec-to-RTL only after RTLLM:

   Arm                              Purpose
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━
   classic_revolution_8x5           Baseline
  ───────────────────────────────  ──────────────────────────
   classic_no_cf_8x5                C-F confound check
  ───────────────────────────────  ──────────────────────────
   pcn_v3_cf_restored_memory_8x5    Best clean PCN candidate

  ## Reporting And Analysis

  Package the milestone with:

  - README.md: navigation and status.
  - experiment_plan.md: frozen protocol and claims allowed.
  - method_configs.md: exact CLI flags and descriptor definitions.
  - commands/: launch scripts and per-method wrappers.
  - logs/: run logs and done/failed markers.
  - tables/: per-seed, per-problem, and aggregate metrics.
  - figures/: publication-style plots.
  - reports/: final report, C-F ablation report, mechanism report.
  - analysis/: raw derived CSV/JSON used to regenerate plots.

  Primary RTLLM comparisons:

  - classic_no_cf - classic: effect of removing C-F.
  - pcn_v3_no_cf_memory - classic_no_cf: memory effect after controlling for C-F absence.
  - pcn_v3_cf_restored_memory - classic: clean PCN-vs-classic claim.
  - pcn_v3_cf_restored_memory - pcn_v3_no_cf_memory: whether restoring C-F helps or hurts PCN.

  Statistical summaries:

  - Paired per-problem/per-seed HV deltas.
  - Paired bootstrap confidence intervals.
  - Wilcoxon signed-rank test where enough paired nonzero deltas exist.
  - Sign test win/loss/tie counts.
  - Seed-level aggregate mean HV and HV-AUC.
  - Reference-complete RTLLM subset only for headline normalized metrics.

  Figures:

  - Seed-wise HV delta distributions.
  - Per-problem win/loss heatmap.
  - Classic vs PCN scatter with diagonal.
  - C-F count by method.
  - Memory-lane contribution by method and seed.
  - Pareto/front count comparison.
  - Valid-PPA coverage funnel.

  ## Test Plan

  Before launching full 5-seed RTLLM:

  - Unit test --eoh_success_operator_set in classic mode:
      - classic allows C-F when two success parents exist.
      - one_parent never schedules C-F.

  - Unit test PCN mode:
      - qd_two_parent_probability=0.00 still disables QD/archive fusion.
      - eoh_success_operator_set=classic restores classic-lane C-F.
      - eoh_success_operator_set=one_parent reproduces current PCN behavior.

  - Smoke run one or two RTLLM problems for all four core arms.
  - Audit generated strategy counts:
      - classic and PCN-CF-restored must have possible nonzero C-F.
      - classic-no-CF and PCN-no-CF must have exactly zero C-F.

  Validation commands:

  - uv run pytest for touched tests.
  - uv run ruff check on touched files.
  - uv run python -m pyright on touched source modules if feasible.
  - git diff --check.
  - Run packaging script and verify all tables/figures regenerate from saved run roots.

  ## Assumptions

  - Main budget remains population_size=8, num_generations=5.
  - Seeds are 1001, 1002, 1003, 1004, 1005.
  - Headline RTLLM metrics exclude designs missing reference ppa.txt.
  - Missing candidate PPA is counted as invalid for that method.
  - The first publication-safe claim must be conservative: PCN memory is credited only if it improves over classic_no_cf, not merely over original classic.
