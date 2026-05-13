# Thought-Only Individuals And k-Code Evaluation

## Goal Statement For Delegation

Implement Feature 06 as the thought-only journal representation and evaluation
layer. Read this document first and keep the implementation narrow: the
evolvable individual is a detailed thought/design strategy, and each thought is
evaluated by generating `k=4` independent RTL code samples by default. The
existing candidate evaluator remains the workhorse for every code sample. The
new layer only orchestrates thought generation, code-sample generation,
optional bounded sample-local repair, aggregation, artifact writing, and
archive/fail-pool routing at thought granularity.

Feature 05 has already merged the operator layer:
`qd_operator_kind = eoh_strategies | single_thought_operator`. Feature 06 must
work above that layer. The journal target uses `single_thought_operator`, but
the representation/evaluation code should also support an EoH compatibility
mode so the same thought-only aggregation can be ablated against the current
prompting path.

The feature passes only when the thought-only `k=4` representation completes
the full hard-subset acceptance matrix without a substantial metric regression
versus the unified no-thought-only Feature 05 control. The same matrix must also
include the EoH no-thought control and the EoH thought-only ablation so
regressions can be attributed to the operator change, the representation change,
or their interaction. For Feature 06 validation, do not exceed four
simultaneous worker slots.

## Goal

Make the thought, not one generated RTL file, the evolutionary individual. A
thought is a hardware design idea. Code is an evaluation sample drawn from that
idea. This reduces code-generation noise, avoids code anchoring, and makes
archive entries represent design concepts rather than one lucky or unlucky RTL
realization.

Feature 06 is the bridge between the Feature 05 single thought operator and the
Feature 07 adaptive re-binning work. It must preserve the archive, Pareto, and
fail-pool semantics from Features 02 through 05 while changing the unit of
evolution from code candidates to thought evaluations.

## Current State

The current runtime uses `Heuristic` objects that carry thought, code,
feedback, status, score, and artifacts together. QD archive insertion happens
per successful code candidate. This is suitable for the conference code path,
but not for the journal methodology where the paper claims to evolve
thought-level design ideas.

The journal runtime should split these concepts:

- thought individual: the evolvable design idea and parent-selection unit.
- code sample: one RTL realization generated from a thought.
- thought evaluation: aggregate result across code samples.

`src/revolution/runtime/candidate_evaluator.py` should remain the code-sample
evaluation workhorse. Do not duplicate syntax checking, simulation, synthesis,
PPA extraction, scoring, descriptor extraction, or objective extraction.

Feature 05 now owns operator selection through `qd_operator_kind`. Its merged
`single_thought_operator` emits the current `eoh_v1` `{thought, code}` shape
for code-individual runs so it can be compared against EoH before this feature
lands. Feature 06 must not reintroduce strategy-bandit routing. Instead, when
`representation.kind=thought_only`, the selected operator must produce a
thought-only `thought_spec_v1` genotype, and all `k` code samples must be
generated afterward through the same thought-conditioned code-generation path.
Do not count operator-returned code as one of the `k` samples in thought-only
mode.

Feature 07 owns KS-triggered adaptive re-binning. Feature 06 must expose recent
successful thought representatives clearly enough for Feature 07, but it must
not implement re-binning.

## Satisfactory End State

Feature 06 is complete only when all of these are true:

1. The journal QD path has a typed thought-only representation mode selected
   by config, separate from the existing code-individual default and independent
   of `qd_operator_kind`.
2. The thought-only mode generates one thought first, then generates
   `code_samples_per_thought` independent code samples from that same thought.
3. `code_samples_per_thought` defaults to `4` and must be a positive integer.
4. Thoughts have a structured enough content contract for code generation:
   they must state interface/timing intent, state/datapath structure,
   reset/edge-case behavior, and implementation constraints rather than only a
   vague high-level idea.
5. The public `population_size` setting remains a legacy code-sample
   evaluation budget. With `population_size=20` and `k=4`, the runtime
   generates five thought individuals for that generation, not twenty thoughts
   and eighty code samples.
6. Feature 06 acceptance configs use budgets divisible by `k`. The first
   implementation must fail fast on non-divisible thought-only budgets rather
   than adding partial-thought behavior.
7. Every code sample is evaluated by the existing candidate evaluator.
8. Invalid `thought_spec_v1` outputs consume the thought slot, are recorded as
   failed-format thought evaluations, are excluded from parent selection, and do
   not trigger replacement sampling.
9. Optional bounded local repair is available per code sample. Repair attempts
   are controlled by explicit caps, do not reduce the base `k` code samples,
   and are reported separately for budget-normalized metrics. Repair may use
   that sample's own syntax, simulation/testbench, synthesis, or physical/PPA
   logs, but repair logs never enter future thought-mutation parent prompts.
10. All-fail thoughts enter the fail pool as thought evaluations.
11. Partial-success and all-success thoughts choose the best successful code
   sample by scalar PPA quality as the representative.
12. Descriptor assignment uses the representative code's descriptor values in
   the first implementation.
13. Archive insertion happens once per successful thought evaluation, not once
    per successful code sample.
14. Pareto dominance remains PPA-only over the representative sample's active
    objectives.
15. `success_rate = successful_samples / k` is recorded for analysis and
    ablation, but is not used as a Pareto objective, archive replacement
    criterion, parent-selection score, or descriptor axis.
16. All code-sample outcomes and repair attempts are retained in artifacts and
    reports.
17. Prompt artifacts prove that thought mutation prompts contain parent
    thoughts only, not parent code, individual feedback, or code-level error
    logs.
18. The hard-subset acceptance run includes classic, EoH no-thought, unified
    no-thought, EoH thought-only, and unified thought-only modes in one config
    matrix, then compares them with paired quantitative gates.

## Implementation Scope

### Runtime Objects

Add small typed runtime objects for the thought-only path. Recommended names
are:

- `ThoughtIndividual`
- `CodeSample`
- `ThoughtEvaluation`

Keep the objects simple and explicit. Use required fields for data that must
exist. Use discriminated status values rather than optional piles of loosely
related fields.

`ThoughtIndividual` should represent the genotype:

- thought ID.
- structured `thought_spec_v1` JSON payload.
- optional rendered thought text path for human inspection.
- thought schema version.
- generation.
- parent thought IDs.
- parent count.
- parent source such as `archive`, `fail_pool`, or `seed`.
- `qd_operator_kind` that produced the thought, such as `eoh_strategies` or
  `single_thought_operator`.
