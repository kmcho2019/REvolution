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

## Technique Lane Map - 2026-06-21 UTC

- User requested a clearer way to track technique categories, lineage, promising
  branches, and how each BD idea developed from previous results.
- Added `technique_lanes.md` at the revamp root. It groups current and planned
  techniques into lanes for common evaluation, transparent CAD descriptors,
  synthesis-response automatic BDs, codebook archives, learned encoders,
  archive coupling, and lineage/emitter methods.
- Added a Mermaid lineage graph showing how T01/T02/T03 led to T04, how T04/T05
  feed T17, and how T06 feeds the Qwen3 preprocessing/projection path.
- Recorded branch-splitting guidance: continue lightweight replay/docs/scripts
  on `feat/journal-useful-bd-exp-20260622`, and create lane-specific branches
  only for long-running live vLLM runs, incompatible dependency stacks, or
  source-checkout-heavy encoder work.
- Linked the lane map from the local `README.md` so future resumes can follow
  both the chronological technique registry and the lane-level thought process.

## T19 SR ReLU PCA Replay Package - 2026-06-21 UTC

- Packaged the previously unrepresented `sr_random_relu_pca_qd` seed-1001
  central replay arm into
  `techniques/T19_sr_relu_pca_bd/`.
- Used the central replay JSON at
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
  and read `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/...`
  only as source evidence.
- Descriptor provenance: `synthesis_response_raw_v1` features, fixed random
  ReLU map with 128 features and seed `20260618`, descriptor version
  `sr_random_relu_pca_v1`, and frozen axes `sr_pca_0..2`.
- Gate 0 passes: all six classic-covered problems remain covered. The
  functionality, synthesis, and valid-PPA collapse gates are enforced and pass;
  SR ReLU has 197 valid-PPA candidates versus 209 for classic, a 5.74% relative
  decline.
- Main positive signal: final mean HV improves from 0.1245 to 0.1454
  (+16.82%) and HV AUC improves from 0.0728 to 0.1202 (+65.24%). Per-problem HV
  wins occur on `Prob021_mux256to1v` and `Prob030_popcount255`.
- Main blocking signal: final mean best fitness declines by 5.04%,
  PPA-front unique netlists decline by 8.33%, and common-audit occupied cells
  decline by 16.67%.
- Tier decision: `T0 diagnostic`, high-priority HV lead. The follow-up is a
  quality-safe SR ReLU plus local-Pareto live variant, not immediate promotion.

## T20 SR Raw PCA Replay Package - 2026-06-21 UTC

- Packaged the previously unrepresented `sr_raw_pca_qd` seed-1001 central
  replay arm into `techniques/T20_sr_raw_pca_bd/`.
- Used the same central replay JSON and the same read-only `/aux` source run as
  the T19 package, but selected the plain raw-PCA synthesis-response arm.
- Descriptor provenance: `synthesis_response_raw_v1` features, no random
  feature map, descriptor version `sr_raw_pca_v1`, 205 fitting candidates, and
  frozen axes `sr_pca_0..2`.
- Gate 0 passes and validity is exactly preserved: functionality, synthesis,
  and valid-PPA counts are 209 for both classic and SR raw PCA.
- Positive signal: HV AUC improves from 0.0728 to 0.0904 (+24.24%),
  PPA-front unique netlists improve from 12 to 14 (+16.67%), unique canonical
  netlists improve from 70 to 74 (+5.71%), and motif signatures improve from 43
  to 48 (+11.63%).
- Blocking signal: final mean HV declines by 2.94%, final mean best fitness
  declines by 9.97%, and common-audit QD score declines by 15.11%.
- Tier decision: `T0 diagnostic`, projection ablation near-miss. Use it as the
  raw synthesis-response baseline for SR-ReLU/SR-RFF and local-Pareto variants,
  not as a standalone promotion candidate.

## T21 ST-NOD Motif Hybrid Replay Package - 2026-06-21 UTC

- Packaged the previously unrepresented `synthesis_trajectory_motif_nod`
  seed-1001 central replay arm into
  `techniques/T21_stnod_motif_hybrid_bd/`.
- Descriptor provenance: `stnod_motif_trajectory_9d`, no learned fitting,
  final synthesized-netlist motif ratios plus five ST-NOD trajectory axes.
- Gate 0 passes and the validity collapse gate passes. Functionality,
  synthesis, and valid-PPA counts are 198 versus 209 for classic, a 5.26%
  relative decline.
- Positive signal: PPA-front unique netlists improve from 12 to 20 (+66.67%),
  common-audit occupied cells improve from 12 to 16 (+33.33%), unique canonical
  netlists improve from 70 to 77 (+10.00%), and HV AUC improves from 0.0728 to
  0.0903 (+24.09%).
- Blocking signal: final mean HV declines by 3.28%, final mean best fitness
  declines by 10.90%, and common-audit QD score declines by 25.98%. The method
  has no per-problem HV wins against classic.
- Tier decision: `T0 diagnostic`, archive-coverage ablation. The package brings
  the current push to ten real result packages, but broad sign-off still
  requires central comparison, deeper validation of T1+ leads, and adversarial
  review.

## Current Results Matrix - 2026-06-21 UTC

- Added `current_results_matrix.md` as the local comparison table after the
  minimum ten real result packages were reached.
- The matrix separates central seed-1001 replay methods, the Qwen diagnostic,
  and the passive local-Pareto audit so unlike evidence types are not merged
  into one misleading score.
- Current read: `T04` SR-RFF remains the cleanest `T1 near_classic` validation
  candidate, `T19` SR ReLU is the strongest HV/HV-AUC source but has quality
  and coverage regressions, and `T20`/`T21` provide front-material ablations
  rather than promotion candidates.
- The random descriptor control is explicitly flagged because it has nontrivial
  HV-AUC and front-net behavior. Future positive claims should compare against
  random descriptor, not only classic and manual BD.

## T22 Random Descriptor Control Package - 2026-06-21 UTC

- Packaged `random_descriptor_qd` into
  `techniques/T22_random_descriptor_control/` so the required negative control
  is visible in the same registry and report surface as descriptor candidates.
- Descriptor provenance: `random_hash_3d`, deterministic pseudo-random axes
  derived from canonical synthesized-netlist hash with seed
  `20260618_auto_bd_random_descriptor`.
- Gate 0 passes and validity is slightly above classic: functionality,
  synthesis, and valid-PPA counts are 213 versus 209 for classic.
- Control strength: HV AUC improves from 0.0728 to 0.0987 (+35.69%),
  best-fitness AUC improves from 0.2327 to 0.2451 (+5.32%), and PPA-front
  unique netlists improve from 12 to 21 (+75.00%).
- Negative-control blockers: final mean HV declines by 5.61%,
  common-audit occupied cells decline by 33.33%, common-audit QD score declines
  by 26.57%, and the descriptor has no semantic hardware meaning.
- Tier decision: `T0 control`, required comparator. Future positive claims must
  beat T22 on the metric being claimed, not only classic or manual BD.

## T23 SR Pareto Validation Matrix - 2026-06-21 UTC

- Added `scripts/package_useful_bd_validation_matrix.py` and
  `tests/scripts/test_package_useful_bd_validation_matrix.py`.
- Generated focused validation artifacts under
  `exp/useful_bd_push/t23_sr_pareto_validation_matrix_20260621_183200_UTC/`
  and mirrored the CSV/PNG outputs into
  `techniques/T23_sr_pareto_validation_matrix/`.
- Inputs: central seed-1001 replay JSON plus T17 passive local-Pareto aggregate
  table. Focus methods: classic, manual BD, T22 random, T19 SR ReLU PCA, and
  T04 SR-RFF PCA.
- Main read: SR ReLU PCA beats classic and random on final HV and HV AUC, but
  does not beat random on local front material. SR-RFF PCA stays near classic on
  final HV/best fitness, beats classic and random on common-audit QD score, and
  has the strongest local PPA-front netlist and global Pareto point counts.
- Validation: focused pytest passed, ruff passed, and pyright passed when run
  with `--pythonpath .venv/bin/python` so it resolved the local plotting/data
  packages.
- Tier decision: `T0 diagnostic`, passive validation support. The next
  experiment should be a bounded live local-Pareto variant for SR-RFF and/or
  SR ReLU, with T22 included as a required comparator.

## Technique Lane Ledger Refinement - 2026-06-21 UTC

- Expanded `technique_lanes.md` from a lane summary into a maintainable
  decision ledger for the current useful-BD push.
- Added explicit result tags: `advance`, `ablate`, `hybridize`, `park`,
  `control`, and `retire`.
- Added a decision ledger tying T01-T06, T17, and T19-T23 to lane-level
  decisions, next artifacts, and the likely Pareto-live branch split.
- Updated the Mermaid lineage graph so T23 points into the next live
  local-Pareto validation branch.
- Updated `current_results_matrix.md` because T23 now exists; the next decision
  is no longer to build the validation matrix, but to use it to specify a live
  SR-RFF/SR-ReLU local-Pareto run.

## T24 SR Pareto Live Validation Package - 2026-06-21 UTC

- Created `techniques/T24_sr_pareto_live_validation/` as the next live
  validation package after T23.
- Preflighted `http://20.0.0.103:8000/v1/models`; response reports
  `openai/gpt-oss-120b` with `max_model_len=131072`, satisfying the 128000
  token-policy requirement.
- Mirrored the preflight JSON into
  `tables/preflight_models_20260621_184346_UTC.json` with sha256
  `7286fa860e28d21680352c03d8352b44523fe651bb4c11378a607c391f9422b9`.
- Fixed the first live screen to three RTLLM problems from the frozen subset:
  `Prob045_alu`, `Prob041_traffic_light`, and `Prob015_multi_pipe_8bit`.
- Added the six-arm comparator matrix: classic, manual BD, T22 random, T20 SR
  raw PCA, T19 SR ReLU PCA, and T04 SR-RFF PCA.
- T24 uses existing live code paths rather than new archive code:
  `qd_cell_mode=pareto_front`, `qd_max_elites_per_cell=5`,
  `qd_parent_selection=nsga2_global_rank`, and
  `qd_champion_lane_fraction=0.5`.
- Tier remains `pending_live_run`. No T1/T2/T3 claim is allowed until the
  commands complete, validator outputs exist, and figures/tables are inspected.

## Technique Lane Process Guide - 2026-06-21 UTC

- Strengthened `technique_lanes.md` into the durable lane-level process guide
  for the useful-BD push.
- Added a lane taxonomy that states the core question, technique family,
  promotion signal, and recycle/stop signal for L0-L6.
- Added a lane scorecard so the current best lead, blocker, and branch strategy
  are visible without reading every `Txx` package.
- Reworked the Mermaid lineage graph into lane-grouped subgraphs, then added a
  second Mermaid flow for the expected idea-to-replay-to-live-to-branch loop.
- Kept chronological artifact ownership in the `Txx` technique packages; this
  guide tracks process lineage, not raw run outputs.

## T24 Classic vs SR-RFF Live Result - 2026-06-21 UTC

- Completed the T24 classic baseline arm and SR-RFF PCA Pareto-QD arm under
  the fixed three-problem RTLLM live screen.
- Both arms used `openai/gpt-oss-120b`, seed 1001, population 12, three
  generations, strict ablation evaluation, and 128000-token code/diff budgets.
- Classic completed in 637.13 seconds and solved all three problems.
- SR-RFF completed in 748.20 seconds and also solved all three problems, so the
  minimum classic-covered design preservation gate passes.
- Ran `scripts/validate_pareto_front_run.py` for SR-RFF without the
  manual-profile-only hard-subset flag. The Pareto archive validator passed
  with zero failures and max front size 4.
- Packaged `tables/live_sr_rff_vs_classic.csv`,
  `tables/live_sr_rff_pareto_validation.{json,md}`, and
  `figures/live_sr_rff_vs_classic.png`.
- Visual inspection found the figure readable and supportive of the cautious
  conclusion: SR-RFF has front material and one best-score gain, but the
  multi-pipe regression dominates the result.
- Best-score deltas: `Prob045_alu` -0.57%, `Prob041_traffic_light` +1.58%,
  and `Prob015_multi_pipe_8bit` -66.06%.
- Valid-PPA-rate deltas: `Prob045_alu` +6.25 absolute points,
  `Prob041_traffic_light` -25.00 absolute points, and
  `Prob015_multi_pipe_8bit` -25.00 absolute points.
- Promotion decision: do not promote SR-RFF local-Pareto as-is. The multi-pipe
  valid-PPA drop is 60% relative with 20 classic valid-PPA samples, so this is
  not a small-denominator artifact.
- Lane decision: mark T24 SR-RFF as `ablate`. Continue with SR ReLU live or a
  quality/yield guarded SR-RFF variant before expanding the matrix.

## T24 SR ReLU Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models` before the SR ReLU arm.
  The endpoint still reported `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- Completed the `sr_random_relu_pca_qd` arm under the same T24 live screen:
  seed 1001, population 12, three generations, strict ablation evaluation, and
  128000-token code/diff budgets.
- SR ReLU completed in 742.59 seconds and solved all three fixed problems, so
  the classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures and max front size 5.
- Packaged `tables/live_sr_family_vs_classic.csv`,
  `tables/live_sr_relu_pareto_validation.{json,md}`, and
  `figures/live_sr_family_vs_classic.png`.
- Visual inspection found the combined SR-family figure readable. Fixed method
  colors and a zero line make the loss/gain direction clear.
- Best-score deltas versus classic: `Prob045_alu` -0.02%,
  `Prob041_traffic_light` -2.53%, and `Prob015_multi_pipe_8bit` -75.20%.
- Valid-PPA-rate deltas versus classic: `Prob045_alu` 0.00 absolute points,
  `Prob041_traffic_light` -27.08 absolute points, and
  `Prob015_multi_pipe_8bit` -8.33 absolute points.
- SR ReLU retains more local-front material than SR-RFF on traffic light and
  multi-pipe, but it still fails the near-classic quality bar on multi-pipe.
- Promotion decision: do not promote SR ReLU local-Pareto as-is.
- Lane decision: keep the SR-family live result as `ablate`; run SR raw and
  random/manual controls, then design a quality/yield-guarded emitter or parent
  pressure variant before expanding SR-family live sampling.

## T24 SR Raw Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models` before the SR raw arm.
  The endpoint reported `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed the `sr_raw_pca_qd` arm under the same T24 live screen: seed 1001,
  population 12, three generations, strict ablation evaluation, and
  128000-token code/diff budgets.
- SR raw completed in 800.80 seconds and solved all three fixed problems, so
  the classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures and max front size 4.
- Packaged the three completed SR-family arms into
  `tables/live_sr_family_vs_classic.csv`,
  `tables/live_sr_raw_pareto_validation.{json,md}`, and the regenerated
  `figures/live_sr_family_vs_classic.png`.
- Visual inspection found the regenerated three-method figure readable. Fixed
  colors, rotated labels, and the zero line make the SR raw ALU gain and
  multi-pipe quality loss easy to see.
- Best-score deltas versus classic: `Prob045_alu` +1.85%,
  `Prob041_traffic_light` -5.60%, and `Prob015_multi_pipe_8bit` -57.09%.
- Valid-PPA-rate deltas versus classic: `Prob045_alu` +4.17 absolute points,
  `Prob041_traffic_light` -37.50 absolute points, and
  `Prob015_multi_pipe_8bit` -2.08 absolute points.
- SR raw has the strongest completed SR-family multi-pipe front material:
  17 archive members and 10 global Pareto members on
  `Prob015_multi_pipe_8bit`.
- Promotion decision: do not promote SR raw local-Pareto as-is. It keeps useful
  front material but fails the multi-pipe best-quality bar and violates the
  traffic-light synthesis-validity gate by a 60% relative drop with a large
  classic denominator.
- Lane decision: keep the SR-family live result as `ablate`; run random and
  manual controls, then design a quality/yield-guarded emitter or parent
  pressure variant before expanding SR-family live sampling.

## T24 Random Descriptor Live Control - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models` before the random
  descriptor arm. The endpoint reported `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- Completed the `random_descriptor_qd` arm under the same T24 live screen:
  seed 1001, population 12, three generations, strict ablation evaluation, and
  128000-token code/diff budgets.
- Random completed in 798.64 seconds and solved all three fixed problems, so
  the classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures and max front size 3.
- Packaged `tables/live_completed_qd_vs_classic.csv`,
  `tables/live_random_pareto_validation.{json,md}`, and
  `figures/live_completed_qd_vs_classic.png`.
- Visual inspection found the completed-QD figure readable. The gray random
  bars make the live random-control baseline visible beside the SR-family arms.
- Best-score deltas versus classic: `Prob045_alu` +1.45%,
  `Prob041_traffic_light` -10.82%, and `Prob015_multi_pipe_8bit` -71.33%.
- Valid-PPA-rate deltas versus classic: `Prob045_alu` -4.17 absolute points,
  `Prob041_traffic_light` -45.83 absolute points, and
  `Prob015_multi_pipe_8bit` -10.42 absolute points.
- Promotion decision: random is a required comparator, not a lead. It is weaker
  than SR raw on ALU best score and multi-pipe front material, and weaker than
  SR-RFF on traffic-light best score and valid-PPA rate.
- Lane decision: keep T24 random as `control`; run the manual BD arm next, then
  design a quality/yield-guarded emitter or parent-pressure variant before
  expanding SR-family live sampling.

## T24 Manual BD And Complete Live Matrix - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models` before the manual BD arm.
  The endpoint reported `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed the `landing_smooth_qd_manual_bd` arm under the same T24 live
  screen: seed 1001, population 12, three generations, strict ablation
  evaluation, and 128000-token code/diff budgets.
- Manual BD completed in 717.36 seconds and solved all three fixed problems,
  so the classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures and max front size 5.
- Packaged the full five-QD-arm comparison into
  `tables/live_completed_qd_vs_classic.csv`,
  `tables/live_manual_pareto_validation.{json,md}`,
  `tables/preflight_models_20260621_203536_UTC.json`, and the regenerated
  `figures/live_completed_qd_vs_classic.png`.
- Visual inspection found the regenerated completed-QD figure readable. The
  figure now shows manual BD, random, SR-RFF, SR ReLU, and SR raw with fixed
  colors and no label overlap.
- Manual BD best-score deltas versus classic: `Prob045_alu` +1.04%,
  `Prob041_traffic_light` +4.58%, and `Prob015_multi_pipe_8bit` -73.16%.
- Manual BD valid-PPA-rate deltas versus classic: `Prob045_alu` +12.50
  absolute points, `Prob041_traffic_light` -8.33 absolute points, and
  `Prob015_multi_pipe_8bit` -10.42 absolute points.
- Completed T24 matrix decision: `T0 diagnostic`, not promoted. Every QD arm
  preserves all classic-covered designs and validates the Pareto archive, but
  every QD arm loses too much `Prob015_multi_pipe_8bit` best quality.
- Lane decision: keep SR raw as the front-material control and manual BD as the
  traffic-light quality control for a quality/yield-guarded emitter or
  parent-pressure variant before larger live sampling.

## T25 Guarded SR Raw Method Card - 2026-06-21 UTC

- Added a default-preserving scheduler knob:
  `qd_improve_backfill_fraction`, default `0.20`, matching the prior hardcoded
  improve-phase backfill behavior.
- Pre-registered `T25_guarded_sr_raw_pareto_qd` as the first direct follow-up
  to the complete T24 live matrix.
- T25 keeps the SR raw descriptor, `grid_quantile` archive, local Pareto cells,
  NSGA-II parent selection, and T24 budget/model/subset.
- T25 changes only the schedule guard:
  `qd_fill_target_fraction=0.10`, `qd_improve_backfill_fraction=0.05`,
  `qd_two_parent_probability=0.25`, and
  `qd_champion_lane_fraction=0.50`.
- Pre-registered run root:
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/`.
- Rationale: test whether SR raw can keep ALU gain and multi-pipe front
  material while reducing the multi-pipe best-quality collapse and
  traffic-light synthesis-validity drop observed in T24.
- Next action: run the T25 live command after code/tests pass, then package the
  comparison against T24 classic/manual/random/SR raw.

## Technique Lineage Ledger - 2026-06-21 UTC

- Added `technique_lineage_ledger.md` as the skim-first process map for the
  useful-BD push.
- The new ledger categorizes technique families by lane, records current
  result status, gives branch/return conditions, and includes a Mermaid lineage
  graph from prior negative diversity evidence through T25.
- Kept `technique_lanes.md` as the detailed rationale and decision-ledger
  document, while the new ledger serves as the compact navigation layer.
- Updated the local README and TODO so future technique updates keep category,
  result, lineage, and branch direction synchronized with the package reports.

## T25 Guarded SR Raw Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed T25 under
  `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/` with
  seed 1001, population 12, three generations, strict ablation evaluation,
  and 128000-token code/diff budgets.
- Runtime was 750.54 seconds. The run solved all three fixed problems, so the
  classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures. Archive members:
  `Prob045_alu` 16, `Prob041_traffic_light` 8,
  `Prob015_multi_pipe_8bit` 13. Max local front size was 2.
- Packaged `tables/live_guarded_vs_t24_controls.csv`,
  `tables/live_guarded_pareto_validation.{json,md}`,
  `tables/preflight_models_20260621_210402_UTC.json`, and
  `figures/live_guarded_vs_t24_controls.png`.
