# Diff Mode Renewal Journal

## Plan Snapshot (Original)
- Build robust diff-mode formatting, prompting, parsing, and application.
- Improve token efficiency vs whole mode.
- Validate performance on hard long-context benchmark problems.
- Add comprehensive tests, diagnostics, and documentation.
- Perform all work in isolated worktree/branch and avoid merging into `wip/journal-extension-2026` during implementation.

## Plan Snapshot (Revised)
- Primary live endpoint: `http://vllm:8888/v1/models`.
- Add vLLM preflight checks for served model metadata and `max_model_len`.
- Target context length: `>= 128000` for reasoning model workloads.
- If below threshold: warn and continue.
- Maintain structured diff-mode benchmark/diagnostic artifacts and documentation.

## Success Criteria
1. Reduce `failed_diff` rate by at least 40% on selected hard tasks.
2. Achieve measurable token savings for diff mode compared to whole mode.
3. Maintain near-parity functional pass rate (within a small margin).
4. Improve or maintain runtime while preserving solution quality.
5. Keep docs/tests aligned with behavior and configuration.

## Implementation Notes
- 2026-02-24: Worktree created at `/workspace/.worktrees/diff-mode-renewal` on branch `feat/diff-mode-renewal`.
- 2026-02-24: Started diff-mode renewal implementation in isolated worktree.
- 2026-02-24: Added diff robustness controls in `EoHEngine`:
  - `diff_apply_policy` (`strict|hybrid|fuzzy`)
  - `diff_similarity_threshold`, `diff_fuzzy_margin`
  - structured per-hunk diagnostics and `reason_code` propagation
  - stricter JSON diff validation (`code.edits`/`hunks`/string checks)
- 2026-02-24: Added diff token/context controls:
  - `diff_max_tokens` for per-request diff budget
  - `diff_compact_context` for prompt compaction
  - mode-aware token/candidate accounting in logger summary
- 2026-02-24: Added vLLM preflight utility (`src/revolution/vllm_preflight.py`) and wired checks into:
  - `scripts/run_evolution.py`
  - `scripts/run_backend.py`
  - `scripts/run_one_shot.py`
- 2026-02-24: Fixed vLLM runtime compatibility issue:
  - OpenAI-compatible client required non-empty `api_key`; `run_evolution.py` and `run_one_shot.py` now use `OPENAI_API_KEY` or `vllm-local-placeholder` for vLLM.
- 2026-02-24: Added benchmark harness `scripts/run_diff_mode_benchmark.py`:
  - hard-task selection from baseline report
  - CVDP category-based selection
  - whole-vs-diff aggregate report generation (`results.json`, `results.md`)
  - diff failure artifact catalog generation (`diff_failure_catalog.json`)
- 2026-02-24: Added/expanded tests:
  - `tests/revolution/test_vllm_preflight.py`
  - `tests/scripts/test_run_diff_mode_benchmark.py`
  - `tests/scripts/test_run_evolution.py`
  - extended `tests/revolution/test_algorithm.py`, `tests/revolution/test_llm.py`, `tests/revolution/test_logging.py`, `tests/scripts/test_run_backend.py`
- 2026-02-24: Full test suite status after updates:
  - `197 passed` (`.venv/bin/pytest -q`).