- prompt/profile metadata needed to audit generation.

`CodeSample` should represent one phenotype realization:

- thought ID.
- sample index from `0` to `k - 1`.
- candidate/sample ID.
- artifact directory.
- generated code path.
- attempt count.
- repair attempts, when bounded repair is enabled.
- existing evaluator status.
- furthest evaluation stage reached.
- dominant failure class when no final success exists.
- functional/synthesis/PPA status.
- quality score and score components when available.
- descriptor values and active objectives when available.

`ThoughtEvaluation` should represent the aggregate archive/fail-pool unit:

- thought ID.
- `code_samples_per_thought`.
- sample IDs and statuses.
- success count.
- `success_rate`.
- aggregate status: `invalid_thought`, `all_failed`, `partial_success`, or
  `all_success`.
- repair mode and repair budget consumed.
- representative sample ID for partial/all-success thoughts.
- representative descriptor tuple.
- representative quality score.
- representative PPA metrics and active objectives.

Do not expand `Heuristic` until it becomes the thought-level genotype. It is
acceptable for `CodeSample` to wrap or reference existing `Heuristic` /
candidate artifacts while the shared evaluator still expects that shape.

### Thought Specification Contract

Thought-only mode needs a richer thought than the short rationale currently
found in many `eoh_v1` completions. The thought is the genotype, so it must be
detailed enough for a separate code-generation prompt to realize the design
without reading parent code or feedback logs.

Operator output in thought-only mode must be structured JSON with these required
fields:

```json
{
  "format": "thought_spec_v1",
  "summary": "One or two sentences naming the intended architecture.",
  "interface_contract": "Required module/interface behavior from the problem statement.",
  "timing_and_protocol": "Cycle timing, reset behavior, handshakes, pulse widths, latency, and off-by-one boundaries that the implementation must preserve.",
  "state_and_datapath_plan": "Main state registers, counters, datapath operations, combinational paths, and how outputs are derived.",
  "edge_cases": "Boundary input values, reset release, overlapping patterns, saturation, empty/full cases, or invalid/rare protocol states.",
  "ppa_intent": "Area, timing, and power choices that are safe after correctness is satisfied.",
  "implementation_constraints": "Constraints such as single DUT module only, inline helper logic, or avoiding extra helper modules unless the benchmark explicitly requires them."
}
```

Artifacts may render the same payload as `thought.txt` or markdown for human
review, but validators must read the structured JSON fields rather than parsing
free-form headings.

For `single_thought_operator`, update the thought-only prompt so the response
uses this contract. For `eoh_strategies + thought_only`, add thought-only prompt
adapters for the EoH strategy set so those responses also use this contract.
Every required field must be present and must contain a non-empty, meaningful
string. Empty strings, `unknown`, `n/a`, and equivalent non-answers fail
thought validation before code samples are generated. When a benchmark does not
specify a detail, the prompt should require an explicit justified placeholder,
such as `not specified by problem; assume single-cycle combinational behavior`
or `not applicable because the interface has no reset`. Do not fabricate
protocol details that are absent from the problem statement or model output;
state the bounded assumption or non-applicability instead.

The code-generation prompt in thought-only mode receives:

- system prompt.
- problem definition.
- one `thought_spec_v1`.
- JSON output instructions.

It must not receive:

- parent code.
- parent individual feedback.
- parent code-level logs.
- parent failure-stage summaries or failure explanations.
- other code samples from the same thought, except during sample-local repair
  for that exact sample.
- failed sibling sample code, logs, or feedback from a parent thought.

Thought mutation prompts for successful parents may include the parent thought,
coarse `evaluation_status = "succeeded"`, and a compact representative PPA
summary from the selected representative sample. Allowed PPA fields are the
existing compact success-side fields such as representative `quality_score` and
active normalized `g_A`, `g_P`, and `g_T` gains. They must not include
representative code, sample logs, failed sibling evidence, repair transcripts,
or `success_rate`.

### Generation And Evaluation Flow

The thought-only generation flow is:

1. Select thought parents from the journal parent-source policy.
2. Generate one new `thought_spec_v1` using the configured `qd_operator_kind`.
3. Validate the structured thought. If validation fails, create an
   `invalid_thought` evaluation, save validation-error artifacts, count it in
   fail accounting, exclude it from parent selection, and do not generate
   replacement thoughts or code samples.
4. Generate `k` independent code samples from the thought using the same
   thought-conditioned code-generation prompt path.
5. Evaluate every code sample with `CandidateEvaluator`.
6. If bounded local repair is enabled, repair failed samples within the
   configured per-sample and per-thought caps, then re-evaluate each repaired
   attempt with `CandidateEvaluator`.
7. Aggregate the final sample results into one `ThoughtEvaluation`.
8. Route all-fail thought evaluations to the fail pool.
9. Route partial/all-success thought evaluations to descriptor assignment,
   archive insertion, reporting, and parent availability.

Gen0 follows the same representation semantics. When
`representation.kind=thought_only`, initialization creates
`thought_population_size` seed thoughts, generates exactly `k` code samples for
each seed thought, aggregates each thought evaluation, and inserts at most one
representative per seed thought. Do not initialize with ordinary code
candidates and then switch to thought-only semantics in later generations.

Independent code samples should come from independent LLM calls or an existing
batch call that preserves independent decoding. Diversity comes from sampling
temperature, top-p, and stochastic model behavior. Do not add hand-authored
"try a pipeline version", "try a case-statement version", or similar code
modifiers in the first pass.

The code-generation prompt may include the problem specification and the
thought being realized. It must not include parent code, parent individual
feedback, or parent code-level error logs. It may include stable formatting
instructions needed for JSON parsing.

### Outcome Categories And Grading

Each thought is graded after all base samples and any allowed sample-local
repair attempts have finished. The final code sample state, not the first failed
attempt, is used for aggregation.

Invalid thought:

- `thought_spec_v1` validation fails before code sampling.
- aggregate status is `invalid_thought`.
- failure reason is `thought_spec_validation_failed`.
- `success_count = 0` and `success_rate = 0.0`.
- `code_samples = []`.
- no replacement thought is sampled for that slot.
- the thought enters fail accounting as a failed-format thought evaluation.
- the thought is excluded from fail-pool parent selection.
- validation-error artifacts preserve the raw model response and invalid fields.

All-fail thought:

- `success_count = 0` and `success_rate = 0.0`.
- aggregate status is `all_failed`.
- representative sample is absent.
- no archive descriptor or Pareto objective is assigned to the thought.
- the thought enters the fail pool once, with the thought text, parent metadata,
  operator kind, furthest evaluation stage reached by any sample, dominant
  failure class, and sample-level artifact links for reporting.
- future mutation prompts that select this fail-pool thought may include only
  the thought and coarse `evaluation_status = "failed"`.
- failed samples remain diagnostics only and do not become independent parents.
- unlike `invalid_thought`, a valid all-fail thought is eligible for fail-pool
  parent selection.

Partial-success thought:

- `0 < success_count < k`.
- aggregate status is `partial_success`.
- success rate is recorded for analysis.
- the representative is the successful sample with the best scalar PPA quality.
- descriptor assignment, archive insertion, and Pareto comparison use only that
  representative sample.
- failed samples remain attached to the thought evaluation as evidence but do
  not enter the archive or parent pool separately.
- failed samples from a partial-success thought are diagnostic artifacts only.
  They must not become future mutation prompt evidence.

All-success thought:

- `success_count = k`.
- aggregate status is `all_success`.
- representative selection still uses best scalar PPA quality, so all-success
  and partial-success thoughts share the same archive path.
- success rate is recorded as `1.0` and remains diagnostic only.

Thought grading has two layers:

- evolutionary grade: representative PPA objectives, representative descriptor
  values, and archive/Pareto insertion result.
- diagnostic grade: success rate, failure-stage distribution, repair attempts,
  and non-representative sample outcomes.

Only the evolutionary grade may affect archive membership and future parent
selection. Diagnostic fields are for methodology reporting, ablation analysis,
and debugging.

### Operator Compatibility And Ablations

Feature 06 must keep the operator layer and representation layer orthogonal:

```text
qd_operator_kind = eoh_strategies | single_thought_operator
representation.kind = code_individual | thought_only
```

This gives the journal branch four useful comparison cells:

| Operator | Representation | Purpose |
| --- | --- | --- |
| `eoh_strategies` | `code_individual` | Existing no-thought-only baseline. |
| `single_thought_operator` | `code_individual` | Feature 05 unified-operator baseline. |
| `eoh_strategies` | `thought_only` | Compatibility ablation isolating representation changes. |
| `single_thought_operator` | `thought_only` | Journal Feature 06 target. |

The implementation should avoid special cases that make thought-only available
only for the unified operator. The journal paper may ultimately emphasize the
`single_thought_operator + thought_only` target, but the code must support the
EoH compatibility cell so regressions can be attributed to either the operator
change or the representation/evaluation change.

Output schemas depend on representation:

- `single_thought_operator + code_individual` preserves Feature 05 `eoh_v1`
  `{thought, code}` behavior.
- `single_thought_operator + thought_only` uses a thought-only output contract:
  the operator returns `thought_spec_v1` and no code.
- `eoh_strategies + code_individual` preserves existing EoH behavior.
- `eoh_strategies + thought_only` is a compatibility ablation. It must still use
  the uniform thought-conditioned code-sample path and must use EoH
  thought-only prompt adapters that return `thought_spec_v1` and no code.
  Do not generate EoH `{thought, code}` output and discard the code for this
  ablation.

### Bounded Sample-Local Repair

Hard RTL tasks can require iterative log-guided edits before a code sample
passes syntax, simulation, synthesis, and PPA extraction. Thought-only mode
must support an optional repair loop under the thought layer so a good thought
is not discarded only because its first sampled code realization was unlucky.

Repair is local to one code sample:

1. Generate the initial code sample from the thought.
2. Evaluate it with `CandidateEvaluator`.
3. If it fails and repair budget remains, build a repair prompt from only:
   - the same `thought_spec_v1`;
   - the current sample code;
   - the failure stage;
   - the sample's own relevant log or feedback excerpt.
4. Generate a repaired version of that same sample.
5. Re-evaluate the repaired sample.
6. Stop at the first successful final sample or when the repair caps are
   exhausted.

Allowed repair evidence by failure stage:

| Failure stage | Repair evidence allowed |
| --- | --- |
| parse / syntax / compile | compiler error excerpt for that sample. |
| testbench simulation | simulation/testbench failure excerpt for that sample. |
| synthesis | synthesis error excerpt for that sample. |
| physical / PPA | OpenROAD or physical/PPA failure excerpt for that sample. |
| timeout | timeout stage, command name, and bounded tail of that sample's log. |

Repair must not use:

- parent code.
- parent feedback.
- parent logs.
- sibling code samples from the same thought.
- archive members' code.
- aggregate failure summaries from other thoughts.

Repair logs and repaired code stay under the sample artifact directory. They
are evaluation aids, not evolutionary material. Future thought mutation prompts
may see only the parent thought and coarse thought-level evaluation status, not
the repair transcript.

This loop is deliberately bounded. It can rescue a good thought whose sampled
code needs one or a few log-guided corrections, but it is not an unbounded
conversation with the evaluator. If every sample still fails after the repair
budget is exhausted, the thought is categorized as all-fail and moves to the
fail pool. That prevents a hard problem from consuming the run in a repeated
repair spiral.

### Budget Semantics

Thought-only mode must account for budget in code-sample evaluations because
the existing no-thought-only baseline spends one evaluator call per candidate.
This keeps the acceptance comparison fair.

For the first implementation:

- `population_size` remains the per-generation code-sample evaluation budget.
- `initial_population_size` or Gen0 population, if separate, is also treated
  as a code-sample evaluation budget.
- derived `thought_population_size` is
  `code_evaluation_budget / code_samples_per_thought`.
- Feature 06 acceptance configs use `population_size=20` and `k=4`, producing
  five thoughts in Gen0 and five thoughts per later generation.
- resolved manifests must record `population_size`, `code_samples_per_thought`,
  derived `thought_population_size`, and total base code-sample budget.
- `num_generations` keeps the current runtime meaning: Gen0 plus
  `num_generations` later generations. Total base code-sample budget is
  `population_size * (num_generations + 1)`. Total base thought budget is
  `thought_population_size * (num_generations + 1)`.
- if bounded repair is enabled, repair attempts are a separate explicit repair
  budget and must be reported as additional LLM/evaluator calls.
- repair attempts do not consume or replace base `k` code samples. Every thought
  still receives exactly `code_samples_per_thought` initial samples before
  aggregation.

If a later implementation needs non-divisible budgets, add an explicit policy
then. Do not hide silent rounding in the first pass.

