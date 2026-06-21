# Useful BD Push Implementation History

Unbounded journal for `useful_bd_push`. Record notable decisions, commands,
outputs, experiments, failed attempts, blockers, commits, and validation
evidence.

## Scaffold Start - 2026-06-22 KST

- Branch: `feat/journal-useful-bd-exp-20260622`.
- Scaffold directory:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/`.
- User intent: make another broad push to find useful behavior descriptors
  that can show QD/MAP-Elites is effective for RTL netlist evolution and PPA
  optimization.
- Starting evidence: previous committed diversity bundle at
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/`.
- Important user correction: the prior 10% effectiveness threshold was too
  strict as an early filter. This push should treat near-classic or small
  positive reproducible signals as worth deeper analysis.
- Scope of this commit: create goal-launch docs and technique package skeletons
  only. Do not activate `/goal` yet.

## Literature / Method Search Notes

Primary sources checked during scaffold creation:

- DeepGate3 and DeepGate4: scalable AIG/circuit representation learning with
  transformer-style or sparse graph-transformer components.
- NetTAG: text-attributed graph netlist foundation model aligned with RTL and
  layout.
- CircuitFusion: multimodal circuit representation over hardware code, graph,
  and functionality summaries.
- DeepSeq/DeepSeq2: sequential netlist learning with state/temporal behavior.
- MGVGA and DeepCell: self-supervised AIG/post-mapping netlist alignment and
  masked modeling.
- DE-HNN: directed hypergraph netlist representation for place-and-route
  prediction.
- AutoQD, AURORA, CVT-MAP-Elites, and VQ-Elites: QD mechanisms for automatic
  behavior spaces or scalable archives.

Interpretation: the next push should not only rerun raw Qwen or bounded
DeepGate3. It should try concrete surrogates and adaptations: projection heads,
cone splitting, sequential descriptors, text-attributed graphs, multimodal
representations, random-feature occupancy descriptors, and VQ/codebook archives
over stable non-PPA features.

## Technique Package Policy

Every method must write into `techniques/<technique_slug>/` and include:

- `methodology.md`: paper-style algorithm/specification;
- `artifacts_manifest.md`: run roots, commands, hashes, and tables/figures;
- `results_report.md`: measured results and tier decision;
- `figures/` and `tables/`: generated review artifacts after the method runs.

Placeholders are acceptable in the scaffold commit, but not at goal completion.

## Scaffold Expansion - User Corrections

- The minimum broad negative-map bar is now 10 current method attempts with
  real artifacts, not four.
- The acceptance bar is relaxed in the right place: a method can be useful from
  better hypervolume, passive archive coverage/QD score, Pareto-cell count,
  Pareto spread, unique front families, or valid-PPA yield even when average
  fitness is not the headline metric.
- The strict functionality guardrail remains: for the fixed compared subset and
  same evolutionary budget, a `T1` or higher method must produce at least one
  valid functional PPA candidate for every design where classic has at least
  one.
- Catastrophic validity collapse is not acceptable: a 50 percent or larger
  relative decline in functionality rate or synthesis-valid rate versus classic
  downgrades the method unless fixed before promotion. User later clarified the
  denominator caveat: enforce this as a hard gate only when classic has at
  least 10 passing samples for the corresponding stage; below that, report
  `small_n_validity` instead of rejecting on a noisy relative rate alone.
- Added `code_organization_policy.md` so new scripts and source modules stay
  small, typed, modular, and aligned with `GUIDELINES.md`.
- Added `visualization_reporting_policy.md` so generated figures are manually
  inspected for clarity and result reports contain precise conclusions,
  limitations, and next steps.
- Added `vllm_runtime_guide.md` after auditing the scaffold and finding that it
  had only generic vLLM guidance. The new guide records known endpoint
  patterns, `/v1/models` preflight commands, the 128000-token research policy,
  smoke harnesses, live command shape, and run artifact requirements.
- Strengthened dependency policy after user clarification: repo `.venv` or uv
  lock conflicts must not stop a proposed method. Future runs should use
  per-technique/per-run isolated uv environments, source checkouts, or
  submodules as needed, with exact commands and commits captured in manifests.
