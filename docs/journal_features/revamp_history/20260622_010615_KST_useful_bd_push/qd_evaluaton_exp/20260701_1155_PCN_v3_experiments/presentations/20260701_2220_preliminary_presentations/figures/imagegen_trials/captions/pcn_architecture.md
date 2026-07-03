# PCN Architecture Imagegen Trial

Image:

`../images/pcn_architecture_imagegen.png`

Manual counterpart:

`../../concepts/pcn_architecture.png`

## Caption

PCN-v3 keeps a main classic improvement loop and adds a small guarded memory
that stores only selected valid/PPA-relevant alternatives. Memory candidates
can re-enter the main loop, but rejected or invalid candidates stay outside.

## Prompt

```text
Use case: productivity-visual
Asset type: 16:9 presentation concept figure
Primary request: Create a polished conceptual illustration of PCN-v3 guarded memory for RTL evolution, with no text labels.
Scene/backdrop: clean white and pale gray technical slide background.
Subject: A main blue loop of candidate RTL chips flows through evaluation and improvement, while a smaller green archive shelf stores only a few high-quality alternative chip families. Some green dotted arrows return from the memory shelf into the main blue improvement loop. Invalid or low-quality candidates are faint gray and do not enter memory.
Style/medium: crisp 3D-isometric infographic-style raster, professional research presentation visual.
Composition/framing: central horizontal blue loop, green side memory box attached on the lower right, clear arrows, no readable text.
Lighting/mood: calm, precise, technical.
Color palette: blue main loop, green memory, gray rejected candidates, subtle orange warning accents.
Constraints: no text, no letters, no logos, no watermarks, no equations. Keep all elements separated with no overlap and generous margins.
```

## Review

- Strength: best generated candidate; clearly communicates loop plus memory.
- Weakness: still needs a caption because no labels are embedded.
- Recommendation: consider using as an optional slide-14/17 visual if the talk
  needs a more polished high-level PCN image. Keep the manual figure for exact
  step-by-step explanation.
