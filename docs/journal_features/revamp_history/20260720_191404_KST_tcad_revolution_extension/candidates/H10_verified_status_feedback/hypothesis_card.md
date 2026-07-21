# H10: Verified Terminal-Status Feedback

Status: `PROPOSED`; the mechanism passed preliminary scientific, evidence, and
implementation review. Exact-card closure, the immutable six-arm worksheet,
and external review remain open before `READY`.

## Identity

- Candidate ID: H10
- Short name: verified terminal-status feedback
- Candidate class: `CORE_CORRECTION`
- Intended paper role: `RELIABILITY`

## Conference Weakness

- Conference component: the `(Thought, Code, Feedback)` individual
  representation and dual Fail/Success populations.
- Exact classic paths: `src/revolution/algorithm.py:115-135` defines the typed
  terminal states; `src/revolution/algorithm.py:1356-1470` obtains critic
  feedback; `src/revolution/algorithm.py:1688-1713` serializes a parent without
  its status; `src/revolution/algorithm.py:3197-3208` uses status to form the
  pools.
- Conference posture: evaluator feedback guides later evolution, while binary
  functionality separates repair from PPA search.
- Limitation: classic retains the objective terminal status internally but
  exposes only the critic's free-form `analysis` to the offspring-generating
  LLM. The critic score and justification are archived, not consumed.
- Fresh classic-only premise: among 4,800 candidates from the two H5 matched
  control roots, 687/2,309 clear format/syntax/functionality failures disagree
  with the critic score contract. This includes 215 functional failures labeled
  score 10. Success disagrees in only 4/2,067 cases. The exact rows and command
  are in `../../shared/verified_status_feedback_premise/README.md`.
- Interpretation boundary: score disagreement proves evaluator/critic
  inconsistency, not that every consumed analysis is wrong or that consistency
  causes repair. The selected-parent outcome join is observational and
  confounded.

## Falsifiable Hypothesis

At the same 8-by-5 budget as fresh classic REvolution, exposing each failed
parent's authoritative terminal status alongside unchanged critic analysis
increases the number of RTLLM designs producing a fail-origin valid-PPA repair
in each development seed while final HV, HV-AUC, RTL-simulation functionality,
and verification-complete valid-PPA coverage remain within their frozen
noninferiority margins.

## Mechanism And Rationale

- Single mechanism: after classic evaluation and critic generation complete,
  prepend exactly this line and one newline to every failed candidate's
  consumed feedback:

  ```text
  Verified terminal status: <status>
  ```

- `<status>` is the exact existing terminal discriminant. The six failure
  values are `failed_format`, `failed_diff`, `failed_syntax`,
  `failed_functionality`, `failed_synthesis`, and
  `failed_synthesis_functionality`.
- Successful feedback remains byte-identical to classic. The original failed
  candidate critic analysis follows the prefix byte-for-byte. The archived
  critic artifact remains unchanged.
- Hardware/CAD basis: simulation, compilation, synthesis, and gate-level
  simulation provide authoritative categorical states. Evolution should not
  discard that state while retaining a stochastic interpretation of it.
- Expected causal chain: preserved terminal state -> fewer misleading
  failed-parent contexts -> repairs on more distinct designs -> broader useful
  valid-PPA material -> noninferior final PPA search.
- Primary endpoint per arm and seed:

  ```text
  valid_ppa_repair_breadth50 = number of distinct RTLLM problems with at least
  one Gen1-Gen5 child where origin_pool == fail_pool and status == success
  ```

- Benefit requires leave-one-problem-cluster-out treatment-minus-classic
  breadth strictly above zero in both seeds 1001 and 1002. For binary problem
  rows, this is the minimum concentration guard and implies an unremoved delta
  of at least `+2` per seed. This design-level endpoint prevents a concentrated
  H5-style event gain from satisfying H10. In the prior H5 suite, direct
  valid-PPA events rose 36 to 41 and 37 to 40 while repaired-design breadth
  fell 14 to 12 and 13 to 12; `H10` therefore does not reuse event count as its
  benefit gate.
- Resolution warning: the fresh classic controls have breadth 14/50 and 13/50;
  the older five classic seeds span 11, 13, 17, 14, and 11. A `+1/+1`
  development result is descriptive only, not `VIABLE` or a material,
  statistically resolved reliability improvement.
