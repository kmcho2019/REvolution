# Single Thought Mutation Operator

## Goal

Replace the conference-style strategy-bandit prompt routing in the journal
QD runtime with one minimal thought-generation operator.

For the journal experiments, the LLM should be asked to produce a new
hardware design strategy from one or two parent thoughts. Diversity comes
from archive sampling, stochastic LLM decoding, one-parent versus two-parent
variation, and adaptive behavior-space coverage, not from hand-authored
mutation directions such as "fix", "simplify", "explore", "refactor",
"improve", or "fuse".

The unified operator must keep thought mutation free of parent source code,
individual candidate feedback, and code-level error logs. The prompt may
include only the parent thought, a coarse evaluation status, compact
success-side PPA summaries, a compact archive-thought context, and the
problem specification.

This is a deliberate shift from the EoH-style conference operator set toward
a FunSearch/AlphaEvolve-style minimal operator. The operator is the visible
methodological contribution of the journal version on top of the
already-landed BD trio, quantile binning, Pareto-front archive, and
two-tier fail pool work.

The first journal implementation keeps the existing `eoh_v1` output schema
(`format`, `mode`, `thought`, `code`) so the journal QD path remains
functional end-to-end. Feature 06 (thought-only individuals + k-code
evaluation) is the seam where the output narrows to a thought only. Feature
05 must keep the surface shaped so that swap is a small, local change.

The runtime candidate interface also remains the current
thought/code/feedback interface: generated candidates still carry a thought,
generated code, evaluator feedback, status, score, and artifact paths. The
Feature 05 restriction is only about what is injected into the new mutation
prompt; it is not a data-model migration.

## Handoff Goal Statement

Implement Feature 05 as the journal QD prompt-operator simplification. Start
from this document as the authoritative spec, and do not implement Feature 06
or Feature 07 behavior in this worktree.

Dedicated worktree:
`/workspace/.worktrees/journal-single-mutation-operator`

Authoritative spec:
`docs/journal_features/05_single_mutation_operator.md`

The required change is to add a selectable `single_thought_operator` for
`revolution_qd` that bypasses QD strategy-bandit routing and uses exactly one
prompt builder for journal offspring generation. Parent arity is the only
operator variant: one parent requests mutation-like thought generation, and
two parents request crossover-like thought generation. The operator should
preserve archive sampling, stochastic decoding, success/fail parent-source
scheduling, and Pareto-front archive behavior from Features 03-04.

The prompt contract is strict. Parent payloads must never include parent code,
individual feedback, testbench logs, synthesis logs, code-level error text, or
any hidden repair transcript. Failed parents provide only their thought and a
coarse `evaluation_status = "failed"`. Successful parents provide their
thought, `evaluation_status = "succeeded"`, and compact PPA summary fields.
Archive context is a small uniform sample of existing archive thoughts, also
without code, feedback, or logs.

Compatibility is also strict. Do not remove `code` generation, evaluator
feedback capture, candidate feedback files, or existing `Heuristic` fields in
Feature 05. Those are required so the unified operator can be tested against
the current EoH prompt profile before Feature 06 changes the individual
semantics.

Do not consider Feature 05 complete when the code compiles, focused tests
pass, docs are updated, or a smoke run succeeds. Those are necessary
intermediate checks only. Run smaller bounded smoke runs first to catch
wiring, prompt-shape, artifact, and validator issues before committing full
server resources to the 13-problem matrix. A smoke run can justify launching
the full run; it cannot justify marking the feature complete. The feature is
complete only after the full 13-problem hard-subset comparison matrix has run
to completion and the strict validator passes every gate in this document.

The final acceptance comparison is
`grid_quantile_pareto_journal_bd_unified` versus the current EoH-based
`grid_quantile_pareto_journal_bd_eoh` prompt profile, with `classic` kept as
the anchor mode. Acceptance requires the unified mode to avoid substantial
degradation on the paired per-problem metrics: functionality, valid PPA sample
count, average quality score, and average PPA improvement. The same final
run must also pass the prompt-content audits for zero parent code, zero
individual feedback, and zero code-level logs. If the full matrix fails a
gate, continue debugging and rerun the required comparison; do not mark the
feature ready based on partial evidence.

Server-side evaluation resources are limited for this feature branch. Keep
all local smoke runs, validation runs, and multi-config matrix runs at or
below `16` total workers. When running multiple modes in parallel, split the
worker budget so the sum across active configs never exceeds `16`. For
long-running evaluations, progress monitoring may be delegated to a cheap
subagent such as `gpt-5.3-codex-spark`; keep that subagent scoped to progress
checks, failure summaries, and actionable status updates.

## Current State

The journal QD runtime in `revolution_qd` reuses the conference EoH operator
set:

- `M-F` Mutate-Fix: corrects functional errors from a failed parent.
- `M-S` Mutate-Simplify: simplifies a successful parent while preserving
  functionality.
- `M-E` Mutate-Explore: proposes a novel architecture starting from one
  parent.
- `M-R` Mutate-Refactor: refactors a parent into a cleaner structure with the
  same idea.
- `M-I` Mutate-Improve: improves correctness or PPA from one parent.
- `C-F` Crossover-Fusion: fuses two successful parents into one new design.

Two further QD-specific operators existed in earlier branches and remain in
code for descriptor-guided profiles, but they are deliberately disabled for
the journal BD profile and stay out of scope for Feature 05:

- `M-T` Mutate-Targeted: pushes one parent toward a descriptor target.
- `C-D` Crossover-Diverse: fuses two distant archive parents to backfill
  novel cells.