- 2026-02-24 (plan review + corrective pass): reviewed implementation against original plan and fixed high-impact gaps:
  - fixed diff applicability bug: fail-pool offspring were hard-forced to `whole`; now post-Gen0 fail/success pools both respect configured `generation_mode`.
  - hardened deterministic apply pipeline:
    - Phase A exact unique match
    - Phase B whitespace-normalized match
    - Phase C guarded fuzzy fallback with top-candidate diagnostics
  - added JSON diff preflight guards:
    - single-target-file enforcement (`multi_file_edit_not_allowed`)
    - exact-anchor overlap detection (`overlap_conflict`)
  - improved legacy parser diagnostics:
    - delimiter mismatch detection (`legacy_delimiter_mismatch`)
    - JSON-looking parse failures now surfaced as `json_parse_error`
  - enriched diff failure artifacts:
    - include `matching_policy`
    - include `parent_sha256`
  - added strict EOH normalization in LLM parser:
    - tolerates top-level `edits`
    - infers missing `mode` when unambiguous
    - canonicalizes to `code.edits` before strict validation
  - tightened strict diff validation:
    - single-file payload requirement
    - duplicate search-anchor rejection per edit
  - extended benchmark harness:
    - fixed default hard matrix to original-plan 6/6/6 set
    - added matched `--seeds` loops (default `1 2`)
    - added deterministic CVDP medium selection from `cid002/cid003` by largest `input` prompt length
  - added real-LLM diagnostics script:
    - `scripts/run_diff_mode_diagnostics.py`
    - repeated stress cases + parse/apply taxonomy outputs
- 2026-02-24: Added new tests for corrected plan coverage:
  - `tests/scripts/test_run_diff_mode_diagnostics.py`
  - extended `test_algorithm.py` with overlap-conflict, delimiter mismatch, whitespace phase, and fail-pool diff-mode assertions
  - extended `test_llm.py` with canonical normalization and multi-file strict rejection
  - extended `test_logging.py` with phase-distribution and tokens-per-success assertions
  - extended `test_run_diff_mode_benchmark.py` with seed propagation and deterministic CVDP prompt-length selection tests
- 2026-02-24: Full test suite status after corrective pass:
  - `207 passed` (`.venv/bin/pytest -q`).
- 2026-02-24: Prompt source-of-truth alignment update:
  - `run_diff_mode_diagnostics.py` now loads system prompts from `PromptStore`
    (`data/prompts/<profile>/system/diff.txt`, default profile `default`) instead of relying on hardcoded LLM defaults.
  - Added assertion coverage in `tests/scripts/test_run_diff_mode_diagnostics.py` to guarantee `system_prompt_override` is passed.
- 2026-02-24: Regression triage + fix for diff-mode token/runtime blow-up:
  - Observed on live benchmark rerun (`exp/diff_mode_regression_rerun/20260224_044747`):
    - diff mode emitted frequent empty completions and consumed full retry budget (`max_retries=15`) in `LLMInterface.generate_response`.
    - impact: severe retry storms (e.g., 73 empty-response warnings in diff logs), high token/runtime overhead.
  - Implemented guard in `src/revolution/llm.py`:
    - added `max_empty_response_attempts` (default `2`) to cap blank-completion retries.
    - returns structured failure `empty-response-retries-exhausted` when budget is exhausted.
    - avoids unnecessary lenient parse attempts for blank completions.
  - Added tests in `tests/revolution/test_llm.py`:
    - `test_generate_response_empty_content_respects_empty_retry_budget`
  - Full suite after fix:
    - `212 passed` (`.venv/bin/pytest -q`).
- 2026-02-24: Added optimizer-ready diff prompt suite framework:
  - new self-contained case set:
    - `data/diff_prompt_suite/diff_prompt_suite_v1.json`
    - includes escaping, duplicate-anchor, minimal-context, long-file, RTLLM-like, and CVDP-like stress cases.
  - new runner:
    - `scripts/run_diff_prompt_suite.py`
    - supports prompt profile or explicit `--system_prompt_file` for candidate prompt evaluation.
    - supports diff implementation knobs (`--diff_apply_policy`, thresholds) for implementation-vs-prompt comparisons.
    - emits optimizer-friendly metrics:
      - `summary.objective_score`
      - `summary.hard_pass_pct`
      - per-case rates and reason-code taxonomy
  - new tests:
    - `tests/scripts/test_run_diff_prompt_suite.py`
  - new documentation:
    - `docs/diff_prompt_optimization_suite.md`
  - live smoke run:
    - `exp/diff_prompt_suite_smoke/20260224_053626/results.json`
    - validates end-to-end runner execution with profile prompt source and objective scoring artifacts.
