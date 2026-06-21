# T06 Figure Visual Inspection Notes

Inspection date: 2026-06-21 UTC.

## `qwen_replay_hypervolume.png`

Readable bar chart with an all-valid baseline line. Qwen identifier-normalized
selection is close to the fitness-top control and above lexical farthest-first,
while raw Qwen is slightly below lexical and random/generation controls are
clearly worse.

## `qwen_vs_lexical_hv_delta.png`

Readable horizontal delta chart. It clearly shows Qwen identifier-normalized
selection at +3.35% HV over lexical, raw Qwen at -1.25%, and random/generation
controls much lower.

## `qwen_diversity_counts.png`

Readable grouped bar chart. Lexical farthest-first has the highest unique
canonical-netlist and motif-signature counts; Qwen identifier-normalized loses
one canonical netlist and three motif signatures versus lexical.

## `qwen_collapse_diagnostics.png`

Readable diagnostic chart. Same-problem and same-corpus nearest-neighbor
fractions are both high, while same canonical-netlist and motif-signature
fractions are low. Identifier normalization visibly changes embeddings much
more than comment stripping.