Strategy routing currently lives in
`src/revolution/qd/engine.py:1394-1565`. For each generated offspring, the
engine:

1. Picks a parent source (`fail_pool` or success archive) using the Feature
   04 budget split.
2. Picks an EoH strategy via the existing UCB / epsilon-greedy / random
   bandit in `_select_strategy`.
3. Resolves a generation mode (`whole` or `diff`) via `_phase_mode`.
4. Dispatches to the matching `_create_prompt_<strategy>` builder in
   `src/revolution/algorithm.py` (or in `qd/engine.py` for `M-T` / `C-D`).
5. Builds an LLM request and inserts it into the batch.

The prompt builders all use `_format_parent_for_prompt` in
`src/revolution/algorithm.py:1508-1535`, which injects:

- the parent thought;
- the parent feedback string verbatim;
- the parent code (always in whole mode, optionally in diff mode);
- a PPA metrics dictionary when the parent has `ppa_success`.

For the journal BD profile, `_uses_descriptor_guided_generation()` returns
false, which forces classic EoH success-side operators
(`M-S`, `M-E`, `M-R`, `M-I`, `C-F`) instead of the descriptor-targeted
`M-T` / `C-D`. This is the routing surface Feature 05 must collapse.

## Satisfactory End State

Feature 05 is complete only when all of these are true:

1. A new operator `single_thought_operator` is selectable via
   `operator.kind` and is the recommended journal QD operator after this
   feature lands.
2. When `operator.kind = single_thought_operator`, the journal QD path uses
   one prompt builder for every parent-source / parent-arity combination.
   The strategy-bandit code path is bypassed; no `_select_strategy` call is
   made for offspring generated by this operator.
3. The operator emits one of two prompt variants based on parent count only:
   - one parent: mutation-like generation.
   - two parents: crossover-like generation.
4. Parent-count selection follows a configurable `one_parent_fraction`,
   default `0.5`. Two-parent generation falls back to one-parent generation
   when fewer than two parents are available.
5. Parent payloads injected into the prompt never include the parent code.
   This is checked by a regression test that reads every snapshot prompt and
   asserts the parent code string is not present.
6. Parent payloads inject `evaluation_status` plus a compact PPA summary
   for successful parents only (`quality_score`, normalized `g_T`, `g_P`,
   `g_A` gains when active). Failed parents inject no feedback text,
   no testbench output, no synthesis output, and no code-level error logs.
7. Two-parent payloads place both parents under a `parents` array and reuse
   the same per-parent shape as the one-parent case.
8. The prompt builder accepts a uniformly sampled list of existing archive
   thoughts as compact archive context. The list length is
   `operator.archive_context_size`, default `4`. Archive context entries are
   stripped to `{thought, evaluation_status, quality_score?}` and never
   include code or feedback.
9. Two-parent sampling allows two parents from the same Pareto cell when
   `operator.two_parent_allow_intra_bin = true` (default). When the toggle
   is off, two-parent sampling reverts to the existing cross-cell-only
   behavior in `_sample_two_success_parents`.
10. The operator preserves the `eoh_v1` output schema for Feature 05:
    `{format, mode, thought, code}`. Whole mode is the only mode routed for
    `single_thought_operator` in Feature 05; the diff template exists as a
    placeholder so Feature 06 or later can decide whether to enable it.
    Evaluator feedback remains recorded on the resulting candidate exactly as
    it is for current REvolution candidates.
11. Artifacts record `strategy = "single_thought_operator"` for every
    candidate generated through this operator, alongside a new
    `parent_count` field. Existing legacy strategy names continue to exist
    for the `eoh_strategies` operator path and for classic `revolution`.
12. Classic `revolution` (non-QD) and `revolution_qd` with
    `operator.kind = eoh_strategies` are behaviorally unchanged. EoH
    strategy bandit, `_create_prompt_M_F`, `_create_prompt_C_F`, etc. remain
    available; Feature 05 does not delete them.
13. Unknown `operator.kind` values fail loudly at startup with a clear
    error.
14. `one_parent_fraction` is asserted in `[0.0, 1.0]`, and
    `archive_context_size` is a non-negative integer.
15. The journal QD hard-subset acceptance run completes for `classic`,
    `grid_quantile_pareto_journal_bd_eoh`, and
    `grid_quantile_pareto_journal_bd_unified`, and meets the variance gates
    in the Quantitative Acceptance Gates section.

## Operator Methodology

This section is the methodology source for the journal paper section on
prompt operator design. It is intentionally written so the prose can be
lifted with light editing.

### From EoH operator set to unified thought operator

Conference REvolution treats the LLM as a programmable mutation engine. Six
hand-authored mutation directions (`M-F`, `M-S`, `M-E`, `M-R`, `M-I`,
`C-F`) plus QD-targeted `M-T` and `C-D` give the search a fixed taxonomy of
"what kind of change the next candidate is". A bandit (UCB / epsilon-greedy)
then learns which operators currently produce reward. This is operationally
convenient but has three problems for a thought-centric journal MAP-Elites
setting:

1. **Operator inflation.** Eight strategies create eight prompt templates,
   eight prompt builders, eight bandit arms, and eight artifact strategy
   labels. They overlap semantically (`M-I` and `M-R` are nearly identical
   prompts), and there is no first-class place to express "produce a new
   design idea that improves the parent thought."
2. **Code anchoring.** Every conference operator injects the parent code
   and its evaluation feedback into the prompt. The LLM is rewarded for
   surface-level edits to parent code, which both biases generation toward
   small surface mutations and makes the search target conflate "the design
   idea" with "this specific Verilog source string."