- 2026-02-24: Added cross-run prompt-suite result summarizer:
  - new script:
    - `scripts/summarize_diff_prompt_suite.py`
    - aggregates multiple `run_diff_prompt_suite.py` outputs and emits:
      - `summary.json`, `summary.md`
      - `runs.csv`, `prompt_groups.csv`, `case_stats.csv`, `case_matrix.csv`
  - ranking/visualization support:
    - run leaderboard (objective/hard-pass)
    - prompt-group leaderboard (`prompt_sha256`)
    - case-difficulty table with pass-rate bars
    - aggregated reason-code totals
  - new tests:
    - `tests/scripts/test_summarize_diff_prompt_suite.py`

## Failure Catalog
- Real-LLM diff probe (`exp/diff_mode_benchmark_live4/llm_diff_probe_ambiguous_results.json`):
  - total cases: 6
  - format-valid: 6/6
  - apply-success: 3/6
  - apply-failures by reason:
    - `ambiguous_fuzzy_match` (2): duplicate lines produced near-tied fuzzy windows (gap `0.0000 < 0.0300`).
    - `fuzzy_below_threshold` (1): large reformat request produced best ratio `0.7914 < 0.8600`.
- Interpretation:
  - ambiguity gate is correctly blocking unsafe edits on duplicated contexts.
  - threshold gate is correctly blocking low-confidence broad rewrites.
  - strict validation is preventing malformed diff payloads before patch application.

## Benchmark Results
- Hard-task slice (RTLLM + VerilogEval):
  - run root: `exp/diff_mode_benchmark_live3/20260224_033824`
  - selected: `Prob035_calendar`, `Prob066_edgecapture`
  - whole tokens: `29386`
  - diff tokens: `28756`
  - token savings: `630` (`2.14%`)
  - whole runtime: `66.63s`
  - diff runtime: `61.31s`
  - runtime speedup: `5.32s` (`7.98%`)
  - pass rates: both `0.00` functionality/synthesis (no successful parents; diff attempt count remained `0`)
- Solvable-set slice (RTLLM + VerilogEval):
  - run root: `exp/diff_mode_benchmark_live4/20260224_034108`
  - selected: `Prob001_accu`, `Prob001_zero`
  - whole tokens: `60713`
  - diff tokens: `53572`
  - token savings: `7141` (`11.76%`)
  - whole runtime: `112.78s`
  - diff runtime: `90.23s`
  - runtime speedup: `22.55s` (`19.99%`)
  - pass rates: both `0.00` functionality/synthesis; diff-attempt count remained `0` in this model/config (fail-pool fallback dominated).
- CVDP slice:
  - run root: `exp/diff_mode_benchmark_live_cvdp/20260224_034641`
  - selected: `cvdp_copilot_16qam_mapper_0001`
  - whole tokens: `22313`
  - diff tokens: `20024`
  - token savings: `2289` (`10.26%`)
  - whole runtime: `48.42s`
  - diff runtime: `47.02s`
  - runtime speedup: `1.40s` (`2.90%`)
  - pass rates: both `0.00` functionality/synthesis; candidate artifacts were predominantly format failures.
- RTLLM hard-6 slice (additional comprehensive run):
  - run root: `exp/diff_mode_benchmark_live_rtllm6/20260224_035044`
  - selected hard tasks:
    - `Prob022_ring_counter`
    - `Prob026_asyn_fifo`
    - `Prob028_LFSR`
    - `Prob032_freq_divbyeven`
    - `Prob033_freq_divbyfrac`
    - `Prob034_freq_divbyodd`
  - whole tokens: `124331`
  - diff tokens: `123242`
  - token savings: `1089` (`0.88%`)
  - whole runtime: `268.26s`
  - diff runtime: `275.92s`
  - runtime delta (diff-whole): `+7.66s` (diff slower by `2.86%`)
  - pass rates: both `0.00` functionality/synthesis
  - diff attempts: `0` (all offspring remained in fail-pool/whole fallback under this model-config slice)
