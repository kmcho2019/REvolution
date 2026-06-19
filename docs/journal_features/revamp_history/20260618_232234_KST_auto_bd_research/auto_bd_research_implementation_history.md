# Automatic BD Research Implementation History

Use this as the unbounded evidence log. Add dated entries for decisions,
commands, runs, artifacts, failures, fixes, validation, and commits.

## 2026-06-18 23:22 KST

Created the auto-BD research scaffold on branch
`feat/journal-auto-bd-exp-20260618`.

Scaffold directory:

`docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`

Source inputs:

- user request for an AutoQD/AURORA/VQ-Elites-style research branch focused
  on replacing weak manual BDs for RTL PPA evolution
- hard requirement that any proposed method must match original
  REvolution's valid-PPA problem coverage set
- requirement to compare against original REvolution and Smooth-QD manual
  BD, plus controls
- requirement to document every attempted method with specification,
  rationale, results, and accept/reject decision
- `auto_bd_plan_sketch.md`
- `auto_bd_ruminations.md`
- existing journal revamp scaffold in
  `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/`

Initial plan decisions:

- Use ST-NOD as the preferred first serious journal-candidate direction.
- Start with random descriptor and Yosys-stat controls before learned
  descriptors.
- Treat reporting and canonical netlist hashing as a prerequisite, not a
  final cleanup step.
- Add Gate 0: the selected Auto-BD method must produce at least one valid
  PPA candidate for every problem where original REvolution does under the
  fixed evaluation policy.
- Keep PPA, reference PPA, fitness, and hypervolume out of descriptor
  inputs.
- Use `gpt-oss-120b` at `http://20.0.0.103:8000/v1` as the default local
  model arm, with `max_model_len >= 131072` and 128k token settings for
  reasoning-model runs.

No `/goal` was activated. No Auto-BD implementation work started in this
entry.

## 2026-06-18 14:50 UTC

Started the first implementation pass for the active auto-BD goal.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072
- owner: `vllm`

Added the first shared infrastructure slice:

- `src/revolution/auto_bd/__init__.py`
- `src/revolution/auto_bd/netlist_hash.py`
- `src/revolution/auto_bd/results.py`
- `tests/revolution/test_auto_bd_netlist_hash.py`
- `tests/revolution/test_auto_bd_results.py`

What this slice provides:

- deterministic canonical netlist hash for duplicate-elite audits
- motif-signature hash based on cell-type/pin-arity counts
- standard result file names
- required candidate and run-manifest fields
- standard failure-category vocabulary
- required-field assertion helper for future report ingestion
- `auto_bd_methods/README.md` and `method_card_template.md` under the
  scaffold directory, so method artifacts have a fixed home before
  experiments begin

Scope note: this does not yet integrate hashes into live candidate
evaluation or generate full report artifacts. It is the shared contract
and utility layer needed before baseline/method reports.

Validation:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: 6 passed in 63.62s.

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/auto_bd
```

Result: 0 errors, 0 warnings, 0 informations.

```bash
uv tool run ty check src/revolution/auto_bd
```

Result: all checks passed.

Operational note: initial `uv run pytest` / `uv run ruff` attempts spent
several minutes materializing a fresh worktree `.venv`; both wrapper
processes were stopped and validation was rerun through the established
`/workspace/.venv` environment with `PYTHONPATH=src`.

## 2026-06-18 15:20 UTC

Built the initial Auto-BD benchmark task catalog and subset lock before
running any Auto-BD method comparisons.

Added:

- `scripts/build_auto_bd_task_catalog.py`
- `tests/scripts/test_build_auto_bd_task_catalog.py`
- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_task_catalog.json`
- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_task_catalog.md`
- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_subset_lock.yaml`

Command:

```bash
PYTHONPATH=src /workspace/.venv/bin/python scripts/build_auto_bd_task_catalog.py
```

Result:

- full candidate pool in JSON: 202 RTLLM/VerilogEval problems from
  `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`
- included problems: 29 total
- development: 6 problems from `data/configs/fast_iteration_subset_v3.yaml`
- main screening: 13 problems from `data/configs/hard_iteration_subset.yaml`
- held-out validation: 10 problems deterministically selected from
  `data/configs/holdout_reference_subset.yaml`
- held-out pool retained: 20 problems

The catalog records per-problem benchmark source, circuit type, inferred
design family, width hint, reference gate count, approximate cost buckets,
one-shot functionality/synthesis rates, pending baseline valid-PPA status,
and inclusion/exclusion decision. The held-out validation subset remains
unused by any method selection at this point.

Validation:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/scripts/test_build_auto_bd_task_catalog.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: 8 passed in 33.66s.

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  scripts/build_auto_bd_task_catalog.py \
  tests/scripts/test_build_auto_bd_task_catalog.py \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: 0 errors, 0 warnings, 0 informations.

```bash
uv tool run ty check src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: all checks passed.

## 2026-06-18 23:35 KST

Moved the two initial intent documents into this scaffold directory:

- `auto_bd_plan_sketch.md`
- `auto_bd_ruminations.md`

Updated the plan, TODO, goal template, and adversarial prompt so future
work treats these as the original intent/brainstorming record, while
`auto_bd_research_plan.md` remains the controlling contract.

Added organization guidance:

- keep `auto_bd_methods/` under
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`
  so `docs/journal_features/` does not accumulate scattered method
  directories
- put method cards, configs, generated reports, and accept/reject records
  under each method directory
- link large `exp/` artifacts from reports instead of copying them into
  docs

Added validation guidance that experimental modes must not make the
backend messy. Future implementations should keep code simple, typed,
exhaustively handled, documented with useful docstrings/comments, and
aligned with the repository simplicity rules.

## 2026-06-18 23:50 KST

Hardened the scaffold using reviewer feedback. Kept the high-level
direction unchanged and added only the controls that prevent misleading
or non-comparable Auto-BD wins.

Changes made:

- Added `START_HERE.md` as the scaffold entrypoint.
- Added `README.md` as a short pointer to `START_HERE.md`.
- Renamed `auto_bd_plan_scatch.md` to `auto_bd_plan_sketch.md`.
- Clarified that the manual-BD baseline is the landing Smooth-QD
  manual-BD / NSGA-II baseline, not the older failed qd_target/original-v2
  configuration.
- Added a benchmark task catalog requirement.
- Added phased reporting: seed-1 preliminary, seed-3 screening, seed-5
  final confirmation when compute permits.
- Added server parallelism guidance: use multithreading/parallel
  evaluation for speed, but log worker/thread/scheduler settings and keep
  the policy symmetric across methods.
- Added Gate 0 semantics for both `C_problem` and `C_problem_seed`.
- Added common audit archive requirements so QD score/coverage are
  comparable across methods with different internal descriptor spaces.
- Added learned/projected descriptor fitting protocol and leakage
  controls.
- Added ST-NOD observational-equivalence rule so stage dumping does not
  silently alter final synthesis/PPA scoring.
- Added stronger functional correctness audit for final best candidates,
  hypervolume contributors, and representative elites.
- Added PPA/hypervolume normalization rules, structural diversity levels,
  deterministic random-control definition, prompt/archive-context logging,
  toolchain/PPA reproducibility requirements, and a standard result schema.
- Extended the adversarial prompt and validation-report placeholder to
  check these gates explicitly.

No `/goal` was activated. No Auto-BD implementation work started in this
entry.

## 2026-06-19 00:39 KST

Added a concrete run-policy lock after reviewing handoff feedback and the
existing journal/QD guidance.

Added:

- `auto_bd_run_policy_lock.yaml`

The lock records:

- local `openai/gpt-oss-120b` endpoint and 131072 context requirement
- 128k `max_tokens` / `diff_max_tokens` policy
- phased seed policy: seed-1 preliminary, seed-3 screening, seed-5 final
- development, main-screening, final, held-out, and PPA-remeasurement
  worker policies
- landing Smooth-QD manual-BD baseline values:
  `grid_quantile_pareto_journal_bd_eoh`, direct code individuals,
  EoH strategies, `journal_logic_ff_width_3d`, grid-quantile warmup 8,
  Pareto cells, PPA objectives, champion-lane fraction 0.5, and
  `nsga2_global_rank`
- deterministic random descriptor control policy
- common-audit, descriptor-leakage, PPA metric, and toolchain manifest
  requirements

Updated `START_HERE.md`, `README.md`, `auto_bd_research_plan.md`,
`goal_template.md`, the TODO, and the adversarial prompt so future work
uses the run-policy lock as the concrete baseline/seed/worker/budget
reference. Marked the model-length, 128k token, and worker-policy TODO
items complete because these are now explicitly locked before method
comparison. Split the remaining broad lock TODO so prompt hashes,
timeouts, and tool versions stay open until real run manifests exist.

## 2026-06-19 00:45 KST

Validated the run-policy lock and reran the focused checks for touched
Auto-BD support code.

YAML lock validation:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -c "from pathlib import Path; import yaml; p=Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_run_policy_lock.yaml'); data=yaml.safe_load(p.read_text()); assert data['model_policy']['required_min_model_len'] >= 131072; assert data['model_policy']['max_tokens'] == 128000; assert data['baseline_arms']['landing_smooth_qd_manual_bd']['qd_parent_selection'] == 'nsga2_global_rank'; assert data['seed_policy']['screening_seed3'] == [1001, 1002, 1003]; print('run policy lock ok')"
```

Result: `run policy lock ok`.

Line-budget check:

```bash
wc -l docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_implementation_todo.md
```

Result: 145 lines, under the declared 160-line cap.

Focused tests:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/scripts/test_build_auto_bd_task_catalog.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: 8 passed in 52.18s.

Lint:

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  scripts/build_auto_bd_task_catalog.py \
  tests/scripts/test_build_auto_bd_task_catalog.py \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py
```

Result: all checks passed.

Pyright:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: 0 errors, 0 warnings, 0 informations.

Ty:

```bash
uv tool run ty check src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: all checks passed.

## 2026-06-19 00:50 KST

Added the first code-organization guardrail for future Auto-BD variants.
This responds to the explicit requirement that many experimental
descriptor variants must stay clean, compartmentalized, and aligned with
`GUIDELINES.md`.

Added:

- `src/revolution/auto_bd/method_specs.py`
- `tests/revolution/test_auto_bd_method_specs.py`

Updated:

- `src/revolution/auto_bd/__init__.py`
- `auto_bd_methods/README.md`

The new `method_specs.py` module defines the planned method families in
evaluation order:

- `random_descriptor`
- `yosys_stat_bd`
- `netlist_motif_occupancy`
- `synthesis_trajectory_nod`
- `contrastive_synthesis_response`
- `aurora_netlist_encoder`
- `vq_implementation_codebook`

Each method spec records the scaffold-local directory name, title,
descriptor inputs, fitting protocol, synthesis/stage-dump requirements,
and whether fitting artifacts are required. It also centralizes forbidden
descriptor inputs (`ppa`, `reference_ppa`, `fitness`, `hypervolume`) and
validates the registry so unknown method families fail loudly. This is
not backend wiring yet; it is the small shared contract later backend,
reporting, and method-card code should use to avoid variant-specific
conditionals spreading through unrelated call sites.

Focused tests:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/revolution/test_auto_bd_method_specs.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py \
  tests/scripts/test_build_auto_bd_task_catalog.py
```

Result: 13 passed in 63.45s.

Lint:

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_method_specs.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py \
  tests/scripts/test_build_auto_bd_task_catalog.py \
  scripts/build_auto_bd_task_catalog.py
```

Result: all checks passed.

Pyright:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: 0 errors, 0 warnings, 0 informations.

Ty:

```bash
uv tool run ty check src/revolution/auto_bd scripts/build_auto_bd_task_catalog.py
```

Result: all checks passed.

No TODO item was marked complete for this slice. The P5 backend
simplicity item should stay open until real experimental modes are wired
through this contract without scattering backend logic.

## 2026-06-19 01:02 KST

Implemented the random descriptor QD control as the first Auto-BD control
method and made `ty` first-class in the Auto-BD validation contract.

Code changes:

- Added `src/revolution/auto_bd/random_descriptor.py`.
- Registered `random_hash_0`, `random_hash_1`, and `random_hash_2` as
  descriptor axes with `auto_bd_hash` as their source tool.
- Added `requires_auto_bd_hash` to descriptor requirement summaries.
- Extended `SynthesisEvaluator.evaluate` to return
  `synthesized_netlist_path` in synthesis result payloads.
- Extended `CandidateEvaluator` to compute random descriptor axes only
  when the active descriptor profile requires `auto_bd_hash` metrics. The
  source is the canonical synthesized-netlist hash, not source text or
  PPA.

Method docs:

- Added `auto_bd_methods/00_random_descriptor/config.yaml`.
- Added `auto_bd_methods/00_random_descriptor/descriptor_profile.yaml`.
- Added `auto_bd_methods/00_random_descriptor/method_card.md`.

The random profile intentionally lives under the method directory instead
of the shared `data/configs/qd_descriptor_profiles.yaml`, keeping this
control compartmentalized and avoiding global descriptor-default churn.

Checklist updates:

- Marked `Implement random descriptor QD` complete.
- Marked `Ensure random descriptor control is deterministic per
  candidate` complete.
- Left random-control reports and accept/reject decisions open because no
  development-subset run has been executed.

`ty`-first validation policy:

- Updated `auto_bd_research_plan.md`, `auto_bd_research_implementation_todo.md`,
  `auto_bd_research_adversarial_prompt.md`, and `goal_template.md` so
  `uv tool run ty check <touched source modules>` is the primary Auto-BD
  typecheck evidence.
- Pyright remains secondary compatibility evidence while the repository
  still asks for it.

Method YAML validation:

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
from pathlib import Path
import yaml
base = Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/00_random_descriptor')
config = yaml.safe_load((base / 'config.yaml').read_text())
profile = yaml.safe_load((base / 'descriptor_profile.yaml').read_text())
assert config['method_family'] == 'random_descriptor'
assert config['descriptor']['descriptor_file'] == 'descriptor_profile.yaml'
assert profile['profiles']['random_hash_3d'] == ['random_hash_0', 'random_hash_1', 'random_hash_2']
print('random descriptor method yaml ok')
PY
```

