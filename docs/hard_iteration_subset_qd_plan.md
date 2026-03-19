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
| Stage 3 | `blocked` | Original matrix session exited after `classic` only; `Prob124_rule110` is missing and the QD legs have not started |
| Stage 4 | `pending` | Analysis, docs, and final recommendations |

## TODO

- [x] Create worktree `feat/hard-iteration-subset-qd`
- [x] Add PPA-derived circuit typing for RTLLM and VerilogEval-Spec-to-RTL
- [x] Add `scripts/build_hard_iteration_subset.py`
- [x] Add `scripts/run_hard_iteration_qd_vllm.sh`
- [x] Add `scripts/run_hard_iteration_one_shot_vllm.sh`
- [x] Add `scripts/report_hard_iteration_analysis.py`
- [x] Add `scripts/report_qd_feature_space.py`
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
  - `HARD_SUBSET_SAVE_PATH=exp/hard_iteration_qd_rerun_<date> HARD_SUBSET_VLLM_HOST=host.docker.internal HARD_SUBSET_VLLM_PORT=8000 HARD_SUBSET_MIN_MODEL_LEN=128000 HARD_SUBSET_POPULATION_SIZE=20 HARD_SUBSET_NUM_GENERATIONS=5 HARD_SUBSET_TOTAL_WORKER_SLOTS=2 HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=1 HARD_SUBSET_TEMPERATURE=1.0 HARD_SUBSET_TOP_P=1.0 HARD_SUBSET_MAX_TOKENS=128000 HARD_SUBSET_DIFF_MAX_TOKENS=128000 HARD_SUBSET_NUM_CELLS=16 HARD_SUBSET_CVT_WARMUP=4 bash scripts/run_hard_iteration_qd_vllm.sh --config data/configs/hard_iteration_subset.yaml --mode matrix`
- required modes:
  - `classic`
  - `grid_struct`
  - `cvt_struct`
  - `cvt_size_control`
- expected outputs:
  - `exp/hard_iteration_qd_rerun_<date>/<run_tag>/hard_iteration_backend_comparison.md`
  - `exp/hard_iteration_qd_rerun_<date>/<run_tag>/hard_iteration_manifest.txt`
  - per-mode run roots under the same timestamped save directory
- planned commit after matrix completion:
  - `feat(qd): run hard subset classic and qd comparison matrix`

### Stage 4 analysis checklist

- generate final report artifacts from the completed matrix:
  - `/workspace/.venv/bin/python scripts/report_hard_iteration_analysis.py --subset-config data/configs/hard_iteration_subset.yaml --backend_run classic=exp/hard_iteration_qd_rerun_<date>/<run_tag>/classic --backend_run grid_struct=exp/hard_iteration_qd_rerun_<date>/<run_tag>/grid_struct --backend_run cvt_struct=exp/hard_iteration_qd_rerun_<date>/<run_tag>/cvt_struct --backend_run cvt_size_control=exp/hard_iteration_qd_rerun_<date>/<run_tag>/cvt_size_control --output-dir exp/hard_iteration_qd_rerun_<date>/<run_tag>/analysis`
- expected outputs:
  - `exp/hard_iteration_qd_rerun_<date>/<run_tag>/analysis/report.md`
  - `exp/hard_iteration_qd_rerun_<date>/<run_tag>/analysis/summary.json`
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

## Status refresh: 2026-03-17 09:31 UTC

- Stage 3 launched from `data/configs/hard_iteration_subset.yaml`.
- Live matrix root: `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142`
- Modes in flight:
  - `classic`
  - `grid_struct`
  - `cvt_struct`
  - `cvt_size_control`
- Runtime settings match the frozen config defaults:
  - `population_size=20`
  - `num_generations=5`
  - `total_worker_slots=2`
  - `max_workers_per_problem=1`
  - `evaluation_mode=search_accelerated`
  - `accelerated_synthesis_top_k=1`
  - `max_tokens=128000`
  - `diff_max_tokens=128000`

## Status refresh: 2026-03-17 09:40 UTC

