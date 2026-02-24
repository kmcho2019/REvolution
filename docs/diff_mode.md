# Diff Mode Guide

## Overview

REvolution supports two offspring-generation modes:

- `whole`: generate a full replacement RTL file.
- `diff`: generate structured edits and patch the parent file.

Diff mode is intended to reduce token usage and improve iteration speed on long files by avoiding full-file regeneration.

## Prompt Source Of Truth

Mode-specific system prompts are file-backed via `PromptStore`:

- `data/prompts/<profile>/system/whole.txt`
- `data/prompts/<profile>/system/diff.txt`

With the default profile this is:

- `data/prompts/default/system/whole.txt`
- `data/prompts/default/system/diff.txt`

`run_evolution.py`/`EoHEngine` and `run_diff_mode_diagnostics.py` now load these files first and only fall back to internal defaults if a prompt file is missing.

## Output Contract (`eoh_v1`)

Diff responses must be a single JSON object:

```json
{
  "format": "eoh_v1",
  "mode": "diff",
  "thought": "short rationale",
  "code": {
    "edits": [
      {
        "file": "path/to/file.sv",
        "hunks": [
          { "search": "exact old text\n", "replace": "new text\n" }
        ]
      }
    ]
  }
}
```

Validation highlights:

- `code.edits` must be a non-empty list.
- strict mode canonicalizes tolerated variants (`top-level edits`, inferred `mode`) into `code.edits`.
- single-file edit payloads are required in strict diff parsing.
- each edit needs non-empty `file` and non-empty `hunks`.
- each hunk needs string `search` and `replace`.
- both `search` and `replace` cannot be empty simultaneously.

Legacy fenced SEARCH/REPLACE format is still accepted for compatibility.

## Diff Apply Policies

`--diff_apply_policy` controls patch strictness:

- `strict`: exact unique match only.
- `hybrid` (default): deterministic 3-phase pipeline (exact -> whitespace-normalized -> guarded fuzzy).
- `fuzzy`: same pipeline with permissive fallback intent for difficult matches.

Additional controls:

- `--diff_similarity_threshold` (default `0.86`)
- `--diff_fuzzy_margin` (default `0.03`)

These gates reduce incorrect patch application when multiple fuzzy candidates are near-tied. Ambiguous fuzzy ties are rejected with explicit `reason_code` diagnostics.

The JSON applier also enforces:

- single-target-file application (rejects cross-file edits),
- preflight overlap detection for exact-unique hunk anchors (`overlap_conflict`),
- atomic hunk application with per-hunk diagnostics.

## Token and Prompt Controls

Diff mode has independent budgeting knobs:

- `--diff_max_tokens` (default `1024`): completion cap for diff offspring requests.
- `--diff_compact_context` (default enabled): omits duplicated parent code blocks from strategy context while still providing the editable source payload.
- LLM empty-response guard (`LLMInterface.max_empty_response_attempts`, default `2`): caps blank completion retries and returns a structured format failure (`empty-response-retries-exhausted`) instead of burning full retry budgets.

Use these knobs to lower token spend relative to whole mode while preserving context quality.

## Diagnostics and Failure Artifacts

When diff application fails, candidate status is `failed_diff` and artifacts include:

- `*_diff_apply_error.json`: raw diff payload + structured diagnostics.
  - `reason_code`
  - `reason`
  - `phase` (`json`, `legacy`, or specific parsing/matching phases)
  - `matching_policy`
  - `parent_sha256`
  - per-hunk diagnostics (match stage, threshold/margin details, etc.)
- `diff.txt` / `diff.json` (if available): persisted edit payloads.

Generation logs and summaries also accumulate:

- diff attempts/failed/pass-rate,
- diff apply phase distributions,
- diff failure reason histograms,
- candidate counts by generation mode,
- tokens per successful candidate by mode (estimated),
- mode-level token-use estimates.

## Benchmarking Whole vs Diff

Use:

```bash
python scripts/run_diff_mode_benchmark.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --seeds 1 2
```

Outputs:

- `results.json`: machine-readable aggregate comparison.
- `results.md`: summary table and deltas.
- `diff_failure_catalog.json`: grouped failure reasons with examples.

Default benchmark matrix uses the renewal-plan hard pack:

- RTLLM hard set (6): `Prob026_asyn_fifo`, `Prob033_freq_divbyfrac`, `Prob034_freq_divbyodd`, `Prob032_freq_divbyeven`, `Prob018_float_multi`, `Prob010_radix2_div`
- VerilogEval hard set (6): `Prob149_ece241_2013_q4`, `Prob095_review2015_fsmshift`, `Prob099_m2014_q6c`, `Prob062_bugs_mux2`, `Prob155_lemmings4`, `Prob156_review2015_fancytimer`
- CVDP medium set (6): deterministically selected from `cid002/cid003` by largest `input` prompt length.

Use `--selection_profile baseline_hard` to revert to baseline-pass-rate-driven selection.

## Real-LLM Diagnostics Script

Use `scripts/run_diff_mode_diagnostics.py` to stress diff robustness with repeated real-LLM calls across curated failure-prone prompt cases (escaping, duplicate anchors, minimal context, long-file edits).

```bash
python scripts/run_diff_mode_diagnostics.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --repeat_per_case 3
```

Outputs:

- `results.json`: per-attempt parse/apply outcomes and diagnostics.
- `results.md`: summary pass rates and failure taxonomy.

## Prompt Optimization Suite

For prompt-search workflows, use `scripts/run_diff_prompt_suite.py` with:

- self-contained suite cases in `data/diff_prompt_suite/diff_prompt_suite_v1.json`
- objective scoring (`objective_score`) for optimizer loops
- per-case hard-pass and safe-reject diagnostics

Guide: `docs/diff_prompt_optimization_suite.md`.
Cross-run aggregation: `scripts/summarize_diff_prompt_suite.py`.
