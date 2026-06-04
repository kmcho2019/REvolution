# Misc 01: GEPA Prompt Tuning

Status: planned implementation scaffold.

This feature adds a prompt-tuning framework for `PromptStore` profiles using
GEPA, with DSPy installed as part of the optional prompt-tuning dependency
surface for future DSPy module adapters. The first target is
`data/prompts/journal_thought_only`, because the
Feature 06 thought-only path has one main thought operator plus an optional
repair prompt and is small enough to optimize as one coherent text artifact.
The implementation must stay general enough to tune other prompt profiles after
the first path is proven.

This is a `misc/` journal-extension feature rather than a core methodology
feature. The journal methodology contributions are the archive/operator/QD
runtime changes under the numbered core specs. GEPA prompt tuning is engineering
support for improving prompts used by those methods. It can be useful in the
paper's methodology pipeline and ablation hygiene, but it is not itself a new
MAP-Elites archive mechanism.

## Active Goal

Implement a repeatable GEPA tuning loop that:

1. exports a `PromptStore` profile into one strict concatenated bundle;
2. asks GEPA to optimize that bundle as a single candidate text artifact;
3. parses every candidate back into a temporary `PromptStore` profile;
4. evaluates the candidate profile with a small real RTL/QD proxy;
5. scores the candidate from real artifacts only;
6. writes JSON and Markdown diagnostics for the campaign and each candidate;
7. materializes the selected profile as `journal_thought_only_gepa`;
8. validates the selected profile against classic and baseline thought-only on
   the full hard-subset matrix before the feature is considered done.

The tuning loop must not include fake optimizer behavior in production code. A
synthetic evaluator path is allowed for unit tests and dry plumbing checks, but
accepted optimization evidence must come from real RTL/QD artifacts.

## Prompt Bundle Representation

The candidate representation is one concatenated `PromptStore` bundle. The
bundle uses the existing native marker format:

```text
===== PROMPT: system/thought_spec =====
...
===== END PROMPT =====

===== PROMPT: thought_only/generate_thought =====
...
===== END PROMPT =====
```

For the initial `journal_thought_only` profile, the required sections are:

```text
system/thought_spec.txt
thought_only/generate_thought.txt
thought_only/code/whole.txt
evolve/single_thought_operator/thought.txt
thought_only/repair/whole.txt
```

The `.txt` suffix is not part of the bundle key. The strict parser must:

- require every expected section exactly once;
- reject missing sections;
- reject duplicate sections;
- reject unexpected sections;
- reject unclosed prompt blocks;
- reject non-empty text outside prompt blocks;
- reject empty prompt sections;
- preserve the exact expected prompt key set after materialization.

The optimizer sees the full bundle as one parameter named `prompt_bundle`.
This intentionally lets GEPA move wording across sections if needed while the
parser keeps the final artifact compatible with normal `PromptStore` loading.

## Environment And Dependencies

Optimizer dependencies are isolated from the main runtime dependency list:

```bash
uv sync --group prompt-tuning
```

The `prompt-tuning` dependency group includes:

```text
dspy>=2.6.27
gepa>=0.1.1
```

The active optimizer path is GEPA's `optimize_anything` API. The tuning runner
imports it only after dependency preflight, then gives GEPA one candidate
parameter named `prompt_bundle`. DSPy is dependency-checked and kept available
for future prompt-module adapters; it is not the current candidate-search
engine. The runner must fail at startup if either package is unavailable and
should tell the operator to run `uv sync --group prompt-tuning`.

OpenAI credentials are loaded from:

```text
/workspace/.env
```

The default optimizer model is:

```text
gpt-5.5
```

RTL evaluation uses the local vLLM endpoint:

```text
http://host.docker.internal:8000/v1/models
```

The runner must require the served model context length to be at least
`128000` tokens and must pass `max_tokens=128000` into the proxy RTL/QD run.
This avoids silent truncation when reasoning models emit long thought/code
outputs.

## Candidate Flow

The tuning runner is:

```text
scripts/run_gepa_prompt_tuning.py
```

Default inputs:

```text
prompt_root: data/prompts
baseline_profile: journal_thought_only
optimized_profile: journal_thought_only_gepa
save_root: exp/gepa_prompt_tuning
optimizer_model: gpt-5.5
```

Per campaign, the runner creates:

```text
exp/gepa_prompt_tuning/<timestamp>/
  bundles/
    seed_prompt_bundle.txt
    selected_prompt_bundle.txt
  candidates/
    cand_001/
      prompt_bundle.txt
      score.json
      report.md
  candidate_runs/
    cand_001/
      <real run artifacts>
  prompt_profiles/
    journal_thought_only_gepa_cand_001/
      ...
  gepa_state/
  campaign.json
  campaign.md
```

For each GEPA candidate:

1. Extract `candidate["prompt_bundle"]`.
2. Parse with the strict bundle parser.
3. Materialize into a fresh temporary prompt profile under the campaign root.
4. Launch the proxy QD run with that temporary `prompt_root` and profile.
5. Load problem summaries, archive summaries, and thought-evaluation JSON.
6. Hard-fail the candidate if any required artifact is missing or malformed.
7. Compute a deterministic scalar score from artifacts.
8. Write candidate-level JSON and Markdown diagnostics.

The selected candidate is materialized into:

```text
data/prompts/journal_thought_only_gepa
```

The runner must refuse to overwrite an existing optimized profile unless the
operator passes an explicit overwrite flag.

## Optimization Proxy

Optimization uses a small real-eval thought-only QD proxy. It is not the final
acceptance matrix. It is the affordable inner loop for ranking prompt bundles.

Proxy mode:

```text
grid_quantile_pareto_journal_thought_k4
```

Concrete runtime configuration:

```text
search_mode: revolution_qd
qd_archive_type: grid_quantile
qd_descriptor_profile: journal_logic_ff_width_3d
qd_cell_mode: pareto_front
qd_max_elites_per_cell: 5
qd_operator_kind: single_thought_operator
representation_kind: thought_only
code_samples_per_thought: 4
repair_kind: none
population_size: 8
num_generations: 2
total_worker_slots: 8
max_active_problems: 4
max_workers_per_problem: 4
seed: 42
max_tokens: 128000
```

Default proxy problems:

```text
RTLLM/Prob015_multi_pipe_8bit
RTLLM/Prob045_alu
VerilogEval-Spec-to-RTL/Prob116_m2014_q3
VerilogEval-Spec-to-RTL/Prob153_gshare
```

The default proxy list is encoded in `PromptTuningConfig`, not in the scoring
function. Campaigns can replace it with:

```bash
--proxy-problem-file path/to/problems.yaml
```

The file may be either a top-level list of `{benchmark, problem}` rows or a
mapping with a `problems:` list. This keeps the default reproducible while
making other profiles and smaller/larger proxy sets explicit.

Each proxy problem must have at least one valid PPA sample for the candidate to
receive a nonzero score. This gate is intentionally strict: a prompt that
improves one problem while collapsing another is not useful for hard-subset
acceptance.

## Candidate Scoring

Candidate score is deterministic and derived only from written artifacts.

Inputs:

- problem summary JSON;
- `archive_summary.json`;
- `generation_log.jsonl` when present;
- `thought_evaluation.json` records;
- reference PPA metrics in the summary.

Hard failures:

- missing summary for any proxy problem;
- non-empty `worker_errors` or `errors` fields;
- malformed `thought_evaluation.json`;
- missing thought-evaluation required fields;
- missing prompt sections;
- duplicate prompt sections;
- unexpected prompt sections;
- budget/config mismatch when a validator requests exact budget checks;
- zero valid PPA samples for any proxy problem.

Aggregate metrics:

- functionality pass rate;
- synthesis/PPA pass rate;
- valid PPA sample count;
- number of designs with at least one valid PPA sample;
- average score;
- average PPA improvement from reference area/power/timing;
- QD coverage;
- occupied cells;
- QD score.

The scalar score is only for ranking candidates inside a campaign. It is not the
final publication claim. The final claim comes from the full hard-subset
validation gate below.

## Report Requirements

Reporting is a first-class artifact, not an afterthought.

Campaign report:

- optimizer settings;
- dependency versions;
- proxy settings;
- proxy problem list;
- baseline bundle hash;
- candidate table;
- selected candidate;
- selected prompt hash;
- failure reasons.

Candidate report:

- candidate id;
- bundle hash;
- changed sections relative to baseline;
- materialized profile path;
- run root;
- per-problem metrics;
- aggregate score;
- warnings and errors.

Final validation report:

- classic vs baseline thought-only vs optimized thought-only;
- full hard-subset problem count;
- aggregate metric table;
- optimized-vs-baseline deltas;
- strict pass/fail status;
- baseline artifact provenance.

Reports must be written as both JSON and Markdown.

## Final Hard-Subset Acceptance

The feature is not accepted after a successful proxy campaign. It is accepted
only after the optimized profile passes the full 13-problem hard-subset matrix.

Compare:

```text
classic
journal_thought_only + grid_quantile_pareto_journal_thought_k4
journal_thought_only_gepa + grid_quantile_pareto_journal_thought_k4
```

The optimized run must be fresh on the current branch. Baselines may be reused,
copied, or symlinked when their source commit and configuration match the gate.
The validation manifest must record source paths, source commits, and the reuse
rationale for every baseline artifact.

Strict quantitative gates:

- all 13 optimized problems must have at least one valid PPA sample;
- functionality pass rate must not regress beyond the paired stochastic gate;
- synthesis/PPA pass rate must not regress beyond the paired stochastic gate;
- valid PPA sample count must not regress beyond the paired stochastic gate;
- number of designs with at least one valid PPA sample must not regress;
- QD coverage must avoid catastrophic degradation;
- occupied cells must avoid catastrophic degradation;
- QD score must avoid catastrophic degradation;
- optimized mode must improve mean score or mean PPA improvement by at least
  `+1.0` percentage point versus the non-optimized thought-only baseline.

The initial validator implements a concrete no-regression gate:

- functionality and synthesis tolerate at most 5 percent relative regression;
- valid PPA sample count tolerates at most 10 percent relative regression;
- QD coverage, occupied cells, and QD score tolerate at most 25 percent
  relative regression;
- mean score or mean PPA improvement must improve by at least `+1.0` pp.

If later acceptance runs justify different stochastic thresholds, update this
document and the validator together in the same commit.

## Example

Suppose the seed profile produces this bundle:

```text
===== PROMPT: system/thought_spec =====
Return a thought JSON object...
===== END PROMPT =====

===== PROMPT: thought_only/generate_thought =====
Generate one architecture thought...
===== END PROMPT =====
```

GEPA proposes a candidate that changes the thought-generation section and the
single-thought operator section. The runner parses the full bundle, confirms all
five sections exist exactly once, and writes:

```text
prompt_profiles/journal_thought_only_gepa_cand_002/
  system/thought_spec.txt
  thought_only/generate_thought.txt
  thought_only/code/whole.txt
  evolve/single_thought_operator/thought.txt
  thought_only/repair/whole.txt
```

The proxy run then evaluates the four configured problems. If
`RTLLM/Prob045_alu` has zero valid PPA samples, the candidate score is zero
even if the other three problems improved. If all four problems have valid PPA
samples, the runner computes aggregate functionality, synthesis, valid-PPA,
score, PPA-improvement, and archive-health metrics and returns that scalar score
plus diagnostic side information to GEPA.

After the campaign, the selected bundle is materialized as
`data/prompts/journal_thought_only_gepa`. The final hard-subset validation then
compares `classic`, baseline thought-only, and optimized thought-only across all
13 hard-subset problems.

## CLI Surfaces

Run a campaign:

```bash
uv run --group prompt-tuning python scripts/run_gepa_prompt_tuning.py \
  --optimizer-model gpt-5.5 \
  --max-metric-calls 3 \
  --proxy-problem-file exp/gepa_proxy_problems.yaml
```

Regenerate a campaign report:

```bash
uv run --group prompt-tuning python scripts/report_gepa_prompt_tuning.py \
  --campaign-root exp/gepa_prompt_tuning/<timestamp>
```

Validate final acceptance:

```bash
uv run python scripts/validate_gepa_prompt_tuning_run.py \
  --classic-root exp/.../classic \
  --baseline-thought-root exp/.../grid_quantile_pareto_journal_thought_k4 \
  --optimized-thought-root exp/.../grid_quantile_pareto_journal_thought_k4_gepa \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir exp/.../gepa_validation
```

## Test Plan

Unit tests:

- `PromptStore` concat export/import round trip for `journal_thought_only`;
- bundle parser rejects missing sections;
- bundle parser rejects duplicate sections;
- bundle parser rejects unexpected sections;
- materialized candidate profile preserves the exact prompt key set;
- dependency preflight gives a clear failure when `dspy` or `gepa` is absent;
- synthetic evaluator path runs without network;
- scorer rejects missing summaries;
- scorer rejects worker errors;
- scorer rejects malformed thought JSON;
- scorer rejects zero-valid-PPA problems;
- validator enforces no-regression gates;
- validator enforces `+1pp` improvement gate;
- report generator writes stable JSON and Markdown.