3. **Fail-pool repair framing.** `M-F` frames every failed candidate as a
   thing to be fixed line-by-line using its testbench log. This pulls the
   LLM toward repairing code rather than toward generating a new idea that
   could plausibly succeed at the same goal. For a journal version that
   wants thought-level mutation, this is the wrong inductive bias.

The journal operator collapses this surface. Operator routing is replaced
by a single prompt path that accepts:

- one or two parent thoughts;
- per-parent evaluation status (`succeeded` or `failed`);
- per-parent compact PPA summary when applicable;
- a small uniformly sampled list of existing archive thoughts as compact
  archive context;
- the problem specification.

The output is still `{thought, code}` for Feature 05 (so the journal
runtime stays end-to-end functional and comparable to classic), and the
evaluated candidate still records feedback through the existing evaluator
pipeline. The methodological framing nevertheless matches the FunSearch /
AlphaEvolve view: the LLM is asked to produce a new design strategy that
improves on the parent thought(s), and the code is a sample drawn from that
strategy.

Diversity is not produced by hand-authored "explore" prompts. It is
produced by:

- archive sampling: MAP-Elites cells already provide a structured diversity
  pressure on what counts as a useful parent.
- stochastic LLM decoding: temperature and top-p control variation within
  the same parent context.
- one-parent versus two-parent variation: structural variant of the prompt
  inputs.
- parent choice within a cell front: NSGA-II crowding tournament already
  picks different members per request.
- adaptive behavior-space coverage: BD trio plus quantile binning push
  generation toward underfilled cells via the existing Feature 04 budget
  split.

### Why failed-parent feedback is excluded

The journal operator intentionally excludes individual feedback and
code-level logs from thought mutation prompts. Failed parents contribute the
same genotype-level information as successful parents: the parent thought and
a coarse evaluation status. This keeps the mutation target at the thought
level instead of turning the prompt into a repair loop over a particular
Verilog source string or EDA failure transcript.

This restriction is behaviorally important. It forces the LLM to reason from
the parent's design idea and its evaluation outcome, not from its specific
source code, testbench trace, syntax error, synthesis report, or post-hoc
debug text. Future failure-pattern summaries are allowed as a separate
ablation only if they are aggregate, thought-level context rather than
individual candidate feedback.

### Feature 06 seam

Feature 06 narrows the operator to thought-only output and introduces
k-code evaluation. To keep that transition small, Feature 05 isolates the
following knobs:

- The prompt template file is the single source of truth for output
  schema. Feature 06 changes `whole.txt` to drop the `code` field; no
  builder change is required if the schema is sourced from the template.
- The prompt builder returns the assembled prompt string only. It does
  not perform response parsing. Feature 06 can switch the response parser
  branch in `EoHEngine` without touching the builder.
- The operator never reads parent code. Feature 06's k-code stage owns code
  sampling.
- Feature 05 does not remove `Heuristic.code`, `Heuristic.feedback`, feedback
  files, or the existing candidate evaluator. Feature 06 can introduce the
  narrower thought-evaluation objects after this operator has been tested.

## Prompt Schema And Inputs

The unified prompt is loaded from
`data/prompts/default/evolve/single_thought_operator/whole.txt`. It takes a
single template variable `context_json`. The engine assembles `context_json`
as follows.

The prompt text should keep the mutation request methodologically general:
the problem description is authoritative, failed parent thoughts are weak
hints, and the model should re-derive cycle-accurate control logic instead
of preserving parent state counts, counters, or timing assumptions. General
FSM guidance is allowed when it is not derived from individual feedback:
exact pulse widths, handshakes, reset behavior, serial pattern detection,
and short fixed-delay phases should be modeled explicitly when that is
clearer than a compact counter shortcut.

The performance-tuning iteration keeps the same single operator, but makes
the prompt more precise about the kinds of thought-level moves it can perform:
improve, simplify, refactor, explore, repair-by-rethinking, and two-parent
fusion. These are phrased as internal design intentions, not as strategy
arms; the runtime still records every offspring as
`single_thought_operator` and does not reintroduce bandit routing.

### One-parent payload

```text
{
  "task": "single_thought_operator",
  "parent_count": 1,
  "problem_description": "<problem text>",
  "parent": {
    "example": 1,
    "thought": "<parent thought>",
    "evaluation_status": "succeeded" | "failed",
    "ppa_summary": {                             // succeeded parents only
      "quality_score": <float>,
      "g_T": <float>,                            // when timing is active
      "g_P": <float>,                            // when power is active
      "g_A": <float>                             // when area is active
    }
  },
  "archive_context": [                           // optional, length <= archive_context_size
    { "thought": "<thought>", "evaluation_status": "succeeded",
      "quality_score": <float> },
    ...
  ]
}
```

### Two-parent payload

```text
{
  "task": "single_thought_operator",
  "parent_count": 2,
  "problem_description": "<problem text>",
  "parents": [
    { "example": 1, "thought": "...", "evaluation_status": ..., "ppa_summary": ... },
    { "example": 2, "thought": "...", "evaluation_status": ..., "ppa_summary": ... }
  ],
  "archive_context": [ ... ]
}
```

### Per-parent rules

1. `evaluation_status` is `succeeded` only when the parent reached
   `status = "success"` and `ppa_success = true`. Every other state maps to
   `failed`.
2. Failed parents include no `feedback`, no failure log, no code-level error
   text, and no repair hint derived from an individual candidate artifact.
