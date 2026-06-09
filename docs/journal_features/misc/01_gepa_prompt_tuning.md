# Misc 01: GEPA Prompt Tuning

Status: scaffolded implementation; real validation still pending.

This feature adds a prompt-tuning framework for `PromptStore` profiles using
DSPy and GEPA. The first target is `data/prompts/journal_thought_only`,
because the Feature 06 thought-only path has one main thought operator plus an
optional repair prompt and is small enough to optimize as one coherent text
artifact. The implementation must stay general enough to tune other prompt
profiles after the first path is proven.

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

DSPy and GEPA are normal project dependencies, not an optional install group:

```bash
uv sync
```

The project dependency list includes:

```text
dspy>=2.6.27
gepa>=0.1.1
```

The runner has the same conceptual split as the DSPy GEPA examples:

1. config: command-line flags set optimizer model, temperature, token budget,
   proxy problems, and RTL/QD worker budget;
2. dataset/task surface: the prompt bundle is the candidate, and proxy RTL/QD
   problems are loaded from `PromptTuningConfig` or `--proxy-problem-file`;
3. fitness function: candidate bundles are materialized, evaluated, scored,
   and returned to GEPA with diagnostic side information;
4. optimization loop: GEPA proposes new prompt bundles from the score and
   diagnostics.

In the currently resolved package set, DSPy exposes `dspy.LM` but does not
expose `dspy.GEPA`. The active optimizer path therefore imports
`gepa.optimize_anything`, configures a `dspy.LM`, calls `dspy.configure(lm=lm)`,
and passes a small DSPy-backed reflection callable to GEPA. If a later resolved
DSPy package exposes `dspy.GEPA`, the optimizer call can be swapped without
changing the bundle parser, materializer, proxy evaluator, scorer, or final
validator.

OpenAI credentials are loaded from:

```text
/workspace/.env
```

The default optimizer settings are:

```text
optimizer_model: openai/gpt-5.5
optimizer_temperature: 1.0
optimizer_max_tokens: 32000
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
optimizer_model: openai/gpt-5.5
optimizer_temperature: 1.0
optimizer_max_tokens: 32000
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

Optimization uses a real-eval thought-only QD proxy. It is not the final
acceptance matrix, but it must be large enough that the zero-valid-PPA hard
gate measures prompt quality rather than an under-budgeted search.

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
population_size: 20
num_generations: 5
total_worker_slots: 8
max_active_problems: 4
max_workers_per_problem: 4
seed: 42
max_tokens: 128000
```

The runner exposes these as CLI knobs:

```bash
--proxy-population-size 20
--proxy-num-generations 5
--proxy-total-worker-slots 8
--proxy-max-active-problems 4
--proxy-max-workers-per-problem 4
--proxy-qd-grid-quantile-warmup-successes 20
```

The default budget intentionally matches the hard-subset evolutionary budget.
A 2026-06-07 baseline budget sweep on the four default proxy problems showed
that cheaper budgets were not reliable enough for the strict zero-valid-PPA
candidate gate:

| Budget | Candidate budget | Status | Valid PPA | Designs with PPA | Failure |
|:---|---:|:---|---:|---:|:---|
| `population_size=8`, `num_generations=2` | 24 | failed | not used as default | fewer than 4 | `Prob116_m2014_q3` had zero valid PPA in the prior GEPA run |
| `population_size=16`, `num_generations=4` | 80 | failed | 34 | 3 | `Prob153_gshare` had zero valid PPA |
| `population_size=20`, `num_generations=5` | 120 | ok | 58 | 4 | none |

The passing sweep root was:

```text
exp/gepa_budget_sweep/20260607_095900_gepa_budget_sweep
```

This budget is expensive for GEPA inner-loop use, but the smaller tested
budgets converted stochastic under-search into candidate score zero. If a
future campaign needs faster iteration, reduce the proxy problem set explicitly
or run a new budget sweep and record the evidence before changing the default.

### Quick Inner-Loop Proxy

GEPA needs many prompt proposals to move beyond one-off prompt perturbations.
The default four-problem, `20 x 5` proxy is validation-grade, but it is too
slow for exploratory GEPA iteration. For faster optimizer development, use the
explicit quick proxy config:

```text
data/configs/gepa_prompt_tuning_quick_proxy_problems.yaml
```

Recommended runner settings:

```bash
--proxy-problem-file data/configs/gepa_prompt_tuning_quick_proxy_problems.yaml
--proxy-population-size 8
--proxy-num-generations 1
--proxy-total-worker-slots 8
--proxy-max-active-problems 2
--proxy-max-workers-per-problem 4
--proxy-qd-grid-quantile-warmup-successes 8
```

The selected problems are:

```text
RTLLM/Prob015_multi_pipe_8bit
RTLLM/Prob041_traffic_light
```

This pair was chosen after probing smaller real-eval budgets on 2026-06-08:

| Probe | Problems | Status | Evidence |
|:---|:---|:---|:---|
| `12 x 3` | `Prob015`, `Prob045`, `Prob041`, `Prob116` | stopped | too slow for GEPA inner-loop use |
| `12 x 3` | `Prob015`, `Prob045` | stopped | still too slow for quick iteration |
| `8 x 1` | `Prob015`, `Prob041` | accepted | finished in `247.54s`, status `ok`, `8` valid PPA samples, `2` designs with valid PPA, functionality pass rate `1.0`, synthesis pass rate `1.0` |

Probe root:

```text
exp/gepa_proxy_probe/20260608_120541_gepa_quick_proxy_probe_2p_8x1
```

`Prob015_multi_pipe_8bit` is a medium sequential design with reliable prior
valid-PPA generation and a meaningful area/power/timing target.
`Prob041_traffic_light` is a smaller control design that completed quickly
while still producing valid PPA and a clear PPA-improvement signal.

