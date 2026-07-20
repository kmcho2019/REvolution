# Classic REvolution Method Audit

Status: `REVIEWED`, 2026-07-20. Independent closure verdict: `PASS`. No
candidate is `READY`.

## Scope And Provenance

This audit separates three questions:

1. What the ASP-DAC 2026 paper claims.
2. What the classic mode in the current repository does.
3. What completed post-conference experiments actually support.

The conference paper is pinned at submodule commit
`6d81985f74d7fec9b7a341c0e8042d8105751564`. Its core method is in
`content/3_method/v_camera.tex`, and its evidence is in
`content/4_expnrst/v_camera.tex` and `table/result.tex`.

The repository audit point is commit
`9104aff2cdb6d5dff9ef75044b92a03b653d21b9`. The current engine contains
post-conference experimental modes. Only the behavior selected by the frozen
classic configuration is the comparator. Candidate work must not alter that
path.

## Frozen Identifiers

| Artifact | Identifier |
| --- | --- |
| Current classic engine | `src/revolution/algorithm.py`; Git blob `31e64763a0c7567b206ca0f98fce92c5936b57fc`; SHA-256 `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655` |
| Backend adapter | `src/revolution/backends/revolution_backend.py`; SHA-256 `8eb619b85befc141188fbd6719967a56c9868d8fd4afac8afc7693dc17c0d4da` |
| Repository default config | `data/configs/evolution_default.yaml`; SHA-256 `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b` |
| Historical five-seed baseline | `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5`; 250/250 problem-seed summaries present |
| Historical seed-1001 config | SHA-256 `a738ae9784137aaf6c02f29bfaa947e212f2eb348116e0d5ccec3e26b5e509ce` |
| Conference paper | Gitlink `6d81985f74d7fec9b7a341c0e8042d8105751564` |

The historical baseline uses `openai/gpt-oss-120b`, whole-output generation,
the EoH operator family, dual pools, UCB with `c=2`, population 8, five
generations, temperature/top-p 1.0/1.0, and 128000 output-token ceilings. Its
configs vary by seed and output path, so each seed config keeps its own hash.
These artifacts estimate variance and inform design selection. They do not
replace a current-HEAD reproducibility check.

## Conference Claims And Evidence

| Paper claim | Paper location | Evidence in paper | Audit status |
| --- | --- | --- | --- |
| Population evolution improves correctness and PPA over equal-call independent sampling. | Method lines 6-14; experiment lines 59-73. | One unreplicated Llama-3.3-70B comparison with 200 independent samples matched to 10 offspring times 20 generations. Initialization and feedback calls are not matched in the paper's accounting. | `SUPPORTED` directionally for that single-run, offspring-count-matched Llama comparison only. |
| Thought, Code, and Feedback form an effective evolutionary representation. | Method lines 18-26. | No representation ablation. | `UNPROVEN`. |
| Dual Fail/Success populations target repair and PPA optimization effectively. | Method lines 41-48. | No single-pool or allocation ablation in the paper. | `UNPROVEN`; implementation has a material information-loss limitation. |
| Six heterogeneous prompt strategies provide useful variation. | Method lines 51-80. | One qualitative adder trajectory; no operator-level comparison. | `UNPROVEN`; generic prompts and C-F evidence make this a priority audit surface. |
| UCB-softmax improves operator allocation. | Method lines 82-113. | No fixed-policy or random-policy ablation. | `UNPROVEN`. |
| Weighted fitness and survivor selection steer PPA optimization. | Method lines 28-39 and 141-153. | Full loop beats sampling, but selection components are not isolated. | `SUPPORTED` only as part of the bundle; scalarization is `LIMITING` as a formulation. |
| Reported PPA gains represent optimized designs. | Experiment lines 6-16. | PPA averages on designs over 50 gates; four RTLLM references excluded; pre-synthesis pass rate differs from post-synthesis PPA eligibility. | `LIMITING` for broad claims; accepted hardened reporting must govern the journal evidence. |

The paper supports iterative evolution, but it does not identify which internal
component causes the gain. Journal claims must not promote an unablated
conference component to an established mechanism.

## Paper And Code Divergences