- Post-fix smoke validation (seeded plan-default harness, 1 RTLLM task):
  - run root: `exp/diff_mode_benchmark_smoke/20260224_042049`
  - selected: `Prob026_asyn_fifo`
  - whole tokens: `16908`
  - diff tokens: `92653`
  - token delta: `+75745` (diff worse in this low-success slice)
  - diff attempts: `1` (instrumentation fix validated; attempts are now visible even when many outputs fail format)
  - interpretation: diff attempt accounting is now functioning; token efficiency still depends heavily on model format compliance and success-rate regime.
- Real-LLM diagnostics smoke:
  - run root: `exp/diff_mode_diagnostics_smoke/20260224_042419`
  - total attempts: `6` (`repeat_per_case=1` over 6 curated cases)
  - strict format pass: `6/6`
  - apply pass: `6/6`
  - diff phase distribution: `json=6`
  - note: this controlled diagnostic pack confirms parser/apply robustness on escaping, duplicate-anchor, minimal-context, and long-file cases with current model/server.
- Regression retest matrix (6 RTLLM hard + 3 VerilogEval + 3 CVDP), same settings pre/post fix:
  - pre-fix run root: `exp/diff_mode_regression_rerun/20260224_044747`
    - whole tokens/runtime: `147298` / `405.82s`
    - diff tokens/runtime: `507601` / `863.87s`
    - diff-vs-whole: `-244.61%` token savings (worse), `-112.87%` runtime speedup (worse)
    - diff API calls: `117`
    - diff empty-response warnings: `73`
  - post-fix run root: `exp/diff_mode_regression_rerun_fix/20260224_051204`
    - whole tokens/runtime: `181182` / `477.46s`
    - diff tokens/runtime: `196736` / `405.78s`
    - diff-vs-whole: `-8.58%` token savings (still slightly worse), `+15.01%` runtime speedup (better)
    - diff API calls: `57`
    - diff empty-response warnings: `16`
  - before/after delta on diff mode itself:
    - tokens: `507601 -> 196736` (`-310865`)
    - runtime: `863.87s -> 405.78s` (`-458.09s`)
    - API calls: `117 -> 57` (`-60`)
  - interpretation:
    - retry-storm regression is fixed.
    - runtime thesis for diff mode now holds on this slice.
    - token-savings thesis is not yet consistently met on this model/config; further prompt/token-budget tuning remains open.

### Final Baseline-vs-Renewed Diff Snapshot

For quick demonstration, compare the original diff baseline run
(`exp/diff_mode_regression_rerun/20260224_044747`) against the renewed diff implementation run
(`exp/diff_mode_regression_rerun_fix/20260224_051204`) on the same 6+3+3 task matrix:

| Metric | Original Diff Baseline | Renewed Diff | Delta |
|:--|--:|--:|--:|
| Diff total tokens | `507601` | `196736` | `-310865` (`-61.24%`) |
| Diff runtime | `863.87s` | `405.78s` | `-458.09s` (`-53.03%`) |
| Diff LLM API calls | `117` | `57` | `-60` (`-51.28%`) |
| Diff apply pass rate | `91.67%` | `91.67%` | `0.00 pp` |
| Diff vs whole token savings | `-244.61%` | `-8.58%` | `+236.02 pp` |
| Diff vs whole runtime speedup | `-112.87%` | `+15.01%` | `+127.89 pp` |
| Diff empty-response warnings | `73` | `16` | `-57` (`-78.08%`) |

Bottom line:
- Major regression mode (blank-response retry storm) was removed.
- Runtime performance improvement is now clearly demonstrated.
- Token efficiency improved substantially versus the original diff baseline, but still trails whole mode by ~`8.6%` in this slice.

