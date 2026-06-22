# Technique Lanes

This file tracks the search process by research lane rather than by
chronological technique ID. Use it with `techniques/technique_registry.csv`:
the registry says what exists, while this file explains why each method was
tried, what it taught us, and where the next iteration should go.

## How To Use This File

Read the lane summary first, then jump to the lane note for the active method.
Every technique package should be traceable in three directions:

- backward to the evidence or failed method that motivated it;
- sideways to required controls and ablations;
- forward to the next run, branch, or parking decision.

The chronological `Txx` index remains the source of truth for artifact paths.
This file is the source of truth for research lineage and process decisions.
When a technique changes direction, update the decision ledger in the same
commit as the technique package or run-result report.

## Maintenance Rule

Update this file whenever a technique package changes the search direction.
Each update should identify the lane, the evidence source, the decision tag,
and the next artifact or branch. Use these tags consistently:

| Tag | Meaning |
| --- | --- |
| `advance` | Run a live validation, holdout validation, or stronger ablation. |
| `ablate` | Keep the idea, but isolate which component caused the signal. |
| `hybridize` | Reuse the useful part inside another lane. |
| `park` | Keep the package as evidence, but do not spend live budget yet. |
| `control` | Keep as a required comparator or sanity check. |
| `retire` | Stop this direct variant unless new evidence changes the premise. |

## Lane Taxonomy

| Lane | Core Question | Typical Techniques | Promotion Signal | Recycle Or Stop Signal |
| --- | --- | --- | --- | --- |
| `L0` common evaluation | Are we comparing methods on a fair QD surface? | Common passive archives, random BD, validation gates. | Comparator exposes a real baseline or prevents overclaiming. | Metric can be gamed or does not separate classic/manual/random. |
| `L1` transparent CAD descriptors | Can simple hardware structure describe useful exploration axes? | Yosys stats, motif/pathlet counts, ST-NOD trajectories. | Near-classic PPA with better archive coverage or interpretable fronts. | Pure concatenation broadens cells while losing quality. |
| `L2` synthesis-response automatic BDs | Can non-PPA implementation response produce useful automatic BDs? | Raw/RFF/ReLU synthesis-response PCA, AutoQD-style transforms. | Beats classic and random on HV/AUC, front material, or audit QD without yield collapse. | Projection keeps diversity but loses best-PPA pressure. |
| `L3` codebook/discrete archives | Can vector quantization or discrete cells stabilize exploration? | VQ/codebook cells over synthesis-response or graph features. | Codebook improves local front recovery when paired with Pareto retention. | Direct codebook parent pressure loses quality or valid yield. |
| `L4` learned encoders | Can pretrained or trained circuit encoders reveal stronger BDs? | Qwen3, DeepGate, DeepSeq, NetTAG, CircuitFusion, AURORA. | Encoder separates behavioral/structural axes after normalization and beats non-learned controls. | Embeddings cluster by identifiers, problem identity, or corpus artifacts. |
| `L5` archive coupling | Can archive mechanics preserve diversity while retaining hill-climbing pressure? | Local Pareto cells, NSGA-II parent selection, Smooth-QD-style champion lanes. | Same-budget live run improves front/hypervolume metrics while preserving classic-covered designs. | Archive keeps many candidates but does not improve live optimization. |
| `L6` lineage and emitters | Can we bias search by repair dynamics and operator history? | Parent-child repair features, emitter mixtures, adaptive CVT. | Better valid-yield recovery or underexplored-cell improvement without reward leakage. | Lineage axes duplicate scalar fitness or become post-hoc reward proxies. |

## Lane Summary