- Visual inspection found the generated figure readable: grouped colors are
  distinct, zero lines expose regressions, labels fit, and the front-material
  panel clearly shows T25 below unguarded SR raw on multi-pipe.
- T25 best-score deltas versus classic: `Prob045_alu` +1.23%,
  `Prob041_traffic_light` -3.48%, and `Prob015_multi_pipe_8bit` -75.20%.
- T25 valid-PPA deltas versus classic: `Prob045_alu` +4.17 absolute points,
  `Prob041_traffic_light` -43.75 absolute points, and
  `Prob015_multi_pipe_8bit` -12.50 absolute points.
- Promotion decision: `T0 diagnostic`, not promoted. T25 preserves coverage
  but worsens multi-pipe best score versus unguarded SR raw and fails the
  traffic-light valid-PPA gate with 9 passing samples versus classic's 30.
- Lane decision: keep T25 as negative evidence. The next live method should
  change parent-source structure with explicit exploit/explore/repair emitter
  scheduling rather than only tuning the guarded schedule.

## T26 Conservative Exploit Method Card - 2026-06-21 UTC

- Pre-registered `T26_sr_raw_conservative_exploit_qd` as the next live
  parent-source variant after T25.
- T26 keeps the SR raw PCA descriptor, `grid_quantile` archive, local Pareto
  cells, NSGA-II parent selection, and T24/T25 budget/model/subset.
- T26 restores the T24-style fill target (`qd_fill_target_fraction=0.25`) so
  fail-pool and seed pressure remain active longer than in T25.
- T26 removes two-parent crossover (`qd_two_parent_probability=0.00`) and
  raises the champion lane (`qd_champion_lane_fraction=0.80`) so archive-parent
  requests mostly refine the current best candidate while keeping some
  nonchampion NSGA-II parent draws.
- Pre-registered run root:
  `exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC/`.
- Rationale: test whether the T24/T25 failure came from disruptive archive
  parent mixing rather than the SR raw BD itself.
- Next action: run the T26 live command and package the result against T24
  classic/manual/random/SR raw plus T25.

## T26 Conservative Exploit Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed T26 under
  `exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC/`
  with seed 1001, population 12, three generations, strict ablation
  evaluation, and 128000-token code/diff budgets.
- Runtime was 715.08 seconds. The run solved all three fixed problems, so the
  classic-covered design preservation gate passes.
- Pareto archive validation passed with zero failures. Archive members:
  `Prob045_alu` 22, `Prob041_traffic_light` 17,
  `Prob015_multi_pipe_8bit` 14. Max local front size was 4.
- Packaged `tables/live_conservative_vs_t24_t25_controls.csv`,
  `tables/live_conservative_pareto_validation.{json,md}`,
  `tables/preflight_models_20260621_213249_UTC.json`, and
  `figures/live_conservative_vs_t24_t25_controls.png`.
- Visual inspection found the generated figure readable: grouped colors are
  distinct, zero lines expose regressions, labels fit, and the T26 bar is easy
  to compare against T24/T25 controls.
- T26 best-score deltas versus classic: `Prob045_alu` +3.73%,
  `Prob041_traffic_light` -3.48%, and `Prob015_multi_pipe_8bit` +14.34%.
- T26 valid-PPA deltas versus classic: `Prob045_alu` +14.58 absolute points,
  `Prob041_traffic_light` -25.00 absolute points, and
  `Prob015_multi_pipe_8bit` -8.33 absolute points.
- Promotion decision: `T0 diagnostic`, active lead for follow-up audit. T26
  beats classic on ALU and multi-pipe best score and avoids the catastrophic
  validity gate, but traffic-light quality still trails classic/manual BD and
  SR raw keeps stronger multi-pipe front material.
- Lane decision: package passive HV/QD, front spread, unique implementation
  families, and holdout evidence before promotion or a repair-emitter branch.

## T27 T26 Live QD Audit - 2026-06-21 UTC

- Added `scripts/package_t27_t26_live_qd_audit.py` and
  `tests/scripts/test_package_t27_t26_live_qd_audit.py`.
- Packaged `techniques/T27_t26_live_qd_audit/` from the completed T24, T25,
  and T26 live run roots under `exp/useful_bd_push/`.
- The audit compares classic, manual BD, random descriptor, SR raw, guarded SR
  raw, and conservative exploit SR raw on the fixed three-problem development
  screen.
- Generated `tables/live_qd_problem_metrics.csv`,
  `tables/live_qd_aggregate_metrics.csv`,
  `tables/live_qd_comparison_deltas.csv`, and
  `tables/live_qd_method_manifest.csv`.
- Generated `figures/live_qd_problem_metrics.png` and
  `figures/live_qd_aggregate_metrics.png`; visual inspection accepted both
  figures and recorded the front-material caveat.
- T26 versus classic aggregate deltas: mean live HV +11.62%, HV-AUC +17.62%,
  mean best score +3.02%, valid-PPA count -13.64%, PPA-front points -50.00%,
  unique PPA points tied, and mean front nearest-neighbor spread +29.23%.
- T26 versus random aggregate deltas: mean live HV +58.60%, HV-AUC +87.55%,
  mean best score +26.60%, valid-PPA count +54.05%, PPA-front points +28.57%,
  unique PPA points +70.97%, and active global Pareto members +28.57%.
- T26 versus SR raw aggregate deltas: mean live HV +21.55%, HV-AUC +13.24%,
  mean best score +18.97%, valid-PPA count +16.33%, and unique PPA points
  +20.45%, but active global Pareto members fall from 16 to 9 and PPA-front
  points fall from 16 to 9.
- Tier read: T27 supports T26 as a `T1 near_classic` validation candidate for
  live HV/HV-AUC, not as a final `T2` useful-QD win.
- Limitation: the live logs do not expose canonical netlist hashes or
  implementation-family hashes, so T27 reports unique PPA tuples only as a
  proxy duplicate metric. Canonical duplicate/family and holdout audit remain
  required before promotion.
- Updated `README.md`, `current_results_matrix.md`, `technique_lanes.md`,
  `technique_lineage_ledger.md`, `techniques/README.md`,
  `techniques/technique_registry.csv`, `idea_backlog.md`, and this checklist
  surface so the technique lane, lineage, result, and branch decisions all
  point to the same next action.

## T28 T26 Family Audit And PPA Viewer - 2026-06-21 UTC

- Added `scripts/package_t28_t26_family_audit.py` and
  `tests/scripts/test_package_t28_t26_family_audit.py`.
- Packaged `techniques/T28_t26_family_audit/` from the completed T24, T25,
  and T26 live run roots under `exp/useful_bd_push/`.
- The audit hashes normalized RTL, normalized synthesized netlists, and
  synthesized-cell histogram families for every valid-PPA candidate in the
  three-problem development screen.
- Generated `tables/family_candidate_rows.csv`,
  `tables/family_problem_metrics.csv`,
  `tables/family_aggregate_metrics.csv`,
  `tables/family_comparison_deltas.csv`, and
  `tables/family_method_manifest.csv`.
- Generated family figures plus direct PPA Pareto-front figures:
  `figures/family_aggregate_counts.png`,
  `figures/family_problem_front_counts.png`,
  `figures/ppa_pareto_fronts_area_power.png`, and
  `figures/ppa_pareto_fronts_improvement.png`.
- Generated a scoped Phase 03.1 viewer at
  `visualizations/qd_ppa_viewer/index.html` with source CSVs under
  `visualizations/qd_ppa_viewer_source/final_analysis/`.
- Static viewer validation passed with
  `scripts/validate_qd_ppa_visualization.py --viewer-root .../qd_ppa_viewer`.
- Playwright loaded the viewer and generated screenshots, but reported one
  expected archive-hover caveat: Classic has no honest projection into T26's
  SR-PCA archive, so the Classic archive pane has no occupied cell. The PPA
  pane and T26 native archive screenshots were visually inspected.
- Visual inspection accepted the two new direct PPA-front figures after a
  layout fix moved the legend away from the explanatory note.
- Aggregate T28 read: T26 has 52 unique valid families from 57 valid-PPA
  candidates, the best valid-family ratio (0.912281), and 37
  reference-beating families, one more than classic.
- Front-family blocker: T26 has 9 front families and 9 front netlists, while
  classic has 19 front families and 21 front netlists, and SR raw has 16 front
  families and 16 front netlists.
- Tier read: T28 keeps T26 as `T1 near_classic` audit support. It removes the
  duplicate-collapse concern for the valid pool but blocks a broad useful-QD
  claim because front-family coverage is still weak.
- Updated the local index, current-results matrix, visualization policy,
  technique lane ledger, lineage ledger, idea backlog, TODO, technique index,
  and T28 package docs so future techniques include direct PPA-front figures
  and the Phase 03.1 viewer when feasible.

## Direct PPA Front Visualization Audit - 2026-06-21 UTC

- Added `scripts/package_useful_bd_direct_ppa_fronts.py` and
  `tests/scripts/test_package_useful_bd_direct_ppa_fronts.py`.
- Packaged `visualization_audits/20260621_direct_ppa_fronts/` from the
  completed T24, T25, and T26 live run roots under `exp/useful_bd_push/`.
- Generated candidate-level source tables:
  `tables/candidate_ppa_points.csv`, `tables/problem_front_counts.csv`, and
  `tables/method_manifest.csv`.
- Generated direct PPA-front figures:
  `figures/live_key_ppa_fronts_area_power_zoom.png`,
  `figures/live_key_ppa_fronts_area_power.png`,
  `figures/live_key_ppa_fronts_improvement.png`,
  `figures/live_all_ppa_fronts_area_power_zoom.png`,
  `figures/live_all_ppa_fronts_area_power.png`,
  `figures/live_all_ppa_fronts_improvement.png`, and
  `figures/live_front_count_summary.png`.
- Visual inspection accepted the key-method candidate-zoom and normalized
  improvement plots as the clearest direct answer to the missing PPA-front
  concern.
- The raw reference-context plots are retained for scale, but the
  `Prob045_alu` reference point stretches the y-axis; use the zoomed raw plots
  for front geometry.
- The first front-count summary image had a title/legend overlap and was
  regenerated with the legend below the panels.
- Candidate-level front-count read: on `Prob015_multi_pipe_8bit`,
  Conservative exploit has 6 rank-1 front points, SR raw has 10, and Classic
  has 14. This agrees with the T28 family-level blocker and strengthens the
  case for a front-recovery variant before any promotion claim.

## T29 SR Raw Front Recovery Pre-Registration - 2026-06-21 UTC

- Created `techniques/T29_sr_raw_front_recovery_qd/` as the next live
  archive-coupling package.
- The pre-registered question is whether limited SR raw exploration can recover
  front material versus T26 while preserving T26's live HV/HV-AUC signal.
- T29 keeps the frozen SR raw PCA descriptor, `grid_quantile` archive,
  local-Pareto cells, T26 fill/improve backfill settings, NSGA-II parent
  selection, seed 1001, model, endpoint, token budgets, and fixed
  three-problem live screen.
- T29 changes only parent-source pressure: `qd_champion_lane_fraction=0.60`
  and `qd_two_parent_probability=0.20`.
- Added methodology, command, run matrix, pending artifact manifest, pending
  results report, figure requirements, visualization placeholder, and central
  lane/index updates before executing the live run.

## T29 SR Raw Front Recovery Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed T29 under
  `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/` with
  seed 1001, population 12, three generations, strict ablation evaluation,
  and 128000-token code/diff budgets.
- Runtime was 769.10 seconds. `Prob045_alu` and `Prob041_traffic_light` had
  final-population best PPA, but `Prob015_multi_pipe_8bit` did not.
- Pareto archive validation passed structurally with zero failures, but the
  validator also reported zero active archive members for
  `Prob015_multi_pipe_8bit`.
- Added `scripts/package_t29_front_recovery_audit.py` and
  `tests/scripts/test_package_t29_front_recovery_audit.py`.
- Packaged `techniques/T29_sr_raw_front_recovery_qd/` from the completed T24,
  T25, T26, and T29 live run roots under `exp/useful_bd_push/`.
- Generated direct PPA-front figures:
  `figures/t29_ppa_fronts_area_power_zoom.png` and
  `figures/t29_ppa_fronts_improvement.png`, plus count/aggregate/family plots.
- Visual inspection accepted the direct-front plots. Open-circle front markers
  are clear, raw axes state the lower-is-better inversion, and the normalized
  plot gives a higher-is-better view for cross-problem comparison.
- Aggregate T29 read versus T26: mean HV -22.12%, HV-AUC -18.06%, valid PPA
  -26.32%, total front points -11.11%, and final-best problem count drops from
  three to two.
- Direct-front read: on `Prob015_multi_pipe_8bit`, T29 has six candidate-level
  valid PPA samples, two rank-1 PPA-front points, zero reference-beating
  candidates, zero active archive members, and no final best PPA.
- Tier read: `T0 diagnostic`. T29 is measured negative evidence for simple
  partial reversal of T26's champion-lane schedule.
- Lane decision: retire this direct front-recovery variant. Do not continue
  blind interpolation between T24 SR raw and T26 scheduler settings; next
  should be a T26 holdout audit or a T31 repair/yield/front-preserving emitter.
- Validation: focused pytest and ruff passed for the new packager and test.
  Pyright reported only the pre-existing plotting-script environment noise:
  unresolved `matplotlib` imports, matching T27/T28 packaging scripts.

## T30 T26 Holdout Front Audit Pre-Registration - 2026-06-21 UTC

- Created `techniques/T30_t26_holdout_front_audit/` as the next evidence
  package after T29.
- T30 is a holdout audit, not a new descriptor: it compares classic REvolution
  against exact T26 conservative-exploit SR raw on the frozen holdout screen.
- Fixed holdout problems from `tables/holdout_screening_subset.csv`:
  `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`,
  `VerilogEval-Spec-to-RTL/Prob098_circuit7`, and
  `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`.
- Fixed runtime to the same model, endpoint, seed, population, generations,
  token budgets, strict ablation evaluation, and worker settings used by the
  development-screen live runs.
- Added methodology, two-arm live command, holdout subset YAML, run matrix,
  pending artifact manifest, pending results report, figure requirements,
  visualization placeholder, and central lane/index updates before execution.
- Rationale: T29 shows simple front-recovery interpolation fails. T30 checks
  whether T26's current HV/HV-AUC/best-quality signal generalizes before
  spending effort on a repair/yield/front-preserving emitter.

## T30 T26 Holdout Front Audit Live Result - 2026-06-21 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed the two-arm holdout run under
  `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/`.
- Classic runtime was 580.04 seconds. T26 conservative-exploit runtime was
  646.44 seconds.
- Classic final-best scores:
  `Prob150_review2015_fsmonehot` 0.329686,
  `Prob098_circuit7` 0.012006, and
  `Prob135_m2014_q6b` 0.331046.
- T26 final-best scores:
  `Prob150_review2015_fsmonehot` 0.329686,
  `Prob098_circuit7` 0.012006, and
  `Prob135_m2014_q6b` 0.397698.
- Pareto archive validation passed structurally for the T26 holdout arm:
  valid `True`, failure count `0`, and max front size seen `3`.
- Added `scripts/package_t30_holdout_front_audit.py` and
  `tests/scripts/test_package_t30_holdout_front_audit.py`.
- Packaged T30 tables for live metrics, T26-vs-classic deltas, canonical
  RTL/netlist/family accounting, method manifest, vLLM preflight metadata, and
  T26 Pareto validation.
- Added direct raw PPA Pareto figures after review feedback that the current
  visualizations were not straightforward enough:
  `figures/t30_holdout_ppa_pareto_area_power_candidate_zoom.png` uses raw area
  and power with no inverted axes, and
  `figures/t30_holdout_ppa_pareto_area_power.png` adds the reference star for
  context.
- Visual inspection accepted the new candidate-zoom raw PPA Pareto plot as the
  primary front figure. The reference-star plot is useful context, but it
  stretches the y-axis on P150 and P135.
- Aggregate read: T26 valid PPA samples drop from 103 to 68, final-best
  covered problems tie at 3, mean final-best score improves by 9.91%, mean
  normalized HV rises from 0 to 0.066206, candidate-level front points tie at
  3, unique PPA points drop from 11 to 8, and front netlists drop from 9 to 6.
- Per-problem warning: P098 valid PPA samples drop from 31 to 15, which is
  just below the 50% per-design validity threshold if interpreted per problem.
- Tier read: `T1 near-classic` holdout support with a yield warning, not a
  T2/T3 QD-front win.
- Validation: `/workspace/.venv/bin/pytest` passed for
  `tests/scripts/test_package_t30_holdout_front_audit.py`; `/workspace/.venv/bin/ruff`
  passed for the packager and test; `git diff --check` passed; pyright
  reported only unresolved `matplotlib` imports, matching the existing
  plotting-script environment noise.
- Lane decision: keep T26 as the champion exploitation comparator, but specify
  T31 as a repair/yield/front-preserving emitter. Do not keep blindly
  interpolating T24/T26 scheduler knobs.

## T31 SR Raw Fail-Feedback Repair QD Pre-Registration - 2026-06-22 UTC

- Created `techniques/T31_sr_raw_fail_feedback_repair_qd/` as the next
  archive-coupling package after T30.
- T31 targets the T30 P098 warning directly: exact T26 had 15 valid PPA
  samples on P098 versus classic's 31, and T26 did not broaden front/netlist
  evidence on the holdout.
- T31 keeps the T26/T30 SR raw descriptor, `grid_quantile` archive,
  `pareto_front` cells, `qd_max_elites_per_cell=5`, NSGA-II parent selection,
  `qd_champion_lane_fraction=0.80`, `qd_two_parent_probability=0.00`,
  `qd_fill_target_fraction=0.25`, and
  `qd_improve_backfill_fraction=0.20`.
- T31 changes the code-generation emitter to code-individual
  `single_thought_operator` with one-parent success sampling and
  `qd_operator_fail_feedback_chars=1200`, so fail-pool parents expose the
  failed stage and evaluator feedback to the LLM.
- T31 deliberately does not use `thought_only` or bounded local repair attempts
  in the first run. Prior journal-revamp evidence says thought-only/k-code
  variants can improve pass rate while losing PPA quality; T31 is therefore a
  same-offspring-budget repair/yield probe before any expanded-budget repair
  loop.
- Reuses the frozen T30 VerilogEval holdout problems and T30 classic/T26 roots
  as comparators. The only new planned run is the T31 arm under
  `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_<RUN_TS>/`.
- Added methodology, command, holdout subset YAML, run matrix, pending
  artifact manifest, pending result report, figure requirements, visualization
  placeholder, and central lane/index updates before execution.

## Direct Raw PPA Pareto Figure Gate Tightening - 2026-06-22 UTC

- Clarified the visualization policy after reviewing the current figure set.
  A completed technique package now explicitly requires a standalone raw
  area-power PPA Pareto-front PNG with conventional non-inverted axes and
  lower-left marked as better.
- Normalized PPA plots, BD/archive heatmaps, and HTML viewers are supporting
  views only; they do not satisfy the primary PPA-front visualization gate.
- Updated T31's methodology, results placeholder, figure checklist, and
  visualization notes so the next live package cannot be accepted without this
  straightforward PPA Pareto view.

## T31 SR Raw Fail-Feedback Repair QD Live Result - 2026-06-22 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed the T31 holdout run under
  `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/`.
  Runtime was 681.97 seconds.
- T31 final-best scores:
  `Prob150_review2015_fsmonehot` 0.329686,
  `Prob098_circuit7` 0.012006, and
  `Prob135_m2014_q6b` 0.263617.
- Pareto archive validation passed structurally for the T31 holdout arm:
  valid `True`, failure count `0`, problem-invalid count `0`, and max front
  size seen `2`.
- Added `scripts/package_t31_holdout_repair_audit.py` and
  `tests/scripts/test_package_t31_holdout_repair_audit.py`; refactored the T30
  packager to allow a reusable output prefix and figure title.
- Packaged T31 tables for live metrics, T31/T26-vs-classic deltas, canonical
  RTL/netlist/family accounting, method manifest, vLLM preflight metadata, and
  T31 Pareto validation.
- Added direct raw PPA Pareto figures:
  `figures/t31_holdout_ppa_pareto_area_power_candidate_zoom.png` uses raw area
  and power with no inverted axes, and
  `figures/t31_holdout_ppa_pareto_area_power.png` adds reference stars.
- Visual inspection accepted the candidate-zoom raw PPA Pareto plot as the
  primary front figure. It shows no meaningful front widening and makes the
  P135 quality/HV loss visible.
- Aggregate read: T31 valid PPA samples drop to 56 versus classic's 103 and
  T26's 68, final-best covered problems remain 3, mean final-best score drops
  to 0.201770, mean normalized HV and HV-AUC are both 0, candidate-level front
  points tie at 3, unique PPA points drop to 6, and front netlists tie T26 at
  6 while remaining below classic's 9.
- Per-problem warning: P098 valid PPA is 14, worse than T26's already weak 15
  and far below classic's 31. P150 valid PPA is 13 versus classic's 32, which
  triggers the per-problem 50% drop warning. P135 valid PPA improves slightly
  versus T26, but the final-best score and HV signal regress.
- Tier read: `T0 diagnostic`. T31 preserves final-best coverage, but it fails
  the intended P098 repair target and loses T26's P135 quality/HV signal.
- Lane decision: retire direct same-budget fail-feedback repair as the next
  T26 follow-up. The next method card should split champion exploitation,
  near-front sampling, and bounded repair into separate emitter roles.

