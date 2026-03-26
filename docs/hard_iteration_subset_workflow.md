# Hard Iteration Subset Workflow

This workflow freezes a smaller but still challenging benchmark slice for
iteration testing, then runs the long-budget classic-vs-QD comparison on that
frozen subset.

## Inputs

- benchmark gate-count references:
  - `scripts/RTLLM.csv`
  - `scripts/VerilogEval-Spec-to-RTL.csv`
- benchmark reference PPA files under `data/bench/<suite>/`
- vanilla one-shot summaries under a valid post-fix rerun root such as
  `exp/hard_iteration_one_shot_rerun_<date>/`
- do not reuse any pre-path-fix 2026-03-17 smoke or baseline outputs

## Commands

### 1. Vanilla one-shot baseline

Use the resumable helper so completed problems are skipped and endpoint outages
do not force a full restart:

```bash
HARD_ONE_SHOT_VLLM_HOST=host.docker.internal \
HARD_ONE_SHOT_VLLM_PORT=8000 \
HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_<date> \
bash scripts/run_hard_iteration_one_shot_vllm.sh
```

If the endpoint is stable and the remaining work is dominated by one long
problem, resume with `HARD_ONE_SHOT_BATCH_SIZE=0` so the wrapper launches all
remaining pending problems for the benchmark in one `run_one_shot.py` command.
That lets idle workers move on to the next problem instead of waiting behind a
small fixed batch.

Concrete late-resume example:

```bash
HARD_ONE_SHOT_VLLM_HOST=host.docker.internal \
HARD_ONE_SHOT_VLLM_PORT=8000 \
HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_<date> \
HARD_ONE_SHOT_NUM_WORKERS=8 \
HARD_ONE_SHOT_BATCH_SIZE=0 \
bash scripts/run_hard_iteration_one_shot_vllm.sh \
  --benchmarks VerilogEval-Spec-to-RTL
```

### 2. Freeze the hard subset

```bash
python scripts/build_hard_iteration_subset.py \
  --one-shot-root exp/hard_iteration_one_shot_rerun_<date> \
  --output-config data/configs/hard_iteration_subset.yaml \
  --output-csv baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv
```

Selection policy:

- ignore negative gate-count entries
- infer `combinational` vs `sequential` from reference `*_ppa.txt`
- target `16` problems total
- target `4` problems from each bucket:
  - `RTLLM/combinational`
  - `RTLLM/sequential`
  - `VerilogEval-Spec-to-RTL/combinational`
  - `VerilogEval-Spec-to-RTL/sequential`
- primary difficulty window: functionality rate `0.1 .. 0.6`
- fallback window: functionality rate `> 0 .. 0.8`
- rank by `log1p(reference_gate_count) * (1 - functionality_rate)`

### 3. Run the long-budget classic-vs-QD matrix

```bash
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=8 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config data/configs/hard_iteration_subset.yaml \
  --mode matrix
```

The runner creates a timestamped run directory under the configured save root,
for example `exp/hard_iteration_qd/<run_tag>/`, and writes both
`hard_iteration_manifest.txt` and `hard_iteration_backend_comparison.md` there.

The wrapper now reads the elastic scheduling defaults from
`matrix_defaults.total_worker_slots`, `max_active_problems`, and
`max_workers_per_problem` in `data/configs/hard_iteration_subset.yaml`. Older
configs that still use `num_workers` or `candidate_workers` are translated with
warnings when the wrapper loads them.

Mode selection is config-driven:

- `--mode matrix` runs the config's `matrix_modes` list when present, or falls
  back to the legacy fixed matrix
- `--mode <name>` runs any mode declared under `modes`
- each mode can override `qd_num_cells`, `qd_cvt_warmup_successes`,
  `qd_fill_target_fraction`, and `qd_cell_reservoir`

That makes the hard-subset wrapper usable for bounded archive-tuning sweeps
without editing the shell script itself.

### 4. Generate the formal `final_analysis/` bundle

```bash
python scripts/report_final_analysis_bundle.py \
  --run-root exp/hard_iteration_qd/<run_tag> \
  --subset-config data/configs/hard_iteration_subset.yaml
```

This is the recommended post-run entrypoint. It preserves the reference layout
under `exp/hard_iteration_qd/<run_tag>/final_analysis/` and generates:

- `backend_comparison.md`
- `hard_iteration_analysis/`
- `pareto_analysis/`
- `feature_analysis/` when QD backends are present
- `evolutionary_reports/`
- top-level `report.md` and `summary.json`

The Pareto layer adds backend/problem hypervolume, Pareto-point counts,
reference-beating counts, projected pairwise-front figures for every problem,
and static 3D front views for sequential problems.

### 5. Generate the hard-subset analysis report manually

```bash
python scripts/report_hard_iteration_analysis.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<run_tag>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<run_tag>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<run_tag>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<run_tag>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<run_tag>/analysis
```

Stage 3 and Stage 5 produce different report surfaces:

- Stage 3 raw comparison:
  - `exp/hard_iteration_qd/<run_tag>/hard_iteration_backend_comparison.md`
  - emitted by `scripts/run_hard_iteration_qd_vllm.sh`
  - use this as the direct backend-by-backend comparison for the finished matrix run
- Stage 5 hard-iteration analysis:
  - `exp/hard_iteration_qd/<run_tag>/analysis/report.md`
  - `exp/hard_iteration_qd/<run_tag>/analysis/summary.json`
  - emitted by `scripts/report_hard_iteration_analysis.py`
  - `report.md` is the human-readable synthesis of the run
  - `summary.json` contains the same aggregate/recommendation content in machine-readable form
  - the recommendation keys are:
    - `overall`
    - `score_qd`
    - `archive_qd`
    - `multi_objective`

### 6. Generate the deep QD feature-space report manually

```bash
python scripts/report_qd_feature_space.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<run_tag>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<run_tag>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<run_tag>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<run_tag>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<run_tag>/feature_analysis
```

This deep analysis layer consumes finished run artifacts and adds:

- `report.md` and `summary.json` with backend aggregate context plus QD-specific feature-space findings
- `qd_successful_candidates.csv` with one row per successful QD candidate
- per-backend histogram, PCA, and t-SNE plots for successful designs
- regression coefficient tables for `quality_score`, `g_P`, `g_A`, and `g_T`
- `recommended_profile.json` and `recommended_profile_scores.csv` for selecting a larger follow-up descriptor profile

### 7. Generate Pareto-only comparison artifacts manually

```bash
python scripts/report_pareto_analysis.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<run_tag>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<run_tag>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<run_tag>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<run_tag>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<run_tag>/pareto_analysis
```

This writes:

- `report.md` and `summary.json`
- `backend_problem_metrics.csv`
- `aggregate_backend_metrics.csv`
- `problems/<benchmark>/<problem>/pairwise_fronts.png`
- `problems/<benchmark>/<problem>/front_3d.png` for sequential problems

For the March 2026 hard-subset follow-up, the frozen large-profile reruns use
the dedicated descriptor file:

- `data/configs/qd_descriptor_profiles_hard_iteration_large.yaml`
- profile name: `hard_iteration_large_struct10d`

That dedicated file keeps the large-profile grid intentionally coarse with
`2` bins per axis so the 10D sequential archive does not become unusably
sparse.

## Artifacts

- one-shot baseline root:
  - `exp/hard_iteration_one_shot_rerun_<date>/`
- frozen subset config generated after the freeze step:
  - `data/configs/hard_iteration_subset.yaml`
- vanilla difficulty reference generated after the freeze step:
  - `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- long-budget comparison root:
  - `exp/hard_iteration_qd/<run_tag>/`
- matrix manifest:
  - `exp/hard_iteration_qd/<run_tag>/hard_iteration_manifest.txt`
- analysis report outputs:
  - `exp/hard_iteration_qd/<timestamp>/analysis/report.md`
  - `exp/hard_iteration_qd/<timestamp>/analysis/summary.json`
- formal final-analysis bundle:
  - `exp/hard_iteration_qd/<timestamp>/final_analysis/report.md`
  - `exp/hard_iteration_qd/<timestamp>/final_analysis/summary.json`
  - `exp/hard_iteration_qd/<timestamp>/final_analysis/backend_comparison.md`
  - `exp/hard_iteration_qd/<timestamp>/final_analysis/hard_iteration_analysis/report.md`
  - `exp/hard_iteration_qd/<timestamp>/final_analysis/pareto_analysis/report.md`
- deep QD feature-space outputs:
  - `exp/hard_iteration_qd/<timestamp>/feature_analysis/report.md`
  - `exp/hard_iteration_qd/<timestamp>/feature_analysis/summary.json`
  - `exp/hard_iteration_qd/<timestamp>/feature_analysis/qd_successful_candidates.csv`
  - `exp/hard_iteration_qd/<timestamp>/feature_analysis/recommended_profile.json`
- progress tracker:
  - `docs/hard_iteration_subset_qd_plan.md`

## Reserved Stage 4 results section

Populate this section after the live matrix finishes:

- frozen 16-problem subset table:
  - benchmark
  - problem
  - circuit type
  - reference gate count
  - vanilla functionality rate
  - selection stage
- vanilla baseline context:
  - note the one-shot model and sampling settings used to derive the subset
  - link the committed baseline CSV
- final recommendations context:
  - distinguish the Stage 3 raw comparison markdown from the Stage 4 `final_analysis/` bundle and the Stage 5 hard-iteration analysis report
  - summarize why the chosen `overall`, `score_qd`, `archive_qd`, and `multi_objective` recommendations were selected

## Current branch status

The repo-local workflow surfaces are implemented on
`feat/hard-iteration-subset-qd`. The March 17 evaluator path regression has
been fixed, and the current source of truth for live progress is
`docs/hard_iteration_subset_qd_plan.md`. Use a fresh post-fix one-shot rerun
root before freezing the subset or launching the hard-subset matrix.