These are method-description errors, not proposed algorithm changes:

| Surface | Conference description | Frozen classic behavior | Provenance and consequence |
| --- | --- | --- | --- |
| Fail/Success boundary | Simulation correctness determines the pool, and functionally correct candidates receive fitness. | `success` requires simulation, synthesis, post-synthesis functionality, and valid PPA. A simulation-passing synthesis or PPA failure remains Fail with `-inf`. | Present by repository commit `60c1b69d` on 2025-07-31, before the paper's 2025-10-23 initial submission. Journal pseudocode must use the implemented verification-complete boundary. |
| Survivor source | Metric champions come from parents; remaining slots come from all parents plus offspring. | Champions and fill slots come from old Success plus new offspring. Old Fail is excluded. With zero old Success, each generation retains only current offspring. | Also present at `60c1b69d`. Journal text must disclose the restart-like failed-lineage behavior and any treatment must compare against it unchanged. |
| Softmax temperature | The paper exposes temperature `tau` and reports `tau=1`. | The code computes `exp(score - max_score)` with no temperature parameter. | Implemented behavior equals the reported `tau=1`, but `tau` is not a tunable classic state. |
| Ablation budget | The paper calls 200 independent samples and REvolution an identical LLM-call budget. | The count matches only 10 offspring times 20 generations; REvolution also initializes 10 candidates and requests candidate feedback. | Treat this as an offspring-count-matched directional ablation, not a fully resource-matched control. New journal comparisons must report calls and tokens directly. |

The paper's initial-to-final results for GPT-4.1-mini and DeepSeek-V3 are not
matched controls. They cannot extend the evolutionary-loop support beyond the
single Llama offspring-count-matched ablation.

## Classic Code Map

| Component | Current classic behavior | Exact path | Tunable state |
| --- | --- | --- | --- |
| Representation | `Heuristic` stores thought, code, feedback, status, scalar score, and PPA metrics. | `src/revolution/algorithm.py:162-331` | Representation and generation modes exist post-conference; classic uses code individuals and whole output. |
| Fitness | On reference-complete tasks, valid PPA receives the equal mean of normalized power/area improvements and timing for sequential designs. Candidate-side invalid PPA receives `-inf`. | `src/revolution/algorithm.py:882-950`, `1298-1322` | Reference completeness is a baseline precondition; the helper otherwise returns zero for missing reference PPA. |
| Verification funnel | Format, syntax, simulation, synthesis, post-synthesis functionality, and PPA produce typed statuses. Every failed stage receives `-inf`. | `src/revolution/algorithm.py:1154-1354` | Simulator, synthesis, and timeout configuration. |
| Dual pools | Status `success` enters Success; every other status enters Fail. | `src/revolution/algorithm.py:3197-3208`, `3277-3403`, `4118-4125` | `population_pool_mode=dual`. |
| Offspring split | Fail and Success offspring counts are proportional to current pool size. | `src/revolution/algorithm.py:3773-3805` | Population and offspring count. |
| Operators | Fail uses Fix/Simplify/Explore/Refactor/Improve; Success uses Simplify/Explore/Refactor/Improve/Fusion. | `src/revolution/algorithm.py:3779-3786`, `3820-3950`; `data/prompts/default/evolve/` | Operator sets and prompt corpus. |
| Operator allocation | Separate Fail and Success UCB statistics feed softmax sampling. | `src/revolution/algorithm.py:3405-3625` | Selection method, `ucb_c`, temperature implementation. |
| Parent selection | Fail parents are uniform random. Success parents use roulette weights shifted from the minimum scalar score. | `src/revolution/algorithm.py:3820-3836`, `3888-3921` | Parent arity follows operator. |
| Operator reward | Fail reward is binary transition to Success. Success reward is binary scalar-score improvement over one parent or over the better of two parents. | `src/revolution/algorithm.py:3980-4046` | No magnitude, failure-stage, or per-objective credit. |
| Survivors | The pool contains old Success plus all new offspring. Metric champions survive first; remaining slots use scalar score. | `src/revolution/algorithm.py:4048-4125` | Population size and champion metrics. |

