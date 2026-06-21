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

### WP1 Qwen3 Yosys-Normalized Probe

- Reused the same 15-candidate bounded slice and converted each RTL file with
  Yosys `read_verilog -sv`, `hierarchy -auto-top`, `proc`, `opt`, and
  `write_verilog -noattr`.
- Yosys version:
  `Yosys 0.54+29 (git sha1 7b0c1fe49, g++ 11.4.0-1ubuntu1~22.04.3 -fPIC -O3)`.
- Conversion result: 15 of 15 candidates produced normalized Verilog.
- Artifact directory:
  `exp/diversity_check/qwen3_yosys_probe_20260621_033323_UTC/`.
- Outputs:
  `qwen3_yosys_stability.csv`, `qwen3_yosys_embeddings.npy`,
  `qwen3_yosys_summary.json`, and per-candidate Yosys scripts/Verilog under
  `yosys_normalized/`.
- Summary: 15 Yosys-normalized texts, embedding shape `[15, 1024]`,
  Yosys conversion 0.275 s, model load 6.919 s, encode 0.662 s.
- Raw-to-Yosys cosine min/mean/max: `0.7913 / 0.8624 / 0.9307`.
- Artifact hashes:
  - `qwen3_yosys_embeddings.npy`:
    `a95923dc85037d252d55f5cdbc43885769df2e5fe1d4caec28c6162ae74ae9c7`
  - `qwen3_yosys_summary.json`:
    `0d0fafd95bf74f7c46e7a7f9b8c543563af7d5a6415e6cc5a1e825e3f1eb6a5f`
  - `qwen3_yosys_stability.csv`:
    `f50e218b9c11437d766480320a3b3f89f6bb896558f5cb478f8def80f1f52e89`
- Interpretation: Qwen3 is moderately stable to Yosys normalization on this
  small slice and less stable to identifier erasure. This supports treating
  Qwen as a diagnostic encoder worth a larger common-audit run, but it still
  does not establish predictive utility or justify in-loop use.

### WP1 DeepGate3 Setup, AIG Export, And Embedding Smoke

- Cloned official DeepGate3 source into ignored path
  `exp/diversity_check/encoder_sources/DeepGate3` at commit
  `908516a4f5ca02f4530a452743d9a0dc15b13f08`.
- Cloned `python-deepgate` into ignored path
  `exp/diversity_check/encoder_sources/python-deepgate` at commit
  `173db7529cefc97f7b9b2b3fa97ec1bd5773754d`.
- Created isolated environment:
  `uv venv --python 3.8 exp/diversity_check/encoder_envs/deepgate3_probe`.
- Installed `torch==2.2.1+cu121`, PyG extension wheels, `deepgate==2.0.1`
  from source, and missing runtime imports (`progress`, `matplotlib`,
  `einops`, `seaborn`, `torchvision`) in the isolated environment.
- `deepgate==2.0.1` was not resolvable from PyPI in this environment, so the
  source install path from the DeepGate3 README was required.
- Attempted `mamba-ssm==1.2.0.post1`; build isolation failed from undeclared
  `torch`, no-build-isolation then failed until Python-3.8-compatible
  `setuptools`, `wheel`, and `ninja` were installed, and the final build
  failed because `nvcc` is absent. The plain/checkpoint-tokenizer probes stub
  the unused `mamba_ssm.Mamba` import and record this caveat.
- Import check passed with the Mamba stub:
  `torch 2.2.1+cu121`, CUDA visible on `NVIDIA RTX A6000`,
  `torch_geometric 2.5.2`, and `deepgate 2.0.1`.
- A first AIG export attempt failed because `write_aiger -map` handled quoted
  paths poorly. The corrected export removed map files and quotes.
- Corrected AIG artifact directory:
  `exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC/`.
- Graph-state policy for this bounded probe: combinational AIG only;
  latch-bearing AIGER rejected; no cone splitting yet.
- Export result on the same 15-candidate Qwen slice: 9 AIGER exports, 6
  latch-free DeepGate-compatible parses, 3 latch-bearing AIGER rejections, and
  6 sequential/DFFE export failures.
- Parsed nontrivial graphs were three Auto-BD RTLLM adder variants with
  178 nodes and 241 edges each. The three ASP-DAC `Prob001_zero` graphs parsed
  as zero-node constant-output AIGs and were skipped for embeddings.
- Checkpoint inspection: `trained/dg2_100p.pth` contains DeepGate3 checkpoint
  keys, while `trained/model_last.pth` and `model_last_workload.pth` contain
  DeepGate2 tokenizer keys. The shipped DeepGate3 checkpoint has hop/path
  transformer weights but no `transformer.*` weights for the `plain`
  architecture.
- A `plain` transformer smoke
  `exp/diversity_check/deepgate3_embedding_probe_20260621_034803_UTC/`
  ran, but it mixes loaded tokenizer weights with unpopulated plain-transformer
  layers and is diagnostic-only.
- Checkpoint-compatible tokenizer probe:
  `exp/diversity_check/deepgate3_tokenizer_probe_20260621_034921_UTC/`.
- Tokenizer probe result: 3 successful 256-dim embeddings, 3 zero-node skips,
  model load 0.248 s, encode 0.381 s, pairwise cosine min/mean/max
  `0.999968 / 0.999971 / 0.999976`.
- Interpretation: DeepGate3 setup and AIG export are no longer unattempted.
  The current bounded evidence is negative/inconclusive: sequential RTL needs
  a better FF/cone policy, and the checkpoint-compatible embeddings collapse
  on three same-problem adder variants.
- Artifact hashes:
  - `deepgate3_aig_export.csv`:
    `fe042e5ff9d172a4d436f91d0db07c8771c6feab1f3bd27e8004877ab6b5bbb7`
  - `deepgate3_aig_summary.json`:
    `22735689550c9752ecfa382752cc0a3213c7d2becf4025707cb6a98e79a861d6`
  - `deepgate3_graphs_latch_free.npz`:
    `47c657e423c9500fdf74d0a3a3d3eb897d1be82172b700e49133b6c8d9986fef`
  - `deepgate3_tokenizer_embeddings.npy`:
    `61279be160dfbffc8c234775b29de22e57119c2a3672a8eea388df7a0c83e00b`
  - `deepgate3_tokenizer_summary.json`:
    `64b74d6f2e50c0f0a6816910d281173764e9db18f7f733b5128dba232d1d57e8`
  - `deepgate3_tokenizer_rows.csv`:
    `fca404c9ed17615571b68f3de1932045575d9d6e40eb3966e5a888f6cba0b5d2`