## T32 SR Raw Front-Preserving Emitter QD Pre-Registration - 2026-06-22 UTC

- Created `techniques/T32_sr_raw_front_preserving_emitter_qd/` as the next
  archive-coupling package after the negative T31 holdout result.
- T32 keeps the T26/T30 SR raw descriptor, `grid_quantile` archive,
  `pareto_front` cells, `qd_max_elites_per_cell=5`, NSGA-II parent selection,
  `qd_fill_target_fraction=0.25`, `qd_improve_backfill_fraction=0.20`,
  `representation_kind=code_individual`, `repair_kind=none`, and
  `qd_operator_kind=eoh_strategies`.
- T32 lowers `qd_champion_lane_fraction` from T26/T31's `0.80` to `0.72` and
  adds `qd_two_parent_probability=0.08`. This is intentionally smaller than
  failed T29's `0.20` two-parent lane and less disruptive than T29's `0.60`
  champion setting.
- T32 removes T31's direct fail-feedback text and does not add an expanded
  repair loop. The test is whether a small success-parent near-front lane can
  recover yield or front breadth while preserving T26's P135 quality/HV signal.
- Registered T32 in the technique index, lane map, lineage ledger, current
  results matrix, idea backlog, plan, and todo before execution.
- Tightened the T32 artifact gate around straightforward raw area-power PPA
  Pareto figures. The package must include the primary candidate-only raw
  Pareto plot, reference-context raw plot if useful, visual inspection notes,
  and a candidate-level raw PPA/front table that can regenerate the figures.

## T32 SR Raw Front-Preserving Emitter QD Live Result - 2026-06-22 UTC

- Re-preflighted `http://20.0.0.103:8000/v1/models`; the endpoint returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Completed the T32 holdout run under
  `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/`.
  Runtime was 651.99 seconds.
- T32 final-best scores:
  `Prob150_review2015_fsmonehot` 0.329686,
  `Prob098_circuit7` 0.012006, and
  `Prob135_m2014_q6b` 0.263617.
- Pareto archive validation passed structurally for the T32 holdout arm:
  valid `True`, failure count `0`, problem-invalid count `0`, and max front
  size seen `3`.
- Added `scripts/package_t32_front_preserving_emitter_audit.py` and
  `tests/scripts/test_package_t32_front_preserving_emitter_audit.py`; updated
  the shared T30 holdout count plot to use dynamic grouped-bar widths so the
  four-arm T32 comparison is readable.
- Packaged T32 tables for live metrics, T32/T31/T26-vs-classic deltas,
  canonical RTL/netlist/family accounting, method manifest, vLLM preflight
  metadata, and T32 Pareto validation.
- Added direct raw PPA Pareto figures:
  `figures/t32_holdout_ppa_pareto_area_power_candidate_zoom.png` uses raw area
  and power with no inverted axes, and
  `figures/t32_holdout_ppa_pareto_area_power.png` adds reference stars.
- Visual inspection accepted the candidate-zoom raw PPA Pareto plot as the
  primary front figure. It shows T32 mostly overlaps T31 and does not recover
  T26's P135 low-area/low-power point.
- Aggregate read: T32 valid PPA is 67 versus classic's 103, T26's 68, and
  T31's 56. Mean final-best score is 0.201770, matching T31 and below T26's
  0.246463. Mean HV and HV-AUC are both 0. Total front points tie at 3.
  Unique PPA points improve to 9 versus T26's 8 and T31's 6, but remain below
  classic's 11.
- Per-problem read: P098 valid PPA improves to 19 versus T26's 15 and T31's
  14, but remains below classic's 31. P135 valid PPA improves to 31, but
  reference-beating count is 0 and final-best score stays at T31's weaker
  0.263617.
- Tier read: `T0 diagnostic`. T32 is a useful P098-yield hint, but it fails
  the primary requirement to preserve T26's P135 quality/HV signal and does
  not visibly widen the useful raw PPA Pareto front.
- Lane decision: stop simple champion-fraction/two-parent-probability tuning
  as the next T26 follow-up. A same-family follow-up needs stronger
  role-separated champion, local-rank-1/front-preserving, and bounded-repair
  lanes, or the push should branch to another descriptor family.

## PPA Viewer Raw Area-Power Front Refresh - 2026-06-22 UTC

- User feedback identified a visualization gap: the Phase 03.1 HTML viewer
  exposed archive/PPA distribution views, but did not make a straightforward
  raw area-power Pareto-front projection obvious.
- Added a `raw A-P front` PPA pane mode to
  `src/revolution/qd/ppa_visualization_viewer.py`. The mode uses raw area on
  x, raw power on y, conventional non-inverted axes, a lower-left-better
  annotation, and per-technique raw area-power nondominated front outlines.
- The native PPA mode remains available. For sequential problems, the raw
  A-P mode explicitly states that clock period is omitted from the 2D
  projection, while native mode keeps the 3D area/period/power view.
- Tightened `scripts/validate_qd_ppa_visualization.py` so static validation
  requires the raw A-P front controls, debug hook, and scene metadata. The
  Playwright smoke also checks and screenshots the new mode when run.
- Regenerated the T28 scoped viewer at
  `techniques/T28_t26_family_audit/visualizations/qd_ppa_viewer/index.html`
  and added
  `screenshots/raw_area_power_front.png` as an inspected reader-facing
  screenshot.
- Validation run:
  `uv run pytest tests/revolution/test_ppa_visualization_export.py tests/scripts/test_qd_ppa_visualization_scripts.py`,
  `uv run ruff check ...`,
  `uv run python -m pyright ...`,
  `uv tool run ty check ...`, and static viewer validation for the T28
  bundle all passed.

## T33 Qwen3 Preprocessing Ladder Registration - 2026-06-22 UTC

- Registered `T33_qwen3_preprocessing_ladder_bd` as the next L4 learned-encoder
  method after T06. The method directly targets T06's failure mode: Qwen
  embeddings carried HV signal, but nearest neighbors were dominated by
  same-problem and same-corpus clustering.
- The package fixes six PPA-free views before running: raw RTL, commentless RTL,
  identifier-role RTL, canonical RTL, canonical Yosys netlist, and
  summary-plus-netlist.
- The default embedding policy chunks at stable RTL/netlist boundaries,
  L2-normalizes chunk embeddings, and pools by square-root token weighted mean,
  with plain mean and cell-count pooling as ablations.
- Promotion gates require beating lexical or random controls on a claimed
  QD/Pareto metric, lowering T06's `0.9336` same-problem nearest-neighbor
  fraction, avoiding worse duplicate collapse, and preserving classic-covered
  designs in any live run.
- T33 output is explicitly routed to `exp/useful_bd_push/`; `/aux` remains
  read-only retrospective evidence. If dependencies block the repo uv
  environment, the method must try an isolated uv environment under
  `exp/useful_bd_push/envs/` before stopping.

## T33a Source Inventory - 2026-06-22 UTC

- Added `scripts/package_t33_qwen_ladder_inventory.py` and a focused test to
  package T33 source inputs before new embeddings are generated.
- Ran the packager against
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC` and the
  committed 20260621 Qwen bundle. It wrote:
  `tables/t33_source_inventory.csv`,
  `tables/t33_prior_qwen_summary.csv`, and
  `tables/t33_preprocessing_ladder_plan.csv`.
- The source inventory records 15 artifacts with bytes and SHA256 hashes. The
  summary table fixes the T06 facts T33 must beat or explain: 768 candidates,
  127 problems, `768x1024` prior Qwen embeddings, same-problem nearest-neighbor
  fraction `0.93359375`, and identifier-Qwen HV gain `0.033499553667026144`
  versus lexical.
- Validation run:
  `uv run pytest tests/scripts/test_package_t33_qwen_ladder_inventory.py`,
  `uv run ruff check scripts/package_t33_qwen_ladder_inventory.py tests/scripts/test_package_t33_qwen_ladder_inventory.py`,
  `uv run python -m pyright scripts/package_t33_qwen_ladder_inventory.py tests/scripts/test_package_t33_qwen_ladder_inventory.py`,
  and
  `uv tool run ty check scripts/package_t33_qwen_ladder_inventory.py tests/scripts/test_package_t33_qwen_ladder_inventory.py`
  all passed.

## T33b Preprocessing View Cache - 2026-06-22 UTC

- Added `scripts/generate_t33_qwen_preprocessing_views.py` and a focused test.
  The script reads the T06 candidate table, asserts every RTL and netlist path
  exists, writes generated view files under `exp/useful_bd_push/`, and commits
  only compact manifests under the T33 package.
- Fixed a preprocessing bug during sample inspection: tokens immediately after
  a Verilog literal apostrophe must be preserved, so `2'b00` does not become
  `2'tmp_...` during identifier normalization.
- Generated `4608` view files for 768 candidates under
  `exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC`.
  The committed cache manifest records the source candidate-table SHA256
  `f529204adff4a66aa2d9977f087eea41c5292397cac2815b78ef4723be850b0e`.
- Committed setup tables:
  `tables/t33_preprocessing_cache_manifest.csv`,
  `tables/t33_preprocessing_view_manifest.csv`, and
  `tables/t33_preprocessing_view_summary.csv`.
- View-size summary: mean RTL views range from 561.63 to 783.17 characters,
  while canonical netlist and summary-plus-netlist views average about
  22.7k and 23.1k characters. The next embedding stage must therefore chunk
  netlist views rather than treat them as single short strings.
- Validation run:
  `uv run pytest tests/scripts/test_generate_t33_qwen_preprocessing_views.py`,
  `uv run ruff check scripts/generate_t33_qwen_preprocessing_views.py tests/scripts/test_generate_t33_qwen_preprocessing_views.py`,
  `uv run python -m pyright scripts/generate_t33_qwen_preprocessing_views.py tests/scripts/test_generate_t33_qwen_preprocessing_views.py`,
  and
  `uv tool run ty check scripts/generate_t33_qwen_preprocessing_views.py tests/scripts/test_generate_t33_qwen_preprocessing_views.py`
  all passed.

## T33c Qwen Embedding Cache - 2026-06-22 UTC

- Checked the repo uv environment first. It lacked `sentence_transformers`,
  `torch`, and `sklearn`, so T33c reused the existing isolated Qwen env at
  `exp/diversity_check/encoder_envs/qwen3_probe` rather than modifying the
  repo dependency stack.
- The isolated env reported `sentence_transformers 5.6.0`,
  `torch 2.6.0+cu124`, `sklearn 1.9.0`, CUDA available, and an NVIDIA RTX
  A6000 device. The Qwen model cache already contained
  `Qwen/Qwen3-Embedding-0.6B`.
- Added `scripts/embed_t33_qwen_preprocessing_views.py` and a focused fake
  embedder test. The script chunks long view text at 4096 characters,
  embeds chunks, L2-normalizes through the model, and pools by square-root word
  count before writing one `768x1024` matrix per view.
- Ran the real embedding command with batch size 32. All six views completed:
  canonical RTL 768 chunks, raw/commentless/identifier RTL 773 to 777 chunks,
  canonical Yosys netlist 4738 chunks, and summary-plus-netlist 4765 chunks.
- Embedding matrices are stored under
  `exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC/embeddings/`.
  The committed manifest records each `.npy` SHA256 and encode time.
- Verified all six `.npy` files have shape `(768, 1024)`, dtype `float32`, and
  unit-norm first rows. This validates cache generation only; collapse and
  replay diagnostics still decide whether T33 has useful BD signal.
- Validation run:
  `uv run pytest tests/scripts/test_embed_t33_qwen_preprocessing_views.py`,
  `uv run ruff check scripts/embed_t33_qwen_preprocessing_views.py tests/scripts/test_embed_t33_qwen_preprocessing_views.py`,
  `uv run python -m pyright scripts/embed_t33_qwen_preprocessing_views.py tests/scripts/test_embed_t33_qwen_preprocessing_views.py`,
  and
  `uv tool run ty check scripts/embed_t33_qwen_preprocessing_views.py tests/scripts/test_embed_t33_qwen_preprocessing_views.py`
  all passed.

## T33d Qwen Collapse Diagnostics - 2026-06-22 UTC

- Added `scripts/analyze_t33_qwen_embedding_diagnostics.py` and a focused
  test. The script computes nearest-neighbor cosine, same-problem/corpus/hash
  fractions, and pairwise view-stability cosines over the six T33 embedding
  matrices.
- Ran diagnostics against the T33c embedding manifest, T33b view manifest, and
  T06 candidate table. It wrote `tables/t33_collapse_diagnostics.csv`,
  `tables/t33_nearest_neighbors.csv`, and `tables/t33_view_stability.csv`.
- Main signal: preprocessing helped only for netlist-style views. T06
  same-problem nearest fraction was `0.93359375`; T33 canonical Yosys netlist
  drops it to `0.738281250`, summary-plus-netlist drops it to `0.816406250`,
  canonical RTL drops it to `0.894531250`, and raw/commentless RTL do not
  improve it.
- Same-corpus fraction also improves most for canonical Yosys netlist:
  `0.822916667` versus T06's `0.9479166666666666`.
- Interpretation: this is a meaningful L4 preprocessing signal, not yet a
  useful-BD claim. The next step must test replay/PPA-front metrics against
  lexical and random controls, especially for `canonical_yosys_netlist`.
- Validation run:
  `uv run pytest tests/scripts/test_analyze_t33_qwen_embedding_diagnostics.py`,
  `uv run ruff check scripts/analyze_t33_qwen_embedding_diagnostics.py tests/scripts/test_analyze_t33_qwen_embedding_diagnostics.py`,
  `uv run python -m pyright scripts/analyze_t33_qwen_embedding_diagnostics.py tests/scripts/test_analyze_t33_qwen_embedding_diagnostics.py`,
  and
  `uv tool run ty check scripts/analyze_t33_qwen_embedding_diagnostics.py tests/scripts/test_analyze_t33_qwen_embedding_diagnostics.py`
  all passed.

## T33e Qwen Replay And Direct PPA Fronts - 2026-06-22 UTC

- Added `scripts/analyze_t33_qwen_replay.py` and a focused test. The script
  replays lexical farthest-first, random, generation-prefix, fitness-top, and
  six T33 Qwen descriptor matrices under the same `0.5` retention fraction as
  the T06 common audit.
- The script writes `tables/t33_replay_rows.csv`,
  `tables/t33_replay_aggregate.csv`, `tables/t33_selected_candidates.csv`,
  `tables/t33_ppa_front_metrics.csv`, and
  `tables/t33_qwen_ladder_vs_controls.csv`.
- The primary figure is now a direct raw area-power PPA front:
  `figures/t33_raw_area_power_pareto_front.png`. It has full-range and
  lower-left zoom panels for `Prob018_float_multi`, the richest valid-PPA
  representative group selected by unique PPA/front richness.
- Main result: canonical RTL and identifier-role RTL each improve selected HV
  versus lexical by about `+2.63%`; commentless RTL improves by `+1.91%`.
  Canonical Yosys netlist, the best collapse-diagnostic view, loses `-3.34%`
  selected HV versus lexical, and summary-plus-netlist loses `-0.43%`.
- Direct PPA-front accounting does not promote T33: commentless RTL has `123`
  unique all-valid front hits, lexical and fitness-top have `122`, summary
  plus netlist has `121`, canonical RTL and identifier-role RTL have `120`,
  and canonical Yosys netlist has `119`. Netlist views increase unique netlist
  and motif counts, but not HV or direct front hits.
- Tier decision: `T0 diagnostic`. Do not promote direct Qwen whole-design
  farthest-first. Follow up only with a small projection/head or hybrid
  ablation that combines the RTL-view HV source with an explicit
  anti-problem/corpus objective learned from the netlist collapse diagnostic.
- Visual inspection passed for the direct PPA front, hypervolume bar chart, and
  uniqueness bar chart; notes are in
  `techniques/T33_qwen3_preprocessing_ladder_bd/figures/visual_inspection_notes.md`.
- Validation run:
  `uv run pytest tests/scripts/test_package_t33_qwen_ladder_inventory.py tests/scripts/test_generate_t33_qwen_preprocessing_views.py tests/scripts/test_embed_t33_qwen_preprocessing_views.py tests/scripts/test_analyze_t33_qwen_embedding_diagnostics.py tests/scripts/test_analyze_t33_qwen_replay.py`,
  `uv run ruff check` over the T33 scripts/tests,
  `uv run python -m pyright` over the T33 scripts/tests,
  `uv tool run ty check` over the T33 scripts/tests, and `git diff --check`
  all passed.

## T34 Qwen PCA-Residual Registration - 2026-06-22 UTC

- Registered `T34_qwen_pca_residual_bd` as the bounded L4 follow-up to T33.
- Method: remove the first `k` principal components from selected T33 Qwen
  embedding views, L2-normalize the residuals, and replay farthest-first
  selection against lexical, random, generation-prefix, fitness-top, and T33
  base-view controls.
- Leakage rule: PCA fitting uses embedding coordinates only. It does not use
  final PPA, reference PPA, fitness, hypervolume, Pareto rank, validity labels,
  problem id, or corpus id. Problem/corpus labels are reserved for post-replay
  collapse diagnostics.
- Motivation: T33 found that RTL views carry modest HV signal while netlist
  views reduce nuisance clustering. T34 tests whether a label-free residual
  projection can keep the RTL signal while suppressing dominant nuisance axes.
- Next command is documented in
  `techniques/T34_qwen_pca_residual_bd/commands/replay_v0.md`.

## T34 Qwen PCA-Residual Replay - 2026-06-22 UTC

- Added `scripts/analyze_t34_qwen_pca_residual.py` and a focused unit test.
  The script builds label-free PCA residual descriptors from T33 Qwen views,
  replays farthest-first selection, computes collapse diagnostics, and writes
  direct raw PPA-front figures.
- Ran the documented replay command against the T33 embedding manifest and the
  T06/T33 common 768-candidate replay surface.
- Main result: T34 does not produce a promoted descriptor. The best residuals
  tie T33 canonical RTL HV at `3.799167` (`+2.63%` versus lexical), but their
  same-problem nearest-neighbor fractions remain high: `0.895833` to
  `0.911458` for the best canonical/identifier RTL residuals.
- Lower-collapse residuals are netlist-derived and do not solve utility:
  `t34_summary_plus_netlist_pc4_residual` reaches same-problem fraction
  `0.805990` but drops selected HV to `3.570861`, below lexical.
- Direct PPA-front accounting is also not decisive. The best residual front
  hit count is `123`, matching T33 commentless RTL and only one unique front
  hit above lexical's `122`.
- Tier decision: `T0 diagnostic`. Stop label-free whole-design Qwen projection
  variants unless the training objective changes. The L4 lane should move to
  graph encoders or a genuine contrastive/fine-tuning objective.
- Visual inspection passed for `t34_raw_area_power_pareto_front.png`,
  `t34_hypervolume_by_projection.png`, and
  `t34_collapse_vs_hypervolume.png`; notes are in
  `techniques/T34_qwen_pca_residual_bd/figures/visual_inspection_notes.md`.
- Validation run:
  `uv run pytest tests/scripts/test_analyze_t34_qwen_pca_residual.py`,
  `uv run ruff check scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py`,
  `uv run python -m pyright scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py`,
  and
  `uv tool run ty check scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py`
  all passed before the real replay and again after the report artifacts were
  generated. `git diff --check` also passed.

## T07 DeepGate-Family Graph-Surrogate Replay - 2026-06-22 UTC

- Revisited the DeepGate-family lane after T34 closed the bounded label-free
  Qwen residual path. Prior DeepGate3 probes were not enough for a full replay:
  the AIG probe had 9 exports, 6 latch-free parses, and 3 latch-bearing
  rejects; the tokenizer embedding probe had pairwise cosine mean
  `0.999970734`, which is too collapsed for a useful descriptor.
- Checked the existing isolated environment evidence. It can import
  `deepgate 2.0.1` and `torch`, but not `deepgate3` or `dgl`. Instead of
  stopping, T07 used a standard-cell graph surrogate over all 768 synthesized
  netlists from the T33/T34 common candidate surface.
- Added `scripts/analyze_t07_deepgate_surrogate.py` and a focused test. The
  script parses mapped cell instances, builds directed producer-consumer cell
  graphs, extracts WL-hashed graph features and graph statistics, replays
  farthest-first retention at 50%, computes PPA/front/collapse diagnostics,
  and writes direct raw PPA-front figures.
- Ran the replay command:
  `uv run python scripts/analyze_t07_deepgate_surrogate.py --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd --retention-fraction 0.5 --random-seed 0`.
- Primary result: `t07_graph_wl_farthest` and
  `t07_graph_combo_farthest` both select HV `3.704413`, a `+0.07%` gain over
  lexical (`3.701827`) and far above random (`3.074167`). They improve unique
  PPA points from lexical's `183` to `185` and keep the same best fitness as
  `fitness_top`.
- Front evidence blocks a stronger claim. Lexical has `122` selected all-valid
  front hits, while graph WL/combo have `120`. Graph WL has `126` area-power
  front points and graph combo has `125`, versus lexical's `127`.
- Collapse diagnostics are better than the Qwen whole-design pattern but not
  sufficient alone: graph WL nearest-neighbor same-problem fraction is
  `0.635417`, same-corpus fraction is `0.761719`, same-netlist fraction is
  `0.694010`, and same-motif fraction is `0.723958`.
