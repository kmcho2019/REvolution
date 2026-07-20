# Classic REvolution Method Audit

Status: `PENDING`; complete before any candidate becomes `READY`.

## Purpose

Audit the ASP-DAC 2026 algorithm and implementation before proposing fixes.
Every limitation must be grounded in the paper, exact classic code path,
completed ablations, or reproducible baseline evidence. Do not infer a weakness
only because a replacement idea is attractive.

## Audit Procedure

For each component:

1. Record the conference claim and exact implementation path.
2. State the intended mechanism and all tunable state.
3. Summarize evidence that the component helps, hurts, or remains unproven.
4. Compare the mechanism with current RTL/EDA and evolutionary-search work.
5. Identify the smallest general correction or extension.
6. Define a measurement that could falsify the proposed explanation.

## Component Map

| Component | Conference role | Audit question | Current evidence | Candidate directions |
| --- | --- | --- | --- | --- |
| EoH-derived evolutionary operators | Generate and refine candidate RTL/thoughts | Are generic evolutionary prompts sufficiently grounded in RTL functionality and PPA mechanisms? Which operators add unique useful children? | Audit conference text, operator ablations, classic no-operator results, and the failed `single_thought_operator` evidence. | Small fixed hardware-intent operator family or evidence-backed removal. Any unification proposal must state a mechanism distinct from the retired single-thought treatment; no large prompt taxonomy. |
| Weighted success fitness and parent selection | Exploit functionally valid PPA candidates | Does scalar ranking discard useful PPA tradeoffs, or is its exploitation bias essential at the available budget? | Include F41 global Pareto negative and prior QD results. | Objective-preference decomposition or another direct, low-state multiobjective mechanism only if it preserves classic exploitation. |
| UCB/strategy adaptation | Allocate effort among evolutionary operators | Is adaptation independently useful, and is aggregate success the right feedback? | Locate clean UCB ablations before proposing contextual state. | Simplify/remove unproven adaptation, or test one hardware-grounded signal with a shuffled control. |
| Dual fail/success populations | Separate functional repair from PPA optimization | Are failures differentiated usefully? Does the transition discard partially useful functional information? | Audit fail fitness, parent selection, migration, and completed feedback experiments. | Typed verification progress or failure-class evolution only if available from general evaluator outputs. |
| Full-output mutation and repair | Produce revised RTL | How often do broad rewrites cause avoidable interface, latency, reset, or semantic regressions? | Measure mutation validity, changed descendants, failure classes, and edit size. | Contract-preserving or local edits with no design-specific annotations. |
| PPA evaluator and search objective | Guide optimization | Which proxy limitations, noise, and missing-data rules affect search or claims? | Reuse the accepted measurement model and run classic-only determinism/variance checks. | Evaluation hardening is supporting methodology, not an algorithmic novelty claim. |
| Generation-centric task setup | Generate RTL from a specification | Does the method naturally optimize valid suboptimal RTL and larger designs? | Audit seeded and long-design infrastructure plus current related work. | Seeded optimization or hierarchical evaluation only after an algorithmic mechanism is credible. |

## Required Audit Outputs

- exact classic engine and configuration hashes;
- component-to-code map;
- conference claim-to-evidence table;
- current related-work comparison matrix;
- ranked weaknesses with severity, tractability, and paper value;
- candidate ideas derived from each material weakness;
- explicit list of components that should remain unchanged.
- explicit negative-map conflicts for every idea resembling a retired mechanism.

## Selection Rule

Promote an idea from this audit into a hypothesis card only when it addresses a
documented weakness, has a hardware/CAD or evolutionary-search rationale, is
general across design classes, can be isolated by one ablation, and can be
implemented without problem branches, fallback ladders, or a parameter scan.