| Lane | Purpose | Current Evidence | Next Action |
| --- | --- | --- | --- |
| `L0` common evaluation | Keep every result on one passive archive and validity surface. | Central seed-1001 report, T22 replay control, and T24 live random control now exist. | Keep random BD in every validation table before any positive claim. |
| `L1` transparent CAD descriptors | Test cheap, reviewer-readable structure: Yosys stats, motifs, pathlets, ST-NOD. | T01/T02 are `T0`; T03 is a near-miss `T0`; T21 expands coverage but loses quality. | Stop pure concatenation; use feature selection, CVT, or local-Pareto retention. |
| `L2` synthesis-response automatic BDs | Use AutoQD-like transformations over non-PPA synthesis-response vectors. | T04/T19/T20 replay leads survive as live diagnostics but not as promoted methods. | Add a quality/yield guard before larger SR-family runs. |
| `L3` codebook/discrete archives | Test VQ/codebook cells over stable hardware vectors. | T05 direct VQ is `T0`, with one small per-problem HV win. | Reuse codebooks only as side archives or local-Pareto cells, not as direct parent pressure. |
| `L4` learned encoders | Try Qwen, DeepGate, DeepSeq, NetTAG, CircuitFusion, MGVGA, DE-HNN, DeepCell, AURORA. | T06 Qwen is `T0`; identifier-normalized Qwen has HV signal but nuisance clustering. | Run Qwen3 preprocessing ladder before heavier fine-tuning or external graph-encoder branches. |
| `L5` archive coupling | Preserve hill-climbing pressure without collapsing to scalar weighted-sum fitness. | T27 shows T26 beats classic on live HV/HV-AUC; T28/direct-front audit show weak front coverage; T29 shows simple front-recovery interpolation fails; T30 gives holdout support but no front-breadth win; T31 direct fail-feedback repair is negative. | Specify a front-preserving archive/emitter ensemble. |
| `L6` lineage and emitters | Use parent-child repair, invalid-to-valid transitions, and fixed emitter mixtures. | T26/T27/T30 show champion-biased parent-source policy restores quality and holdout pressure; T29 shows reducing that pressure can lose survival; T31 shows direct fail-feedback repair is insufficient. | Split champion, near-front, and bounded-repair emitter roles. |

## Lane Scorecard

| Lane | Best Current Lead | Status | Main Blocker | Branch Strategy |
| --- | --- | --- | --- | --- |
| `L0` | T22 replay and T24 live random descriptor controls | Required comparator. | Random can look strong on AUC/front material, so claims need metric-specific controls. | Keep in this branch and every validation table. |
| `L1` | T03 ST-NOD near-miss | Hybrid source. | Direct transparent descriptors lose audit-QD or best quality. | Continue only as selected features inside T17/T24-style archives. |
| `L2` | T04 SR-RFF PCA, T19 SR ReLU PCA, and T20 SR raw PCA | Live diagnostic lane. | Descriptor signal survives execution but not multi-pipe best quality. | Revise descriptor/archive coupling with quality/yield guarding. |
| `L3` | T05 VQ codebook side archive | Parked. | Direct VQ pressure is too costly. | Reopen only as a side archive after local-Pareto live evidence. |
| `L4` | T06 Qwen normalized-view diagnostic | Needs preprocessing ladder. | Whole-file embeddings carry nuisance axes. | Split to a Qwen/encoder branch if dependencies or model runtime expand. |
| `L5` | T17/T23/T24/T25/T26/T27/T28/T29/T30/T31 local-Pareto lineage | T31 tested same-budget failure feedback and did not repair yield or preserve T26 pressure. | A front-preserving archive/emitter split is not yet specified. | Use T30/T31 direct-front metrics as controls for the next method card. |
| `L6` | T12/T18 scaffolded emitter ideas, T26 parent-source policy, T31 failure-feedback emitter | T26/T27/T30 give a positive schedule signal; T29 shows naive exploration recovery loses multi-pipe coverage; T31 shows direct fail-feedback repair loses P135 HV/quality. | Need separate champion, near-front, and bounded-repair emitters instead of one fail-feedback operator. | Specify the next front-preserving emitter/archive ensemble. |