- Added a new straightforward multi-problem raw area-power PPA-front figure:
  `techniques/T07_deepgate_family_bd/figures/deepgate_multi_problem_ppa_pareto_fronts.png`.
  It overlays all-valid, lexical, random, and graph-combo selections on
  conventional lower-left-better axes. The plotted data are committed in
  `tables/ppa_front_plot_points.csv`.
- Visual inspection passed for the multi-problem raw PPA-front figure, the
  one-problem raw PPA-front zoom, hypervolume bar chart, graph projection, and
  graph-size diagnostic. Notes are in
  `techniques/T07_deepgate_family_bd/figures/visual_inspection_notes.md`.
- Tier decision: `T1 near_classic_replay_lead`, not a promoted useful-BD win.
  T07 is worth advancing to a true DeepGate/AIG dependency path or contrastive
  graph encoder, but this exact surrogate should not consume live budget alone.
- Validation run:
  `uv run pytest tests/scripts/test_analyze_t07_deepgate_surrogate.py`,
  `uv run ruff check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`,
  `uv run python -m pyright scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`,
  and
  `uv tool run ty check scripts/analyze_t07_deepgate_surrogate.py tests/scripts/test_analyze_t07_deepgate_surrogate.py`
  all passed after adding the direct PPA-front outputs.

## T13 AURORA-Style Implementation Replay - 2026-06-22 UTC

- Added `scripts/analyze_t13_aurora_autoencoder.py` and a focused test. The
  script combines RTL count features with T07's parsed standard-cell graph
  manifest, fits PCA, RFF-PCA, and incremental PCA bottlenecks, and replays
  farthest-first retention on the same 768-candidate common surface.
- Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
  Pareto labels, validity labels, problem id, corpus, model, method, seed, and
  candidate id. The committed `tables/feature_manifest.csv` records the 36
  structural input features.
- Ran the replay command:
  `uv run python scripts/analyze_t13_aurora_autoencoder.py --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T13_aurora_incremental_autoencoder_bd --retention-fraction 0.5 --random-seed 0 --latent-dims 2 4 8`.
- Main result: raw implementation features (`t13_impl_z_farthest`) select HV
  `3.740943`, a `+1.06%` gain over lexical (`3.701827`) and a stronger L4
  replay lead than T07's graph WL/combo `+0.07%`. Unique PPA points improve
  from lexical's `183` to `186`, and selected area-power front points improve
  from `127` to `129`.
- Promotion blocker: front hits still do not improve. Lexical has `122`
  selected all-valid front hits; raw implementation features have `120`.
- Compression result: the AURORA-style PCA/RFF/incremental bottlenecks are
  negative on HV. PCA-4 loses `2.06%`, incremental PCA-4 loses `6.05%`, and
  RFF-PCA variants lose `5.67%` to `8.57%` versus lexical.
- Collapse diagnostics explain the tradeoff. RFF-PCA reduces same-problem and
  same-corpus nearest-neighbor collapse, but the lower-collapse bottlenecks
  lose HV. The raw feature space keeps high same-problem collapse (`0.867188`)
  but carries the useful HV signal.
- Added the primary raw PPA-front figure:
  `techniques/T13_aurora_incremental_autoencoder_bd/figures/aurora_multi_problem_ppa_pareto_fronts.png`.
  The source points are in `tables/ppa_front_plot_points.csv`.
- Tier decision: mixed. The package is `T1 near_classic_replay_lead` for the
  raw implementation-feature input space and `T0 diagnostic` for compressed
  bottlenecks. Next L4 work should use feature selection, local-Pareto
  coupling, or contrastive graph training rather than another plain
  unsupervised bottleneck.
- Final validation run:
  `uv run pytest tests/scripts/test_analyze_t13_aurora_autoencoder.py`,
  `uv run ruff check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`,
  `uv run python -m pyright scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`,
  and
  `uv tool run ty check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`
  all passed. `git diff --check` passed.
- Re-ran the real replay with the final script after the focused checks. The
  table and figure hashes stayed stable; the final code hash is recorded in
  `techniques/T13_aurora_incremental_autoencoder_bd/artifacts_manifest.md`.

## T14 DE-HNN-Style Hypergraph Replay - 2026-06-22 UTC

- Added `scripts/analyze_t14_dehnn_hypergraph.py` and a focused test. The
  script parses mapped netlists into directed hyperedges from driver cells or
  primary inputs to sink cells or primary outputs, then replays hypergraph
  farthest-first descriptors on the same 768-candidate common surface.
- Descriptor construction excludes final PPA, reference PPA, fitness,
  hypervolume, Pareto labels, validity labels, problem id, corpus, model,
  method, seed, and candidate id. The T14 hybrid uses the same T13
  implementation-feature schema plus hypergraph incidence features.
- Ran the replay command:
  `uv run python scripts/analyze_t14_dehnn_hypergraph.py --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd --retention-fraction 0.5 --random-seed 0`.
- Extraction result: all `768` candidates parsed, all had cells and
  hyperedges, and `647` had directed source-to-sink cell edges.
- Main result: `t14_hyper_impl_combo_farthest` selects HV `3.739236`, a
  `+1.01%` gain over lexical (`3.701827`). Unique PPA points improve to `187`,
  compared with lexical's `183` and T13's `186`.
- Hypergraph-only descriptors are not enough. `t14_hyper_hash_farthest` and
  `t14_hyper_combo_farthest` select HV `3.624054`, about `-2.10%` versus
  lexical, despite improving selected Pareto size and unique PPA counts.
- Promotion blocker: direct front hits remain below lexical. Lexical has
  `122` selected all-valid front hits; the T14 hybrid has `119`.
- Collapse diagnostics explain the hybrid tradeoff. Hypergraph hash reduces
  same-problem nearest-neighbor collapse to `0.690104`, but the high-HV hybrid
  restores T13-like same-problem collapse at `0.867188`.
- Added the primary raw PPA-front figure:
  `techniques/T14_dehnn_hypergraph_bd/figures/hypergraph_multi_problem_ppa_pareto_fronts.png`.
  The source points are in `tables/ppa_front_plot_points.csv`.
- Tier decision: mixed. The package is `T1 near_classic_replay_lead` for the
  hypergraph plus implementation-feature hybrid and `T0 diagnostic` for
  hypergraph-only descriptors. The next L4 method should target front-hit
  retention with feature selection or contrastive training, not more blind
  concatenation.
- Final validation run:
  `uv run pytest tests/scripts/test_analyze_t14_dehnn_hypergraph.py`,
  `uv run ruff check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`,
  `uv run python -m pyright scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`,
  and
  `uv tool run ty check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`
  all passed. `git diff --check` passed.
- Re-ran the real replay with the final script after the focused checks. The
  table and figure hashes stayed stable; the final code hash is recorded in
  `techniques/T14_dehnn_hypergraph_bd/artifacts_manifest.md`.

## T11 MGVGA-Style Contrastive Replay - 2026-06-22 UTC

- Added `scripts/analyze_t11_mgvga_contrastive.py` and a focused test. The
  bounded replay approximates MGVGA-style source/graph alignment by scoring
  structural features from T13 implementation vectors, T07 graph features, and
  T14 hypergraph features with self-supervised canonical-netlist/motif
  duplicate keys.
- Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
  Pareto labels, validity labels, problem id, corpus, model, method, seed, and
  candidate id. Rows without canonical-netlist or motif keys are treated as
  unique unlabeled examples, not positive pairs.
- Ran the replay command:
  `uv run python scripts/analyze_t11_mgvga_contrastive.py --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T11_mgvga_contrastive_bd --retention-fraction 0.5 --random-seed 0`.
- Alignment coverage: `768` candidate rows, `658` unique structural keys,
  `153` duplicate-key rows, `521` rows missing structural labels, `271`
  positive pairs, and `294257` negative pairs.
- Main result: `t11_contrast_top64_farthest` and
  `t11_contrast_weighted_farthest` select HV `3.769259`, a `+1.82%` gain over
  lexical (`3.701827`). Unique PPA improves to `186`, matching T13 and below
  T14's `187`.
- Promotion blocker: direct front hits remain below lexical. T11 keeps `120`
  selected all-valid front hits versus lexical's `122`. This recovers one hit
  versus the best T14 hybrid (`119`) but is not enough for promotion.
- Added primary raw PPA-front figures:
  `techniques/T11_mgvga_contrastive_bd/figures/mgvga_multi_problem_ppa_pareto_fronts.png`
  and
  `techniques/T11_mgvga_contrastive_bd/figures/mgvga_raw_area_power_pareto_front.png`.
  The source table is `tables/ppa_front_plot_points.csv`.
- Added the direct raw PPA HTML viewer:
  `techniques/T11_mgvga_contrastive_bd/visualizations/direct_ppa_pareto/index.html`.
  Playwright rendered it and saved
  `visualizations/direct_ppa_pareto/screenshot.png`; the summary cards show
  T11 front hits `120` versus lexical `122`.
- Tier decision: `T1 near_classic_replay_lead`, not promoted. T11 is now the
  best L4 HV replay lead, but it still needs local-Pareto coupling or a
  collapse-penalized contrastive objective before live-budget use.
- Final focused validation run:
  `uv run pytest tests/scripts/test_analyze_t11_mgvga_contrastive.py` and
  `uv run ruff check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`,
  `uv run python -m pyright scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`,
  and
  `uv tool run ty check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`
  passed before the final real replay was regenerated.

## T35 T11 Pareto-Coupled Replay - 2026-06-22 UTC

- Added `scripts/analyze_t35_t11_pareto_coupling.py` and a focused test. The
  replay keeps T11 structural contrastive features from RTL counts, T07 graph
  features, and T14 hypergraph features, then tests descriptor-cell local
  area-power Pareto retention.
- Descriptor fitting excludes final PPA, reference PPA, fitness,
  hypervolume, Pareto labels, validity labels, problem id, corpus, model,
  method, seed, and candidate id. PPA is used only after candidate evaluation
  for archive-retention diagnostics.
- Ran the replay command recorded in
  `techniques/T35_t11_pareto_coupling_bd/commands/replay_v0.md` with the
  common Qwen audit candidate CSV, T07 graph manifest, T14 hypergraph feature
  table, `0.5` retention fraction, random seed `0`, and `2` bins per T11 PCA
  axis.
- Main deployable result: T35 cell-local Pareto retention improves direct
  front hits to `126`, compared with lexical's `122` and T11's `120`, but it
  loses too much selected HV: `3.369630`, or `-8.97%` versus lexical. Unique
  PPA also falls to `162`, below lexical's `183`.
- Upper-bound result: `t35_top64_front_seeded` reaches HV `3.864198`
  (`+4.39%` versus lexical) and `132` front hits. This is not deployable
  because it uses global raw area-power front membership directly; it only
  proves that the fixed candidate pool contains recoverable front material.
- Added primary raw PPA-front figures:
  `techniques/T35_t11_pareto_coupling_bd/figures/t35_multi_problem_ppa_pareto_fronts.png`
  and
  `techniques/T35_t11_pareto_coupling_bd/figures/t35_raw_area_power_pareto_front.png`.
  The plotted data are committed in `tables/ppa_front_plot_points.csv`.
- Added the direct raw PPA HTML viewer:
  `techniques/T35_t11_pareto_coupling_bd/visualizations/direct_ppa_pareto/index.html`.
  Playwright rendered it and saved
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Visual inspection passed for the multi-problem raw PPA front, raw
  area-power zoom, hypervolume bars, front-hit bars, and HTML viewer. Notes are
  in `techniques/T35_t11_pareto_coupling_bd/figures/visual_inspection_notes.md`.
- Tier decision: mixed `T0/T1 diagnostic`, not promoted. The cell-local
  Pareto arms are `T0` because the HV loss is too large. The front-seeded arm
  is useful upper-bound evidence only. The next T11-family attempt should keep
  the T11 farthest/HV selector and add a small bounded front lane rather than
  replacing descriptor novelty with local Pareto retention.
- Focused validation passed:
  `uv run pytest tests/scripts/test_analyze_t35_t11_pareto_coupling.py`,
  `uv run ruff check scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`,
  `uv run python -m pyright scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`,
  and
  `uv tool run ty check scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`.

## T36 T11 Bounded Front-Lane Replay - 2026-06-22 UTC

- Added `scripts/analyze_t36_t11_bounded_front_lane.py` and a focused test.
  The replay keeps T11 structural contrastive farthest-first retention for
  most slots and reserves a bounded descriptor-cell local-front lane.
- Pre-registered the method in
  `techniques/T36_t11_bounded_front_lane_bd/methodology.md` before the real
  replay. PPA is excluded from descriptor fitting and used only after
  candidate evaluation for the bounded archive-retention lane.
- Ran the replay command recorded in
  `techniques/T36_t11_bounded_front_lane_bd/commands/replay_v0.md` with the
  common Qwen audit candidate CSV, T07 graph manifest, T14 hypergraph feature
  table, `0.5` retention fraction, random seed `0`, and `2` bins per T11 PCA
  axis.
- Main result: every T36 quota arm maps to one front-lane slot under the
  current group sizes. That one-slot bounded lane selects HV `3.851344`,
  `+4.04%` versus lexical (`3.701827`) and above T11 (`3.769259`). Direct
  front hits improve to `126`, compared with lexical's `122` and T11's `120`.
- The result also beats `fitness_top` on HV (`3.851344` versus `3.823248`) and
  unique PPA (`180` versus `159`). It does not beat lexical/T11 on unique PPA:
  lexical has `183` and T11 has `186`.
- Tier decision: `T2 replay_candidate`, not final promotion. This is the
  strongest replay lead so far, but it still needs same-budget live validation
  or a slot-count ablation before a useful-BD claim.
- Added primary raw PPA-front figures:
  `techniques/T36_t11_bounded_front_lane_bd/figures/t36_multi_problem_ppa_pareto_fronts.png`
  and
  `techniques/T36_t11_bounded_front_lane_bd/figures/t36_raw_area_power_pareto_front.png`.
  The plotted data are committed in `tables/ppa_front_plot_points.csv`.
- Added the direct raw PPA HTML viewer:
  `techniques/T36_t11_bounded_front_lane_bd/visualizations/direct_ppa_pareto/index.html`.
  Playwright rendered it and saved
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Visual inspection passed for the multi-problem raw PPA front, raw
  area-power zoom, hypervolume bars, front-hit bars, and HTML viewer. Notes are
  in `techniques/T36_t11_bounded_front_lane_bd/figures/visual_inspection_notes.md`.
- Focused validation passed:
  `uv run pytest tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`,
  `uv run ruff check scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`,
  `uv run python -m pyright scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`,
  and
  `uv tool run ty check scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`.

## T37 T36 Slot-Count Ablation - 2026-06-22 UTC

- Added `scripts/analyze_t37_t36_slot_count_ablation.py` and a focused test.
  The replay turns the collapsed T36 quota question into explicit zero, one,
  two, and three local-front slot arms.
- Pre-registered the method in
  `techniques/T37_t36_slot_count_ablation/methodology.md` before the real
  replay. The descriptor remains the T11 structural contrastive descriptor; PPA
  is excluded from descriptor fitting and used only after candidate evaluation
  for archive-retention diagnostics.
- Ran the replay command recorded in
  `techniques/T37_t36_slot_count_ablation/commands/replay_v0.md` with the
  common Qwen audit candidate CSV, T07 graph manifest, T14 hypergraph feature
  table, `0.5` retention fraction, random seed `0`, and `2` bins per T11 PCA
  axis.
- Main result: slot zero reproduces T11 (`3.769259` HV, `120` front hits). One
  slot reproduces the T36 win (`3.851344` HV, `+4.04%` versus lexical, `126`
  front hits). Two or more slots lose too much HV (`3.369630`, `-8.97%` versus
  lexical), so wider local-front lanes are rejected.
- Tier decision: one-slot T37 remains `T2 replay_candidate`, not final
  promotion. The slot-count ablation answers the replay ambiguity and makes the
  next live target precise: exactly one bounded local-front slot.
- Added primary raw PPA-front figures:
  `techniques/T37_t36_slot_count_ablation/figures/t37_multi_problem_ppa_pareto_fronts.png`
  and
  `techniques/T37_t36_slot_count_ablation/figures/t37_raw_area_power_pareto_front.png`.
  The plotted data are committed in `tables/ppa_front_plot_points.csv`.
- Added the direct raw PPA HTML viewer:
  `techniques/T37_t36_slot_count_ablation/visualizations/direct_ppa_pareto/index.html`.
  Playwright rendered it and saved
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Visual inspection passed for the multi-problem raw PPA front, raw
  area-power zoom, hypervolume bars, front-hit bars, and HTML viewer. Notes are
  in
  `techniques/T37_t36_slot_count_ablation/figures/visual_inspection_notes.md`.
- Focused validation passed:
  `uv run pytest tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`,
  `uv run ruff check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`,
  `uv run python -m pyright scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`,
  and
  `uv tool run ty check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`.

## T38 Elite Pareto Slot Live Hook - 2026-06-22 UTC

- Pre-registered `techniques/T38_elite_pareto_slot_live_qd/` as the live
  archive-coupling follow-up to the T37 one-slot boundary.
- Added the `elite_pareto_slot` QD cell mode. Each occupied cell preserves the
  scalar quality champion and fills the remaining slots by local PPA Pareto
  rank and crowding distance. The planned T38 arm sets
  `--qd_max_elites_per_cell 2`, so the rule is champion plus one local Pareto
  slot.
- Wired the mode through the grid, grid-quantile, and CVT archives, engine
  parent sampling, `scripts/run_backend.py`, `scripts/run_backend_ablation.py`,
  and `scripts/validate_pareto_front_run.py`.
- Added focused archive and validator tests for the new mode.
- The T38 command card uses the existing live `journal_graph_testability_3d`
  runtime descriptor because exact T11/T37 structural-contrastive projection is
  still retrospective-only. If T38 is promising, the next follow-up is to add
  exact T11 runtime projection rather than overclaiming the descriptor result.
- No live result or tier is assigned yet. The next required artifact is the T38
  same-budget live screen with direct raw area-power PPA Pareto figures as the
  first visual gate.
- Focused validation passed:
  `uv run pytest tests/revolution/test_qd_archive.py tests/scripts/test_validate_pareto_front_run.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py`,
  `uv run ruff check src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/qd/types.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/validate_pareto_front_run.py tests/revolution/test_qd_archive.py tests/scripts/test_validate_pareto_front_run.py`,
  narrowed
  `uv run python -m pyright src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/qd/types.py scripts/run_backend_ablation.py scripts/validate_pareto_front_run.py tests/revolution/test_qd_archive.py tests/scripts/test_validate_pareto_front_run.py`,
  narrowed
  `uv tool run ty check src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/qd/types.py scripts/run_backend_ablation.py scripts/validate_pareto_front_run.py tests/revolution/test_qd_archive.py tests/scripts/test_validate_pareto_front_run.py`,
  and `git diff --check`.
- Full touched-file `pyright`/`ty` still report the pre-existing
  `scripts/run_backend.py` evaluator union mismatch at lines 305 and 339.
  This commit only changes the CLI `--qd_cell_mode` choices in that file.
- Ran a bounded one-problem smoke after the implementation commit:
  `RTLLM/Prob045_alu`, population `4`, generation `1`, full 128000 token caps,
  `grid_quantile`, `journal_graph_testability_3d`, and
  `elite_pareto_slot` with `max_elites_per_cell=2`.
- Smoke root:
  `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072. Runtime completed in 82 seconds and wrote archive artifacts with
  `cell_mode=elite_pareto_slot`.
- Smoke validator passed with `failure_count=0`, but
  `max_front_size_seen=0`, `occupied_cells=0`, and `total_archive_members=0`.
  The smoke generated 8 candidates but had zero functionality and synthesis-PPA
  successes, so it is a CLI/runtime contract check only and not a PPA-front
  result.
- Ran the full bounded T38 arm on the pre-registered three RTLLM screen
  problems with population `12`, generations `3`, seed `1001`, full 128000
  token caps, `grid_quantile`, `journal_graph_testability_3d`, and
  `elite_pareto_slot` with `max_elites_per_cell=2`.
- Full bounded-arm root:
  `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/elite_pareto_slot_qd/seed_1001/openai_gpt-oss-120b/`.
  Runtime completed in 771 seconds.
- Validator passed with `failure_count=0` and `max_front_size_seen=2`.
  Packaged direct PPA figures, candidate/front tables, validator output, and a
  simple HTML viewer under `techniques/T38_elite_pareto_slot_live_qd/`.
- Main measured result: `Prob045_alu` has 25 valid PPA, 2 local/global front
  points, and 19 active archive members. `Prob041_traffic_light` has 8 valid
  PPA, 2 local/global front points, and 7 active archive members.
  `Prob015_multi_pipe_8bit` has 7 valid PPA and 3 front points, but zero active
  archive members because the configured grid-quantile warmup threshold is 8.
- Tier decision: `T0 diagnostic`. The cell mode runs and produces usable direct
  PPA-front plots, but the current warmup policy fails the sparse-yield
  multi-pipe case. Next iteration should keep the one-slot rule and ablate
  sparse-yield archive warmup/fallback before broad controls.

## T39 Sparse-Yield Warmup Pre-Registration - 2026-06-22 UTC

- Pre-registered `techniques/T39_sparse_yield_warmup_qd/` as the direct T38
  warmup ablation before broad controls.
- T39 keeps the T38 live descriptor, seed, subset, model, budget, parent
  selection, `elite_pareto_slot` mode, and `max_elites_per_cell=2`.
- The only method delta is `--qd_grid_quantile_warmup_successes 4` instead of
  `8`, so designs with four to seven valid PPA samples can initialize an active
  quantile archive during the run.
- The method card records the leakage guard: PPA/front/HV/test labels are not
  descriptor inputs, and the lower warmup threshold alone cannot justify
  promotion without direct PPA/front and classic-covered-design evidence.

## T39 Sparse-Yield Warmup Live Arm - 2026-06-22 UTC

- Ran the pre-registered T39 bounded live arm under
  `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072. Runtime completed in 750 seconds.