3. `ppa_summary` is included only when `evaluation_status = "succeeded"`.
   It contains `quality_score` and the active per-objective PPA gain
   values returned by `compute_ppa_gains`.
4. The parent payload never contains `code`. The builder must not read
   the parent's code file or feedback/log artifacts under any conditions.

### Archive context rules

1. `archive_context` is omitted entirely when the archive has zero
   successful members.
2. Otherwise, `archive_context` is a list of up to
   `operator.archive_context_size` thoughts drawn uniformly at random from
   `success_archive` members. When the archive has fewer members than the
   requested size, the list is shorter.
3. Each entry contains only `{thought, evaluation_status, quality_score}`.
   No code, no feedback, no descriptor coordinates.
4. The sampled parents themselves are excluded from `archive_context` to
   avoid duplication.

## Parent Sampling Methodology

`single_thought_operator` reuses the existing journal QD parent sampling
machinery, with one new toggle.

### Parent arity

1. For each scheduled offspring, the engine draws a Bernoulli with
   probability `1 - operator.one_parent_fraction` for "wants two parents".
2. If the result is "wants two parents" and at least two success parents
   are available, the engine calls `_sample_two_success_parents`.
3. Otherwise, the engine calls `_sample_success_parents(1)`.
4. Fail-pool offspring always run with parent_count = 1 because the fail
   pool is not the right source for crossover-like generation in Feature
   05. (Two-parent fail-pool generation is intentionally deferred.)

### Intra-bin two-parent sampling

The current `_sample_two_success_parents` forces the second parent into a
different Pareto cell than the first. This was a Feature 03 choice intended
to maximize behavior diversity for `C-F` and `C-D`. For
`single_thought_operator`, we relax it:

- When `operator.two_parent_allow_intra_bin = true` (default), the engine
  may sample both parents from the same Pareto cell. Inside the cell, each
  draw still uses the existing crowding tournament so distinct members are
  preferred. If the cell has only one member, the second draw falls back to
  a different cell.
- When `operator.two_parent_allow_intra_bin = false`, sampling reverts to
  the existing cross-cell-only behavior.

The default is on because the intra-bin regime is empirically useful for
the unified operator: two parents from the same descriptor cell that have
different PPA Pareto positions exercise within-cell refinement, which is
otherwise hard to express in a thought-centric prompt. The toggle is
exposed so this choice can be ablated.

### Reporting

Every generated candidate carries a `parent_count` artifact field
(`1` or `2`) alongside the existing `strategy` field. The strategy field is
set to `single_thought_operator` for offspring produced through this
operator, and to the existing EoH strategy name for offspring produced
through `operator.kind = eoh_strategies`.

## Implementation Specification

Concrete required behavior:

1. Add `operator.kind` selection with values `eoh_strategies` (default) and
   `single_thought_operator`. Unknown values raise immediately in
   `QDEngine.__init__`.
2. Thread the operator config through
   `RevolutionBackendConfig` -> `RevolutionBackend.initialize` ->
   `QDEngine.__init__`. Match the existing flat `qd_*` field naming style:
   - `qd_operator_kind`
   - `qd_operator_one_parent_fraction`
   - `qd_operator_archive_context_size`
   - `qd_operator_two_parent_allow_intra_bin`
3. In `QDEngine.evolve_one_generation`, when
   `qd_operator_kind == "single_thought_operator"`, replace the strategy
   selection block in `src/revolution/qd/engine.py:1394-1565` with a
   single dispatch that:
   - For each fail-budget offspring: sample one fail-pool parent and call
     `_create_prompt_single_thought_operator(parents=[parent],
     archive_context=<compact archive thought sample>)`.
   - For each success-budget offspring: draw arity, sample parents through
     the existing path with the intra-bin toggle honored, and call the same
     builder with the sampled archive_context.
4. Add `_create_prompt_single_thought_operator` in `QDEngine`. The builder
   produces the context JSON described above, reads the prompt template
   from `evolve/single_thought_operator/whole.txt`, and returns the
   formatted prompt string. The builder never falls back to a built-in
   prompt string; if the template file is missing, raise.
5. Add `_archive_context_sample(exclude_ids: set[str]) -> list[Heuristic]`
   that returns up to `qd_operator_archive_context_size` candidates from
   `success_archive` members, drawn uniformly at random, excluding the
   sampled parents.
6. Add `_format_parent_for_single_thought_operator(parent, example_num)`
   that produces the per-parent payload described above. Use the existing
   `compute_ppa_gains` and `_objective_names` to build the PPA summary.
   This helper must not read `parent.feedback`, code files, simulation logs,
   synthesis logs, or any candidate-specific failure artifact.
7. Update `_sample_two_success_parents` (or add a thin wrapper) so the
   intra-bin toggle controls the same-cell behavior. Do not touch
   `_sample_diverse_success_parents`; `single_thought_operator` does not
   use diverse-distance sampling.
8. In `_materialize_offspring`, set `candidate.strategy =
   "single_thought_operator"`, `candidate.parent_count = parent_count`, and
   `candidate.requested_parent_count = requested_parent_count` for offspring
   whose `request_meta` carries that strategy label. `parent_count` is the
   actual arity after fallback; `requested_parent_count` records the arity
   drawn before fallback.
9. Update artifact writers so the new `parent_count` column appears in
   `qd_archive_event.json` and in any CSV produced by
   `src/revolution/qd/artifacts.py`. Existing strategy columns continue to
   exist.
