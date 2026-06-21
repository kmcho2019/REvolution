# RTL Diversity Check Experiment Implementation History

Unbounded journal for `rtl_diversity_check`. Record notable decisions,
commands, outputs, experiments, failed attempts, blockers, commits, and
validation evidence.

## Session Start - 2026-06-21 KST

- Branch: `feat/journal-diversity-check-exp-20260620`.
- Base branch: `feat/journal-auto-bd-exp-20260618`.
- Setup commit already present:
  `d4d5872f3f chore(devcontainer): enable gpu diversity audit setup`.
- Current goal-scaffold output directory:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/`.
- User intent: prepare a future `/goal` contract for testing whether
  implementation diversity matters for RTL/Verilog PPA evolution, using
  historical runs and pre-trained encoders before adding new AutoQD/AURORA
  mechanisms.
- Scope guard: this scaffold does not start the goal and does not implement
  the corpus indexer, embedding extraction, or analysis scripts.

## Branch And Devcontainer Notes

- The devcontainer should expose NVIDIA GPUs to both the main devcontainer
  service and optional `vllm` service.
- Historical REvolution data should be mounted read-only at
  `/aux/revolution-history`.
- The intended host path for the auxiliary mount is
  `/home/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution`.

## Initial Research Position

- The Auto-BD work established that descriptors can organize archives, but
  not that diversity pressure improves RTL PPA search.
- The next goal should test diversity as an empirical variable before adding
  more descriptor-learning complexity.
- Pre-trained encoders should be diagnostic first:
  Qwen3-Embedding-0.6B for RTL/source or netlist text, and DeepGate3 for
  synthesized netlist graphs when graph export is ready.
- AURORA-style custom encoder training is intentionally deferred.
- New live evolutionary runs are not the default path. If live runs or
  AURORA-style encoder training become necessary, the intended endpoint is
  `http://20.0.0.103:8000/v1/models` with `gpt-oss-120b`, served
  `max_model_len >= 131072`, and 128K-token REvolution settings to avoid
  reasoning-model output truncation.
- Development subsets are acceptable for debugging the pipeline, but final
  conclusions should use a large retrospective corpus or run. Broad RTLLM
  coverage is the preferred practical final target; VerilogEval evidence
  should be used when available but labeled partial if full-suite coverage is
  impractical.

## Notes Assimilation - 2026-06-21 KST

- User added `original_notes/notes_1.md` and `original_notes/notes_2.md` as
  disorganized source notes for the future goal scaffold.
- Those notes predate the 20260618 Auto-BD result push. The scaffold now
  treats Yosys-stat, motif histogram, ST-NOD, projected synthesis-response,
  VQ/codebook, and random descriptor results as existing control or negative
  evidence, not fresh promising defaults.
- The future study should test whether those failures came from weak RTL PPA
  diversity signal, wrong descriptor families, or diversity pressure that
  harmed exploitation and repair.
- The plan now makes reporting and visualization first-class outputs:
  encoder leaderboard, D1-D6 gates, diversity-vs-PPA regression,
  common-audit metrics, embedding/PPA-front plots, replay bars, stability
  boxplots, heatmaps, and representative implementation galleries.
- Qwen3-Embedding-0.6B and DeepGate3 remain the first diagnostic encoder
  paths. DeepSeq, NetTAG, CircuitFusion, larger Qwen variants, and AURORA or
  custom encoder training are explicitly later-stage unless the first-pass
  evidence justifies them.

## Goal Review Assimilation - 2026-06-21 KST

- Reviewed `original_notes/goal_v1_review.md`, `notes_3.md`, and `notes_4.md`.
- Accepted review points that close validation loopholes: formal claim levels,
  stricter utility-plus-meaning proceed rule, descriptor fitting/leakage
  policy, historical-corpus pairing labels, minimum D-gate evidence, oracle vs
  online-available downsampling split, validity-normalized diversity metrics,
  final A-F verdicts, Qwen style-leakage checks, and DeepGate3 sequential-state
  reporting.
- Rejected or deferred heavier suggestions that would bloat the first
  milestone: a new directory tree, full active quality-gated Auto-BD work
  package, and immediate VQ/AURORA/large-encoder method development. Those
  remain follow-on only after the retrospective study supports diversity.
