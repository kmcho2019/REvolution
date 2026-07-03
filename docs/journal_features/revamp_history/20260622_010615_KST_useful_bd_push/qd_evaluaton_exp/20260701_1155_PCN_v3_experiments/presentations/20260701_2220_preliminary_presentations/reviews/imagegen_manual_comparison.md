# Imagegen Versus Manual Figure Comparison

This review compares generated concept images against the deterministic
manual figures already used in the deck.

## Summary

Contact sheet:

`reviews/figure_contact_sheet_imagegen.png`

| Concept | Imagegen read | Manual read | Recommendation |
| --- | --- | --- | --- |
| QD replacement vs guarded memory | Visually strong; clean split composition; no text artifacts. | More precise about the algorithmic contrast. | Optional transition image; do not replace exact method slide. |
| PCN-v3 architecture | Best generated asset; clearly shows main loop, rejected candidates, and memory shelf. | More precise and label-driven. | Candidate for a polished high-level slide; keep manual for technical detail. |
| Scalar fitness vs Pareto/HV | Attractive and clear at a glance. | More faithful to metric explanation. | Keep manual for metrics; use generated only for intuition. |
| Classic REvolution methodology | Clean success-pool loop; no text artifacts. | More precise about EoH operator names. | Good opening methodology visual; pair with appendix for exact operators. |
| Generic QD / MAP-Elites methodology | Strong archive-grid visual; communicates coverage pressure. | More precise about descriptor and parent-selection mechanics. | Use before explaining why straightforward QD failed. |
| PCN-v3 methodology | Strong contrast between dominant classic loop and small memory sidecar. | More precise about trigger, 90/10 schedule, and cell credit. | Best generated image for the PCN narrative. |
| Paper-style methodology trio | Cleanest imagegen result; flat flowcharts with readable labels. | Deterministic diagrams remain exact but look stiffer. | Use these in the appendix. |

## Detailed Notes

### Replacement Versus Memory

Generated path:

`figures/imagegen_trials/images/replacement_vs_memory_imagegen.png`

The generated version is more engaging than the manual boxes. It does a good
job showing the left-side archive as scattered and the right-side memory as a
small helper to a main path. The downside is precision: it does not encode the
actual 90/10 PCN scheduling or the valid-PPA insertion rule.

### PCN Architecture

Generated path:

`figures/imagegen_trials/images/pcn_architecture_imagegen.png`

This is the strongest candidate. The main blue loop, green memory shelf, and
gray rejected candidates align with the PCN narrative. It could replace one
high-level PCN overview image if the presenter wants a more polished visual.
For method interrogation, the manual figure remains safer.

### Scalar Versus Pareto

Generated path:

`figures/imagegen_trials/images/scalar_vs_pareto_imagegen.png`

This works as a high-level intuition image. It should not replace the manual
HV/HV-AUC explanation because a technical colleague may ask whether the shaded
region and frontier geometry are exact. The manual metric diagram is more
defensible.

### Classic REvolution Methodology

Generated path:

`figures/imagegen_trials/images/classic_revolution_methodology_imagegen.png`

This works as a polished visual for the baseline: most attention stays on the
success pool and iterative refinement. It should not be used alone to explain
EoH because it does not show `M-S`, `M-E`, `M-R`, `M-I`, or `C-F` by name.

### Generic QD / MAP-Elites Methodology

Generated path:

`figures/imagegen_trials/images/generic_qd_map_elites_methodology_imagegen.png`

This is a useful contrast image because the archive grid is visually dominant.
That matches the critique that generic QD can spend scarce budget on descriptor
coverage. It remains a concept image; the exact archive mode, cell retention,
and descriptor axes must come from the manual slides or appendix.

### PCN-v3 Methodology

Generated path:

`figures/imagegen_trials/images/pcn_v3_methodology_imagegen.png`

This is the strongest image for the central PCN claim. It makes the main loop
larger than memory, which is exactly the intended difference from MAP-Elites
replacement. It should be paired with the appendix section explaining
stagnation gates, minimum valid-PPA evidence, and cell credit.

### Paper-Style Methodology Trio

Generated paths:

`figures/imagegen_trials/images/classic_revolution_methodology_paper_imagegen.png`

`figures/imagegen_trials/images/generic_qd_map_elites_methodology_paper_imagegen.png`

`figures/imagegen_trials/images/pcn_v3_methodology_paper_imagegen.png`

These are the recommended appendix images. They use imagegen, but the prompt
constrains them to a flat academic flowchart style using the deterministic
manual diagrams as the reference. Compared with the earlier imagegen concepts,
they are less ornamental and more suitable for a technical colleague.

## Optional Slide Usage

The generated images are best used in one of two ways:

1. Add a short visual transition slide before the technical PCN section.
2. Use the PCN generated image as a large background/visual while keeping the
   exact method rules in speaker notes or appendix.

They should not replace data plots or operator-audit figures.