## Current Lineage

```mermaid
flowchart LR
  A[Older diversity-check negative map]

  subgraph L0[L0 common evaluation]
    Q[T22 random descriptor control]
    V[Common passive archive and gates]
  end

  subgraph L1[L1 transparent CAD descriptors]
    B[T01 simple Yosys stats]
    C[T02 motif occupancy]
    D[T03 synthesis trajectory NOD]
    P[T21 ST-NOD plus motif hybrid]
  end

  subgraph L2[L2 synthesis-response automatic BDs]
    O[T20 SR raw PCA ablation]
    E[T04 AutoQD SR-RFF PCA]
    N[T19 SR ReLU PCA]
  end

  subgraph L3[L3 codebook archives]
    F[T05 VQ codebook]
  end

  subgraph L4[L4 learned encoders]
    I[T06 Qwen diagnostic]
    J[Qwen3 preprocessing ladder]
    K[Encoder projection or fine-tuning]
    L[T07-T16 graph and multimodal scaffolds]
  end

  subgraph L5[L5 archive coupling]
    G[T17 passive local-Pareto audit]
    R[T23 SR Pareto validation matrix]
    H[Smooth-QD-style Pareto-biased parent sampling]
    S[T24 SR Pareto live validation]
    T[T25 guarded SR raw Pareto QD]
    U[T26 conservative exploit SR raw]
    X[T27 live QD audit]
    Y[T28 canonical family audit]
    Z[T29 front recovery diagnostic]
    AA[T30 T26 holdout audit]
    AB[T31 repair yield front emitter]
  end

  subgraph L6[L6 lineage and emitters]
    M[T18 adaptive emitter CVT]
    W[T12 lineage repair descriptors]
  end

  A --> Q
  A --> B
  A --> I
  B --> C
  B --> D
  C --> P
  D --> P
  D --> O
  D --> F
  O --> E
  O --> N
  E --> G
  N --> G
  F --> G
  G --> R
  R --> H
  E --> H
  N --> H
  H --> S
  S --> T
  T --> U
  U --> X
  X --> Y
  Y --> Z
  Z --> AA
  AA --> AB
  I --> J
  J --> K
  K --> L
  G --> M
  G --> W
```

## Iteration Flow

```mermaid
flowchart TD
  idea[New BD idea] --> spec[Technique package methodology]
  spec --> replay[Replay or bounded diagnostic]
  replay --> controls[Compare with classic, manual BD, and T22 when relevant]
  controls --> tier[T0/T1/T2/T3 decision]
  tier -->|T0| followup[Record ablation or hybrid idea]
  tier -->|T1 or T2| live[Same-budget live validation]
  tier -->|T3| holdout[Holdout or multi-seed confirmation]
  followup --> lanes[Update lane ledger and backlog]
  live --> lanes
  holdout --> lanes
  lanes --> branch{Needs isolated branch?}
  branch -->|No| current[Continue current revamp branch]
  branch -->|Yes| split[Create lane-specific branch and record return condition]
```

## Decision Ledger