- Strengthened the visual-evidence contract after user feedback: each main
  claim should pair a figure with a quantitative table, use declared
  case-study selection rules, include positive/null/negative examples where
  available, and tie visual conclusions to claim levels and D gates.

## Evidence To Record During The Future Goal

- Corpus roots scanned and artifact coverage.
- Candidate counts by method, model, seed, benchmark, and problem.
- Exact commands used to build audit tables and reports.
- Embedding model names, local paths or revisions, GPU device, batch size,
  max length, and output hashes.
- Analysis report paths and plots.
- Failed or inconclusive checks, especially missing lineage, missing PPA, or
  model/budget confounds.
- Commit hashes and validation commands.

## Goal Execution - 2026-06-20 UTC / 2026-06-21 KST

### Environment And Scope

- Branch/HEAD recorded with `git status --short && git branch --show-current
  && git rev-parse HEAD`:
  `feat/journal-diversity-check-exp-20260620` at
  `6a725c544265b35ffd9aa2792bc1d9974a152eaf`.
- Dirty state before this documentation update:
  `M GUIDELINES.md`, `?? .devcontainer/devcontainer-lock.json`,
  `?? scripts/report_rtl_diversity_check.py`, and
  `?? tests/scripts/test_report_rtl_diversity_check.py`. The first two were
  pre-existing/unrelated and were not modified for this goal.
- Container evidence: `hostname` returned `b2b60f6e4513`; `/etc/os-release`
  reports Ubuntu 22.04.5 LTS.
- GPU visibility: `nvidia-smi --query-gpu=name,memory.total
  --format=csv,noheader` returned one RTX A4000 and three RTX A6000 GPUs.
- Historical checkout mount: `findmnt -T /aux/revolution-history -o
  TARGET,SOURCE,FSTYPE,OPTIONS` reports NFS4 mounted with `ro` options from
  `20.0.0.51:/data/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution`.
  `test -w /aux/revolution-history` exited `1`, so the mounted checkout is not
  writable from the devcontainer.
- No live model calls or new live evolution runs were needed. The vLLM
  preflight and 128K-token live-run checks remain scoped out by policy.

### Corpus Inventory

- Auto-BD control roots indexed from
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3`.
  The indexed standard-results roots cover classic, manual-BD, random
  descriptor, sr-random-ReLU, and ST-NOD methods for seeds 1001, 1002, and
  1003.
- Auto-BD context read from
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`,
  including `auto_bd_final_negative_decision.md`,
  `auto_bd_seed3_screening_report.md`, and centralized JSON reports for seed 1
  and seed 3. The final report treats Yosys-stat, motif histogram, ST-NOD,
  projected synthesis response, VQ/codebook, and random descriptor arms as
  negative/control evidence.
- Historical RTLLM root selected as the largest practical conclusion corpus:
  `/aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506/revolution/_models_openai-gpt-oss-120b/RTLLM`.
  Coverage: 50 problems, 10,413 generated candidates, 10,413 RTL code
  artifacts, 2,600 synthesized netlist artifacts, and 2,335 PPA artifacts.
- `/aux/revolution-history/exp` was listed for historical context. The broad
  RTLLM run above was selected over smoke/debug roots for final claims.
- Local ASPDAC checkout check:
  `find /workspace -maxdepth 3 \( -type d -name '*aspdac*' -o -type d -name
  '*ASPDAC*' \)` returned no local checkout.
- Recoverable archived baselines were listed from `baselines/`:
  FunSearch, CodeEvolve, and EOH `raw_results.tar.xz` archives plus
  `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`. These
  were not unpacked because the broad paired RTLLM artifacts were sufficient
  for this post-hoc conclusion.
- VerilogEval was not used for final claims because the selected practical
  large corpus was RTLLM and no local full-suite VerilogEval corpus was needed.

### Implementation

- Added `scripts/report_rtl_diversity_check.py`.
- Added `tests/scripts/test_report_rtl_diversity_check.py`.
- The report script builds one candidate audit table and derived artifacts
  under `exp/diversity_check/`. It asserts required RTLLM and Auto-BD roots,
  reads standard-results summaries, computes lexical/structural descriptors,
  canonical netlist hashes, motif signatures, style clusters, Pareto/front
  metrics, cluster contribution, replay policies, early-diversity summaries,
  D1-D6 gates, L0-L5 claims, and the final verdict.