### WP1 Encoder Method Cards

- Added `rtl_diversity_check_encoder_method_cards.md`.
- Current card verdicts:
  - Qwen3: diagnostic-only proceed to larger common audit with leakage
    controls; do not promote in-loop.
  - DeepGate3: diagnostic-only no-proceed in current form because the bounded
    checkpoint-compatible embedding smoke collapsed and sequential RTL needs a
    better FF/cone policy.

### Goal Template Fidelity Check

- Re-read the canonical TCAD journal goal template at
  `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/goal_template.md`.
- The active `/goal` object is the RTL-diversity restart objective, not the
  TCAD revamp template verbatim. It intentionally adapts the same strict
  pattern to this branch: active contract, checklist, audit log, hard evidence
  requirements, dependency escalation, live-run policy, completion gates, and
  signed atomic commits.
- The current goal remains active. It must not be closed just because WP1
  produced bounded diagnostic evidence; WP0-WP3 and the restarted completion
  gates are still open.

### WP0 ST-NOD, SR, And Lineage Inventory

- Rechecked `exp/diversity_check/full_20260620/candidate_audit.csv`.
  It has 203,944 rows and only one lineage-like column, `parent_id`.
  Non-empty `parent_id` count is zero for every current audit stratum:
  `aspdac2026_release/RTLLM`, `aspdac2026_release/VerilogEval-Spec-to-RTL`,
  `auto_bd_standard_results/RTLLM`,
  `auto_bd_standard_results/VerilogEval-Spec-to-RTL`, and
  `rtllm_gen20/RTLLM`.
- The audit already includes ST-NOD and synthesis-response descriptor-family
  rows, but only valid-PPA rows retain non-empty descriptor vectors there:
  `synthesis_trajectory_nod` has 1,896 five-dimensional vectors and 2,784
  empty vectors; `sr_random_relu_pca_qd` has 1,906 three-dimensional vectors
  and 2,774 empty vectors.
- Inspected the original Auto-BD seed-3 standard-results roots under
  `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/`.
  For both `synthesis_trajectory_nod` and `sr_random_relu_pca_qd`, seeds
  1001, 1002, and 1003 each expose
  `candidates.parquet`, `descriptor_vectors.parquet`,
  `per_generation_metrics.parquet`, `archive_snapshots.parquet`, and
  `elites.parquet`.
- Source `candidates.parquet` coverage is stronger than the Phase 0 audit
  projection for generated-candidate reconstruction: each method has 4,680
  rows total, 13 problems per seed, and generations 0-5. The descriptor and
  common-audit columns exist for every generated row, but invalid rows store
  `[]`; actual non-empty vectors are still limited to valid-PPA rows.
- Valid-PPA coverage in the source candidates is 1,896 rows for ST-NOD and
  1,906 rows for SR random-ReLU PCA. This matches the actual non-empty
  descriptor counts, confirming that the available ST-NOD/SR descriptor
  surface is valid-PPA-scoped while the generated-candidate row surface is
  broader.
- Source `candidates.parquet` preserves `operator_name` with
  `initial`, `M-*`, and `C-*` operators, but `parent_id` is empty for all
  checked ST-NOD and SR rows. This supports operator/generation/origin-pool
  analysis, but not true parent-child jump attribution from these parquets.
- Sampled per-candidate `qd_archive_event.json` files in the seed-3 SR root.
  The events preserve `candidate_id`, `generation`, `generated_mode`,
  `origin_pool`, archive insertion fields, descriptor values, objectives, PPA,
  structural metrics, and quality score. They do not preserve parent IDs:
  `parent_count` and `requested_parent_count` were `None`, and no other
  parent-ID keys were present.
- QD-event counts in the inspected seed-3 roots: ST-NOD has 1,896 events
  with `generated_mode` 1,601 whole / 295 diff and origin pools 1,113
  success / 534 fail / 249 initial; SR random-ReLU PCA has 1,906 events with
  `generated_mode` 1,576 whole / 330 diff and origin pools 1,302 success /
  344 fail / 260 initial.
- `per_generation_metrics.parquet` gives 234 rows per method across 13
  problems, three seeds, and generations 0-5. This is enough to compute
  25%, 50%, 75%, and 100% budget curves for ST-NOD and SR, and to compare
  those curves to descriptor occupancy, validity funnel, archive insertion,
  duplicate suppression, and common-audit retention policies.
- Current interpretation: WP0 is not blocked. True parent-child lineage
  remains missing in the checked Auto-BD roots, and invalid-candidate
  ST-NOD/SR descriptor values are not recoverable from these standard-results
  files. However, generated-candidate row reconstruction, valid-PPA-scoped
  descriptor analysis, operator-yield analysis, origin-pool analysis,
  per-budget curves, and replay-style duplicate suppression are feasible from
  the source artifacts. The next WP0 implementation step should emit a
  reconstructed row-level artifact or replay table before changing any final
  claim level.

### WP0 ST-NOD/SR Reconstruction Artifact

- Added `scripts/reconstruct_rtl_diversity_wp0.py` with focused test
  `tests/scripts/test_reconstruct_rtl_diversity_wp0.py`.
- Ran:
  `uv run python scripts/reconstruct_rtl_diversity_wp0.py --output-dir exp/diversity_check/wp0_stnod_sr_reconstruction_20260621_040536_UTC`.
- Artifact directory:
  `exp/diversity_check/wp0_stnod_sr_reconstruction_20260621_040536_UTC/`.
- Outputs:
  `wp0_descriptor_rows.parquet`, `wp0_descriptor_rows.csv`,
  `wp0_budget_curves.csv`, `wp0_operator_yield.csv`,
  `wp0_qd_events.csv`, and `wp0_reconstruction_summary.json`.
- Summary: 9,360 generated-candidate rows, 3,802 QD event rows, 312
  budget-curve rows, and 54 operator-yield rows.
- ST-NOD rows: 4,680 generated, 1,896 valid-PPA, 1,896 non-empty descriptor
  rows, zero non-empty parent IDs, and 718 unique canonical netlists.
- SR random-ReLU PCA rows: 4,680 generated, 1,906 valid-PPA, 1,906 non-empty
  descriptor rows, zero non-empty parent IDs, and 771 unique canonical
  netlists.
- Budget-curve aggregate at 100%:
  - ST-NOD: 4,680 candidates, 1,896 valid-PPA, 852 unique canonical netlists,
    1,044 duplicate valid canonical-netlist hits, and Pareto size 558.
  - SR random-ReLU PCA: 4,680 candidates, 1,906 valid-PPA, 900 unique
    canonical netlists, 1,006 duplicate valid canonical-netlist hits, and
    Pareto size 496.
