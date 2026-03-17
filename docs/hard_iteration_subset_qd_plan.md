# Hard Iteration Subset + QD Matrix Execution Plan

## Original request

- create and use a dedicated git worktree
- keep a committed markdown plan/progress tracker with clear stages and TODOs
- derive a relatively hard RTLLM + VerilogEval-Spec-to-RTL subset using gate count and vanilla-model one-shot difficulty
- keep both combinational and sequential designs in the subset
- use the subset for a `20 x 5` classic-vs-QD comparison with recommended grid/CVT variants
- update docs, configs, tests, and commit history as the work progresses

## Stage tracker

| Stage | Status | Notes |
|:---|:---|:---|
| Stage 0 | `completed` | Worktree setup and execution scaffold |
| Stage 1 | `completed` | Runtime circuit typing, subset builder, QD runner, and workflow docs |
| Stage 2 | `completed` | Corrected one-shot baseline rerun completed and frozen into a balanced 16-problem subset |
| Stage 3 | `pending` | Frozen subset is ready; long-budget classic-vs-QD matrix not yet launched |
| Stage 4 | `pending` | Analysis, docs, and final recommendations |

## TODO

- [x] Create worktree `feat/hard-iteration-subset-qd`
- [x] Add PPA-derived circuit typing for RTLLM and VerilogEval-Spec-to-RTL
- [x] Add `scripts/build_hard_iteration_subset.py`
- [x] Add `scripts/run_hard_iteration_qd_vllm.sh`
- [x] Add `scripts/run_hard_iteration_one_shot_vllm.sh`
- [x] Add `scripts/report_hard_iteration_analysis.py`
- [x] Add regression tests for circuit typing, subset building, one-shot recovery, QD runner dry-run, and final analysis
- [x] Update `README.md`, `GUIDELINES.md`, and `docs/user_guide.md`
- [x] Run bounded vLLM smoke on the restored endpoint
- [x] Run clean one-shot baseline restart (`10` samples/problem, `8` workers, long-context vLLM)
- [x] Freeze and commit `data/configs/hard_iteration_subset.yaml`
- [x] Commit vanilla baseline CSV for difficulty reference
- [ ] Run classic + grid_struct + cvt_struct + cvt_size_control on the frozen subset
- [ ] Produce comparison report, analysis notes, and recommendations
- [ ] Make signed multi-line commits for the remaining live stages

## Progress log

### 2026-03-16 Stage 0

- created worktree `/workspace/.worktrees/hard-iteration-subset-qd`
- branched from `wip/journal-extension-2026` at `902f1bd78f`
- confirmed the shared vLLM endpoint serves `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` with `max_model_len=131072`
- confirmed existing repo surfaces already provide:
  - `scripts/run_one_shot.py` for vanilla baseline generation
  - `scripts/backend_comparison_report.py` for classic-vs-QD comparison markdown
  - `scripts/run_qd_retrospective_redo_vllm.sh` as the closest existing long-run harness to mirror

### 2026-03-16 Stage 1

- implemented PPA-derived circuit typing in `src/revolution/runtime/problem_spec.py`
- added `scripts/build_hard_iteration_subset.py` to freeze a balanced hard subset from one-shot summaries, gate-count CSVs, and reference PPA metadata
- added `scripts/run_hard_iteration_qd_vllm.sh` to run classic, grid, and CVT modes from the frozen subset config
- added `scripts/run_hard_iteration_one_shot_vllm.sh` so the vanilla baseline can restart or resume safely after endpoint outages
- added `scripts/report_hard_iteration_analysis.py` so the final hard-subset matrix can emit:
  - `report.md`
  - `summary.json`
  - recommendation fields for overall, score-oriented QD, and archive-health QD
- added regression coverage for:
  - benchmark circuit typing behavior
  - subset builder selection and export behavior
  - one-shot runner dry-run batching and completed-problem skipping
  - hard-subset runner dry-run matrix generation
  - hard-subset analysis reporting
- linked the new hard-subset workflow surfaces from `README.md`, `GUIDELINES.md`, and `docs/user_guide.md`

### 2026-03-16 Outage summary

- started the full one-shot baseline over `RTLLM` and `VerilogEval-Spec-to-RTL` with:
  - `10` samples/problem
  - `8` workers
  - `temperature=1.0`
  - `top_p=0.95`
  - `max_tokens=128000`