- Stage 3 poll: `classic` completed its first problem under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/classic`.
- Latest completed summary at poll time:
  - `RTLLM/Prob004_adder_8bit`
- Follow-through while waiting:
  - corrected the Stage 3/4 checklist paths so they match the runner's timestamped `<run_tag>` layout
  - extended dry-run test coverage to pin the timestamped matrix output root, manifest creation, and CVT-specific flags
  - extended analysis coverage to include the four-backend workflow and a partial backend tree with placeholder metrics

## Status refresh: 2026-03-17 09:56 UTC

- Stage 3 progress: `classic` has completed `2/16` selected problems at the matrix root `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142`.
- Latest completed classic summary at poll time:
  - `RTLLM/Prob024_fsm`
- Current active tail:
  - synthesized-netlist verification is running for `RTLLM/Prob015_multi_pipe_8bit/Gen4/Prob015_multi_pipe_8bit_sample19_M-I`
- Interpretation: the matrix is progressing normally; the current delay is one long late-generation evaluation inside the `classic` mode, not a launcher or endpoint failure.

## Status refresh: 2026-03-17 10:03 UTC

- Stage 3 progress: `classic` has advanced to `3/16` completed problems.
- Latest completed classic summary at poll time:
  - `RTLLM/Prob037_parallel2serial`
- Current active tail:
  - synthesized-netlist verification is now running for `RTLLM/Prob015_multi_pipe_8bit/Gen5/Prob015_multi_pipe_8bit_sample3_M-R`
- Follow-through while waiting:
  - reviewed the earlier one-shot post-run shell syntax error against the last several script revisions and local shell parsing behavior
  - result: no reproducible repo-local shell syntax bug was found; treat that earlier message as transient/non-actionable unless it recurs with exact stderr and on-disk script contents

## Status refresh: 2026-03-17 10:08 UTC

- Stage 3 progress: `classic` has advanced to `4/16` completed problems at the live matrix root.
- Latest completed classic summary at poll time:
  - `RTLLM/Prob015_multi_pipe_8bit`
- Interpretation: the previously long late-generation tail on `Prob015_multi_pipe_8bit` resolved cleanly, and the `classic` leg continues to make steady forward progress without any launcher or endpoint regression.

## Status refresh: 2026-03-17 10:14 UTC

- Stage 3 progress: `classic` has advanced to `5/16` completed problems.
- Latest completed classic summary at poll time:
  - `RTLLM/Prob041_traffic_light`
- Current matrix shape is unchanged:
  - `classic` is still the only active mode
  - `grid_struct`, `cvt_struct`, and `cvt_size_control` have not started yet because the runner executes the modes sequentially
- Documentation follow-through while waiting:
  - clarified the distinction between the Stage 3 raw comparison markdown and the Stage 4 final analysis/report surfaces in `README.md`, `docs/user_guide.md`, and `docs/hard_iteration_subset_workflow.md`
  - reserved a Stage 4 results section in the workflow doc for the frozen subset table, vanilla baseline context, and recommendation rationale

## Status refresh: 2026-03-17 10:27 UTC

- Stage 3 progress: `classic` has advanced to `6/16` completed problems.
- Latest completed classic summary at poll time:
  - `RTLLM/Prob042_width_8to16`
- Current matrix shape is still sequential by mode:
  - `classic` remains the only active mode
  - `grid_struct`, `cvt_struct`, and `cvt_size_control` are queued behind it

## Status refresh: 2026-03-17 10:34 UTC

- Stage 3 classic progress: the original sequential matrix at `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142` has advanced to `8/16` completed problems.
- Parallel Stage 3 branch launched at user request:
  - mode: `grid_struct`
  - worker budget: `total_worker_slots=8`
  - save root: `exp/hard_iteration_qd_parallel_grid8_20260317/20260317_103455`
- Interpretation:
  - the original matrix run remains active and will continue its sequential mode order unless interrupted later
  - the new `grid_struct` branch is an auxiliary parallel run intended to overlap with the in-flight `classic` leg rather than replace the already-started matrix process

## Status refresh: 2026-03-17 11:01 UTC

- Auxiliary branch shutdown:
  - the parallel `grid_struct` run at `exp/hard_iteration_qd_parallel_grid8_20260317/20260317_103455` was intentionally interrupted at user request
  - it had already produced partial artifacts before the interrupt and currently shows `8` completed summaries
  - treat that branch as abandoned and exclude it from the primary comparison path unless explicitly revived later
- Primary matrix status:
  - the original sequential run at `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142` remains the source of truth
  - `classic` is still at `8/16` completed problems
  - latest completed classic summary at poll time: `RTLLM/Prob045_alu`
- Process check:
  - no `hard_iteration_qd_parallel_grid8_20260317` worker processes remain
  - only the original `classic` process tree is still active

## Status refresh: 2026-03-17 11:06 UTC

- Primary matrix progress:
  - the original sequential run has advanced to `10/16` completed problems in `classic`
  - latest completed classic summary at poll time: `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`
- Interpretation:
  - `classic` has moved from the RTLLM half into the VerilogEval half of the frozen subset
  - the original run remains healthy and is still the only active source-of-truth experiment

## Status refresh: 2026-03-17 13:35 UTC

- Original matrix session outcome:
  - the source-of-truth session for `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142` exited before any QD leg started
  - `classic` stopped at `15/16` completed summaries
  - `grid_struct`, `cvt_struct`, and `cvt_size_control` were never launched
  - `hard_iteration_backend_comparison.md` was never generated
- Missing classic problem:
  - `VerilogEval-Spec-to-RTL/Prob124_rule110`
  - its problem directory existed with `generation_log.jsonl` and successful simulation traces, but no final `Prob124_rule110_summary.json`
  - the partial directory was moved aside to `Prob124_rule110_partial_pre_resume_20260317` so a clean single-problem rerun can reuse the original `classic` root
- Current resume blocker:
  - the worktree shell currently cannot reach the vLLM endpoint
  - `curl http://host.docker.internal:8000/v1/models` fails DNS resolution from this shell
  - direct probes to `172.17.0.1:8000` and `localhost:8000` also fail
  - until the endpoint is reachable again, Stage 3 remains `blocked`