| Date | Lane | Evidence | Tag | Decision | Next Artifact |
| --- | --- | --- | --- | --- | --- |
| 2026-06-21 | `L0` common evaluation | T22 random descriptor control | `control` | Random archive partitioning is a nontrivial comparator, so positive claims must beat it on the claimed metric. | Keep T22 in every validation table and central report. |
| 2026-06-21 | `L1` transparent CAD descriptors | T01/T02/T03/T21 replay packages | `hybridize` | Transparent features are useful for interpretation and ablations, but direct cells lose too much quality or passive-QD score. | Feed selected ST-NOD/motif features into local-Pareto or feature-selection variants. |
| 2026-06-21 | `L2` synthesis-response automatic BDs | T04 SR-RFF PCA | `advance` | Strongest near-classic automatic-BD lead; improves common-audit QD and front material while staying close on HV/best. | Bounded live SR-RFF local-Pareto validation. |
| 2026-06-21 | `L2` synthesis-response automatic BDs | T19 SR ReLU PCA | `advance` | Strongest final-HV and HV-AUC source, but it needs quality-safe parent pressure. | Live or passive ablation paired with local-Pareto retention and T22 comparator. |
| 2026-06-21 | `L2` synthesis-response automatic BDs | T20 raw PCA | `ablate` | Raw synthesis-response PCA preserves validity and front material, but loses too much best quality. | Use as the no-RFF/no-ReLU ablation in SR-family reports. |
| 2026-06-21 | `L3` codebook/discrete archives | T05 VQ codebook | `park` | Direct codebook pressure loses quality and yield; the codebook may still help as a side archive. | Revisit only after local-Pareto retention is live. |
| 2026-06-21 | `L4` learned encoders | T06 Qwen diagnostic | `ablate` | Raw whole-RTL embeddings are not enough; preprocessing and projection remain open. | Qwen3 canonical-RTL/netlist preprocessing ladder on an isolated env branch if needed. |
| 2026-06-21 | `L5` archive coupling | T17 passive MOME audit | `advance` | Scalar-cell retention discards useful local front material. | Implement bounded local-Pareto retention as a live search variant. |
| 2026-06-21 | `L5` archive coupling | T23 validation matrix | `advance` | SR-RFF and SR-ReLU beat random on different metrics, so the next run should test the archive mechanism, not another passive table only. | Candidate branch: `feat/journal-useful-bd-exp-20260622-pareto-live`. |
| 2026-06-21 | `L5` archive coupling | T24 live command package and vLLM preflight | `advance` | Existing `pareto_front` cell mode and NSGA-II parent selection are sufficient for the next live validation; the open item is execution, not archive-code invention. | Run `T24_sr_pareto_live_validation/commands/live_screen_v0.md`. |
| 2026-06-21 | `L5` archive coupling | T24 classic-vs-SR-RFF live result | `ablate` | SR-RFF local-Pareto runs end to end and preserves all three classic-covered problems, but the multi-pipe best-score and valid-PPA yield regression blocks promotion. | Compare with SR ReLU, then run SR raw/control arms before a family-level claim. |
| 2026-06-21 | `L5` archive coupling | T24 SR ReLU live result | `ablate` | SR ReLU also runs end to end and preserves all three classic-covered problems, with more front material than SR-RFF on traffic light and multi-pipe, but still loses too much multi-pipe best quality. | Compare with SR raw and live controls before a family-level claim. |
| 2026-06-21 | `L5` archive coupling | T24 SR raw live result | `ablate` | SR raw runs end to end, preserves all three classic-covered problems, improves ALU best score, and has the strongest SR-family multi-pipe front material, but still loses too much multi-pipe best quality and violates the traffic-light synthesis-validity gate. | Use as the front-material control for a quality/yield-guarded emitter variant. |
| 2026-06-21 | `L0` common evaluation | T24 random live result | `control` | Random runs end to end and preserves all three classic-covered problems, but is weaker than SR raw on ALU and multi-pipe front material and weaker than manual BD on traffic-light best score. | Keep as the required live random comparator. |
| 2026-06-21 | `L5` archive coupling | T24 manual BD live result | `ablate` | Manual BD improves ALU and traffic-light best scores without a yield collapse, but still loses 73.16% relative multi-pipe best score. | Use manual BD as the traffic-light quality control for the next guarded variant. |
| 2026-06-21 | `L5` archive coupling | T24 complete six-arm live matrix | `ablate` | Local Pareto cells and NSGA-II parent selection run end to end and preserve classic-covered designs, but every QD arm loses too much multi-pipe best quality. | Specify a quality/yield-guarded emitter or parent-pressure variant before larger live sampling. |
| 2026-06-21 | `L5` archive coupling | T25 guarded SR raw method card | `advance` | T25 keeps the SR raw descriptor and local Pareto archive but reduces improve-phase backfill and two-parent fusion to test quality/yield recovery without changing the BD. | Result captured in the T25 live-result row below. |
| 2026-06-21 | `L5` archive coupling | T25 guarded SR raw live result | `ablate` | T25 preserves all classic-covered designs and validates the Pareto archive, but traffic-light valid-PPA count falls from 30 to 9 and multi-pipe best score drops 75.20% versus classic, worse than unguarded SR raw. | Specify T26 emitter/parent-source variant using SR raw as front-material control and manual BD as traffic-light quality control. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T26 conservative exploit method card | `advance` | T26 keeps SR raw/local Pareto but restores T24's fill/repair/seed pressure, removes two-parent crossover, and makes archive-parent draws mostly champion-biased. | Run `T26_sr_raw_conservative_exploit_qd/commands/live_screen_v0.md`. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T26 conservative exploit live result | `advance` | T26 preserves all classic-covered designs, passes Pareto validation, improves ALU and multi-pipe best score versus classic, and recovers traffic-light valid-PPA count versus T25. Traffic-light quality and SR raw front-material gaps still block promotion. | T27 and T28 completed the live-QD and family audits; next is holdout or front recovery. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T27 live QD audit | `advance` | T26 beats classic on mean live HV (+11.62%), HV-AUC (+17.62%), and best score (+3.02%), and beats random on every audited aggregate metric. It still loses PPA-front points versus classic and SR raw, and lacks canonical family accounting. | T28 completed canonical duplicate/family audit; next is holdout or front recovery before any promotion claim. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T28 canonical family audit | `advance` | T26's valid-PPA pool is not duplicate collapse: it has the highest valid-family ratio and one more reference-beating family than classic. The blocker is real front-family coverage: T26 has 9 front families versus classic's 19 and SR raw's 16. | Run T26 holdout or an SR raw front-recovery variant with direct PPA-front figures and the Phase 03.1 viewer. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T29 front-recovery method card | `advance` | T29 keeps SR raw PCA and T26's archive substrate, but lowers champion pressure to 0.60 and restores limited 0.20 two-parent fusion to test front recovery before any promotion claim. | Run `T29_sr_raw_front_recovery_qd/commands/live_screen_v0.md`. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T29 live front-recovery result | `retire` | T29 does not recover front material: mean HV, HV-AUC, valid PPA, total front points, and multi-pipe final-PPA coverage all regress versus T26. Direct PPA-front plots show only two multi-pipe front points. | Do not continue blind T24/T26 schedule interpolation; run T26 holdout or specify a T31 repair/yield/front-preserving emitter. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T30 holdout method card | `advance` | T30 tests whether exact T26 conservative-exploit SR raw generalizes to the frozen VerilogEval holdout screen before adding a new emitter. | Run `T30_t26_holdout_front_audit/commands/live_holdout_v0.md`. |
| 2026-06-21 | `L5/L6` archive coupling and emitters | T30 live holdout result | `advance` | T26 preserves all three classic-covered holdout designs, improves mean final-best score by 9.91%, and produces positive normalized HV from P135. It also drops valid PPA samples from 103 to 68, has a P098 yield warning at 15 versus 31 valid PPA samples, ties candidate-level front points at 3, and has fewer front netlists than classic. | Specify T31 repair/yield/front-preserving emitter with `T30_t26_holdout_front_audit/figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png` as a primary control figure. |
| 2026-06-22 | `L5/L6` archive coupling and emitters | T31 failure-feedback repair method card | `advance` | T31 keeps T26's SR raw descriptor/archive, NSGA-II parent selection, and 0.80 champion lane, but switches to code-individual `single_thought_operator` with 1200-character fail-pool feedback. It avoids `thought_only` and extra repair calls because prior evidence showed those can trade away PPA quality. | Run `T31_sr_raw_fail_feedback_repair_qd/commands/live_holdout_v0.md`, then package T31 against T30 classic/T26 controls. |
| 2026-06-22 | `L5/L6` archive coupling and emitters | T31 live holdout result | `retire` | T31 preserves 3/3 final-best coverage, but valid PPA drops to 56, P098 drops to 14 valid PPA samples, mean final-best score drops to 0.201770, HV/HV-AUC are zero, and unique PPA points fall to 6. | Do not retry direct fail-feedback repair; specify a front-preserving emitter/archive ensemble with T26/T30/T31 controls. |
| 2026-06-21 | `L6` lineage and emitters | T12/T18 scaffolds plus T17/T24/T25 evidence | `hybridize` | Lineage/emitter methods should improve search dynamics around SR-family descriptors, not become generic descriptor resets. | Specify exploit/explore/repair scheduling from the observed T24/T25 failures. |

