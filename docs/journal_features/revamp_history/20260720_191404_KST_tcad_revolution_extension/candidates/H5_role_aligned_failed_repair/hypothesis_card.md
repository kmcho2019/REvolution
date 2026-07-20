# H5: M-F-Only Failed-Pool Routing

Status: `READY`; hypothesis, estimand, schema, and pre-implementation reviews
froze before treatment implementation.

## Identity

- Candidate ID: H5
- Short name: M-F-only failed-pool routing
- Candidate class: `CORE_CORRECTION`
- Intended paper role: `PRIMARY_ALGORITHM`

## Conference Weakness

- Conference component: dual Fail/Success populations and EoH prompt strategy
  allocation.
- Exact classic code/config path: `src/revolution/algorithm.py:550` initializes
  all five one-parent operators for failed candidates;
  `src/revolution/algorithm.py:3820` selects among them.
- Conference claim: the dual populations apply specialized repair and PPA
  improvement strategies.
- Evidence: classic routes failed candidates through dedicated correction M-F,
  mixed correctness/PPA improvement M-I, and broader M-S/M-E/M-R
  transformations. Every operator receives stored parent feedback. In 804
  classic failed-parent requests, M-F had 26.1% RTL-simulation functional and
  7.1% valid-PPA yield, versus 17.0-21.0% and 2.7-5.1% for the other operators.
  Equal-weight, problem-clustered
  differences versus the alternatives are `+0.0643` RTL-simulation functional,
  95% CI
  `[+0.0179, +0.1199]`, and `+0.0270` valid PPA, CI
  `[-0.0126, +0.0781]`. These are descriptive, not causal rates.
- Why leaving it unchanged matters: four fifths of classic failed-parent
  requests are spent outside the dedicated M-F correction intent, weakening the
  stated dual-population specialization at this short search horizon.

## Falsifiable Hypothesis

At the same 8-by-5 budget as classic REvolution, restricting failed-parent
offspring to the existing EoH M-F repair operator increases unconditional
fail-origin valid-PPA repairs per fixed 48-candidate problem budget in each
development seed without material valid-PPA coverage, final-HV, HV-AUC, or
RTL-simulation functionality regression, while successful-parent evolution
remains byte-for-byte classic.

## Mechanism And Rationale

- Single mechanism: replace the failed pool's five-operator choice with the
  existing dedicated M-F correction operator.
- Basis: feasibility restoration is a distinct search role from optimization;
  M-F labels its task `fix_failed_attempt` and requests a corrected solution.
  This is an intent-routing claim, not a claim that other prompts lack feedback.
- Existing-policy check: classic UCB gives M-F 20.3% of all failed-parent
  requests. Its share peaks at 22.2% in generation 2 and returns to 20.4% by
  generation 5 while the policy approaches uniform. Classic does not already
  converge to the proposed static role constraint.
- Expected causal chain: more explicit repair requests -> more failed-to-valid
  transitions -> a larger success pool -> more useful PPA search -> higher HV.
- Telemetry signature: every failed-parent request is M-F; lineage records name
  parent IDs, origin pool, operator, parent/child verification stage, and exact
  RTL-simulation, synthesis, post-synthesis, and PPA booleans. Log pre/post
  selection pool sizes. Report conditional repair yield diagnostically.
  The mechanism estimand is unconditional fail-origin valid-PPA repairs per
  48-candidate problem budget. Success-side operator allocation remains classic
  UCB. No descendant-level HV credit is assigned.
- Non-goals: no new prompt, partial-correctness score, verification-stage rank,
  retained failed lineage, reward shaping, allocation floor, QD/Pareto archive,
  descriptor, or single-thought operator.

## Novelty And Naturalness

- Closest work: COEVO uses fine-grained correctness, category-specific rewards,
  and an annealed correctness gate; EoH supplies the generic operator family.
- REvolution-specific delta: complete the existing binary dual-population
  specialization with static role-constrained failed-parent operators while
  preserving classic success search and reward.
- Strongest objection: selecting the obviously named repair prompt may be an
  ablation or engineering correction rather than sufficient journal novelty.
- Provisional score: 11/14: continuity 2, need 2, hardware/CAD grounding 1,
  generality 2, mechanistic clarity 2, simplicity 1, novelty/paper value 1.
- Hard-rejection audit: none provisionally; novelty and implementation
  isolation require independent closure.

## Minimal Implementation

- Experimental mode: `revolution_failed_parent_repair` with one isolated
  `EoHEngine` subclass.
- Classic files byte-identical: `src/revolution/algorithm.py`, all default EoH
  prompts, and `data/configs/evolution_default.yaml`.
- New state: none after initialization; `fail_strats == ["M-F"]` and the fail
  statistics map has exactly one entry.
- Public knobs: none. The search-mode discriminant selects one fixed method.
- Expected surface: one small engine module, one backend dispatch branch, one
  CLI choice, telemetry-only logger fields, focused tests, and one experiment
  manifest.
- Removal: delete the package, dispatch value, tests, and candidate configs.