Do not reinterpret `population_size` as thought count in thought-only mode.
That would multiply evaluator spend by `k` and make the no-thought controls an
unfair comparison unless every control budget were separately adjusted.

Repair budget accounting:

```text
base_code_samples_per_thought = k
max_repair_attempts_per_thought = R_t
max_repair_attempts_per_sample = R_s
max_code_generation_llm_calls_per_thought = k + R_t
max_evaluator_calls_per_thought = k + R_t
```

`R_t` is the hard cap. `R_s` prevents spending the whole thought repair budget
on one sample. Setting both caps to `0` disables repair. Small integer repair
round caps such as `1` or `2` are the intended first experiments. The
implementation must assert:

- `max_repair_attempts_per_sample >= 0`.
- `max_repair_attempts_per_thought >= 0`.
- `max_repair_attempts_per_thought <= k * max_repair_attempts_per_sample`.

When repair is enabled in acceptance, reports must show both code-sample budget
and repair budget so reviewers can distinguish representation quality from
extra debug compute. If the thought-only target uses repair while the control
does not, the validator must compare both ordinary metrics and budget-adjusted
metrics normalized by total LLM calls and total evaluator calls.

### Archive And Fail-Pool Semantics

Valid all-fail thought evaluations enter the fail pool once and remain eligible
for fail-pool parent selection. Do not insert each failed code sample as its own
fail-pool parent. `invalid_thought` evaluations are counted in fail accounting,
but they must not be sampled as parents.

Fail-pool parent prompts expose only the parent thought and coarse
`evaluation_status = "failed"`. They must not include failure-stage summaries,
dominant failure classes, failed sample code, logs, feedback, or repair
transcripts. Those fields may be stored for reporting and validator audits, but
they are not mutation context.

Partial-success and all-success thought evaluations enter the success/archive
path once. The representative sample is the best successful sample by scalar
PPA quality. That representative supplies:

- descriptor tuple for archive cell assignment.
- active PPA objectives for local and global Pareto logic.
- code artifact pointer for inspection.
- legacy quality score for reports and representative views.

In thought-only mode, local archive members and global Pareto members are
thought representatives, not all successful code samples. The non-representative
successful code samples remain evaluation evidence and may appear in
success-rate/sample-level diagnostics, but they are not extra evolutionary
individuals.

Parent selection uses thought evaluations or their archive-member payloads.
When a selected parent has representative code available, that code must not be
included in the thought mutation prompt.

Successful parent prompts may include compact representative PPA summaries, but
not representative code or logs. Keep the summary at the thought level: one
representative quality/active-objective payload per parent thought.

Parent selection must not use `success_rate` in Feature 06. Successful thought
parents are selected through the representative archive member using the
existing archive, Pareto rank, crowding, and parent-source machinery. All-fail
thoughts are available through the fail pool as thoughts, but their sample-level
success-rate diagnostics still do not change selection probability.

### Descriptor And Objective Semantics

Descriptor assignment uses representative-code descriptors in Feature 06.
Deferred alternatives include centroid, mean, median, and most-frequent-cell
aggregation over successful samples. Those are ablation knobs, not first-pass
behavior.

Pareto dominance remains PPA-only. `success_rate` must be emitted to artifacts
and reports, but must not alter:

- local cell dominance.
- local cell crowding.
- global Pareto archive insertion.
- archive duplicate checks.
- parent tournament comparison.
- parent-source allocation or parent sampling weights.
- descriptor assignment.

## Non-Goals

Do not implement any of these in Feature 06:

- KS-triggered re-binning.
- success-rate-aware Pareto dominance.
- success-rate-weighted archive replacement.
- code-sample descriptor aggregation beyond best successful representative.
- new code-generation diversity modifiers.
- learned descriptors.
- a new evaluator that bypasses `CandidateEvaluator`.
- strategy-bandit prompt routing in the journal path.
- parent code, individual feedback, repair transcripts, or code-level logs in
  thought mutation prompts.
- failed sibling sample code, logs, or feedback in future thought mutation
  prompts.
- failure-stage summaries or failure explanations in future thought mutation
  prompts.

## Configuration

Required first-pass representation config shape:

```yaml
representation:
  kind: thought_only
  code_samples_per_thought: 4
  representative_sample: best_successful_quality
```

Validation rules:

- `kind` is a discriminated representation mode:
  `code_individual` or `thought_only`. Unknown values fail.
- `code_samples_per_thought` is a positive integer.
- Feature 06 acceptance uses `4`.
- `representative_sample` has one supported first-pass value:
  `best_successful_quality`.
- thought-only operator output must be `thought_spec_v1` and must not contain a
  code sample for the unified target.
- Thought-only acceptance budgets must be divisible by
  `code_samples_per_thought`.
- In `representation.kind: thought_only`, runtime config validation must fail
  before generation starts when `population_size % code_samples_per_thought !=
  0`, with an error equivalent to:
  `population_size must be divisible by code_samples_per_thought in thought_only mode`.

Optional repair config:

```yaml
repair:
  kind: none
  max_attempts_per_sample: 0
  max_attempts_per_thought: 0
  evidence: stage_scoped_logs
```

For hard-task rescue experiments:

```yaml
repair:
  kind: bounded_local_repair
  max_attempts_per_sample: 1
  max_attempts_per_thought: 4
  evidence: stage_scoped_logs
```

Validation rules:

- `repair.kind` is `none` or `bounded_local_repair`.
- `max_attempts_per_sample` and `max_attempts_per_thought` are non-negative
  integers.
- `repair.kind: none` requires both caps to be `0`.
- `repair.kind: bounded_local_repair` requires
  `max_attempts_per_thought > 0`.
- `evidence` has one supported first-pass value: `stage_scoped_logs`.

The Feature 06 journal target should use Feature 05's unified operator:

```yaml
qd_operator_kind: single_thought_operator
qd_operator_one_parent_fraction: 0.5
qd_operator_archive_context_size: 4
qd_operator_two_parent_allow_intra_bin: true
```

It may also use one prompt profile for unified thought generation,
thought-conditioned code generation, and sample-local repair, for example:

```yaml
prompt_profile: journal_thought_only
```

Keep this ablation-safe. The EoH thought-only mode must preserve the EoH
thought-generation operator while using the same thought-conditioned
code-generation and repair prompt templates as the unified thought-only target.
If one global `prompt_profile` cannot express that without changing EoH
generation semantics, add a narrowly scoped representation or repair prompt
profile key and record it in the manifest. Do not let prompt-template selection
silently collapse the EoH-vs-unified ablation.