10. Leave `_create_prompt_M_F`, `_create_prompt_M_S`, `_create_prompt_M_E`,
    `_create_prompt_M_R`, `_create_prompt_M_I`, `_create_prompt_C_F`,
    `_create_prompt_M_T`, and `_create_prompt_C_D` in place. They remain in
    use for `operator.kind = eoh_strategies` and for non-QD `revolution`
    runs.

Out of scope for Feature 05:

- Thought-only output schema. Output stays `{thought, code}`. Feature 06
  narrows it.
- k-code thought evaluation, success rates, all-fail-thought routing.
- Removing or narrowing the current thought/code/feedback candidate interface.
  Evaluator feedback remains captured and archived; it is simply not used as
  parent prompt input for `single_thought_operator`.
- Removing the EoH strategy bandit code paths.
- Adding LLM-judged abstract failure categories or failure-pattern summaries.
  Feature 05 includes no individual failed-candidate feedback in prompts.
- New descriptor-targeted operators or QD operator surfaces.
- Two-parent generation from the fail pool.

## Current Repo Surfaces

Intended code impact:

- `src/revolution/qd/engine.py`:
  - Add `QDOperatorKind` literal and `SINGLE_THOUGHT_OPERATOR_STRATEGY`
    constant.
  - Accept the four new `qd_operator_*` kwargs in `__init__`, validate
    them, store them on the instance.
  - Add `_create_prompt_single_thought_operator`,
    `_format_parent_for_single_thought_operator`, and
    `_archive_context_sample`.
  - Branch in `evolve_one_generation` on `qd_operator_kind`.
  - Honor `qd_operator_two_parent_allow_intra_bin` in
    `_sample_two_success_parents`.
- `src/revolution/algorithm.py`:
  - Extend the strategy literal set with `single_thought_operator` so
    typed enumerations remain exhaustive.
  - Add `parent_count: int | None = None` to `Heuristic` and set it during
    materialization.
  - Preserve the existing thought/code/feedback fields and evaluator feedback
    behavior.
- `src/revolution/backends/revolution_backend.py`:
  - Add the four new fields to `RevolutionBackendConfig`.
  - Pass them into `QDEngine` kwargs.
  - Expose them under `backend_details.qd_config.operator` in the summary.
- `data/prompts/default/evolve/single_thought_operator/whole.txt`: new
  prompt template, whole mode.
- `data/prompts/default/evolve/single_thought_operator/diff.txt`:
  placeholder for future use; not wired into Feature 05 routing.
- `src/revolution/qd/artifacts.py`: add `parent_count` to archive event
  payloads and CSV exports where strategy is already exposed.
- `scripts/run_hard_iteration_qd_vllm.sh`: pass the `qd_operator_*`
  mode fields through to `scripts/run_backend.py`, write them into the
  hard-subset manifest, and support `--smoke-subset N` for bounded
  pre-acceptance runs.
- `scripts/validate_two_tier_fail_pool_run.py` or a narrow
  `scripts/validate_single_thought_operator_run.py`: enforce the
  acceptance gates below.
- `tests/revolution/test_qd_engine.py` and a new
  `tests/revolution/test_single_thought_operator.py`: cover prompt shape,
  parent sampling, intra-bin toggle, regression that parent code is never
  present.
- `docs/user_guide.md` and `docs/qd_map_elites_guide.md`: document the new
  operator config keys.

## Configuration

New flat config keys (defaults shown):

```yaml
qd_operator_kind: eoh_strategies          # or: single_thought_operator
qd_operator_one_parent_fraction: 0.5
qd_operator_archive_context_size: 4
qd_operator_two_parent_allow_intra_bin: true
```

The journal hard-subset acceptance config sets
`qd_operator_kind: single_thought_operator` for the unified mode and leaves
it at the default `eoh_strategies` for the EoH-prompting comparison mode.

Assertions enforced at engine construction:

- `qd_operator_kind in {"eoh_strategies", "single_thought_operator"}`.
- `0.0 <= qd_operator_one_parent_fraction <= 1.0`.
- `qd_operator_archive_context_size` is a non-negative integer.

No new required configuration is introduced for runs that stay on
`eoh_strategies`. The journal default in the acceptance config is the only
place that must be explicit.

## Artifacts And Reporting

- Every generated candidate carries `strategy` (existing), `parent_count`
  (actual arity after fallback), and `requested_parent_count` (requested
  arity before fallback, when applicable).
- Candidates from the unified operator report
  `strategy = "single_thought_operator"`. Candidates from the
  `eoh_strategies` path keep their EoH names (`M-F`, `C-F`, etc.).
- `qd_archive_event.json` records both fields.
- Summary `qd_config.operator` exposes the four operator config values so
  acceptance auditing can read them back from the manifest.
- Prompt snapshots must be auditable as "no parent code, feedback, or
  code-level logs". A focused test scans every prompt snapshot recorded by
  a smoke run and asserts forbidden parent artifacts are not substrings of
  the prompt.

Reports do not need a new visualization specifically for the operator; the
existing Feature 03.1 archive/PPA viewer, the backend comparison report,
the Pareto analysis, and the PPA distribution report already cover the
metric space that acceptance gates use.

For acceptance reporting, a valid PPA sample is counted when a generated
candidate passes validation and synthesis/PPA evaluation, even if a QD run
later buffers it during warmup or declines to insert it into the archive.
Archive coverage and retained elites remain separate QD diagnostics. When a
problem has generated valid PPA samples but no retained final-population PPA
aggregate, the backend comparison report uses the best generated valid PPA
sample for the per-problem score and PPA deltas.