- Budget-curve aggregate at 25%:
  - ST-NOD: 1,170 candidates, 423 valid-PPA, 226 unique canonical netlists,
    197 duplicate valid canonical-netlist hits, and Pareto size 196.
  - SR random-ReLU PCA: 1,170 candidates, 433 valid-PPA, 227 unique canonical
    netlists, 206 duplicate valid canonical-netlist hits, and Pareto size 219.
- Highest valid-PPA-rate operators in this artifact are `C-D` and `C-F`.
  Example top rows: ST-NOD seed 1001 `C-D` valid rate 0.755 and SR seed 1003
  `C-D` valid rate 0.731. This is an operator-yield signal only; it is not
  descendant-yield evidence because parent IDs remain absent.
- Artifact hashes:
  - `wp0_descriptor_rows.parquet`:
    `0a545bc34622b6f5c4a54dffeb33427028bcc4b0cd14903d6a27916da47af28a`
  - `wp0_descriptor_rows.csv`:
    `0767e2d95a0af1154c791d8eecbf3d4b3985b41c4231cac2f7b07477d6ec1f14`
  - `wp0_budget_curves.csv`:
    `d155c084676cf0666fc37d2aa3129aa750da3df1c8fb44b5efbbef534bb0c35a`
  - `wp0_operator_yield.csv`:
    `99ab85adec2f0e5ccb7cca7b6d952e7377f5342443c4878136fd9f15b135876c`
  - `wp0_qd_events.csv`:
    `35527bc7a3566c19375a6c4fb4231993df5d21a17291b87f53da9f94acb1576e`
- Validation:
  - `uv run pytest -q tests/scripts/test_reconstruct_rtl_diversity_wp0.py`:
    1 passed.
  - `uv run ruff check scripts/reconstruct_rtl_diversity_wp0.py
    tests/scripts/test_reconstruct_rtl_diversity_wp0.py`: clean.
  - `uv run pyright scripts/reconstruct_rtl_diversity_wp0.py`: 0 errors,
    0 warnings.

### WP0 Duplicate-Suppression Replay Artifact

- Extended `scripts/reconstruct_rtl_diversity_wp0.py` to emit
  `wp0_duplicate_suppression.csv`.
- Ran:
  `uv run python scripts/reconstruct_rtl_diversity_wp0.py --output-dir exp/diversity_check/wp0_stnod_sr_replay_20260621_041018_UTC`.
- Artifact directory:
  `exp/diversity_check/wp0_stnod_sr_replay_20260621_041018_UTC/`.
- The replay file has 624 rows:
  two methods, three seeds, 13 problems, four budget checkpoints, and two
  replay keys (`canonical_netlist` and `exact_motif_signature`).
- Full-budget canonical-netlist replay:
  - ST-NOD: 1,896 valid-PPA rows, 1,044 suppressed duplicate hits, 852
    retained unique canonical netlists, online retained Pareto size 176, and
    raw baseline Pareto size 558.
  - SR random-ReLU PCA: 1,906 valid-PPA rows, 1,006 suppressed duplicate hits,
    900 retained unique canonical netlists, online retained Pareto size 174,
    and raw baseline Pareto size 496.
- Full-budget exact-motif replay:
  - ST-NOD: 1,292 suppressed duplicate hits, 604 retained exact motif
    signatures, online retained Pareto size 112, and raw baseline Pareto size
    558.
  - SR random-ReLU PCA: 1,253 suppressed duplicate hits, 653 retained exact
    motif signatures, online retained Pareto size 116, and raw baseline
    Pareto size 496.
- Interpretation: duplicate/equivalent candidates are numerous in both
  descriptor arms, and raw Pareto counts can overstate unique structural
  contribution because duplicate points are counted separately. This replay is
  not a quality-gated novelty result yet; it is a prerequisite diagnostic for
  a valid-only novelty lane and a reminder to report unique-front counts next
  to raw Pareto counts.
- Artifact hash:
  - `wp0_duplicate_suppression.csv`:
    `3a29b887dbfcbfdb682c8dfc81e39147ad3946120945c6cf4792d348ed4d8834`
- Validation:
  - `uv run pytest -q tests/scripts/test_reconstruct_rtl_diversity_wp0.py`:
    1 passed.
  - `uv run ruff check scripts/reconstruct_rtl_diversity_wp0.py
    tests/scripts/test_reconstruct_rtl_diversity_wp0.py`: clean.
  - `uv run pyright scripts/reconstruct_rtl_diversity_wp0.py`: 0 errors,
    0 warnings.

### WP2 Quality-Gated Novelty Replay Artifact

- Extended `scripts/reconstruct_rtl_diversity_wp0.py` to emit
  `wp0_quality_gated_novelty.csv`.
- Replay policy: within each method/seed/problem/budget prefix, keep only
  valid-PPA candidates above the prefix median valid fitness and use
  `common_audit_descriptor_vector` distance for the novelty lane.
- Swept `novelty_parent_fraction` values `0.00`, `0.10`, `0.25`, and `0.50`.
  This is a bounded replay analogue of the requested novelty-parent sweep,
  not a live search run.
- Ran:
  `uv run python scripts/reconstruct_rtl_diversity_wp0.py --output-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC`.
- Artifact directory:
  `exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC/`.
- The novelty replay file has 1,248 rows:
  two methods, three seeds, 13 problems, four budget checkpoints, and four
  novelty-parent fractions.
- Full-budget SR random-ReLU PCA:
  - `0.00`: 492 selected, 228 unique canonical netlists, 172 motif
    signatures, 70 common-audit cells, Pareto size 304, best fitness 0.683497.
  - `0.50`: 492 selected, 248 unique canonical netlists, 201 motif
    signatures, 82 common-audit cells, Pareto size 294, best fitness 0.683497.
- Full-budget ST-NOD:
  - `0.00`: 490 selected, 211 unique canonical netlists, 157 motif
    signatures, 71 common-audit cells, Pareto size 336, best fitness 0.683497.
  - `0.50`: 490 selected, 224 unique canonical netlists, 183 motif
    signatures, 83 common-audit cells, Pareto size 327, best fitness 0.683497.
- Interpretation: the median-fitness quality gate prevents best-fitness loss
  on this replay, and increasing the novelty fraction modestly increases
  unique canonical-netlist, motif-signature, and common-audit-cell counts.
  The selected Pareto count drops slightly against pure quality selection, so
  this supports "quality-gated novelty is a plausible diagnostic/replay
  follow-up" rather than an active-method claim.