Result: `random descriptor method yaml ok`.

Line-budget check:

```bash
wc -l docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_implementation_todo.md
```

Result: 146 lines, under the declared 160-line cap.

Primary typecheck:

```bash
uv tool run ty check \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/evaluation.py \
  scripts/build_auto_bd_task_catalog.py
```

Result: all checks passed.

Focused tests:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/revolution/test_auto_bd_random_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_evaluation.py \
  tests/revolution/test_auto_bd_method_specs.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py \
  tests/scripts/test_build_auto_bd_task_catalog.py
```

Result: 92 passed in 63.58s.

Lint:

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/evaluation.py \
  tests/revolution/test_auto_bd_random_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_evaluation.py \
  tests/revolution/test_auto_bd_method_specs.py \
  tests/revolution/test_auto_bd_netlist_hash.py \
  tests/revolution/test_auto_bd_results.py \
  scripts/build_auto_bd_task_catalog.py \
  tests/scripts/test_build_auto_bd_task_catalog.py
```

Result: all checks passed.

Secondary pyright compatibility:

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/evaluation.py \
  scripts/build_auto_bd_task_catalog.py
```

Result: 0 errors, 0 warnings, 0 informations.

## 2026-06-19 01:11 KST

Implemented the simple Yosys-stat BD control as the next control arm
after the random descriptor.

Added:

- `auto_bd_methods/01_yosys_stat_bd/descriptor_profile.yaml`
- `auto_bd_methods/01_yosys_stat_bd/config.yaml`
- `auto_bd_methods/01_yosys_stat_bd/method_card.md`

Primary descriptor profile:

- `cell_count_log`
- `seq_ratio`
- `mux_ratio`

Rationale:

- keep the first Yosys-stat control three-dimensional like the landing
  manual-BD baseline
- use synthesized-netlist structural metrics that already exist in the
  evaluator
- avoid a new backend branch or broad experimental-mode configuration
  while still testing whether simple implementation-size/composition
  statistics beat the current manual descriptors

Predeclared ablation:

- `yosys_stat_mix_4d`, adding `adder_ratio`, if the compact profile
  collapses or fails on arithmetic-heavy tasks

Status: implemented but not run. Reports and accept/reject decisions are
still pending until baseline coverage and development-subset runs exist.

Validation:

```bash
uv tool run ty check \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_auto_bd_method_specs.py
```

Result: 45 passed in 26.83s.

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py
```

Result: 0 errors, 0 warnings, 0 informations.

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
from pathlib import Path
import yaml
base = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/01_yosys_stat_bd"
)
for name in ["config.yaml", "descriptor_profile.yaml"]:
    payload = yaml.safe_load((base / name).read_text(encoding="utf-8"))
    assert isinstance(payload, dict), name
print("yosys-stat method yaml ok")
PY
```

Result: `yosys-stat method yaml ok`.

## 2026-06-19 01:26 KST

Added standardized Auto-BD run-manifest builder plumbing.

Added:

- `scripts/build_auto_bd_run_manifest.py`
- `tests/scripts/test_build_auto_bd_run_manifest.py`

Updated `auto_bd_run_policy_lock.yaml` with the manifest-freeze inputs
that were previously only implicit in runner defaults:

- timeout policy: RTL simulation, synthesis, post-synthesis simulation,
  and CVDP simulation timeouts
- prompt policy hash inputs: `data/prompts` plus prompt-building code
  paths used by REvolution/Smooth-QD
- toolchain hash paths: Nangate45 liberty file, PDK/technology config
  tree, Yosys/ABC/OpenROAD reference scripts, and evaluator SDC/script
  generation code

The builder emits the required standard `run_manifest.json` fields from
`src/revolution/auto_bd/results.py`, including config/subset hashes,
prompt-policy hash, tool versions, timeout policy, budget policy, worker
count, and thread policy. It records a standalone `abc` binary as
unavailable when no external `abc` command is in `PATH`, instead of
silently omitting the required field.

Checklist update:

- Marked `Freeze prompt hashes, timeout policy, and tool versions in run
  manifests` complete because the builder now freezes those fields and a
  real development manifest smoke was generated. Full per-run result
  emission remains open under P6.

Validation:

```bash
uv tool run ty check \
  scripts/build_auto_bd_run_manifest.py \
  src/revolution/auto_bd/results.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/scripts/test_build_auto_bd_run_manifest.py \
  tests/revolution/test_auto_bd_results.py
```

Result: 5 passed in 15.23s.

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  scripts/build_auto_bd_run_manifest.py \
  tests/scripts/test_build_auto_bd_run_manifest.py \
  src/revolution/auto_bd/results.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  scripts/build_auto_bd_run_manifest.py \
  src/revolution/auto_bd/results.py
```

Result: 0 errors, 0 warnings, 0 informations.

Manifest smoke:

```bash
PYTHONPATH=src /workspace/.venv/bin/python \
  scripts/build_auto_bd_run_manifest.py \
  --config-path \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/01_yosys_stat_bd \
  --phase development \
  --output /tmp/auto_bd_yosys_stat_run_manifest.json
```

Result:

- wrote `/tmp/auto_bd_yosys_stat_run_manifest.json`
- verified model ID `openai/gpt-oss-120b`
- verified seed list `[1001]`
- verified 64-character prompt-policy hash

## 2026-06-19 01:48 KST

Added a deterministic development run-matrix builder for the first
comparable seed-1 phase.

Added:

- `scripts/build_auto_bd_run_matrix.py`
- `tests/scripts/test_build_auto_bd_run_matrix.py`
- `auto_bd_development_run_matrix.json`
- `auto_bd_development_run_matrix.sh`
- `auto_bd_run_configs/development/classic_revolution.yaml`
- `auto_bd_run_configs/development/landing_smooth_qd_manual_bd.yaml`
- `auto_bd_run_configs/development/random_descriptor_qd.yaml`
- `auto_bd_run_configs/development/simple_yosys_stat_bd.yaml`

The matrix expands the locked development subset into eight executable
`run_backend.py` commands:

- 4 arms: original REvolution, landing Smooth-QD manual-BD, random
  descriptor QD, and simple Yosys-stat BD
- 1 seed: `1001`
- 2 benchmark groups: RTLLM and VerilogEval-Spec-to-RTL, grouped
  separately so problem IDs cannot be accidentally cross-applied to the
  wrong benchmark

The generated commands use the locked policy:

- model: `openai/gpt-oss-120b`
- endpoint: `20.0.0.103:8000`
- `--vllm_min_model_len 131072`
- `--max_tokens 128000`
- `--diff_max_tokens 128000`
- population size 12, generations 3
- strict-ablation evaluation
- development worker policy: 12 total slots, 6 active problems, 4
  workers per problem
- locked RTL/synthesis/post-synthesis timeouts

The matrix also emits one `run_manifest.json` command per arm/seed before
the expensive LLM commands. I executed only those four manifest commands,
not the LLM evolution commands.

Generated manifests:

- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/run_manifest.json`

Validation:

```bash
uv tool run ty check scripts/build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pytest \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 2 passed in 0.12s.

```bash
PYTHONPATH=src /workspace/.venv/bin/ruff check \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
PYTHONPATH=src /workspace/.venv/bin/python -m pyright \
  scripts/build_auto_bd_run_matrix.py
```

Result: 0 errors, 0 warnings, 0 informations.

Matrix checks:

```bash
PYTHONPATH=src /workspace/.venv/bin/python \
  scripts/build_auto_bd_run_matrix.py --phase development
bash -n \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_development_run_matrix.sh
```

Result:

- generated 8 run commands
- generated 4 manifest commands
- shell syntax check passed
- JSON payload verified that command token lists start with `env`

Manifest generation command:

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
import json
import shlex
import subprocess
from pathlib import Path
payload = json.loads(Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_development_run_matrix.json"
).read_text())
for item in payload["manifest_commands"]:
    subprocess.run(shlex.split(item["command_string"]), check=True)
print("development run manifests generated:", len(payload["manifest_commands"]))
PY
```

Result: 4 development run manifests generated.

Fresh model preflight:

First attempt incorrectly piped `curl` into a Python here-doc, so the
here-doc consumed stdin and `curl` reported `Failed writing body`. The
corrected command wrote the response to a temp JSON file and parsed it:

```bash
tmp_json=/tmp/auto_bd_vllm_models.json
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models > "$tmp_json"
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
import json
from pathlib import Path
payload = json.loads(Path("/tmp/auto_bd_vllm_models.json").read_text())
models = payload.get("data", [])
assert models, "no models returned"
model = models[0]
print("model_id=", model.get("id"))
print("max_model_len=", model.get("max_model_len"))
assert model.get("id") == "openai/gpt-oss-120b"
assert int(model.get("max_model_len")) >= 131072
PY
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

No development baseline/control LLM run has been launched yet. The next
step is to execute the generated matrix commands, starting with original
REvolution and landing Smooth-QD manual-BD so Gate 0 coverage can be
established before interpreting controls.

## 2026-06-19 01:59 KST

Executed the original REvolution development-subset seed-1 baseline from
the generated run matrix. This was the first expensive LLM-backed
development run for Gate 0 coverage.

Preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run policy:

- phase: `development_preliminary_seed1`
- seed: `1001`
- method arm: `classic_revolution`
- backend: original `revolution`
- model: `openai/gpt-oss-120b`
- `--vllm_min_model_len 131072`
- `--max_tokens 128000`
- `--diff_max_tokens 128000`
- population size 12, generations 3
- strict-ablation evaluation
- worker policy: 12 total slots, 6 active problems, 4 workers per
  problem

Executed the two `classic_revolution` commands from
`auto_bd_development_run_matrix.json`:

- RTLLM: `Prob011_multi_16bit`, `Prob019_sub_64bit`, `Prob048_pe`
- VerilogEval-Spec-to-RTL: `Prob021_mux256to1v`,
  `Prob030_popcount255`, `Prob105_rotate100`

Run artifacts:

- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_163442_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_164339_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_163442_revolution_scheduler_telemetry.json`
- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_164339_revolution_scheduler_telemetry.json`

Run completion:

- RTLLM group completed in 489.70 seconds.
- VerilogEval-Spec-to-RTL group completed in 449.11 seconds.

Added a repeatable Gate 0 summarizer:

- `scripts/summarize_auto_bd_gate0.py`
- `tests/scripts/test_summarize_auto_bd_gate0.py`

Generated coverage artifact:

- `auto_bd_gate0_coverage_seed1.json`

Coverage result for original REvolution, development subset, seed 1001:

| Problem | Summary | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 16 | 0.3647038093317585 |
| `RTLLM/Prob019_sub_64bit` | success | 43 | 0.48228021147642647 |
| `RTLLM/Prob048_pe` | success | 27 | 0.005550298699281149 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 31 | 0.4231863785854045 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 48 | 0.28511627906976744 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 44 | 0.04155040525406675 |

Gate 0 status:

- provisional development seed-1 `C_problem` contains all six
  development problems
- provisional development seed-1 `C_problem_seed` contains all six
  `(problem, seed=1001)` pairs
- cross-method Gate 0 deltas remain open until the manual-BD and control
  arms are run

Validation:

```bash
uv tool run ty check \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 2 passed in 1.03s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 0 errors, 0 warnings, 0 informations.

Operational note: an initial parallel `uv run` validation attempt for
pytest, ruff, and pyright stalled before reaching the tools, likely due
to environment setup contention. Those validation processes were stopped
and replaced with sequential `uv run --active` commands.

## 2026-06-19 02:23 KST

Executed the landing Smooth-QD manual-BD / NSGA-II development-subset
seed-1 baseline from the generated run matrix.

Preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run policy:

- phase: `development_preliminary_seed1`
- seed: `1001`
- method arm: `landing_smooth_qd_manual_bd`
- backend: `revolution_qd`
- descriptor profile: `journal_logic_ff_width_3d`
- archive: `grid_quantile`, warmup successes 8
- cell mode: Pareto front, max elites per cell 5
- parent selection: `nsga2_global_rank`
- champion-lane fraction: 0.5
- model: `openai/gpt-oss-120b`
- `--vllm_min_model_len 131072`
- `--max_tokens 128000`
- `--diff_max_tokens 128000`
- population size 12, generations 3
- strict-ablation evaluation
- worker policy: 12 total slots, 6 active problems, 4 workers per
  problem

Executed the two `landing_smooth_qd_manual_bd` commands from
`auto_bd_development_run_matrix.json`:

- RTLLM: `Prob011_multi_16bit`, `Prob019_sub_64bit`, `Prob048_pe`
- VerilogEval-Spec-to-RTL: `Prob021_mux256to1v`,
  `Prob030_popcount255`, `Prob105_rotate100`

Run artifacts:

- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_170319_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_171307_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_170319_revolution_scheduler_telemetry.json`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_171307_revolution_scheduler_telemetry.json`

Run completion:

- RTLLM group completed in 550.23 seconds.
- VerilogEval-Spec-to-RTL group completed in 530.33 seconds.

Generated coverage artifact:

- `auto_bd_gate0_coverage_seed1_landing_smooth_qd_manual_bd.json`

Coverage result for landing Smooth-QD manual-BD, development subset, seed
1001:

| Problem | Summary | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 27 | 0.15328258385427165 |
| `RTLLM/Prob019_sub_64bit` | success | 45 | 0.452712179958205 |
| `RTLLM/Prob048_pe` | success | 24 | 0.006579168080201192 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 38 | 0.4231863785854045 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 45 | 0.28511627906976744 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 40 | 0.04155040525406675 |

Gate 0 comparison against original REvolution seed-1 `C`:

```json
{
  "classic_minus_manual": [],
  "manual_minus_classic": [],
  "classic_seed_minus_manual": []
}
```

Result: the landing Smooth-QD manual-BD baseline covers all six
development seed-1 problems covered by original REvolution.

Implementation note:

- Fixed `scripts/summarize_auto_bd_gate0.py` to ignore QD sidecar
  summaries such as `archive_summary.json` and `global_pareto_summary.json`.
  It now reads only `<problem>_summary.json` per problem.

Validation:

```bash
uv tool run ty check \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 2 passed in 1.26s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 0 errors, 0 warnings, 0 informations.