If the implementation chooses a different exact profile name or config key
shape, update this spec, the user guide, and validation docs in the same
change. The accepted run manifest must record the resolved prompt profile,
operator kind, representation, and repair config for each matrix mode.

Expected hard-subset target mode:

```yaml
grid_quantile_pareto_journal_thought_k4:
  search_mode: revolution_qd
  qd_archive_type: grid_quantile
  qd_descriptor_profile: journal_logic_ff_width_3d
  qd_grid_quantile_warmup_successes: 8
  qd_cell_mode: pareto_front
  qd_max_elites_per_cell: 5
  qd_objectives: ppa
  qd_two_parent_probability: 0.5
  qd_operator_kind: single_thought_operator
  qd_operator_one_parent_fraction: 0.5
  qd_operator_archive_context_size: 4
  qd_operator_two_parent_allow_intra_bin: true
  prompt_profile: journal_thought_only
  representation:
    kind: thought_only
    code_samples_per_thought: 4
    representative_sample: best_successful_quality
  repair:
    kind: none
    max_attempts_per_sample: 0
    max_attempts_per_thought: 0
    evidence: stage_scoped_logs
```

The EoH no-thought-only control remains the operator baseline:

```yaml
grid_quantile_pareto_journal_bd_eoh:
  search_mode: revolution_qd
  qd_archive_type: grid_quantile
  qd_descriptor_profile: journal_logic_ff_width_3d
  qd_grid_quantile_warmup_successes: 8
  qd_cell_mode: pareto_front
  qd_max_elites_per_cell: 5
  qd_objectives: ppa
  qd_two_parent_probability: 0.5
  qd_operator_kind: eoh_strategies
  representation:
    kind: code_individual
```

The unified no-thought-only comparison control after Feature 05 is:

```yaml
grid_quantile_pareto_journal_bd_unified:
  search_mode: revolution_qd
  qd_archive_type: grid_quantile
  qd_descriptor_profile: journal_logic_ff_width_3d
  qd_grid_quantile_warmup_successes: 8
  qd_cell_mode: pareto_front
  qd_max_elites_per_cell: 5
  qd_objectives: ppa
  qd_two_parent_probability: 0.5
  qd_operator_kind: single_thought_operator
  qd_operator_one_parent_fraction: 0.5
  qd_operator_archive_context_size: 4
  qd_operator_two_parent_allow_intra_bin: true
  representation:
    kind: code_individual
```

The EoH compatibility thought-only ablation is:

```yaml
grid_quantile_pareto_journal_eoh_thought_k4:
  search_mode: revolution_qd
  qd_archive_type: grid_quantile
  qd_descriptor_profile: journal_logic_ff_width_3d
  qd_grid_quantile_warmup_successes: 8
  qd_cell_mode: pareto_front
  qd_max_elites_per_cell: 5
  qd_objectives: ppa
  qd_two_parent_probability: 0.5
  qd_operator_kind: eoh_strategies
  representation:
    kind: thought_only
    code_samples_per_thought: 4
    representative_sample: best_successful_quality
  repair:
    kind: none
    max_attempts_per_sample: 0
    max_attempts_per_thought: 0
    evidence: stage_scoped_logs
```

`scripts/run_hard_iteration_qd_vllm.sh`, `scripts/run_backend.py`, and backend
config snapshots must pass through and record any new representation,
prompt-profile, and repair fields needed to run these modes in one matrix.

## Artifacts And Reporting

Each thought evaluation must have a stable artifact bundle. The exact directory
shape may follow existing local conventions, but it must be easy to inspect one
thought and all `k` samples from that thought.

Recommended structure:

```text
Gen<N>/
  <thought_id>/
    thought.json
    thought.txt
    thought_evaluation.json
    code_sample_0/
      code.sv
      evaluation_summary.json
      ...
    code_sample_1/
      ...
```

The implemented `thought_evaluation.json` includes:

- thought ID.
- generation.
- parent thought IDs and parent source.
- `qd_operator_kind`.
- prompt profile.
- representation kind.
- `population_size` as the public code-sample budget.
- derived `thought_population_size`.
- repair config.
- `code_samples_per_thought`.
- validation errors when aggregate status is `invalid_thought`.
- one `sample_records` row per code sample with sample ID, sample index,
  status, artifact path, PPA success, quality score when available, descriptor
  values when available, PPA metrics when available, and repair attempts used.
  Invalid thoughts have zero sample rows.
- success count.
- `success_rate`.
- aggregate status.
- repair budget consumed.
- representative sample ID.
- representative descriptor values.
- representative active objectives.
- representative quality score.
- archive insertion result or fail-pool insertion result.

Archive events for thought-only mode must link:

- archive member thought ID.
- representative code-sample ID.
- all code-sample IDs.
- thought success rate for reporting only.
- final attempt IDs for repaired samples.
- `success_rate`.
- repair mode and repair attempts used.
- descriptor tuple from the representative sample.
- local Pareto metadata when `qd_cell_mode=pareto_front`.
- global Pareto update metadata when applicable.

Summary and report files must expose both levels:

- thought-level counts and pass rates, used for acceptance comparisons.
- code-sample-level pass rates and success-rate distributions, used as
  diagnostic evidence.
- repair-attempt counts, repair success rates, and budget-normalized metrics
  when repair is enabled.
- operator/representation cross-tab summaries for the EoH compatibility,
  unified no-thought-only, EoH thought-only, and unified thought-only modes.

Existing report scripts should avoid treating all `k` code samples as separate
archive individuals. If a script intentionally reports code-sample diagnostics,
label that table clearly.

## Testing Plan

Add focused unit tests for:

- representation config parsing and rejection of unknown representation kinds.
- rejection of non-positive `code_samples_per_thought`.
- rejection of non-divisible thought-only budgets in the first pass.
- invalid `thought_spec_v1` consumes a thought slot, writes validation-error
  artifacts, generates zero code samples, and enters fail accounting.
- invalid `thought_spec_v1` does not trigger replacement thought sampling.
- invalid `thought_spec_v1` is excluded from parent selection.
- generating exactly `budget / k` thoughts for a code-sample budget.
- generating exactly `k` code samples per thought.
- all-fail aggregation.
- partial-success aggregation.
- all-success aggregation.
- representative-code selection by scalar PPA quality.
- `success_rate` recording.
- all-fail thought insertion into the fail pool.
- partial/all-success thought insertion into the archive once.
- descriptor assignment from representative code only.
- global Pareto insertion from representative code only.
- non-representative successful code samples staying out of the archive.
- prompt payloads for thought mutation excluding parent code, individual
  feedback, and code-level error logs.
