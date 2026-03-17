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
- do not reuse the invalid March 17 relative-path outputs under
  `exp/hard_iteration_one_shot_smoke_20260317/` or
  `exp/hard_iteration_one_shot_restart_20260317/`

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
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config data/configs/hard_iteration_subset.yaml \
  --mode matrix
```

Current fixed modes:

- `classic`
- `grid_struct`
- `cvt_struct`
- `cvt_size_control`

### 4. Generate the hard-subset analysis report

```bash
python scripts/report_hard_iteration_analysis.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<timestamp>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<timestamp>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<timestamp>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<timestamp>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<timestamp>/analysis
```

## Artifacts

- one-shot baseline root:
  - `exp/hard_iteration_one_shot_rerun_<date>/`
- frozen subset config:
  - `data/configs/hard_iteration_subset.yaml`
- vanilla difficulty reference:
  - `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- long-budget comparison root:
  - `exp/hard_iteration_qd/`
- analysis report outputs:
  - `exp/hard_iteration_qd/<timestamp>/analysis/report.md`
  - `exp/hard_iteration_qd/<timestamp>/analysis/summary.json`
- progress tracker:
  - `docs/hard_iteration_subset_qd_plan.md`

## Current branch status

The repo-local workflow surfaces are implemented on
`feat/hard-iteration-subset-qd`. The March 17 evaluator path regression has
been fixed, and the current source of truth for live progress is
`docs/hard_iteration_subset_qd_plan.md`. Use a fresh post-fix one-shot rerun
root before freezing the subset or launching the hard-subset matrix.