Descriptor-health reports distinguish live insertion decisions from
grid-quantile warmup replay/finalization. `decision_counts` remains the
live-decision compatibility alias, while `live_decision_counts` and
`replay_decision_counts` make the distinction explicit. Grid-quantile
descriptor health also records `initialization_mode`, `initialized`,
`warmup_successes`, `warmup_buffer_size`, `initialization_sample_count`,
`effective_shape`, `active_effective_axes`, `collapsed_axes`, and
`warmup_replay_decision_counts` when available.

## Testing Plan

Focused unit tests (live in `tests/revolution/test_single_thought_operator.py`):

1. Parent-count sampling: with `one_parent_fraction = 1.0`, every
   generation runs with one parent. With `one_parent_fraction = 0.0` and
   `>= 2` available success parents, every generation runs with two.
2. One-parent prompt schema, successful parent: payload contains
   `evaluation_status = "succeeded"`, contains `ppa_summary`, does not
   contain `feedback`, does not contain `code`.
3. One-parent prompt schema, failed parent: payload contains
   `evaluation_status = "failed"`, does not contain `feedback`, does not
   contain `ppa_summary`, does not contain `code`, and does not contain
   log-derived fields.
4. Two-parent prompt schema: payload uses `parents` array with two
   entries, each entry follows the per-parent rules.
5. Archive context: when the success archive has more members than
   `archive_context_size`, the payload `archive_context` length equals
   `archive_context_size`. When the archive is empty, `archive_context` is
   absent.
6. No parent code, feedback, or code-level logs in any payload: a regression
   scans the rendered prompt string and asserts the forbidden parent
   artifacts are not present.
7. Intra-bin two-parent on: two parents may be drawn from the same Pareto
   cell when `two_parent_allow_intra_bin = true`.
8. Intra-bin two-parent off: with the toggle off, two parents are always
   from distinct cells (matches pre-Feature-05 behavior).
9. `operator.kind = eoh_strategies` regression: existing strategy-bandit
    routing is unchanged. A run with this kind produces no candidate with
    `strategy = "single_thought_operator"`.
10. Unknown `operator.kind`: engine construction raises immediately.

Smoke testing: a bounded local smoke (population_size = 4,
num_generations = 1, 2-3 problems, total concurrent workers <= 16) must
complete for `classic`, `grid_quantile_pareto_journal_bd_eoh`, and
`grid_quantile_pareto_journal_bd_unified` without crashes. The smoke
artifacts must include `qd_archive_event.json` with `parent_count`, and the
prompt-content audit must report zero candidates that injected parent code.
The same audit must report zero injected individual feedback or code-level
logs.

The acceptance hard-subset run is described in the Full Hard-Subset
Acceptance Run section. Reporting and validator tooling overlap with
Feature 04; only the validator command names a new mode and adds the
prompt-content gate.

## Validation Loop

Follow this loop before accepting the implementation:

1. Run the existing focused QD engine and algorithm tests before editing
   and record the baseline.
2. Add the focused tests in `test_single_thought_operator.py` and confirm
   each one fails before the implementation lands.
3. Implement the engine, config, prompt template, and artifact changes.
4. Re-run the focused tests until they pass.
5. Run `uv run ruff check` on touched source, tests, and scripts.
6. Run `uv run pyright` (or `python -m pyright`) on touched source and
   scripts.
7. Run the bounded local smoke described above. Confirm the prompt
   audit reports zero candidates with parent code, individual feedback, or
   code-level logs injected.
8. Run the full fixed-seed hard-subset matrix below.
9. Generate the final-analysis bundle, Pareto analysis, PPA distribution,
   design-space analysis, Feature 03.1 visualization, and strict
   validation reports.
10. Accept the feature only if every quantitative gate below passes.

## Full Hard-Subset Acceptance Run

Feature 05 uses the same acceptance style as the Feature 04 Pareto/fail
hard-subset run, restricted to a three-mode matrix that isolates the
operator effect.

### Matrix

```yaml
matrix_modes:
  - classic
  - grid_quantile_pareto_journal_bd_eoh
  - grid_quantile_pareto_journal_bd_unified

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
    seed: 42
```

`grid_struct` and `grid_quantile_journal_bd` (scalar) are intentionally not
in this matrix. They are not affected by the operator change and their
hard-subset behavior is already established by Features 01-04. Restricting
the matrix keeps the cost of the acceptance run bounded and isolates the
operator effect to one paired comparison plus a classic anchor.

### Scratch config

Create the run config under `exp/` and do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_single_thought_operator_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_single_thought_operator_configs/hard_subset_single_thought_operator.yaml
```

Then edit `matrix_modes` and `modes` to match the matrix above.

### Local smoke (before the costly run)

Before launching the full hard-subset matrix, run a smoke at most three
problems with total concurrent workers capped at `16` to confirm the runtime
is wired correctly. Acceptable smoke parameters:

```bash
PYTHON_BIN=/workspace/.venv/bin/python \
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_MIN_MODEL_LEN=128000 \
HARD_SUBSET_MAX_TOKENS=128000 \
HARD_SUBSET_DIFF_MAX_TOKENS=128000 \
HARD_SUBSET_POPULATION_SIZE=4 \
HARD_SUBSET_NUM_GENERATIONS=1 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=16 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
HARD_SUBSET_SAVE_PATH=exp/journal_single_thought_operator_smoke \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_single_thought_operator_configs/hard_subset_single_thought_operator.yaml \
  --mode matrix \
  --smoke-subset 3