- the initial sweep completed `35` RTLLM problems before the remaining workers stopped making forward progress on the shared endpoint
- preserved the partial outputs under:
  - `exp/hard_iteration_one_shot/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b`
- recovery probes then failed because `http://host.docker.internal:8000/v1/models` returned `connection refused`
- a bounded retry through `scripts/run_hard_iteration_one_shot_vllm.sh` confirmed the harness waited correctly and exited cleanly without producing new summaries while the endpoint was unavailable
- decision change for the final benchmark reference run:
  - keep the partial RTLLM outputs only as audit history
  - restart Stage 2 from a fresh output root once the endpoint is restored

### 2026-03-17 Recovery status

- `curl http://host.docker.internal:8000/v1/models` is reachable again
- the restored endpoint reports:
  - model id `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - `max_model_len=131072`
- no one-shot baseline or hard-subset QD process is currently running
- Stage 2 is unblocked and reset to `active`
- the next execution step is a bounded smoke followed by a clean one-shot baseline restart from a new output root

### 2026-03-17 Evaluation path regression diagnosis

- the 2026-03-17 smoke and clean baseline reruns were invalidated by a relative-path evaluation bug
- root cause:
  - later runs passed a relative `save_path` into the evaluation stack
  - compilation wrote `code_compiled.vvp` under that relative output directory
  - simulation then invoked `vvp` with the same relative `.vvp` path while also setting the working directory to that relative candidate directory
  - `vvp` therefore searched for `exp/.../code_compiled.vvp` from inside `exp/.../`, effectively doubling the path and failing with `Unable to open input file`
- evidence:
  - the pre-outage March 16 run used absolute compile and simulation paths and passed on `RTLLM/Prob001_accu`
  - the broken March 17 smoke and restart runs used relative paths and failed on the same sample with `Unable to open input file`
  - the fixed March 17 smoke rerun used absolute paths again and restored `functionality=1.0` and `synthesis_ppa=1.0` on `RTLLM/Prob001_accu`
- corrective code changes:
  - normalize `save_path` to an absolute path in `scripts/run_one_shot.py`
  - normalize the effective save path in `scripts/run_backend.py`
  - normalize evaluator output/runtime paths in `src/revolution/evaluation.py`
  - add a focused evaluator regression in `tests/revolution/test_evaluation.py`
- impact on progress tracking:
  - the prior 2026-03-17 Stage 2 freeze and the launched Stage 3 matrix are invalid and must not be used
  - rerun Stage 2 from scratch with a fresh output root before freezing the subset again

### 2026-03-17 Historical aborted Stage 3 launch

- launched the full hard-subset matrix with save root `exp/hard_iteration_qd_20260317/20260317_063730`
- the run was interrupted after the path-regression diagnosis because the preceding Stage 2 freeze was invalid
- do not reuse any outputs from this aborted matrix run; rerun Stage 3 only after the corrected Stage 2 baseline and subset freeze complete

## Remaining execution checklist

### Stage 2 smoke

- endpoint preflight:
  - `curl http://host.docker.internal:8000/v1/models`
  - confirm `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` is served
  - confirm `max_model_len >= 128000`
- completed smoke reference:
  - `/workspace/.venv/bin/python scripts/run_one_shot.py --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path exp/hard_iteration_one_shot_smoke_fix_20260317 --num_workers 1 --temperature 1.0 --top_p 0.95 --max_tokens 128000 --num_samples 1 --generation_mode whole`
- smoke acceptance:
  - one summary is emitted under `exp/hard_iteration_one_shot_smoke_fix_20260317`
  - no local script/runtime error occurs before generation completes

### Stage 2 baseline restart and freeze

- clean baseline restart:
  - `HARD_ONE_SHOT_VLLM_HOST=host.docker.internal HARD_ONE_SHOT_VLLM_PORT=8000 HARD_ONE_SHOT_MIN_MODEL_LEN=128000 HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_20260317_pathfix HARD_ONE_SHOT_NUM_WORKERS=8 HARD_ONE_SHOT_BATCH_SIZE=8 HARD_ONE_SHOT_NUM_SAMPLES=10 HARD_ONE_SHOT_MAX_TOKENS=128000 HARD_ONE_SHOT_TEMPERATURE=1.0 HARD_ONE_SHOT_TOP_P=0.95 bash scripts/run_hard_iteration_one_shot_vllm.sh --benchmarks RTLLM VerilogEval-Spec-to-RTL`
