# H9: Strict Delta Evolution

Status: `RETIRED`; independent proposal review rejected the card before
implementation, admission, or live spend. The unexecuted ladder remains below
only to preserve what was reviewed.

## Identity

- Candidate ID: H9
- Short name: strict delta evolution
- Proposed candidate class: `CORE_CORRECTION`; rejected
- Proposed paper role: `PRIMARY_ALGORITHM`; rejected

## Proposal Decision

H9 fails the natural-extension novelty gate. AlphaEvolve already places
SEARCH/REPLACE deltas inside an evolutionary code loop and includes a Verilog
hardware-optimization case. CodeEvolve explicitly supports diff-based
evolution or full-code rewrite. Enabling REvolution's existing global diff mode
is therefore a useful ablation, not a differentiated TCAD algorithm.

The premise also does not support the proposed all-offspring treatment. Of the
4,000 post-Gen0 classic offspring in the two fresh development controls, the
published negative association covers 1,900 success-origin one-parent rows.
The 1,658 fail-origin rows reverse direction: valid-PPA repairs have mean edit
ratio `0.582580` versus `0.526275` for failures, with rho `+0.060274`. The 442
C-F rows show a negative association when edit breadth is measured against the
closer parent, but they do not repair the failed-pool contradiction. No H9
config, reporter, worksheet, admission event, or model-backed run is allowed.

## Conference Weakness

- Conference component: EoH-derived RTL mutation representation.
- Exact classic paths: `data/configs/evolution_default.yaml` fixes
  `generation_mode: whole`; `src/revolution/algorithm.py` builds whole-output
  requests for every classic post-initialization EoH operator.
- Conference posture: operator intents evolve complete RTL implementations,
  but the paper does not isolate whether full regeneration is necessary or
  whether its edit breadth harms functional/PPA search.
- Evidence: the frozen classic-only premise contains 1,900 post-initialization,
  one-parent, success-origin offspring from fresh full-suite classic arms.
  Valid-PPA pass offspring have mean edit ratio `0.529609`, versus `0.621488`
  for failures; Spearman rho is `-0.250869` (`p=1.17e-28`). The association is
  negative in both seeds, every generation, all four one-parent success
  operators, and 27 of 31 reference-complete problem strata with both outcomes.
- Why it matters: broad rewrites can spend the short 8-by-5 search budget
  rediscovering unchanged RTL and increase semantic drift. This association is
  observational and does not establish that delta output improves search.

## Falsifiable Hypothesis

At the same 8-by-5 budget as fresh classic REvolution, encoding every
post-initialization EoH mutation as a strict exact RTL delta increases the
unconditional valid-PPA offspring rate in each development seed while final
HV, HV-AUC, RTL-simulation functionality, and verification-complete valid-PPA
coverage remain within their frozen noninferiority margins.

## Mechanism And Rationale

- Single mechanism: change the post-initialization mutation representation from
  complete RTL output to exact search/replace hunks against the selected parent.
- Gen0 remains whole-output in both arms. The treatment freezes
  `generation_mode=diff`, `diff_apply_policy=strict`, and
  `diff_compact_context=false`. Full diff context is required so the C-F
  operator sees both selected parents, just as it does in the whole-output arm.
  Strict mode never invokes whitespace, wildcard, similarity, fuzzy, repair,
  or whole-output fallback. The existing applier can accept an empty-search
  append, so H9 additionally rejects any accepted hunk without a nonempty,
  unique exact anchor when it replays the raw artifact against its parent.
- Hardware/CAD basis: most PPA transformations are local structural changes,
  while RTL functionality is a hard constraint. A parent-relative mutation
  representation should preserve unaffected logic without constraining the
  optimizer to a hand-written transformation library.
- Expected causal chain: exact parent-relative mutations -> lower realized edit
  breadth -> fewer semantic/syntax losses -> more valid-PPA offspring per fixed
  budget -> more useful survivor material -> noninferior or better final HV.
- Mechanism telemetry: request mode and pool, EoH operator/arity, exact replay
  or failure reason, hunk count, realized edit ratio, RTL and valid-PPA child
  status, valid-parent-to-valid-child transition, fail-parent repair, and
  success-parent score improvement relative to the best recorded parent.
- Artifact contract: the reporter joins child and parent IDs from
  `generation_log.jsonl`, joins valid-PPA scores from
  `population_ppa_details`, parses each treatment `diff.json`, sequentially
  replays every nonempty hunk against the first parent, and requires the replay
  to equal the saved child. A missing parent, score used in a score comparison,
  diff, or candidate file is an evidence failure, not a skipped row.