## Lane Notes

### `L1` Transparent CAD Descriptors

T01 and T02 are useful controls, not promotion candidates. They make the lower
bound clear: simple structural descriptors can preserve some coverage but lose
too much PPA quality or common-audit QD score. T03 is more important because
ST-NOD remains close on HV while losing common-audit QD score. That makes T03 a
source for hybrids, not a retired family.

Current follow-up: combine ST-NOD with pathlet/reconvergence features or with
the T17 local-Pareto retention rule. T21 shows simple ST-NOD plus motif
concatenation should not be the next deterministic live method: it increases
PPA-front unique netlists by 66.67% and common-audit cells by 33.33%, but drops
best fitness by 10.90% and common-audit QD score by 25.98%.

### `L0` Common Evaluation

T22 makes the control bar explicit. Random hash improves HV AUC by 35.69% and
PPA-front unique netlists by 75.00% versus classic, despite losing final HV,
common-audit cells, and common-audit QD score. Future positive claims must
therefore beat classic, manual BD, and random descriptor on the specific metric
being claimed.

T24 adds the same random descriptor as a live local-Pareto control. It preserves
all three classic-covered problems but loses 71.33% best score on
`Prob015_multi_pipe_8bit` and triggers a 73.33% relative traffic-light
synthesis-validity drop. It is a required comparator, not a promotion lead.

