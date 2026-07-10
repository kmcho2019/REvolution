# Validation And Claims Plan

This is a proposed review plan, not a new frozen contract. The advisor should
approve or revise it before any new primary run.

## Stage 0: Claims And Zero-Compute Audit

1. Preserve `journal_narrative.md` revision 3 unchanged.
2. Write a versioned method/claims addendum for Pareto REvolution before any
   launch. Reuse the frozen measurement and statistical protocol.
3. Recompute classic-no-C-F versus classic through the canonical penalized
   cluster-bootstrap reporter, including HV, HV-AUC, coverage, token/call
   budgets, leave-one-seed-out, and per-problem deltas.
4. Audit whether current generation logs are sufficient for a retrospective
   count of globally nondominated candidates lost by per-cell retention.
5. Freeze the implementation, comparator roots, seeds, and module manifests.

## Stage 1: Pareto REvolution

Full RTLLM is the primary triage surface because the small screen transfers
weakly.

| Step | Scope | Decision |
| --- | --- | --- |
| Technical smoke | 46 ref-complete, seed 1001 | Stop only for validation/operator failure, <90% classic HV, or coverage at least four problems below classic. |
| Full-suite probe | seeds 1001-1002 | Promote only if mean final HV is at least matched classic and coverage is at least matched classic. |
| Confirmation | seeds 1001-1005 | Decide the method claim with paired cluster statistics and frozen gates. |
| Held-out confirmation | untouched held-out reference set | Required for any new positive headline. |

Primary metrics remain final global PPA HV and functional valid-PPA
coverage. HV-AUC is secondary. Report Pareto cardinality, per-axis wins,
valid-PPA yield, and deliverable-front utility as mechanism evidence.

Promotion language:

- **Performance win:** final HV improves over classic with the frozen
  statistical gate and coverage does not decline.
- **Pareto-deliverable result:** only if the preregistered parity condition
  holds and the delivered front adds utility under the existing 0.25 rule.
- **Negative:** no metric substitution if final HV fails. Retain the result as
  the descriptor-free control for the QD characterization.

Required controls:

- original classic REvolution;
- Smooth-QD V2;
- classic without C-F when operator sets differ;
- scalar-survivor Pareto-archive control if needed to isolate retention from
  reporting-only archiving.

## Stage 2: Reference-Seeded Optimization

Begin only after the seed path, locked RealBench PPA manifest, and
equivalence policy are validated.

Minimum decisive set: 6-10 e203 modules spanning small, medium, and larger
contexts, mostly from the 23 modules with nondegenerate timing, plus one or two
combinational controls.

Budget-matched arms:

1. seeded scalar REvolution;
2. seeded Pareto REvolution;
3. seeded iterative feedback/refinement without population evolution.

The immutable reference seed may serve as a parent and fallback, but it is
excluded from descendant coverage and improvement counts.

Promotion gate for a larger confirmation:

- at least half of module-seed units produce a non-identical, functionally
  passing, valid-PPA descendant;
- every candidate counted in the headline PPA-improvement statistic passes
  the preregistered formal-equivalence procedure, with testbench-only
  descendants reported separately;
- the seeded Pareto arm matches or exceeds seeded scalar HV and valid
  descendant coverage;
- improvements are not explained by deleted logic, missing outputs,
  degenerate synthesis, or one module jackpot;
- duplicate synthesis and clock-sensitivity checks do not reverse the result.

Use a stricter manuscript claim set if formal equivalence is unavailable for
a module. Testbench-passing results remain labeled as such and never become
equivalence claims.

## Stage 3: Final Evidence

- Five preregistered seeds for any main method.
- Held-out RTLLM/VerilogEval evidence for the Pareto selection claim.
- Fresh or version-locked RealBench modules for seeded optimization.
- CVDP remains a functionality-only cross-suite check unless a valid PPA
  reference contract is introduced before the run.
- Report full evaluated histories for gate-bearing HV and retained fronts for
  engineer-deliverable claims. Do not conflate the two pools.

## Anti-Gaming Checklist

- Exclude unchanged reference seeds from improvement and coverage claims.
- Count duplicates once and disclose canonicalization.
- Require explicit reason codes for missing candidate PPA.
- Keep HV-AUC secondary to final HV.
- Keep reference-missing problems out of normalized PPA claims.
- Run formal equivalence or clearly scoped stronger simulation on claimed
  large-design improvements.
- Add four-state spot checks for showcased RealBench candidates.
- Re-run sampled candidates to quantify synthesis determinism.
- Report absolute PPA beside normalized gains.
- Preserve the synthesis-stage proxy language; do not imply signoff quality.