This quick proxy is not final acceptance. It is an optimizer inner loop for
more GEPA iterations per wall-clock hour. The observed quick probe had useful
valid-PPA, functionality, synthesis, score, area, power, and timing signals,
but QD coverage and occupied-cell metrics were not informative in the one
generation budget. Final acceptance still requires the full hard-subset matrix
and the strict validation gates below.

### Diverse RTLLM Quick Proxy

When the two-design proxy is too narrow for PPA-oriented prompt tuning, use the
RTLLM-diverse quick proxy:

```text
data/configs/gepa_prompt_tuning_rtllm_diverse_quick_proxy_problems.yaml
```

Recommended runner settings:

```bash
--proxy-problem-file data/configs/gepa_prompt_tuning_rtllm_diverse_quick_proxy_problems.yaml
--proxy-population-size 8
--proxy-num-generations 1
--proxy-total-worker-slots 12
--proxy-max-active-problems 3
--proxy-max-workers-per-problem 4
--proxy-qd-grid-quantile-warmup-successes 8
```

The selected problems are:

```text
RTLLM/Prob015_multi_pipe_8bit
RTLLM/Prob041_traffic_light
RTLLM/Prob045_alu
```

This proxy covers sequential pipeline behavior, control/FSM behavior, and a
datapath-heavy ALU. A mixed four-design probe also tried
`VerilogEval-Spec-to-RTL/Prob116_m2014_q3`, but that design produced zero
valid PPA samples at the `8 x 1` budget and therefore failed the hard scorer
gate. VerilogEval coverage should be retained for higher-budget validation, not
for this fast inner loop.

Accepted probe evidence from 2026-06-08:

| Proxy | Runtime | Status | Valid PPA | Designs with PPA | Func | Synth | Avg PPA |
|:---|---:|:---|---:|---:|---:|---:|---:|
| RTLLM-diverse `8 x 1` | `452.98s` | `ok` | `10` | `3` | `0.8333` | `0.8333` | `0.2180` |

Accepted probe root:

```text
exp/gepa_prompt_tuning/20260608_163625_gepa_rtllm_diverse_proxy_probe/20260608_163635
```

This is slower than the two-design quick proxy but gives GEPA a more diverse
PPA and correctness signal. Use it for prompt searches intended to improve PPA,
then validate the selected prompt on the full hard subset against classic and
the unoptimized thought-only baseline.

Default proxy problems live in:

```text
data/configs/gepa_prompt_tuning_proxy_problems.yaml
```

Current default rows:

```text
RTLLM/Prob015_multi_pipe_8bit
RTLLM/Prob045_alu
VerilogEval-Spec-to-RTL/Prob116_m2014_q3
VerilogEval-Spec-to-RTL/Prob153_gshare
```

The default proxy list is loaded from YAML, not hard-coded in the runner or
scoring function. Campaigns can replace it with:

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

GEPA also receives a multi-objective `scores` side-info dictionary for Pareto
tracking. These scores are all higher-is-better and prioritize:

1. every proxy problem having at least one valid PPA sample;
2. aggregate PPA improvement and average score;
3. separate area, power, and effective-clock-period improvements;
4. functionality, synthesis, and valid-PPA count as tie-breakers;
5. QD health metrics when the short proxy budget produces meaningful archive data.

The scalar score remains the final ranking value. The side-info scores give
GEPA more structure during reflection and candidate selection without allowing
a candidate that loses all valid PPA on one problem to pass the hard gate.

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

- average PPA improvement from reference area/power/timing;
- average score;
- average area, power, and clock improvement;
- functionality pass rate;
- synthesis/PPA pass rate;
- valid PPA sample count;
- number of designs with at least one valid PPA sample;
- QD coverage;
- occupied cells;
- QD score.

The scalar ranking is PPA-first after the hard eligibility gate. A candidate
with at least one valid PPA sample on every proxy problem should beat a more
valid-looking candidate when it has materially better PPA and score metrics.
Functionality, synthesis, and valid-PPA count remain useful diagnostics and
tie-breakers, but they should not dominate prompt selection once the candidate
is viable.

The scalar score is only for ranking candidates inside a campaign. It is not
the final publication claim. The final claim comes from the full hard-subset
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
score, PPA-improvement, and archive-health metrics, ranks viable candidates
primarily by PPA/score improvement, and returns that scalar score plus
diagnostic side information to GEPA.

After the campaign, the selected bundle is materialized as
`data/prompts/journal_thought_only_gepa`. The final hard-subset validation then
compares `classic`, baseline thought-only, and optimized thought-only across all
13 hard-subset problems.

## CLI Surfaces

Run a campaign:

```bash
uv run python scripts/run_gepa_prompt_tuning.py \
  --optimizer-model openai/gpt-5.5 \
  --max-metric-calls 3 \
  --proxy-problem-file exp/gepa_proxy_problems.yaml
```

Regenerate a campaign report:

```bash
uv run python scripts/report_gepa_prompt_tuning.py \
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
- direct imports fail immediately if `dspy` or `gepa` is absent;
- synthetic evaluator path runs without network;
- scorer rejects missing summaries;
- scorer rejects worker errors;
- scorer rejects malformed thought JSON;
- scorer rejects zero-valid-PPA problems;
- validator enforces no-regression gates;
- validator enforces `+1pp` improvement gate;
- report generator writes stable JSON and Markdown.

Integration smokes:

- `uv sync` creates a usable `.venv`;
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
- [x] Add `dspy` and `gepa` to default project dependencies.
- [x] Resolve and install `dspy` and `gepa` with `uv sync`.
- [x] Use direct package imports for fail-fast startup behavior.

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