- Safe progress while blocked on the endpoint:
  - added `scripts/report_qd_feature_space.py`
  - added `tests/scripts/test_report_qd_feature_space.py`
  - added workflow and QD-guide documentation for the deep feature-space analysis path
  - local validation for the new script passed via `pytest tests/scripts/test_report_qd_feature_space.py`

## 2026-03-17 13:42 UTC status refresh

- Stage 3 repair remains active in session `59237`.
- Repaired classic backfill target: `VerilogEval-Spec-to-RTL/Prob124_rule110` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/classic`.
- The stale-path failure has not recurred after commit `b1d75c8c37`.
- Current live tail: `Gen1/Prob124_rule110_sample4_M-S` post-synthesis simulation via `vvp`.
- `Prob124_rule110_summary.json` is still pending, so the classic leg is not yet fully repaired.
- Remaining QD modes are still blocked on this classic repair completing cleanly.

## 2026-03-17 14:04 UTC status refresh

- Stage 3 classic repair is still the only active live run.
- Session `59237` has advanced through `Gen1` well past the original failure point.
- Latest observed repaired-canonical tail: `Gen1/Prob124_rule110_sample12_C-F` post-synthesis simulation.
- Canonical `Prob124_rule110` artifacts continue to grow (`32` simulation logs at the latest count).
- `Prob124_rule110_summary.json` is still pending, so `grid_struct`, `cvt_struct`, and `cvt_size_control` remain queued behind the repaired classic leg.

## 2026-03-17 14:23 UTC status refresh

- Stage 3 classic repair is still active in session `59237`.
- Latest observed canonical tail: `Gen1/Prob124_rule110_sample15_M-I` post-synthesis simulation via `vvp`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- While waiting, fixed a report-analysis regression in `scripts/report_qd_feature_space.py` where problem metrics were stored under the rate-dict key name instead of `(benchmark, problem)`.
- Validation update: `/workspace/.venv/bin/python -m pytest tests/scripts/test_report_qd_feature_space.py` now passes again (`4 passed`).
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 14:29 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- The repaired run is still making forward progress through `Gen1`; the latest observed post-synthesis simulation moved from `Prob124_rule110_sample15_M-I` to `Prob124_rule110_sample17_C-F`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg is not complete yet.
- No new repo-local runtime defect is indicated by the current behavior; the run is spending time in candidate-level post-synthesis simulation rather than failing on the earlier stale-path issue.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 14:36 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- Latest observed canonical tail: `Gen1/Prob124_rule110_sample18_M-R` post-synthesis simulation via `vvp`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- No new repo-local failure signature is visible; the run is still advancing through candidate-level post-synthesis simulation.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 14:45 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- The repaired run has advanced into `Gen2`; the latest observed post-synthesis simulation is `Prob124_rule110_sample3_M-R`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- Current evidence still points to a long-tail evaluation rather than a repeat of the stale-path failure: artifact counts are increasing and the active candidate path has progressed beyond the full `Gen1` tail.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 14:51 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- The latest observed post-synthesis simulation advanced from `Gen2/Prob124_rule110_sample3_M-R` to `Gen2/Prob124_rule110_sample4_M-I`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- The temporary empty `code.syn_simulation.log` on `sample3_M-R` did not indicate a hard stall; the run advanced to the next candidate on the next poll.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 14:59 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- The generation log shows `Gen1` completed successfully; the latest observed live tail remains `Gen2/Prob124_rule110_sample5_M-E` post-synthesis simulation via `vvp`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- The current evidence still supports a long-tail candidate evaluation rather than a repeat of the stale-path bug.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-17 15:03 UTC status refresh

- Stage 3 classic repair remains active in session `59237`.
- The latest observed post-synthesis simulation advanced from `Gen2/Prob124_rule110_sample5_M-E` to `Gen2/Prob124_rule110_sample6_M-S`.
- `Prob124_rule110_summary.json` is still pending, so the repaired classic leg remains incomplete.
- The run is still making forward progress through candidate-level post-synthesis simulation and does not currently present the earlier stale-path failure signature.
- Remaining execution order is unchanged after the classic repair: run `grid_struct`, `cvt_struct`, and `cvt_size_control` into the same `20260317_093142` root, then generate the original-root reports.

## 2026-03-18 03:09 UTC status refresh

- Stage 3 classic repair finished successfully in session `59237` after the overnight run.
- `Prob124_rule110_summary.json` is now present under the source-of-truth Stage 3 root `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/classic`.
- The repaired `classic` leg can now be treated as complete.
- Remaining Stage 3 work is now the queued QD legs: `grid_struct`, `cvt_struct`, and `cvt_size_control` in the same experiment root family, followed by the original-root reports.

## 2026-03-18 03:10 UTC status refresh

- Stage 3 resumed beyond the repaired `classic` leg: `grid_struct` is now running in session `74849` under the source-of-truth root `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- The resumed `grid_struct` launch reused the original frozen subset, model, and evolutionary settings and passed vLLM preflight against `http://host.docker.internal:8000/v1/models`.
- Remaining Stage 3 order after `grid_struct` is unchanged: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 03:24 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- There are still no completed problem summaries for the resumed `grid_struct` leg yet.
- The resumed run is nonetheless making progress: recent `generation_log.jsonl` updates are present for `RTLLM/Prob015_multi_pipe_8bit` and then `RTLLM/Prob004_adder_8bit`.
- QD/runtime artifacts continue to accumulate under the resumed root (`42` synthesis-report `.ppa` files and `2` `archive_history.jsonl` files at the latest poll).
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 03:29 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- There are still no completed problem summaries for the resumed `grid_struct` leg yet.
- Current active tail at poll time: `openroad` is running for `RTLLM/Prob015_multi_pipe_8bit/Gen2/Prob015_multi_pipe_8bit_sample6_M-I`.
- Artifact counts continue to grow under the resumed root (`120` `code_simulation.log`, `60` `code.syn_simulation.log`, and `59` `code_synthesis_report.ppa` files at the latest poll).
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 03:40 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- There are still no completed problem summaries for the resumed `grid_struct` leg yet.
- The two `run_backend.py` worker processes remain live after a long polling window; no leaf synthesis/simulation child was captured at the exact final poll, but artifact growth confirms continued progress.
- Latest artifact counts at poll time: `89` `code_synthesis_report.ppa` files and `2` `archive_history.jsonl` files.
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 03:46 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- The resumed `grid_struct` leg has now completed its first full problem summary: `RTLLM/Prob004_adder_8bit`.
- Current active tail at poll time: `yosys` is running for `RTLLM/Prob015_multi_pipe_8bit/Gen4/Prob015_multi_pipe_8bit_sample5_M-R`.
- Latest artifact counts at poll time: `105` `code_synthesis_report.ppa` files and `2` `archive_history.jsonl` files.
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 03:52 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries remain at `1/16` for this resumed leg (`RTLLM/Prob004_adder_8bit`).
- The two `run_backend.py` worker processes remain live after another long polling window.
- Latest artifact counts at poll time: `112` `code_synthesis_report.ppa` files and `3` `archive_history.jsonl` files.
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 05:49 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries have advanced to `6/16` for this resumed leg.
- Completed problems at the latest poll:
  - `RTLLM/Prob004_adder_8bit`
  - `RTLLM/Prob015_multi_pipe_8bit`
  - `RTLLM/Prob024_fsm`
  - `RTLLM/Prob037_parallel2serial`
  - `RTLLM/Prob041_traffic_light`
  - `RTLLM/Prob042_width_8to16`