### `L2` Synthesis-Response Automatic BDs

This is the strongest lane. T04 SR-RFF PCA is `T1 near_classic`: it remains
within a small quality tolerance, improves HV AUC and common-audit QD score, and
increases PPA-front unique netlists. It still loses some final HV and audit
occupancy, so it is not a finished positive claim.

T19 SR ReLU PCA is a different kind of lead. It improves final mean HV by
16.82% and HV AUC by 65.24% versus classic on the seed-1001 replay, with two
per-problem HV wins and no validity collapse. It stays `T0 diagnostic` because
final best fitness falls by 5.04%, PPA-front unique netlists fall by 8.33%, and
common-audit occupied cells fall by 16.67%.

T20 SR raw PCA is the necessary ablation. It preserves valid-PPA count and
common-audit occupied cells, increases PPA-front unique netlists by 16.67%, and
increases motif signatures by 11.63%. It remains `T0 diagnostic` because final
best fitness falls by 9.97% and common-audit QD score falls by 15.11%.

Current follow-up: revise the SR-family archive coupling. The completed T24
matrix shows that local-Pareto retention produces valid front material and
preserves classic-covered designs, but every QD arm loses too much
`Prob015_multi_pipe_8bit` best quality for promotion.

### `L3` Codebook/Discrete Archives

T05 shows direct VQ parent pressure is too expensive in PPA quality and
valid-PPA yield. The codebook idea should not be abandoned entirely, but it
should move from "the descriptor" to "a side archive" or "a cell partition with
local Pareto fronts."

Current follow-up: test VQ only with MOME-style retention or as an auxiliary
archive paired with SR-RFF/SR-ReLU exploitation.