The survivor pool at line 4049 excludes the previous Fail pool. Therefore, a
failed lineage survives only if it is newly regenerated in that generation.
Typed failure stages affect feedback text, but not fail-parent ranking,
retention, offspring allocation, or UCB reward.

## Component Findings

### 1. Iterative Population Search: `SUPPORTED`

The paper's offspring-count-matched Llama ablation directionally supports
retaining a population, evaluation feedback, and iterative offspring generation
as the journal substrate. Its call and token budget is not fully matched. The
completed classic-substrate single-thought ablation loses pooled score by
`-0.092`, with CI `[-0.149, -0.037]`, on 39 paired units. This rules out operator
unification as a presumed simplification win.

### 2. Six-Operator Portfolio: `UNPROVEN` And `LIMITING`

The checked-in prompts ask broadly to fix, simplify, explore, refactor, improve,
or fuse. They do not encode a validated hardware transformation model. The
paper provides no per-operator ablation or useful-child yield analysis.

The clean five-seed no-C-F control is informative but not decisive. Removing
Fusion changes mean final HV from `0.103802` to `0.106846`, HV-AUC from
`0.086797` to `0.094592`, mean coverage from `32.8` to `33.2`, and valid-PPA
rows from 4882 to 4978. The paired final-HV delta is `+0.0030`, CI
`[-0.0068, 0.0153]`, with `41/41/148` W/L/T. Fusion is therefore not proven
useful, but removal is not yet a confirmed final-HV improvement.

A canonical no-C-F reanalysis and operator-yield audit are justified. A large
new prompt taxonomy is not. POET and COEVO already publish hardware-specific
operator families and synthesis-aware prompts, so that idea alone no longer
has a credible novelty delta.

### 3. UCB-Softmax Allocation: `UNPROVEN`

No completed clean ablation establishes that UCB beats a fixed uniform policy.
The reward discards improvement magnitude and all failure-stage progress. A
UCB-versus-fixed-policy ablation is the smallest missing conference component
test. It can support simplification or validate the original mechanism, but it
is unlikely to be a primary TCAD novelty claim by itself.

Contextual or category-specific rewards are not an open generic novelty lane:
COEVO already uses category-specific correctness/PPA rewards with UCB-softmax.

### 4. Scalar PPA Selection: `LIMITING` In Formulation

One equal-weight scalar cannot represent all non-convex PPA tradeoffs, although
classic partially offsets this through per-metric champions. The limitation is
conceptual, not evidence that Pareto selection performs better at this budget.

The descriptor-free F41 replacement failed its frozen two-seed full-RTLLM gate:
classic versus Pareto final HV was `0.104745` versus `0.103991`, HV-AUC was
`0.090500` versus `0.083317`, valid-PPA tied at `65/92`, and functionality was
`75/92` versus `74/92`. The earlier QD/MOME campaign also failed to beat classic
final HV at five seeds. Do not relaunch global NSGA-II, per-cell capacity, BD,
or neighboring Pareto-selection variants without a distinct measured
mechanism.

### 5. Dual Hard Feasibility Split: `UNPROVEN` And `LIMITING`

The verification funnel already emits meaningful hardware stages, but classic
collapses all failures to `-inf`, samples them uniformly, rewards only a full
Fail-to-Success transition, and drops old failed lineages during survival. Pool
size is used as a proxy for search opportunity even when many failures occupy
different stages.

This is a concrete conference limitation. A minimal stage-aware retention or
credit mechanism could be a natural correction because it reuses existing
general evaluator outputs. Novelty is at risk: COEVO directly proposes
fine-grained correctness, partial-candidate retention, synthesis diagnosis, and
an adaptive correctness gate. Any new card must state a narrower and clearly
different REvolution-specific mechanism before implementation.

### 6. Whole-Output Mutation: `UNPROVEN`

The conference path regenerates complete RTL. Current post-conference code has
diff infrastructure, but no accepted paired evidence establishes that broad
rewrites cause the functional losses or that local patches improve valid-PPA
yield. H3 therefore starts with an unverified causal premise. SymRTLO and
LongRTL also occupy structured AST/local optimization. Do not promote H3 until
classic-only edit-size and failure-transition telemetry establish the premise
and the card states a distinct delta.