- Artifact hash:
  - `wp0_quality_gated_novelty.csv`:
    `7182c1f4c6f4a4a9700417ccc799a6369d50fcac8949e609414ab9dfd9eeea2c`
- Validation:
  - `uv run pytest -q tests/scripts/test_reconstruct_rtl_diversity_wp0.py`:
    1 passed.
  - `uv run ruff check scripts/reconstruct_rtl_diversity_wp0.py
    tests/scripts/test_reconstruct_rtl_diversity_wp0.py`: clean.
  - `uv run pyright scripts/reconstruct_rtl_diversity_wp0.py`: 0 errors,
    0 warnings.

### Restarted Report Regeneration With WP0/WP2 And WP1 Artifacts

- Updated `scripts/report_rtl_diversity_check.py` so the restarted report
  ingests `wp0_duplicate_suppression.csv` and
  `wp0_quality_gated_novelty.csv` from the WP0/WP2 replay artifact instead of
  leaving replay evidence out of the final report package.
- The report now loads the restarted Qwen3 and DeepGate3 probe summaries when
  present. This fixes the stale Phase 0 cards that still said Qwen was
  dependency-blocked and DeepGate3 was only deferred.
- Added a dedicated preliminary negative-result and plan-pivot section. The
  regenerated report keeps the verdict at `B illumination_only`, recommends
  diagnostic-only / no-proceed for method promotion, and leaves larger Qwen,
  stronger graph encoders, bounded live sampling, and AURORA/VQ training
  conditional on targeting a concrete D1/D3/D4/D5 utility gate.
- Ran:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_045103_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Artifact directory:
  `exp/diversity_check/restarted_report_20260621_045103_UTC/`.
- Report counts: 203,944 total candidates, 170,131 ASP-DAC release
  candidates, 180,544 evolution-analysis candidates, and 23,400 Auto-BD
  control candidates.
- WP0/WP2 report evidence: full-budget duplicate suppression records
  1,006-1,292 duplicate hits depending on method/key; quality-gated novelty
  preserves best fitness at 0.683497 while increasing unique canonical
  netlists from 228 to 248 for SR and from 211 to 224 for ST-NOD between
  novelty fractions 0.00 and 0.50.
- WP1 report evidence: Qwen3 card now reports 45 embedded texts with
  `[45, 1024]` shape, 15/15 Yosys-normalized conversions, variant stability
  mean 0.748, and raw-to-Yosys cosine mean 0.862. DeepGate3 card now reports
  9 AIG exports, 6 latch-free parses, 3 embeddings, and pairwise cosine mean
  0.999971, so the current DeepGate3 path remains no-proceed due collapse and
  combinational-only graph policy.
- Artifact hashes:
  - `diversity_necessity_report.md`:
    `ada5868be4100cc2596ac92fcacb5389a99122e3625c813c89e209d88b2d5519`
  - `diversity_necessity_report.json`:
    `b6ae7200d960480cf7fe29a2b12f1a85df78280327d55deface8adcba96e599f`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `encoder_leaderboard.csv`:
    `3b09ffa9927b3f877f4ae76b54ff44a16d659e023071e068720a27ea5b4896b4`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `92551a1f6ebe2432089d1a3389333b2fbc46c18da857d245825bbf43963a23a5`
- Validation:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_reconstruct_rtl_diversity_wp0.py`: 6 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    tests/scripts/test_report_rtl_diversity_check.py
    scripts/reconstruct_rtl_diversity_wp0.py
    tests/scripts/test_reconstruct_rtl_diversity_wp0.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py
    scripts/reconstruct_rtl_diversity_wp0.py`: 0 errors, 0 warnings.

### Restarted Report Residual Cleanup

- The first independent restarted adversarial validation returned PASS for the
  `B illumination_only` claim but noted two paper-facing cleanup items:
  `case_studies.csv` used the negative-control document path for two selected
  ASP-DAC cases even though `implementation_gallery.md` resolved real
  candidate snippets, and the WP0/WP2 replay section did not state the novelty
  distance metric explicitly.
- Updated `representative_cases` to use the same broad evolution-analysis
  candidate table as the gallery. This makes the generated `case_studies.csv`
  and `implementation_gallery.md` agree on candidate paths and clusters.
- Added report text stating that the quality gate uses valid-PPA candidates at
  or above prefix median valid fitness, and that the novelty lane uses
  nearest-selected Euclidean distance over the artifact's existing four-axis
  `common_audit_descriptor_vector` without fitting a new scaler or using
  PPA-derived normalization.
- Ran:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_051025_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Artifact directory:
  `exp/diversity_check/restarted_report_20260621_051025_UTC/`.
- Spot checks:
  - `case_studies.csv` now points `best_supported` to
    `Prob050_square_wave_M-E_sample9.sv` with cluster `register_sequential`.
  - `case_studies.csv` now points `null_or_median` to
    `Prob130_circuit5_C-F_sample8.sv` with cluster `control_case`.
  - `diversity_necessity_report.md` includes the quality-gate and novelty
    metric bullets in the `Restart WP0/WP2 Replay Evidence` section.
- Artifact hashes:
  - `diversity_necessity_report.md`:
    `c8dd164d1779bcd178e82b1add8a941f664dd3353fc71026643d6cf4e9994e59`
  - `diversity_necessity_report.json`:
    `edde0925ab865c4205ee30413e691d56cef0608419c3da8c7cb777a64e495705`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `encoder_leaderboard.csv`:
    `3b09ffa9927b3f877f4ae76b54ff44a16d659e023071e068720a27ea5b4896b4`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `92551a1f6ebe2432089d1a3389333b2fbc46c18da857d245825bbf43963a23a5`
- Validation:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py`:
    6 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    tests/scripts/test_report_rtl_diversity_check.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
    0 warnings.

### Restarted Adversarial Validation PASS

- Refreshed the independent adversarial validation after the residual cleanup.
- Validator output:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md`.
- Verdict: PASS for current HEAD
  `b4383b5cc5a9028096bcfc85e6f5b43885e0a4c4` and artifact
  `exp/diversity_check/restarted_report_20260621_051025_UTC/`.
- Scope of PASS: only the `B illumination_only` / diagnostic-only claim. It
  is not final TCAD sign-off, predictive evidence, reconstructive evidence,
  active diversity evidence, or Auto-BD method promotion.
- Remaining non-blocking gaps before any stronger claim: incomplete lineage,
  bounded Qwen3 coverage, collapsed/limited DeepGate3 graph evidence,
  distance-based near-identical motif suppression, and report-script size.