## 2026-06-18 18:02 UTC

Fixed random-descriptor QD initialization and recorded the seed-1
development control result.

Initial failure:

- Command: reran the two `random_descriptor_qd` entries from
  `auto_bd_development_run_matrix.json`.
- Artifacts:
  - `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_172739_revolution_summary_results.txt`
  - `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_172934_revolution_summary_results.txt`
- Result: all six problems reported `initialization_failed`.
- Root cause: valid-PPA candidates were generated, but the QD archive
  could not initialize because `QDEngine` inherits
  `_evaluate_candidate_pipeline` from `EoHEngine`; that path populated
  standard metric dictionaries but did not populate
  `candidate.descriptor_values`. The random-hash archive axes therefore
  failed with missing `random_hash_*` descriptor metrics.

Implementation fix:

- Added an `EoHEngine._extract_candidate_descriptor_values(...)` hook for
  descriptor values that are not standard structural/RTL/graph/physical
  metrics.
- Overrode the hook in `QDEngine` for descriptor profiles requiring
  `requires_auto_bd_hash`.
- Random descriptor values are computed from the synthesized netlist only
  after synthesis and PPA succeed, using the canonical netlist hash.
- Updated the Gate 0 summarizer to accept old two-column
  `initialization_failed` summary lines, so failed rerun history can
  remain in the same run directory without breaking later summaries.

Rerun:

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
import json
import subprocess
from pathlib import Path

matrix_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_development_run_matrix.json"
)
payload = json.loads(matrix_path.read_text(encoding="utf-8"))
entries = [
    entry for entry in payload["entries"]
    if entry["arm_name"] == "random_descriptor_qd"
]
assert len(entries) == 2
for entry in entries:
    subprocess.run(entry["command"], check=True)
PY
```

Result:

- RTLLM group completed in 546.17 seconds.
- VerilogEval group completed in 781.54 seconds.
- In-run model preflight passed for `openai/gpt-oss-120b` with
  `max_model_len=131072`.

Rerun artifacts:

- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_173737_revolution_run_log.txt`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_173737_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_173737_revolution_scheduler_telemetry.json`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_174705_revolution_run_log.txt`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_174705_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_174705_revolution_scheduler_telemetry.json`

Generated Gate 0 artifact:

- `auto_bd_gate0_coverage_seed1_random_descriptor_qd.json`

Coverage summary:

| Method | Covered | Missing | Gate 0 Delta vs Classic |
| --- | ---: | ---: | --- |
| `random_descriptor_qd` | 6 | 0 | none |

Covered problems:

- `RTLLM/Prob011_multi_16bit`
- `RTLLM/Prob019_sub_64bit`
- `RTLLM/Prob048_pe`
- `VerilogEval-Spec-to-RTL/Prob021_mux256to1v`
- `VerilogEval-Spec-to-RTL/Prob030_popcount255`
- `VerilogEval-Spec-to-RTL/Prob105_rotate100`

Gate 0 comparison against original REvolution seed-1 `C`:

```json
{
  "classic_minus_random": [],
  "random_minus_classic": [],
  "classic_seed_minus_random": []
}
```

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_qd_engine.py -k 'random_hash or descriptor_tuple'
```

Result: 2 passed, 44 deselected.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 3 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/algorithm.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_qd_engine.py \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/summarize_auto_bd_gate0.py \
  tests/scripts/test_summarize_auto_bd_gate0.py
```

Result: 0 errors, 0 warnings, 0 informations.

```bash
uv tool run ty check \
  src/revolution/algorithm.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_qd_engine.py
```

Result: failed with 82 diagnostics in pre-existing touched-file type
debt. The failures include old strategy-type invariance in
`algorithm.py`, old `_select_strategy` overload issues in `qd/engine.py`,
and old test-helper typing issues in `test_qd_engine.py`. No diagnostic
identified the new descriptor hook or random-hash extraction body.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/algorithm.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_qd_engine.py
```

Result: failed with 69 existing diagnostics, primarily old
`QDEngine`/archive union narrowing and `test_qd_engine.py` helper typing
debt.

## 2026-06-18 18:25 UTC

Ran the simple Yosys-stat BD seed-1 development control.

Endpoint preflight before the run:

```bash
curl -s http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Command:

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
import json
import subprocess
from pathlib import Path

matrix_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_development_run_matrix.json"
)
payload = json.loads(matrix_path.read_text(encoding="utf-8"))
entries = [
    entry for entry in payload["entries"]
    if entry["arm_name"] == "simple_yosys_stat_bd"
]
assert len(entries) == 2
for entry in entries:
    subprocess.run(entry["command"], check=True)
PY
```

Result:

- RTLLM group completed in 533.08 seconds.
- VerilogEval group completed in 468.25 seconds.
- In-run model preflight passed for `openai/gpt-oss-120b` with
  `max_model_len=131072`.

Run artifacts:

- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_180728_revolution_run_log.txt`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_180728_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_180728_revolution_scheduler_telemetry.json`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_181700_revolution_run_log.txt`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_181700_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_181700_revolution_scheduler_telemetry.json`

Generated Gate 0 artifact:

- `auto_bd_gate0_coverage_seed1_simple_yosys_stat_bd.json`

Coverage summary:

| Method | Covered | Missing | Gate 0 Delta vs Classic |
| --- | ---: | ---: | --- |
| `simple_yosys_stat_bd` | 6 | 0 | none |

Covered problems:

- `RTLLM/Prob011_multi_16bit`
- `RTLLM/Prob019_sub_64bit`
- `RTLLM/Prob048_pe`
- `VerilogEval-Spec-to-RTL/Prob021_mux256to1v`
- `VerilogEval-Spec-to-RTL/Prob030_popcount255`
- `VerilogEval-Spec-to-RTL/Prob105_rotate100`

Gate 0 comparison against original REvolution seed-1 `C`:

```json
{
  "classic_minus_yosys": [],
  "yosys_minus_classic": [],
  "classic_seed_minus_yosys": []
}
```

Validation:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/summarize_auto_bd_gate0.py \
  --run-dir \
  exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b \
  --method-name simple_yosys_stat_bd \
  --phase development_preliminary_seed1 \
  --seed 1001 \
  --output \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_gate0_coverage_seed1_simple_yosys_stat_bd.json
```

Result: artifact generated successfully.

```bash
jq empty \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_gate0_coverage_seed1_simple_yosys_stat_bd.json
```

Result: JSON parsed successfully.

## 2026-06-18 18:30 UTC

Added seed-1 preliminary reports and accept/reject records for both
control methods.

New random descriptor artifacts:

- `auto_bd_methods/00_random_descriptor/seed1_preliminary_report.md`
- `auto_bd_methods/00_random_descriptor/accept_reject.md`

Decision:

- retain as the required negative control
- reject as a final Auto-BD method candidate

New Yosys-stat BD artifacts:

- `auto_bd_methods/01_yosys_stat_bd/seed1_preliminary_report.md`
- `auto_bd_methods/01_yosys_stat_bd/accept_reject.md`

Decision:

- retain as a strong simple control
- reject as the selected final Auto-BD method for now

Updated both method cards so their status points to the seed-1 reports
and decision files. Marked the P2 control report/decision checklist items
complete. Broader P6 reporting and seed-3/seed-5 evaluation remain open.

## 2026-06-18 18:39 UTC

Implemented the first non-control Auto-BD method:
`netlist_motif_occupancy`.

Code changes:

- Added `src/revolution/auto_bd/motif_descriptor.py`.
- Exposed `netlist_cell_instances(...)` from `netlist_hash.py`.
- Registered motif axes in `src/revolution/qd/descriptors.py`:
  `motif_logic_ratio`, `motif_control_ratio`, `motif_arith_ratio`, and
  `motif_diversity`.
- Added `requires_auto_bd_motif` descriptor requirements.
- Wired motif extraction through both `CandidateEvaluator` and
  `QDEngine` synthesized-netlist descriptor paths.
- Extended `scripts/build_auto_bd_run_matrix.py` with the
  `netlist_motif_occupancy` candidate-method arm.

Method artifacts:

- `auto_bd_methods/02_netlist_motif_occupancy/config.yaml`
- `auto_bd_methods/02_netlist_motif_occupancy/descriptor_profile.yaml`
- `auto_bd_methods/02_netlist_motif_occupancy/method_card.md`

Run-policy and matrix updates:

- Added `candidate_method_arms.netlist_motif_occupancy` to
  `auto_bd_run_policy_lock.yaml`.
- Regenerated `auto_bd_development_run_matrix.json` and
  `auto_bd_development_run_matrix.sh`.
- The development matrix now has 10 entries: classic, manual-BD, random,
  Yosys-stat, and motif occupancy across RTLLM and VerilogEval.

Validation:

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/auto_bd/motif_descriptor.py \
  src/revolution/auto_bd/netlist_hash.py \
  src/revolution/auto_bd/__init__.py \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/qd/engine.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/revolution/test_auto_bd_motif_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_qd_engine.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_auto_bd_motif_descriptor.py
```

Result: 4 passed.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_qd_descriptors.py -k motif
```

Result: 1 passed, 26 deselected.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_candidate_evaluator.py -k motif_descriptor
```

Result: 1 passed, 14 deselected.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_qd_engine.py -k motif_descriptors
```

Result: 1 passed, 94 deselected.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 2 passed.

```bash
uv tool run ty check \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/revolution/test_auto_bd_motif_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/revolution/test_auto_bd_motif_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 0 errors, 0 warnings, 0 informations.

```bash
uv tool run ty check \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_qd_engine.py
```

Result: failed with 103 existing diagnostics. The failures are the known
runtime/QD test-helper typing debt: fake evaluators are not typed as
`VerilogEvaluator`/`SynthesisEvaluator`, `_select_strategy` overloads are
not narrowed for QD callers, and `test_qd_engine.py` assigns
`SimpleNamespace` loggers and uses archive union attributes without
narrowing.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_qd_engine.py
```

Result: failed with 99 existing diagnostics in the same runtime/QD
test-helper debt surface.

TODO status:

- marked motif implementation complete
- marked motif extraction, signal-renaming stability, and formatting
  stability tests complete
- left development subset run/report and accept/reject decision open

## 2026-06-18 - Netlist Motif Occupancy Seed-1 Run

Ran the `netlist_motif_occupancy` development seed-1 arm on the locked
six-problem subset.

Commands:

```bash
PYTHONPATH=src /workspace/.venv/bin/python - <<'PY'
...
PY
```

The wrapper executed the run-matrix manifest command and the two locked
benchmark commands for the motif arm.

Run policy:

- phase: `development_preliminary_seed1`
- seed: `1001`
- model: `openai/gpt-oss-120b`
- endpoint: `http://20.0.0.103:8000/v1/models`
- vLLM preflight: `max_model_len=131072`
- REvolution token budgets: `--max_tokens 128000`,
  `--diff_max_tokens 128000`

Artifacts:

- `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/run_manifest.json`
- `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/revolution/openai_gpt-oss-120b/20260618_184839_revolution_summary_results.txt`
- `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/revolution/openai_gpt-oss-120b/20260618_185911_revolution_summary_results.txt`
- `auto_bd_gate0_coverage_seed1_netlist_motif_occupancy.json`
- `auto_bd_methods/02_netlist_motif_occupancy/seed1_preliminary_report.md`
- `auto_bd_methods/02_netlist_motif_occupancy/accept_reject.md`

Results:

- RTLLM runtime: 564.57 seconds
- VerilogEval runtime: 548.10 seconds
- covered problems: 6
- missing problems: 0
- classic-minus-motif problem delta: 0
- motif-minus-classic problem delta: 0
- classic-minus-motif problem-seed delta: 0

Decision:

- promote motif occupancy to seed-3 screening candidate
- reject as the selected final method for now until PPA/hypervolume,
  common-audit QD, and structural-diversity evidence exists

TODO status:

- marked motif development run/report complete
- marked motif accept/reject decision complete

## 2026-06-18 - ST-NOD Stage-Dump Helper

