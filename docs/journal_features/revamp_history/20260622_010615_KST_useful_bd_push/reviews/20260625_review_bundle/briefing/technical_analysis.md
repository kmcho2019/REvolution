# Technical Analysis For External Review

## Research Goal

The TCAD extension goal is to show whether explicit diversity mechanisms can
improve LLM-based RTL evolution. The target improvement is not average archive
coverage. The target is better PPA Pareto-front search:

- higher PPA hypervolume;
- higher HV-AUC;
- more nondominated PPA-front points;
- more unique PPA points or implementation families;
- no missing classic-covered designs;
- no hidden functionality, synthesis, or reference-PPA failure.

In-loop behavior descriptors are not allowed to use final PPA, reference PPA,
fitness, hypervolume, Pareto rank, test pass rate, or problem identity.

## Method Families Tried

### 1. Transparent CAD Descriptors

Examples: simple Yosys stats, motif/pathlet counts, synthesis trajectory
features, ST-NOD-style descriptors.

What we learned:

- They are easy to explain and useful as controls.
- They can broaden archive views.
- Direct use was not enough to beat classic on PPA-front metrics.

Evidence:

- `evidence/current_goal_docs/current_results_matrix.md`
- early technique reports under `evidence/techniques/`

### 2. Synthesis-Response / AutoQD-Style Descriptors

Examples: T04 SR-RFF PCA, T19 SR ReLU PCA, T20 SR raw PCA, T23 validation,
T24 live matrix, T26 conservative exploit.

Best evidence:

- T19 replay: mean HV `0.1454` vs classic `0.1245`, HV-AUC `0.1202` vs
  classic `0.0728`.
- T04 replay: near-classic mean HV `0.1229` vs `0.1245`, stronger passive QD
  score and more local front netlists.
- T20 raw PCA: matched classic valid-PPA count and increased front/motif
  diversity, but lost best quality.
- T26 development screen: recovered multi-pipe quality and improved ALU best
  score under conservative champion-biased parent policy.

Blocking evidence:

- T24 live matrix showed every QD arm lost too much quality on
  `Prob015_multi_pipe_8bit`.
- Full RTLLM exact T26 was negative after removing missing-reference designs
  from headline aggregates.

Interpretation:

Synthesis response is one of the few families with a real signal. The problem
is coupling. The descriptor can identify implementation-response variation,
but the archive/exploitation schedule often spends too much budget away from
the immediate PPA-improving path.

### 3. Pretrained Text Embeddings: Qwen3

Examples: T06 and T33/T34.

Best evidence:

- T33 canonical RTL and identifier-role RTL beat lexical farthest-first on
  selected HV by about `+2.63%`.
- Canonical Yosys netlist reduced same-problem nearest-neighbor collapse from
  the T06 level of about `0.934` to about `0.738`.

Blocking evidence:

- The netlist views that fixed collapse did not improve selected HV.
- The RTL views that improved HV retained high same-problem/corpus structure.
- No Qwen-based live QD arm has produced a clean PPA-front win.

Interpretation:

Qwen embeddings contain some PPA-relevant signal, but the signal is entangled
with problem identity and corpus artifacts. They are better as auxiliary
diagnostics or secondary features than as a primary archive geometry.

### 4. Synthesized Netlist / Graph Encoder Lane

Examples: T07 DeepGate-style graph surrogate, T11 MGVGA-style contrastive
features, T13 AURORA-style implementation features, T14 DE-HNN-style
hypergraph features, T36 bounded front lane, T58 live graph-coordinate QD.

Best evidence:

- T07 WL graph surrogate slightly beat lexical HV and reduced collapse.
- T13 raw implementation features beat lexical HV by `+1.06%`.
- T14 hypergraph plus implementation hybrid beat lexical HV by `+1.01%` and
  increased unique PPA points.
- T11 structural contrastive features beat lexical HV by `+1.82%`.
- T36 bounded front lane reached `+4.04%` replay HV and improved front hits.

Blocking evidence:

- T07 was not a validated pretrained DeepGate checkpoint path.
- AURORA-style compression reduced collapse but usually lost HV.
- Hypergraph-only variants lost HV.
- T58 live T51 plus T11-PCA4 graph coordinates improved valid-PPA count and
  best score but lost classic on HV, HV-AUC, front points, unique PPA points,
  and reference-beating candidates.

Interpretation:

Graph/netlist features are promising in replay but have not survived live QD
pressure. The replay evidence suggests useful implementation-family signal,
but the live archive geometry can suppress the exact hill-climbing behavior
that classic uses to win.

### 5. RTL-Native MasterRTL / RTLTimer Lane

Examples: T68-T80.

Best evidence:

- T68/T69/T70 verified that source-aligned MasterRTL/RTLTimer-style extraction
  can run on shipped examples and generated RTL candidates.
- T72 source-aligned cells nearly matched classic mean HV:
  `0.0920035731` vs classic `0.0926007600`.
- T73/T75 improved valid-PPA yield or recovered some mean-HV signal over
  intermediate variants.
- T80 showed raw MasterRTL structural-mix descriptors are noncollapsed:
  `17/19` unique descriptor rows and `15` quantile occupied cells.

Blocking evidence:

- T72 still lost classic on HV wins, Pareto points, reference-beating
  candidates, and valid-PPA samples.
- T75 still lost classic on mean HV and front breadth.
- T79 showed exact T75 loses classic under `12x3`, `8x5`, and `6x7`.
- T77 showed direct pretrained MasterRTL Area-head leaves collapse to one
  prediction and one leaf row on generated candidates.

Interpretation:

This is the strongest methodology story because "RTL-native implementation
families" is easy to defend to hardware reviewers. But the current measured
variants still do not beat classic. The next attempt needs either stronger
verified model features, retrained features, or a better auxiliary-memory
algorithm that does not overtax exploitation.

## Repeated Failure Modes

1. Replay-to-live gap:
   descriptor selection over an existing pool often looks useful, but live
   MAP-Elites sampling changes the generation distribution and loses quality.

2. Exploration tax:
   archive fill consumes candidates that classic spends on immediate PPA
   improvement.

3. Validity fragility:
   diverse RTL often fails syntax, functionality, or synthesis before PPA.

4. Descriptor collapse:
   learned embeddings can cluster by problem, corpus, text length, or
   identifier style instead of useful implementation strategy.

5. Archive coverage without PPA-front gain:
   several methods improve cell occupancy, valid yield, or family counts while
   losing HV and front points.

6. Reference-PPA vulnerability:
   missing benchmark reference PPA made one all-RTLLM aggregate look positive
   until reference-complete filtering reversed the result.

7. Small-budget disadvantage:
   with `12x3` or 48 candidates/problem, QD has little time for "discover
   family, improve locally, become Pareto useful."

8. Pretrained-model credibility:
   external model weights must be loaded through their original feature
   schema and shown to produce nonconstant useful variation on generated RTL.

## Current Assessment

The strongest defensible statement is negative but nuanced:

> We have not demonstrated that current QD/MAP-Elites methods beat classic
> REvolution for RTL PPA evolution. However, several descriptor families show
> nontrivial replay or diagnostic signal, especially synthesis-response,
> structural graph features, bounded front-lane retention, and RTL-native
> MasterRTL/RTLTimer-derived features.

This suggests the research direction should shift from "generic diversity
beats classic" to:

> Useful RTL diversity is preserving PPA-competitive implementation families
> under validity constraints, while retaining classic-like exploitation
> pressure.

## Reviewer-Facing Hypotheses

1. QD as primary selection pressure is too expensive for this setting.
2. QD as auxiliary memory may still help if classic-like exploitation remains
   dominant.
3. RTL-native descriptors are more publishable than opaque embeddings, but
   they must improve PPA fronts, not just archive spread.
4. Pretrained circuit encoders should be used only after checkpoint, schema,
   and noncollapse validation.
5. A decisive full-RTLLM test should include only a few strong candidates and
   must use reference-complete paired metrics.