### WP3 AURORA-Style Learned Encoder Diagnostic

- Added `scripts/run_rtl_diversity_wp3_learned_encoder.py` with focused test
  `tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py`.
- This is a bounded diagnostic probe, not finetuning and not an in-loop
  method. It trains a frozen linear reconstruction bottleneck over the
  existing four-axis `common_audit_descriptor_vector`, using a deterministic
  problem-level train/holdout split.
- Leakage policy: fitting inputs exclude area, power, timing, fitness,
  hypervolume contribution, validity labels, `problem_id`, and candidate IDs.
  PPA and fitness are used only after fitting for replay evaluation.
- Ran the 2D probe:
  `uv run python scripts/run_rtl_diversity_wp3_learned_encoder.py --artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --output-dir exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim2_fixed --latent-dim 2`.
- 2D artifact:
  `exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim2_fixed/`.
- 2D result: train candidates 2,120, holdout candidates 1,682, holdout
  reconstruction MSE 0.018272, latent std `[1.1895, 0.8730]`, verdict
  `diagnostic_only_no_proceed`.
- 2D holdout replay at novelty fraction 0.50: learned latent versus
  common-audit control has +0 unique canonical netlists, +0 motif signatures,
  -1 occupied common-audit cell, +1 Pareto point, same best fitness, and
  slightly lower mean fitness. Pareto gain fraction is 0.00358, below the 5%
  threshold.
- 2D artifact hashes:
  - `wp3_learned_encoder_summary.json`:
    `8e0e367d172d2e366707072ca2bedda6ec4ea648b647da8b284969ef54ec55de`
  - `wp3_learned_encoder_replay.csv`:
    `7a9898fbc37a8b2e65d524dcc909dd39bb9d4307047f1da3bebd22adacc09daa`
  - `wp3_learned_encoder_rows.parquet`:
    `4854cd5bf59400902c1528d3193eed1c69207efd40d793eebe1d44bf541397f0`
  - `wp3_learned_encoder_card.md`:
    `053b099ccb21207b54f353b2683f9d94b7e74ad2ac4ca7a869534377f8f4b91d`
- Ran the 3D probe:
  `uv run python scripts/run_rtl_diversity_wp3_learned_encoder.py --artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --output-dir exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim3_fixed --latent-dim 3`.
- 3D artifact:
  `exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim3_fixed/`.
- 3D result: holdout reconstruction MSE 0.009623, latent std
  `[1.1895, 0.8730, 1.5850]`, verdict `diagnostic_only_no_proceed`.
- 3D holdout replay at novelty fraction 0.50 exactly matches common-audit on
  unique canonical netlists, motif signatures, occupied cells, Pareto size,
  and best fitness, with slightly lower mean fitness.
- 3D artifact hashes:
  - `wp3_learned_encoder_summary.json`:
    `bcf43ec1c92212a81f1a131e2b95b86a3175f0d22614094274f6444dca20f90c`
  - `wp3_learned_encoder_replay.csv`:
    `1063bee779857f3844ea0cf7742c5547a9f66ff257a503a210539e34b667c6fe`
  - `wp3_learned_encoder_rows.parquet`:
    `f0305339afa690101e077b823d5d28e0b53aa37b5745f9bb10cce2555d75ee12`
  - `wp3_learned_encoder_card.md`:
    `2cd0995f51df076c3c07143da262998718d9dfd8e405070f7f56ccbac07d9dc0`
- Interpretation: this bounded AURORA-style linear bottleneck does not create
  a meaningful utility signal beyond the common-audit control. It should not
  be finetuned or promoted without a richer non-PPA input space, a larger
  train/holdout corpus, or a concrete D1/D3/D4/D5 target.
- Validation:
  - `uv run pytest -q tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py`:
    1 passed.
  - `uv run ruff check scripts/run_rtl_diversity_wp3_learned_encoder.py
    tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py`: clean.
  - `uv run pyright scripts/run_rtl_diversity_wp3_learned_encoder.py`:
    0 errors, 0 warnings.

### WP3-Integrated Central Report Regeneration

- Updated `scripts/report_rtl_diversity_check.py` so the central Diversity
  Necessity Report loads the bounded WP3 learned-encoder summaries and renders
  them in both the dedicated WP3 diagnostics section and the encoder
  leaderboard.
- Added `tests/scripts/test_report_rtl_diversity_check.py` coverage for the
  WP3 summary loader.
- Regenerated the report:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_054009_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Report artifact:
  `exp/diversity_check/restarted_report_20260621_054009_UTC/`.
- Central result remains `B illumination_only`. The report now records:
  - Qwen3 as real artifact-loaded diagnostic evidence, not promoted.
  - DeepGate3 as diagnostic-only no-proceed because the bounded tokenizer
    embeddings collapsed and the graph-state policy remains limited.
  - AURORA-style 2D and 3D linear probes as
    `diagnostic_only_no_proceed`.
- WP3-integrated artifact hashes:
  - `diversity_necessity_report.md`:
    `375f2c0438e19e50daf5fe650694be0ad5dd79892814f83f9ae57351790000a2`
  - `diversity_necessity_report.json`:
    `68c5e4075879edd13b19780f032575430134089d5c8331cf1546eeba521992d9`
  - `encoder_leaderboard.csv`:
    `38a138fb098198f12b8334837a7186aa6ea5e38ac9027369995a433b2ad71d32`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `92551a1f6ebe2432089d1a3389333b2fbc46c18da857d245825bbf43963a23a5`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