Implemented the first ST-NOD infrastructure step as a sidecar Yosys
stage-dump script writer.

Changed code:

- `src/revolution/auto_bd/stage_dumps.py`
- `src/revolution/auto_bd/__init__.py`
- `tests/revolution/test_auto_bd_stage_dumps.py`

The helper writes an observational script that snapshots:

- `00_read`
- `01_synth`
- `02_opt`
- `03_arithmap`
- `04_dffmap`
- `05_abc`
- `06_clean`
- `07_buffered`

The helper does not feed artifacts into the scoring synthesis/PPA path.
Runtime execution, observational-equivalence validation, trajectory
feature extraction, and descriptor-profile wiring are still pending.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: 2 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/auto_bd/stage_dumps.py \
  src/revolution/auto_bd/__init__.py \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/auto_bd \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: 0 errors, 0 warnings, 0 informations.

TODO status:

- marked ST-NOD stage-dump script writer complete
- left runtime execution and observational-equivalence validation open

## 2026-06-18 - ST-NOD Descriptor And Method Arm

Implemented the first runnable ST-NOD descriptor profile and registered
it as a development run-matrix arm.

Changed code:

- `src/revolution/auto_bd/trajectory_descriptor.py`
- `src/revolution/qd/descriptors.py`
- `src/revolution/runtime/candidate_evaluator.py`
- `src/revolution/qd/engine.py`
- `scripts/build_auto_bd_run_matrix.py`

Method artifacts:

- `auto_bd_methods/03_synthesis_trajectory_nod/descriptor_profile.yaml`
- `auto_bd_methods/03_synthesis_trajectory_nod/config.yaml`
- `auto_bd_methods/03_synthesis_trajectory_nod/method_card.md`
- `auto_bd_run_configs/development/synthesis_trajectory_nod.yaml`
- `auto_bd_development_run_matrix.json`
- `auto_bd_development_run_matrix.sh`

Descriptor axes:

- `stnod_cell_growth_log`
- `stnod_logic_swing`
- `stnod_control_swing`
- `stnod_arith_swing`
- `stnod_diversity_swing`

The descriptor uses Yosys stage-dump Verilog snapshots only. It does not
consume PPA, fitness, reference PPA, or hypervolume inputs.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_auto_bd_trajectory_descriptor.py \
  tests/revolution/test_qd_descriptors.py::test_stnod_profile_uses_stage_dump_metrics \
  tests/revolution/test_candidate_evaluator.py::test_candidate_evaluator_runs_stnod_stage_dumps_for_stage_profile \
  tests/revolution/test_candidate_evaluator.py::test_candidate_evaluator_rejects_failed_stnod_stage_dump \
  tests/revolution/test_qd_engine.py::test_qd_engine_extracts_stnod_descriptors
```

Result: 6 passed.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 2 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/auto_bd/trajectory_descriptor.py \
  src/revolution/auto_bd/__init__.py \
  src/revolution/qd/descriptors.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/qd/engine.py \
  tests/revolution/test_auto_bd_trajectory_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_qd_engine.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  tests/revolution/test_auto_bd_trajectory_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/auto_bd \
  src/revolution/qd/descriptors.py \
  tests/revolution/test_auto_bd_trajectory_descriptor.py \
  tests/revolution/test_qd_descriptors.py \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 0 errors, 0 warnings, 0 informations.

Runtime/QD source-only typecheck note:

- `uv tool run ty check src/revolution/runtime/candidate_evaluator.py
  src/revolution/qd/engine.py` still reports 7 existing diagnostics.
- `pyright` on those two source files still reports 3 existing
  diagnostics.
- The remaining diagnostics are the previously recorded QD typing debt:
  `_select_strategy` overloads, rebin event typing, redundant cast,
  default tuple for a list parameter, and scipy result typing.

Generated matrix check:

```bash
jq '{manifest_count: (.manifest_commands | length), entry_count: (.entries | length), arms: ([.entries[].arm_name] | unique)}' \
  auto_bd_development_run_matrix.json
```

Result: 6 manifest commands and 12 entries, including
`synthesis_trajectory_nod`.

TODO status:

- marked ST-NOD runtime sidecar wiring complete
- marked ST-NOD trajectory feature extraction complete
- left observational-equivalence validation and development run open

## 2026-06-18 - ST-NOD Observational Equivalence Test

Added a live Yosys regression test proving that the ST-NOD sidecar final
snapshot matches the baseline Yosys final netlist for a tiny design.

Changed test:

- `tests/revolution/test_synthesis_stage_dumps.py`

Equivalence rule:

- baseline path: `SynthesisEvaluator._create_yosys_script(...)`
- ST-NOD path: `SynthesisEvaluator.run_yosys_stage_dumps(...)`
- comparison: canonical netlist hash of baseline output versus
  `07_buffered.v`

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_synthesis_stage_dumps.py::test_stage_dump_final_snapshot_matches_baseline_yosys_netlist -q
```

Result: 1 passed in 59.12 seconds.

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_synthesis_stage_dumps.py \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: 5 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/auto_bd/stage_dumps.py \
  src/revolution/evaluation.py \
  tests/revolution/test_synthesis_stage_dumps.py \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  src/revolution/auto_bd \
  src/revolution/evaluation.py \
  tests/revolution/test_synthesis_stage_dumps.py \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  src/revolution/auto_bd \
  src/revolution/evaluation.py \
  tests/revolution/test_synthesis_stage_dumps.py \
  tests/revolution/test_auto_bd_stage_dumps.py
```

Result: 0 errors, 0 warnings, 0 informations.

TODO status:

- marked ST-NOD observational-equivalence test complete
- left motif-plus-trajectory combination, cost check, and development
  seed-1 run open

## 2026-06-18 - ST-NOD Seed-1 Preliminary Run

Initial ST-NOD seed-1 execution failed during initialization. All six
problems reported `initialization_failed` because successful synthesis/PPA
candidates reached QD descriptor extraction before the legacy QD path had
created `stage_dump_verilog_paths`.

Fix:

- commit `ac0e5d3a4c`:
  `fix(auto-bd): Create ST-NOD dumps in QD`
- preserved failed output:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/revolution/openai_gpt-oss-120b_failed_pre_c97c73a/`

Validation before rerun:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/revolution/test_qd_engine.py::test_qd_engine_extracts_stnod_descriptors \
  tests/revolution/test_qd_engine.py::test_qd_engine_runs_stnod_dumps_when_missing
```

Result: 2 passed in 22.60 seconds.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  src/revolution/qd/engine.py \
  tests/revolution/test_qd_engine.py
```

Result: all checks passed.

```bash
uv tool run ty check src/revolution/qd/engine.py
```

Result: blocked by the previously recorded QD source typing debt
(`_select_strategy` overloads, rebin event typing, redundant cast, and
default tuple for a list parameter). No new ST-NOD branch diagnostic was
introduced.

```bash
UV_LINK_MODE=copy uv run --active pyright src/revolution/qd/engine.py
```

Result: blocked by the previously recorded QD source typing debt
(`ks_2samp` result typing and default tuple for a list parameter). No new
ST-NOD branch diagnostic was introduced.

Successful rerun:

```bash
PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob011_multi_16bit Prob019_sub_64bit Prob048_pe \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --seed 1001 \
  --save_path exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001 \
  --search_mode revolution_qd \
  --qd_descriptor_profile stnod_trajectory_5d
```

Result: 3/3 RTLLM problems succeeded in 528.97 seconds.

```bash
PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob021_mux256to1v Prob030_popcount255 Prob105_rotate100 \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --seed 1001 \
  --save_path exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001 \
  --search_mode revolution_qd \
  --qd_descriptor_profile stnod_trajectory_5d
```

Result: 3/3 VerilogEval problems succeeded in 554.05 seconds.

Gate 0 summary:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/summarize_auto_bd_gate0.py \
  --run-dir exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/revolution/openai_gpt-oss-120b \
  --method-name synthesis_trajectory_nod \
  --phase development_preliminary_seed1 \
  --seed 1001 \
  --output docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_gate0_coverage_seed1_synthesis_trajectory_nod.json
```

Result:

- covered problems: 6
- missing problems: 0
- classic-minus-ST-NOD problem delta: 0
- classic-minus-ST-NOD problem-seed delta: 0

Artifacts:

- `auto_bd_methods/03_synthesis_trajectory_nod/seed1_preliminary_report.md`
- `auto_bd_methods/03_synthesis_trajectory_nod/accept_reject.md`
- `auto_bd_gate0_coverage_seed1_synthesis_trajectory_nod.json`

TODO status:

- marked ST-NOD in-loop cost check complete for seed-1
- marked ST-NOD development run and report complete
- marked ST-NOD accept/reject decision complete
- left seed-3 screening, common-audit, PPA/hypervolume, and structural
  diversity evidence open

## 2026-06-18 20:22 UTC

Added the standardized Auto-BD result collector and generated seed-1
standard results for all current development arms.

Changed code:

- `scripts/build_auto_bd_standard_results.py`
- `tests/scripts/test_build_auto_bd_standard_results.py`
- `pyproject.toml`
- `uv.lock`

The collector emits the standard result schema from one REvolution run:

- `candidates.parquet`
- `elites.parquet`
- `archive_snapshots.parquet`
- `per_generation_metrics.parquet`
- `per_problem_metrics.parquet`
- `descriptor_vectors.parquet`
- `netlist_hashes.parquet`
- `method_summary.json`
- `run_manifest.json`

The common audit archive is fixed across methods:

- axes: `motif_logic_ratio`, `motif_control_ratio`,
  `motif_arith_ratio`, `motif_diversity`
- bins per axis: 4
- cell id prefix: `audit_motif4:`

Generated standard result directories:

- `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results/`
- `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results/`
- `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results/`
- `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results/`
- `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/standard_results/`
- `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results/`

Seed-1 method summaries:

| Arm | Candidates | Valid PPA | Unique Netlists | Unique Motifs | Audit Cells | Audit QD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | 288 | 209 | 70 | 43 | 12 | 2.3163 |
| `landing_smooth_qd_manual_bd` | 288 | 219 | 61 | 33 | 9 | 1.8526 |
| `random_descriptor_qd` | 288 | 213 | 64 | 41 | 8 | 1.7008 |
| `simple_yosys_stat_bd` | 288 | 201 | 62 | 45 | 11 | 2.0779 |
| `netlist_motif_occupancy` | 288 | 192 | 64 | 37 | 8 | -3.0274 |
| `synthesis_trajectory_nod` | 288 | 205 | 72 | 52 | 11 | -2.0643 |

Added scaffold index:

- `auto_bd_standard_results_seed1.md`

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_build_auto_bd_standard_results.py \
  tests/revolution/test_auto_bd_results.py
```

Result: 6 passed in 30.14 seconds.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/build_auto_bd_standard_results.py \
  tests/scripts/test_build_auto_bd_standard_results.py \
  src/revolution/auto_bd/results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/build_auto_bd_standard_results.py \
  tests/scripts/test_build_auto_bd_standard_results.py \
  src/revolution/auto_bd/results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/build_auto_bd_standard_results.py \
  tests/scripts/test_build_auto_bd_standard_results.py \
  src/revolution/auto_bd/results.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact check:

```bash
python - <<'PY'
from pathlib import Path
files = {
    'candidates.parquet', 'elites.parquet', 'archive_snapshots.parquet',
    'per_generation_metrics.parquet', 'per_problem_metrics.parquet',
    'descriptor_vectors.parquet', 'netlist_hashes.parquet',
    'method_summary.json', 'run_manifest.json'
}
base = Path('exp/auto_bd_research/development_preliminary_seed1')
for path in sorted(base.glob('*/seed_1001/standard_results')):
    found = {p.name for p in path.iterdir()}
    assert found == files, path
print('standard result file sets ok')
PY
```

Result: `standard result file sets ok`.

TODO status:

- marked current seed-1 Gate 0 coverage and coverage-delta reporting
  complete for all six current development arms
- marked report-input identification, canonical netlist hashing, fixed
  common-audit binning, standard result emission, common-audit QD
  score/coverage, and exp-artifact linking complete
- left PPA/hypervolume normalization, duplicate-cell leakage,
  PPA-relevant diversity, centralized reports, seed-3/seed-5 evaluation,
  and stronger functional correctness audits open

## 2026-06-18 20:40 UTC

Added the seed-1 centralized Auto-BD report generator and generated the
first cross-method report from standard artifacts.

Changed code:

- `scripts/report_auto_bd_standard_results.py`
- `tests/scripts/test_report_auto_bd_standard_results.py`