- The arm used `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`, and
  `RTLLM/Prob015_multi_pipe_8bit`; population `12`, generations `3`, seed
  `1001`, `journal_graph_testability_3d`, `elite_pareto_slot`,
  `max_elites_per_cell=2`, and `qd_grid_quantile_warmup_successes=4`.
- Pareto archive validation passed with `failure_count=0` and
  `max_front_size_seen=2`.
- T39 fixed the T38 multi-pipe archive gap: multi-pipe has 11 valid PPA,
  8 local-front points, 6 global-front points, and 10 active archive members.
  T38 had 7 valid PPA, 3 local/global front points, and zero active archive
  members.
- Traffic-light improved from T38's 8 valid PPA and best quality `0.399899`
  to 15 valid PPA and best quality `0.403821`. ALU kept archive/front material
  but best quality dropped from `0.416377` to `0.402072`.
- Packaged direct raw PPA figures, improvement figures, count summary,
  candidate/front tables, validator output, preflight metadata, and a
  Playwright-rendered HTML viewer screenshot under
  `techniques/T39_sparse_yield_warmup_qd/`.
- Visual inspection passed for the raw area-power front, normalized
  improvement front, archive-count figure, and HTML screenshot.
- Tier decision: `T0 positive_ablation`. The warmup fix is real, but this
  package lacks same-budget classic/manual/random/full-Pareto controls, so it
  is not a `T1` or `T2` useful-QD claim.

## T38/T39 Direct PPA Front Correction - 2026-06-22 UTC

- The T38/T39 packages included raw area-power PPA plots, but the generator
  inverted both raw axes. That made the plots less straightforward for the
  intended reader-facing question: where is the actual area-power Pareto front?
- Updated `scripts/package_t38_elite_pareto_slot_live.py` so raw PPA plots use
  area on x, power on y, conventional non-inverted axes, and an explicit
  lower-left-is-better annotation. The normalized improvement plot remains
  higher-is-better.
- Regenerated T38 and T39 package artifacts:
  `figures/t38_live_raw_area_power_fronts.png`,
  `figures/t39_live_raw_area_power_fronts.png`, and their
  `visualizations/direct_ppa_pareto/screenshot.png` viewer screenshots.
- Visually inspected the regenerated T38 and T39 raw-front figures with
  `view_image`. The T39 viewer screenshot also renders the corrected plot and
  summary table without overlap.
- Updated T38/T39 figure notes and results reports to state that the primary
  direct PPA figure uses conventional lower-left-better axes.

## T40 Sparse-Warmup Control Matrix - 2026-06-22 UTC

- Pre-registered `techniques/T40_sparse_warmup_control_matrix/` as the matched
  control matrix for the frozen T39 candidate arm.
- T40 keeps the same RTLLM three-problem subset, seed `1001`, model
  `openai/gpt-oss-120b`, 128000-token caps, population `12`, generations `3`,
  `strict_ablation`, grid-quantile warmup `4`, NSGA-II parent selection,
  champion lane `0.80`, zero two-parent probability, `eoh_strategies`, and
  code-individual representation.
- Planned controls are `classic_revolution`, `manual_sparse_pareto_qd`,
  `random_sparse_elite_slot_qd`, and `graph_full_pareto_sparse_qd`; the T39
  candidate arm is referenced from
  `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`.
- The T40 visual gate is explicit: the first accepted comparison figure must
  be a direct raw area-power PPA Pareto plot with area on x, power on y, no
  axis inversion, and lower-left marked as better. Archive heatmaps,
  descriptor-space views, and normalized improvement plots are supporting
  artifacts, not substitutes.

## T40 Live Controls And Direct PPA Report - 2026-06-22 UTC

- Ran the four T40 live controls under
  `exp/useful_bd_push/t40_sparse_warmup_control_matrix_20260622_070540_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072.
- Completed arm runtimes:
  `classic_revolution` 646.16 seconds, `manual_sparse_pareto_qd` 698.34
  seconds, `random_sparse_elite_slot_qd` 743.50 seconds, and
  `graph_full_pareto_sparse_qd` 1075.89 seconds.
- Pareto archive validation passed for every QD control with `failure_count=0`.
  Manual BD and graph full Pareto reached `max_front_size_seen=5`; random
  one-slot reached `max_front_size_seen=2`.
- Packaged the completed matrix under
  `techniques/T40_sparse_warmup_control_matrix/`, including the preflight
  capture, candidate-level PPA rows, method summary rows, validator outputs,
  direct raw PPA-front PNG, count summary PNG, and filesystem-openable HTML
  viewer with a Playwright screenshot.
- The accepted primary figure is
  `figures/t40_raw_area_power_fronts.png`. It uses raw area on x, raw power on
  y, no axis inversion, and an explicit lower-left-is-better caption. The
  first generated version had title/legend crowding; it was regenerated before
  acceptance.
- Main result: T39 one-slot has the strongest multi-pipe best score
  (`0.222285`, +321.04% versus classic) and two multi-pipe pooled raw-front
  hits. Manual BD also contributes one multi-pipe pooled-front hit and one
  traffic-light pooled-front hit.
- Promotion blocker: classic keeps all three ALU pooled raw-front hits, three
  traffic-light pooled raw-front hits, and the best ALU and traffic-light
  scores (`0.414136` and `0.420875`). Random one-slot and graph full Pareto do
  not add pooled raw-front material.
- Tier decision: `T0 mixed_control_no_promotion`. Sparse warmup fixed the T38
  archive-activation failure and is useful for the hard multi-pipe slice, but
  the uniform T39 one-slot policy is not a same-budget screen-wide useful-QD
  win.
- Next iteration should test adaptive or per-design sparse-yield gating:
  preserve classic/champion pressure on designs with healthy yield/fronts, and
  activate the one-slot sparse-yield lane only where archive activation or hard
  front recovery is the bottleneck.

## T41 Adaptive Sparse-Yield Gate Pre-Registration - 2026-06-22 UTC

- Added opt-in grid-quantile adaptive warmup support for T41. The default is
  off; when enabled, generation-end fallback can initialize an archive from
  buffered valid PPA samples only if the archive is still empty and descriptor
  geometry is ready.
- Pre-registered `techniques/T41_adaptive_sparse_yield_gate_qd/` as the next
  live same-surface test after T40: primary warmup `8`, fallback `4`, trigger
  generation `1`, same T40 three-problem RTLLM subset, seed `1001`, model
  `openai/gpt-oss-120b`, 128000-token caps, population `12`, generations `3`,
  and `strict_ablation`.
- Added a matched T41 classic command. Frozen T40 manual/random/full-Pareto
  controls and the frozen T39 one-slot arm remain comparators, but T41's own
  live classic arm is the baseline for the new run.
- Added `scripts/package_t41_adaptive_sparse_yield_gate.py` so the first T41
  report artifact is a straightforward raw area-power PPA Pareto comparison:
  `figures/t41_raw_area_power_fronts.png`, plus candidate rows, method summary
  rows, count summary, and a filesystem-openable direct-PPA HTML viewer.
- Updated central indexes, lane docs, backlog, plan, and current results
  matrix so T41 is discoverable as pre-registered only, not a measured result.
- Validation: focused pytest passed for archive initialization, engine
  fallback behavior, backend and CLI plumbing, and the T40/T41 direct-PPA
  packagers. Ruff passed on touched source, scripts, and tests. Pyright and ty
  passed for the changed QD/backend modules and T40/T41 packagers. Pyright and
  ty still report the pre-existing `scripts/run_backend.py` evaluator union
  mismatch at lines 305 and 339.

## T41 Live Result And Direct PPA Report - 2026-06-22 UTC

- Ran T41 under
  `exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_20260622_083629_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072.
- Completed matched arms: `classic_revolution` in 716.66 seconds
  (`classic_seconds=719`) and `adaptive_sparse_yield_gate_qd` in 1029.96
  seconds (`adaptive_seconds=1033`).
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Packaged the result under
  `techniques/T41_adaptive_sparse_yield_gate_qd/`, including preflight JSON,
  validation JSON/MD, candidate-level PPA rows, method summary rows, runtime
  summary, direct raw PPA-front PNG, count summary PNG, and a
  filesystem-openable HTML viewer with Playwright screenshot.
- Visual inspection passed. `figures/t41_raw_area_power_fronts.png` and
  `visualizations/direct_ppa_pareto/screenshot.png` use conventional
  lower-left-better raw area-power axes and make the T41 traffic-light win and
  multi-pipe loss visible.
- Main result: T41 adaptive wins traffic-light with 20 valid PPA candidates,
  7 pooled raw-front hits, min area `97`, min power `0.000255`, and best score
  `0.473631`, beating T41 classic (`0.407742`) and all frozen controls on the
  claimed traffic-light metric.
- Promotion blockers: T41 adaptive has zero ALU pooled-front hits and best
  score `0.400330` versus T41 classic `0.414603`; it also loses the T39
  multi-pipe signal with best score `-0.000378` versus T39 `0.222285`.
- Archive read: ALU and traffic-light initialized with 8 samples; multi-pipe
  initialized with 5 samples, so the adaptive fallback did activate on the
  sparse-yield design. The issue is not activation, but late/weak activation
  that fails to preserve useful multi-pipe quality.
- Tier decision: `T0 mixed_diagnostic`. T41 is useful evidence for adaptive
  gating but not a screen-wide useful-QD method.
- Next iteration should pre-register T42: keep warmup `8`, fallback threshold
  `4`, but trigger fallback at generation `0` so sparse-yield designs can
  initialize immediately after the initial population.

## Direct PPA Audit Semantics Refresh - 2026-06-22 UTC

- Corrected `scripts/package_useful_bd_direct_ppa_fronts.py` so raw
  area-power plots use conventional non-inverted axes and raw area-power
  Pareto membership, rather than reusing the active-objective front flag.
- Regenerated
  `visualization_audits/20260621_direct_ppa_fronts/` from the original
  T24/T25/T26 run roots. The candidate table now records
  `is_area_power_front` and `is_active_objective_front`; the problem table now
  reports `area_power_front_count` and `active_objective_front_count`.
- Visual inspection accepted the regenerated
  `live_key_ppa_fronts_area_power_zoom.png`,
  `live_all_ppa_fronts_area_power_zoom.png`, and
  `live_front_count_summary.png` figures. The raw panels now directly answer
  the straightforward PPA Pareto-front concern: lower-left is better, open
  circles are raw area-power nondominated points, and the timing-aware
  active-objective counts are separate.
- Updated the visualization audit README, figure README, table README,
  visual-inspection notes, and current-results matrix to use the corrected
  front definitions and counts.
- Focused validation:
  `uv run pytest tests/scripts/test_package_useful_bd_direct_ppa_fronts.py`
  passed.

## T42 Initial Sparse-Yield Gate Pre-Registration - 2026-06-22 UTC

- Added generation-0 adaptive warmup support to `QDEngine.initialize_population`.
  After the initial success pool is rebuilt into a grid-quantile archive, the
  existing adaptive fallback hook now runs once. It remains a no-op unless
  `qd_grid_quantile_adaptive_warmup_generation=0` and the configured valid-PPA
  fallback threshold is met.
- Added a focused engine test for the public initialization path:
  four valid initial PPA samples with primary warmup `8`, fallback `4`, and
  trigger generation `0` initialize the grid-quantile archive with
  `adaptive_sparse_yield_fallback`.
- Pre-registered `techniques/T42_initial_sparse_yield_gate_qd/` as the next
  live same-surface test after T41. T42 keeps T41's descriptor, archive,
  parent selection, operator, model, seed, subset, and budget, but changes
  `qd_grid_quantile_adaptive_warmup_generation` from `1` to `0`.
- Added `scripts/package_t42_initial_sparse_yield_gate.py` and a focused
  package test. The planned package emits candidate-level PPA rows, per-method
  summaries, direct raw area-power front PNGs, count summaries, and a local
  direct-PPA HTML viewer.
- Updated central indexes, current-results matrix, lane docs, lineage ledger,
  TODO, and idea backlog so T42 is discoverable as pre-registered and pending
  live execution.

## T42 Live Result And Direct PPA Report - 2026-06-22 UTC

- Ran T42 under
  `exp/useful_bd_push/t42_initial_sparse_yield_gate_qd_20260622_093940_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072.
- Completed matched arms: `classic_revolution` in 646 seconds and
  `initial_sparse_yield_gate_qd` in 747 seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Packaged the result under
  `techniques/T42_initial_sparse_yield_gate_qd/`, including preflight JSON,
  validation JSON/MD, candidate-level PPA rows, method summary rows, runtime
  summary, direct raw PPA-front PNG, count summary PNG, and a
  filesystem-openable direct-PPA HTML viewer with screenshot.
- Visual inspection passed. `figures/t42_raw_area_power_fronts.png` and
  `visualizations/direct_ppa_pareto/screenshot.png` use conventional
  lower-left-better raw area-power axes, open circles for method fronts, and
  black stars for pooled fronts.
- Main result: T42 preserves all classic-covered designs and adds one ALU
  pooled raw-front hit plus one multi-pipe pooled raw-front hit. Multi-pipe
  best score improves over T41 (`0.116397` versus `-0.000378`).
- Promotion blockers: T42 loses T41's traffic-light signal with zero
  traffic-light pooled-front hits and best score `0.391093` versus T41's seven
  pooled hits and `0.473631`; T42 also does not recover T39's multi-pipe best
  score (`0.116397` versus `0.222285`).
- Archive read: all three T42 archives initialized with `warmup_successes=8`,
  so this screen does not clearly prove that generation-0 fallback fired in a
  sparse-initialization regime. Treat it as a timing ablation, not as a
  solved gating policy.
- Tier decision: `T0 mixed_diagnostic`. The next iteration should
  pre-register a staged or per-design sparse-yield gate instead of another
  global trigger-only variant.

## T43 Staged Sparse-Yield Gate Pre-Registration - 2026-06-22 UTC

- Added staged sparse-yield parent-pressure support for T43. The new
  `qd_adaptive_warmup_champion_lane_fraction` setting is off by default and
  only changes parent sampling when a `GridQuantileArchive` reports
  `initialization_mode=adaptive_sparse_yield_fallback`.
- Pre-registered `techniques/T43_staged_sparse_yield_gate_qd/` as the next
  same-surface live method after T42. T43 keeps T42's descriptor, archive,
  operator, model, seed, subset, and budget.
- T43 keeps the default champion lane at `0.80`, but changes it to `0.60` for
  problems whose archive actually initialized through adaptive sparse-yield
  fallback. Strict eight-success warmup archives keep `0.80`.
- The trigger is per-problem runtime archive state, not problem identity,
  final PPA, final Pareto rank, reference PPA, hypervolume, or best score.
- Added `scripts/package_t43_staged_sparse_yield_gate.py` and a focused
  package test. The planned package emits candidate-level PPA rows, per-method
  summaries, direct raw area-power front PNGs, count summaries, and a local
  direct-PPA HTML viewer.
- Updated central indexes, current-results matrix, lane docs, lineage ledger,
  TODO, and plan so T43 is discoverable as pre-registered and pending live
  execution.

## T43 Live Result And Direct PPA Report - 2026-06-22 UTC

- Ran T43 under
  `exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072.
- Completed matched arms: `classic_revolution` in 1025 seconds and
  `staged_sparse_yield_gate_qd` in 721 seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Packaged the result under
  `techniques/T43_staged_sparse_yield_gate_qd/`, including preflight JSON,
  validation JSON/MD, candidate-level PPA rows, method summary rows, runtime
  summary, direct raw PPA-front PNG, count summary PNG, and a
  filesystem-openable direct-PPA HTML viewer with screenshot.
- Visual inspection passed. `figures/t43_raw_area_power_fronts.png` and
  `visualizations/direct_ppa_pareto/screenshot.png` use conventional
  lower-left-better raw area-power axes, open circles for method fronts, and
  black stars for pooled fronts.
- Main result: T43 preserves all classic-covered designs and improves
  traffic-light valid-PPA count versus matched classic (`26` versus `12`), but
  contributes zero pooled raw area-power front hits.
- Archive read: all three T43 QD archives completed strict eight-success
  warmup, so the staged `0.60` champion lane never activated.
- Tier decision: `T0 mixed_diagnostic`. Do not continue blind
  champion-lane-percentage tuning; next use a bounded sparse-trigger screen or
  branch exact T11 runtime projection.

## Phase 03.1 Viewer Contract And T43 Export - 2026-06-22 UTC

- Tightened `visualization_reporting_policy.md`: live QD techniques with
  archive artifacts now require both the full Phase 03.1
  `visualizations/qd_ppa_viewer/` bundle and the simpler
  `visualizations/direct_ppa_pareto/` supplement.
- Fixed `scripts/validate_qd_ppa_visualization.py` so strict Playwright
  validation can run on per-technique subsets without requiring unrelated
  reference/demo problems.
- Fixed classic descriptor recovery in
  `src/revolution/qd/ppa_visualization_export.py` by combining RTL and graph
  metrics and applying descriptor-axis transforms before posthoc projection.
- Exported T43's full viewer at
  `techniques/T43_staged_sparse_yield_gate_qd/visualizations/qd_ppa_viewer/`.
  The baseline is aliased as `classic` for Phase 03.1 compatibility and maps
  to the `classic_revolution` backend run.
- Strict schema/control validation and strict Playwright smoke both passed.
  Classic projection coverage is 35/35 for ALU, 12/12 for traffic-light, and
  14/14 for multi-pipe.

## T44 T11 Runtime Graph Bridge Pre-Registration - 2026-06-22 UTC

- Added live-safe T11-inspired graph descriptor axes to
  `GraphDescriptorEvaluator` and registered `t11_runtime_top8_graph` plus
  `t11_runtime_top16_graph` in `data/configs/qd_descriptor_profiles.yaml`.
- T44 is intentionally scoped as a runtime bridge, not a full replay-exact
  T11 projection. It exposes T11's highest-ranked graph count/share features
  online without using PPA, reference PPA, fitness, hypervolume, Pareto rank,
  functional pass labels, or problem identity.
- Pre-registered
  `techniques/T44_t11_runtime_graph_bridge/` as the next L4/L5 follow-up after
  T43. The full run will use the T39 one-slot sparse-warmup substrate and
  replace only the descriptor profile with `t11_runtime_top8_graph`.
- Verified the shared vLLM endpoint:
  `curl --max-time 15 http://20.0.0.103:8000/v1/models` returned
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Ran a bounded smoke on `RTLLM/Prob041_traffic_light`, population `4`,
  generation `0`, seed `1001`, and `t11_runtime_top8_graph`. The run completed
  under
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_113144_UTC/` in
  42.29 seconds and wrote archive metadata with the expected descriptor axes.
- Smoke caveat: all four candidates failed functionality, so no valid PPA or
  archive-initialization evidence exists. Treat the smoke as a wiring check
  only; T44 still needs the full three-problem live screen before any tier
  decision.

## Phase 03.1 Contract For New Live Techniques - 2026-06-22 UTC

- Added `phase_03_1_visualization_contract.md` as the concise live-technique
  visualization contract. Completed live QD methods with archive artifacts now
  require both the full `visualizations/qd_ppa_viewer/` bundle and the
  reader-facing `visualizations/direct_ppa_pareto/` supplement.
- Updated the local index, experimental setup, visualization policy, and TODO
  to make the Phase 03.1 viewer mandatory rather than treating simple direct
  raw-PPA HTML as the full linked archive/PPA viewer.
- Added `scripts/package_t44_t11_runtime_graph_bridge.py` plus a focused test
  so the next T44 full run can generate direct raw area-power PPA figures,
  summary tables, `metrics.json`, and the direct HTML supplement from the
  matched T44 run plus frozen T43/T39 references.
- Updated T44 commands and reports to require the full viewer export, strict
  validation, Playwright inspection, honest classic archive projection notes,
  and separate direct-PPA screenshots before any tier decision.

## T44 Live Result And Phase 03.1 Viewer - 2026-06-22 UTC

- Ran T44 under
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC/`.
  The vLLM preflight reported `openai/gpt-oss-120b` with `max_model_len`
  131072.
- Completed matched arms: `classic_revolution` in 643 seconds and
  `t11_runtime_top8_graph_qd` in 702 seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Packaged direct raw-PPA artifacts under
  `techniques/T44_t11_runtime_graph_bridge/`, including candidate rows,
  method summaries, raw area-power front PNG, count summary PNG, direct HTML
  supplement, and screenshot.
- Built the full Phase 03.1 viewer at
  `techniques/T44_t11_runtime_graph_bridge/visualizations/qd_ppa_viewer/`.
  The baseline key is `classic`, and classic candidates project honestly into
  the T44 archive: 35/35 ALU, 25/25 traffic-light, and 16/16 multi-pipe.