- code-generation prompts including the thought text and excluding parent code
  and feedback.
- artifact JSON containing representative sample ID and all sample statuses.
- hard-iteration wrapper pass-through for per-mode `prompt_profile` and
  thought-only representation config if those fields are added there.
- thought-spec validation rejects missing fields, empty fields, `unknown`, and
  equivalent non-answers before code samples are generated.
- thought-only operator output contains `thought_spec_v1` and no code for the
  unified target.
- EoH thought-only prompt adapters return `thought_spec_v1` and no code.
- all `code_sample_0..k-1` entries are generated through the same
  thought-conditioned code-generation prompt path.
- EoH thought-only compatibility mode does not generate or discard
  operator-returned code before the uniform code-sample path.
- EoH strategy operator plus thought-only representation.
- single-thought operator plus code-individual representation.
- single-thought operator plus thought-only representation.
- primary acceptance keeps repair disabled by `repair.kind=none`.
- bounded local repair stops after first successful repaired attempt.
- bounded local repair stops at `max_attempts_per_sample`.
- bounded local repair stops at `max_attempts_per_thought`.
- repair prompt for syntax failure contains only the sample code, thought spec,
  failure stage, and sample-local compile log excerpt.
- repair prompt for testbench failure contains only the sample code, thought
  spec, failure stage, and sample-local simulation/testbench excerpt.
- repair prompt for synthesis or physical/PPA failure contains only the sample
  code, thought spec, failure stage, and sample-local tool-log excerpt.
- repair transcripts are absent from future thought-mutation prompts.
- reports distinguish base code-sample LLM calls from repair LLM calls.

Regression-test that the existing no-thought-only modes still run with the
current code-individual semantics when `representation.kind` is not
`thought_only`.

## Validation Loop

Before asking for review:

1. Run focused tests around QD engine scheduling, parent selection, archive
   insertion, and candidate evaluation before editing, and record the baseline.
2. Add the unit and regression tests listed above.
3. Run focused tests for touched source and scripts.
4. Run ruff on touched source, tests, scripts, and docs-adjacent Python.
5. Run pyright on touched source and scripts, or document unrelated existing
   type debt.
6. Run a tiny deterministic fake-LLM integration test proving one thought
   produces four code samples and one aggregate archive/fail-pool decision.
7. Run a small live or fake smoke for the target mode with total worker slots
   capped at `4`.
8. Run the full hard-subset acceptance matrix below.
9. Generate backend comparison, final-analysis, Pareto/PPA/design-space, and
   visualization artifacts.
10. Run the strict Feature 06 validator.
11. Accept the feature only if every quantitative gate below passes.

Minimum local checks:

```bash
uv run pytest <focused tests> -q
uv run ruff check <touched source/tests/scripts>
uv run pyright <touched source/scripts>
git diff --check
```

If shared QD runtime paths are touched, also run:

```bash
uv run pytest -q
```

## Full Hard-Subset Acceptance Run

Create a scratch config under `exp/`; do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_thought_only_k4_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_thought_only_k4_configs/hard_subset_thought_only_k4.yaml
```

Set the matrix to include the classic anchor plus the journal operator /
representation ablation grid:

```yaml
matrix_modes:
  - classic
  - grid_quantile_pareto_journal_bd_eoh
  - grid_quantile_pareto_journal_bd_unified
  - grid_quantile_pareto_journal_eoh_thought_k4
  - grid_quantile_pareto_journal_thought_k4

modes:
  classic:
    search_mode: revolution
    seed: 42

  grid_quantile_pareto_journal_bd_eoh:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: eoh_strategies
    representation:
      kind: code_individual
    seed: 42

  grid_quantile_pareto_journal_bd_unified:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: single_thought_operator
    qd_operator_one_parent_fraction: 0.5
    qd_operator_archive_context_size: 4
    qd_operator_two_parent_allow_intra_bin: true
    representation:
      kind: code_individual
    seed: 42

  grid_quantile_pareto_journal_eoh_thought_k4:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: eoh_strategies
    representation:
      kind: thought_only
      code_samples_per_thought: 4
      representative_sample: best_successful_quality
    repair:
      kind: none
      max_attempts_per_sample: 0
      max_attempts_per_thought: 0
      evidence: stage_scoped_logs
    seed: 42

  grid_quantile_pareto_journal_thought_k4:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: single_thought_operator
    qd_operator_one_parent_fraction: 0.5
    qd_operator_archive_context_size: 4
    qd_operator_two_parent_allow_intra_bin: true
    prompt_profile: journal_thought_only
    representation:
      kind: thought_only
      code_samples_per_thought: 4
      representative_sample: best_successful_quality
    repair:
      kind: none
      max_attempts_per_sample: 0
      max_attempts_per_thought: 0
      evidence: stage_scoped_logs
    seed: 42
```

Default Feature 06 acceptance keeps repair disabled. This tests the thought-only
`k=4` representation without extra log-guided debug compute.

If smoke or validation runs show the target has persistent difficulty producing
valid representatives without repair, run a second declared rescue/ablation
candidate with only the two thought-only modes changed to:

```yaml
repair:
  kind: bounded_local_repair
  max_attempts_per_sample: 1
  max_attempts_per_thought: 4
  evidence: stage_scoped_logs
```

Do not silently switch repair on in the final run. The run root, manifest,
validator, and methodology notes must state whether the accepted target is
`repair.kind=none` or `repair.kind=bounded_local_repair`.

Even when repair is disabled for primary acceptance, keep bounded-repair unit
and integration tests in Feature 06. Those tests prove the optional rescue path
works and catch regressions in prompt evidence scoping, cap enforcement, and
budget accounting.

Run the full hard subset with at most four simultaneous workers:

```bash
PYTHON_BIN=/workspace/.venv/bin/python \
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_MIN_MODEL_LEN=128000 \
HARD_SUBSET_MAX_TOKENS=128000 \
HARD_SUBSET_DIFF_MAX_TOKENS=128000 \
HARD_SUBSET_POPULATION_SIZE=20 \
HARD_SUBSET_NUM_GENERATIONS=5 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=4 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
HARD_SUBSET_SAVE_PATH=exp/journal_thought_only_k4_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_thought_only_k4_configs/hard_subset_thought_only_k4.yaml \
  --mode matrix
