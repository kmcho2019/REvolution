# Diff Prompt Optimization Suite

## Purpose

This suite is designed for future prompt-search/optimization workflows targeting diff mode.
It provides:

- A self-contained hard-case dataset.
- A reproducible runner that queries an LLM and applies diffs with the current engine implementation.
- Machine-readable scoring (`objective_score`) and pass/fail metrics for optimizer loops.

Primary artifacts:

- Suite file: `data/diff_prompt_suite/diff_prompt_suite_v1.json`
- Runner: `scripts/run_diff_prompt_suite.py`

## What It Measures

Per attempt, the harness evaluates:

- strict format compliance (`format_ok`)
- parsed mode compliance (`mode_ok`, must be `diff`)
- diff apply outcome (`apply_ok`)
- semantic checks on applied result (`must_contain`/`must_not_contain`)
- safe rejection behavior for ambiguous unsafe cases (`safe_reject_ok`)

Each attempt gets:

- `hard_pass` (boolean, case-behavior aware)
- `objective_score` (float in `[0,1]`)

Default objective weights:

- `format_ok`: `0.20`
- `mode_ok`: `0.10`
- `behavior_ok`: `0.40`
- `terminal_ok`: `0.30`

`behavior_ok` means:

- `apply_success`: apply + semantic success
- `apply_or_safe_reject`: apply+semantic success OR allowed safe reject
- `safe_reject_only`: allowed safe reject

## Suite Schema

Top-level:

```json
{
  "suite_name": "diff_prompt_optimization_suite_v1",
  "version": 1,
  "description": "...",
  "cases": [ ... ]
}
```

Per case:

```json
{
  "id": "unique_case_id",
  "description": "human-readable description",
  "tags": ["rtllm", "hard"],
  "file_to_edit": "/tmp/path.sv",
  "original_file": "full original text",
  "change_request": "requested modification",
  "expected_behavior": "apply_success|apply_or_safe_reject|safe_reject_only",
  "must_contain": ["required substrings after apply"],
  "must_not_contain": ["forbidden substrings after apply"],
  "safe_reject_reason_codes": ["ambiguous_fuzzy_match"]
}
```

## Running The Suite

Baseline run (default prompt profile `data/prompts/default/system/diff.txt`):

```bash
python scripts/run_diff_prompt_suite.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --vllm_min_model_len 128000 \
  --repeat_per_case 2
```

Run with a candidate prompt file:

```bash
python scripts/run_diff_prompt_suite.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --vllm_min_model_len 128000 \
  --system_prompt_file /path/to/candidate_diff_prompt.txt \
  --repeat_per_case 2
```

Run a filtered subset:

```bash
python scripts/run_diff_prompt_suite.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --case_ids quote_escape rtllm_fifo_param_update \
  --tags hard rtllm
```

## Outputs

Each run writes:

- `exp/diff_prompt_suite/<timestamp>/results.json`
- `exp/diff_prompt_suite/<timestamp>/results.md`

Important fields in `results.json`:

- `summary.objective_score`
- `summary.hard_pass_pct`
- `summary.by_case`
- `summary.reason_code_counts`
- `attempts[]` for per-attempt diagnostics
- `prompt_source` and `prompt_sha256` for traceability

## Cross-Run Summarizer

Use `scripts/summarize_diff_prompt_suite.py` to aggregate many suite runs into an easy-to-visualize leaderboard.

```bash
python scripts/summarize_diff_prompt_suite.py \
  --results_root exp/diff_prompt_suite \
  --output_dir exp/diff_prompt_suite/summary
```

Generated artifacts:

- `summary.json`: machine-readable aggregate summary
- `summary.md`: human-readable leaderboard and case difficulty table
- `runs.csv`: per-run flattened metrics
- `prompt_groups.csv`: grouped metrics by `prompt_sha256`
- `case_stats.csv`: cross-run per-case averages (hard-pass/apply/safe-reject/objective)
- `case_matrix.csv`: run-by-case hard-pass matrix for plotting/visualization

The markdown summary includes:

- run leaderboard ranked by `objective_score` then `hard_pass_pct`
- prompt leaderboard for prompt-candidate comparisons
- case difficulty table with visual pass-rate bars
- aggregated reason-code counts

If all input runs are skipped (for example unreachable vLLM in CI), the
summarizer now emits a valid zero-run `summary.json`/`summary.md` plus empty
CSVs, rather than failing.

## Optimizer Integration

You can treat:

- objective: `summary.objective_score` (maximize)
- constraints: minimum `summary.hard_pass_pct`, cap on `strict_parse_error` or selected failure reasons

Typical loop:

1. Generate candidate diff system prompt.
2. Save candidate prompt to a temporary file.
3. Run `run_diff_prompt_suite.py --system_prompt_file <candidate>`.
4. Read `results.json`.
5. Feed `objective_score` and diagnostics back to optimizer.

## First Optimization Loop Runner

Use `scripts/run_diff_prompt_optimization_loop.py` to evaluate a batch of
prompt candidates and generate a ranked leaderboard in one command.

```bash
python scripts/run_diff_prompt_optimization_loop.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --system_prompt_dir data/prompts/candidates \
  --system_prompt_glob '*.txt' \
  --repeat_per_case 3 \
  --include_profile_prompt
```

Outputs:

- `results.json`: per-candidate run status and objective metrics
- `results.md`: ranked candidate table and selected best prompt
- candidate raw suite runs under `candidate_runs/`

Latest live example:

- `exp/diff_prompt_optimization_loop_premerge_multi/20260224_131426`
- candidates: default profile + two file candidates
- selected best: `cand_strict_anchor` (`objective_score=0.8833`, `hard_pass_pct=83.33%`)

## Notes

- This suite evaluates prompt + diff-apply pipeline behavior, not full RTL benchmark correctness.
- It is intentionally self-contained and does not require synthesis/simulation tools.
- vLLM preflight checks are included and default to skip with artifact output when unreachable.