Changing classic to add a general fail-operator-set option is forbidden. Copying
`evolve_one_generation` is also forbidden.

## Controls

- Matched control: frozen classic REvolution.
- Mechanism control: the matched classic arm is the one-factor control; an
  operator-contract audit verifies five fail operators in control and only M-F
  in treatment. No extra null arm is justified.
- Frozen factors: model, prompts, success operators, UCB, parent/survivor
  selection, evaluator, candidate order, candidate budget, synthesis budget,
  and missing-result policy.
- Seed roles: smoke 42; development 1001 and 1002; confirmation 61001-61005;
  holdout 62001.
- Statistics and margins: `program_claims_contract.md` revision 3 and
  `baseline_contract.md`.
- Telemetry: frozen `telemetry_schema.md`; unknown stage combinations fail.

## Validation Ladder

### Technical Smoke

- Designs: frozen three-design smoke manifest.
- Budget: seed 42, population 8, one generation, matched classic and treatment.
- Pass: complete artifacts, exact budget, correct operator contract, and no
  infrastructure failure. It is not performance evidence.

### Representative Probe

- Designs: eight tasks in `shared/representative_selection.csv`, hash
  `44bfacd9ad9969b7ec890892e5d28be3df3904b19ec734f4b8cc9505f50cc298`.
- Budget: seeds 1001 and 1002, population 8, five generations.
- Metrics: final HV, HV-AUC, RTL-simulation functionality, valid PPA,
  failed-parent RTL-simulation and valid-PPA yield, first valid generation,
  unconditional fail-origin valid-PPA repairs per 48-candidate budget,
  pre/post pool sizes, operator counts, calls, tokens, synthesis attempts, and
  runtime.
- Retirement: only invalid mechanism, budget mismatch, code-review failure, or
  infrastructure failure. This saturated classic-valid set cannot test coverage,
  and the full-suite catastrophic gate does not apply at representative scale.

### Full-Suite Probe

- Suite: frozen 50-task RTLLM manifest; 46 reference-complete headlines.
- Budget: seeds 1001 and 1002, population 8, five generations.
- Preregistered development benefit: the paired mean unconditional fail-origin
  valid-PPA repairs per 48-candidate problem budget is above classic in each
  development seed. Conditional yield is diagnostic because treatment changes
  the number and difficulty of failed-parent requests.
- `VIABLE`: the preregistered repair-count benefit occurs in both development
  seeds and valid-PPA coverage, final HV, HV-AUC, and RTL-simulation
  functionality remain within frozen noninferiority margins. Development
  coverage is screening evidence, not a confirmed improvement claim.
- `RETIRED`: shared catastrophic gate, absent telemetry signature, or no
  preregistered benefit after the complete probe.

### Confirmation And Holdout

- Confirmation: final mean HV46 strictly above fresh matched classic at seeds
  61001-61005, no material coverage/AUC regression, exact M-F-only activation,
  and a positive paired mean unconditional repair-count delta over all fresh
  confirmation problem-seed units. Report intervals and per-seed sensitivity.
- Holdout: one frozen CVDP RTL-simulation functionality run at seed 62001 after
  code freeze.
- `PAPER_CANDIDATE`: all algorithmic gates in the claims contract pass. AUC or
  repair yield cannot rescue a final-HV loss.

## Risks And Interpretation

- Failure modes: M-F loses exploratory diversity, proportional allocation gives
  too few failed-parent requests, or increased repair yield produces low-quality
  successes that consume population capacity.
- Falsification: the treatment activates correctly but does not improve repair
  yield, or repair yield rises without success-pool/HV consequences.
- Allowed positive claim: static M-F-only failed-pool routing improves the
  stated metrics on the tested frozen suite under equal budget.
- Coverage improvement may be claimed only if confirmation coverage is also
  positive; noninferiority supports preservation wording only.
- Negative value: it would show that generic failed-parent mutation diversity,
  not prompt-role alignment, is important at this budget.

## Review Dispositions

| Review | Reviewer/artifact | Finding | Disposition |
| --- | --- | --- | --- |
| Conference-method | `conference_method_audit.md` | Dual-pool operator semantics are unproven. | ACCEPT |
| TCAD novelty | `../../reviews/20260720_claude_candidate_ranking_closure.md` | Modest role-alignment correction has no blocking COEVO collision or post-hoc gate; novelty remains thin. | ACCEPT |
| Hardware/EDA methodology | `../../reviews/20260720_internal_h5_hardware_methodology.md` | Prompt role, unconditional estimand, stage/pool schema, confirmation, and lineage-credit corrections closed. | ACCEPT |
| Statistics/reproducibility | Frozen contracts | Exact gates and roles are fixed. | ACCEPT |
| Classic-policy premise | `component_evidence_audit.md`; report commit `7106c4dfb2` | UCB does not sustain an M-F preference; treatment remains causally distinct. | ACCEPT |
| Code simplicity | `../../reviews/20260720_internal_h5_architecture.md` | Subclass can narrow two fields without copying generation logic. | ACCEPT_PENDING_DIFF |