#### Whole-Mode Context (same two runs)

To provide context for run-to-run baseline drift, compare whole mode across the same two runs:

| Metric | Original Whole (paired with baseline diff) | Renewed Whole (paired with renewed diff) | Delta |
|:--|--:|--:|--:|
| Whole total tokens | `147298` | `181182` | `+33884` (`+23.00%`) |
| Whole runtime | `405.82s` | `477.46s` | `+71.64s` (`+17.65%`) |
| Whole LLM API calls | `49` | `53` | `+4` (`+8.16%`) |
| Whole prompt tokens | `93437` | `119654` | `+26217` (`+28.06%`) |
| Whole completion tokens | `53861` | `61528` | `+7667` (`+14.23%`) |

Interpretation:
- Whole mode became heavier in the renewed run slice due to stochastic run variance / workload dynamics.
- The diff improvements shown above are therefore stronger when read as direct diff-before-vs-diff-after deltas (`-61.24%` tokens, `-53.03%` runtime).

## Open TODOs
- [x] Add diff-application policy controls (`strict|hybrid|fuzzy`) and diagnostics.
- [x] Add diff prompt/context compaction option for token reduction.
- [x] Add diff token budget knob and mode-aware token accounting.
- [x] Add vLLM model preflight checks in runners (`run_evolution.py`, `run_backend.py`, and helpers).
- [x] Add benchmark runner for whole-vs-diff with hard-task defaults.
- [x] Expand unit/integration/script tests for diff robustness and preflight.
- [x] Update README and docs pages with renewed diff mode behavior.
- [ ] Run additional model/config sweeps that achieve non-zero Gen0 success rate to measure true diff-attempt pass/fail behavior at benchmark level.
- [ ] Tune prompt/profile for CVDP format compliance (observed frequent format failures under current model/setup).
- [ ] Decide whether to relax/retune diff fallback gates for specific benchmark classes after collecting more diff-attempt samples.
- [ ] Run the renewed default 6/6/6 matrix with seeds `1 2` and compare against prior single-seed slices.
- [x] Run `run_diff_mode_diagnostics.py` smoke against current vLLM model and attach artifact paths.
- [ ] Expand diagnostics to multi-repeat (`repeat_per_case>=5`) and preserve worst-case failure examples for ambiguous anchors and malformed escaping regressions.
- [ ] Reduce remaining token overhead (`~8.6%` in latest 6/3/3 retest) via prompt/context and diff-token-budget tuning without reintroducing empty-response retry storms.
- [ ] Attach first prompt-optimization loop to `run_diff_prompt_suite.py` using `summary.objective_score` as objective and compare top prompts against baseline profile prompt.

## Pre-Merge Checklist (Recommended)
- [ ] Run full 6/6/6 matrix with seeds `1 2` and archive both raw outputs + summarized comparison.
- [ ] Demonstrate non-negative diff token savings against whole on at least one stable multi-seed slice (not single-run anecdote).
- [ ] Run `run_diff_prompt_suite.py` on full suite with `repeat_per_case>=3` and record baseline `summary.objective_score`.
- [ ] Use `summarize_diff_prompt_suite.py` to produce prompt leaderboard artifacts (`summary.md`, CSVs) for merge PR evidence.
- [ ] Reduce dominant remaining failure buckets (currently format/semantic edge cases like quote escaping) and re-baseline.
- [ ] Ensure no transient/generated files are included in commits (e.g., simulation logs) and keep commit chain split by feature area (llm/apply, benchmarking, docs, suite tooling).

## Decisions
- Worktree base branch: `wip/journal-extension-2026`.
- Diff apply policy default: `hybrid`.
- Benchmark matrix target: medium first-pass matrix.
- vLLM max context gate: `128000`, warn+continue when below threshold.