Generated report artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`

Report inputs:

- `exp/auto_bd_research/development_preliminary_seed1/*/seed_1001/standard_results/`
- reference PPA files under `data/bench/<benchmark>/<problem>_ppa.txt`

PPA/HV normalization fixed for seed-1 reporting:

- objective directions: minimize area, power, and effective clock
- normalized improvement:
  `(reference - candidate) / max(abs(reference), 1e-12)`
- combinational problems use area/power
- sequential problems add effective clock period
- hypervolume uses normalized improvement space against zero improvement
- negative objective improvements are clipped to zero inside HV
- invalid candidates remain in robustness counts but are excluded from
  valid-only PPA/HV

Central report surfaces:

- Gate 0 matrix for all six seed-1 arms
- leaderboard with valid-PPA count, mean best fitness, mean HV, W/T/L
  counts, netlist/motif diversity, common-audit QD, runtime, and LLM
  calls
- per-problem fitness/HV win-loss-tie matrix against classic REvolution
- per-problem PPA/HV/diversity table with Pareto points,
  reference-beating count, duplicate netlists, motif-signature diversity,
  and unique canonical netlists on the PPA Pareto front

Seed-1 summary:

- all six current arms pass development seed-1 Gate 0
- `classic_revolution` remains the strongest seed-1 mean-fitness and mean
  HV reference
- `random_descriptor_qd` and `synthesis_trajectory_nod` each have two
  per-problem HV wins but no best-fitness wins under the 0.03 fitness
  equivalence margin
- `synthesis_trajectory_nod` has the highest unique canonical netlist
  count and motif-signature count in this seed-1 report
- motif-only remains weaker on mean HV and mean best fitness, matching
  the earlier accept/reject caution

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_standard_results.py \
  --results-root exp/auto_bd_research/development_preliminary_seed1 \
  --output-md docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.md \
  --output-json docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json
```

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

TODO status:

- marked PPA/HV normalization complete for the current seed-1 reporting
  layer
- marked motif-signature and PPA-relevant uniqueness checks complete
- marked centralized cross-method report generation complete
- marked leaderboard, gate matrix, per-problem win/loss matrix, and
  compute-cost comparison complete
- left per-method artifact report generation, robustness funnel,
  anytime curves, archive entropy/heatmaps, descriptor correlation,
  representative elites, seed-3/seed-5 evaluation, and functional audits
  open

## 2026-06-18 20:47 UTC

Extended the seed-1 centralized report with robustness/failure and
anytime evidence from the standard candidate tables.

Changed code:

- `scripts/report_auto_bd_standard_results.py`
- `tests/scripts/test_report_auto_bd_standard_results.py`

Regenerated artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`

New report surfaces:

- robustness funnel by method:
  total candidates, syntax pass, functionality pass, synthesis pass,
  OpenROAD pass, valid-PPA count, and corresponding rates
- failure breakdown by method and failure reason
- anytime summary by method:
  final generation, final covered problems, final mean best fitness,
  final mean hypervolume, mean-best-fitness AUC, and mean-HV AUC
- machine-readable per-generation anytime rows in JSON:
  `anytime_metrics`

Seed-1 observations:

- all six arms still pass Gate 0
- `landing_smooth_qd_manual_bd` has the highest seed-1 valid-PPA rate
  at 76.0 percent
- `classic_revolution` remains strongest in final mean fitness and final
  mean HV
- `random_descriptor_qd` has the strongest seed-1 mean-best-fitness AUC
  and mean-HV AUC, but this is exploratory seed-1 evidence only
- `netlist_motif_occupancy` has the weakest seed-1 valid-PPA rate and
  mean HV among current arms

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_standard_results.py \
  --results-root exp/auto_bd_research/development_preliminary_seed1 \
  --output-md docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.md \
  --output-json docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json
```

Report JSON checks:

```bash
jq '{robustness: (.robustness_funnel | length), failures: (.failure_breakdown | length), anytime_summary: (.anytime_summary | length), anytime_metrics: (.anytime_metrics | length)}' \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json
```

Result:

- robustness rows: 6
- failure rows: 19
- anytime summary rows: 6
- anytime metric rows: 24

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

TODO status:

- marked robustness funnel and failure breakdown complete
- marked seed-1 preliminary reports complete
- left plotted PPA/HV curves open; the JSON now has per-generation
  curve-ready data, but no chart artifacts

## 2026-06-18 20:56 UTC

Added plotted seed-1 anytime figures for the centralized Auto-BD report.

Changed code:

- `scripts/report_auto_bd_standard_results.py`
- `tests/scripts/test_report_auto_bd_standard_results.py`

Regenerated report artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`

New figure artifacts:

- `auto_bd_seed1_figures/anytime_mean_best_fitness.png`
- `auto_bd_seed1_figures/anytime_mean_hypervolume.png`

The Markdown and JSON reports now link these figure paths. The figures
are generated from the same `anytime_metrics` rows used in the central
JSON report, so the plotted curves and machine-readable metrics share one
data source.

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_standard_results.py \
  --results-root exp/auto_bd_research/development_preliminary_seed1 \
  --output-md docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.md \
  --output-json docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json \
  --figure-dir docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures
```

Artifact checks:

```bash
file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/*.png
```

Result:

- both figure files are 1440x864 PNG images

```bash
python - <<'PY'
from pathlib import Path
base = Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures')
for name in ['anytime_mean_best_fitness.png', 'anytime_mean_hypervolume.png']:
    data = (base / name).read_bytes()
    assert data.startswith(b'\x89PNG'), name
    assert len(data) > 1000, name
print('figure artifacts ok')
PY
```

Result: `figure artifacts ok`.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed in 99.16 seconds.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

TODO status:

- marked PPA anytime and hypervolume curves complete for the seed-1
  centralized report
- left QD entropy/archive visualizations and descriptor-correlation
  heatmaps open

## 2026-06-19 06:05 KST

Extended the centralized seed-1 Auto-BD report with QD/archive metrics
and archive visualizations.

Code changes:

- `scripts/report_auto_bd_standard_results.py` now loads
  `descriptor_vectors.parquet` and emits `qd_summary` plus
  `archive_metrics` in the central JSON report.
- The QD summary reports internal occupied cells/internal QD score where
  available, fixed common-audit occupied cells, common-audit coverage,
  common-audit QD score, common-audit entropy, and normalized
  common-audit entropy.
- Entropy is computed over `(problem_id, archive_cell_id)` occupancy so
  the metric is not inflated by merging different benchmark problems into
  one descriptor space.
- `write_figures` now emits three QD/archive figures in addition to the
  existing anytime plots:
  - `qd_common_audit_coverage.png`
  - `qd_common_audit_entropy.png`
  - `qd_common_audit_cells_heatmap.png`

Regenerated artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`
- `auto_bd_seed1_figures/qd_common_audit_coverage.png`
- `auto_bd_seed1_figures/qd_common_audit_entropy.png`
- `auto_bd_seed1_figures/qd_common_audit_cells_heatmap.png`

Report-generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_standard_results.py \
  --results-root exp/auto_bd_research/development_preliminary_seed1 \
  --repo-root . \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.md \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json \
  --figure-dir \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures
```

Result:

- wrote the central markdown report
- wrote the central JSON report
- generated the three new QD/archive PNGs

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed in 34.93s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

PNG validation:

```bash
file \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/*.png
```

Result: all five report figures are valid PNG images.

## 2026-06-19 06:17 KST

Extended the centralized seed-1 Auto-BD report with descriptor/PPA
correlation evidence.

Code changes:

- `scripts/report_auto_bd_standard_results.py` now emits
  `descriptor_correlations` in the central JSON report.
- Correlations are computed from standardized candidate and descriptor
  tables by joining on `(problem_id, candidate_id)`.
- Internal descriptor and fixed common-audit descriptor spaces are kept
  separate so method-specific BDs do not get compared as if they shared
  axes.
- The report now generates three correlation figures:
  - `descriptor_common_audit_ppa_correlation.png`
  - `descriptor_internal_ppa_correlation.png`
  - `manual_bd_ppa_correlation.png`

Regenerated artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`
- `auto_bd_seed1_figures/descriptor_common_audit_ppa_correlation.png`
- `auto_bd_seed1_figures/descriptor_internal_ppa_correlation.png`
- `auto_bd_seed1_figures/manual_bd_ppa_correlation.png`

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed in 3.61s after fixing an initial dataframe merge
column-collision bug.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact checks:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path
p=Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json')
payload=json.loads(p.read_text(encoding='utf-8'))
rows=payload['descriptor_correlations']
assert rows
assert {row['descriptor_space'] for row in rows} == {'internal', 'common_audit'}
manual=[row for row in rows if row['method_name']=='landing_smooth_qd_manual_bd' and row['descriptor_space']=='internal']
assert manual
for name in ['descriptor_common_audit_ppa_correlation','descriptor_internal_ppa_correlation','manual_bd_ppa_correlation']:
    fig=Path(payload['figure_paths'][name])
    assert fig.read_bytes().startswith(b'\x89PNG'), name
print('descriptor correlation artifact check ok')
PY
```

Result: `descriptor correlation artifact check ok`.

## 2026-06-19 06:25 KST

Added representative elite examples to the seed-1 centralized Auto-BD
report.

Code changes:

- `scripts/report_auto_bd_standard_results.py` now loads
  `elites.parquet` from each standard result directory.
- The central JSON report now emits `representative_elites`.
- The representative set includes one best-fitness elite per method and
  one best-fitness elite for every `(method, problem)` pair.
- Each elite row includes PPA, descriptor vector, common-audit vector,
  archive cells, canonical netlist hash, motif-signature hash, RTL path,
  netlist path, and log path.
- The Markdown report includes a compact best-per-method table and keeps
  the per-problem examples in the JSON artifact to avoid an oversized
  report table.

Regenerated artifacts:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 2 passed in 99.81s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path
p=Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json')
payload=json.loads(p.read_text(encoding='utf-8'))
rows=payload['representative_elites']
assert len(rows) == 42
assert sum(row['selection_kind'] == 'method_best_fitness' for row in rows) == 6
assert sum(row['selection_kind'] == 'problem_best_fitness' for row in rows) == 36
for row in rows:
    assert row['rtl_path']
    assert row['netlist_path']
    assert row['canonical_netlist_hash']
print('representative elite artifact check ok')
PY
```

Result: `representative elite artifact check ok`.

## 2026-06-19 06:33 KST

Implemented per-method artifact report generation for the seed-1
Auto-BD method arms.

Added:

- `scripts/report_auto_bd_method_results.py`
- `tests/scripts/test_report_auto_bd_method_results.py`

Generated reports:

- `auto_bd_methods/00_random_descriptor/seed1_artifact_report.md`
- `auto_bd_methods/01_yosys_stat_bd/seed1_artifact_report.md`
- `auto_bd_methods/02_netlist_motif_occupancy/seed1_artifact_report.md`
- `auto_bd_methods/03_synthesis_trajectory_nod/seed1_artifact_report.md`

The generator reads the centralized seed-1 JSON report, then writes one
method-local report per configured Auto-BD method. Each report includes
Gate 0 status, PPA/diversity summary, robustness funnel, QD archive
metrics, representative elite examples, and the standard result root.
Interpretation remains in each method's `accept_reject.md`.

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_method_results.py \
  --central-report-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json \
  --method-root \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods \
  --output-name seed1_artifact_report.md
```

Result: wrote all four configured method reports.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_method_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 3 passed in 101.70s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_method_results.py \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_method_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_method_results.py \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_method_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_method_results.py \
  scripts/report_auto_bd_standard_results.py \
  tests/scripts/test_report_auto_bd_method_results.py \
  tests/scripts/test_report_auto_bd_standard_results.py
```

Result: 0 errors, 0 warnings, 0 informations.

Report content check:

```bash
for f in docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/*/seed1_artifact_report.md; do
  rg -n "^# |^## Gate 0|^## Representative Elites|accept_reject|Standard result root" "$f"
done
```

Result: all four reports include source, Gate 0, representative elites,
and `accept_reject.md` guidance.

## 2026-06-19 06:39 KST

Predeclared seed-3 promotion thresholds and generated the seed-1
promotion decision artifact.

Added:

- `scripts/report_auto_bd_promotion_decisions.py`
- `tests/scripts/test_report_auto_bd_promotion_decisions.py`
- `auto_bd_seed1_promotion_decisions.md`
- `auto_bd_seed1_promotion_decisions.json`

Threshold policy:

- Gate 0: cover every classic-covered problem; more than 5 percent
  problem-seed misses is high risk.
- Gate 1: no more than 5 percentage-point drop versus landing
  Smooth-QD manual-BD in functionality, synthesis, OpenROAD, or valid-PPA
  rates.
- Gate 2: final sign-off requires at least 10 percent relative uplift in
  mean best fitness or hypervolume, or two additional positive-PPA
  problems.
- Gate 3: final sign-off requires at least 15 percent QD-score uplift,
  20 percent common-audit coverage uplift, or 25 percent unique-netlist
  uplift.
- Seed-1 development evidence is treated as underpowered for final
  claims; it is used only for Gate 0, robustness, and seed-3 screening
  promotion.

Promotion result:

- Retain `classic_revolution` as baseline comparator.
- Retain `landing_smooth_qd_manual_bd` as baseline comparator.
- Promote `random_descriptor_qd` as the seed-3 screening control because
  it passes development Gate 0 and Gate 1.
- Do not promote `simple_yosys_stat_bd`; it fails Gate 1 with a 6.25
  percentage-point functionality/valid-PPA drop versus landing manual-BD.
- Do not promote `netlist_motif_occupancy`; it fails Gate 1 with a 9.38
  percentage-point functionality/valid-PPA drop.
- Promote `synthesis_trajectory_nod` as the seed-3 Auto-BD method because
  it passes development Gate 0 and Gate 1.

Seed-3 screening arms:

- `classic_revolution`
- `landing_smooth_qd_manual_bd`
- `random_descriptor_qd`
- `synthesis_trajectory_nod`

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_promotion_decisions.py \
  --central-report-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_promotion_decisions.md \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_promotion_decisions.json
```