- Strict Playwright validation initially found that high-dimensional archive
  cells rendered samples but not filled-cell hover targets. Updated
  `src/revolution/qd/ppa_visualization_viewer.py` to render occupied cells
  from actual cell summaries, then re-exported T44 and passed strict
  validation.
- Visual inspection passed for `figures/t44_raw_area_power_fronts.png`,
  `figures/t44_front_count_summary.png`,
  `visualizations/direct_ppa_pareto/screenshot.png`, and
  `visualizations/qd_ppa_viewer/screenshot.png`.
- Main result: T44 preserves all classic-covered designs, wins HV on
  traffic-light and multi-pipe, and adds one pooled raw-front hit on each of
  those two problems. Mean Pareto point count rises from 3.333 to 3.667.
- Promotion blockers: aggregate mean HV falls from 0.163787 to 0.154221,
  reference-beating count falls from 16.333 to 6.333, ALU valid PPA drops from
  35 to 16, and traffic-light valid PPA drops from 25 to 7. The two yield
  drops exceed the 50% gate with classic denominators above 10.
- Tier decision: `T0 mixed_diagnostic`. The next method should compress or
  select fewer T11 runtime graph axes, such as a top-3/top-4 profile or frozen
  non-PPA projection, before trying top-16/top-64 fitted projection.

## T45 Compact T11 Runtime Graph Pre-Registration - 2026-06-22 UTC

- Added descriptor profile `t11_runtime_top4_graph`, using the first four
  axes from T44's pre-registered top-8 T11 runtime graph profile:
  `hyper_mean_fanout`, `edge_per_node`, `log_edge_count`, and
  `hyper_directed_edge_count`.
- Pre-registered `techniques/T45_t11_runtime_top4_graph/` as the direct T44
  dimensionality ablation. It keeps model, subset, seed, budget, archive
  substrate, parent selection, operator, and reporting gates fixed.
- Added `scripts/package_t45_t11_runtime_top4_graph.py` and a focused unit
  test so T45 can package direct raw-PPA figures, summary tables,
  `metrics.json`, and the direct HTML supplement against matched T45 runs and
  frozen T44/T43/T39 references.
- T45 remains pending until the full three-problem live screen, Pareto
  validation, direct-PPA package, Phase 03.1 viewer export, strict Playwright
  validation, visual inspection, and tier decision are complete.

## Presentation And RTLLM Milestone Start - 2026-06-22 UTC

- User redirected the active priority to a presentation/report milestone that
  answers the two main questions: whether diversity matters for RTL/Verilog
  PPA evolution, and which diversity matters.
