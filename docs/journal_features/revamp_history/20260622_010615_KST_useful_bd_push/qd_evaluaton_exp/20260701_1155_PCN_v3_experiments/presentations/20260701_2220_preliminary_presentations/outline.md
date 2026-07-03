# Slide Outline

## Main Deck

1. **Title** - What kind of diversity helps RTL PPA evolution?
   Body: evidence timeline.
2. **Bottom Line** - Generic diversity is not enough; guarded PCN memory is
   the current best hypothesis.
   Body: lessons summary.
3. **Evidence Boundary** - What results are in scope and what claims are not
   allowed yet.
   Body: claim gates.
4. **Classic REvolution Baseline** - Why the conference baseline is strong.
   Body: classic hill-climbing pipeline.
5. **Why Scalar Fitness Looked Limiting** - Weighted fitness can select one
   PPA preference and hide tradeoffs.
   Body: scalar fitness versus Pareto concept.
6. **Metrics** - HV, HV-AUC, coverage, valid-PPA, Pareto points.
   Body: HV/HV-AUC explainer.
7. **Why QD Was A Natural Hypothesis** - MAP-Elites preserves behavior niches.
   Body: QD grid concept.
8. **20260629 Setup** - Broad full RTLLM attempt with Qwen3, MasterRTL,
   DeepGate, AURORA, hybrid descriptors, and FG-QDM.
   Body: method-family table.
9. **20260629 Result** - Classic wins clearly.
   Body: mean-HV retention plot.
10. **20260629 Coverage Loss** - QD arms also lost valid-PPA coverage.
    Body: coverage versus HV-retention scatter.
11. **Failure Was Not All Random** - Hybrid/source-aligned descriptors were
    less bad than pure Qwen/DeepGate.
    Body: 20260629 ranked evidence.
12. **Operator Mismatch** - Many QD arms used `single_thought_operator`.
    Body: operator mismatch diagram.
13. **Second Failure Mode** - Archive-driven search replaced too much classic
    hill climbing.
    Body: replacement versus memory diagram.
14. **Revised Hypothesis** - QD should be auxiliary memory, not the main
    optimizer.
    Body: PCN architecture.
15. **20260630 Corrected Rerun** - Restore EoH thought/code/feedback.
    Body: operator audit table.
16. **20260630 Full RTLLM Result** - PCN-v3 reaches 103.4% mean-HV retention.
    Body: corrected method comparison.
17. **PCN-v3 Mechanics** - Primary pool stays classic; memory-refine is small.
    Body: PCN architecture diagram.
18. **PCN Memory Was Active** - Memory-refine generated valid-PPA and front
    insertions.
    Body: memory mechanism funnel.
19. **But The Signal Is Small** - One seed, 9/9/28 win/loss/tie.
    Body: win/loss/tie plot.
20. **Qwen3 After Correction** - Qwen improves materially but does not beat
    classic.
    Body: Qwen operator correction plot.
21. **Encoder And RTL-Native Read** - DeepGate and MasterRTL are closer but not
    headline-positive.
    Body: corrected encoder comparison.
22. **C-F Confound** - PCN disabled two-parent fusion and also removed C-F.
    Body: C-F ablation setup.
23. **20260701 Smoke Operator Audit** - C-F restored in the right arms; no
    single-thought use.
    Body: C-F count plot.
24. **20260701 Smoke Metrics** - Positive smoke deltas, but n=3.
    Body: smoke comparison plot.
25. **What We Can Say Now** - Guarded memory is plausible; proof is pending.
    Body: claim-gate checklist.
26. **What The Better Algorithm Looks Like** - Classic-first, front-guarded,
    descriptor-aware memory.
    Body: recommended algorithm diagram.
27. **Next Experiment Ladder** - Five-seed RTLLM, C-F ablation, elite variants,
    VerilogEval holdout.
    Body: experiment ladder.
28. **Discussion Prompts** - Questions for colleagues.
    Body: three technical discussion questions.

## Appendix Deck

- Detailed classic REvolution mechanics.
- Generic QD/MAP-Elites mechanics.
- 20260629 method details.
- 20260630 corrected method details.
- PCN-v3 step-by-step mechanics.
- 20260701 C-F ablation arms.
- Known caveats and evidence discipline.
