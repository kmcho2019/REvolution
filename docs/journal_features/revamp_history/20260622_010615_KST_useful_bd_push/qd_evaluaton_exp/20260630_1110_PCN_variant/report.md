# PCN Variant Results Report

This report is a pre-run scaffold. Replace this section after the staged
commands finish and the package script writes `analysis/` and `figures/`.

## Executive Conclusion

Pending staged runs. No positive PCN claim is made yet.

## Why This Variant Exists

The 20260629 RTLLM full suite showed that the best QD arm,
`rf_deepgate_hybrid_delayed_8x5`, retained only 73.4 percent of classic mean HV
on the reference-complete RTLLM subset. Coverage also dropped from 33/46 for
classic to 27/46 for the best QD arm. That result suggests the issue is not
only descriptor choice. The archive policy itself was too disruptive.

PCN tests a stricter question: can descriptor-indexed memory help if classic
REvolution remains the main optimizer?

## Overview Figures

- `figures/pcn_algorithm_flow.png`: PCN scheduler and memory-credit flow.
- `figures/pcn_stage_ladder.png`: smoke, screen, long-budget, and RTLLM
  promotion sequence.

## Required Result Tables

After packaging, include:

- method summary table ranked by mean HV;
- per-problem HV/HV-AUC table;
- completeness table with reference status;
- memory mechanism table with generated, valid-PPA, global-front, and
  local-front counts by lane;
- long-budget comparison table if Stage 3 runs.

## Required Figures

After packaging, include:

- mean HV by method;
- HV-AUC by method;
- paired HV delta distribution;
- valid-PPA coverage by method;
- memory lane contribution per call;
- coverage versus mean HV scatter;
- representative raw area-power fronts.

## Interpretation Rule

A PCN success claim requires both performance and mechanism evidence. A mean HV
increase without memory-lane contribution is not a QD-memory result. A
memory-lane contribution without HV/HV-AUC or front-breadth preservation is not
a PPA optimization win.
