# Manuscript artifacts (drop-in content for the Overleaf journal_draft)

Mechanically-generated, evidence-sourced content for the manuscript (#15) —
**not authored prose, and not the Overleaf itself.** Regenerate any time the
underlying runs change; numbers/figures trace to the cited run directories.

## Contents

| Artifact | What | Regenerate with |
|---|---|---|
| `tables.tex` | Table 1 (5-seed hard-subset contrasts: F1/F2/F23/F3 with CIs + sign-p) and Table 2 (RealBench + CVDP capability counts) | `python scripts/build_manuscript_tables.py` |
| `figures/scalar_vs_qd_Prob135.pdf` | Case-study: classic vs QD best-quality trajectory on Prob135 (QD reaches 0.123 vs classic 0.035 — the +0.088 healthy-archive case) | `python scripts/build_manuscript_figures.py` |
| `figures/archive_heatmap_Prob135.png` | Case-study: the healthy 6-cell QD archive (logic_depth × comb_width_log, best 0.123) | (copied by the figures script) |
| `draft_results_section.md` | Prose DRAFT of the Results section (§5.1–5.6 + Limitations), calibrated to the frozen narrative; for the author to adapt — not pushed to Overleaf | hand-drafted against doc 13 / tables.tex |
| `draft_abstract_contributions.md` | Prose DRAFT of the Abstract + Contributions list (supersedes the doc-17 spine sketch; incorporates the CVDP F30–F32 arc) | hand-drafted against doc 13 |
| `draft_discussion_conclusion.md` | Prose DRAFT of the Discussion (§6: why QD doesn't win — F29 mechanism; operator simplification; negative-result framing; future work) + Conclusion (§7) | hand-drafted against doc 13 |

## Figure caption caveats (carry into the paper)

- **archive_heatmap_Prob135.png** renders 2 of the 3 BD-trio axes (logic_depth
  × comb_width_log; ff_depth is sliced). Per the frozen disclosure,
  `comb_width_log` is a **size proxy** (correlates with area) — caption it as
  such; the diversity claim rests on logic_depth + ff_depth.
- **scalar_vs_qd_Prob135.pdf** is Prob135, a spec-exact problem where QD helps
  (regime-sensitivity, F4) — it is a case study, NOT the aggregate verdict
  (the aggregate is F1: QD loses pooled). Caption accordingly.

## Still bespoke (need manual curation — not auto-generated)

The narrative's 4 case-study artifacts include two that require selecting
specific candidates/transitions; their source dirs (sourced in docs 12/13):

- **Thought-lineage** (a thought→child crossing descriptor cells):
  `exp/fast_iter/rb_failure_regime_v2/variant/revolution/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/`
- **Failure panel** (alu feedback-misdirection, pass-rate 15%→2%):
  `exp/fast_iter/rb_failure_regime_v2/variant/revolution/openai_gpt-oss-120b/RTLLM/Prob045_alu/`
- **Equivalence pass-rate** (per F24): report on the fully-specified
  Prob150_review2015_fsmonehot (1/1 PROVEN), NOT Prob135 (don't-care spec).

The numbers themselves are all in `tables.tex`, doc 13 (F1–F28), and the
consolidated record §7 evidence index.