Result: wrote the Markdown and JSON promotion artifacts.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_promotion_decisions.py
```

Result: 1 passed in 0.61s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_promotion_decisions.py \
  tests/scripts/test_report_auto_bd_promotion_decisions.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_promotion_decisions.py \
  tests/scripts/test_report_auto_bd_promotion_decisions.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_promotion_decisions.py \
  tests/scripts/test_report_auto_bd_promotion_decisions.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path
p=Path('docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_promotion_decisions.json')
payload=json.loads(p.read_text())
assert payload['seed3_screening_arms'] == ['classic_revolution', 'landing_smooth_qd_manual_bd', 'random_descriptor_qd', 'synthesis_trajectory_nod']
decisions={row['method_name']: row for row in payload['decisions']}
assert decisions['synthesis_trajectory_nod']['decision'] == 'PROMOTE_TO_SEED3'
assert decisions['random_descriptor_qd']['decision'] == 'PROMOTE_TO_SEED3'
assert decisions['simple_yosys_stat_bd']['decision'] == 'DO_NOT_PROMOTE'
assert decisions['netlist_motif_occupancy']['decision'] == 'DO_NOT_PROMOTE'
assert payload['thresholds']['gate1_robustness']['max_functionality_drop_pp'] == 5.0
print('promotion decision artifact check ok')
PY
```

Result: `promotion decision artifact check ok`.

## 2026-06-18 21:45 UTC

Generated the promoted-arm seed-3 main screening run matrix.

Scope:

- Added `--arms` filtering to `scripts/build_auto_bd_run_matrix.py` so a
  phase matrix can be restricted to promoted arms without editing the lock
  policy.
- Kept the seed-3 matrix restricted to `classic_revolution`,
  `landing_smooth_qd_manual_bd`, `random_descriptor_qd`, and
  `synthesis_trajectory_nod` based on the seed-1 promotion artifact.
- Wrote exact per-arm configs under
  `auto_bd_run_configs/main_screening/`.

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_run_matrix.py \
  --phase main_screening \
  --arms classic_revolution landing_smooth_qd_manual_bd \
  random_descriptor_qd synthesis_trajectory_nod
```

Result:

- `auto_bd_main_screening_run_matrix.json`
- `auto_bd_main_screening_run_matrix.sh`
- 24 run entries: 4 arms x 3 seeds x 2 benchmark groups
- 12 manifest commands
- 13 main-screening problems: 7 RTLLM and 6 VerilogEval
- 128k token and 131072 minimum model-length settings preserved

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 3 passed in 1.03s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py
```

Result: 0 errors, 0 warnings, 0 informations.

Matrix content check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_matrix.json"
)
payload = json.loads(p.read_text())
assert payload["phase"] == "main_screening"
assert payload["arms"] == [
    "classic_revolution",
    "landing_smooth_qd_manual_bd",
    "random_descriptor_qd",
    "synthesis_trajectory_nod",
]
assert len(payload["manifest_commands"]) == 12
assert len(payload["entries"]) == 24
assert {entry["seed"] for entry in payload["entries"]} == {1001, 1002, 1003}
assert {entry["benchmark"] for entry in payload["entries"]} == {
    "RTLLM",
    "VerilogEval-Spec-to-RTL",
}
assert all("--max_tokens 128000" in e["command_string"] for e in payload["entries"])
assert all(
    "--diff_max_tokens 128000" in e["command_string"]
    for e in payload["entries"]
)
assert all(
    "--vllm_min_model_len 131072" in e["command_string"]
    for e in payload["entries"]
)
print("seed3 run matrix check ok")
PY
```

Result: `seed3 run matrix check ok`.

Shell validation:

```bash
bash -n \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.sh
```

Result: passed.

## 2026-06-18 21:50 UTC

Implemented the ST-NOD motif-plus-trajectory ablation.

Scope:

- Added `stnod_motif_trajectory_9d` to the ST-NOD descriptor profile.
- Added `config_motif_trajectory.yaml` under the existing ST-NOD method
  directory.
- Added `synthesis_trajectory_motif_nod` to the locked run policy as an
  ablation arm for motif-only versus trajectory-motif comparison.
- Wired the ablation arm into `scripts/build_auto_bd_run_matrix.py`.
- Updated tests so the hybrid profile requires both final-netlist motif
  metrics and Yosys stage dumps.

Status:

- The descriptor combination is implemented.
- The motif-only versus trajectory-motif experimental comparison is still
  pending; no result/report claim was made in this entry.

Development matrix refresh:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_run_matrix.py \
  --phase development \
  --output-dir \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research \
  --run-root exp/auto_bd_research
```

Result: regenerated the development run matrix with 14 entries,
including the new `synthesis_trajectory_motif_nod` ablation arm.

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_build_auto_bd_run_matrix.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_auto_bd_trajectory_descriptor.py
```

Result: 34 passed in 76.70s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py \
  tests/revolution/test_qd_descriptors.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py \
  tests/revolution/test_qd_descriptors.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/build_auto_bd_run_matrix.py \
  tests/scripts/test_build_auto_bd_run_matrix.py \
  tests/revolution/test_qd_descriptors.py
```

Result: 0 errors, 0 warnings, 0 informations.

Matrix content check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_development_run_matrix.json"
)
payload = json.loads(p.read_text())
assert payload["phase"] == "development"
assert payload["arms"][-1] == "synthesis_trajectory_motif_nod"
assert len(payload["manifest_commands"]) == 7
assert len(payload["entries"]) == 14
hybrid = [
    e for e in payload["entries"]
    if e["arm_name"] == "synthesis_trajectory_motif_nod"
]
assert len(hybrid) == 2
assert all(
    "--qd_descriptor_profile stnod_motif_trajectory_9d" in e["command_string"]
    for e in hybrid
)
assert all("--max_tokens 128000" in e["command_string"] for e in payload["entries"])
assert all(
    "--diff_max_tokens 128000" in e["command_string"]
    for e in payload["entries"]
)
print("development hybrid matrix check ok")
PY
```

Result: `development hybrid matrix check ok`.

Shell validation:

```bash
bash -n \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_development_run_matrix.sh
```

Result: passed.

## 2026-06-18 22:29 UTC

Ran and reported the seed-1 ST-NOD motif-plus-trajectory ablation.

Preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result: `openai/gpt-oss-120b` was available with `max_model_len` 131072.

Manifest command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python \
  scripts/build_auto_bd_run_manifest.py \
  --config-path \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_run_configs/development/synthesis_trajectory_motif_nod.yaml \
  --phase development \
  --output \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/run_manifest.json
```

Result: wrote the hybrid ablation run manifest.

Run commands:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob011_multi_16bit Prob019_sub_64bit Prob048_pe \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --evaluation_mode strict_ablation \
  --total_worker_slots 12 \
  --max_active_problems 6 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile stnod_motif_trajectory_9d \
  --qd_descriptor_file \
  /workspace/.worktrees/journal-auto-bd-exp-20260618/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/descriptor_profile.yaml
```

Result: RTLLM completed in 652.53 seconds.

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob021_mux256to1v Prob030_popcount255 Prob105_rotate100 \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 12 \
  --num_generations 3 \
  --evaluation_mode strict_ablation \
  --total_worker_slots 12 \
  --max_active_problems 6 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile stnod_motif_trajectory_9d \
  --qd_descriptor_file \
  /workspace/.worktrees/journal-auto-bd-exp-20260618/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/descriptor_profile.yaml
```

Result: VerilogEval completed in 655.33 seconds.

Standard result command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/revolution/openai_gpt-oss-120b \
  --output-dir \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/standard_results \
  --method-name synthesis_trajectory_motif_nod \
  --method-family synthesis_trajectory_nod \
  --descriptor-version stnod_motif_trajectory_9d \
  --phase development_preliminary_seed1 \
  --seed 1001 \
  --run-manifest \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/run_manifest.json
```

Result:

- candidates: 288
- valid PPA: 198
- unique canonical netlists: 77
- unique motif signatures: 45
- common-audit occupied cells: 16
- common-audit QD score: 1.7144

Gate 0 command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/summarize_auto_bd_gate0.py \
  --run-dir \
  exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/revolution/openai_gpt-oss-120b \
  --method-name synthesis_trajectory_motif_nod \
  --phase development_preliminary_seed1 \
  --seed 1001 \
  --output \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_gate0_coverage_seed1_synthesis_trajectory_motif_nod.json
```

Result: Gate 0 PASS with 6 covered classic problems and no missing
classic problems.

Central report command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_standard_results.py \
  --results-root exp/auto_bd_research/development_preliminary_seed1 \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_hybrid_ablation_report.md \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_hybrid_ablation_report.json \
  --figure-dir \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/figures/seed1_hybrid_ablation
```

Result: wrote the hybrid-ablation central Markdown, JSON, and figures.

Decision:

- `synthesis_trajectory_motif_nod` passes Gate 0.
- It improves diversity versus motif-only and trajectory-only:
  77 unique canonical netlists and 16 common-audit occupied cells.
- It does not improve seed-1 PPA/HV over trajectory-only ST-NOD:
  198 valid PPA versus 205, mean best fitness 0.2380 versus 0.2511,
  and mean hypervolume 0.1204 versus 0.1208.
- Decision: do not promote the hybrid ablation to seed-3 screening;
  keep trajectory-only ST-NOD as the promoted method.

Generated docs:

- `auto_bd_seed1_hybrid_ablation_report.md`
- `auto_bd_seed1_hybrid_ablation_report.json`
- `auto_bd_gate0_coverage_seed1_synthesis_trajectory_motif_nod.json`
- updated `auto_bd_standard_results_seed1.md`
- `auto_bd_methods/03_synthesis_trajectory_nod/seed1_hybrid_ablation_report.md`
- `auto_bd_methods/03_synthesis_trajectory_nod/hybrid_ablation_accept_reject.md`

## 2026-06-18 22:36 UTC

Added a seed-3 main-screening run-status helper.

Scope:

- Added `scripts/report_auto_bd_run_matrix_status.py`.
- Added `tests/scripts/test_report_auto_bd_run_matrix_status.py`.
- Generated:
  - `auto_bd_main_screening_run_status.md`
  - `auto_bd_main_screening_run_status.json`
- Updated `START_HERE.md` to link the main-screening matrix and status
  artifacts.

Current seed-3 status:

- manifest commands: 0 complete, 12 pending
- benchmark commands: 0 complete, 24 pending
- arm/seed pairs: 0 complete, 12 pending
- promoted arms:
  `classic_revolution`, `landing_smooth_qd_manual_bd`,
  `random_descriptor_qd`, `synthesis_trajectory_nod`

Generation command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: 2 passed in 0.72s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["phase"] == "main_screening"
assert payload["manifest_summary"] == {"pending": 12, "total": 12}
assert payload["entry_summary"] == {"pending": 24, "total": 24}
assert payload["arm_seed_summary"] == {"pending": 12, "total": 12}
assert len(payload["next_pending_commands"]) == 4
print("main screening status artifact check ok")
PY
```

Result: `main screening status artifact check ok`.

## 2026-06-18 22:42 UTC

Generated all seed-3 main-screening run manifests.

Manifest batch command:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
import shlex
import subprocess
from pathlib import Path

matrix = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_matrix.json"
)
payload = json.loads(matrix.read_text())
for index, row in enumerate(payload["manifest_commands"], start=1):
    print(f"[{index}/{len(payload['manifest_commands'])}] {row['arm_name']} seed {row['seed']}", flush=True)
    subprocess.run(shlex.split(row["command_string"]), check=True)
PY
```

Result: wrote 12 ignored `exp/` run manifests:

- 4 promoted arms
- 3 seeds per arm
- phase: `main_screening`
- seed policy: `screening_seed3`

Status-helper fix:

- Corrected `scripts/report_auto_bd_run_matrix_status.py` so a
  manifest-only save directory remains `pending`.
- A benchmark command becomes `partial` only after its benchmark run tree
  exists.

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 0 complete, 24 pending
- arm/seed pairs: 0 complete, 12 pending

Validation:

```bash
UV_LINK_MODE=copy uv run --active pytest \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: 2 passed in 1.40s.

```bash
UV_LINK_MODE=copy uv run --active ruff check \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: all checks passed.

```bash
uv tool run ty check \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: all checks passed.

```bash
UV_LINK_MODE=copy uv run --active pyright \
  scripts/report_auto_bd_run_matrix_status.py \
  tests/scripts/test_report_auto_bd_run_matrix_status.py
```

Result: 0 errors, 0 warnings, 0 informations.

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"pending": 24, "total": 24}
assert payload["arm_seed_summary"] == {"pending": 12, "total": 12}
print("main screening manifest status check ok")
PY
```

Result: `main screening manifest status check ok`.

## 2026-06-18 23:20 UTC

Completed the first seed-3 main-screening benchmark command.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1001
- benchmark group: `RTLLM`
- run time: 1912.40 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_224539_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_224539_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_224539_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.0681326199880789 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.2283492764287466 |
| `Prob041_traffic_light` | `success` | 0.42853304284676835 |
| `Prob045_alu` | `success` | 0.4113455548984821 |
| `Prob049_signal_generator` | `success` | 0.2638032281317402 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 1 complete, 23 pending
- arm/seed pairs: 0 complete, 1 partial, 11 pending
- `classic_revolution` seed 1001: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 1, "pending": 23, "total": 24}
assert payload["arm_seed_summary"] == {"partial": 1, "pending": 11, "total": 12}
entry = payload["arm_seed_status"][0]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1001
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("first seed3 run status check ok")
PY
```

Result: `first seed3 run status check ok`.

## 2026-06-19 00:01 UTC