```

The smoke is acceptable when:

- all three modes complete without crash on the chosen problems;
- the `grid_quantile_pareto_journal_bd_unified` artifacts contain at least
  one `qd_archive_event.json` with `strategy = "single_thought_operator"`
  and `parent_count in {1, 2}`;
- the prompt-content audit reports zero candidates that injected parent
  code, individual feedback, or code-level logs into the prompt.

### Full hard-subset matrix

Run the full 13-problem matrix with the long-context vLLM endpoint:

```bash
PYTHON_BIN=/workspace/.venv/bin/python \
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_MIN_MODEL_LEN=128000 \
HARD_SUBSET_MAX_TOKENS=128000 \
HARD_SUBSET_DIFF_MAX_TOKENS=128000 \
HARD_SUBSET_POPULATION_SIZE=20 \
HARD_SUBSET_NUM_GENERATIONS=5 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=16 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
HARD_SUBSET_SAVE_PATH=exp/journal_single_thought_operator_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_single_thought_operator_configs/hard_subset_single_thought_operator.yaml \
  --mode matrix
```

The manifest must show:

- `reported_max_model_len >= 128000`.
- `population_size=20`.
- `num_generations=5`.
- `total_worker_slots=16`.
- `max_active_problems=4`.
- `max_workers_per_problem=4`.
- `max_tokens=128000`.
- `diff_max_tokens=128000`.
- `seed=42`.
- all 13 hard-subset problems.
- `mode.grid_quantile_pareto_journal_bd_eoh.qd_cell_mode=pareto_front`.
- `mode.grid_quantile_pareto_journal_bd_eoh.qd_operator_kind=eoh_strategies`.
- `mode.grid_quantile_pareto_journal_bd_unified.qd_cell_mode=pareto_front`.
- `mode.grid_quantile_pareto_journal_bd_unified.qd_operator_kind=single_thought_operator`.
- `mode.grid_quantile_pareto_journal_bd_unified.qd_operator_one_parent_fraction=0.5`.
- `mode.grid_quantile_pareto_journal_bd_unified.qd_operator_archive_context_size=4`.
- `mode.grid_quantile_pareto_journal_bd_unified.qd_operator_two_parent_allow_intra_bin=true`.

### Reports after the run

```bash
RUN_ROOT="<printed save path from wrapper>"
CONFIG=exp/journal_single_thought_operator_configs/hard_subset_single_thought_operator.yaml

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}"

/workspace/.venv/bin/python scripts/report_pareto_analysis.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --output-dir "${RUN_ROOT}/pareto_analysis"

/workspace/.venv/bin/python scripts/report_ppa_distribution.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --output-dir "${RUN_ROOT}/ppa_distribution"

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --feature-profile journal_logic_ff_width_3d
```

Export and validate the linked archive/PPA visualization:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_eoh="${RUN_ROOT}/grid_quantile_pareto_journal_bd_eoh" \
  --backend_run grid_quantile_pareto_journal_bd_unified="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified" \
  --archive_source_backend grid_quantile_pareto_journal_bd_unified \
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

Run the strict audit:

```bash
/workspace/.venv/bin/python scripts/validate_single_thought_operator_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --classic-mode classic \
  --eoh-mode grid_quantile_pareto_journal_bd_eoh \
  --unified-mode grid_quantile_pareto_journal_bd_unified \
  --require-full-subset \
  --acceptance-hard-subset