### `L4` Learned Encoders

T06 shows Qwen3 embeddings contain signal but are contaminated by problem,
identifier, and corpus axes. Raw whole-file embeddings should not be promoted.
The useful question is preprocessing and projection: canonical RTL,
Yosys-normalized netlist text, structural summaries, pooled chunks, and
non-PPA contrastive or structural-bucket heads.

Current follow-up: run the Qwen3 preprocessing ladder before training a head.
If collapse diagnostics improve, escalate to Qwen projection or multimodal
fusion with graph descriptors.

### `L5` Archive Coupling

T17 addresses the user's concern that classic wins partly because it keeps
sampling higher-quality parents and hill-climbs. The passive local-Pareto audit
keeps nondominated candidates inside each descriptor cell rather than one scalar
elite. It recovers more PPA-front netlists and Pareto points, especially for
SR-RFF PCA, but its own HV delta is too small for promotion.

T23 narrows the next live target. SR-RFF PCA beats classic and T22 random on
common-audit QD score and local front material while staying within the
near-classic quality tolerance. SR ReLU PCA beats classic and random on final
HV and HV AUC, but does not beat random on local front material.

T25 keeps SR raw and tests whether lower improve-phase backfill plus less
two-parent fusion recovers quality/yield without changing the descriptor. It
does not. T25 preserves all classic-covered designs, but multi-pipe best score
falls 75.20% versus classic, worse than SR raw's 57.09% loss, and
traffic-light valid-PPA count falls from classic's 30 to 9.

T26 keeps the same SR raw descriptor but restores T24-style fill pressure,
removes two-parent crossover, and biases archive-parent draws toward the
champion lane. This recovers best-quality pressure on the development screen:
ALU improves by 3.73% versus classic and multi-pipe improves by 14.34% versus
classic. Traffic-light still trails classic by 3.48%, and SR raw still has more
multi-pipe global Pareto members.

T27 audits T26 against the live T24/T25 controls. T26 beats classic on mean
live HV (+11.62%), HV-AUC (+17.62%), and best score (+3.02%), while beating
random on every audited aggregate metric. The audit also exposes the blocker:
T26 has 9 PPA-front points versus classic's 18 and SR raw's 16, and the live
logs only support unique PPA-tuple accounting, not canonical implementation
families.

T29 tests the simplest front-recovery hypothesis: lower T26 champion pressure
and restore limited two-parent archive fusion. It fails. Mean HV falls by
22.12% versus T26, HV-AUC falls by 18.06%, valid PPA falls by 26.32%, and
multi-pipe loses final-PPA coverage. Direct PPA-front plots show only two
multi-pipe rank-1 front points.

T30 runs T26 holdout validation before any new emitter. It supports T26 as a
holdout-competitive quality-pressure method: final-best coverage is preserved
on all three VerilogEval holdout problems, mean best score improves by 9.91%,
and P135 supplies positive normalized HV. It also keeps the central blocker
alive: P098 valid PPA samples fall from 31 to 15, candidate-level front points
tie classic at 3, and front netlists fall from 9 to 6.

Current follow-up: direct T31 fail-feedback repair is retired. Use classic as
the holdout comparator, T26 as the quality-pressure control, T29 as the failed
front-recovery control, T31 as the failed repair control, and T30/T31 direct
raw PPA Pareto figures as required visual comparisons for a front-preserving
emitter/archive ensemble.

### `L6` Lineage And Emitters

T12 and T18 should not be generic new descriptors. They should use evidence from
T03/T04/T17 to bias mutation sources: repair-prone ancestors, underfilled cells,
and local Pareto fronts. This lane is for improving search dynamics while
leaving descriptor construction PPA-free.

Current follow-up: T29 shows champion-pressure reduction alone can break
multi-pipe survival, while T30 shows T26 still needs P098 yield and front
breadth repair. A repair/yield emitter should therefore keep T26-style champion
refinement and add a bounded repair/front-preservation lane rather than
replacing champion pressure with generic two-parent exploration.