- Validation before commit:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_analyze_rtl_diversity_near_motif_suppression.py`:
    12 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    scripts/analyze_rtl_diversity_near_motif_suppression.py
    tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_analyze_rtl_diversity_near_motif_suppression.py`:
    clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py
    scripts/analyze_rtl_diversity_near_motif_suppression.py`: 0 errors,
    0 warnings.
  - `git diff --check`: clean.
- Validation before commit:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py`:
    7 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    tests/scripts/test_report_rtl_diversity_check.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py`: 0 errors,
    0 warnings.
- The previous independent adversarial PASS remains scoped to HEAD
  `b4383b5cc5` and report
  `exp/diversity_check/restarted_report_20260621_051025_UTC/`. The
  WP3-integrated report needs refreshed adversarial validation after this
  report integration is committed.

### WP0 Lineage Source Audit And Descendant Yield

- Added `scripts/audit_rtl_diversity_lineage_sources.py` with focused test
  `tests/scripts/test_audit_rtl_diversity_lineage_sources.py`.
- Ran the source audit:
  `uv run python scripts/audit_rtl_diversity_lineage_sources.py --output-dir exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC`.
- Audit artifact:
  `exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC/`.
- Audit result: 3/5 roots existed, 9,564 files were readable, 9,548 files
  exposed generation fields, 9,356 exposed operator fields, and 271 files had
  non-empty lineage fields with 3,358 parent/lineage edges. The lineage-capable
  files were in the Auto-BD archive CSVs; ASP-DAC and broad RTLLM generation
  logs had generation/operator summaries but no non-empty lineage fields.
- Missing roots logged explicitly:
  `/home/kmcho/1_RESEARCH/2026_Revolution_Journal_Ext/code_repo/REvolution`
  and
  `/home/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution`.
- Audit artifact hashes:
  - `lineage_source_summary.json`:
    `e5a9c73cca5285db85bbe29e4eb7d8d6c697b535704426fef2b0c7357953d199`
  - `lineage_source_files.csv`:
    `6e35872e7a5c548c5de10ea111ad04c3243bb8204ff47568a6919e742b3b4647`
  - `lineage_source_roots.csv`:
    `52c9b57389c7c28a5c3d9c56d08006652bfe19f11100b9650f3b4befa784bd84`
  - `lineage_source_audit.md`:
    `c81beace593ac35146588fa1ca1ea7a1a5df2198411fd4b2ebe7ece3d0af7ac6`
- Added `scripts/analyze_rtl_diversity_lineage_yield.py` with focused test
  `tests/scripts/test_analyze_rtl_diversity_lineage_yield.py`.
- Ran descendant-yield analysis:
  `uv run python scripts/analyze_rtl_diversity_lineage_yield.py --lineage-files-csv exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC/lineage_source_files.csv --output-dir exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC`.
- Yield artifact:
  `exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC/`.
- Yield result: 3,358 parent-child edges, 2,233 parent-found edges, 1,829
  new-cell edges, 779 positive child-quality deltas, and 2,063 parent-yield
  rows. Every method/table aggregate had negative mean quality delta, so the
  result does not support an L3 mechanistic or descendant-yield claim.
- Yield artifact hashes:
  - `lineage_yield_summary.json`:
    `c502241e102259b988b6bfa7dcbdcee3bb390d312750375b080329928e89b016`
  - `lineage_edges.csv`:
    `1bb780b2a8b841949dc054d295a5c8e6db214c38cab2debac020c13a671e61e4`
  - `lineage_parent_yield.csv`:
    `06dad87c166341461d63ec328a0cb62c5c0f1f9d2e7c8041c4df9a18312834a3`
  - `lineage_aggregate.csv`:
    `db5426bcf69df05fcf8be27a390ef92f5efb765a7e44dd0ef36b63970e7e9e2a`
  - `lineage_yield_report.md`:
    `25368c732ac21104975cf76a734fc4e5391185a220147a46e36f35b5e097988b`
- Updated `scripts/report_rtl_diversity_check.py` to load the lineage audit
  and yield summaries into the central report. The L3 claim now states that
  lineage was recovered but mechanistic utility remains unsupported because
  0/8 method/table groups had positive mean quality delta.
- Regenerated the central report:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_060721_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Report artifact:
  `exp/diversity_check/restarted_report_20260621_060721_UTC/`.
- Updated report hashes:
  - `diversity_necessity_report.md`:
    `a5f09173b1e3ff35578b6c8b95ead01831e7f122ae4837bb560182147bb4563e`
  - `diversity_necessity_report.json`:
    `567283390da1e2a4937d3c8697a931bab5d110c754ce66251e67c6fdfefbaa9d`
  - `encoder_leaderboard.csv`:
    `38a138fb098198f12b8334837a7186aa6ea5e38ac9027369995a433b2ad71d32`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `27e5ee31d38a9fd2a48d351bba9a9d9731be70da66ba3896cbf8371a92dd8826`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
- Interpretation: this corrects the previous "lineage absent" finding. The
  rigorous statement is now: lineage exists in Auto-BD archive tables, but the
  observed descendant-yield signal is not strong enough to promote diversity
  as mechanistically useful or to justify AURORA/finetuning in-loop.
- Validation before commit:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_audit_rtl_diversity_lineage_sources.py
    tests/scripts/test_analyze_rtl_diversity_lineage_yield.py`: 10 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    scripts/audit_rtl_diversity_lineage_sources.py
    scripts/analyze_rtl_diversity_lineage_yield.py
    tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_audit_rtl_diversity_lineage_sources.py
    tests/scripts/test_analyze_rtl_diversity_lineage_yield.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py
    scripts/audit_rtl_diversity_lineage_sources.py
    scripts/analyze_rtl_diversity_lineage_yield.py`: 0 errors, 0 warnings.
  - `git diff --check`: clean.

### WP0 Budget/Funnel Curves And Encoder Escalation Status

- Added `scripts/analyze_rtl_diversity_budget_funnels.py` with focused test
  `tests/scripts/test_analyze_rtl_diversity_budget_funnels.py`.
- Ran the budget/funnel analysis:
  `uv run python scripts/analyze_rtl_diversity_budget_funnels.py --candidate-audit exp/diversity_check/restarted_report_20260621_060721_UTC/candidate_audit.parquet --output-dir exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC`.
- Budget/funnel artifact:
  `exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC/`.
- Result: 203,944 candidates, 1,069 problem groups, 21,380 curve rows, and
  140 aggregate rows across budget checkpoints 0.25, 0.50, 0.75, and 1.00.
  Funnels are generated, functional, synthesis-valid, valid-PPA, and
  Pareto-front. Later funnel stages are cumulative, so synthesis-valid also
  requires functional validity, valid-PPA requires synthesis-valid, and
  Pareto-front requires valid-PPA.
- Full-budget valid-PPA aggregate highlights:
  - ASP-DAC release lexical/classic: 824 problem groups, 90,058 valid-PPA
    candidates, mean best fitness 0.2069, mean style clusters 2.2002, and
    mean Pareto members 50.5. Canonical netlist and motif counts are zero
    because this imported post-hoc release path lacks recovered netlist hashes.
  - RTLLM Gen20 lexical/classic: 50 problem groups, 2,335 valid-PPA
    candidates, mean best fitness 0.2120, mean style clusters 1.06, mean
    canonical netlists 8.1, and mean motif signatures 5.02.
  - Auto-BD valid-PPA mean best fitness remains highest for
    `landing_smooth_qd_manual_bd` at 0.2887; descriptor families still do not
    show a promoted diversity-utility gate in the common-audit read.
- Budget/funnel artifact hashes:
  - `budget_funnel_summary.json`:
    `34d8950bde7ed9efe72092ec7669555cf1b581d3deda4e612c09cd84195938e5`
  - `budget_funnel_curves.csv`:
    `b805b4d40577b74fbe26fc204904acaa09922044b730249c24eb592b16ffeeb9`
  - `budget_funnel_aggregate.csv`:
    `8b0db9dd6422cceca4b55722f06cabe87914159d5138a9b7e64a9ce89a5bb6fe`
  - `budget_funnel_report.md`:
    `a700050bc8b52614634bb603f9e2c28892759bae3e583818d7a9f35fccfa28af`
- Updated `scripts/report_rtl_diversity_check.py` to load the budget/funnel
  summary into the central Diversity Necessity Report and added loader
  coverage in `tests/scripts/test_report_rtl_diversity_check.py`.
- Regenerated the central report:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_062641_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Report artifact:
  `exp/diversity_check/restarted_report_20260621_062641_UTC/`.
- Updated report hashes:
  - `diversity_necessity_report.md`:
    `8f9196b53894a3084aeb2d21eed6dae673fb21c09ab217bbe921adf37a715556`
  - `diversity_necessity_report.json`:
    `b5a3122af3ee6249ea02b8674fec69a98af6a8068678544cdda3d7ed07f43c9b`
  - `encoder_leaderboard.csv`:
    `38a138fb098198f12b8334837a7186aa6ea5e38ac9027369995a433b2ad71d32`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `27e5ee31d38a9fd2a48d351bba9a9d9731be70da66ba3896cbf8371a92dd8826`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
- Interpretation: Qwen3 and DeepGate3 did not return promoted results.
  Qwen3 produced real `Qwen/Qwen3-Embedding-0.6B` embeddings but remains
  diagnostic-only; DeepGate3 reached the bounded AIG/tokenizer path but
  embeddings collapsed under the current graph representation. AURORA-style
  or finetuned-encoder work is therefore reasonable as a diagnostic
  escalation, but it should first declare a fitting corpus, leakage controls,
  utility target, and no-proceed threshold rather than becoming an in-loop
  method by default.
- Current verdict remains `B illumination_only`.
- Validation before commit:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_analyze_rtl_diversity_budget_funnels.py
    tests/scripts/test_audit_rtl_diversity_lineage_sources.py
    tests/scripts/test_analyze_rtl_diversity_lineage_yield.py`: 12 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    scripts/analyze_rtl_diversity_budget_funnels.py
    scripts/audit_rtl_diversity_lineage_sources.py
    scripts/analyze_rtl_diversity_lineage_yield.py
    tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_analyze_rtl_diversity_budget_funnels.py
    tests/scripts/test_audit_rtl_diversity_lineage_sources.py
    tests/scripts/test_analyze_rtl_diversity_lineage_yield.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py
    scripts/analyze_rtl_diversity_budget_funnels.py
    scripts/audit_rtl_diversity_lineage_sources.py
    scripts/analyze_rtl_diversity_lineage_yield.py`: 0 errors, 0 warnings.
  - `git diff --check`: clean.

### Encoder Escalation Plan After Qwen3/DeepGate3 Diagnostics

- Added `rtl_diversity_check_encoder_escalation_plan.md`.
- Linked it from `rtl_diversity_check_plan.md` and the WP1/WP3 todo items.
- Reason: Qwen3 produced real embeddings and is no longer dependency-blocked,
  but current evidence is diagnostic-only; DeepGate3 was attempted end to end
  through the bounded AIG/tokenizer path, but the embedding collapsed and the
  graph-state policy is still combinational-only.
- Decision: AURORA-style training or finetuning is allowed as the next
  diagnostic escalation, not as an in-loop method by default. The first
  concrete run should be a richer AURORA-style diagnostic over
  implementation-only D_code/D_struct/D_synth features with problem-held-out
  evaluation, common-audit replay controls, and fixed no-proceed thresholds.
- The plan records required gates, training/leakage rules, escalation order,
  and no-proceed thresholds before any new encoder training command is run.

### WP3 Rich Implementation-Feature Encoder Diagnostic

- Added `scripts/run_rtl_diversity_wp3_rich_encoder.py` with focused test
  `tests/scripts/test_run_rtl_diversity_wp3_rich_encoder.py`.
- The first full run was interrupted after 3:43 because pandas `iterrows()`
  in the farthest-candidate novelty loop made the full replay too slow.
  The selection rule was then vectorized with NumPy and rerun.
- Ran the richer diagnostic:
  `uv run python scripts/run_rtl_diversity_wp3_rich_encoder.py --candidate-audit exp/diversity_check/restarted_report_20260621_062641_UTC/candidate_audit.parquet --output-dir exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC --latent-dims 8 16`.
- Artifact:
  `exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC/`.
- Training protocol: fixed problem-held-out split over all 203,944 candidate
  audit rows. Inputs were 37 implementation-only features: RTL lexical
  counts, syntax/functionality/synthesis stages, descriptor vector slots,
  netlist motif ratios, style one-hots, and hash-availability flags.
- Forbidden fitting inputs were area, power, timing, fitness,
  hypervolume contribution, valid-PPA, Pareto membership, OpenROAD pass,
  archive cell id, problem id, candidate id, prompt hash, model, and model id.
- Result:
  - AE8 latent pairwise cosine mean 0.4589; holdout reconstruction MSE 2.371;
    held-out replay hypervolume gain fraction 0.0 and Pareto gain fraction
    -0.001087 versus the implementation-feature baseline.
  - AE16 latent pairwise cosine mean 0.3879; holdout reconstruction MSE 1.184;
    held-out replay hypervolume gain fraction -0.000071 and Pareto gain
    fraction -0.000362 versus the implementation-feature baseline.
  - Verdict: `diagnostic_only_no_proceed`.
- Artifact hashes:
  - `wp3_rich_encoder_summary.json`:
    `4fc3aef43b881716ebd24ac9c3a205ee3bf8416ef798599bc33424ea7a346605`
  - `wp3_rich_encoder_replay.csv`:
    `fd2dd16910be723d595cabbca1c2e732c5e6d1a26b25467381c28b42255de0dd`
  - `wp3_rich_encoder_rows.parquet`:
    `0cc30a8a00f0474dada0ab8147dfc082d3214d9b1d06c62a8c8056a8fee74d3c`
  - `wp3_rich_encoder_feature_manifest.csv`:
    `8853d7b2654387e9459f458b14ec2102db55f3ab69610019159bd05d217a3ec9`
  - `wp3_rich_encoder_card.md`:
    `4138f700b1d8d3f90bdd447fa79816d09e58ecc666565ceab3aadcdc5519b194`
- Updated `scripts/report_rtl_diversity_check.py` so the central report loads
  the richer WP3 summary and adds `rich_ae8` and `rich_ae16` rows to the WP3
  diagnostics and encoder leaderboard.
- Regenerated the central report:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_071339_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Report artifact:
  `exp/diversity_check/restarted_report_20260621_071339_UTC/`.
- Report result remains `B illumination_only`.
- Updated report hashes:
  - `diversity_necessity_report.md`:
    `5e41a1c25688368b37eec38539a392ce6809c4c5199477b36aaf9d5b70c2c302`
  - `diversity_necessity_report.json`:
    `0722b9d52a03664ed0f004c63dfc5bca7a779bd3febdfdd401f9950ed135bad1`
  - `encoder_leaderboard.csv`:
    `794ac49d1322d8190f5cb80b3c75f4d1968bf89147f48658c5025ad394a48c82`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `27e5ee31d38a9fd2a48d351bba9a9d9731be70da66ba3896cbf8371a92dd8826`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
- Interpretation: the richer AURORA-style diagnostic addressed the earlier
  criticism that the 2D/3D probes only compressed four common-audit axes. It
  still does not create a useful diversity signal under the held-out replay
  utility gate, so it should not be promoted or finetuned in-loop.
- Validation before commit:
  - `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_run_rtl_diversity_wp3_rich_encoder.py
    tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py`: 12 passed.
  - `uv run ruff check scripts/report_rtl_diversity_check.py
    scripts/run_rtl_diversity_wp3_rich_encoder.py
    scripts/run_rtl_diversity_wp3_learned_encoder.py
    tests/scripts/test_report_rtl_diversity_check.py
    tests/scripts/test_run_rtl_diversity_wp3_rich_encoder.py
    tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py`: clean.
  - `uv run pyright scripts/report_rtl_diversity_check.py
    scripts/run_rtl_diversity_wp3_rich_encoder.py
    scripts/run_rtl_diversity_wp3_learned_encoder.py`: 0 errors, 0 warnings.
  - `git diff --check`: clean.

### WP2 Near-Identical Motif Suppression

- Added `scripts/analyze_rtl_diversity_near_motif_suppression.py` with
  focused test
  `tests/scripts/test_analyze_rtl_diversity_near_motif_suppression.py`.
- Ran the near-motif suppression analysis:
  `uv run python scripts/analyze_rtl_diversity_near_motif_suppression.py --candidate-audit exp/diversity_check/restarted_report_20260621_071339_UTC/candidate_audit.parquet --output-dir exp/diversity_check/wp2_near_motif_suppression_20260621_072816_UTC`.
- Artifact:
  `exp/diversity_check/wp2_near_motif_suppression_20260621_072816_UTC/`.
- Coverage: distance-based motif suppression covers 2,335 RTLLM valid-PPA
  rows across 29 problem groups. ASP-DAC and Auto-BD imported rows do not
  carry distance-bearing `motif_vector` JSON in this audit, so they remain
  covered only by exact motif-signature hash and canonical-netlist duplicate
  replay.
- Aggregate result:
  - threshold `0.00`: retained 246/2,335 rows, suppressed 2,089 near-motif
    duplicates, retained HV 3.1507 vs baseline 3.1836, Pareto size 63 vs 793.
  - threshold `0.01`: retained 203/2,335 rows, suppressed 2,132 rows,
    retained HV 3.1384, Pareto size 61.
  - threshold `0.025`: retained 166/2,335 rows, suppressed 2,169 rows,
    retained HV 3.1266, Pareto size 53.
  - threshold `0.05`: retained 124/2,335 rows, suppressed 2,211 rows,
    retained HV 2.9510, Pareto size 50.
- Interpretation: near-motif suppression preserves the best fitness in this
  retrospective RTLLM slice, but it sharply reduces retained Pareto diversity
  and slightly lowers hypervolume. It is not a utility-positive intervention.
- Artifact hashes:
  - `near_motif_suppression_summary.json`:
    `48fff66d91151549efb48ef70234986add9598a007196672343a29f6140b2c20`
  - `near_motif_suppression.csv`:
    `239aa51992577f91e0d5e764e272f6a9bf72dd55329720e59d625760ac4370ae`
  - `near_motif_suppression_aggregate.csv`:
    `ac6f58ee5f8ce25203e447ffec989737b4e6a3425122a4e8e0f5f0a117c09a4b`
  - `near_motif_suppression_report.md`:
    `76d8f42a8dd8290fbec093ef7b4d2d6bf96de8a6343ae8cec6eb089fe7efa1ed`
- Updated `scripts/report_rtl_diversity_check.py` so the central Diversity
  Necessity Report loads the near-motif suppression summary and aggregate.
- Regenerated the central report:
  `uv run python scripts/report_rtl_diversity_check.py --output-dir exp/diversity_check/restarted_report_20260621_072933_UTC --aspdac-root exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp --wp0-artifact-dir exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC --qwen-smoke-limit 64`.
- Report artifact:
  `exp/diversity_check/restarted_report_20260621_072933_UTC/`.
- Report result remains `B illumination_only`.
- Updated report hashes:
  - `diversity_necessity_report.md`:
    `6027668d123332fb94df9739f8160c6e41b7ca1259d266e29e9826f12c95de8d`
  - `diversity_necessity_report.json`:
    `1b84602a9688d42f2b6357fd6d5eb34276e55364f3b214fadcf2e1c5dac84863`
  - `encoder_leaderboard.csv`:
    `794ac49d1322d8190f5cb80b3c75f4d1968bf89147f48658c5025ad394a48c82`
  - `d_gate_matrix.csv`:
    `4bf52c6ab5db8a13bec254fd7373643c6fa9fb9cdd11d259b05204bd0d0c995d`
  - `claim_levels.csv`:
    `27e5ee31d38a9fd2a48d351bba9a9d9731be70da66ba3896cbf8371a92dd8826`
  - `wp0_replay_summary.csv`:
    `c2656cc1f41cbc7998c8a4ffff0ee0376d8fd88393385d85626ed7f95d3d102b`
  - `case_studies.csv`:
    `c42ff93e19ede55c72ad9bcbc8dab49af7432c7b5e7241d14e87582d35e1f5d4`
