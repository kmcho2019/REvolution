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