## Branching Guidance

Continue on `feat/journal-useful-bd-exp-20260622` for lightweight replay
packages, docs, and scripts. Create a new branch only when a lane needs a
long-running live vLLM run, incompatible dependency stack, or source checkout
that would make the current branch hard to review. Suggested branch suffixes:

- `feat/journal-useful-bd-exp-20260622-pareto-live`
- `feat/journal-useful-bd-exp-20260622-qwen-ladder`
- `feat/journal-useful-bd-exp-20260622-encoder-env`

Any branch split must keep the same revamp root, append to this file, and point
back to the source technique packages.

## Branch And Iteration Queue

Use this table to decide whether a lane stays on the current branch, gets a
focused follow-up branch, or is parked until another lane creates evidence that
unblocks it.

| Lane | Source IDs | Current Branch State | Next Iteration | Return Condition |
| --- | --- | --- | --- | --- |
| `L0` common evaluation | T22, T24 random | Stays on current branch as a comparator. | Keep random/manual controls in every claim table. | Comparator rows are present for any method marked `advance` or better. |
| `L1` transparent CAD descriptors | T03, T21 | Stays on current branch for hybrids. | Select a small ST-NOD/motif subset for a guarded archive variant. | Hybrid beats direct T21 on best quality without losing archive coverage. |
| `L2` synthesis-response automatic BDs | T04, T19, T20, T24, T25, T26, T27, T28, T29, T30, T31 | Stays on current branch; T29 and T31 are measured negative, while T30 is mixed holdout support for T26. | Specify a front-preserving emitter/archive ensemble. | New method improves front/yield without losing T26 quality pressure. |
| `L3` codebook/discrete archives | T05 | Parked. | Reopen only as side archive or local-Pareto cell partition. | A non-codebook lane shows local front material worth discretizing. |
| `L4` learned encoders | T06-T16 | Candidate split branch. | Run Qwen3 preprocessing ladder before fine-tuning or external graph encoders. | Normalized embedding diagnostics separate useful structure without problem-ID clustering. |
| `L5` archive coupling | T17, T23, T24, T25, T26, T27, T28, T29, T30, T31 | Active on current branch; T31 is negative and supplies direct-front/HV controls. | Specify the next front-preserving archive/emitter method card. | A candidate beats controls on documented direct-front/HV metrics without hidden duplicate loss. |
| `L6` lineage and emitters | T12, T18, T26, T27, T28, T29, T30, T31 | T31 shows same-budget fail-pool feedback is insufficient. | Split champion, near-front, and bounded-repair emitter roles. | Better valid-yield recovery or front material than T26/T29/T30 without losing T26 best-quality recovery. |

## Branch Split Checklist

A branch split is justified when the next step needs a long live vLLM run, a
new dependency stack, an external source checkout, or a method-specific env that
would make this branch harder to review. Before creating that branch, record:

- lane and source technique IDs;
- intended technique package ID;
- run output root under `exp/useful_bd_push/`;
- required comparator set, including T22 when a positive claim is possible;
- return condition for merging the result back into this revamp directory.

## Result Update Template

When a technique lands new evidence, update the package docs and this lane file
with the same compact shape:

| Field | Required Content |
| --- | --- |
| Lane | `L#` lane plus the chronological `T##` package. |
| Evidence | Replay, live run, validation matrix, diagnostic, or failed setup. |
| Comparator | Classic, manual BD, random BD, and any lane-specific ablation. |
| Main signal | Best score, HV/AUC, front material, archive coverage, validity, or synthesis yield. |
| Failure mode | What blocks promotion or what must be guarded in the next variant. |
| Decision | One of `advance`, `ablate`, `hybridize`, `park`, `control`, or `retire`. |
| Next artifact | Exact technique package, branch, command file, table, or figure to update next. |