- The two `run_backend.py` worker processes remain live after the long polling window.
- Latest artifact counts at poll time: `264` `code_synthesis_report.ppa` files and `8` `archive_history.jsonl` files.
- Remaining Stage 3 order is unchanged after `grid_struct`: run `cvt_struct`, then `cvt_size_control`, then generate the original-root reports.

## 2026-03-18 06:54 UTC operator override

- User-directed timeout policy for all subsequent runs launched after the current in-flight `grid_struct` leg:
  - `rtl_simulation_timeout_s: 60`
  - `synthesis_timeout_s: 120`
  - `post_synthesis_simulation_timeout_s: 120`
- This override applies to future Stage 3 and follow-on QD runs (`cvt_struct`, `cvt_size_control`, and any later large-profile reruns).
- The current in-flight `grid_struct` run is unchanged.

## 2026-03-18 06:55 UTC operator override

- User-directed worker policy for all subsequent runs launched after the current in-flight `grid_struct` leg:
  - `total_worker_slots: 4`
  - `max_workers_per_problem: 1`
- This override applies to future Stage 3 and follow-on QD runs (`cvt_struct`, `cvt_size_control`, and any later large-profile reruns).
- The current in-flight `grid_struct` run is unchanged.

## 2026-03-18 11:37 UTC operator override

