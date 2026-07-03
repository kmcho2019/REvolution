# Presentation Review Notes

## Round 1 - Structural And Evidence Review

Issues found:

- Slides 8 and 15 were table-heavy in the main deck.
- Slide 22 used the future experiment ladder where a C-F ablation design
  diagram would be clearer.
- Several evidence claims were correct but needed the slide visuals to make the
  distinction between full-suite, one-seed, and smoke evidence easier to see.

Fixes:

- Replaced slide 8's table with `figures/generated/method_family_matrix.png`.
- Replaced slide 15's table with `figures/generated/20260630_operator_audit.png`.
- Replaced slide 22's generic ladder with `figures/concepts/cf_ablation_design.png`.

## Round 2 - Figure Readability Review

Issues found:

- Early concept diagrams originally rendered literal `\n` strings instead of
  line breaks.
- The classic pipeline diagram had overlapping boxes and arrows crossing text.
- The 20260701 C-F audit showed zero-count control arms as visually empty,
  which could be misread as missing data.
- The 20260701 smoke comparison emphasized the large PCN-C-F-restored bar but
  did not visually show that the result is only a three-problem smoke sample.

Fixes:

- Regenerated concept diagrams with real line breaks.
- Shortened the classic pipeline labels and moved arrows below text boxes.
- Added numeric zero labels to the C-F and single-thought audit plot.
- Added bootstrap confidence intervals and `n=3` directly to the smoke delta
  plot title.

## Round 3 - Content Discipline Review

Issues checked:

- No 20260701 partial full-run logs are used in headline slides.
- 20260630 PCN-v3 is described as a one-seed signal, not statistical proof.
- 20260701 smoke is described as an operator/confound check, not final
  validation.
- The appendix includes detailed method descriptions for colleague questions.

Remaining caveats:

- Some conceptual diagrams are intentionally simple and should be treated as
  explanatory aids, not data.
- Final statistical claims require the ongoing five-seed C-F ablation.

## Round 4 - Original Plan And Code-Audit Review

Issues found:

- `original_plan.md` asked for visual treatment of descriptor-family failures;
  slide 11 still used a table.
- `original_thoughts.md` emphasized colleague Q&A on exact method mechanics;
  the appendix described methods but did not yet list exact code/wrapper facts.
- The 20260630 PCN positive result needed the no-C-F caveat placed directly in
  the main deck, not only in supporting notes.

Fixes:

- Replaced slide 11 with `figures/generated/20260629_descriptor_family_rank.png`.
- Added an implementation cross-check section to `appendix_methods.md`.
- Added `reviews/methodology_code_audit.md` with wrapper/code/test anchors.
- Added `reviews/adversarial_qa_review.md` with likely questions and answers.
- Added a slide 17 caveat that the 20260630 PCN result still needs the C-F
  ablation before memory-only causality can be claimed.

## Round 5 - Imagegen Concept Trial

Issues checked:

- Whether native image generation can produce more polished concept visuals
  than manual deterministic diagrams.
- Whether generated figures introduce text artifacts, overlap, or misleading
  technical precision.

Fixes:

- Added `figures/imagegen_trials/images/` with three generated concept images.
- Added `figures/imagegen_trials/captions/` with exact prompts, captions,
  manual counterparts, and usage recommendations.
- Added `reviews/imagegen_manual_comparison.md`.
- Added `slides_imagegen_optional.md` as optional inserts rather than modifying
  the main evidence deck.

Assessment:

- The PCN architecture image is the strongest candidate for optional use.
- Replacement-vs-memory is visually strong but less exact than the manual
  method diagram.
- Scalar-vs-Pareto should remain optional because the manual metric figure is
  more defensible for technical questions.

## Round 6 - Final Original-Plan Coverage Audit

Issues found:

- The final discussion slide still used a table body, while the original plan
  asked for visual-first slide bodies where possible.
- The generated/concept contact sheets were stale after adding
  `20260629_descriptor_family_rank.png` and the imagegen trials.

Fixes:

- Replaced the slide 28 table with
  `figures/concepts/discussion_question_map.png`.
- Regenerated `reviews/figure_contact_sheet_generated.png` and
  `reviews/figure_contact_sheet_concepts.png`.
- Rechecked `original_plan.md` and `original_thoughts.md` against the current
  deck, appendix, evidence map, imagegen trials, and review files.

Final read:

- The main narrative requested in `original_thoughts.md` is covered.
- The appendix covers all method families named in `original_plan.md`.
- Methodology claims are cross-referenced against wrappers and source code in
  `reviews/methodology_code_audit.md`.
- The remaining caveats are intentional: no sub-agents in this side
  conversation, no 20260701 full-run headline claims, and no full
  MasterRTL/RTLTimer pretrained-model reproduction claim.

## Round 7 - Appendix Detail And Methodology Images

Issues found:

- `appendix_methods.md` defined the method families but did not sufficiently
  explain recurring shorthand such as PCN, RF, leaf ID, canonical RTL, memory,
  MasterRTL/RTLTimer-inspired features, and implementation-level structural
  features.
- Several later method sections were too compressed for adversarial Q&A,
  especially MasterRTL delayed activation, FG-QDM, and PCN-v3.
- The optional imagegen package had polished concept visuals, but did not yet
  include a methodology trio for classic REvolution, generic MAP-Elites, and
  PCN-v3.

Fixes:

- Added an acronym and descriptor-feature glossary to `appendix_methods.md`.
- Expanded the Qwen, DeepGate, RF+DeepGate, AURORA, MasterRTL, FG-QDM, and
  PCN-v3 sections with step-by-step mechanics and conservative claim wording.
- Added three generated methodology figures:
  - `figures/imagegen_trials/images/classic_revolution_methodology_imagegen.png`
  - `figures/imagegen_trials/images/generic_qd_map_elites_methodology_imagegen.png`
  - `figures/imagegen_trials/images/pcn_v3_methodology_imagegen.png`
- Added captions/prompts for each new image and optional slide entries in
  `slides_imagegen_optional.md`.

Assessment:

- The appendix is now strong enough to answer terminology and mechanism
  questions without relying on source-code lookup during the talk.
- The PCN-v3 methodology image is the best visual for the key algorithmic
  contrast, but deterministic diagrams remain safer for exact rules.

## Round 8 - Replace Overstyled Appendix Method Images

Issue found:

- The appendix methodology images generated through imagegen were too
  futuristic and ornamental for a technical appendix. They looked like concept
  art rather than paper-style method diagrams.

Fixes:

- Added deterministic, clean flowchart diagrams:
  - `figures/concepts/classic_revolution_methodology_clean.png`
  - `figures/concepts/generic_qd_map_elites_methodology_clean.png`
  - `figures/concepts/pcn_v3_methodology_clean.png`
- Updated `appendix_methods.md` to use these flowchart images instead of the
  imagegen trial images.

Assessment:

- The replacement diagrams are simpler, more paper-like, and easier to
  interrogate: boxes and arrows directly expose the algorithmic difference
  between classic REvolution, generic MAP-Elites, and PCN-v3 memory.

## Round 9 - Paper-Style Imagegen Regeneration

Issue found:

- The deterministic matplotlib diagrams were clean but still visually stiff and
  manually constrained. The user requested imagegen regeneration using those
  diagrams as the style reference.

Fixes:

- Generated a new paper-style imagegen trio with strict flat-flowchart
  constraints:
  - `figures/imagegen_trials/images/classic_revolution_methodology_paper_imagegen.png`
  - `figures/imagegen_trials/images/generic_qd_map_elites_methodology_paper_imagegen.png`
  - `figures/imagegen_trials/images/pcn_v3_methodology_paper_imagegen.png`
- Updated `appendix_methods.md` to use those imagegen-generated flowcharts.
- Added caption/provenance files for the new imagegen outputs.

Assessment:

- These are the best appendix visuals so far: clean, paper-like, and more
  polished than the deterministic diagrams, without reverting to the earlier
  futuristic concept-art style.
