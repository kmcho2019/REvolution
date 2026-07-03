# Brainstorming Prompt

You are a senior research reviewer. We need a practical path to make a
QD-compatible RTL PPA optimizer outperform or closely match classic REvolution
on reference-complete RTLLM hypervolume.

Read the bundle, especially:

- `evidence/current_goal_docs/central_comparison_report.md`
- `evidence/current_goal_docs/current_selection_status.md`
- `evidence/current_goal_docs/technique_lineage_ledger.md`
- `evidence/preliminary_planning/20260626_rf_leafid_structural_delayed_probe/results_report.md`
- `evidence/preliminary_planning/20260626_rf_leafid_seed_robustness_gate/seed_robustness_report.md`
- `evidence/preliminary_planning/20260626_deepgate_delayed_high_exploit_probe/results_report.md`
- `evidence/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/results_report.md`
- `evidence/preliminary_planning/20260626_aurora_raw_impl_delayed_probe/results_report.md`
- `evidence/preliminary_planning/20260626_fg_qdm_contribution_audit/results_report.md`
- `evidence/techniques/T100_front_credit_rf_leafid_fg_qdm_memory/results_report.md`

Return:

1. The three most plausible new method ideas.
2. For each idea, the precise mechanism and why it might beat classic.
3. Which existing code path or technique it should start from.
4. The smallest screening experiment that should be run first.
5. What result would promote it to full RTLLM.
6. What result would retire it.
7. The biggest reward-hacking or overclaim risk.

Be direct. It is acceptable to recommend that QD be used only lightly. The
goal is not to defend MAP-Elites purity. The goal is to find any defensible
variant where diversity improves PPA-front search.
