# Does Diversity Matter For RTL PPA Evolution?

Status: scaffolded report; conclusions are provisional until the RTLLM
milestone experiment lands.

## Executive Answer

Question 1: Does diversity matter?

Current evidence says yes in a scoped way, but not any diversity. The strongest
current lead, T26/T27/T30, is best described as a quality-safe SR raw archive
bundle with strong hill-climbing pressure. It preserves classic-covered designs
on the development screen, improves live HV/HV-AUC in audit, and shows holdout
best-score support. It is not yet cleanly diversity-positive on PPA-front
family breadth: T28 reports fewer front families than classic. The defensible
claim before the RTLLM milestone is therefore `T1 near_classic`, not `T2
useful_qd`.

Question 2: Which diversity matters?

The diversity that matters appears to be implementation-response diversity
coupled to preserved hill-climbing pressure. Pure lexical/identifier
diversity, random descriptors, overly sparse graph axes, and broad local-Pareto
replacement are not enough. The useful pattern is:

- descriptors or archives must be tied to implementation behavior, not names;
- archive pressure must preserve valid-PPA yield and champion refinement;
- Pareto/front breadth must count valid, nonduplicate candidates only.

## Evidence Map

| Evidence | Read |
| --- | --- |
| Prior diversity check | Whole-design embeddings and naive diversity mostly illuminated search space without improving PPA enough. |
| T04/T19/T20 | Synthesis-response descriptors show real automatic-BD signal, but plain versions do not reliably preserve quality. |
| T24/T25 | Local Pareto QD can run live, but unguarded archive pressure loses multi-pipe quality or traffic-light yield. |
| T26/T27 | Conservative exploit SR raw QD restores hill-climbing pressure and wins live HV/HV-AUC audit versus classic. |
| T28/T30 | Duplicate/family and holdout audits support T26, but front-family breadth and yield warnings remain. |
| T38-T44 | T11/local-front/archive variants show front/HV signal but expose yield, warmup, and sparsity failures. |

## What The New RTLLM Milestone Must Add

The current evidence is encouraging but still too narrow for a persuasive
presentation. The milestone experiment must compare classic REvolution against
the best pre-screened T26-family QD arm across all 50 RTLLM problems at the
same seed and budget. With one seed, the result can support a broad paired
engineering comparison, not seed-stable statistical significance.
The deadline-driven first pass should still proceed with one seed, then package
the evidence clearly before deciding which subset or method deserves costly
multi-seed replication.

The report can argue that QD/MAP-Elites should not be dropped only if the full
RTLLM package shows positive paired evidence on PPA-centered metrics without
hiding invalid samples, duplicate collapse, front-family loss, or
classic-covered design loss.
For the deadline run, lower valid-PPA yield is a visible warning rather than a
selection blocker when the selected method still has at least one valid PPA
candidate for every classic-covered design.

## Required Final Figures

- Paired per-problem HV delta distribution.
- Paired HV-AUC delta distribution.
- Win/loss heatmap across RTLLM problems.
- Valid-PPA funnel by method.
- Classic HV versus QD HV scatter with a diagonal reference.
- PPA-front and unique-front-family counts by problem.
- Representative raw area-power Pareto panels.

## Provisional Conclusion

Diversity matters when it is implementation-aware and coupled to a quality-safe
archive. The current best candidate is exact T26 unless screening proves that a
low-fusion or gated T26.1 variant retains T26's quality while improving front
breadth. The full RTLLM run is the evidence gate for moving from promising
research direction to a presentation-grade claim.