- Descriptor fitting leakage is avoided for predictive claims by not fitting
  PCA/scalers/clusters for D1. The report labels early-diversity evidence as
  uncontrolled single-run correlation and marks D1 as FAIL.
- Parent-child jump analysis was scoped out because lineage was not
  recoverable from the selected broad RTLLM artifacts.
- Qwen diagnostics include dry-run text coverage and comment/identifier
  stability checks for `Qwen/Qwen3-Embedding-0.6B`. The optional real smoke was
  attempted and blocked by `ModuleNotFoundError: No module named 'torch'`.
- DeepGate3 diagnostics were deferred with setup evidence:
  `deepgate3` was not importable, Yosys is available at `/usr/local/bin/yosys`,
  and the report records that future graph export must decide whether
  sequential elements are kept, cone-split, or dropped.

### Final Report Command And Artifacts

- Final command:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/full_20260620 --qwen-real-smoke --qwen-smoke-limit 64`.
- Main report artifacts:
  `exp/diversity_check/full_20260620/diversity_necessity_report.md` and
  `exp/diversity_check/full_20260620/diversity_necessity_report.json`.
- Audit/table artifacts:
  `candidate_audit.csv`, `candidate_audit.parquet`, `corpus_coverage.csv`,
  `problem_metrics.csv`, `cluster_summary.csv`, `counterfactual_replay.csv`,
  `early_diversity.csv`, `common_audit_metrics.csv`, `d_gate_matrix.csv`,
  `encoder_leaderboard.csv`, `claim_levels.csv`, and `case_studies.csv`.
- Diagnostic artifacts:
  `qwen_dry_run_coverage.csv`, `deepgate3_diagnostic_card.json`, and
  `implementation_gallery.md`.
- Figure artifacts:
  `figures/embedding_scatter.png`, `figures/ppa_front_by_cluster.png`,
  `figures/diversity_efficiency_frontier.png`,
  `figures/diversity_over_time_vs_quality.png`,
  `figures/early_diversity_vs_final_hv.png`,
  `figures/counterfactual_replay_bars.png`,
  `figures/descriptor_stability_boxplots.png`,
  `figures/correlation_heatmap.png`, `figures/common_audit_heatmap.png`, and
  `figures/validity_funnel.png`.
- Report artifact hashes:
  - `diversity_necessity_report.json`:
    `9687b373407e2b4be99b8d7b599bd54d7eb07823a25ebe487fb1af0688e42615`
  - `candidate_audit.csv`:
    `4ca353a5df7cdf10bb993aa5c4f9fec9a0c23c4de1518d8f9aa85467ce505bb6`
  - `qwen_dry_run_coverage.csv`:
    `829aa7512fcf8196a734a00fd7ef665dcfabe58f7acac611dae8aad941893cb6`
  - `deepgate3_diagnostic_card.json`:
    `0f4a27e12034480d1088cdd8f98e2c8f7af268f694b1201a494ef6529a658c63`

### Final Result

- Final verdict: `C reconstructive`.
- Candidate counts: 33,813 total; 10,413 RTLLM candidates; 23,400 Auto-BD
  control candidates; 50 RTLLM problems.
- D gates:
  - D1 early predictive: FAIL. Early lexical distance vs final HV rho is
    0.441, but the corpus has one historical run per problem without
    seed/model/budget controls.
  - D2 multi-cluster front: FAIL. 13.8% of analyzable valid-PPA problems have
    at least two style clusters on the Pareto front; shuffled-label rate is
    20.8%.
  - D3 replay retention: PASS. Best diversity oracle HV gain over
    best-fitness retention is 14.7%, above the 10% threshold. This is
    reconstructive/post-hoc evidence only.
  - D4 prospective moderate diversity: NOT_RUN.
  - D5 real beats random: FAIL because the 20260618 Auto-BD controls did not
    show robust PPA uplift and no new in-loop descriptor is promoted.
  - D6 interpretable regions: PASS with eight style clusters.
- Claim levels:
  L0 descriptive and L1 reconstructive are supported; L2 predictive, L3
  mechanistic, and L5 method are not supported; L4 active was not run.
- Interpretation: D3 plus D6 supports offline/reconstructive diversity
  follow-up, not a new Auto-BD default. Auto-BD follow-up is not justified as
  an in-loop candidate because D4 and D5 did not pass.

### Validation Commands

- `uv run pytest tests/scripts/test_report_rtl_diversity_check.py`:
  3 passed.
- `uv run ruff check scripts/report_rtl_diversity_check.py
  tests/scripts/test_report_rtl_diversity_check.py`: all checks passed.
- `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
  0 warnings, 0 informations. Pyright reported only that a newer pyright
  release is available.