- User-directed timeout policy supersedes the prior future-run override for all subsequent runs launched after the current in-flight `grid_struct` leg:
  - `rtl_simulation_timeout_s: 60`
  - `synthesis_timeout_s: 300`
  - `post_synthesis_simulation_timeout_s: 300`
- User-directed worker policy for all subsequent runs launched after the current in-flight `grid_struct` leg remains:
  - `total_worker_slots: 4`
  - `max_workers_per_problem: 1`
- This policy applies to future Stage 3 and follow-on QD runs (`cvt_struct`, `cvt_size_control`, and any later large-profile reruns).
- The current in-flight `grid_struct` run is unchanged.

## 2026-03-18 11:55 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries have advanced to `15/16` for this resumed leg.
- Current active tail at poll time: post-synthesis `vvp` is running for `VerilogEval-Spec-to-RTL/Prob124_rule110/Gen5/Prob124_rule110_sample1_C-D`.
- A single chained follow-on launcher is now armed in session `49962`; it waits for `grid_struct` to reach `16/16`, then runs `cvt_struct` and `cvt_size_control` sequentially with the user-directed overrides (`total_worker_slots=4`, `max_workers_per_problem=1`, `rtl_simulation_timeout_s=60`, `synthesis_timeout_s=300`, `post_synthesis_simulation_timeout_s=300`).
- The queued `cvt` chain has not started yet because `grid_struct` is still in flight.

## 2026-03-18 12:06 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries remain at `15/16` for this resumed leg.
- Current active tail at poll time: post-synthesis `vvp` is running for `VerilogEval-Spec-to-RTL/Prob124_rule110/Gen5/Prob124_rule110_sample5_C-F`.
- The chained follow-on launcher remains armed in session `49962` and is still waiting for `grid_struct` to reach `16/16` before starting `cvt_struct` and then `cvt_size_control`.
- Future sequential runs in that chain remain configured with the user-directed settings: `total_worker_slots=4`, `max_workers_per_problem=1`, `rtl_simulation_timeout_s=60`, `synthesis_timeout_s=300`, and `post_synthesis_simulation_timeout_s=300`.

## 2026-03-18 12:17 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries remain at `15/16` for this resumed leg.
- Current active tail at poll time: post-synthesis `vvp` is running for `VerilogEval-Spec-to-RTL/Prob124_rule110/Gen5/Prob124_rule110_sample7_M-R`.
- The chained follow-on launcher remains armed in session `49962` and is still waiting for `grid_struct` to reach `16/16` before starting `cvt_struct` and then `cvt_size_control`.
- The queued sequential `cvt` runs remain configured with the user-directed settings: `total_worker_slots=4`, `max_workers_per_problem=1`, `rtl_simulation_timeout_s=60`, `synthesis_timeout_s=300`, and `post_synthesis_simulation_timeout_s=300`.