Completed the paired seed-3 main-screening command for
`classic_revolution` seed 1001.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1001
- benchmark group: `VerilogEval-Spec-to-RTL`
- run time: 2123.84 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_232439_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_232439_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b/20260618_232439_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob098_circuit7` | `success` | 0.01200564971751411 |
| `Prob116_m2014_q3` | `success` | 0.46535233160621764 |
| `Prob135_m2014_q6b` | `success` | 0.39769805680119585 |
| `Prob150_review2015_fsmonehot` | `success` | 0.32968627450980387 |
| `Prob151_review2015_fsm` | `success` | -0.21014555913884778 |
| `Prob153_gshare` | `success` | 0.1631082617311034 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 2 complete, 22 pending
- arm/seed pairs: 0 standard-results complete, 1 runs-complete, 11 pending
- `classic_revolution` seed 1001: runs complete, 2/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 2, "pending": 22, "total": 24}
assert payload["arm_seed_summary"] == {"pending": 11, "runs_complete": 1, "total": 12}
entry = payload["arm_seed_status"][0]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1001
assert entry["status"] == "runs_complete"
assert entry["benchmark_groups_complete"] == 2
print("classic seed1001 run status check ok")
PY
```

Result: `classic seed1001 run status check ok`.

## 2026-06-19 00:18 UTC

Generated standard results for `classic_revolution` seed 1001 in the
seed-3 main-screening matrix.

Standard result command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/revolution/openai_gpt-oss-120b \
  --output-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/standard_results \
  --method-name classic_revolution \
  --method-family baseline \
  --descriptor-version classic_revolution_v1 \
  --phase main_screening \
  --seed 1001 \
  --run-manifest \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/run_manifest.json
```

Result:

- standard result root:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/standard_results`
- problems: 13
- candidates: 1560
- valid PPA candidates: 740
- unique canonical netlists: 341
- unique motif signatures: 248
- common-audit occupied cells: 41
- common-audit QD score: 8.552644534445314

Standard files:

```text
archive_snapshots.parquet
candidates.parquet
descriptor_vectors.parquet
elites.parquet
method_summary.json
netlist_hashes.parquet
per_generation_metrics.parquet
per_problem_metrics.parquet
run_manifest.json
```

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 2 complete, 22 pending
- arm/seed pairs: 1 standard-results complete, 11 pending
- `classic_revolution` seed 1001: standard results complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

files = {
    "candidates.parquet",
    "elites.parquet",
    "archive_snapshots.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "descriptor_vectors.parquet",
    "netlist_hashes.parquet",
    "method_summary.json",
    "run_manifest.json",
}
standard = Path(
    "exp/auto_bd_research/main_screening_screening_seed3/"
    "classic_revolution/seed_1001/standard_results"
)
assert {path.name for path in standard.iterdir()} == files
summary = json.loads((standard / "method_summary.json").read_text())
assert summary["method_name"] == "classic_revolution"
assert summary["phase"] == "main_screening"
assert summary["seed"] == 1001
assert summary["problem_count"] == 13
assert summary["candidate_count"] == 1560
assert summary["valid_ppa_candidate_count"] == 740

status_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
status = json.loads(status_path.read_text())
assert status["arm_seed_summary"] == {
    "pending": 11,
    "standard_results_complete": 1,
    "total": 12,
}
entry = status["arm_seed_status"][0]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1001
assert entry["status"] == "standard_results_complete"
print("classic seed1001 standard results check ok")
PY
```

Result: `classic seed1001 standard results check ok`.

## 2026-06-19 00:50 UTC

Completed the next seed-3 main-screening benchmark command.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1002 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1002
- benchmark group: `RTLLM`
- run time: 1987.65 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_001545_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_001545_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_001545_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.23250999677398254 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.08458997628975556 |
| `Prob041_traffic_light` | `success` | 0.4344153957879448 |
| `Prob045_alu` | `success` | 0.41323979893554114 |
| `Prob049_signal_generator` | `success` | 0.25984938304829974 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 3 complete, 21 pending
- arm/seed pairs: 1 standard-results complete, 1 partial, 10 pending
- `classic_revolution` seed 1002: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 3, "pending": 21, "total": 24}
assert payload["arm_seed_summary"] == {
    "partial": 1,
    "pending": 10,
    "standard_results_complete": 1,
    "total": 12,
}
entry = payload["arm_seed_status"][1]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1002
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("classic seed1002 rttlm status check ok")
PY
```

Result: `classic seed1002 rttlm status check ok`.

## 2026-06-19 01:26 UTC

Completed the paired seed-3 main-screening command for
`classic_revolution` seed 1002.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1002 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1002
- benchmark group: `VerilogEval-Spec-to-RTL`
- run time: 1981.37 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_005258_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_005258_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b/20260619_005258_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob098_circuit7` | `success` | 0.01200564971751411 |
| `Prob116_m2014_q3` | `success` | 0.46535233160621764 |
| `Prob135_m2014_q6b` | `success` | 0.26414050822122576 |
| `Prob150_review2015_fsmonehot` | `success` | 0.32968627450980387 |
| `Prob151_review2015_fsm` | `success` | -0.1929191241271778 |
| `Prob153_gshare` | `success` | 0.15972044135971744 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 4 complete, 20 pending
- arm/seed pairs: 1 standard-results complete, 1 runs-complete, 10 pending
- `classic_revolution` seed 1002: runs complete, 2/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 4, "pending": 20, "total": 24}
assert payload["arm_seed_summary"] == {
    "pending": 10,
    "runs_complete": 1,
    "standard_results_complete": 1,
    "total": 12,
}
entry = payload["arm_seed_status"][1]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1002
assert entry["status"] == "runs_complete"
assert entry["benchmark_groups_complete"] == 2
print("classic seed1002 paired status check ok")
PY
```

Result: `classic seed1002 paired status check ok`.

## 2026-06-19 01:37 UTC

Generated standard results for `classic_revolution` seed 1002 in the
seed-3 main-screening matrix.

Standard result command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/revolution/openai_gpt-oss-120b \
  --output-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/standard_results \
  --method-name classic_revolution \
  --method-family baseline \
  --descriptor-version classic_revolution_v1 \
  --phase main_screening \
  --seed 1002 \
  --run-manifest \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/run_manifest.json
```

Result:

- standard result root:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/standard_results`
- problems: 13
- candidates: 1560
- valid PPA candidates: 735
- unique canonical netlists: 329
- unique motif signatures: 250
- common-audit occupied cells: 41
- common-audit QD score: 7.413841191035325

Standard files:

```text
archive_snapshots.parquet
candidates.parquet
descriptor_vectors.parquet
elites.parquet
method_summary.json
netlist_hashes.parquet
per_generation_metrics.parquet
per_problem_metrics.parquet
run_manifest.json
```

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 4 complete, 20 pending
- arm/seed pairs: 2 standard-results complete, 10 pending
- `classic_revolution` seed 1002: standard results complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

files = {
    "candidates.parquet",
    "elites.parquet",
    "archive_snapshots.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "descriptor_vectors.parquet",
    "netlist_hashes.parquet",
    "method_summary.json",
    "run_manifest.json",
}
standard = Path(
    "exp/auto_bd_research/main_screening_screening_seed3/"
    "classic_revolution/seed_1002/standard_results"
)
assert {path.name for path in standard.iterdir()} == files
summary = json.loads((standard / "method_summary.json").read_text())
assert summary["method_name"] == "classic_revolution"
assert summary["phase"] == "main_screening"
assert summary["seed"] == 1002
assert summary["problem_count"] == 13
assert summary["candidate_count"] == 1560
assert summary["valid_ppa_candidate_count"] == 735

status_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
status = json.loads(status_path.read_text())
assert status["arm_seed_summary"] == {
    "pending": 10,
    "standard_results_complete": 2,
    "total": 12,
}
entry = status["arm_seed_status"][1]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1002
assert entry["status"] == "standard_results_complete"
print("classic seed1002 standard results check ok")
PY
```

Result: `classic seed1002 standard results check ok`.

## 2026-06-19 02:10 UTC

Completed the next seed-3 main-screening benchmark command.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1003 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1003
- benchmark group: `RTLLM`
- run time: 1907.04 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_013848_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_013848_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_013848_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.22434044941785722 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.2283492764287466 |
| `Prob041_traffic_light` | `success` | 0.42657225853304287 |
| `Prob045_alu` | `success` | 0.41190387016229707 |
| `Prob049_signal_generator` | `success` | 0.26025712884096003 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 5 complete, 19 pending
- arm/seed pairs: 2 standard-results complete, 1 partial, 9 pending
- `classic_revolution` seed 1003: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 5, "pending": 19, "total": 24}
assert payload["arm_seed_summary"] == {
    "partial": 1,
    "pending": 9,
    "standard_results_complete": 2,
    "total": 12,
}
entry = payload["arm_seed_status"][2]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1003
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("classic seed1003 rttlm status check ok")
PY
```

Result: `classic seed1003 rttlm status check ok`.

## 2026-06-19 02:49 UTC

Completed the paired seed-3 main-screening command for
`classic_revolution` seed 1003.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1003 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003 \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual
```

Result:

- arm: `classic_revolution`
- seed: 1003
- benchmark group: `VerilogEval-Spec-to-RTL`
- run time: 2045.03 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_021437_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_021437_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b/20260619_021437_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob098_circuit7` | `success` | 0.01200564971751411 |
| `Prob116_m2014_q3` | `success` | 0.46535233160621764 |
| `Prob135_m2014_q6b` | `success` | 0.2636173393124066 |
| `Prob150_review2015_fsmonehot` | `success` | 0.32968627450980387 |
| `Prob151_review2015_fsm` | `success` | -0.1438256002014391 |
| `Prob153_gshare` | `success` | 0.13092220310027677 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 6 complete, 18 pending
- arm/seed pairs: 2 standard-results complete, 1 runs-complete, 9 pending
- `classic_revolution` seed 1003: runs complete, 2/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 6, "pending": 18, "total": 24}
assert payload["arm_seed_summary"] == {
    "pending": 9,
    "runs_complete": 1,
    "standard_results_complete": 2,
    "total": 12,
}
entry = payload["arm_seed_status"][2]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1003
assert entry["status"] == "runs_complete"
assert entry["benchmark_groups_complete"] == 2
print("classic seed1003 paired status check ok")
PY
```

Result: `classic seed1003 paired status check ok`.

## 2026-06-19 03:01 UTC

Generated standard results for `classic_revolution` seed 1003 in the
seed-3 main-screening matrix.

Standard result command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/revolution/openai_gpt-oss-120b \
  --output-dir \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/standard_results \
  --method-name classic_revolution \
  --method-family baseline \
  --descriptor-version classic_revolution_v1 \
  --phase main_screening \
  --seed 1003 \
  --run-manifest \
  exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/run_manifest.json
```

Result:

- standard result root:
  `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/standard_results`
- problems: 13
- candidates: 1560
- valid PPA candidates: 730
- unique canonical netlists: 301
- unique motif signatures: 220
- common-audit occupied cells: 36
- common-audit QD score: 8.181659506507073

Standard files:

```text
archive_snapshots.parquet
candidates.parquet
descriptor_vectors.parquet
elites.parquet
method_summary.json
netlist_hashes.parquet
per_generation_metrics.parquet
per_problem_metrics.parquet
run_manifest.json
```

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 6 complete, 18 pending
- arm/seed pairs: 3 standard-results complete, 9 pending
- all `classic_revolution` seed-3 runs now have standard results

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

files = {
    "candidates.parquet",
    "elites.parquet",
    "archive_snapshots.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "descriptor_vectors.parquet",
    "netlist_hashes.parquet",
    "method_summary.json",
    "run_manifest.json",
}
standard = Path(
    "exp/auto_bd_research/main_screening_screening_seed3/"
    "classic_revolution/seed_1003/standard_results"
)
assert {path.name for path in standard.iterdir()} == files
summary = json.loads((standard / "method_summary.json").read_text())
assert summary["method_name"] == "classic_revolution"
assert summary["phase"] == "main_screening"
assert summary["seed"] == 1003
assert summary["problem_count"] == 13
assert summary["candidate_count"] == 1560
assert summary["valid_ppa_candidate_count"] == 730

status_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
status = json.loads(status_path.read_text())
assert status["arm_seed_summary"] == {
    "pending": 9,
    "standard_results_complete": 3,
    "total": 12,
}
entry = status["arm_seed_status"][2]
assert entry["arm_name"] == "classic_revolution"
assert entry["seed"] == 1003
assert entry["status"] == "standard_results_complete"
print("classic seed1003 standard results check ok")
PY
```

Result: `classic seed1003 standard results check ok`.

## 2026-06-19 03:37 UTC

Completed the first seed-3 main-screening command for the landing
Smooth-QD manual-BD baseline.

Model endpoint preflight:

```bash
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_logic_ff_width_3d
```

Result:

- arm: `landing_smooth_qd_manual_bd`
- seed: 1001
- benchmark group: `RTLLM`
- run time: 2034.08 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_030154_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_030154_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_030154_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.06105036615113211 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.06325075627503886 |
| `Prob041_traffic_light` | `success` | 0.42675744371822805 |
| `Prob045_alu` | `success` | 0.4110166896642355 |
| `Prob049_signal_generator` | `success` | 0.25984938304829974 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py \
  --matrix \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json \
  --output-json \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.json \
  --output-md \
  docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_status.md
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 7 complete, 17 pending
- arm/seed pairs: 3 standard-results complete, 1 partial, 8 pending
- `landing_smooth_qd_manual_bd` seed 1001: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 7, "pending": 17, "total": 24}
assert payload["arm_seed_summary"] == {
    "partial": 1,
    "pending": 8,
    "standard_results_complete": 3,
    "total": 12,
}
entry = payload["arm_seed_status"][3]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1001
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("landing smooth seed1001 rttlm status check ok")
PY
```