### Adversarial Validation

- Independent subagent wrote
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md`.
- Verdict: PASS for the stated `C reconstructive` claim level.
- Subagent checks:
  - `uv run pytest -q -p no:cacheprovider
    tests/scripts/test_report_rtl_diversity_check.py`: 3 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    tests/scripts/test_report_rtl_diversity_check.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
    0 warnings, 0 informations.
  - Read-only recomputation from generated artifacts confirmed 33,813 total
    candidates, `C reconstructive` verdict, D3/D6 PASS, D1/D2/D5 FAIL, D4
    NOT_RUN, D3 replay gain 14.6926%, and D2 multi-cluster front rate below
    shuffled-label rate.
- Residual risks recorded by the validator: historical Auto-BD worktree Git
  status could not be checked because its `.git` pointer references an absent
  local worktree metadata path; the read-only mount still prevents writes.

## ASP-DAC Release Corpus Correction - 2026-06-20 UTC

- User pointed out that the rich past-run source is the `aspdac2026-paper`
  branch/release `exp/` directory, with DeepSeek-V3, GPT-4.1-mini, and
  Llama-3.2-70B-Instruct style runs over both RTLLM and
  VerilogEval-Spec-to-RTL.
- Local Git refs and `/aux/revolution-history/.worktrees` did not expose an
  `aspdac2026-paper` worktree. GitHub branch search confirmed that
  `aspdac2026-paper` exists. Public release tag
  `aspdac2026-submission` contains a tracked `exp/` tree.
- Downloaded release source archive to `/tmp/revolution-aspdac2026-submission.tar.gz`
  with:
  `curl -L --fail --max-time 120 -o /tmp/revolution-aspdac2026-submission.tar.gz https://github.com/kmcho2019/REvolution/archive/refs/tags/aspdac2026-submission.tar.gz`.
- Extracted the source archive under ignored output path
  `exp/diversity_check/aspdac2026_submission_source/`. The first full
  extraction was interrupted after slow NFS writes; a second
  `tar --skip-old-files -xzf ...` pass completed the tree.
- Verified ASP-DAC release coverage:
  824 summary JSON files total, with 206 problem summaries under each root:
  `deepseek_clean_results`, `gpt-4.1-mini_clean_results`,
  `llama3_baseline_clean_results`, and `llama3_clean_results`.
- Added an optional `--aspdac-root` loader to
  `scripts/report_rtl_diversity_check.py` for the ASP-DAC flat filename
  layout. The loader covers RTLLM and VerilogEval-Spec-to-RTL, and the report
  now uses this source for the final conclusion.
- Performance guard: ASP-DAC candidates without valid PPA do not read RTL text
  during annotation; ASP-DAC valid candidates use lexical/style RTL
  descriptors but skip content-derived canonical netlist and motif hashes.
  Legacy broad RTLLM candidates still compute canonical netlist and motif
  hashes.
- Added focused fixture coverage for the ASP-DAC flat layout in
  `tests/scripts/test_report_rtl_diversity_check.py`.

### Superseding Final Report