- Stopped the just-started T45 classic arm after about 10 seconds to avoid
  consuming the vLLM endpoint while switching priorities. It wrote an
  interrupted run root at
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_124816_UTC/`; this
  is not a T45 result and must not be interpreted.
- Created `presentations/20260623_report/` with report and slide scaffolds,
  pre-registered RTLLM experiment protocol, command templates, adversarial
  review rubric, planned figure/table directories, and a 50-problem RTLLM
  manifest frozen from `bench/RTLLM/*_prompt.txt`.
- Recorded an initial adversarial sub-agent review at
  `presentations/20260623_report/reviews/subagent_prelaunch_review.md`.
- Attempted `claude -p` prelaunch review and recorded the non-usable
  `Execution error`, then reran with a longer wait and recorded the completed
  review at `presentations/20260623_report/reviews/claude_prelaunch_review.md`.
- Incorporated immediate Claude review gates: exact T26 is the confirmatory
  fallback, one-seed RTLLM cannot claim seed-stable significance, full-run
  aggregates must include a screen-excluded view, budget parity must report
  evaluation/LLM-call counts, and front-family breadth must be a first-class
  figure because T28 shows exact T26 loses that diversity metric versus
  classic.
- Added the milestone to `goal_template.md`,
  `useful_bd_push_implementation_todo.md`, and
  `useful_bd_push_adversarial_prompt.md` so presentation plus RTLLM comparison
  is treated as a major goal gate before resuming lower-priority technique
  exploration.

## One-Seed RTLLM Milestone Clarification - 2026-06-22 13:05 UTC

- User clarified that the one-seed limitation is acceptable for the deadline
  as the first broad RTLLM pass. The priority is to run the matched
  classic-vs-T26-family comparison, organize the plots/tables, and build the
  presentation/report materials before paying the cost of multi-seed
  replication.
- Updated the milestone docs to keep the statistical caveat: one seed can
  support paired engineering evidence across problems, but not seed-stable or
  statistical-significance claims.

## RTLLM Yield Gate Relaxation - 2026-06-22 UTC

- User clarified that the primary milestone objective is PPA optimization, not
  matching classic's valid-PPA rate. Updated current policy so the hard launch
  gate is classic-covered retention: if classic has at least one valid PPA
  candidate for a design, the selected QD arm must also have at least one.
- A 50 percent or larger valid-PPA or synthesis-valid drop is now a reported
  yield warning for this deadline milestone, not an automatic full-run blocker.
  Reports must still show the yield tradeoff clearly.

## RTLLM Screen Selection - 2026-06-22 UTC

- Completed the matched three-problem RTLLM screen under
  `exp/useful_bd_push/rtllm_milestone_screen_20260622_130747_UTC/` for classic,
  exact T26, T26.1 low-fusion, and T26.1 mid-fusion.
- Packaged results under `presentations/20260623_report/screening/` with CSV
  tables and inspected PNG summaries.
- Selected exact T26, `sr_raw_conservative_exploit_qd`, for the full one-seed
  RTLLM run because it is the only QD arm with positive final mean HV versus
  classic and it improves HV-AUC. Exact T26 yield drops on ALU and multi-pipe
  are retained as visible yield warnings.

## 2026-06-22T14:34:27Z - Relax PPA-first validity policy

- Updated the current source-of-truth gate language after user clarification:
  PPA optimization is the primary milestone goal, so the hard gate is
  design-level coverage retention, not matching classic's valid-yield rate.
- A `T1+` or milestone-promoted method must still produce at least one valid
  functional PPA candidate for every design where classic has at least one
  under the same budget.
- A 50 percent or larger functionality, synthesis-valid, or valid-PPA yield
  drop is now a visible warning when the classic denominator is at least 10,
  not automatic rejection. Below 10, the rate is labeled small-n/noisy.
- The active full RTLLM experiment remains pre-registered; this change aligns
  the broader policy docs with the already-packaged milestone gate.

## Full RTLLM Milestone Package - 2026-06-22 UTC

- Completed the one-seed full RTLLM milestone package under
  `presentations/20260623_report/full_rtllm/` using the merged analysis root
  `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0`.
- Exact T26 QD passes the relaxed PPA-first hard gate with `0`
  classic-covered retention failures. It has `4` yield warnings and `6`
  small-n validity labels.
- Legacy all-RTLLM/defaulted results looked positive for PPA-centered QD
  evidence: mean HV delta `+0.010562`, mean HV-AUC delta `+0.012397`, and
  PPA-front points `69` versus `61`.
- The report records the main caveats: lower valid-PPA yield (`879` versus
  `1056`), fewer unique PPA points (`318` versus `352`), and outlier
  sensitivity around `Prob040_synchronizer`.
- Updated `report.md`, `slides.md`, command provenance, and visual inspection
  notes so the milestone can be presented as reviewable one-seed engineering
  evidence rather than seed-stable proof.

## T26 Reference-Complete Claim Correction - 2026-06-23 UTC

- Updated the milestone interpretation after confirming that four RTLLM
  problems have missing/defaulted reference PPA:
  `Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
  `Prob018_float_multi`, and `Prob040_synchronizer`.
- The all-50/defaulted aggregate view explains why the first T26 headline
  looked positive, but it is not claim-safe.
- The 46-problem reference-complete formal bundle recommends classic overall,
  classic for multi-objective/Pareto comparison, and T26 only for
  score/archive diagnostic views.
- T26/T27 are therefore mechanism clues and historical context, not proof that
  QD beat classic on broad RTLLM.

## Presentation Terminology Pass - 2026-06-22 UTC

- Added `presentations/20260623_report/glossary.md` with audience-facing
  definitions for BD, QD/MAP-Elites, archive/elites, PPA, valid PPA,
  retention gates, yield warnings, Pareto fronts, HV, HV-AUC, archive
  coverage, QD score, and one-seed paired engineering evidence.
- Split the slide outline into separate terminology and metric/gate slides so
  non-QD readers can follow the result before the method details.
- Linked the glossary from the report and package README, and tightened metric
  schema descriptions for HV, HV-AUC, front counts, archive coverage, and QD
  score.

## Packaging Review Resolution - 2026-06-22 UTC

- Recorded the Lovelace sub-agent packaging review under
  `presentations/20260623_report/reviews/subagent_packaging_review.md`.
- Resolved the main presentation blockers by scoping the Q2 answer to the T26
  implementation-response archive bundle instead of descriptor-only causality.
- Added `full_rtllm/tables/full_budget_parity.csv` from existing per-problem
  summaries. Both arms generated `2400` candidates; classic made `4801` LLM
  API calls and exact T26 made `4800`.
- Marked full-suite unique front-family breadth as a follow-up audit rather
  than a current claim, while keeping the current claim on HV, HV-AUC,
  classic-covered retention, PPA-front points, and unique PPA points.

## Scoped Presentation Review Pass - 2026-06-22 UTC

- Recorded the Volta follow-up sub-agent review as `PASS` for the scoped
  PPA-first T26-bundle claim after the Q2 scope and budget-parity fixes.
- Recorded the `claude -p` packaging review as `PASS` under
  `presentations/20260623_report/reviews/claude_packaging_review.md`.
- Added the explicit prior-family-audit caveat: exact T26 should not be
  presented as a front-family-breadth win until the full RTLLM family audit is
  generated.
- Clarified that bootstrap intervals are deferred for the one-seed package
  because this milestone is not a seed-stability claim.

## Retrospective Presentation Digest - 2026-06-22 UTC

- Added `presentations/20260623_report/retrospective/` as the local digest for
  the 20260618 Auto-BD controls and the 20260621 ASP-DAC-backed retrospective
  diversity analysis.
- Regenerated presentation-local tables and figures for source coverage,
  utility gates, replay retention, Qwen replay deltas, early-diversity
  correlation, and a PPA-front-by-style RTLLM case study.
- Added a report subsection explaining that the retrospective evidence supports
  interpretable/diagnostic diversity only, while the then-current T26 claim
  came from the prospective matched-budget full RTLLM comparison. The later
  current-package correction downgrades that claim to diagnostic.
- Recorded two sub-agent retrospective review passes and two `claude -p`
  retrospective review passes under
  `presentations/20260623_report/reviews/`. The final verdicts were `PASS`
  with no blockers after resolving readability and terminology notes.

## T45 Compact T11 Runtime Graph Live Result - 2026-06-22 UTC

- Ran the fresh T45 live root under
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC/`.
  The earlier
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_124816_UTC/`
  root remains an interrupted non-result.
- The `/v1/models` preflight reported `openai/gpt-oss-120b` with
  `max_model_len=131072`, satisfying the 128k token-budget requirement.
- Completed matched arms with the frozen three-problem screen, seed `1001`,
  population `12`, generations `3`, strict-ablation evaluation, and
  `96` LLM calls per design:
  `classic_revolution` completed in `595.26` seconds, and
  `t11_runtime_top4_graph_qd` completed in `718.21` seconds.
- Pareto archive validation passed with `valid=True`, `failure_count=0`,
  `problem_invalid_count=0`, `acceptance_error_count=0`, and
  `max_front_size_seen=2`.
- Packaged direct raw-PPA artifacts under
  `techniques/T45_t11_runtime_top4_graph/`, including candidate rows, method
  summaries, raw area-power front PNG, count summary PNG, direct HTML
  supplement, and Playwright screenshot.
- Built the full Phase 03.1 viewer at
  `techniques/T45_t11_runtime_top4_graph/visualizations/qd_ppa_viewer/`.
  Strict validation with Playwright passed, and the package includes
  `validation.{json,md}`, `screenshot.png`, and the optional screenshot matrix.
- Main result: T45 preserves all three classic-covered designs and avoids the
  50 percent yield-warning threshold, but classic wins the primary metrics:
  mean HV `0.2043` versus `0.1775`, value-level HV outcomes are two classic
  wins plus one zero-HV tie, mean Pareto points `3.67` versus `3.33`, mean
  reference-beating count `10.00` versus `8.67`, valid-PPA samples `61` versus
  `41`, and every best-score comparison.
- Direct raw-PPA figures show T45 contributes only one pooled raw-front point,
  on traffic-light. The correct tier is `T0 mixed_diagnostic`, not a
  promotion.
- Lane decision: retire direct ranked graph-axis escalation as the next graph
  move. Do not run top-16/top-64 ranked axes next; use a frozen non-PPA graph
  projection or make graph descriptors a secondary archive lane.
- Sub-agent adversarial review passed with no blockers. Follow-up edits
  clarified that final-analysis `HV Wins` assigns the zero-HV multi-pipe tie to
  classic by deterministic winner count, while the report's value-level read
  treats it as a tie. The manifest validation note was made self-contained.

## T46 Frozen T11 PCA Graph Pre-Registration - 2026-06-22 UTC

- Pre-registered `techniques/T46_t11_runtime_pca4_graph/` as the next graph
  lane follow-up after T45 retired direct ranked-axis escalation.
- Added descriptor profile `t11_runtime_pca4_graph` with four frozen
  projection axes: `t11_runtime_pca_0` through `t11_runtime_pca_3`.
- Fitted the projection from the 768 parsed non-PPA rows in
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`, using
  T44's top-8 graph feature family and no PPA, fitness, hypervolume,
  validity, pass-rate, problem, corpus, model, method, seed, or candidate-id
  labels.
- Kept the live-screen settings fixed to T45: same three RTLLM problems, model
  endpoint, seed `1001`, population `12`, generations `3`, strict-ablation
  evaluation, grid-quantile archive, one local Pareto slot, champion lane
  `0.80`, no two-parent fusion, and Phase 03.1/direct-PPA visualization gates.
- Added `scripts/package_t46_t11_runtime_pca4_graph.py` and focused tests for
  the new descriptor profile plus package generation. T46 is now ready for
  pre-run validation and a matched live screen.

## T46 Frozen T11 PCA Graph Live Result - 2026-06-22 UTC

- Ran the matched T46 live screen under
  `exp/useful_bd_push/t46_t11_runtime_pca4_graph_20260622_182358_UTC/`.
  The `/v1/models` preflight reported `openai/gpt-oss-120b` with
  `max_model_len=131072`, satisfying the 128k token-budget requirement.
- Completed matched arms with the fixed three-problem RTLLM screen, seed
  `1001`, population `12`, generations `3`, strict-ablation evaluation, and
  `96` LLM calls per problem. `classic_revolution` completed in `664.23`
  seconds, and `t11_runtime_pca4_graph_qd` completed in `744.18` seconds.
- Pareto archive validation passed for all three problems with `valid=True`,
  `failure_count=0`, `problem_invalid_count=0`, `acceptance_error_count=0`,
  and `max_front_size_seen=2`.
- Packaged direct raw-PPA artifacts under
  `techniques/T46_t11_runtime_pca4_graph/`, including candidate rows, method
  summaries, raw area-power front PNG, count summary PNG, direct HTML
  supplement, and Playwright screenshot.
- Built the full Phase 03.1 viewer at
  `techniques/T46_t11_runtime_pca4_graph/visualizations/qd_ppa_viewer/`.
  Strict validation with Playwright passed, and the package includes
  `validation.{json,md}`, `screenshot.png`, and the screenshot matrix.
- Main result: T46 preserves all three classic-covered designs and avoids the
  50 percent valid-PPA yield warning, but classic wins the primary aggregate
  metrics: mean HV `0.1588` versus `0.1155`, HV wins `2` versus `1`,
  reference-beating count `11.00` versus `7.00`, and valid-PPA samples `54`
  versus `37`.
- The positive signal is narrow: T46 wins ALU HV (`0.2046` versus `0.1962`),
  contributes one ALU pooled raw-front hit, and improves best score on ALU and
  multi-pipe. Traffic-light blocks promotion: HV falls from `0.2801` to
  `0.1419`, best score falls from `0.4248` to `0.3774`, and T46 contributes no
  traffic-light pooled raw-front hit.
- Lane decision: assign `T0 mixed_diagnostic` and retire direct graph-axis
  dimensionality variants as the next primary live path. Reuse graph features
  as secondary archive/reporting coordinates or trained-encoder inputs unless
  a new mechanism is specified.

## Full RTLLM Phase 03.1 Viewer Package - 2026-06-22 UTC

- Added the full Phase 03.1 archive/PPA viewer under
  `presentations/20260623_report/full_rtllm/visualizations/qd_ppa_viewer/`.
  The bundle includes `index.html`, `manifest.json`, 37 problem datasets,
  `validation.{json,md}`, `visual_parity_report.md`, `screenshot.png`, and
  the Playwright screenshot matrix.
- Kept the scope explicit: the milestone covers all 50 RTLLM manifest
  problems, while the viewer includes the 37 problems with at least one valid
  PPA candidate. The 13 zero-valid-PPA problems remain in the aggregate
  tables and validity gates.
- Projected all classic samples into the exact T26 SR-PCA archive using the
  frozen 20260618 SR raw PCA artifact. Projection coverage was `352/352`
  classic rows with `0` failures and descriptor hash
  `931edf18e9ec5e3a7b2b8d7996c603c64ec82619f6185ea44cf4803e6105ee1b`.
- Added `visualizations/direct_ppa_pareto/` as the static reader-facing raw
  area-power front supplement, reusing the visually inspected representative
  PPA-front figure.
- Strict validation passed with Playwright:
  `uv run python scripts/validate_qd_ppa_visualization.py --viewer-root .../qd_ppa_viewer --subset-config .../rtllm_valid_ppa_viewer_subset.yaml --strict --playwright`.

## Full RTLLM Family Audit Package - 2026-06-22 UTC

- Added `scripts/package_full_rtllm_family_audit.py` and a focused unit test
  to package canonical RTL/netlist/family duplicate metrics for the one-seed
  full RTLLM milestone.
- Packaged `presentations/20260623_report/full_rtllm/family_audit/` with
  candidate rows, per-problem family metrics, aggregate metrics, comparison
  deltas, three figures, and visual inspection notes.
- Main result: exact T26 QD is not a duplicate-collapse win under the T28
  family proxy. It has fewer family-proxy duplicates (`7` versus `11`) and a
  slightly higher audited family-proxy ratio (`0.977987` versus `0.968750`)
  despite fewer audited deduplicated PPA-point rows.
- Positive full-suite diversity result: exact T26 QD has more active-front
  family-proxy hits and front netlists than classic (`69` versus `61` for both
  metrics). This resolves the missing full-suite front-family proxy audit
  noted in the presentation draft.
- Remaining caveat: exact T26 QD has fewer summed family proxies (`311`
  versus `341`) and fewer reference-beating family-proxy hits (`129` versus
  `179`), so the milestone supports a front-material proxy observation rather
  than broad implementation-family dominance.

## Current Package Adversarial Correction - 2026-06-22 UTC

- Ran a new current-package sub-agent review and a long-timeout `claude -p`
  review after the full family-proxy audit. The sub-agent passed with
  limitations, but Claude found stronger presentation-integrity blockers.
- Downgraded the milestone claim status from `useful_qd` to `diagnostic`.
  Exact T26 preserves every classic-covered design and adds front points, but
  paired HV is net-negative (`4` wins, `15` losses, `31` ties), all-RTLLM
  `best_score` is worse (`-0.798824` versus `0.260455`), and the aggregate HV
  win flips negative without `Prob040_synchronizer`.
- Connected the aggregate HV caveat to the provenance note: `Prob040` is one
  of the repaired missing-reference problems and uses a defaulted reference.
  It cannot be the sole carrier for a positive QD-effectiveness claim.
- Clarified that front-family and front-netlist counts are not independent
  corroboration when `front_family_ratio=1.0`; the family-proxy audit rejects
  duplicate collapse but does not create a separate front win.
- Updated `report.md`, `slides.md`, package READMEs, claim-validation docs,
  review-resolution notes, and the RTLLM package generator/test so future
  regenerated summaries remain diagnostic unless stronger paired PPA and
  scalar-quality evidence is added.

## Journal Contract Alignment Note - 2026-06-22 UTC

- Added `presentations/20260623_report/journal_contract_alignment.md` to map
  the one-seed full RTLLM package against the accepted
  `docs/journal_features/journal_narrative.md` contract.
- Main decision: the package is not final-gate eligible. It lacks the 5-seed
  final scale, frozen tuning/held-out split labels, `journal_stats`
  penalized cluster-bootstrap/sign-test gates, and non-defaulted-reference
  headline evidence.
- The note keeps the diagnostic value: exact T26 preserves classic-covered
  problems and adds front points, but it cannot support Branch A/B/C or a
  positive useful-QD claim without the contract-aligned follow-up evidence.

## T47 Contract-Aligned T26 Probe Pre-Registration - 2026-06-22 UTC

- Added `techniques/T47_t26_contract_probe/` as the next T26-family gate after
  the full RTLLM package was narrowed to diagnostic.
- T47 is not a result package yet. It pre-registers a hard/tuning sanity probe,
  a blocked held-out dry-run phase, default-reference quarantine rules, and
  acceptance signals for exact T26 or a narrow T26.1 role-separated variant.
- Updated the technique registry, TODO, lane ledger, and lineage ledger so the
  next live spend is tied to the frozen `journal_narrative.md` contract rather
  than the one-seed full-RTLLM diagnostic package.

## T47 Probe Table Generation - 2026-06-22 UTC

- Added `scripts/build_t47_contract_probe_tables.py` to regenerate the T47
  probe ladder, expanded phase/seed/arm/problem matrix, and
  default-reference quarantine table from the frozen configs.
- Generated 92 planned T47 hard/tuning and held-out rows. All 92 have
  benchmark reference PPA files available.
- Confirmed the known repaired/default-reference RTLLM problems
  (`Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
  `Prob040_synchronizer`) are outside the T47 probe matrix and remain
  quarantined from headline reference-normalized claims.

## T47 Endpoint Preflight - 2026-06-22 UTC

- Recorded local vLLM preflight metadata in
  `techniques/T47_t26_contract_probe/tables/preflight_models_20260622_203146_UTC.json`.
- The endpoint at `20.0.0.103:8000` reports `openai/gpt-oss-120b` with
  `max_model_len=131072`, satisfying the 128k-token budget requirement.
- Added exact hard/tuning sanity commands under
  `techniques/T47_t26_contract_probe/commands/hard_tuning_sanity_20260622_203146_UTC.md`
  before launching any live T47 spend.

## T47 Classic Seed 1001 Completion - 2026-06-22 UTC

- Launched the hard/tuning sanity `classic_revolution` arm for seed `1001`
  under
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/`.
- The run completed with return code `0` at `2026-06-22T20:57:52Z` and
  produced 13 of 13 expected problem summaries.
- Added `tables/hard_tuning_run_status.csv` so subsequent T47 arm/seed
  launches can be tracked without relying on untracked `exp/` state alone.

## T47 Exact T26 Seed 1001 Completion - 2026-06-22 UTC

- Launched the hard/tuning sanity `sr_raw_conservative_exploit_qd` arm for
  seed `1001` under the same T47 run root.
- The run completed with return code `0` at `2026-06-22T21:26:45Z` and
  produced 13 of 13 expected archive summaries.
- Validated the matched seed-1001 pair with
  `scripts/validate_pareto_front_run.py --require-full-subset` before
  launching any seed-1002 spend.

## T47 Classic Seed 1002 Completion - 2026-06-22 UTC

- Launched the hard/tuning sanity `classic_revolution` arm for seed `1002`
  under the same T47 run root.
- The run completed with return code `0` at `2026-06-22T21:52:23Z` and
  produced 13 of 13 expected problem summaries.
- The remaining hard/tuning live spend is exact T26 QD seed `1002`, after
  which the two-seed T47 comparison can be validated and packaged.

## T47 Exact T26 Seed 1002 Completion - 2026-06-22 UTC

- Launched the hard/tuning sanity `sr_raw_conservative_exploit_qd` arm for
  seed `1002` under the same T47 run root.
- The run completed with return code `0` at `2026-06-22T22:20:55Z` and
  produced 13 of 13 expected archive summaries.
- Validated the full two-seed hard/tuning set with
  `scripts/validate_pareto_front_run.py --require-full-subset`. The command
  exited with code `0` and no validation errors.
- The next T47 step is analysis packaging, not a held-out launch. Package
  paired HV, best-score, validity, front-count, and default-reference
  quarantine metrics before assigning any T1-or-higher decision.

## T47 Hard/Tuning Package - 2026-06-22 UTC

- Added `scripts/package_t47_contract_probe.py` plus focused tests to package
  the two-seed T47 hard/tuning run across RTLLM and VerilogEval problems.
- Generated `techniques/T47_t26_contract_probe/hard_tuning_package/` with
  per-seed problem metrics, aggregate metrics, comparison deltas, relaxed
  validity gates, candidate-level PPA data, four figures, and visual
  inspection notes.
- Exact T26 QD is diagnostic but not held-out-ready: mean HV delta is
  `-0.015483`, mean HV-AUC delta is `-0.018435`, mean best-score delta is
  `+0.024728`, valid-PPA candidates are `428` versus `538`, and aggregate
  PPA-front points are `53` versus `61`.
- There are no classic-covered valid-PPA losses, but there are `4` yield
  warnings and `4` small-n labels. The next step should be a narrow T26.1
  variant or another lane, not exact T26 held-out escalation.

## T48 Gated Near-Front Fusion Pre-Registration - 2026-06-22 UTC

- Updated the central TODO, technique registry, lane ledger, lineage ledger,
  and technique index so T47 is discoverable as a completed `T0` diagnostic,
  not a pending pre-registration.
- Added `techniques/T48_t26_gated_near_front_fusion_qd/` as the next T26.1
  follow-up before any held-out exact-T26 spend.
- T48 keeps the T47 SR raw descriptor, local Pareto archive, champion lane,
  hard/tuning subset, and two seeds, but adds a planned
  `qd_two_parent_gate=near_front_descriptor` option with
  `qd_two_parent_probability=0.10`.
- The planned gate accepts two-parent fusion only when both parents are valid
  archive members, both are NSGA-II rank `1` or `2`, and their squared
  `sr_pca_3d` descriptor distance is at most `6.75`. Otherwise it falls back
  to the existing one-parent success path and records the fallback.
- No live T48 result is claimed yet. The next step is a narrow implementation
  plus focused tests before launching the hard/tuning QD arm.

## T48 Gated Near-Front Fusion Implementation - 2026-06-22 UTC

- Added opt-in `qd_two_parent_gate=near_front_descriptor` support through
  `scripts/run_backend.py`, `RevolutionBackendConfig`, and `QDEngine`.
- The default remains `none`, preserving exact T26/T47 behavior unless the new
  flag is passed.
- The near-front gate accepts a two-parent request only when both archive
  parents are valid, rank `1` or `2` under existing NSGA-II ranking, and within
  squared descriptor distance `6.75`. It records gate attempts, accepts,
  rejects, and one-parent fallbacks in QD summaries.
- Focused validation passed:
  `uv run pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py -q`
  with `58 passed`; `uv run ruff check` on touched files; `ty` and `pyright`
  on touched source modules; and `git diff --check`.
- Broader `ty` and `pyright` runs including `scripts/run_backend.py` and the
  full modified tests still report older type debt around the run-backend
  evaluator union and broad test `**kwargs` helpers. The T48 source modules
  type-check cleanly in isolation.
- No live T48 sampling has been launched yet. The next step is the two-seed
  hard/tuning QD arm in `commands/hard_tuning_sanity.md`.

## T48 Gated Near-Front Fusion Seed 1001 Launch - 2026-06-22 UTC

- Launched seed `1001` for the T48 QD arm at:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`.
- The run passed the local vLLM preflight against
  `http://20.0.0.103:8000/v1/models`; the endpoint reported
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Runtime arguments match `commands/hard_tuning_sanity.md`: hard/tuning
  subset, `population_size=12`, `num_generations=3`,
  `qd_two_parent_probability=0.10`, and
  `qd_two_parent_gate=near_front_descriptor`.
- The run is still in progress. Do not package or tier T48 until the process
  exits cleanly and the archive summaries are validated.

## T48 Gated Near-Front Fusion Seed 1001 Completion - 2026-06-22 UTC

- Seed `1001` completed with exit code `0` after `1572.27` seconds.
- The run produced `13/13` `archive_summary.json` files and `13/13`
  `qd_metrics.json` files.
- The runner's summary best-status count is `11` success and `2` failed, but
  both summary-level failed problems still have valid PPA artifacts and
  global-Pareto candidates.
- Against T47 classic seed `1001`, the summary best-score comparison is
  `3` wins, `3` losses, `5` ties, and `2` missing summary best scores.
  The two missing summary best scores are `Prob024_fsm` and
  `Prob151_review2015_fsm`.
- `Prob024_fsm` has two T48 global-Pareto PPA candidates and matches the
  T47 classic best score. `Prob151_review2015_fsm` has one T48 global-Pareto
  PPA candidate, but it is worse than the T47 classic best score.
- Gate counters from `qd_metrics.json` latest snapshots: `21` two-parent
  attempts, `6` near-front gate attempts, `5` gate accepts, `1` gate reject,
  and `16` one-parent fallbacks after two-parent requests.
- No T48 tier is assigned yet. The next step is seed `1002`, then paired
  packaging with direct PPA-front inspection and validity-gate analysis.

## T48 Gated Near-Front Fusion Seed 1002 Launch - 2026-06-22 UTC

- Launched seed `1002` in the same T48 run root:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning`.
- The preflight snapshot is
  `preflight/models_seed1002_20260622_232737_UTC.json`; the in-command
  vLLM preflight again accepted `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- Runtime arguments match seed `1001` except for `--seed 1002` and
  `--save_path .../seed_1002`.
- The seed is in progress and has created the expected config, run-log, and
  Gen0 problem directories. Do not package T48 until it exits.

## T48 Gated Near-Front Fusion Completion - 2026-06-22 UTC

- Seed `1002` completed with exit code `0` after `1593.16` seconds.
- The final T48 run has `13/13` archive summaries and `13/13` QD metrics for
  both seeds.
- Added `scripts/package_t48_gated_probe.py` and a focused test to package
  the split-root T48 comparison against T47 classic roots.
- The hard/tuning package is:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T48_t26_gated_near_front_fusion_qd/hard_tuning_package/`.
- Aggregate result versus classic: mean HV `-9.5%`, HV-AUC `-17.9%`, mean
  best score `+2.3%`, valid-PPA count `-16.0%`, and PPA-front points
  `-16.4%`.
- T48 has no classic-covered valid-PPA design loss, but has three valid-PPA
  yield warnings where classic has enough samples for the warning to matter.
- Tier decision: `T0 diagnostic`. Near-front gated fusion mitigates parts of
  T47 exact T26, but does not clear the active goal's T1+ guardrail.
- Generated the direct PPA supplement at
  `visualizations/direct_ppa_pareto/index.html`.
- Generated a Phase 03.1 viewer at `visualizations/qd_ppa_viewer/index.html`.
  Non-strict validation passes. Strict validation fails because classic
  candidates cannot be honestly projected into learned `sr_pca_3d` archive
  cells from raw graph/RTL metrics, so the viewer was exported with
  `--no-classic-descriptor-recovery`.

## Central T48 Navigation Sync - 2026-06-23 UTC

- Updated the local index, current results matrix, technique registry, lane
  ledger, lineage ledger, and TODO to stop treating T48 as pending.
- Recorded T48 as `T0 diagnostic after review`: zero classic-covered
  valid-PPA losses and partial improvement over exact T26, but negative mean
  HV, mean HV-AUC, valid-PPA count, and aggregate front-count deltas versus
  classic on the hard/tuning contract surface.
- Recorded the next direction: do not spend held-out budget on exact T26 or
  gated T26.1. The next same-family method needs a role-separated champion,
  local-rank-1, and bounded-repair emitter/archive follow-up.

## T49 Thought-K Role-Separated Repair Method Card - 2026-06-23 UTC

- Added `T49_thought_k_role_separated_repair_qd` as the next T48 follow-up.
- The method uses existing engine surfaces rather than adding another parent
  knob: `thought_only`, `single_thought_operator`, `code_samples_per_thought=3`,
  `population_size=9`, bounded sample-local repair, NSGA-II archive parent
  selection, and `qd_champion_lane_fraction=0.80`.
- The pre-registered budget caps each generation at nine base code samples
  plus at most three repair attempts, matching the T47/T48 twelve-candidate
  scale while making repair cost explicit.
- The method intentionally disables two-parent fusion and broad fail-feedback
  prompt injection. It tests role separation rather than another T26.1 fusion
  probability or gate variant.
- Next step: run seed `1001` on the T47/T48 hard/tuning comparator surface and
  package repair counters, validity gates, HV/HV-AUC, and direct raw-PPA
  figures before considering seed `1002`.

## T49 Thought-K Role-Separated Repair Launch - 2026-06-23 UTC

- Launched seed `1001` under:
  `exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning`.
- The recorded preflight snapshot is
  `preflight/models_20260623_003408_UTC.json`; the endpoint accepted
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Runtime arguments match the committed T49 method card: thought-only
  representation, three code samples per thought, bounded one-attempt repair,
  no two-parent fusion, no fail-feedback prompt injection, SR-PCA descriptors,
  and the T47/T48 thirteen-problem hard/tuning surface.
- First audit checkpoint found `11/13` problem-level `qd_metrics.json` files.
  The run is still in progress, so no quality or tier conclusion is recorded
  yet.

## T49 Thought-K Role-Separated Repair Completion - 2026-06-23 UTC

- Seed `1001` completed with exit code `0` after `3270.46` seconds.
- Packaged the matched hard/tuning comparison under
  `techniques/T49_thought_k_role_separated_repair_qd/hard_tuning_package/`.
- Added the direct PPA supplement under
  `techniques/T49_thought_k_role_separated_repair_qd/visualizations/direct_ppa_pareto/`
  with a Playwright screenshot.
- Tier decision: `T0 mixed_diagnostic`. T49 preserves all classic-covered
  valid-PPA designs and improves mean best score by `+0.067203`, but loses
  mean HV (`-0.005704`), valid-PPA count (`231` versus `257`), aggregate front
  points (`20` versus `30`), unique PPA points (`76` versus `87`), and
  reference-beating candidates (`40` versus `46`).
- Next step: do not launch held-out spend or seed `1002` from this result
  without a front-preserving follow-up design.

## T50 Candidate-Matched Thought Front Method Card - 2026-06-23 UTC

- Added `T50_candidate_matched_thought_front_qd` as the direct T49 follow-up.
- The method keeps the T49 SR-PCA descriptor, thought-only representation,
  single-thought operator, champion lane, NSGA-II parent selection, no
  two-parent fusion, no fail-feedback prompt injection, and the same
  hard/tuning surface.
- The method changes three visible candidate-budget/front-retention controls:
  `population_size=12`, `code_samples_per_thought=3`, `repair_kind=none`, and
  `qd_max_elites_per_cell=8`.
- Rationale: T49 generated fewer base code candidates than classic/T47/T48, so
  T50 must determine whether thought-only role separation still loses front
  material when the evaluated-candidate budget is matched and local Pareto
  retention is widened. T50 is not LLM-call or token matched unless post-run
  accounting proves parity.
- Next step: run seed `1001`, package against the T47 classic roots and T49
  diagnostic package, then decide whether seed `1002` is justified.

## T50 Candidate-Matched Thought Front Partial Result - 2026-06-23 UTC

- Launched seed `1001` under:
  `exp/useful_bd_push/t50_candidate_matched_thought_front_20260623_020738_UTC/hard_tuning`.
- The preflight snapshot accepted `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- The run produced `12/13` planned problem artifacts. `Prob153_gshare` did
  not produce a problem directory, and most completed QD problem roots missed
  final `*_summary.json` files.
- Added partial-run packaging support in
  `src/revolution/qd/pareto_analysis.py` and
  `scripts/package_t48_gated_probe.py`, with focused tests, so the package can
  derive the required summary subset from `generation_log.jsonl` without
  editing raw experiment artifacts.
- Packaged the partial 12-problem comparison under
  `techniques/T50_candidate_matched_thought_front_qd/hard_tuning_package/`.
- Added family comparison tables against T47/T48/T49 on the same completed
  12-problem subset:
  `tables/t50_family_comparison_12_problem_subset.csv` and
  `tables/t50_family_deltas_12_problem_subset.csv`.
- Added the direct PPA supplement under
  `visualizations/direct_ppa_pareto/` with a Playwright screenshot.
- Tier decision: `T0 diagnostic_rejected_for_promotion`. T50 improves mean
  best score by `+0.063433`, but loses mean HV (`-0.026686`), mean HV-AUC
  (`-0.029095`), valid-PPA candidates (`156` versus `244`), aggregate front
  points (`18` versus `26`), unique PPA points (`47` versus `79`), and
  reference-beating candidates (`26` versus `45`).
- Next step: do not run T50 seed `1002` or held-out spend. Specify a new
  front/yield-preserving emitter that keeps the best-score pressure without
  collapsing valid-PPA and front material.

## RTLLM Formal Final-Analysis Supplement - 2026-06-23 UTC

- Added `presentations/20260623_report/full_rtllm/final_analysis/` as a
  supplemental `scripts/report_final_analysis_bundle.py` output for the full
  one-seed RTLLM milestone.
- The bundle uses `rtllm_reference_complete_subset.yaml`, a 46-problem subset
  that excludes `Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
  `Prob018_float_multi`, and `Prob040_synchronizer` because at least one arm
  lacks reference `area` required by the generic PPA-distribution report.
- `backend_comparison.md` still scans all 50 backend summaries and reports
  `N/A` where reference fields are missing.
- The formal bundle recommends `classic_revolution` for overall,
  multi-objective, and Pareto winner. It recommends
  `sr_raw_conservative_exploit_qd` only on score-QD and archive-QD report
  surfaces.
- Visual inspection found the aggregate design-space and feature figures
  readable, but some generated per-problem Pareto figures have title/legend
  crowding. The formal bundle is an audit supplement, not the primary
  presentation-facing figure source.
- Interpretation: this reinforces the diagnostic presentation stance. Exact
  T26 has archive/front signal, but the current one-seed RTLLM package does
  not prove a positive QD-effectiveness claim over classic.

## T51 Code-Thought Front-Slot Method Card - 2026-06-23 UTC

- Added `T51_code_thought_front_slot_qd` as the direct follow-up to T50.
- The method keeps the T47-T50 hard/tuning surface, SR-PCA descriptor, seed
  policy, local vLLM model, 128k token budgets, no two-parent fusion, and no
  repair loop.
- The method changes the mechanism instead of rerunning T50: it returns to
  `code_individual` representation, keeps `single_thought_operator`, uses
  `elite_pareto_slot` with one local front slot per cell, and lowers
  grid-quantile warmup to `4` based on the T39 sparse-yield result.
- The method is explicitly a composite rescue. A positive seed `1001` result
  would justify an ablation matrix before seed `1002` or held-out spend.
- Next step: preflight the vLLM endpoint, launch T51 seed `1001`, then package
  against the T47 classic hard/tuning roots and T47-T50 QD packages.

## T51 Code-Thought Front-Slot Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T51 seed `1001` on the 13-problem hard/tuning surface in
  `1664.77` seconds:
  `exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001`.
- Validation passed:
  `pareto_front_validation.md` reports `failure_count=0`, and
  `single_thought_operator_validation.md` reports `failure_count=0`.
- Packaged results under
  `techniques/T51_code_thought_front_slot_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T51_code_thought_front_slot_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T51_code_thought_front_slot_qd/visualizations/qd_ppa_viewer/`.
- Non-strict Phase 03.1 validation passed. Strict validation failed because
  classic candidates have no honest `sr_pca_0/1/2` archive projection.
- Tier decision: `T0 positive_ablation_not_promoted`. T51 restores the full
  candidate budget and beats classic on valid-PPA count (`266` versus `257`),
  HV-AUC (`0.085454` versus `0.082020`), and best score (`0.293480` versus
  `0.227928`), but loses mean HV (`0.089252` versus `0.092601`) and front
  points (`21` versus `30`).
- Against T50 on the same 12 completed problems, T51 improves generated
  candidates (`576` versus `336`), valid-PPA (`245` versus `156`), mean HV
  (`0.096588` versus `0.073617`), HV-AUC (`0.092549` versus `0.059753`),
  unique PPA points (`60` versus `47`), and reference-beating candidates
  (`39` versus `26`).
- Next step: keep T51's code-individual yield recovery, but add a stronger
  front-preserving mechanism before seed `1002` or held-out spend.

## T52 Code-Thought Full-Pareto Method Card - 2026-06-23 UTC

- Added `T52_code_thought_full_pareto_qd` as the direct front-breadth ablation
  of T51.
- The method keeps T51's hard/tuning surface, seed policy, local vLLM model,
  128k token budgets, SR-PCA descriptor, direct code representation,
  `single_thought_operator`, sparse warmup `4`, champion lane `0.80`,
  NSGA-II parent selection, no repair, and no two-parent fusion.
- The only live-search change is the archive cell rule: T52 uses
  `qd_cell_mode=pareto_front` and `qd_max_elites_per_cell=5` instead of T51's
  one-slot `elite_pareto_slot` with capacity `2`.
- This directly tests whether T51's remaining front-breadth loss came from
  too little local Pareto retention. It is not a new BD and must not be treated
  as proof that the code-thought operator itself is sufficient.
- Next step: preflight the vLLM endpoint, run T52 seed `1001`, validate the
  single-thought and Pareto artifacts, then package against the T47 classic
  and T51 hard/tuning results.

## T52 Code-Thought Full-Pareto Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T52 seed `1001` on the 13-problem hard/tuning surface in
  `1666.96` seconds:
  `exp/useful_bd_push/t52_code_thought_full_pareto_20260623_035857_UTC/hard_tuning/code_thought_full_pareto_qd/seed_1001`.
- Validation passed:
  `pareto_front_validation.md` reports `failure_count=0`, and
  `single_thought_operator_validation.md` reports `failure_count=0`.
- Packaged results under
  `techniques/T52_code_thought_full_pareto_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T52_code_thought_full_pareto_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T52_code_thought_full_pareto_qd/visualizations/qd_ppa_viewer/`.
- Non-strict Phase 03.1 validation passed. Strict validation failed because
  classic candidates have no honest `sr_pca_0/1/2` archive projection.
- Tier decision: `T0 diagnostic_retired_full_pareto`. T52 adds front points
  versus T51 (`24` versus `21`) and unique PPA points (`76` versus `75`), but
  loses T51's valid-PPA count (`254` versus `266`), mean HV (`0.083502`
  versus `0.089252`), HV-AUC (`0.055792` versus `0.085454`), and best score
  (`0.242261` versus `0.293480`).
- Against classic, T52 loses mean HV by `-0.009099`, HV-AUC by `-0.026228`,
  valid-PPA count by `-3`, front points by `-6`, unique PPA points by `-11`,
  and reference-beating candidates by `-5`, while improving mean best score by
  `+0.014333`.
- Next step: do not spend seed `1002` on this exact full-Pareto widening.
  Keep T51's one-slot/yield behavior and specify any follow-up as a bounded
  front-pressure trigger that avoids in-loop classic results and final-front
  labels.

## T53 Sparse-Front Trigger Method Card - 2026-06-23 UTC

- Added `T53_sparse_front_trigger_qd` as the direct follow-up to T52.
- The method keeps T51's hard/tuning surface, seed policy, local vLLM model,
  128k token budgets, SR-PCA descriptor, direct code representation,
  `single_thought_operator`, sparse warmup `4`, `elite_pareto_slot` capacity
  `2`, no repair, and no two-parent fusion.
- The only live-search change is parent selection:
  `qd_parent_selection=sparse_front_triggered_nsga2`.
- The trigger uses the same NSGA-II global-rank parent pool as T51. When the
  active one-slot archive has at least four occupied cells and fewer than two
  extra local-front slots, it lowers the champion lane from `0.80` to `0.65`
  for that parent-sampling call.
- The trigger is not allowed to use classic results, held-out outcomes,
  problem identity, final PPA-front labels, or reference PPA as a descriptor
  or trigger input.
- Next step: preflight the vLLM endpoint, run T53 seed `1001`, validate
  single-thought and Pareto artifacts, then package against T47 classic, T51,
  and T52.

## T53 Sparse-Front Trigger Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T53 seed `1001` on the 13-problem hard/tuning surface in
  `1592.24` seconds:
  `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd/seed_1001`.
- Validation passed:
  `pareto_front_validation.md` reports `failure_count=0`, and
  `single_thought_operator_validation.md` reports `failure_count=0`.
- Packaged results under
  `techniques/T53_sparse_front_trigger_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T53_sparse_front_trigger_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T53_sparse_front_trigger_qd/visualizations/qd_ppa_viewer/`.
- Non-strict Phase 03.1 validation passed. Strict validation failed because
  classic candidates have no honest `sr_pca_0/1/2` archive projection.
- Tier decision: `T0 diagnostic_not_promoted`. T53 preserves every
  classic-covered design and improves best score (`0.290435` versus
  `0.227928`), but loses valid-PPA count (`239` versus `257`), mean HV
  (`0.085793` versus `0.092601`), HV-AUC (`0.071011` versus `0.082020`),
  front points (`22` versus `30`), unique PPA points (`71` versus `87`), and
  reference-beating candidates (`38` versus `46`).
- The sparse-front trigger fired 25 times, so this was not a no-op. The result
  argues against further scalar champion-lane tuning as the next escalation.

## T54 Front-Slot Lane Method Card - 2026-06-23 UTC

- Added `T54_front_slot_lane_qd` as the direct follow-up to T53.
- The method keeps T51's hard/tuning surface, seed policy, local vLLM model,
  128k token budgets, SR-PCA descriptor, direct code representation,
  `single_thought_operator`, sparse warmup `4`, `elite_pareto_slot` capacity
  `2`, champion lane `0.80`, no repair, and no two-parent fusion.
- The only live-search change is parent selection:
  `qd_parent_selection=front_slot_lane_nsga2`.
- The new mode reserves a fixed 10 percent of archive parent requests for
  non-elite members retained inside `elite_pareto_slot` cells. Those members
  are local front slots, not the scalar quality elite for that cell.
- If no local front slot exists, the request falls back to T51-style champion
  and global NSGA-II parent sampling.
- The lane cannot use classic results, held-out outcomes, problem identity,
  final PPA-front labels, reference PPA, final hypervolume, or test pass rate
  as descriptor or lane inputs.
- Focused validation before launch passed:
  `uv run pytest tests/revolution/test_qd_engine.py`, `uv run ruff check` on
  touched files, and `uv run python -m pyright src/revolution/qd/engine.py`.
- `uv run python -m pyright scripts/run_backend.py` still reports the
  pre-existing evaluator union diagnostics at lines 305 and 339; the T54 CLI
  choice does not touch that evaluator construction path.
- `uv tool run ty check src/revolution/qd/engine.py` passed.
- Next step: commit the code/docs checkpoint, preflight the vLLM endpoint, run
  T54 seed `1001`, validate single-thought and Pareto artifacts, then package
  against T47 classic, T51, T52, and T53.

## T54 Front-Slot Lane Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T54 seed `1001` on the 13-problem hard/tuning surface in
  `1713.07` seconds:
  `exp/useful_bd_push/t54_front_slot_lane_20260623_054428_UTC/hard_tuning/code_thought_front_slot_lane_qd/seed_1001`.
- Validation passed:
  `pareto_front_validation.md` reports `failure_count=0`, and
  `single_thought_operator_validation.md` reports `failure_count=0`.
- Packaged results under
  `techniques/T54_front_slot_lane_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T54_front_slot_lane_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T54_front_slot_lane_qd/visualizations/qd_ppa_viewer/`.
- Phase 03.1 strict schema validation passed. The optional Playwright smoke
  produced screenshots but failed compare-guide and archive-hover checks; the
  exact caveat is recorded in
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Visual inspection passed after regenerating
  `hard_tuning_package/figures/t54_operator_counters.png` with shorter labels
  and recapturing the direct-PPA browser screenshot.
- Tier decision: `T0 diagnostic_not_promoted`. T54 preserves every
  classic-covered valid-PPA design and improves mean best score (`0.263027`
  versus `0.227928`), but loses valid-PPA count (`253` versus `257`), mean HV
  (`0.075892` versus `0.092601`), HV-AUC (`0.062753` versus `0.082020`),
  front points (`21` versus `30`), unique PPA points (`67` versus `87`), and
  reference-beating candidates (`31` versus `46`).
- Against T51, T54 loses HV (`-0.013360`), HV-AUC (`-0.022701`), best score
  (`-0.030453`), valid-PPA count (`-13`), unique PPA count (`-8`), and
  reference-beating count (`-12`) while tying aggregate front points.
- The front-slot lane was active but weak: `12` requests produced `4` hits.
  This retires the immediate T51/T52/T53/T54 parent-lane lineage unless the
  next method changes how front slots are created.

## T55 Coarse SR2 Front-Slot Method Card - 2026-06-23 UTC

- Added `T55_coarse_sr2_front_slot_qd` as the direct mechanism follow-up to
  T54's sparse slot pool.
- T55 keeps T54's hard/tuning surface, seed policy, local vLLM model, 128k
  token budgets, SR-PCA descriptor file, direct code representation,
  `single_thought_operator`, sparse warmup `4`, `elite_pareto_slot` capacity
  `2`, champion lane `0.80`, fixed 10 percent front-slot parent lane, no
  repair, and no two-parent fusion.
- The only live-search change is archive geometry:
  `--qd_descriptor_axes sr_pca_0 sr_pca_1`. T54 used the implicit three-axis
  SR-PCA grid-quantile archive. T55 intentionally drops `sr_pca_2` so
  descriptor cells are coarser and can form more local front slots.
- This is not a new PPA-informed BD. The grid axes are descriptor coordinates
  computed before PPA is known. Evaluated PPA is used only after evaluation
  for archive retention and NSGA-II parent ranking, as in T47 through T54.
- Adversarial review caught that `--qd_grid_axes` would not affect
  `grid_quantile`; T55 must use `--qd_descriptor_axes` and must prove the
  emitted `descriptor_axes` are exactly `sr_pca_0` and `sr_pca_1` before live
  spend.
- Next step: commit the pre-run package, preflight the vLLM endpoint, run T55
  seed `1001`, validate single-thought and Pareto artifacts, then package
  against T47 classic and T51 through T54.

## T55 Coarse SR2 Front-Slot Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T55 seed `1001` on the 13-problem hard/tuning surface in `1593.98`
  seconds:
  `exp/useful_bd_push/t55_coarse_sr2_front_slot_20260623_064153_UTC/hard_tuning/code_thought_coarse_sr2_front_slot_qd/seed_1001`.
- Validation passed for the single-thought operator and Pareto/front archive
  checks with `--require-full-subset`.
- Verified all 13 emitted archive spaces use exactly
  `descriptor_axes == ["sr_pca_0", "sr_pca_1"]`.
- Packaged results under
  `techniques/T55_coarse_sr2_front_slot_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T55_coarse_sr2_front_slot_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T55_coarse_sr2_front_slot_qd/visualizations/qd_ppa_viewer/`.
- Patched the canonical Phase 03.1 viewer template so two-axis archive
  datasets render as a `4 x 4 x 1` slab instead of crashing when the third
  descriptor axis is absent.
- Phase 03.1 strict schema validation passed. The optional Playwright smoke
  generated screenshots but failed deeper compare and hover checks; the exact
  caveat is recorded in
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Visual inspection passed after regenerating
  `hard_tuning_package/figures/t55_operator_counters.png` as a horizontal bar
  chart and recapturing the direct-PPA browser screenshot.
- Tier decision: `T0 positive_mechanism_ablation_not_promoted`. T55 improves
  T54 slot activity (`9` hits versus `4`) and removes T54's yield warnings
  (`0` versus `2`), but still loses classic on mean HV (`0.086189` versus
  `0.092601`), HV-AUC (`0.072307` versus `0.082020`), valid PPA (`233`
  versus `257`), front points (`23` versus `30`), unique PPA (`72` versus
  `87`), and reference-beating candidates (`36` versus `46`).
- Against T51, T55 loses HV (`-0.003063`), HV-AUC (`-0.013147`), best score
  (`-0.029412`), and valid-PPA count (`-33`) while adding two front points.
- Do not run seed `1002` for exact T55. The next live arm should either
  isolate coarse geometry with a T51-control ablation or switch mechanisms to
  exact T11 runtime projection / learned auxiliary archive lanes with
  front-yield protection.

## T56 Coarse SR2 T51-Control Method Card - 2026-06-23 UTC

- Added `T56_coarse_sr2_t51_control_qd` as the geometry-isolation follow-up to
  T55.
- T56 keeps T51's hard/tuning surface, seed policy, local vLLM model, 128k
  token budgets, direct code representation, `single_thought_operator`, sparse
  warmup `4`, `elite_pareto_slot` capacity `2`, champion lane `0.80`,
  `qd_parent_selection=nsga2_global_rank`, no repair, and no two-parent
  fusion.
- The only live-search change from T51 is archive geometry:
  `--qd_descriptor_axes sr_pca_0 sr_pca_1`.
- T56 intentionally removes T55's `front_slot_lane_nsga2` fixed parent lane.
  This isolates whether two-axis SR-PCA grid-quantile cells help T51 directly
  or whether T55's improved slot-hit counter was not enough to justify the
  coarse-geometry branch.
- Acceptance requires preserving every classic-covered valid-PPA design,
  avoiding a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples, improving T51 on at least two primary metrics, and not
  losing T55's front-point recovery by more than one point.
- Pre-run descriptor probe passed:
  `uv run python scripts/qd_descriptor_probe.py --profile sr_pca_3d --axes sr_pca_0 sr_pca_1 --descriptor_file ... --archive_type grid_quantile --circuit_type sequential`
  resolved exactly `["sr_pca_0", "sr_pca_1"]` and reported
  `requires_ppa=false`.
- Next step: commit the pre-run package, preflight the vLLM endpoint, run T56
  seed `1001`, validate single-thought and Pareto artifacts, then package
  against T47 classic, T51, and T55.

## T56 Coarse SR2 T51-Control Result - 2026-06-23 UTC

- Preflight passed against `http://20.0.0.103:8000/v1/models` with
  `openai/gpt-oss-120b max_model_len=131072`.
- Ran T56 seed `1001` on the 13-problem hard/tuning surface in `1598.41`
  seconds:
  `exp/useful_bd_push/t56_coarse_sr2_t51_control_20260623_074326_UTC/hard_tuning/code_thought_coarse_sr2_t51_control_qd/seed_1001`.
- Validation passed for the single-thought operator and Pareto/front archive
  checks with `--require-full-subset`.
- Verified all 13 emitted archive spaces use exactly
  `descriptor_axes == ["sr_pca_0", "sr_pca_1"]`.
- Packaged results under
  `techniques/T56_coarse_sr2_t51_control_qd/hard_tuning_package/`.
- Added direct PPA supplement under
  `techniques/T56_coarse_sr2_t51_control_qd/visualizations/direct_ppa_pareto/`
  and a full Phase 03.1 viewer under
  `techniques/T56_coarse_sr2_t51_control_qd/visualizations/qd_ppa_viewer/`.
- Phase 03.1 strict schema validation passed. The optional Playwright smoke
  generated screenshots but reported compare and hover warnings; the caveat is
  recorded in `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Visual inspection passed for the direct PPA HTML screenshot and the full
  Phase 03.1 compare-mode screenshot. The operator-counter figure is
  intentionally empty because T56 disables success-parent and two-parent lanes.
- Tier decision: `T0 diagnostic_retire_coarse_sr2_geometry`. T56 preserves
  every classic-covered valid-PPA design, but loses classic on mean HV
  (`0.082056` versus `0.092601`), HV-AUC (`0.069095` versus `0.082020`),
  valid PPA (`231` versus `257`), front points (`22` versus `30`), unique PPA
  (`66` versus `87`), and reference-beating candidates (`35` versus `46`).
- Against T51, T56 loses HV (`-0.007196`), HV-AUC (`-0.016359`), best score
  (`-0.024855`), valid PPA (`-35`), unique PPA (`-9`), and reference-beating
  candidates (`-8`) while adding only one front point.
- Retire coarse SR2 archive geometry as a primary path. The next method should
  switch mechanisms to exact T11 runtime projection, learned auxiliary archive
  lanes, or a front-yield protected emitter before any seed `1002`.

## T57 T51 Adaptive-Rebin Method Card - 2026-06-23 UTC

- Added `T57_t51_adaptive_rebin_qd` as the first post-SR2 mechanism change.
- T57 keeps T51's hard/tuning surface, seed policy, local vLLM model, 128k
  token budgets, SR-PCA descriptor file, direct code representation,
  `single_thought_operator`, sparse warmup `4`, `elite_pareto_slot` capacity
  `2`, champion lane `0.80`, `nsga2_global_rank` parent selection, no repair,
  and no two-parent fusion.
- The only live-search change is archive adaptation:
  `--qd_rebinning_kind ks_triggered`, `--qd_rebinning_recent_generations 1`,
  `--qd_rebinning_min_archive_members 8`,
  `--qd_rebinning_cooldown_generations 2`, and
  `--qd_rebinning_base_p_threshold 0.05`.
- The rebin trigger compares archive-member descriptor values against recent
  archiveable samples by KS test and Bonferroni threshold. It does not use
  final PPA, reference PPA, hypervolume, Pareto-front labels, classic results,
  or test-pass outcomes as descriptor inputs or trigger labels.
- Pre-run descriptor probe passed:
  `uv run python scripts/qd_descriptor_probe.py --profile sr_pca_3d --descriptor_file ... --archive_type grid_quantile --circuit_type sequential`
  resolved exactly `["sr_pca_0", "sr_pca_1", "sr_pca_2"]` and reported
  `requires_ppa=false`.
- Next step: commit the pre-run package, preflight the vLLM endpoint, run T57
  seed `1001`, validate single-thought, Pareto/front, and adaptive-rebinning
  artifacts, then package against T47 classic, T51 off-mode, and T56.

## T57 T51 Adaptive-Rebin Result - 2026-06-23 UTC

- Preflight passed against the local vLLM endpoint:
  `openai/gpt-oss-120b max_model_len=131072`.
- T57 raw run:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/t51_adaptive_rebin_qd/seed_1001`.
- The run completed all 13 hard/tuning problems in `1811.33` seconds.
- Single-thought and Pareto/front validators passed with
  `--require-full-subset`.
- Adaptive-rebinning validation wrote diagnostics and returned invalid:
  `26` rebin checks, `0` rebin events, and localized evidence was
  inconclusive because the selected collapsed/localized case did not improve
  healthy or occupied cells.
- Aggregate T57 versus classic: HV `-0.016790`, HV-AUC `-0.011599`, best
  score `+0.033800`, valid PPA `-12`, front points `-7`, unique PPA points
  `-12`, reference-beating candidates `-7`.
- T57 versus T51: HV `-0.013441`, HV-AUC `-0.015033`, best score
  `-0.031752`, valid PPA `-21`, front points `+2`, unique PPA points `0`,
  reference-beating candidates `-4`.
- T57 has one classic-covered valid-PPA loss: `Prob151_review2015_fsm`.
- Packaged result:
  `techniques/T57_t51_adaptive_rebin_qd/hard_tuning_package/`.
- Direct PPA supplement:
  `techniques/T57_t51_adaptive_rebin_qd/visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `techniques/T57_t51_adaptive_rebin_qd/visualizations/qd_ppa_viewer/index.html`.
- Strict viewer validation passed. Playwright generated screenshots but
  reported the caveat documented in
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Decision: mark T57 `T0 diagnostic_no_rebin_signal`; do not spend seed
  `1002` on exact T57. Move to exact T11 runtime projection, learned auxiliary
  archive lanes, or a front-yield protected emitter.

## T58 T51 T11-PCA4 Front-Slot Method Card - 2026-06-23 UTC

- Created `techniques/T58_t51_t11_pca4_front_slot_qd/` as the next
  pre-registered hard/tuning method after T57.
- T58 keeps T51's code-individual representation, single-thought operator,
  `elite_pareto_slot` archive, warmup `4`, champion lane `0.80`,
  `nsga2_global_rank` parent selection, no repair, and no two-parent fusion.
- T58 changes only the descriptor profile from T51's SR-PCA axes to the frozen
  T46/T11 graph projection profile `t11_runtime_pca4_graph`.
- The intended test is whether the stronger T51 emitter can make the T11 PCA4
  graph projection useful after T44-T46 showed graph descriptors had local
  signal but weak aggregate live results on the older substrate.
- Descriptor probe passed: the profile resolves to
  `t11_runtime_pca_0..3`, reports `requires_ppa=false`, and reports
  `requires_graph_metrics=true`.
- Next step: preflight the vLLM endpoint, then run seed `1001`.

## T58 T51 T11-PCA4 Front-Slot Result - 2026-06-23 UTC

- Preflight passed against the local vLLM endpoint:
  `openai/gpt-oss-120b max_model_len=131072`.
- T58 raw run:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001`.
- The run completed all 13 hard/tuning problems in `1808.04` seconds.
- Single-thought and Pareto/front validators passed with
  `--require-full-subset`.
- Aggregate T58 versus classic: HV `-0.016348`, HV-AUC `-0.015787`, best
  score `+0.021823`, valid PPA `+9`, front points `-8`, unique PPA points
  `-16`, reference-beating candidates `-12`.
- T58 versus T51: HV `-0.012999`, HV-AUC `-0.019221`, best score
  `-0.043729`, valid PPA tie, front points `+1`, unique PPA points `-4`,
  reference-beating candidates `-9`.
- Bounded T46 overlap: T58 improves valid PPA (`44` versus `37`) and mean best
  score (`0.297560` versus `0.276800`) on the three shared RTLLM problems, but
  does not improve front breadth (`5` versus `6` area-power/front points).
- Packaged result:
  `techniques/T58_t51_t11_pca4_front_slot_qd/hard_tuning_package/`.
- Direct PPA supplement:
  `techniques/T58_t51_t11_pca4_front_slot_qd/visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `techniques/T58_t51_t11_pca4_front_slot_qd/visualizations/qd_ppa_viewer/index.html`.
- Strict viewer validation passed. Playwright generated screenshots but
  reported the caveat documented in
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Manual screenshots were inspected for the direct PPA supplement and full
  Phase 03.1 viewer; both render readable, nonblank figures without broken
  assets.
- Decision: mark T58 `T0 diagnostic_no_promotion`; do not spend seed `1002`
  on exact T58. Move graph features to secondary/reporting lanes or a trained
  encoder objective, and make the next live method front-yield protected.

## T59 T51 Feedback Front-Slot Method Card - 2026-06-23 UTC

- Created `techniques/T59_t51_feedback_front_slot_qd/` as the same-budget
  front-yield protected follow-up after T58.
- T59 keeps T51's code-individual representation, single-thought operator,
  SR-PCA descriptor, `elite_pareto_slot` archive, warmup `4`, champion lane
  `0.80`, no repair loop, and no two-parent fusion.
- T59 changes parent selection to T54's `front_slot_lane_nsga2` and enables
  short fail-pool feedback with `qd_operator_fail_feedback_chars=600`.
- This is not bounded local repair. Current bounded repair support is tied to
  the thought-only loop, while T59 deliberately preserves T51's direct-code
  path and evaluated-candidate budget.
- Next step: preflight the vLLM endpoint, then run seed `1001` on the frozen
  13-problem hard/tuning surface.