- Verified the shared GPT-OSS endpoint with
  `curl --max-time 15 http://20.0.0.103:8000/v1/models`. It returned
  `openai/gpt-oss-120b` with `max_model_len=131072`, so the runtime guide now
  treats `20.0.0.103:8000` as an active live API target instead of only an
  older Auto-BD reference.
- Added six extra method packages from the literature/architecture search:
  `T13_aurora_incremental_autoencoder_bd`, `T14_dehnn_hypergraph_bd`,
  `T15_masterrtl_sog_bd`, `T16_deepcell_multiview_bd`,
  `T17_mome_pareto_archive_bd`, and `T18_adaptive_emitter_cvt_bd`.
- Compressed `goal_template.md` so the activated goal body is safely under the
  4000-character goal-tool limit while keeping the sibling plan and policy
  files as the detailed contract.

## Active Goal Setup - 2026-06-21 UTC

- Confirmed active branch `feat/journal-useful-bd-exp-20260622` at
  `c1bc8e669907d4a80cb34c8ffaf3c2ca725a5612`.
- Dirty state at setup contained only the unrelated untracked
  `.devcontainer/devcontainer-lock.json` before new setup edits began.
- GPU visibility: one RTX A4000 and three RTX A6000 devices were visible via
  `nvidia-smi`.
- Re-preflighted `http://20.0.0.103:8000/v1/models`; it returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Read the 20260621 compiled conclusion and the 20260618/20260621 negative
  evidence trail. The key setup lesson is to reuse negative evidence without
  treating prior Qwen/DeepGate/AURORA failures as a reason to stop this push.
- Verified no local or remote branch named `aspdac2026-paper` is present in
  this worktree, while the copied ASP-DAC source archive exists under
  `exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/`.
- Added `scripts/report_useful_bd_push_setup.py` and a focused test to create
  setup artifacts from replay tables without touching core QD code.
- Ran
  `.venv/bin/python scripts/report_useful_bd_push_setup.py --timestamp 20260621_164500_UTC`.
  The script created ignored raw artifacts under
  `exp/useful_bd_push/setup_20260621_164500_UTC/`, initialized
  `exp/useful_bd_push/run_ledger.jsonl`, and created `envs/` plus `sources/`
  conventions for isolated dependencies.
- Committed setup tables under `tables/`: `source_inventory.csv`,
  `screening_subset_candidates.csv`, `frozen_screening_subset.csv`, and
  `holdout_screening_subset.csv`.
- Frozen screening subset: `VerilogEval-Spec-to-RTL/Prob153_gshare`,
  `RTLLM/Prob045_alu`, `RTLLM/Prob037_parallel2serial`,
  `RTLLM/Prob041_traffic_light`, `RTLLM/Prob015_multi_pipe_8bit`,
  `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm`, `RTLLM/Prob024_fsm`,
  `RTLLM/Prob004_adder_8bit`, `RTLLM/Prob049_signal_generator`, and
  `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`.
- Holdout subset: `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`,
  `VerilogEval-Spec-to-RTL/Prob098_circuit7`, and
  `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`.

## Simple Yosys-Stat Replay - 2026-06-21 UTC

- Located historical seed-1 `simple_yosys_stat_bd` standard-result artifacts
  under the 20260618 Auto-BD worktree. This provides a real simple-control
  method attempt even though the frozen 10-problem screening subset will be
  used for later current runs.
- Ran `scripts/report_auto_bd_standard_results.py` on
  `development_preliminary_seed1`, seed `1001`, writing ignored artifacts to
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/`.
- Packaged committed tables and figures under
  `techniques/T01_simple_yosys_stat_bd/`.
- Tier decision: `T0 diagnostic`. Simple Yosys-stat passes Gate 0 and loses no
  classic-covered problem, has mean HV within -0.24% of classic, and improves
  PPA-front unique netlists from 12 to 16. It does not reach `T1` because mean
  best fitness drops by 5.93% and common-audit QD score drops by 10.29%.
- Follow-up idea from this `T0`: keep Yosys-stat as the transparent lower
  bound, then test motif/pathlet and synthesis-delta descriptors for whether
  they preserve the near-classic HV while recovering QD score and best fitness.

## Local Navigation And Gate Clarification - 2026-06-21 UTC

- Added `README.md` as a local index for this revamp-history directory. It
  maps the top-level docs, committed tables, technique-package structure, and
  current technique states.
- Clarified the 50 percent functionality/synthesis-validity regression rule
  after user feedback: enforce it as a hard gate only where the classic
  baseline has at least 10 passing samples for the corresponding stage. Smaller
  denominators must be reported as `small_n_validity` rather than used as a
  hard accept/reject signal.

## Technique Index Rename - 2026-06-21 UTC

- Renamed all technique package subdirectories to visible chronological
  `T##_slug` names so method tracking does not depend on remembering scaffold
  order.