- Superseding command:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/full_20260620 --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --qwen-real-smoke --qwen-smoke-limit 64`.
- Main report artifacts remain under `exp/diversity_check/full_20260620/`.
- Report artifact hashes after the ASP-DAC rerun:
  - `diversity_necessity_report.json`:
    `c62f29a03f2fa816d8397db182b826316d1d6694b70a073cb254535a185ba523`
  - `candidate_audit.csv`:
    `8dcc4876fa5630bd1cb20bdc0476fc6140f5f7b737b0080645461c21221f34fc`
  - `qwen_dry_run_coverage.csv`:
    `829aa7512fcf8196a734a00fd7ef665dcfabe58f7acac611dae8aad941893cb6`
  - `deepgate3_diagnostic_card.json`:
    `0f4a27e12034480d1088cdd8f98e2c8f7af268f694b1201a494ef6529a658c63`

### Superseding Final Result

- Final verdict: `B illumination_only`.
- Candidate counts: 203,944 total; 180,544 evolution-analysis candidates;
  10,413 legacy broad RTLLM candidates; 170,131 ASP-DAC release candidates;
  23,400 Auto-BD control candidates.
- Final conclusion problem coverage: 874 evolution problem-runs; 697
  analyzable valid-PPA problem-runs for D2/D3/D6.
- D gates:
  - D1 early predictive: FAIL. Early lexical distance vs final HV rho is
    0.300, still a single-run uncontrolled post-hoc correlation.
  - D2 multi-cluster front: FAIL. 48.8% of analyzable valid-PPA problem-runs
    have at least two style clusters on the Pareto front, below the 60% gate
    and below the 56.0% shuffled-label rate.
  - D3 replay retention: FAIL. Best diversity oracle HV gain over
    best-fitness retention is 1.4%, below the 10% threshold.
  - D4 prospective moderate diversity: NOT_RUN.
  - D5 real beats random: FAIL because the 20260618 Auto-BD controls did not
    show robust PPA uplift and no new in-loop descriptor is promoted.
  - D6 interpretable regions: PASS with eight style clusters.
- Claim levels: L0 descriptive is supported; L1 reconstructive, L2
  predictive, L3 mechanistic, and L5 method are not supported; L4 active was
  not run.
- Interpretation: the ASP-DAC-backed corpus weakens the earlier
  RTLLM-only reconstructive signal. Current evidence supports illumination
  only: implementation regions are interpretable, but the utility gates do
  not justify predictive, reconstructive, active, or Auto-BD method claims.

### Superseding Validation Commands

- `uv run pytest tests/scripts/test_report_rtl_diversity_check.py`:
  4 passed.
- `uv run ruff check scripts/report_rtl_diversity_check.py
  tests/scripts/test_report_rtl_diversity_check.py`: all checks passed.
- `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
  0 warnings, 0 informations. Pyright reported only that a newer pyright
  release is available.

### Superseding Adversarial Validation Attempt

- Independent subagent initially returned FAIL for the revised
  `B illumination_only` report because the generated Markdown limits section
  still contained a stale `D3 plus D6 justify reconstructive/offline diversity
  follow-up` sentence from the earlier RTLLM-only result.
- Fixed `scripts/report_rtl_diversity_check.py` so the limits conclusion is
  D-gate aware. With D3 FAIL and D6 PASS, the report now states:
  `D6 supports illumination only; D1/D2/D3/D5 failed and D4 was not run, so
  the evidence does not justify reconstructive, predictive, active, or Auto-BD
  method claims.`
- Regenerated `exp/diversity_check/full_20260620/diversity_necessity_report.md`
  from the current JSON/CSV artifacts using the report writer.
- Post-fix checks:
  - `uv run pytest tests/scripts/test_report_rtl_diversity_check.py`:
    4 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    tests/scripts/test_report_rtl_diversity_check.py`: all checks passed.
  - `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
    0 warnings, 0 informations.