```

If the full matrix must be repeated after the unchanged baseline modes already
completed, do not spend evaluator time rerunning those controls. Reuse the
completed `classic`, `grid_quantile_pareto_journal_bd_eoh`, and
`grid_quantile_pareto_journal_bd_unified` mode directories by copying them or
linking them into the new run root, then rerun only the thought-only target or
thought-only ablation modes that need another pass. Record the source run root
for any copied or symlinked baseline directory in the validation notes so the
comparison remains auditable.

The manifest must show:

- `reported_max_model_len >= 128000`.
- `population_size=20`.
- `num_generations=5`.
- `total_worker_slots=4`.
- `max_active_problems=4`.
- `max_workers_per_problem=4`.
- `max_tokens=128000`.
- `diff_max_tokens=128000`.
- `seed=42`.
- all 13 hard-subset problems.
- EoH no-thought control:
  `mode.grid_quantile_pareto_journal_bd_eoh.qd_operator_kind=eoh_strategies`.
- unified no-thought control:
  `mode.grid_quantile_pareto_journal_bd_unified.qd_operator_kind=single_thought_operator`.
- EoH thought-only ablation:
  `mode.grid_quantile_pareto_journal_eoh_thought_k4.representation.kind=thought_only`.
- unified thought-only target:
  `mode.grid_quantile_pareto_journal_thought_k4.representation.kind=thought_only`.
- `mode.grid_quantile_pareto_journal_thought_k4.representation.code_samples_per_thought=4`.
- `mode.grid_quantile_pareto_journal_thought_k4.repair.kind=none` unless a
  separate bounded-repair final run is declared.
- `mode.grid_quantile_pareto_journal_thought_k4.prompt_profile=journal_thought_only`.
- target thought count per generation is `5` for a code-sample budget of `20`.

After the run, generate the report family:

```bash
RUN_ROOT="<printed save path from wrapper>"
CONFIG=exp/journal_thought_only_k4_configs/hard_subset_thought_only_k4.yaml

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --backend_run grid_quantile_pareto_journal_eoh_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_eoh_thought_k4" \
  --backend_run grid_quantile_pareto_journal_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_thought_k4" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}"

/workspace/.venv/bin/python scripts/report_pareto_analysis.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --backend_run grid_quantile_pareto_journal_eoh_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_eoh_thought_k4" \
  --backend_run grid_quantile_pareto_journal_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_thought_k4" \
  --output-dir "${RUN_ROOT}/pareto_analysis"

/workspace/.venv/bin/python scripts/report_ppa_distribution.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --backend_run grid_quantile_pareto_journal_eoh_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_eoh_thought_k4" \
  --backend_run grid_quantile_pareto_journal_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_thought_k4" \
  --output-dir "${RUN_ROOT}/ppa_distribution"

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --feature-profile journal_logic_ff_width_3d
```

Export and validate the linked archive/PPA viewer if the touched code changes
archive, Pareto, report, or visualization surfaces:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --backend_run grid_quantile_pareto_journal_eoh_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_eoh_thought_k4" \
  --backend_run grid_quantile_pareto_journal_thought_k4="${RUN_ROOT}/grid_quantile_pareto_journal_thought_k4" \
  --archive_source_backend grid_quantile_pareto_journal_thought_k4 \
  --output-dir "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config "${CONFIG}" \
  --asset-mode local \
  --strict

/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config "${CONFIG}" \
  --playwright \
  --strict
```

Add a strict Feature 06 audit command:

```bash
/workspace/.venv/bin/python scripts/validate_thought_only_k_code_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --classic-mode classic \
  --eoh-control-mode grid_quantile_pareto_journal_bd_eoh \
  --unified-control-mode grid_quantile_pareto_journal_bd_unified \
  --eoh-thought-only-mode grid_quantile_pareto_journal_eoh_thought_k4 \
  --thought-only-mode grid_quantile_pareto_journal_thought_k4 \
  --require-full-subset \
  --acceptance-hard-subset
```

The audit command must emit:

- `thought_only_k_code_validation.json`.
- `thought_only_k_code_validation.md`.
- non-zero exit status on any failed hard gate.

## Quantitative Acceptance Gates

The full hard-subset run is satisfactory only if every hard gate passes:

- `problem_count=13`.
- `failure_count=0`.
- `problem_invalid_count=0`.
- `acceptance_error_count=0`.
- all five configured modes complete all 13 hard-subset problems.
- final-analysis, Pareto, PPA-distribution, design-space, and backend
  comparison reports are generated.
- `backend_comparison.md` reports valid designs, functionality pass rate,
  synthesis/PPA pass rate, average quality score, and average PPA improvement
  for every backend.
- target artifacts contain `thought_evaluation.json` for every generated
  thought.
- every target thought has exactly four code-sample records.
- every target successful archive member links to one representative code
  sample and all evaluated sample IDs.
- no target archive cell or global Pareto archive contains multiple entries
  from the same thought evaluation.
- all-fail thoughts appear in fail-pool accounting.
- `success_rate` distribution is present in target summaries and reports.
- `success_rate` is absent from active objective lists and descriptor axes.
- `success_rate` is absent from parent-selection weights, parent-source
  allocation, Pareto ranking, and archive replacement decisions.
- prompt snapshots for thought mutation contain no parent code, individual
  feedback, or code-level error logs.
- prompt snapshots for thought mutation contain no failed sibling sample code,
  logs, or feedback from partial-success parent thoughts.
- prompt snapshots for fail-pool thought parents contain only the thought and
  coarse `evaluation_status = "failed"` from evaluation results.
- prompt snapshots for successful thought parents contain at most the thought,
  coarse `evaluation_status = "succeeded"`, and compact representative PPA
  summary fields.
- total concurrent workers never exceed `4`.

Primary performance gates compare the unified thought-only target against the
unified no-thought-only Feature 05 control:

```text
target = grid_quantile_pareto_journal_thought_k4
primary_control = grid_quantile_pareto_journal_bd_unified
operator_baseline = grid_quantile_pareto_journal_bd_eoh
representation_ablation = grid_quantile_pareto_journal_eoh_thought_k4
```

The target must not substantially degrade versus the unified no-thought control
on:

- valid design count.
- functional any-pass problem count.
- synthesis/PPA any-pass problem count.
- functional pass rate.
- synthesis/PPA pass rate.
- average quality score.
- average PPA improvement over reference.
- Pareto/front breadth or linked visualization checks when those artifacts are
  touched.