- Added `techniques/technique_registry.csv` as the stable machine-readable
  index. `T01` is the simple Yosys-stat control, `T02` is the motif/pathlet
  family replay, and `T03` through `T18` preserve the original scaffold order.
- Updated the root README, technique README, TODO, plan, and literature-method
  map to refer to numbered package directories.

## T02 Motif Pathlet Replay - 2026-06-21 UTC

- Added `scripts/package_useful_bd_replay_method.py` to package one method from
  the existing central Auto-BD replay JSON into a numbered technique directory.
  The script writes method-local CSV tables, small-n-aware validity-gate rows,
  and PNG figures with readable labels.
- Ran the packager on
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
  for method `netlist_motif_occupancy`, writing committed artifacts under
  `techniques/T02_motif_pathlet_bd/`.
- Visual inspection completed for all generated T02 figures. Notes are in
  `techniques/T02_motif_pathlet_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T0 diagnostic`. Gate 0 passes and the 50 percent validity
  collapse gate passes because functionality/synthesis/valid-PPA rate drops by
  only 8.13% relative to classic with 209 classic passing samples. However,
  mean hypervolume drops by 51.35%, mean best fitness drops by 12.00%,
  common-audit occupied cells drop from 12 to 8, and common-audit QD score
  drops from 2.3163 to -3.0274.
- Follow-up rationale: coarse motif occupancy alone is too weak. The next
  netlist-family attempt should add pathlets/reconvergence or combine motif
  axes with synthesis-trajectory deltas before retrying archive pressure.

## T03 Synthesis Delta ST-NOD Replay - 2026-06-21 UTC

- Ran `scripts/package_useful_bd_replay_method.py` on
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
  for method `synthesis_trajectory_nod`, writing committed artifacts under
  `techniques/T03_synthesis_delta_stnod_bd/`.
- Visual inspection completed for all generated T03 figures. Notes are in
  `techniques/T03_synthesis_delta_stnod_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T0 diagnostic`, prioritized near-miss. Gate 0 passes and the
  50 percent validity collapse gate passes because functionality, synthesis,
  and valid-PPA rates drop by only 1.91% relative to classic with 209 classic
  passing samples.
- Key signal: mean hypervolume is only 2.94% below classic; ST-NOD wins HV on
  two problems, ties three, and loses one. Unique canonical netlists increase
  from 70 to 72, PPA-front unique netlists from 12 to 13, and motif signatures
  from 43 to 52.
- Blocking issue: common-audit occupied cells drop from 12 to 11 and
  common-audit QD score drops from 2.3163 to -2.0643. The descriptor finds more
  structure but fills lower-quality common-audit cells.
- Follow-up rationale: do not retire ST-NOD. Try archive coupling around
  ST-NOD, especially local Pareto fronts or a stronger exploitation lane, so
  the near-classic HV behavior is preserved while passive QD score improves.

## T04 AutoQD MMD Synthesis Replay - 2026-06-21 UTC

- Ran `scripts/package_useful_bd_replay_method.py` on
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
  for method `sr_rff_pca_qd`, writing artifacts under
  `techniques/T04_autoqd_mmd_synthesis_bd/`.
- The replay maps T04 to the 20260618 synthesis-response RFF-PCA kernel
  control: `synthesis_response_raw_v1`, descriptor `sr_rff_pca_v1`, 128 RFF
  dimensions, seed `20260618`, and frozen PCA projection over 205 valid ST-NOD
  development candidates.
- Visual inspection completed for all generated T04 figures. Notes are in
  `techniques/T04_autoqd_mmd_synthesis_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T1 near_classic`, validation candidate. Gate 0 passes, all
  six classic-covered problems remain covered, and the 50 percent validity
  collapse gate passes because functionality, synthesis, and valid-PPA rates
  drop by only 5.74% relative to classic with 209 classic passing samples.