- Independent subagent rerun wrote
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md`.
- Final validation verdict: PASS for the current `B illumination_only` claim.
- Subagent recomputed D3 replay gain as 1.35%, D2 multi-cluster Pareto-front
  rate as 48.8% versus 56.0% shuffled-label rate, confirmed the stale
  reconstructive/offline sentence is absent from current report artifacts,
  and ran `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py`
  with 4 passed.

### Superseded Initial Report Archive

- Regenerated the derailed RTLLM-only initial report with:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/initial_rtllm_only_20260620_183839_UTC --qwen-real-smoke --qwen-smoke-limit 64`.
- Archived the report-facing Markdown, JSON, CSV diagnostics, implementation
  gallery, and 10 visualization PNGs under
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260620_183839_UTC_derailed_initial_report/`.
- Left the large raw audit dumps in ignored `exp/`:
  `candidate_audit.csv` is about 38 MB and `candidate_audit.parquet` is about
  4.6 MB for this RTLLM-only run.
- The archive preserves the superseded `C reconstructive` report for audit
  history only. The authoritative current result remains the ASP-DAC-backed
  `B illumination_only` report under `exp/diversity_check/full_20260620/`.

## Restart Decision - 2026-06-20 UTC

### Preliminary Audit Commit

- Committed the preliminary audit package as:
  `a5fc5018ab feat(diversity): Add preliminary RTL audit`.
- The commit includes `scripts/report_rtl_diversity_check.py`, focused tests,
  the Phase 0 history/TODO/validation record, and the timestamped archive of
  the derailed RTLLM-only report.
- The stored commit message was checked with `git log --format=%B -n 1`,
  `git show --pretty=fuller --no-patch HEAD`, and an over-72-character line
  scan. The message was amended until it had no raw `\n`, one sign-off, and
  wrapped body lines.

### What Went Wrong

- Phase 0 was too narrow for the original research intent. It validated that
  the generated ASP-DAC-backed report honestly supports only
  `B illumination_only`, but it treated that as close to final sign-off.
- The pass accepted missing `torch` as enough to block real
  Qwen3-Embedding-0.6B extraction. That is not acceptable: dependency setup
  should have been attempted.
- DeepGate3 was reduced to a missing-import/setup card. There was no actual
  AIG export plus embedding attempt, and the graph-state policy remained a
  future note instead of an attempted diagnostic.
- ST-NOD and synthesis-response descriptors were treated mainly as prior
  Auto-BD control evidence. The restarted plan must reconstruct them
  post-hoc where stage dumps, sidecars, or fitting artifacts allow.
- Parent-child and descendant-yield analysis was scoped out after the selected
  broad RTLLM root lacked lineage. The correct response is to search for
  lineage-rich corpora and run the analysis wherever the data exists.
- No bounded duplicate-suppression, quality-gated novelty, or
  archive-parent-fraction experiment was run, even though `original_notes/`
  explicitly proposed these as the way to distinguish "diversity is useless"
  from "diversity pressure was coupled badly."

### Original Notes Reinstated

- Read `original_notes/notes_1.md`: reinstated the layered diversity
  definition `D_code`, `D_struct`, `D_synth`, `D_ppa`, and `D_lineage`; the
  post-hoc audit tasks; duplicate suppression; quality-gated novelty lane;
  and the requirement to treat encoders as diagnostics before in-loop BDs.
- Read `original_notes/notes_2.md`: reinstated per-encoder reports, the
  centralized encoder leaderboard, method-card requirements, stage gates for
  accepting embeddings, the first-pass descriptor list
  (manual BD, Yosys-stat, motif histogram, ST-NOD, Qwen3, DeepGate3, random),
  and the preferred ST-NOD/VQ direction only if the pre-study succeeds.
- Read `original_notes/notes_3.md`: reinstated the negative Auto-BD
  interpretation, ST-NOD as the best hardware-native but robustness-losing
  signal, the quality-gated ST-NOD/Auto-BD work package, novelty-parent
  sweep `0.00/0.10/0.25/0.50`, and explicit no-proceed rules for AURORA/VQ.
- Read `original_notes/notes_4.md`: reinstated encoder diagnostics, DeepSeq /
  NetTAG / CircuitFusion as later diagnostics, quality floors, and robustness
  gates that reject ST-NOD-style valid-PPA loss.
- Read `original_notes/goal_v1_review.md`: reinstated stricter claim levels,
  utility-plus-meaning gate logic, historical-corpus confound policy,
  descriptor-fitting leakage controls, oracle vs online replay separation,
  random-label controls for multi-cluster fronts, D5 real-vs-random controls,
  and validity-normalized diversity.

### Restarted Goal And Dependency Rule

- Created a new active goal to restart the research rather than leave the
  old goal complete.
- Updated `goal_template.md`, `rtl_diversity_check_plan.md`, and
  `rtl_diversity_check_implementation_todo.md` so Phase 0 is explicitly
  preserved as preliminary evidence only.
- Missing dependencies are no longer accepted as blockers without escalation.
  For Qwen, DeepGate3, DeepSeq, NetTAG, CircuitFusion, or AURORA-style probes,
  the next run must try `uv add`, the nearest repo-local optional dependency
  path, or an isolated ignored environment under `exp/` before declaring the
  diagnostic blocked.
- The restarted completion surface now requires real Qwen or logged setup
  failure, DeepGate3 graph export plus embedding or logged setup failure,
  ST-NOD/synthesis-response reconstruction where possible, lineage analysis
  on any corpus that exposes it, and at least one duplicate-suppression or
  quality-gated novelty replay/live experiment before closing the research as
  illumination-only.

## Restart Execution - 2026-06-21 UTC

### Active Goal Reset

- Confirmed the active `/goal` text matches `goal_template.md` in spirit and
  includes the restarted work-package ladder, dependency-escalation rule,
  live-policy guard, and completion gates.
- The goal remains active. Phase 0 artifacts and commits are treated as
  evidence only, not full research sign-off.

### WP1 Qwen3 Dependency Escalation

- Worktree before this probe: only unrelated
  `.devcontainer/devcontainer-lock.json` was untracked.
- Created an isolated ignored encoder environment:
  `uv venv --python 3.11 exp/diversity_check/encoder_envs/qwen3_probe`.
- Installed encoder dependencies into that environment:
  `uv pip install --python exp/diversity_check/encoder_envs/qwen3_probe/bin/python
  'torch' 'transformers>=4.51.0' 'accelerate' 'sentence-transformers'
  'safetensors'`.
- Initial import succeeded, but default `torch==2.12.1+cu130` could not use
  the host NVIDIA 550.90.07 driver and reported `cuda_available False`.
- Escalated instead of accepting the blocker:
  `uv pip install --python exp/diversity_check/encoder_envs/qwen3_probe/bin/python
  --force-reinstall --index-url https://download.pytorch.org/whl/cu124
  'torch==2.6.0'`.
- Re-check result: `torch 2.6.0+cu124`, `cuda_available True`,
  device `NVIDIA RTX A6000`, `transformers 5.12.1`, and
  `sentence_transformers 5.6.0`.

### WP1 Qwen3 Bounded Embedding Probe

- Ran a bounded real `Qwen/Qwen3-Embedding-0.6B` extraction over 15 valid-PPA
  RTL candidates sampled as the first three usable rows from each available
  `(corpus, benchmark)` stratum in
  `exp/diversity_check/full_20260620/candidate_audit.csv`.
- Strata covered:
  `rtllm_gen20/RTLLM`, `auto_bd_standard_results/RTLLM`,
  `auto_bd_standard_results/VerilogEval-Spec-to-RTL`,
  `aspdac2026_release/RTLLM`, and
  `aspdac2026_release/VerilogEval-Spec-to-RTL`.
- Embedded raw, comment-stripped, and identifier-normalized RTL variants.
  Yosys-normalized RTL remains open.
- Artifact directory:
  `exp/diversity_check/qwen3_probe_20260621_032811_UTC/`.
- Outputs:
  `qwen3_probe_candidates.csv`, `qwen3_probe_variant_stability.csv`,
  `qwen3_probe_raw_nearest.csv`, `qwen3_probe_embeddings.npy`, and
  `qwen3_probe_summary.json`.
- Summary: 45 texts, embedding shape `[45, 1024]`, model load 24.673 s,
  encode 0.816 s, `variant_stability_mean=0.7481`,
  `variant_stability_min=0.512646`, raw pairwise cosine min/mean/max
  `0.3860 / 0.5835 / 0.9862`.
- Raw nearest-neighbor check: 9 of 15 nearest neighbors had the same canonical
  netlist hash and 6 of 15 had the same normalized RTL hash.
- Artifact hashes:
  - `qwen3_probe_embeddings.npy`:
    `4ce48422ea08957fee7ea42afd9768b3486d60dc42c1d92d3d1c6db0b9d1d2a2`
  - `qwen3_probe_summary.json`:
    `b4784a6c6b6017b7ed0689dd33c2cdac5156920f1977ede1bd7498069bf815dd`
- Interpretation: Qwen3 extraction is no longer dependency-blocked. The small
  smoke suggests useful duplicate/netlist proximity signal, but identifier
  normalization can sharply change embeddings, so leakage/stability controls
  and a larger common audit are required before any predictive or in-loop
  claim.
