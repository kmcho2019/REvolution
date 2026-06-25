# Claude Periodic Review Prompt

Run a read-only adversarial review of the useful-BD/QD/MAP-Elites push.
Do not edit files. Inspect the local repository state and cite concrete
paths, commits, results, and stale docs where relevant.

Scope:
- `/workspace/AGENTS.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/goal_template.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_plan.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_todo.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_history.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_adversarial_prompt.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/best_current_techniques.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/research_strategy_recommendations.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/README.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_qwen_live_screen_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_masterrtl_front_slot_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_t11_top4_front_slot_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_aux_archive_high_exploit_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_aux_archive_front_breadth_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_aux_archive_high_exploit_depth_probe/`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/reviews/20260625_review_bundle/README.md`
- Latest commits from `git log --oneline -20`

Questions to answer:
1. Is the current preliminary plan finished enough to choose final full-RTLLM
   QD configs? If not, what concrete hard-data gaps remain?
2. Are the pretrained encoder claims honest? Check Qwen, DeepGate, MasterRTL,
   RTL-Timer, Aurora-like, graph-contrastive, and synthesized-netlist lanes.
3. Do the current docs avoid overclaiming after the negative Qwen, DeepGate,
   MasterRTL front-slot, T11 front-slot, auxiliary archive front-breadth, and
   auxiliary archive depth results?
4. Are reference-complete paired subset rules, missing-reference exclusion,
   candidate-PPA invalid accounting, and PPA-front/HV/HV-AUC metrics used
   consistently enough for a colleague-facing presentation?
5. Is the next research direction technically sound, or are we repeating
   failed geometry tweaks? Recommend the next 1-3 experiments.
6. Do the recent docs and scripts follow `/workspace/AGENTS.md` guidance:
   simple, skimmable, no excessive fallbacks, no defensive back-compat, focused
   commits, useful docs/docstrings/comments, and clean organization?
7. Are visualizations/tables sufficient and easy to understand, or are there
   concrete plots/tables that need to be added before sign-off?

Output format:
- Verdict: PASS / PASS_WITH_ACTIONS / FAIL
- Critical findings, ordered by severity
- Hard-data gaps before final RTLLM config selection
- Recommended next experiments
- Documentation and visualization fixes
- Commit/coding-practice observations