- Key signal: mean HV is only 1.24% below classic, mean best fitness is only
  1.53% below classic, HV AUC improves by 10.06%, common-audit QD score
  improves by 21.36%, and PPA-front unique netlists increase from 12 to 20.
- Caveat: common-audit occupied cells drop from 12 to 10, unique canonical
  netlists drop from 70 to 63, and per-problem HV only ties five problems and
  loses one. This is a near-classic lead for validation, not a final
  journal-positive claim.
- Follow-up rationale: compare `sr_rff_pca_qd`, `sr_random_relu_pca_qd`,
  `sr_raw_pca_qd`, and an ST-NOD plus RFF hybrid under the same passive
  archive. If the RFF signal survives a second seed or holdout replay, use it
  as the first candidate for MOME-style local-Pareto archive coupling.

## T05 VQ-Elites Codebook Replay - 2026-06-21 UTC

- Ran `scripts/package_useful_bd_replay_method.py` on
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
  for method `sr_vq_codebook_qd`, writing artifacts under
  `techniques/T05_vq_elites_codebook_bd/`.
- The replay maps T05 to the 20260618 fixed VQ codebook arm:
  descriptor `sr_vq_codebook_v1`, 16 centroids, k-means seed `20260618`, and
  frozen centroid-layout coordinates over 205 valid ST-NOD development
  candidates.
- Visual inspection completed for all generated T05 figures. Notes are in
  `techniques/T05_vq_elites_codebook_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T0 diagnostic`. Gate 0 passes and all six classic-covered
  problems remain covered. The 50 percent validity collapse gate passes
  because functionality, synthesis, and valid-PPA rates drop by 16.75%
  relative to classic, not 50% or more, with 209 classic passing samples.
- Key signal: SR VQ has one per-problem HV win on
  `VerilogEval-Spec-to-RTL/Prob030_popcount255` and increases PPA-front unique
  netlists from 12 to 13.
- Blocking issue: mean HV drops by 10.82%, mean best fitness by 21.18%,
  valid-PPA candidates by 16.75%, unique canonical netlists by 35.71%, motif
  signatures by 30.23%, common-audit occupied cells by 25.00%, and
  common-audit QD score by 63.37%.
- Follow-up rationale: do not run direct fixed-codebook parent pressure next.
  If the codebook family is revisited, use local Pareto fronts, residual-norm
  auxiliary axes, or side-archive coupling with a stronger exploitation lane.

## T06 Qwen Normalized-View Plan Update - 2026-06-21 UTC

- User suggested a simpler future technique using Qwen3 embedding models while
  acknowledging that RTL/netlist preprocessing and whole-design BD extraction
  remain open.
- Updated `techniques/T06_qwen_projection_bd/methodology.md` to make raw
  whole-file embedding an ablation only. The planned primary views are now
  `canonical_rtl_view`, `yosys_netlist_view`, and `structural_summary_view`.
- Added whole-design pooling guidance: chunk at stable syntactic boundaries,
  embed with fixed prompt/tokenizer settings, L2-normalize chunks, and pool by
  deterministic PPA-free weights such as token count, cell count, or signal
  count.
- Added projection and collapse gates: PCA/whitened PCA, contrastive
  view-pair projection, structural-bucket projection, CVT/grid archive
  mapping, and checks against identifier churn, text length, same-problem
  clustering, canonical netlist hash, motif signature hash, and problem id.
- Recorded prior Qwen evidence in the T06 manifest. The old diagnostic used
  `Qwen/Qwen3-Embedding-0.6B` on 768 candidates across 127 problems; raw to
  comment-stripped cosine mean was 0.9493, raw to identifier-normalized cosine
  mean was 0.6389, same-problem nearest-neighbor fraction was 0.9336, and
  identifier-normalized Qwen farthest-first improved HV by 3.35% over lexical
  farthest-first but remained `diagnostic_only_no_proceed`.
- This is a plan/spec update, not a completed T06 technique package. T06 still
  needs a current run, tables, figures, visual notes, and tier decision before
  the TODO can be checked.

## T06 Qwen Common-Audit Diagnostic Package - 2026-06-21 UTC

- Added `scripts/package_useful_bd_qwen_audit.py` and a focused unit test to
  package prior Qwen common-audit artifacts into the current useful-BD
  technique layout.