Integration smokes:

- `uv sync --group prompt-tuning` creates a usable `.venv`;
- `python -c "import dspy, gepa"` succeeds inside that environment;
- baseline bundle candidate can be exported and materialized;
- a synthetic optimized bundle can be written to a temporary prompt profile;
- one small real-eval proxy run passes vLLM preflight and 128k context checks;
- report generator summarizes the proxy campaign.

Final acceptance:

- full 13-problem hard-subset matrix;
- strict validation JSON and Markdown;
- campaign report JSON and Markdown;
- selected prompt bundle hash;
- materialized `journal_thought_only_gepa` profile;
- baseline provenance manifest;
- quantitative pass/fail table.

## Implementation Checklist

Stage 1: worktree and dependency setup

- [x] Create `feat/journal-gepa-prompt-tuning` from latest
  `wip/journal-extension-2026`.
- [x] Add `prompt-tuning` dependency group.
- [x] Resolve and install `dspy` and `gepa` with `uv sync --group
  prompt-tuning`.
- [x] Add startup dependency preflight.

Stage 2: strict prompt bundle tooling

- [x] Define `journal_thought_only` required section list.
- [x] Export profile to one concat bundle.
- [x] Parse concat bundle with missing/duplicate/extra-section failures.
- [x] Materialize candidate bundle to a temporary prompt profile.
- [x] Verify materialized prompt keys are exact.

Stage 3: optimization runner

- [x] Add `scripts/run_gepa_prompt_tuning.py`.
- [x] Load `/workspace/.env`.
- [x] Preflight vLLM context length for real proxy runs.
- [x] Call GEPA with one `prompt_bundle` parameter.
- [x] Write candidate bundles, profiles, run roots, scores, and selected bundle.

Stage 4: scoring and reports

- [x] Score candidates from real artifacts.
- [x] Hard-fail malformed or incomplete artifacts.
- [x] Add campaign JSON and Markdown.
- [x] Add candidate JSON and Markdown.
- [x] Add report regeneration script.

Stage 5: final validator

- [x] Add `scripts/validate_gepa_prompt_tuning_run.py`.
- [x] Compare classic, baseline thought-only, and optimized thought-only.
- [x] Enforce full 13-problem hard-subset gate.
- [x] Enforce no-regression and `+1pp` improvement gates.

Stage 6: real validation

- [ ] Run one real proxy campaign.
- [ ] Inspect candidate reports and selected bundle hash.
- [ ] Run optimized full hard-subset matrix.
- [ ] Reuse matching baselines with provenance recorded.
- [ ] Generate final validation JSON/Markdown.
- [ ] Confirm all strict quantitative gates pass.

## Clean-Code Guidance

Implementation should be simple enough to skim:

1. Write straightforward code with visible data flow.
2. Keep configs small and typed.
3. Prefer required arguments over optional state.
4. Use asserts when loading known structured data.
5. Fail fast on missing files, missing deps, malformed bundles, and bad
   summaries.
6. Do not add fake optimizer fallback behavior.
7. Do not hide errors behind broad `try/except` blocks.
8. Keep argument count low.
9. Do not add broad abstractions before duplication proves they are needed.
10. Bias toward fewer lines.
11. Use early returns when they make the branch obvious.
12. Do not make arguments optional if the caller always needs them.
13. Do not pass override dictionaries unless strictly necessary.
14. Remove changes that are not required by this feature.

## Commit Guidance

Use atomic commits. Each commit should address one logical change.

Commit subjects should follow Conventional Commits when possible:

```text
feat(prompt): add GEPA bundle tuning runner
test(prompt): cover strict prompt bundle parsing
docs(prompt): specify GEPA prompt tuning gates
```

Rules:

1. Separate subject from body with a blank line.
2. Keep the subject near 50 characters.
3. Capitalize the subject.
4. Do not end the subject with a period.
5. Use imperative mood.
6. Wrap the body at 72 characters.
7. Explain what and why, not line-by-line how.

After every commit, inspect the latest commit message and confirm there are no
literal `\n` artifacts, missing signoff if the branch requires one, or malformed
subjects.
