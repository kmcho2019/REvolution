# 14. Narrative Posture Assessment (contribution vs. reviewer muster)

**Purpose.** A candid, evidence-grounded read of whether the revamp is
achieving the novelty/contribution goals of the original ruminations
(`revamp_ruminations_20260612.md`) and whether the storyline can pass
TCAD reviewer muster. Written 2026-06-13 from findings F1–F7 / M1–M7
(doc 13). Strategic companion to the frozen claims contract
(`journal_narrative.md`, which wins on any conflict) — this doc is
assessment, not a claims change.

## The five conference criticisms → answer → honest status

| # | Conference criticism | Journal answer | Status (evidence) |
| --- | --- | --- | --- |
| 1 | Weighted-sum PPA biases search | Pareto-front cells (no scalar weight) | Implemented; performance value is seed-noise (F5). Defensible as *principled removal of a biasing knob*, not a measured win. |
| 2 | EoH operators arbitrary | One unified thought-operator | **Parity within QD (F2): one operator = six, no cost** — answers the criticism, but only within QD (F9). |
| 3 | Bandit/UCB claimed, never ablated | Bandit removed; operator ablated | **Ablated (F2, 3-seed): the missing ablation now exists** — verdict is parity, QD-entangled. |
| 4 | Benchmarks too small | CVDP + RealBench integrated | Integrated, **not yet demonstrated** as meaningful PPA wins. |
| 5 | No diversity | QD MAP-Elites + BD trio | Implemented; **value unproven, BD justification weak** (M5, bake-off pending). |

## The uncomfortable core truth

The original goal — make the QD/Pareto/thought version **beat** classic
REvolution — is **not achieved and the evidence says it will not be.**
F1 is CONFIRMED across two seeds: every journal arm loses on best-quality
(−0.08 to −0.13); all five repair screens DEMOTED. This is blocker A from
the ruminations, unfixed. If the paper pitch is "our fancier search
wins," it has no result to stand on. We are tracking **Branch C / B-scoped,
not the triumphant Branch A.**

> **UPDATE 2026-06-14 — the posture improved: a POSITIVE QD contribution
> now exists (F22/F23, doc 16).** The "QD loses −0.08 to −0.13" verdict was
> specific to the RADICAL `thought_only` build. A *smooth* integration —
> direct-code QD (`code_individual`, drops the harmful indirection) +
> global NSGA-II non-domination-rank selection — reaches **near-parity:
> best_quality −0.011, functional TIE, 12/13 within the parity band**
> (single seed 1001; multi-seed 1002-1003 confirming now). The deficit
> collapsed from −0.10 to −0.011, concentrated on ~1 intrinsic-limitation
> problem (parallel2serial). So the pitch is no longer "we win" NOR pure
> characterization — it is **"QD/MAP-Elites as a parity-quality diversity
> augmentation: NSGA-II selection over an archive removes the weighted-sum
> bias (#1) and adds behavioral diversity (#5) at no quality cost vs a
> strong classic baseline."** That is a *positive, principled* contribution
> a reviewer can accept, and it directly converts criticisms #1 and #5 from
> "implemented, value unproven" to "implemented, parity-demonstrated."
> Pending: the 3-seed pooled cluster-bootstrap CI (the formal parity
> verdict) + the alu/quality win replicating across seeds.

## The stronger storyline the work actually produced

A *characterization* contribution, not a victory lap — and it is more
defensible than "we win":

1. **Operator simplification (the publishable spine, F2/F3) — but
   QD-entangled, NOT standalone (F9).** The unified operator is
   parity-or-better than the six-operator suite *within QD* (formal
   3-seed pooled +0.011, CI [−0.006,+0.030] — PARITY, passes the
   parity-or-better bar but is NOT "better"; the 2-seed "better" did not
   replicate) yet *worse* on the classic
   substrate (pooled −0.092, CI [−0.149,−0.037]). Clean mechanism: the
   archive supplies the exploration the hand-engineered operators
   otherwise manufacture. **This is the ablation criticism #3 said was
   missing** — but the earlier hope that it is "independent of QD's fate"
   is **falsified (F9)**: it only wins inside QD. Consequence: the
   narrative's Branch C floor leg (i) (a simplification win independent of
   QD) is **not met**, predeclaring venue reassessment if the finals land
   in Branch C. The operator story therefore stands only as a *within-QD*
   result, which makes closing the QD-vs-classic gap (Fix B) load-bearing.
2. **Regime-sensitivity (F4).** Thought/QD search is competitive on
   under-determined/spec-exact problems, weaker on PPA-margin ones — with
   a mechanism. Explains the conference result instead of apologizing.
3. **Deficit localization (F7).** The loss is ~3 intrinsic-limitation
   problems, not diffuse incompetence; 58–62% of loss in 3/13.
4. **Validity vs. quality (F6).** Failure feedback lifts pass-rate, not
   peak quality → the bottleneck is archive/selection, not the operator.

Reframed thesis: *"When does quality-diverse, thought-level structure help
LLM-driven RTL search, and when does it not — characterized rigorously,
with operator simplification as a within-QD no-cost result (parity, F2)."*

## Reviewer-muster verdict (candid)

- **Passes conditionally.** TCAD accepts a rigorous characterization + a
  clean simplification result *if framed as such from the title down* —
  not if dressed as "we win" so Reviewer 2 finds the −0.10 in a table.
  The pre-registration, paired stats, disclosed proxies, and M1–M7 rigor
  are themselves selling points.