```

The audit command must emit:

- `single_thought_operator_validation.json`.
- `single_thought_operator_validation.md`.
- non-zero exit status on any failed hard gate.

## Quantitative Acceptance Gates

The unified mode is accepted only when every hard gate passes. All gates
below use per-problem aggregation, not raw candidate rows.

### Run-level structural gates

- `problem_count = 13`.
- `failure_count = 0`.
- `problem_invalid_count = 0`.
- `acceptance_error_count = 0`.
- `final_analysis/summary.json` exists and has an empty
  `skipped_sections` list.
- `final_analysis/hard_iteration_analysis/summary.json` covers all 13
  problems for each mode.
- `final_analysis/pareto_analysis/summary.json` covers every
  backend/problem pair in the matrix.
- `final_analysis/ppa_distribution/summary.json` exists.
- `final_analysis/design_space_analysis/summary.json` has successful
  candidates and all 13 pairwise feature comparisons.
- `backend_comparison.md` reports valid designs, functionality rate,
  synthesis/PPA rate, average quality score, and average PPA improvement
  for every mode.
- The linked archive/PPA viewer exports successfully and the strict
  validator exits `0`.

### Coverage gates (unified vs. EoH and classic)

- Unified mode must complete the same 13 problems as the EoH mode and
  classic.
- The unified mode must produce at least one valid PPA sample for every
  one of the 13 hard-subset problems. Count successful PPA samples recorded
  in `generation_log.jsonl` for this gate; archive CSV rows measure retained
  archive/front members and must not be used as a proxy for generated valid
  sample count. There is no coverage tolerance for Feature 05 acceptance.
- For every problem where the EoH mode or classic produced at least one
  design with a valid final PPA, the unified mode must also produce at
  least one. This is redundant with the all-problem unified coverage gate
  but is reported explicitly so baseline/unified gaps are visible.

### Variance-envelope gates (unified vs. EoH)

These are the journal-specific gates. The unified mode is accepted on a
metric when the paired delta (unified minus EoH, per problem) satisfies:

```text
mean_delta >= -max(2 * standard_error(delta_by_problem), metric_floor)
```

Metric set, with floors used until a multi-seed study replaces them:

```text
functional pass rate:        0.10
valid PPA sample count:      1 sample per problem
average quality score:       0.05
average PPA improvement:     0.05
```

If fewer than four paired non-empty problem values exist for a metric, the
floor alone is used and a written validation note is required. Cherry-
picked reruns are not accepted; if the declared final run fails a gate, a
new full matrix must be declared and validated from scratch.

### Operator-specific gates

- For every non-seed offspring in the unified mode, `strategy =
  "single_thought_operator"` and `parent_count in {1, 2}`. Seed-budget
  candidates may still have `strategy = "initial"` and are excluded from
  operator-offspring prompt-routing gates.
- For every offspring in the unified mode, `parent_count = 1` for fail-pool
  offspring (two-parent fail-pool generation is out of scope).
- For every prompt snapshot in the unified mode, the prompt string does
  not contain the parent code string, parent feedback string, testbench log
  text, synthesis log text, or code-level error-log text. The validator scans
  recorded snapshots and emits the offending candidate ID on the first
  violation.
- `archive_context` entries in unified-mode snapshots contain only
  `thought`, `evaluation_status`, and `quality_score`. Any other key
  (especially `code` or `feedback`) is a hard failure.
- Across the 13-problem run, the empirical requested one-parent fraction is
  within `+/- 0.10` of `qd_operator_one_parent_fraction` once the success
  archive has reached at least two members. Use `requested_parent_count` for
  this gate so legitimate two-parent fallback does not bias the arity audit.
- When `qd_operator_two_parent_allow_intra_bin = true`, at least one
  two-parent generation in the run draws both parents from the same
  Pareto cell. This proves the toggle is exercised in the acceptance run.

### Deferred from Feature 05

The validation report must include a "Deferred From Feature 05" section
listing:

- thought-only output schema;
- k-code thought evaluation;
- all-fail versus partial-success thought routing;
- success-rate-aware archive dominance;
- removing legacy strategy-bandit operators from the journal path;
- LLM-summarized abstract failure categories or aggregate failure-pattern
  context;
- two-parent fail-pool generation;
- intra-bin two-parent ablation results (default on; explicit on/off
  comparison left to a separate experiment).

## Implementation Rules

Apply these rules while implementing this feature:

1. Write simple, skimmable code.
2. Minimize possible states by narrowing state and reducing argument count.
3. Use discriminated unions for operator kind, parent-source labels, and
   parent payload shape where new typed surfaces are needed.
4. Exhaustively handle every multi-type object; fail on unknown variants.
5. Do not write defensive fallback code for values that should exist.
6. Use asserts when loading required data.
7. Remove changes not required for Feature 05.
8. Bias toward fewer lines of code.
9. Avoid clever code.
10. Do not split logic into tiny helpers when it makes generation flow
    harder to read.
11. Prefer early returns.
12. Use asserts instead of broad try/except/defaults for expected values.
13. Do not pass overrides unless strictly necessary.
14. Do not make required arguments optional.

Concretely for Feature 05:

- Add no second public operator mode beyond `eoh_strategies` and
  `single_thought_operator`.
- Add no new prompt semantics inside the EoH strategy code paths.
- Do not pass operator config through every scheduler layer. The engine
  owns it; the scheduler is unchanged.
- Keep `evolve_one_generation` as the single place where operator routing
  is decided.
- Keep `_create_prompt_single_thought_operator` as the single prompt builder
  for the unified operator; do not split it into per-arity functions.
- Fail validation on unknown `operator.kind` rather than silently falling
  back.
- Do not delete or refactor the existing EoH strategy builders. They remain
  in use for the EoH-prompting comparison mode.

## Commit Guidance

Use atomic commits with `git commit -s`.

Good possible commits:

```text
feat(qd): Add single thought mutation operator
test(qd): Cover unified operator prompt shape
docs(qd): Specify single-thought-operator acceptance
```

Commit message rules:

1. Separate subject from body with a blank line.
2. Keep the subject concise, ideally under 50 characters.
3. Capitalize the subject text after the type/scope.
4. Do not end the subject with a period.
5. Use imperative mood.
6. Wrap body text at 72 characters.
7. Explain what and why, not line-by-line how.

After each commit, immediately check:

```bash
git log --format=%B -n 1 HEAD
git show --pretty=fuller --no-patch HEAD
git log --format=%B -n 1 HEAD | rg '\\n' && echo "BAD: raw newline text found"
git log --format=%B -n 1 HEAD | rg -c '^Signed-off-by:'
```

There should be no raw `\n` text and exactly one `Signed-off-by:` footer.

## Completion Checklist

Target deadline: `2026-05-08`

- [ ] 5.1 Add `qd_operator_kind` selection plumbed through
  `RevolutionBackendConfig` and `QDEngine`, including assertions.
- [ ] 5.2 Add `_create_prompt_single_thought_operator`, the unified
  template, and the per-parent payload helper. Verify prompts contain no
  parent code, individual feedback, or code-level logs.
- [ ] 5.3 Replace the strategy-bandit routing block in
  `evolve_one_generation` for `qd_operator_kind = single_thought_operator`
  while leaving the EoH bandit path intact for `qd_operator_kind =
  eoh_strategies`.
- [ ] 5.4 Add intra-bin two-parent sampling toggle and update
  `_sample_two_success_parents` to honor it.
- [ ] 5.5 Add focused unit tests and the prompt-content regression.
- [ ] 5.6 Run a bounded local smoke with at most 16 concurrent workers
  across `classic`, `grid_quantile_pareto_journal_bd_eoh`, and
  `grid_quantile_pareto_journal_bd_unified`.
- [ ] 5.7 Run the full 13-problem hard-subset matrix and pass every
  quantitative gate in this document.