- Packaged
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/stage_results/wp1_qwen/`
  into `techniques/T06_qwen_projection_bd/`.
- Source diagnostic: `Qwen/Qwen3-Embedding-0.6B`, 768 candidates across 127
  problems, 682 valid-PPA candidates in replay, 341 retained candidates, and
  114 problem groups.
- Visual inspection completed for all generated T06 figures. Notes are in
  `techniques/T06_qwen_projection_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T0 diagnostic`. Qwen identifier-normalized farthest-first
  improves selected HV by 3.35% over lexical farthest-first and matches the
  fitness-top selected best fitness, but this is an offline retention audit,
  not a same-budget QD run.
- Blocking issue: raw Qwen loses HV by 1.25% versus lexical, Qwen identifier
  loses unique canonical netlists from 60 to 59 and motif signatures from 54 to
  51, nearest-neighbor same-problem fraction is 0.9336, same-corpus fraction is
  0.9479, same canonical-netlist fraction is only 0.1406, and same
  motif-signature fraction is only 0.1888.
- Follow-up rationale: do not promote raw or identifier-normalized whole-RTL
  Qwen as a BD. Try the normalized-view projection plan next: canonical RTL,
  Yosys-normalized netlist text, structural-summary text, pooled whole-design
  embeddings, and explicit nuisance-axis checks before any live run.

## T06 Qwen3 Preprocessing Ladder Note - 2026-06-21 UTC

- User suggested keeping a simpler future technique based on Qwen3 embedding
  models, while treating RTL/netlist normalization, whole-design pooling, and BD
  extraction as unresolved research questions rather than solved details.
- Updated `techniques/T06_qwen_projection_bd/methodology.md` with a concrete
  preprocessing ladder: raw RTL, commentless RTL, role-normalized RTL,
  canonical RTL, canonical Yosys netlist text, and summary-plus-netlist text.
- Added the default whole-design embedding rule for the future replay: chunk at
  module, declaration, assignment, always-block, or topological-netlist-level
  boundaries; L2-normalize chunks; pool with square-root token count as the
  first default; and compare plain mean and cell-count weighting as ablations.
- Added simple BD extraction candidates before learned heads: whitened PCA plus
  CVT, stable 2D PCA grid, one Qwen3 axis paired with a deterministic
  synthesis-response axis, and PCA residual-norm buckets.
- Updated `idea_backlog.md` so this lower-cost Qwen3 ladder remains available
  as a future replay before projection-head training, with same-problem collapse
  and duplicate/motif alignment as hard filters.

## T17 Passive Local-Pareto Audit - 2026-06-21 UTC

- User noted that classic's advantage partly comes from repeatedly sampling
  higher-quality parents, while QD should retain diversity without degenerating
  into scalar weighted-sum fitness sampling.
- Added `scripts/package_useful_bd_mome_pareto_audit.py` and
  `tests/scripts/test_package_useful_bd_mome_pareto_audit.py` to audit bounded
  local Pareto retention against one scalar elite per common-audit cell.
- Used `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/...`
  only as read-only source evidence. New generated outputs were written under
  `exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/`.
- Mirrored generated tables and figures into
  `techniques/T17_mome_pareto_archive_bd/` for the committed journal package.
- Audit rule: valid-PPA candidates with finite objective improvements and finite
  fitness; scalar mode keeps one highest-fitness candidate per common-audit cell;
  bounded local-Pareto mode keeps up to four nondominated candidates per cell,
  pruned by crowding distance.
- Visual inspection completed for all generated T17 figures. Notes are in
  `techniques/T17_mome_pareto_archive_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T0 diagnostic`. Local Pareto retention increases front
  material but does not itself create a decisive HV gain.
- Strongest signal: `sr_rff_pca_qd` retained candidates increase from 10 to 23,
  global Pareto points from 6 to 19, PPA-front unique netlists from 6 to 14,
  PPA-grid cells from 7 to 9, and unique canonical netlists from 10 to 18; mean
  HV increases only from 0.122151 to 0.122184.
- Follow-up rationale: run a bounded live Smooth-QD-v2-style variant on
  `sr_rff_pca_qd` or `sr_random_relu_pca_qd` with local Pareto fronts, underfilled
  cell exploration, and global nondominated-front sampling. Do not promote T17
  from passive retention evidence alone.