### 7. Evaluator And Reporting: `LIMITING`

The conference reports average improvements only on eligible successful
designs, uses a gate-count threshold, excludes unsynthesizable references, and
separates pre-synthesis pass rate from post-synthesis PPA validity. The current
journal contract correctly requires penalized missing outputs, hardened
post-synthesis functionality, reference-complete HV, paired uncertainty, and
resource accounting. Evaluation hardening is necessary supporting methodology,
not an algorithmic novelty claim.

### 8. Generation-Only Scope: `LIMITING`, But Crowded

The paper generates RTL from specifications and does not establish optimization
of valid suboptimal RTL or long designs. RTL-OPT provides a stronger seeded
optimization benchmark, but POET already combines that task with evolutionary
search. LongRTL, SymRTLO, and Alpha-RTL further cover structured, long-context,
and test-time RTL optimization. Seeded optimization remains useful as a
generalization test only after an independently novel algorithmic candidate is
confirmed. H4 is not a standalone primary contribution.

## Related-Work Collision Matrix

This first-pass matrix pins the primary-paper versions reviewed on 2026-07-20.
Evidence anchors are short excerpts plus the exact method sections.

| Work | Version and evidence anchor | Collision with current seed cards | Consequence |
| --- | --- | --- | --- |
| [POET](https://arxiv.org/abs/2603.19333v1) | v1, 2026-03-19; Sections 2.2-2.3: "non-dominated sorting, power-first intra-level ranking, and proportional survivor selection"; Section 2.3.1 defines hardware-specific operators. | H2, H4, and a generic hardware-operator card. | Those ideas require a sharper delta; seeded evolution is supporting generalization. |
| [COEVO](https://arxiv.org/abs/2604.15001v2) | v2, 2026-04-17; Sections 4.1.2-4.3: rewards are "category-specific, reflecting each operator category's optimization intent"; correctness is continuous and the gate anneals. | H1, H2, and a failure-stage or hardware-operator card. | H1 does not state how bottleneck conditioning differs from COEVO's category feedback. This is a novelty hold, not proof that the mechanisms are identical. H2 also conflicts with F41. |
| [RTL-OPT](https://arxiv.org/abs/2601.01765v1) | v1, 2026-01-05; Sections 2.3 and 3: each task has a "suboptimal version and a human-optimized reference"; 35/36 improve under `compile_ultra`, 33/36 under Yosys. | H4. | Supports a benchmark role, not method novelty; tool-flow sensitivity must be reported. |
| [LongRTL](https://arxiv.org/abs/2606.08944v1) | v1, 2026-06-08; Sections III-C to III-E partition "semantically meaningful AST subtrees", optimize, and reconstruct them. | H3 and long-design claims. | A generic local or partitioned rewrite claim is crowded. |
| [SymRTLO](https://arxiv.org/abs/2504.10369v2) | v2, 2025-09-22; method uses "AST-based templates", symbolic FSM optimization, and formal plus test-driven checks. | H3 and hardware rewrite rules. | Contract-preserving rewriting needs a distinct mechanism and stronger oracle. |
| [Alpha-RTL](https://arxiv.org/abs/2606.05253v1) | v1, 2026-06-03; Sections 3.1-3.6 use a "PUCT state pool", EDA reward, and per-design test-time policy updates. | Generic adaptive search or state-pool claims. | Avoid repackaging tree/state reuse as a REvolution extension. |

## Negative Map

The dispositions below apply to the same mechanism family and comparable
budget. They are resource-allocation rules, not universal impossibility claims.

| Prior mechanism | Result | Default disposition here | Evidence |
| --- | --- | --- | --- |
| Smooth-QD V2 and full BD/geometry campaign | Five-seed V2 final HV `0.098801` versus classic `0.103802`; S07 capacity-3 near miss `0.102481`, with better AUC and one more covered unit. | Deprioritize broad QD revival, BD scans, and capacity interpolation absent a distinct measured mechanism. AUC cannot rescue a primary final-HV loss. | `20260703_121857_KST_natural_qd_push/suite_variant_campaign/README.md` |
| Descriptor-free global Pareto selection (F41) | Two-seed final HV, AUC, and functionality gates failed. | Deprioritize H2 as written and adjacent NSGA-II variants absent a distinct measured mechanism. | `20260710_222442_KST_pareto_revolution_validation/README.md` |
| Unified single-thought operator on classic | Pooled delta `-0.092`, CI `[-0.149, -0.037]`. | Single-operator simplification and any treatment using `single_thought_operator`. | `docs/journal_features/13_findings_dashboard.md`, F3/F9 |
| PCN-v3 memory | Five-seed controlled comparisons did not beat classic or no-C-F classic. | Deprioritize triggered memory, archive credit, and nearby memory schedules absent a distinct measured mechanism. | `reviews/20260710_review_bundle/evidence/operator_ablation/classic_no_cf_report.md` |
| C-F removal | Positive means and yield, but final-HV CI crosses zero. | Claims that Fusion is harmful or no-C-F is already paper-ready. | Same no-C-F report. |

## Ranked Weaknesses

Scores are qualitative and include the independent review completed on
2026-07-20.

| Rank | Weakness | Evidence | Tractability | Naturalness | Paper value | Disposition |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Conference components lack isolated evidence, especially UCB and operator utility. | High | High | High | Medium | Run analysis and the smallest fixed-policy/operator-subtraction ablations; supporting spine, not assumed headline. |
| 2 | Failure stages are observed but discarded by selection, reward, and retention. | High from code; performance effect unknown | Medium | High | Medium if differentiated | Form one collision-aware card only after novelty review. |
| 3 | Generic operators have weak hardware grounding. | High from prompts; C-F signal is mixed | Medium | High | Low alone due POET/COEVO | Measure operator yield first; do not build a taxonomy speculatively. |
| 4 | Scalarization cannot express the full PPA front. | High conceptually; replacement evidence negative | High | High | Low after F41/POET | Recommend H2 retirement at proposal review unless it states a distinct mechanism; no adjacent Pareto search. |
| 5 | Whole-output mutation may cause semantic drift. | Plausible but not yet measured | Medium | High | Low due prior work | Telemetry only until causal evidence and novelty exist. |
| 6 | Generation-only evaluation misses seeded and larger RTL. | High | Medium | High | Supporting only | Use as confirmation/generalization after an algorithmic candidate. |

## Keep Unchanged

- the population-based iterative search substrate;
- EoH operators for baseline and non-operator treatments;
- simulation, synthesis, and post-synthesis functionality gates;
- the classic comparator's scalar score, parent selection, UCB, and survivor
  behavior unless that exact component is the isolated treatment;
- equal candidate-evaluation and synthesis budgets;
- 128000-token reasoning-model ceilings;
- penalized, paired, reference-complete journal reporting;
- the classic engine and baseline prompt files byte-for-byte during treatments.

## Candidate Implications

- H1 is not promotable as written because it does not distinguish bottleneck
  conditioning from COEVO's category-specific correctness/PPA UCB rewards. It
  may be reformulated only if that delta is concrete and falsifiable.
- H2 is not promotable as written because F41 failed and POET/COEVO cover
  Pareto or preference-aware selection.
- H3 lacks a measured premise and collides with structured RTL rewriting work.
- H4 is a generalization stage, not an independent algorithmic candidate.
- The cleanest immediate work is classic-only mechanism telemetry plus two
  missing component ablations: UCB versus fixed uniform allocation and a
  canonical no-C-F comparison. Neither should be advertised as primary novelty.
- At most one new stage-aware failure card should be drafted. It must differ
  explicitly from COEVO, use only existing evaluator stages, and avoid annealing,
  adaptive gates, reward shaping, and parameter scans.

H1-H4 remain `PROPOSED`. The recommendations above execute during proposal
review; they are not terminal candidate decisions and do not yet change the
hypothesis registry.

## Audit Closure

The independent review trail is in
`reviews/20260720_claude_conference_audit.md`. Its closure pass verified the
paper/code map, evidence labels, completed-result numbers, and candidate holds.
The conference-method audit gate is closed. Baseline, statistics, seed roles,
holdout eligibility, and resource ceilings remain separate open gates before
any live treatment.