- Expected signature: all 40 post-Gen0 treatment requests per full-suite problem
  use diff mode; every accepted treatment delta has only nonempty unique exact
  anchors and reproduces its saved child; successful treatment descendants have
  lower realized edit breadth than fresh whole-output control; unconditional
  valid-PPA yield rises in both development seeds.
- Explicit non-goals: no edit-size threshold, contract extractor, AST, RAG,
  dependency slice, formal checker, hidden test, repair retry, fallback ladder,
  operator change, QD/Pareto archive, reward shaping, or adaptive policy.

## Novelty And Naturalness

- Closest work: SymRTLO uses RAG, AST templates, symbolic FSM reasoning, and a
  verification pipeline; LongRTL uses AST partitioning, multimodal RAG, and
  reconstruction agents; Veri-Sure combines contracts, dependency slicing,
  localized repair, temporal tracing, and formal verification. Dr. RTL learns
  reusable optimization skills; POET and COEVO change verification/objective
  and multiobjective selection behavior.
- Exact REvolution delta: isolate mutation representation inside the existing
  dual-pool, EoH-operator, UCB-guided evolutionary loop. H9 adds none of the
  structure-learning, retrieval, formal, continuous-correctness, or Pareto
  mechanisms above.
- H3 distinction: H3 remains retired. It combined a patch representation,
  machine-readable contract, locality rejection, and equivalence control. H9
  is a new one-factor card enabled by the now-measured classic premise; it has
  no contract or locality gate.
- Strongest reviewer objection: strict textual patches are generic tooling and
  already exist in the repository, so a configuration ablation alone may have
  thin novelty. Paper value requires a causal full-suite REvolution result and
  cannot rest on patching as an invention.
- Reviewed score: 9/14: continuity 2, evidence-backed need 1, hardware/CAD
  grounding 1, generality 2, mechanistic clarity 1, simplicity 2, novelty 0.
- Hard-rejection audit: fail. The novelty zero triggers the mandatory rejection
  rule, and the premise-to-treatment scope mismatch weakens causal clarity.

See `related_work.md` for the primary-source comparison.

## Minimal Implementation

- Rejected method: one existing global configuration tuple, not a new engine or
  search mode.