## 2026-03-18 12:39 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries remain at `15/16` for this resumed leg.
- Current active tail at poll time: post-synthesis `vvp` is running for `VerilogEval-Spec-to-RTL/Prob124_rule110/Gen5/Prob124_rule110_sample13_M-S`.
- The chained follow-on launcher remains armed in session `49962` and is still waiting for `grid_struct` to reach `16/16` before starting `cvt_struct` and then `cvt_size_control`.
- Future sequential runs in that chain remain configured with the user-directed settings: `total_worker_slots=4`, `max_workers_per_problem=1`, `rtl_simulation_timeout_s=60`, `synthesis_timeout_s=300`, and `post_synthesis_simulation_timeout_s=300`.

## 2026-03-18 12:50 UTC status refresh

- `grid_struct` remains active in session `74849` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- Completed problem summaries remain at `15/16` for this resumed leg.
- Current active tail at poll time: post-synthesis `vvp` is running for `VerilogEval-Spec-to-RTL/Prob124_rule110/Gen5/Prob124_rule110_sample15_C-F`.
- The chained follow-on launcher remains armed in session `49962` and is still waiting for `grid_struct` to reach `16/16` before starting `cvt_struct` and then `cvt_size_control`.
- Future sequential runs in that chain remain configured with the user-directed settings: `total_worker_slots=4`, `max_workers_per_problem=1`, `rtl_simulation_timeout_s=60`, `synthesis_timeout_s=300`, and `post_synthesis_simulation_timeout_s=300`.

## 2026-03-18 13:01 UTC status refresh

- `grid_struct` completed successfully in session `74849`.
- Completed problem summaries now total `16/16` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- The queued follow-on launcher in session `49962` attempted to start `cvt_struct` automatically but failed immediately with a CLI compatibility error: `run_backend.py` no longer accepts legacy parallelism flags (`--num_workers`, `--candidate_workers`).
- Stage 3 now needs a corrected chained relaunch for `cvt_struct` followed by `cvt_size_control` using the currently supported worker controls while preserving the requested effective `4`-worker sequential policy and timeout settings.

## 2026-03-18 13:02 UTC status refresh

- `grid_struct` completed successfully; all `16/16` final problem summaries are now present under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- The previous waiting chained launcher used obsolete worker CLI flags and was intentionally stopped before it could misfire.
- Stage 3 now proceeds with a corrected single chained relaunch for `cvt_struct` followed by `cvt_size_control`, preserving the requested effective `4`-worker sequential policy and timeout settings under the current elastic worker controls.

## 2026-03-18 13:02 UTC status refresh

- `grid_struct` is complete; all `16/16` final problem summaries are present under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/grid_struct`.
- The obsolete waiting launcher was superseded by a corrected single chained relaunch in session `99457`.
- `cvt_struct` is now running as the active Stage 3 backend under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/cvt_struct`.
- The corrected chained command preserves the requested effective sequential-run policy using the modern elastic flags:
  - `total_worker_slots=4`
  - `max_active_problems=4`
  - `max_workers_per_problem=1`
  - `rtl_simulation_timeout_s=60`
  - `synthesis_timeout_s=300`
  - `post_synthesis_simulation_timeout_s=300`
- After `cvt_struct` completes, the same session will automatically run `cvt_size_control`.

## 2026-03-18 13:08 UTC status refresh

- `cvt_struct` is now the active Stage 3 backend in session `99457` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/cvt_struct`.
- The corrected chained launcher is now confirmed to be using the modern elastic worker controls in live execution:
  - `total_worker_slots=4`
  - `max_active_problems=4`
  - `max_workers_per_problem=1`
  - `rtl_simulation_timeout_s=60`
  - `synthesis_timeout_s=300`
  - `post_synthesis_simulation_timeout_s=300`
- Early `cvt_struct` progress is visible across multiple RTLLM problems via `generation_log.jsonl`, and the active leaf process at poll time is `yosys` for `RTLLM/Prob015_multi_pipe_8bit/Gen1/Prob015_multi_pipe_8bit_sample2_M-E`.
- `cvt_size_control` remains queued behind `cvt_struct` in the same chained session.

## 2026-03-18 13:14 UTC status refresh

- `cvt_struct` remains the active Stage 3 backend in session `99457` under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/cvt_struct`.
- Completed problem summaries remain at `0/16` for the corrected `cvt_struct` leg so far.
- Progress is visible across multiple RTLLM problems via `generation_log.jsonl`, including `Prob004_adder_8bit`, `Prob015_multi_pipe_8bit`, `Prob024_fsm`, and `Prob037_parallel2serial`.
- `cvt_size_control` remains queued behind `cvt_struct` in the same chained session and will inherit the same effective `4`-worker elastic settings.