- Endpoint selection disclosure: H10 mechanism selection and the complete
  RTLLM-50 membership use classic-only evidence. Design breadth is a
  prospective H10 endpoint informed by the already closed H5 concentration
  failure and the Wave-2 process correction; no H10 outcome exists. The `+2`
  minimum comes from one-cluster deletion, not H5's observed effect size.
- The endpoint counts designs that produce a fail-origin successful child. It
  does not mean the design was previously unsolved, and it is not final
  valid-PPA coverage.
- Secondary mechanism evidence: unconditional fail-origin valid-PPA repair
  count among all fixed 2,000 post-Gen0 offspring per arm and seed,
  RTL-simulation repair breadth, stage transitions, and problem concentration.
- Activation telemetry: one per-problem UTF-8
  `verified_status_feedback_telemetry.jsonl`, truncated deterministically at
  Gen0 and appended thereafter. It contains exactly one record per evaluated
  candidate: 16 per smoke problem and 48 per full-suite problem. Each record
  contains generation, candidate ID, terminal status, prefix flag, UTF-8 byte
  count and SHA-256 for original critic analysis and consumed feedback, and
  SHA-256 of the untouched `code_feedback.txt` artifact.
- Expected signature: every failed candidate receives exactly one canonical
  line; no successful candidate receives it; selected failed-parent prompt
  payloads contain it; critic artifacts and successful feedback remain
  unchanged.
- Explicit non-goals: no raw evaluator log, diagnostic summarizer, critic-score
  gate, mismatch trigger, stage weighting, retention rule, reward shaping,
  operator or routing change, prompt taxonomy, fallback, threshold, QD/Pareto
  behavior, or task-specific rule.

## Novelty And Naturalness

- Closest work: AutoChip and RTLFixer use compiler/simulator feedback for RTL
  repair; Reflexion retains verbal environment feedback; COEVO supplies
  correctness and synthesis diagnoses to evolutionary operators;
  Verilog-Evolve uses executable feedback during versioned RTL refinement.
- Exact REvolution delta: preserve the existing terminal verifier type inside
  classic REvolution parent memory while leaving its critic analysis, dual
  pools, EoH operators, UCB, scalar selection, and evaluator unchanged.
- Repository collision: the retired unified single-thought operator serializes
  a coarse succeeded/failed label, but it removes classic feedback and the EoH
  operator family. H10 instead tests typed status retention on the accepted
  classic substrate and does not revive that operator.
- Strongest reviewer objection: the failed-pool context already implies
  failure, and contradictory prose may dominate one short prefix. A null result
  would reject only this minimal invariant, not verifier-grounded feedback in
  general.
- Reviewed natural-extension score: `2/2/2/2/2/2/1 = 13/14` for conference
  continuity, evidence-backed need, hardware/CAD grounding, generality,
  mechanistic clarity, simplicity, and novelty/paper value.
- Hard-rejection audit: provisionally passes. The method is a narrow supporting
  reliability contribution, not a new feedback paradigm or primary TCAD
  algorithm by itself.

See `related_work.md` and the preliminary reviews in `../../reviews/`.

## Minimal Implementation

- Experimental mode: `search_mode=revolution_verified_status_feedback`.
- Experimental module: one `VerifiedStatusFeedbackEngine(EoHEngine)` subclass
  that overrides only `_evaluate_candidates`, calls `super`, and transforms the
  consumed feedback after the critic artifact is saved.
- Exhaustive state handling: `success` returns unchanged; all six failures
  receive the line; `new` asserts impossible; an unknown status reaches
  `assert_never`.