- **The live risk.** The *diversity* contribution (criticism #5) currently
  has no demonstrated value. If the bake-off finds no profile that helps
  and RealBench shows nothing, the diversity pitch is "implemented and
  characterized where it doesn't help" — defensible but thin.

## The storyline-deciding experiment (highest strategic leverage)

From the ruminations' own RealBench rationale: **diversity and Pareto
structure plausibly only pay off on larger designs with real
architectural design space** — which is *why the small-benchmark
criticism mattered in the first place.* Every loss so far is on small
RTLLM/VerilogEval problems where F7 says there is no room to maneuver.
**We have not yet run QD-vs-classic on RealBench-scale designs.** If QD
helps there, criticisms #4 and #5 resolve *together* into a positive
headline: "quality-diversity pays off at the design scale where it
matters — the regime the conference benchmarks were too small to expose."
That converts Branch C → A/B.

→ Elevate the RealBench QD-vs-classic comparison from an integration
checkbox to the **storyline-deciding experiment** (tracked in the plan /
dashboard, not left implicit in P3).

**Feasibility — RESOLVED 2026-06-13 (M8).** Initial blocker: only 5/55
validated RealBench tasks were marked `supports_synthesis`, and the 5 are
small (aes sboxes, crc) — the large e203 designs that the hypothesis
needs were excluded. BUT this is a false negative: the marking is the
conservative `supports_synthesis = not dependencies and not support_files`
heuristic, and a direct yosys probe synthesizes the large e203 modules
cleanly with their support files (alu_bjp 67, branchslv 587, alu_dpath
2143 cells; 0 errors). So the storyline-decider IS feasible. **Unlock
(scope decision):** relax the manifest heuristic, thread support/aux
files into `SynthesisEvaluator.evaluate` (single-file today — mirror the
verilator harness fix), and re-validate the full yosys+OpenROAD+descriptor
PPA flow on 2-3 large modules. The yosys step (the hardest unknown) is
already confirmed; OpenROAD floorplan + descriptor extraction on large
designs is the remaining validation. This is the highest-leverage
engineering investment for the storyline.

**Synthesis feasibility — CLOSED 2026-06-14 (M10/M11, F16).** The whole
harness path is now validated end-to-end: the golden e203_exu_decode
(53 KB, largest dependency-complete module) passes the full runtime
`evaluate_candidate` (pre-synth functional → yosys+OpenROAD PPA →
post-synth check → BD-trio descriptors). The four eval-wiring gaps
(top-module resolution, post-synth include/defines, post-synth parser,
verilator vcd-probe) are fixed. So the *tooling* can run the
storyline-decider. The engineering investment paid off.

**BUT a NEW, harder blocker emerged — LLM CAPABILITY (F18, 2026-06-14).**
The storyline-decider needs the LLM to produce *functionally-valid
candidates* on large modules, and it cannot. A bounded capability smoke
(gpt-oss-120b, 24 attempts) on decode yielded **0 valid** — the model
emits incomplete (~half-size), syntactically-broken decoders. This
reframes the feasibility question entirely: synthesis feasibility was the
*easy* blocker; capability is the *binding* one. **The squeeze:** the
designs big enough to exhibit QD's hypothesized architectural-room
advantage are too big for the model to implement; the dependency-complete
modules it might implement (≤14 KB) are in the same small-design regime
where QD already loses (F1/F15).

**RESOLVED — win-path does NOT deliver a win (F19/F20, 2026-06-14).**
Two artifacts had to be removed before a fair read: (1) candidates dying
at preprocessing on the omitted e203_defines.v include (F19, fixed); and
(2) the parallel run spuriously failing valid candidates under 14-way
contention (M12, worked around with isolated deterministic re-eval). The
corrected, authoritative storyline-decider (isolated re-eval, classic vs
QD, 7 dependency-complete modules 4.7–53 KB): **valid candidates appear
only on the 2 smallest modules (<6 KB), classic 4 ≥ QD 2; the larger
modules (incl. decode 53 KB) get 0 valid.** QD shows more behavioral
diversity but converts it into FEWER valid candidates — diverse-but-wrong,
not closer-to-correct. So **QD does not beat classic at RealBench scale**:
the buildable modules are back in the small regime where classic already
wins (F1), and the large-design regime is LLM-infeasible. Crucially this
is a *content* result, not a null — the limiting factor at scale is the
LLM's systematic spec-comprehension, answering criticism #4 with a
RealBench-scale finding and bounding the diversity claim (#5). CAVEAT:
the smallest modules have weak coverage (alu_csrctrl 27 compared samples),
so the gradient (large→infeasible, small→classic-wins) is the robust
reading, not the precise 4-vs-2 count.

## Recommendation (updated 2026-06-14 — now evidence-decided)

1. Finish the bake-off — decides whether the diversity contribution has
   any legs at all on the small benchmarks where candidates ARE valid.
2. ~~Prioritize RealBench QD-vs-classic on the larger modules~~ —
   **DONE (F20): QD does not win.** classic 4 ≥ QD 2 valid (only on the
   smallest modules); no PPA-win. Stop spending on the win-path. Fold the
   RealBench-large result in as a *characterization* contribution: "at
   real-CPU scale,
   LLM spec-comprehension — not QD search structure — is the binding
   limit; quality-diversity cannot rescue it."
3. Write the **characterization paper** — now the evidence-decided
   conclusion, not a judgement call. The one experiment that could have
   flipped the verdict to "we win" has been run honestly and did not.