Result: `landing smooth seed1001 rttlm status check ok`.

## 2026-06-19 04:23 UTC

Completed the paired seed-3 main-screening command for the landing
Smooth-QD manual-BD baseline.

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1001 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_logic_ff_width_3d
```

Result:

- arm: `landing_smooth_qd_manual_bd`
- seed: 1001
- benchmark group: `VerilogEval-Spec-to-RTL`
- run time: 2370.44 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_034208_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_034208_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b/20260619_034208_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob098_circuit7` | `success` | 0.01200564971751411 |
| `Prob116_m2014_q3` | `success` | 0.46535233160621764 |
| `Prob135_m2014_q6b` | `success` | 0.3977130044843049 |
| `Prob150_review2015_fsmonehot` | `success` | 0.32968627450980387 |
| `Prob151_review2015_fsm` | `success` | -0.1422179610099073 |
| `Prob153_gshare` | `success` | 0.1584042631431856 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 8 complete, 16 pending
- arm/seed pairs: 3 standard-results complete, 1 runs complete, 8 pending
- `landing_smooth_qd_manual_bd` seed 1001: runs complete, 2/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 8, "pending": 16, "total": 24}
assert payload["arm_seed_summary"] == {
    "pending": 8,
    "runs_complete": 1,
    "standard_results_complete": 3,
    "total": 12,
}
entry = payload["arm_seed_status"][3]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1001
assert entry["status"] == "runs_complete"
assert entry["benchmark_groups_complete"] == 2
print("landing smooth seed1001 pair status check ok")
PY
```

Result: `landing smooth seed1001 pair status check ok`.

## 2026-06-19 04:31 UTC

Packaged standard results for the landing Smooth-QD manual-BD seed-1001
main-screening run pair.

Packaging command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/revolution/openai_gpt-oss-120b \
  --output-dir exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/standard_results \
  --method-name landing_smooth_qd_manual_bd \
  --method-family smooth_qd_manual_bd \
  --descriptor-version journal_logic_ff_width_3d \
  --phase main_screening \
  --seed 1001 \
  --run-manifest exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/run_manifest.json
```

Standard-result files:

- `archive_snapshots.parquet`
- `candidates.parquet`
- `descriptor_vectors.parquet`
- `elites.parquet`
- `method_summary.json`
- `netlist_hashes.parquet`
- `per_generation_metrics.parquet`
- `per_problem_metrics.parquet`
- `run_manifest.json`

Method summary:

```json
{
  "candidate_count": 1560,
  "common_audit_occupied_cells": 38,
  "common_audit_qd_score": 7.320268796402099,
  "common_audit_total_cells": 256,
  "method_name": "landing_smooth_qd_manual_bd",
  "phase": "main_screening",
  "problem_count": 13,
  "seed": 1001,
  "unique_canonical_netlist_count": 357,
  "unique_motif_signature_count": 275,
  "valid_ppa_candidate_count": 785
}
```

Current seed-3 status after refresh:

- benchmark commands: 8 complete, 16 pending
- arm/seed pairs: 4 standard-results complete, 8 pending
- `landing_smooth_qd_manual_bd` seed 1001: standard results complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

root = Path(
    "exp/auto_bd_research/main_screening_screening_seed3/"
    "landing_smooth_qd_manual_bd/seed_1001/standard_results"
)
required = {
    "archive_snapshots.parquet",
    "candidates.parquet",
    "descriptor_vectors.parquet",
    "elites.parquet",
    "method_summary.json",
    "netlist_hashes.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "run_manifest.json",
}
assert {p.name for p in root.iterdir() if p.is_file()} == required
summary = json.loads((root / "method_summary.json").read_text())
assert summary["method_name"] == "landing_smooth_qd_manual_bd"
assert summary["candidate_count"] == 1560
assert summary["valid_ppa_candidate_count"] == 785
assert summary["unique_canonical_netlist_count"] == 357
assert summary["unique_motif_signature_count"] == 275

status_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(status_path.read_text())
assert payload["arm_seed_summary"] == {
    "pending": 8,
    "standard_results_complete": 4,
    "total": 12,
}
entry = payload["arm_seed_status"][3]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1001
assert entry["status"] == "standard_results_complete"
print("landing smooth seed1001 standard results check ok")
PY
```

Result: `landing smooth seed1001 standard results check ok`.

## 2026-06-19 05:09 UTC

Completed the first seed-3 main-screening command for landing
Smooth-QD manual-BD seed 1002.

Model endpoint preflight:

```bash
curl -s http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1002 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_logic_ff_width_3d
```

Result:

- arm: `landing_smooth_qd_manual_bd`
- seed: 1002
- benchmark group: `RTLLM`
- run time: 2027.30 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_043454_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_043454_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_043454_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.1412586937105224 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.468610906712452 |
| `Prob041_traffic_light` | `success` | 0.4736310820624546 |
| `Prob045_alu` | `success` | 0.4170231289835074 |
| `Prob049_signal_generator` | `success` | 0.25984938304829974 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 9 complete, 15 pending
- arm/seed pairs: 4 standard-results complete, 1 partial, 7 pending
- `landing_smooth_qd_manual_bd` seed 1002: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 9, "pending": 15, "total": 24}
assert payload["arm_seed_summary"] == {
    "partial": 1,
    "pending": 7,
    "standard_results_complete": 4,
    "total": 12,
}
entry = payload["arm_seed_status"][4]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1002
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("landing smooth seed1002 rttlm status check ok")
PY
```

Result: `landing smooth seed1002 rttlm status check ok`.

## 2026-06-19 05:52 UTC

Completed the paired seed-3 main-screening command for landing
Smooth-QD manual-BD seed 1002.

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1002 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_logic_ff_width_3d
```

Result:

- arm: `landing_smooth_qd_manual_bd`
- seed: 1002
- benchmark group: `VerilogEval-Spec-to-RTL`
- run time: 2306.86 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_051250_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_051250_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b/20260619_051250_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob098_circuit7` | `success` | 0.01200564971751411 |
| `Prob116_m2014_q3` | `success` | 0.46535233160621764 |
| `Prob135_m2014_q6b` | `success` | 0.2636173393124066 |
| `Prob150_review2015_fsmonehot` | `success` | 0.32968627450980387 |
| `Prob151_review2015_fsm` | `success` | -0.1071404359994964 |
| `Prob153_gshare` | `success` | 0.1459157415637549 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 10 complete, 14 pending
- arm/seed pairs: 4 standard-results complete, 1 runs complete, 7 pending
- `landing_smooth_qd_manual_bd` seed 1002: runs complete, 2/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 10, "pending": 14, "total": 24}
assert payload["arm_seed_summary"] == {
    "pending": 7,
    "runs_complete": 1,
    "standard_results_complete": 4,
    "total": 12,
}
entry = payload["arm_seed_status"][4]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1002
assert entry["status"] == "runs_complete"
assert entry["benchmark_groups_complete"] == 2
print("landing smooth seed1002 pair status check ok")
PY
```

Result: `landing smooth seed1002 pair status check ok`.

## 2026-06-19 05:54 UTC

Packaged standard results for the landing Smooth-QD manual-BD seed-1002
main-screening run pair.

Packaging command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/build_auto_bd_standard_results.py \
  --run-dir exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/revolution/openai_gpt-oss-120b \
  --output-dir exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/standard_results \
  --method-name landing_smooth_qd_manual_bd \
  --method-family smooth_qd_manual_bd \
  --descriptor-version journal_logic_ff_width_3d \
  --phase main_screening \
  --seed 1002 \
  --run-manifest exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/run_manifest.json
```

Standard-result files:

- `archive_snapshots.parquet`
- `candidates.parquet`
- `descriptor_vectors.parquet`
- `elites.parquet`
- `method_summary.json`
- `netlist_hashes.parquet`
- `per_generation_metrics.parquet`
- `per_problem_metrics.parquet`
- `run_manifest.json`

Method summary:

```json
{
  "candidate_count": 1560,
  "common_audit_occupied_cells": 41,
  "common_audit_qd_score": 9.788517579864838,
  "common_audit_total_cells": 256,
  "method_name": "landing_smooth_qd_manual_bd",
  "phase": "main_screening",
  "problem_count": 13,
  "seed": 1002,
  "unique_canonical_netlist_count": 342,
  "unique_motif_signature_count": 253,
  "valid_ppa_candidate_count": 807
}
```

Current seed-3 status after refresh:

- benchmark commands: 10 complete, 14 pending
- arm/seed pairs: 5 standard-results complete, 7 pending
- `landing_smooth_qd_manual_bd` seed 1002: standard results complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

root = Path(
    "exp/auto_bd_research/main_screening_screening_seed3/"
    "landing_smooth_qd_manual_bd/seed_1002/standard_results"
)
required = {
    "archive_snapshots.parquet",
    "candidates.parquet",
    "descriptor_vectors.parquet",
    "elites.parquet",
    "method_summary.json",
    "netlist_hashes.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "run_manifest.json",
}
assert {p.name for p in root.iterdir() if p.is_file()} == required
summary = json.loads((root / "method_summary.json").read_text())
assert summary["method_name"] == "landing_smooth_qd_manual_bd"
assert summary["candidate_count"] == 1560
assert summary["valid_ppa_candidate_count"] == 807
assert summary["unique_canonical_netlist_count"] == 342
assert summary["unique_motif_signature_count"] == 253

status_path = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(status_path.read_text())
assert payload["arm_seed_summary"] == {
    "pending": 7,
    "standard_results_complete": 5,
    "total": 12,
}
entry = payload["arm_seed_status"][4]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1002
assert entry["status"] == "standard_results_complete"
print("landing smooth seed1002 standard results check ok")
PY
```

Result: `landing smooth seed1002 standard results check ok`.

## 2026-06-19 06:34 UTC

Completed the first seed-3 main-screening command for landing
Smooth-QD manual-BD seed 1003.

Model endpoint preflight:

```bash
curl -s http://20.0.0.103:8000/v1/models
```

Result:

- model ID: `openai/gpt-oss-120b`
- `max_model_len`: 131072

Run command:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit Prob024_fsm Prob037_parallel2serial Prob041_traffic_light Prob045_alu Prob049_signal_generator \
  --api_backend vllm \
  --vllm_host 20.0.0.103 \
  --vllm_port 8000 \
  --vllm_min_model_len 131072 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --population_size 20 \
  --num_generations 5 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --total_worker_slots 13 \
  --max_active_problems 13 \
  --max_workers_per_problem 4 \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 300 \
  --post_synthesis_simulation_timeout_s 300 \
  --seed 1003 \
  --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003 \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.5 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile journal_logic_ff_width_3d
```

Result:

- arm: `landing_smooth_qd_manual_bd`
- seed: 1003
- benchmark group: `RTLLM`
- run time: 2112.88 seconds
- run log:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/revolution/openai_gpt-oss-120b/20260619_055708_revolution_run_log.txt`
- summary:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/revolution/openai_gpt-oss-120b/20260619_055708_revolution_summary_results.txt`
- scheduler telemetry:
  `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/revolution/openai_gpt-oss-120b/20260619_055708_revolution_scheduler_telemetry.json`

Problem outcomes:

| Problem | Status | Best Score |
| --- | --- | --- |
| `Prob004_adder_8bit` | `success` | 0.38154412826809186 |
| `Prob015_multi_pipe_8bit` | `success` | 0.06105036615113211 |
| `Prob024_fsm` | `success` | 0.6834970284641851 |
| `Prob037_parallel2serial` | `success` | 0.468610906712452 |
| `Prob041_traffic_light` | `success` | 0.44030803679496494 |
| `Prob045_alu` | `success` | 0.4139837045798016 |
| `Prob049_signal_generator` | `success` | 0.25984938304829974 |

Refreshed status command:

```bash
UV_LINK_MODE=copy uv run --active python \
  scripts/report_auto_bd_run_matrix_status.py
```

Current seed-3 status:

- manifest commands: 12 complete, 0 pending
- benchmark commands: 11 complete, 13 pending
- arm/seed pairs: 5 standard-results complete, 1 partial, 6 pending
- `landing_smooth_qd_manual_bd` seed 1003: partial, 1/2 benchmark groups complete

Artifact check:

```bash
UV_LINK_MODE=copy uv run --active python - <<'PY'
import json
from pathlib import Path

p = Path(
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_main_screening_run_status.json"
)
payload = json.loads(p.read_text())
assert payload["manifest_summary"] == {"complete": 12, "total": 12}
assert payload["entry_summary"] == {"complete": 11, "pending": 13, "total": 24}
assert payload["arm_seed_summary"] == {
    "partial": 1,
    "pending": 6,
    "standard_results_complete": 5,
    "total": 12,
}
entry = payload["arm_seed_status"][5]
assert entry["arm_name"] == "landing_smooth_qd_manual_bd"
assert entry["seed"] == 1003
assert entry["status"] == "partial"
assert entry["benchmark_groups_complete"] == 1
print("landing smooth seed1003 rttlm status check ok")
PY
```

Result: `landing smooth seed1003 rttlm status check ok`.