- Classic files that remain byte-identical:
  `src/revolution/algorithm.py` SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`;
  `data/configs/evolution_default.yaml` SHA-256
  `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b`;
  and every default prompt pinned by
  `../../shared/default_prompt_manifest.sha256`.
- Backend contract freezes dual pools, EoH strategies, classic success
  operators, UCB, whole generation, code individuals, no repair wrapper,
  strict output format, `prompt_profile=default`, `prompt_root=None`, and
  strict-ablation evaluation. The engine asserts that the resolved prompt root
  is the repository `data/prompts`; paired raw configs record no override.
- Shared backend and CLI files necessarily register the new mode. Tests require
  classic `search_mode=revolution` to continue dispatching exactly
  `EoHEngine`; byte identity applies to the classic engine, default config, and
  default prompt corpus rather than shared dispatch code.
- New runtime state: none beyond one fixed search-mode discriminant and one
  append-only telemetry file.
- Public knobs: none. Prefix text and treatment scope are constants, not
  configuration.
- Expected source surface: one experimental package, backend dispatch,
  CLI-mode validation, focused tests, and a candidate-local terminal reporter.
- Removal boundary: delete the experimental engine package; backend
  import/constant/Literal/validation/dispatch branch; CLI choice and contract
  validation; candidate reporter, tests, configs, manifests, and telemetry.
  Classic engine/config/prompt files require no rollback.

## Controls

- Matched control: a fresh classic arm at every reached stage. Historical and
  H5 control outputs are premise evidence only.
- Mechanism control: the matched classic arm differs only by visibility of the
  terminal status line; no third arm is required.
- Held constant: model, critic calls and artifacts, default prompts, EoH
  operators, UCB, pools, parent/survivor selection, scalar fitness, evaluator,
  candidate count, generation count, token envelope, synthesis envelope,
  problem order, seeds, and missing-result policy.
- Prompt disclosure: default prompt files remain byte-identical, but treatment
  parent payload instances contain the registered line. The claim concerns
  terminal-state visibility, not an unchanged prompt instance.
- Missing treatment units count as zero outcomes and method failures.
- Seed roles: smoke 42; development 1001/1002; confirmation 61001-61005;
  holdout 62001.
- Governing contracts: `../../program_claims_contract_v4.md`,
  `../../baseline_contract.md`, `../../shared/program_manifest_v5.yaml`, and
  `../../wave2_methodology_addendum.md`.

## Validation Ladder

### Technical Smoke

- Designs: `Prob002_adder_16bit`, `Prob025_sequence_detector`, and
  `Prob043_RAM`.
- Budget: seed 42, population 8, one post-initialization generation, exactly 48
  candidates and at most 300 calls per arm. Pair-equal caps are 265,153 tokens,
  35 synthesis starts, and 161 endpoint seconds per arm.
- Pass only if both arms complete all three units; candidate/call/resource
  accounting reconciles; telemetry has exactly 16 rows per problem; at least
  one treatment Gen0 failure is prefixed; at least one Gen1 child has
  `origin_pool=fail_pool`; and that child's sole parent ID joins to a prefixed
  Gen0 failure. All treatment failures and no successes satisfy the exact
  hash/byte invariant, every recorded critic-artifact hash matches
  `code_feedback.txt`, and the terminal reporter reproduces.
- Stop on missing units, wrong status handling, duplicate prefix, altered critic
  artifact, changed successful feedback, mechanism absence, resource stop, or
  infrastructure-independent crash. Smoke carries no positive performance
  evidence.

### Wave-2 Screen Omission

- The representative probe is omitted under claims-contract revision 4.
- The immutable worksheet must contain exactly smoke classic/treatment and
  full-suite classic/treatment at seeds 1001 and 1002.

### Full-Suite Probe

- Suite: frozen 50-task RTLLM development manifest; the 46 reference-complete
  tasks remain the PPA headline.
- Budget: seeds 1001 and 1002, population 8, five post-initialization
  generations, exactly 2,400 candidates and at most 5,000 calls per arm.
- `VIABLE`: leave-one-problem-out `valid_ppa_repair_breadth50` delta is
  strictly positive in each seed; pooled final-HV delta is at least `-0.0050`;
  pooled HV-AUC delta is at least `-0.0036`; valid-PPA46,
  RTL-functionality46, and
  RTL-functionality50 deficits are at most one design independently in each
  seed; mechanism, evidence, and resource gates pass.
- Resource caps: 16,291,915 tokens, 1,407 synthesis starts, and 5,125 seconds
  for each seed-1001 arm; 16,146,270 tokens, 1,415 synthesis starts, and 4,985
  seconds for each seed-1002 arm.
- Reporter contract: require generations 0-5 and eight unique candidates per
  generation for each complete unit. Emit exactly 200 arm/seed/problem rows
  over the fixed all-50 denominator and reconcile exactly 2,400 total and 2,000
  post-Gen0 candidates per arm/seed. Count only Gen1-Gen5 children with
  `origin_pool=fail_pool`, `status=success`, and `ppa_success=true`; join the
  sole parent and assert its earlier status was not `success`; count each
  problem at most once. Eligibility never conditions on failure availability,
  activation, critic score, parent stage, or synthesis success. Verify unique
  candidate and parent IDs.
- A missing or malformed treatment unit retains its problem row as zero, fails
  exact candidate accounting, and retires H10. A missing classic unit caused by
  named infrastructure follows the governing required-rerun rule; because the
  frozen worksheet admits no rerun, H10 remains `BLOCKED` pending an
  outcome-blind reviewed worksheet revision. A genuine complete classic method
  failure is a zero breadth row. Any other malformed classic evidence retires
  H10. Historical controls are never substituted.
- Retain one paired repaired/not-repaired indicator per problem and seed, then
  report per-seed breadth/delta, W/L/T, seeded problem-cluster uncertainty,
  gain/loss problem IDs, leave-one-problem-out deltas, event counts,
  generation/operator concentration, missing/exclusion states, the fresh
  classic breadth, historical seed sensitivity, and every noninferiority and
  resource gate. The candidate reporter imports the shared gate implementation.
- Reporter tests cover duplicate repairs on one design, success-origin and Gen0
  exclusion, inconsistent `status`/`ppa_success`, a missing treatment unit, and
  a gain in only one seed. They also distinguish raw `+1` from leave-one-out
  `+2`, classic infrastructure absence from a complete zero, exact 200-row
  output, and all shared per-seed gate translations.
- `RETIRED`: any leave-one-problem-out breadth delta is `<= 0` in either
  required seed, any noninferiority surface fails, gains are fabricated by
  missing treatment units, the mechanism or reporter fails audit, or any
  candidate/resource/process ceiling fails. Gains are never netted across
  seeds.

### Confirmation And Holdout

- H10 can become `VIABLE` from the two-seed suite. As a supporting reliability
  candidate, it becomes `PAPER_CANDIDATE` only if confirmation improves breadth
  in at least four of five seeds with no negative seed and a problem-clustered
  95% interval whose lower bound is above zero; preserves final HV within its
  margin; passes the holdout and adversarial audit; and is paired with a
  separately confirmed algorithmic contribution.
- Confirmation uses five fresh matched seeds 61001-61005 after method freeze.
- Holdout uses the frozen repository-evidence-disjoint CVDP functionality set
  at seed 62001 and carries no reference-PPA claim. Every unit must complete,
  treatment RTL-functionality coverage may trail classic by at most one design,
  treatment RTL-repair breadth must be at least classic, the H10 mechanism must
  activate, and resource gates must pass.
- Active holdout composition is fixed: `run_backend.py` selects
  `CVDPEvaluator` as the candidate-evaluator service while
  `RevolutionBackend` still dispatches `VerifiedStatusFeedbackEngine`. The
  legacy sibling `CVDPEngine` in `algorithm.py` is not used. A focused backend
  test must prove this dispatch before confirmation; no post-development engine
  composition decision is permitted.

## Risks And Interpretation

- Expected failure: one categorical line is redundant with the Fail-pool
  context or is outweighed by contradictory critic prose.
- Falsification: exact activation occurs but leave-one-problem-out breadth is
  not positive in both seeds, or it passes while any frozen
  PPA/functionality/resource surface fails.
- Allowed positive claim: preserving REvolution's authoritative terminal
  failure type alongside unchanged critic analysis produced fail-origin
  verification-complete valid-PPA children on more distinct designs than
  matched classic in each tested seed while frozen surfaces remained inside
  their margins. Raw `+1/+1` without leave-one-problem-out robustness is
  descriptive only and cannot make H10 `VIABLE`.
- Forbidden claim: H10 invents EDA feedback, corrects critic reasoning,
  improves every failure stage, saves inference cost, or independently provides
  the journal's primary algorithmic contribution.
- Negative value: determines whether the smallest lossless state invariant is
  sufficient before considering more invasive feedback representations.

## Review Dispositions

| Review | Reviewer/artifact | Finding | Disposition |
| --- | --- | --- | --- |
| Conference-method | `../../conference_method_audit.md`; premise report | Typed failure state is used for pools but omitted from classic parent memory. | `ACCEPT_PRELIMINARY` |
| TCAD novelty | `../../reviews/20260721_h10_scientific_review.md` | Exact delta is narrow and supports reliability only; 13/14. | `ACCEPT_PRELIMINARY` |
| Evidence | `../../reviews/20260721_h10_evidence_review.md` | Counts reproduce; outcome association is not causal and cannot be the premise. | `ACCEPT_PRELIMINARY` |
| Code simplicity | `../../reviews/20260721_h10_code_boundary_review.md` | One post-super subclass is clean; raw-payload alternatives are blocked. | `ACCEPT_PRELIMINARY` |
| Exact-card closure | Pending independent rereview | Endpoint, worksheet, and reporter table are not yet frozen. | `PENDING` |
| External review | Pending read-only Claude review | No exact-card verdict yet. | `PENDING` |
