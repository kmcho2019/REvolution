  # Preliminary QD/PCN Presentation Package Plan

  ## Summary

  Create a Markdown-based slide package at:

  /workspace/docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/
  presentations/20260701_2220_preliminary_presentations

  The presentation will tell a cautious evidence-driven story:

  1. Classic REvolution is a strong hill-climbing baseline but uses scalar fitness and has no explicit diversity memory.
  2. Straightforward QD/MAP-Elites with pretrained or learned descriptors failed badly in the 20260629 RTLLM full suite.
  3. The main failure was not only “QD is bad”; many QD arms also used the degraded single_thought_operator.
  4. The corrected 20260630 EoH-preserving suite sharply reduced the regression, and PCN-v3 produced a positive one-seed signal: 103.4% mean-HV retention
     versus classic.

  5. The best current hypothesis is not “replace classic with MAP-Elites,” but “preserve classic exploitation and add small guarded diversity memory.”
  6. The newest 20260701 PCN-v3 smoke confirms the C-F confound is real and motivates the ongoing five-seed ablation, but smoke results remain
     preliminary.

  No 20260701 full-run data should be used in headline slides. Only 20260701 smoke data is included unless a later explicit request updates that evidence
  boundary.

  ## Artifacts To Create

  Create this structure:

  20260701_2220_preliminary_presentations/
    README.md
    outline.md
    slides.md
    appendix_methods.md
    evidence_map.md
    data/
      raw/
      derived/
      README.md
    figures/
      copied/
      generated/
      concepts/
      README.md
    tables/
      README.md
    reviews/
      adversarial_checklist.md

  Artifact roles:

  - README.md: navigation, evidence boundary, and claim discipline.
  - outline.md: slide-by-slide outline created before slides.md.
  - slides.md: main Markdown deck, 25-30 primary slides plus appendix pointers.
  - appendix_methods.md: detailed step-by-step method descriptions for likely colleague questions.
  - evidence_map.md: maps every claim to source tables, reports, and figures.
  - data/raw/: copied source CSVs from 20260629, 20260630, and 20260701 smoke.
  - data/derived/: generated comparison tables used by the deck.
  - figures/copied/: exact copied source-package figures for sanity comparison.
  - figures/generated/: regenerated presentation-style plots from copied raw tables.
  - figures/concepts/: diagrams or imagegen-style visual aids for algorithm concepts.
  - reviews/adversarial_checklist.md: manual adversarial review checklist in place of sub-agent review for this side-conversation scope.

  ## Data Sources

  Copy, do not move, these source artifacts into data/raw/:

  - 20260629:
      - RTLLM_full_suite/20260629/tables/full_suite_method_summary.csv
      - RTLLM_full_suite/20260629/tables/full_suite_problem_metrics.csv
      - RTLLM_full_suite/20260629/method_configs.md
      - RTLLM_full_suite/20260629/report.md

  - 20260630:
      - RTLLM_full_suite/20260630/tables/full_suite_method_summary.csv
      - RTLLM_full_suite/20260630/tables/full_suite_problem_metrics.csv
      - RTLLM_full_suite/20260630/analysis/full/operator_contract.csv
      - RTLLM_full_suite/20260630/analysis/full/pcn_memory_mechanism_summary.csv
      - RTLLM_full_suite/20260630/reports/full_report.md
      - RTLLM_full_suite/20260630/reports/pcn_memory_mechanism.md
      - RTLLM_full_suite/20260630/method_configs.md

  - 20260701 smoke:
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_smoke_method_seed_summary.csv
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_smoke_comparison_summary.csv
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_smoke_paired_deltas.csv
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/analysis/rtllm_smoke/seed_1001/operator_contract.csv
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/reports/rtllm_smoke_report.md
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/experiment_plan.md
      - qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/experiment_todo.md

  Copy these source figures into figures/copied/ for reference:

  - 20260629 full-suite figures: mean HV, HV-AUC, delta, coverage, heatmap, Pareto count.
  - 20260630 full-suite figures: same set plus pcn_memory_front_contributions.png.
  - 20260701 smoke figures: mean HV, C-F count, delta HV, delta HV-AUC, PCN scatter.

  All regenerated plot values must match the copied raw CSVs, not numbers manually typed from reports.

  ## Generated Figures And Tables

  Generate these presentation-ready figures from copied raw data:

  1. timeline_story.png
      - Three evidence stages: 20260629 failure, 20260630 corrected signal, 20260701 C-F smoke audit.

  2. scalar_fitness_vs_pareto.png
      - Concept diagram showing weighted scalar fitness choosing one direction while HV/Pareto recognizes tradeoffs.

  3. hv_hv_auc_explainer.png
      - Simple visual definition of final HV versus HV-over-generation AUC.

  4. 20260629_method_retention.png
      - Bar chart of mean HV retention: classic 100%, best QD 73.4%, Qwen 43.1%.

  5. 20260629_coverage_vs_hv_retention.png
      - Scatter or bubble plot showing coverage loss and HV loss together.

  6. operator_mismatch_diagram.png
      - Flow diagram contrasting classic EoH thought/code/feedback versus QD single-thought operator path.

  7. 20260630_method_retention.png
      - Bar chart showing PCN-v3 103.4%, classic 100%, DeepGate 93.5%, MasterRTL 91.6%, Qwen 89.5%.

  8. 20260630_pcn_win_loss.png
      - Compact 9 win / 9 loss / 28 tie visual.

  9. pcn_memory_mechanism.png
      - Uses PCN mechanism counters: 86 memory-refine candidates, 62 valid-PPA, 9 local-front adds, 5 global-front adds.

  10. 20260701_smoke_cf_audit.png
      - C-F counts and single-thought counts for the four smoke arms.

  11. 20260701_smoke_comparison.png
      - Smoke HV deltas for classic_no_cf - classic, pcn_no_cf - classic_no_cf, and pcn_cf_restored - classic.

  12. recommended_algorithm_shape.png
      - Conceptual architecture: classic primary pool dominates, PCN memory passively retains near-front families, memory-refine fires only under gates.

  Optional imagegen/concept figures:

  - One clean illustrative image for “illumination vs hill climbing” if data plots feel too abstract.
  - One clean conceptual diagram for “QD as auxiliary memory, not replacement optimizer.”

  Save any image-generation prompt text beside the image as .prompt.md.

  ## Main Deck Outline

  Target: 28 primary slides plus appendix pointers.

  1. Title: “What Kind Of Diversity Helps RTL PPA Evolution?”
      - Body: timeline visual.

  2. Question And Bottom Line
      - Diversity is not automatically useful; guarded memory is the current promising form.

  3. Classic REvolution Baseline
      - Explain EoH thought/code/feedback hill climbing.
      - Body: classic pipeline diagram.

  4. Why We Suspected A Limitation
      - Scalar weighted fitness can bias toward one PPA direction.
      - Body: scalar fitness vs Pareto diagram.

  5. Metrics Used In This Talk
      - HV, HV-AUC, coverage, valid-PPA, Pareto points.
      - Body: HV/HV-AUC explainer.

  6. Why QD/MAP-Elites Was A Natural Hypothesis
      - Preserve diverse behavior niches while improving quality.
      - Body: MAP-Elites grid concept.

  7. What We Tried In 20260629
      - Qwen3, MasterRTL/RF, DeepGate, AURORA, hybrid descriptors, FG-QDM.
      - Body: method-family matrix.

  8. 20260629 Result: Broad Negative
      - Classic wins mean HV, HV-AUC, coverage, Pareto count.
      - Body: 20260629 retention plot.

  9. 20260629 Failure Was Not Uniformly Random
      - Hybrid RF+DeepGate and MasterRTL RF were less bad than pure Qwen/DeepGate.
      - Body: ranked method table or bar.

  10. But The Key Confound Was Operator Mismatch

  - Classic used EoH; QD used single_thought_operator.
  - Body: operator mismatch diagram.

  11. Why Single-Thought Was A Problem

  - It removed the strong evolutionary operator and individual formulation.
  - Body: side-by-side operator stack.

  12. Second Failure Mode: Archive Replaced Hill Climbing

  - Aggressive MAP-Elites sampling consumed exploitation budget.
  - Body: budget allocation diagram.

  13. Revised Hypothesis

  - QD should supplement classic, not replace it.
  - Body: “replacement QD” crossed out versus “PCN memory” architecture.

  14. Corrected 20260630 Rerun

  - EoH operators restored, thought/code/feedback preserved.
  - Body: operator audit mini-table showing single_thought_count=0.

  15. 20260630 Full RTLLM Results

  - PCN-v3 reaches 103.4% mean-HV retention; others trail.
  - Body: 20260630 retention plot.

  16. What PCN-v3 Actually Does

  - Classic pool remains primary; memory stores PPA-competitive families; memory-refine is small and gated.
  - Body: PCN architecture diagram.

  17. PCN Mechanism Was Active

  - 86 memory-refine candidates, 62 valid-PPA, 9 local-front adds, 5 global-front adds.
  - Body: mechanism funnel.

  18. Why The PCN Signal Is Promising But Not Final

  - One seed, small 3.4% HV gain, 9/9/28 win/loss/tie.
  - Body: win/loss/tie visual.

  19. Qwen3 Under Corrected Operators

  - Completed pretrained encoder lane; improved over 20260629 but still trails classic.
  - Body: Qwen retention comparison across 20260629 and 20260630.

  20. MasterRTL And DeepGate Under Corrected Operators

  - Better than failed QD but not headline-positive.
  - Body: grouped encoder comparison.

  21. The C-F Confound

  - PCN-v3 disabled QD fusion but also removed classic C-F.
  - Body: C-F operator-set diagram.

  22. 20260701 Smoke Ablation

  - Four arms: classic, classic-no-C-F, PCN-no-C-F, PCN-C-F-restored.
  - Body: smoke design matrix.

  23. Smoke Operator Audit

  - Classic and PCN-CF-restored had C-F; no-CF arms had zero; all had no single-thought.
  - Body: C-F count figure.

  24. Smoke Metric Signal

  - PCN-CF-restored strongest, but n=3 and not final.
  - Body: smoke delta plot.

  25. Current Claim Discipline

  - Do not claim statistical proof yet; five-seed run is required.
  - Body: claim-gate checklist.

  26. What We Think We Learned

  - Generic diversity is weak; descriptor-only MAP-Elites loses exploitation; guarded memory is plausible.
  - Body: three-column lessons figure.

  27. What A Stronger Algorithm Should Look Like

  - Classic-first, small memory lane, front guards, operator-preserving, descriptor sanity checks.
  - Body: recommended algorithm shape diagram.

  28. Next Experiments

  - Five-seed RTLLM, C-F ablation, elite-cell variants only if core passes, VerilogEval holdout.
  - Body: experiment ladder.

  29. Discussion Slide

  - Three explicit questions for colleagues:
      - Is PCN memory a real mechanism or operator confound?
      - Which descriptors are worth making more faithful?
      - What budget/depth is fair for QD?

  ## Appendix Content

  Create appendix_methods.md with detailed sections for:

  1. Classic REvolution
      - Parent pool, EoH operators, thought/code/feedback representation, scalar fitness role.

  2. QD/MAP-Elites Generic Template
      - Descriptor extraction, archive cell assignment, elite retention, parent sampling, PPA objective use.

  3. 20260629 QD Arms
      - Qwen canonical RTL PCA3.
      - MasterRTL RF leaf ID plus structural descriptors.
      - DeepGate pooled graph PC3.
      - RF+DeepGate hybrid.
      - AURORA raw implementation compact descriptor.
      - MasterRTL delayed archive activation.
      - FG-QDM RF leaf-ID front-credit.

  4. 20260630 Corrected Arms
      - EoH-preserving Qwen3.
      - EoH-preserving DeepGate.
      - EoH-preserving MasterRTL archive activation.
      - PCN-v3 RF stagnation memory.

  5. PCN-v3 Mechanics
      - Primary classic pool.
      - Passive memory insertion.
      - RF/MasterRTL/RTLTimer descriptor role.
      - Stagnation trigger.
      - Memory-refine lane.
      - Local/global front contribution counters.
      - Why it differs from full MAP-Elites.

  6. 20260701 C-F Ablation Arms
      - classic_revolution_8x5.
      - classic_no_cf_8x5.
      - pcn_v3_no_cf_memory_8x5.
      - pcn_v3_cf_restored_memory_8x5.

  7. Known Caveats
      - One-seed 20260630 result.
      - 20260701 smoke only.
      - Reference-complete subset requirement.
      - Pretrained encoder fidelity limitations.
      - Missing-reference RTLLM designs excluded from headline metrics.

  ## Review Checklist

  Create reviews/adversarial_checklist.md and use it before finalizing slides:

  - Every numeric claim links to a copied raw CSV or report section.
  - Every positive claim states whether it is one-seed, smoke, or full-suite.
  - No 20260701 full-run partial logs appear in headline slides.
  - 20260629 is framed as negative evidence for those exact methods and operator setup, not proof QD is impossible.
  - 20260630 PCN is framed as a promotion signal, not multi-seed proof.
  - 20260701 smoke is framed as a C-F confound check, not final validation.
  - PCN mechanism claims cite memory-refine counters.
  - Qwen/MasterRTL/DeepGate claims distinguish actual pretrained usage from descriptor-inspired or source-aligned usage.
  - Slides are visual-first: each non-appendix slide should have one main plot, table, or diagram unless it is a transition or takeaway slide.

  ## Test Plan

  After implementation:

  - Verify all copied CSVs match source checksums or exact byte counts recorded in data/README.md.
  - Regenerate presentation plots from copied raw CSVs and compare headline values against:
      - 20260629 report: classic 0.1002 mean HV, best QD 0.0735, Qwen 0.0432.

  - Confirm slides.md uses relative links that resolve from the presentation directory.
  - Confirm slides.md contains 25-30 main slides and appendix links.
  - Confirm appendix includes all method families named in the main deck.
  - Run git diff --check before committing.
  - Do not stage or commit active 20260701 full-run logs unless explicitly requested.

  ## Assumptions

  - Main deck length: 25-30 slides.
  - Headline evidence boundary: 20260629 full suite, 20260630 corrected full suite, and 20260701 smoke only.
  - Visual policy: copy raw data, regenerate presentation plots from copied tables, and keep copied original figures as sanity references.
  - Concept diagrams may use imagegen or local plotting, but quantitative charts must be generated from copied CSV tables.
  - No sub-agents are used in this side conversation; adversarial review is represented as a written checklist.