The same metrics must also be reported versus `classic`, the EoH no-thought
operator baseline, and the EoH thought-only representation ablation.
Classic-relative comparison is a guardrail for paper claims: if the target is
outside the classic variance envelope, the validator must say whether the
unified no-thought control and EoH thought-only ablation are also outside that
envelope. A target that is materially worse than both the unified control and
the EoH thought-only ablation is not accepted.

Compute variance envelopes over per-problem paired values, not raw candidate or
code-sample rows. This prevents one problem with many samples from dominating
the decision. The validator should compute paired target-minus-control deltas
and accept a metric when:

```text
mean_delta >= -max(2 * standard_error(delta_by_problem), metric_floor)
```

Use these floors until a repeated-seed study replaces them:

```text
any-pass counts: 1 problem
functional pass rate: 0.10
synthesis/PPA pass rate: 0.10
average quality score: 0.05
average PPA improvement: 0.05
```

For average quality and average PPA improvement, pair only problems where both
target and control have at least one synthesis/PPA-valid representative. If
fewer than four paired non-empty problem values exist for a metric, use the
floor only and require a written validation note.

Do not accept Feature 06 on a cherry-picked rerun. If the declared final run
fails a gate, the feature remains open unless a new full matrix is declared and
validated from scratch.

Feature-specific acceptance gates:

- thought count per generation equals code-sample budget divided by `k`.
- manifests and summaries expose `thought_population_size` as the derived
  thought count per generation.
- manifests and summaries expose total base code-sample budget and total base
  thought budget, both counting Gen0.
- code-sample count equals `thought_count * k` for every generation.
- all code samples pass through the existing evaluator.
- EoH no-thought, unified no-thought, EoH thought-only, and unified thought-only
  modes are all runnable from the same matrix config.
- paired reports include target-minus-unified-control,
  target-minus-EoH-control, EoH-thought-minus-EoH-control, and
  unified-thought-minus-EoH-thought deltas.
- archive insertion count is bounded by successful thought count, not
  successful code-sample count.
- every successful thought has exactly one representative sample.
- representative sample is the highest scalar-quality successful sample for
  that thought.
- failed samples do not receive archive descriptors unless their own evaluator
  produced valid diagnostic descriptors; they still must not become archive
  members.
- valid all-fail thoughts are available as fail-pool parents as thoughts, not
  as individual code samples.
- invalid thoughts are excluded from parent selection even though they are
  counted in fail accounting.
- parent-source counts are reported at thought granularity.
- prompt-profile and representation fields are present in run config
  snapshots and the hard-iteration manifest.
- `repair.kind=none` produces zero repair attempts and no repair prompt
  artifacts.
- when `repair.kind=bounded_local_repair`, per-sample and per-thought repair
  caps are enforced, repair evidence is sample-local, and reports separate base
  code-sample calls from repair calls.
- repair attempts never reduce `code_samples_per_thought`; budget-normalized
  metrics include base sample calls plus repair calls.

## Documentation Requirements

Update docs and comments only where they help users run or review the feature.
At minimum, check:

- this feature spec.
- `docs/journal_features/overall_plan.md`.
- `docs/user_guide.md`.
- `docs/qd_map_elites_guide.md`.
- CLI/config docs for any new representation or prompt-profile pass-through.
- docstrings on new runtime objects and validator/report entry points.

Keep docs consistent with the implemented behavior. If the implementation uses
different names from this spec, update the spec in the same change.

## Implementation Rules

Apply the project-wide journal implementation discipline:

1. Keep code simple, skimmable, and direct.
2. Minimize states and arguments.
3. Use typed/discriminated variants for representation and aggregate status.
4. Exhaustively handle object variants; fail on unknown types.
5. Do not add fallback behavior for values that should exist.
6. Use asserts when loading required data.
7. Do not make required parameters optional.
8. Do not pass overrides unless strictly needed.
9. Bias for fewer lines of code.
10. Avoid clever abstractions.
11. Prefer early returns.
12. Remove changes that are not required for Feature 06.
13. Do not change archive geometry, Pareto dominance, descriptor definitions,
    or KS re-binning behavior beyond what Feature 06 explicitly requires.
14. Do not revert unrelated work from Features 05 or 07.

## Commit Guidance

Use atomic signed commits with `git commit -s`.

Good possible commits:

```text
feat(qd): Add thought-only evaluation
test(qd): Cover k-code aggregation
docs(qd): Specify thought-only gates
```

Commit message rules:

1. Separate subject from body with a blank line.
2. Keep the subject concise, ideally under 50 characters.
3. Use imperative mood.
4. Do not end the subject with a period.
5. Wrap body text at 72 characters.
6. Explain what and why, not line-by-line how.

After each commit, immediately check:

```bash
git log --format=%B -n 1 HEAD
git show --pretty=fuller --no-patch HEAD
git log --format=%B -n 1 HEAD | rg '\\n' && echo "BAD: raw newline text found"
git log --format=%B -n 1 HEAD | rg -c '^Signed-off-by:'
```

There should be no raw `\n` text and exactly one `Signed-off-by:` footer.

## Completion Checklist

Target deadline: `2026-05-10`

- [x] 6.1 Add simple typed runtime objects for thought individuals, code
  samples, and thought evaluations.
- [x] 6.2 Keep `qd_operator_kind` orthogonal to `representation.kind` so both
  EoH and unified operators can run as code-individual and thought-only modes.
- [x] 6.3 Split thought generation from code generation.
- [x] 6.4 Add structured `thought_spec_v1` prompts for thought generation and
  thought-conditioned code generation.
- [x] 6.5 Generate `k=4` code samples per thought and evaluate each sample with
  the existing evaluator.
- [x] 6.6 Keep the public runtime budget as a code-sample evaluation budget and
  record derived thought counts.
- [x] 6.7 Aggregate thought evaluation: best successful code chooses BD/code
  artifact, success rate is recorded, and all-fail thoughts enter the fail
  pool.
- [x] 6.8 Add optional bounded sample-local repair with explicit per-sample and
  per-thought caps.
- [x] 6.9 Insert successful thoughts into local/global archives once, using the
  representative sample for descriptors and PPA objectives.
- [x] 6.10 Add thought-level artifacts, summaries, success-rate reports, and
  repair-budget reports.
- [x] 6.11 Add strict validation for the thought-only hard-subset acceptance
  matrix.
- [ ] 6.12 Run the full four-worker hard-subset acceptance matrix and pass the
  quantitative gates.
