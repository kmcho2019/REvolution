# Preliminary QD/PCN Presentation

This package is a preliminary colleague-facing presentation about whether
quality-diversity ideas help RTL PPA evolution.

## Evidence Boundary

The main deck uses:

- 20260629 RTLLM full suite: broad QD failure with the earlier
  `single_thought_operator` path.
- 20260630 RTLLM full suite: corrected EoH-preserving rerun with PCN-v3.
- 20260701 PCN-v3 smoke: operator-set and C-F confound check.

The ongoing 20260701 five-seed RTLLM full run is not used for headline claims.

## Files

| Path | Purpose |
| --- | --- |
| `outline.md` | Slide-by-slide outline written before the deck. |
| `slides.md` | Main Markdown presentation deck. |
| `slides_imagegen_optional.md` | Optional generated-image slide inserts. |
| `appendix_methods.md` | Detailed method and algorithm descriptions for questions. |
| `evidence_map.md` | Claim-to-artifact evidence map. |
| `data/raw/` | Copied input reports and CSVs from the source packages. |
| `data/derived/` | Regenerated presentation tables. |
| `figures/copied/` | Exact copied source figures for sanity checks. |
| `figures/generated/` | Regenerated data plots from copied raw CSVs. |
| `figures/concepts/` | Conceptual diagrams generated for this deck. |
| `figures/imagegen_trials/` | Optional native imagegen concept alternatives with captions. |
| `tools/build_presentation_assets.py` | Rebuilds generated plots and derived tables. |
| `reviews/adversarial_checklist.md` | Manual adversarial review checklist. |
| `reviews/adversarial_qa_review.md` | Simulated hard Q&A and slide-answer coverage. |
| `reviews/methodology_code_audit.md` | Wrapper/code/test cross-check for method claims. |
| `reviews/imagegen_manual_comparison.md` | Review of generated concept figures versus manual diagrams. |
| `reviews/presentation_review_notes.md` | Multi-round review notes and fixes applied. |
| `original_plan.md` | Original plan retained for traceability. |
| `original_thoughts.md` | Original user prompt retained for traceability. |

## Regeneration

Run from `/workspace`:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/presentations/20260701_2220_preliminary_presentations/tools/build_presentation_assets.py
```

Quantitative plots are generated from copied CSVs in `data/raw/`. The copied
source figures remain in `figures/copied/` so values and visual trends can be
checked against the original packages.

## Claim Discipline

- Do not claim multi-seed proof from the 20260630 PCN result.
- Do not claim the 20260701 smoke result resolves the C-F confound.
- Do claim that naive QD/MAP-Elites variants failed in the 20260629 setup.
- Do claim that restoring EoH operators greatly reduced the QD regression.
- Do claim that PCN-v3 is the best current hypothesis and merits the ongoing
  five-seed ablation.
