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