- late-stage resume recommendation after the current in-flight batch exits:
  - `HARD_ONE_SHOT_VLLM_HOST=host.docker.internal HARD_ONE_SHOT_VLLM_PORT=8000 HARD_ONE_SHOT_MIN_MODEL_LEN=128000 HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_20260317_pathfix HARD_ONE_SHOT_NUM_WORKERS=8 HARD_ONE_SHOT_BATCH_SIZE=0 HARD_ONE_SHOT_NUM_SAMPLES=10 HARD_ONE_SHOT_MAX_TOKENS=128000 HARD_ONE_SHOT_TEMPERATURE=1.0 HARD_ONE_SHOT_TOP_P=0.95 bash scripts/run_hard_iteration_one_shot_vllm.sh --benchmarks VerilogEval-Spec-to-RTL`
  - rationale: `HARD_ONE_SHOT_BATCH_SIZE=0` launches all remaining pending problems for the benchmark in one `run_one_shot.py` command, so workers that finish shorter problems can immediately move on instead of waiting behind one slow batch member
- completion criteria:
  - `50` RTLLM summaries under `exp/hard_iteration_one_shot_rerun_20260317_pathfix/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/RTLLM`
  - `156` VerilogEval-Spec-to-RTL summaries under `exp/hard_iteration_one_shot_rerun_20260317_pathfix/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/VerilogEval-Spec-to-RTL`