## 2026-03-19 00:00 UTC completion update

- The original hard-subset Stage 3 matrix is now complete under `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142`.
- Final backend completion state for the original matrix:
  - `classic`: `16/16`
  - `grid_struct`: `16/16`
  - `cvt_struct`: `16/16`
  - `cvt_size_control`: `16/16`
- The original baseline reporting surfaces are complete:
  - raw backend comparison: `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/hard_iteration_backend_comparison.md`
  - final aggregate report: `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/analysis/report.md`
  - final aggregate summary: `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/analysis/summary.json`
- Stage 2 is complete from the corrected rerun artifacts:
  - frozen subset config: `data/configs/hard_iteration_subset.yaml`
  - baseline CSV: `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- Next follow-on stage: run the deep QD feature-space analysis on the finished original root, freeze the larger descriptor profile, then run new large-profile `grid` and `cvt` follow-up experiments.
- Follow-on user override for these new large-profile runs:
  - use `16` workers total per run rather than the earlier `4`-worker follow-up default
  - keep `max_workers_per_problem=1`
  - keep `rtl_simulation_timeout_s=60`
  - keep `synthesis_timeout_s=300`
  - keep `post_synthesis_simulation_timeout_s=300`
  - for the new large-profile grid, keep per-axis bins deliberately coarse to avoid an unusably sparse archive.


## 2026-03-19 00:30 UTC feature-analysis freeze

- The deep QD feature-space analysis completed successfully from the finished original root:
  - `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/feature_analysis/report.md`
  - `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/feature_analysis/summary.json`
  - `exp/hard_iteration_qd_rerun_20260317_pathfix/20260317_093142/feature_analysis/recommended_profile.json`
- The feature-analysis rerun required one branch-local robustness fix in `scripts/report_qd_feature_space.py` so it tolerates historical `qd_archive_event.json` records with `current_cell_elite: null`.
- The measured top-ranked eligible non-target features were:
  - `sequential_cells`
  - `mux_ratio`
  - `mux_cells`
  - `adder_ratio`
  - `seq_ratio`
  - `arithmetic_cells`
  - `cell_count_log`
- Follow-on profile freeze adjustment: `cell_count_log` was replaced by `total_cells` in the dedicated runnable profile because the finished original-root candidate table mixes transformed and raw `cell_count_log` semantics across backends, while `total_cells` remains stable and ranked immediately below it.
- Frozen dedicated follow-up descriptor file:
  - `data/configs/qd_descriptor_profiles_hard_iteration_large.yaml`
  - profile name: `hard_iteration_large_struct10d`
- Frozen large-profile sequential axes:
  - `sequential_cells`, `mux_ratio`, `mux_cells`, `adder_ratio`, `seq_ratio`, `arithmetic_cells`, `total_cells`, `g_P`, `g_A`, `g_T`
- Frozen large-profile combinational axes:
  - `sequential_cells`, `mux_ratio`, `mux_cells`, `adder_ratio`, `seq_ratio`, `arithmetic_cells`, `total_cells`, `g_P`, `g_A`
- Large-profile grid sparsity control for the new follow-up grid run:
  - use the dedicated descriptor file instead of the global profile file
  - keep all large-profile grid axes at `2` bins each
  - this yields a coarse `10D` sequential grid instead of reusing the denser legacy `g_*` axis settings
- Next live step: run new large-profile `grid` then `cvt` follow-up experiments sequentially with:
  - `total_worker_slots=16`
  - `max_active_problems=16`
  - `max_workers_per_problem=1`
  - `rtl_simulation_timeout_s=60`
  - `synthesis_timeout_s=300`
  - `post_synthesis_simulation_timeout_s=300`