- Classic files that remain byte-identical:
  `src/revolution/algorithm.py` SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`;
  `data/configs/evolution_default.yaml` SHA-256
  `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b`.
- Current backend is pinned by program-manifest version 5; classic and treatment
  both use `search_mode=revolution`.
- New required runtime state: none. Existing generation mode, strict apply
  policy, and compact context are frozen rather than exposed as candidate knobs.
- Source changes made: none. The proposed reporting/configuration work was not
  admitted.
- Default diff prompts are unchanged and pinned by
  `../../shared/default_prompt_manifest.sha256`.
- Removal boundary: no runtime artifact exists. Archival removal would delete
  only this candidate record; no source or configuration rollback is needed.

## Controls

- Matched classic arm: fresh whole-output classic REvolution at every reached
  stage; historical classic results are context only.
- Mechanism control: the matched classic arm is sufficient because the frozen
  treatment differs only in mutation representation. No third arm is admitted.
- Held constant: model, prompts by operator intent, EoH operator family, UCB,
  dual pools, parent/survivor selection, scalar fitness, evaluator, generation
  count, candidate count, calls, token envelope, synthesis envelope, toolchain,
  problem order, seeds, and missing-result policy.
- Required prompt disclosure: whole and diff serialization templates differ as
  required by their output schema. Claims concern the complete mutation
  representation, not the applier in isolation. The diff schema repeats the
  first parent's RTL as `original_file`; this token overhead is disclosed and
  remains subject to the frozen resource-skew gate.
- Missing treatment units and failed diff applications count as zero outcomes;
  no complete-case promotion is allowed.
- Seed roles: smoke 42; development 1001/1002; confirmation 61001-61005;
  holdout 62001.
- Governing statistics and margins: `../../program_claims_contract_v4.md`,
  `../../baseline_contract.md`, and `../../shared/program_manifest_v5.yaml`.

## Validation Ladder

This ladder was never frozen or executed and carries no result.

### Technical Smoke

- Designs: `Prob002_adder_16bit`, `Prob025_sequence_detector`, and
  `Prob043_RAM`.
- Budget: seed 42, population 8, one post-initialization generation, exactly 48
  candidates and at most 300 calls per arm. Use the frozen pair-equal token,
  synthesis, and 161-second wall envelopes.
- Pass only if both arms complete all units and exact candidate budgets; all 24
  post-initialization treatment requests use strict diff mode; every accepted
  treatment delta passes exact artifact replay; at least one treatment delta is
  accepted; reporter and accounting artifacts reproduce. This is execution
  evidence, not positive performance evidence.
- Retire on wrong mode/operator, fallback use, missing unit, zero exact applies,
  accepted append/non-unique anchor, resource stop, code-review failure, or
  infrastructure-independent crash.

### Wave-2 Screen Omission

- The representative probe is omitted under claims-contract revision 4.
- The frozen candidate worksheet must contain exactly smoke classic/treatment
  and full-suite classic/treatment at seeds 1001 and 1002. No revision, rerun,
  or hidden screen is budgeted.

### Full-Suite Probe

- Suite: frozen 50-task RTLLM development manifest; 46 reference-complete tasks
  are the PPA headline.
- Budget: seeds 1001 and 1002, population 8, five post-initialization
  generations, exactly 2,400 candidates and at most 5,000 calls per arm.
- Benefit endpoint: unconditional valid-PPA offspring count among all fixed
  2,000 post-Gen0 offspring per arm and seed. Failed diff/format, syntax,
  functionality, synthesis, post-synthesis, and PPA outcomes contribute zero.
  Treatment-minus-classic must be strictly positive in each seed.
- `VIABLE`: the benefit endpoint passes in both seeds; pooled final-HV delta is
  at least `-0.0050`; pooled HV-AUC delta is at least `-0.0036`; valid-PPA46,
  RTL-functionality46, and RTL-functionality50 deficits are at most one design
  independently in each seed; mechanism and resource gates pass.
- Resource disclosure: report candidates, calls, tokens, synthesis starts, wall
  time, and classic/treatment relative skew. The frozen 10% auxiliary-resource
  skew rule and every arm/cumulative ceiling apply.
- `RETIRED`: absent mechanism signature, no benefit in either seed, any
  noninferiority failure, shared catastrophic stop, resource/process failure,
  or evidence audit failure after the complete probe.

### Confirmation And Holdout

- Only a nominated strongest candidate advances.
- Five-seed confirmation requires final mean HV46 strictly above fresh matched
  classic, no material HV-AUC or per-seed coverage regression, positive pooled
  valid-PPA offspring-yield delta, exact strict-delta activation, paired
  uncertainty/W/L/T, and complete resource accounting.
- Holdout: one frozen repository-evidence-disjoint CVDP functionality run at
  seed 62001 after method freeze; it carries no reference-PPA claim.
- `PAPER_CANDIDATE`: every algorithmic gate in claims-contract revision 4
  passes. Yield, token savings, edit breadth, or HV-AUC cannot rescue a final-HV
  loss.

## Risks And Interpretation

- Expected failures: exact anchors fail often; localized output blocks useful
  architectural rewrites; C-F patches against one target lose fusion content;
  or lower edit breadth raises validity without improving final Pareto quality.
- Falsification: strict deltas activate and reduce edit breadth but do not
  improve valid-PPA offspring yield in both seeds, or yield improves while a
  frozen HV/coverage surface regresses.
- Allowed positive claim: strict parent-relative mutation improves the stated
  REvolution yield and PPA/functionality surfaces under the frozen model,
  budget, suite, and seeds.
- Forbidden claim: patching, local RTL rewriting, semantic preservation, formal
  correctness, or general superiority was invented or proven universally.
- Negative value: separates broad-edit association from causation and shows
  whether whole-output regeneration is necessary for useful architectural
  exploration at this budget.

## Review Dispositions

| Review | Reviewer/artifact | Finding | Disposition |
| --- | --- | --- | --- |
| Conference-method | `../../conference_method_audit.md`; `../../shared/edit_breadth_premise/README.md` | The selected success-origin premise is real but covers only 1,900/4,000 proposed offspring; fail-origin evidence reverses. | `REJECT` |
| TCAD novelty | `../../reviews/20260721_h9_novelty_review.md`; `related_work.md` | AlphaEvolve and CodeEvolve occupy global diff-based evolutionary generation. | `REJECT` |
| Hardware/EDA methodology | `../../reviews/20260721_h9_methodology_review.md` | Compact C-F context and accepted empty-search appends contradicted the original one-factor/exact definition. | `REJECT` |
| Statistics/reproducibility | `../../reviews/20260721_h9_methodology_review.md` | Exact replay was recoverable, but no worksheet or terminal reporter was frozen before rejection. | `NOT_REACHED` |
| External review | `../../reviews/20260721_h9_claude_timeout.md` | The 600-second read-only command returned no review. | `UNAVAILABLE` |
| Code simplicity | `implementation_history.md` | No implementation was made; role-conditioned repair would require a new reviewed card and clean isolation boundary. | `NOT_REACHED` |