- freeze immediately after the restart completes:
  - `/workspace/.venv/bin/python scripts/build_hard_iteration_subset.py --one-shot-root exp/hard_iteration_one_shot_rerun_20260317_pathfix --subset-size 16 --per-bucket 4 --benchmark-root data/bench --rtllm-csv scripts/RTLLM.csv --verilogeval-csv scripts/VerilogEval-Spec-to-RTL.csv --output-config data/configs/hard_iteration_subset.yaml --output-csv baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- freeze acceptance:
  - subset size is `16`
  - bucket target is `4` each for RTLLM/VerilogEval x combinational/sequential
  - no selected problem has invalid gate count or unknown circuit type
- planned commit after freeze:
  - `feat(bench): freeze hard iteration subset and baseline reference`

### Stage 3 execution checklist

- run the full hard-subset matrix:
  - `HARD_SUBSET_SAVE_PATH=exp/hard_iteration_qd_rerun_<date> HARD_SUBSET_VLLM_HOST=host.docker.internal HARD_SUBSET_VLLM_PORT=8000 HARD_SUBSET_MIN_MODEL_LEN=128000 HARD_SUBSET_POPULATION_SIZE=20 HARD_SUBSET_NUM_GENERATIONS=5 HARD_SUBSET_NUM_WORKERS=2 HARD_SUBSET_CANDIDATE_WORKERS=0 HARD_SUBSET_TEMPERATURE=1.0 HARD_SUBSET_TOP_P=1.0 HARD_SUBSET_MAX_TOKENS=128000 HARD_SUBSET_DIFF_MAX_TOKENS=128000 HARD_SUBSET_NUM_CELLS=16 HARD_SUBSET_CVT_WARMUP=4 bash scripts/run_hard_iteration_qd_vllm.sh --config data/configs/hard_iteration_subset.yaml --mode matrix`
- required modes:
  - `classic`
  - `grid_struct`
  - `cvt_struct`
  - `cvt_size_control`
- expected outputs:
  - `exp/hard_iteration_qd_rerun_<date>/hard_iteration_backend_comparison.md`
  - per-mode run roots under the same save directory
- planned commit after matrix completion:
  - `feat(qd): run hard subset classic and qd comparison matrix`

### Stage 4 analysis checklist

- generate final report artifacts from the completed matrix:
  - `/workspace/.venv/bin/python scripts/report_hard_iteration_analysis.py --subset-config data/configs/hard_iteration_subset.yaml --backend_run classic=exp/hard_iteration_qd_rerun_<date>/classic --backend_run grid_struct=exp/hard_iteration_qd_rerun_<date>/grid_struct --backend_run cvt_struct=exp/hard_iteration_qd_rerun_<date>/cvt_struct --backend_run cvt_size_control=exp/hard_iteration_qd_rerun_<date>/cvt_size_control --output-dir exp/hard_iteration_qd_rerun_<date>/analysis`
- expected outputs:
  - `exp/hard_iteration_qd_rerun_<date>/analysis/report.md`
  - `exp/hard_iteration_qd_rerun_<date>/analysis/summary.json`
- final writeup additions after live results exist:
  - add the frozen subset table and vanilla baseline outcomes to the workflow doc or a dedicated benchmark note
  - add recommendation bullets backed by the real matrix results
  - update the stage tracker from `active/pending` to `completed`
- planned commit after final reporting is published:
  - `docs(bench): publish hard subset results and recommendations`

## Status refresh: 2026-03-17 07:35 UTC

- Poll result: corrected Stage 2 one-shot rerun is still active under `exp/hard_iteration_one_shot_rerun_20260317_pathfix`.
- Stable completion snapshot: `RTLLM` is `39/50` complete and `VerilogEval-Spec-to-RTL` is `0/156` complete.
- Run health: the corrected rerun continues to pass vLLM preflight and batch aggregation; no repeat of the March 17 relative-path simulation failure has appeared in the rerun logs so far.
- Stage impact: keep Stage 2 as `active`; do not refreeze the hard subset or rerun the Stage 3 matrix until this corrected baseline completes.

## Status refresh: 2026-03-17 07:44 UTC

- Poll result: corrected Stage 2 rerun remains active under `exp/hard_iteration_one_shot_rerun_20260317_pathfix`.
- Stable completion snapshot: `RTLLM` is now `50/50` complete and `VerilogEval-Spec-to-RTL` is `8/156` complete.
- Follow-through completed while waiting: hard-subset workflow docs now point at a fresh post-fix one-shot root, warn against the invalid March 17 outputs, and a new `tests/scripts/test_run_one_shot.py` regression pins the relative-`--save_path` normalization at the script entrypoint.
- Validation snapshot: `python -m pytest tests/scripts/test_run_one_shot.py tests/revolution/test_evaluation.py tests/scripts/test_build_hard_iteration_subset.py` passed (`42` tests).

## Status refresh: 2026-03-17 07:49 UTC

- Poll result: corrected Stage 2 rerun is still active and has cleared the full RTLLM suite.
- Stable completion snapshot: `RTLLM` is `50/50` complete and `VerilogEval-Spec-to-RTL` is `63/156` complete.
- Run health: the corrected VerilogEval batches continue to pass preflight and aggregate normally; no recurrence of the broken relative-path simulation error has appeared.
- Stage impact: Stage 2 remains on track for a truthful refreeze once the remaining `93` VerilogEval problems complete.

## Status refresh: 2026-03-17 08:08 UTC

- Poll result: corrected Stage 2 rerun is still active under `exp/hard_iteration_one_shot_rerun_20260317_pathfix`.
- Stable completion snapshot: `RTLLM` is `50/50` complete and `VerilogEval-Spec-to-RTL` is `111/156` complete.
- Batch health: the latest completed VerilogEval summary at poll time was `Prob105_rotate100` written at `08:00:03 UTC`; the run has gone quiet in the terminal since then, but no new path-regression symptom has appeared.
- Documentation follow-through: the active checklist now points at the post-fix smoke root and the live corrected baseline root, while the invalid pre-fix March 17 roots remain only in historical sections or warning prose.
- Stage impact: keep Stage 2 as `active`; Stage 3 and Stage 4 stay blocked on the remaining `45` VerilogEval summaries and the subsequent valid subset freeze.

## Status refresh: 2026-03-17 08:24 UTC

- Poll result: corrected Stage 2 rerun is still active with unchanged completed-summary counts at `RTLLM 50/50` and `VerilogEval-Spec-to-RTL 111/156`.
- Stall check: the flat summary count is not a dead process. The active VerilogEval worker has continued advancing inside `Prob108_rule90`, moving from `sample4_initial` to `sample5_initial` and then `sample6_initial` under `vvp`.
- Operational conclusion: keep the batch running. The current slow point is long per-sample simulation time inside one problem, not a recurrence of the relative-path evaluator failure.

## Status refresh: 2026-03-17 08:32 UTC

- Stage 2 runtime improvement: `scripts/run_hard_iteration_one_shot_vllm.sh` now accepts `HARD_ONE_SHOT_BATCH_SIZE=0` to launch all remaining pending problems for a benchmark in one command.
- Why this matters: the current `VerilogEval-Spec-to-RTL` rerun is spending a long time inside `Prob108_rule90`, and a small fixed batch can leave finished workers idle until that whole batch returns. The new resume mode avoids that head-of-line blocking on the next launch.
- Testing follow-through: added a dry-run regression in `tests/scripts/test_run_hard_iteration_one_shot_vllm.py` to pin the single-command all-remaining behavior.

## Status refresh: 2026-03-17 08:37 UTC

- Operational cutover: intentionally interrupted the old small-batch `VerilogEval-Spec-to-RTL` Stage 2 resume after confirming it was blocked by long per-sample work inside `Prob108_rule90` rather than the earlier path bug.
- Cleanup note: the interrupt left one orphaned `vvp` process on `Prob108_rule90_sample8_initial`; that evaluator process was terminated before the new resume was launched to avoid overlapping writes into the same candidate directory.
- Current live command: Stage 2 is now running as `VerilogEval-Spec-to-RTL` only with `HARD_ONE_SHOT_BATCH_SIZE=0`, `HARD_ONE_SHOT_NUM_WORKERS=8`, and the same corrected save root `exp/hard_iteration_one_shot_rerun_20260317_pathfix`.
- Current intent: let one `run_one_shot.py` invocation cover all `45` remaining VerilogEval problems so workers that finish shorter problems can immediately move on to later pending work.

## Status refresh: 2026-03-17 08:38 UTC

- Early cutover result: the all-remaining resume immediately moved `VerilogEval-Spec-to-RTL` from `111/156` to `112/156`.
- Worker utilization check: concurrent backend activity is visible across different problems again, including `vvp` on `Prob115_shift18` while `iverilog` is already compiling a later `Prob108_rule90` sample. This confirms the new launch mode is using freed workers instead of serializing the tail behind one problem.

## Status refresh: 2026-03-17 08:57 UTC

- Stage 2 progress: the all-remaining VerilogEval resume advanced the rerun to `154/156` completed summaries while leaving the corrected save root unchanged.
- Current tail: the remaining long-running evaluator is again inside `Prob108_rule90`, with an active `vvp` on `Prob108_rule90_sample4_initial`.
- Execution guidance: leave the current session running. The queueing bottleneck has been resolved; the remaining delay is ordinary long-tail evaluation time inside the last hard problems.

## Status refresh: 2026-03-17 09:05 UTC

- Stage 2 progress: the corrected one-shot rerun is now at `155/156` completed VerilogEval summaries, with `Prob144_conwaylife` recently completing.
- Queue-mode hardening while waiting:
  - tightened `HARD_ONE_SHOT_BATCH_SIZE` validation so the special queue mode is explicitly `0` only
  - added a dry-run regression for the realistic late-resume case where one benchmark is already complete and the other resumes in queue mode
  - added a negative-batch-size rejection test
  - surfaced a concrete queue-mode resume command in the stable workflow docs
- Current tail: one long remaining VerilogEval problem is still active in the live session; Stage 2 remains `active` until the rerun reaches `156/156`.

## Status refresh: 2026-03-17 09:29 UTC

- Stage 2 completed: the corrected one-shot rerun finished at `RTLLM 50/50` and `VerilogEval-Spec-to-RTL 156/156` under `exp/hard_iteration_one_shot_rerun_20260317_pathfix`.
- Freeze outputs created:
  - `data/configs/hard_iteration_subset.yaml`
  - `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- Frozen subset acceptance checks:
  - subset size is `16`
  - bucket balance is `4` each for `RTLLM`/`VerilogEval-Spec-to-RTL` x `combinational`/`sequential`
  - `15` selections came from the primary functionality window and `1` required fallback (`RTLLM/Prob049_signal_generator`)
- Operational note: the one-shot wrapper printed a one-off post-run shell syntax error after the rerun completed, but `bash -n` and traced dry-run reproduction both passed immediately afterward. Treat that message as non-blocking for Stage 2 artifacts unless it recurs during later live runs.
