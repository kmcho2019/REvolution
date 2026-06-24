# Claude T74 Registration Review

Date: 2026-06-24T00:50Z

Command:

```bash
claude -p 'Read-only review in /workspace. Review AGENTS.md/GUIDELINES.md guidance, the active useful-BD goal intent, and docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/ including best_current_techniques.md, current_results_matrix.md, technique_lanes.md, technique_lineage_ledger.md, useful_bd_push_implementation_todo.md, useful_bd_push_implementation_history.md, anti_reward_hacking_policy.md, phase_03_1_visualization_contract.md, and techniques/T74_shape_density_front_slot_hybrid_qd/. Focus on whether the T74 registration is technically coherent after T72/T73, whether it correctly handles the single_thought_operator arity nuance, whether anti-gaming gates and visualization requirements are sufficient, and whether the docs avoid overclaiming. Also flag any GUIDELINES.md simplicity/organization issues. Do not edit files. Return concise findings with severity and concrete file references.'
```

## Verdict

Claude judged the T74 registration technically coherent and confirmed that
the single-thought arity nuance is handled correctly. It found no result
overclaiming.

## Findings

1. Medium: T74 is underpowered because `qd_operator_one_parent_fraction=0.90`
   means only about 10% of success-parent prompts request two parents. A null
   or small positive result should be interpreted cautiously.
2. Medium-low: the required descriptor-distance audit for realized two-parent
   prompts needs an explicit producing command.
3. Medium-low: `commands/live_screen_v0.md` should include frozen Phase 03.1
   viewer export and validation commands.
4. Low: `technique_lineage_ledger.md` used loose "or" comparator wording that
   could imply beating only a weak comparator is enough.
5. Low: `t74_method_contract.json` listed only classic/T72/T73 as primary
   comparators while the methodology also requires T51/T66/T67 context.
6. Low: probe JSON has top-level `requires_dynamic_metrics`, while prose says
   `requires_simulation`; the per-axis summary does include
   `requires_simulation=false`.

## Resolution Plan

- Add the underpowered-intervention caveat to `methodology.md`.
- Add package-local audit tooling or a frozen command for realized two-parent
  descriptor-distance checks.
- Add frozen Phase 03.1 viewer export and validation commands.
- Tighten the lineage comparator wording.
- Expand the method contract comparator fields so headline and context
  comparators are explicit.

## Resolution

The registration now records the underpowered-intervention caveat, includes the
package-local two-parent descriptor audit script and command, freezes the Phase
03.1 export/validation commands, tightens the lineage promotion wording, and
lists every intended comparator in `tables/t74_method_contract.json`.
