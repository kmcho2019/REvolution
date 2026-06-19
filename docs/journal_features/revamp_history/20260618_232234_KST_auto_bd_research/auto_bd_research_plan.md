# Automatic BD Research Plan

Feature slug: `auto_bd_research`

Status: scaffold draft for a future `/goal`; do not treat this as an
activated goal. Start with `START_HERE.md`. This plan is anchored on the
initial intent documents in this directory, `auto_bd_plan_sketch.md` and
`auto_bd_ruminations.md`, and
narrows them into a hard research contract for the
`feat/journal-auto-bd-exp-20260618` worktree.

## Outcome

Develop and evaluate automatic behavior descriptor methods for Smooth-QD
RTL PPA evolution. The purpose is to replace or improve the current
manual descriptor trio:

- combinational logic depth
- FF depth
- log combinational gate count

The final accepted method must preserve the REvolution ability to repair
functionality and reach valid PPA while producing a more defensible QD
archive and materially better PPA or hypervolume evidence.

The preferred initial thesis is:

> RTL behavior for QD should mean implementation behavior under synthesis,
> not raw program text, final PPA, or arbitrary scalar statistics.

The preferred first serious method is ST-NOD:

> Synthesis-Trajectory Netlist Occupancy Descriptor: describe each RTL
> candidate by the synthesized netlist motifs it creates and by how those
> motifs transform across Yosys synthesis stages.

The preferred next AutoQD-inspired method is Synthesis-Response Kernel
MAP-Elites:

> Learn descriptor axes from hardware-native synthesis-response feature
> vectors using frozen random-kernel PCA, without using PPA labels,
> fitness, hypervolume, reference PPA, testbench pass rate, or problem ID
> as descriptor inputs.

## Source Of Truth

- Full plan: `auto_bd_research_plan.md`
- Living checklist: `auto_bd_research_implementation_todo.md`
- Evidence log: `auto_bd_research_implementation_history.md`
- Copy/paste goal text: `goal_template.md`
- Validator prompt: `auto_bd_research_adversarial_prompt.md`
- Validator output: `auto_bd_research_subagent_validation_report.md`
- Benchmark/task lock: `auto_bd_subset_lock.yaml`,
  `auto_bd_task_catalog.md`, `auto_bd_task_catalog.json`
- Run-policy lock: `auto_bd_run_policy_lock.yaml`
- Initial plan sketch: `auto_bd_plan_sketch.md`
- Initial ruminations and goals: `auto_bd_ruminations.md`

## Initial Intent Documents

`auto_bd_plan_sketch.md` and `auto_bd_ruminations.md` are preserved as
the original intent and brainstorming record. They are not the final
contract when they conflict with this plan, but they must be consulted
before narrowing scope, rejecting a method family, or revising the
research question.

## Research Questions

1. Can automatic or hardware-native descriptors outperform Smooth-QD v2's
   manual descriptors under the same RTL generation, simulation,
   synthesis, OpenROAD, model, seed, and budget policy?
2. Can they match original REvolution's valid-PPA problem coverage with no
   missing problem regressions?
3. Can the descriptor space be explained in RTL/netlist/synthesis terms
   that a hardware reviewer would find meaningful?
4. Is the best method simple enough to implement and defend, or does it
   need learned encoders/codebooks to produce a real gain?

## Baselines And Controls

Every serious method must compare against the same fixed benchmark
subset and budget:

1. Original REvolution: code individuals, fail/success pools, six EoH
   operators, no MAP-Elites archive.
2. Landing Smooth-QD manual-BD baseline: code individuals, six EoH
   operators, quantile/Pareto MAP-Elites archive, manual trio descriptors,
   champion lane, and global NSGA-II parent selection. Do not compare
   against the older failed qd_target/original-v2 configuration unless it
   is explicitly labeled as a historical ablation.
3. Random descriptor QD: same Smooth-QD infrastructure, random or hashed
   cell assignment. This is the negative control.
4. Simple Yosys-stat BD: fixed statistics such as gate count, FF count,
   mux count, arithmetic-cell count, fanout statistics, and level
   histograms. This is the strong simple control.

No learned descriptor should be accepted if the Yosys-stat control gives
the same result with clearer rationale and lower complexity.

The landing Smooth-QD manual-BD baseline should be frozen from the current
journal branch configuration. Record exact config values before running,
including representation kind, operator kind, descriptor profile, archive
type, cell mode, objective set, champion-lane fraction, parent selection,
population size, generations, and LLM-call budget.

The active initial freeze is `auto_bd_run_policy_lock.yaml`. It defines
the landing baseline as `grid_quantile_pareto_journal_bd_eoh` with direct
code individuals, EoH strategies, `grid_quantile`,
`journal_logic_ff_width_3d`, Pareto cells, PPA objectives, champion-lane
fraction 0.5, and `nsga2_global_rank` parent selection. If future
evidence changes any locked value, revise the lock by version bump and
record the rationale in the implementation history before running
comparisons.

## Candidate Directions

### Direction 0: Reports And Instrumentation First

Before adding a novel descriptor, build the reporting and artifact
surface needed to judge any descriptor:

- canonical synthesized-netlist hash per valid candidate and elite
- per-method robustness funnel
- per-method PPA, QD, and descriptor-quality tables
- centralized cross-method report
- method card and accept/reject record for every attempted variant

This prevents selective reporting and makes rejected variants useful.

### Direction 1: Yosys-Stat Descriptor

Start with a tiny, deterministic descriptor over Yosys JSON or synthesis
statistics. This is likely not novel enough for the final paper, but it
answers whether the manual trio was simply the wrong set of scalar
statistics.

Accept only if it preserves valid-PPA coverage and improves at least one
PPA or QD gate. Reject if it collapses to gate count, depth, or final
fitness.

### Direction 2: Netlist Motif Occupancy Descriptor

Extract a fixed-length vector from synthesized netlist motifs:

- cell types and mapped gate types
- k-hop fanin/fanout neighborhoods
- PI-to-PO and FF-to-FF pathlets
- mux-heavy, arithmetic-heavy, and control-heavy regions
- reconvergent fanout signatures
- sequential cone balance

Use the motif distribution directly, or reduce it by PCA/random
projection/CVT/quantile binning. This is the simplest AutoQD-inspired
method and should be the first nontrivial implementation.

### Direction 3: ST-NOD

ST-NOD augments motif occupancy with synthesis-stage response. It should
capture how the RTL is transformed by Yosys:

```text
RTL source
RTLIL lowering
process/fsm/memory handling
generic cell mapping
optimization
ABC/AIG optimization
technology mapping
final synthesized netlist
```

Candidate features:

- logic collapse ratio
- mux introduction/removal ratio
- arithmetic preservation/decomposition ratio
- depth shrink/growth
- fanout and reconvergence change
- FF-cone balance change
- shallow-wide versus deep-narrow transition
- control-heavy versus arithmetic-heavy transition

This is the primary journal-candidate direction because it is specific to
generated RTL and synthesis, not a direct port of robotics QD.

### Direction 4: Synthesis-Response Kernel MAP-Elites

This is the first P5 projected/learned candidate and should be attempted
before neural encoders. It uses fixed synthesis-response observations,
a frozen random nonlinear feature map, and PCA/whitening to form the
archive descriptor.

Pipeline:

```text
RTL candidate
normal test/synthesis/PPA path
hardware-native raw feature vector
frozen standardization
fixed random nonlinear feature map
frozen PCA / whitening
MAP-Elites archive insertion
```

Raw features may include:

- final Yosys statistics
- final synthesized-netlist motif occupancy
- ST-NOD trajectory swings
- per-stage motif ratios
- per-stage cell-count deltas
- optional cheap graph/pathlet statistics after the base vector is stable

Raw features must not include:

- PPA, fitness, hypervolume, or reference/golden PPA
- testbench pass percentage
- problem ID as a direct feature

Evaluate variants in this order:

1. `sr_raw_pca_qd`: standardized synthesis-response features plus PCA.
2. `sr_random_relu_pca_qd`: fixed random ReLU expansion plus PCA; main
   AutoQD-style candidate.
3. `sr_rff_pca_qd`: random Fourier features plus PCA; kernel control.
4. `sr_vq_codebook_qd`: VQ/codebook only after PCA variants are
   understood.
5. `sr_contrastive_encoder_qd`: self-supervised learned encoder only if
   the simpler projected methods fail.

The method card must state the fitting protocol, training candidate list,
excluded data, feature schema hash, scaler hash, random-map hash, PCA
component hash, and descriptor version. Every candidate must log those
artifact hashes and the resulting descriptor vector. PCA fitted after
seeing the full evaluation run is post-hoc visualization only and cannot
be claimed as the in-loop descriptor.

The paper rationale should be:

1. manual BDs are low-capacity and arbitrary;
2. final-netlist descriptors miss synthesis-response behavior;
3. ST-NOD captures response but still hand-selects axes;
4. random nonlinear features approximate a broad kernel over hardware
   behavior;
5. PCA extracts independent implementation-variation directions;
6. the archive explores automatically discovered synthesis-behavior modes.

### Direction 5: RTL-Native Contrastive Descriptor

If ST-NOD is promising, test a more novel variant:

> Candidates are behaviorally diverse if synthesis responds to them
> differently, even when they solve the same functional problem.

Possible implementation:

- compute motif/trajectory vectors
- compare candidate vectors to the problem's reference/golden vector when
  available, without using reference PPA
- compare parent-child trajectory deltas
- archive candidates by implementation-style displacement, not raw size

This may produce a clearer paper story: the archive explores
implementation strategies, not only structures.

### Direction 6: AURORA-Style Encoder

Try this only after fixed synthesis-response PCA or kernel-PCA variants
exist and are insufficient. Preferred inputs are tabular motif/trajectory
vectors first, then Yosys JSON graphs only if simpler inputs fail.

Possible encoders:

- MLP autoencoder over motif/trajectory statistics
- graph autoencoder over Yosys JSON
- GNN with global pooling
- lightweight graph transformer

Use the latent vector only as BD input. Do not use PPA, reference PPA, or
fitness as encoder inputs.

### Direction 7: VQ / Implementation-Style Codebook

Learn a finite codebook of implementation styles and use codebook IDs or
codebook coordinates as archive cells. This may be more interpretable
than a continuous latent space because cells can be labeled after the
run:

- mux-heavy
- arithmetic-preserving
- arithmetic-decomposed
- shallow-parallel
- compact-serialized
- control-dominated
- logic-collapsed
- FF-cone-balanced

This should run only after the fixed vector representation is stable.

## Benchmark Subsets

Choose benchmark subsets from RTLLM and VerilogEval. Do not tune on the
held-out subset.

Required subsets:

- Development subset: 4-6 fast problems, at least one combinational and
  one sequential design.
- Main evaluation subset: 12-20 problems, balanced across RTLLM and
  VerilogEval, and balanced across combinational, control, arithmetic,
  FSM-like, and sequential tasks.
- Held-out validation subset: 6-10 problems, unused until the final
  method is selected.

The subset report must explain excluded problems before seeing method
results. Exclusions may use objective reasons only: broken harness,
unavailable synthesis/PPA path, extreme timeout, or no meaningful PPA
variation after baseline reproduction.

## Benchmark Task Catalog

Before method comparison, build a task catalog for every candidate
benchmark problem:

- benchmark source: RTLLM or VerilogEval
- problem name and ID
- combinational or sequential
- arithmetic, control, FSM, datapath, or mixed family
- input/output width
- approximate simulation, synthesis, and OpenROAD cost
- reference/golden availability
- baseline REvolution valid-PPA status
- landing Smooth-QD manual-BD valid-PPA status
- baseline PPA variation
- inclusion/exclusion decision
- objective exclusion reason when excluded

This table is part of the anti-cherry-picking evidence. A task cannot be
dropped after seeing Auto-BD results unless the exclusion is marked as a
post-hoc limitation and removed from all compared methods symmetrically.

## Model And Runtime Policy

Default model arm: `gpt-oss-120b` through the local OpenAI-compatible
endpoint:

```bash
curl http://20.0.0.103:8000/v1/models
```

All compared methods must use the same model and prompting policy. When
launching or configuring a vLLM server for this model, set
`max_model_len` to at least 131072. When invoking REvolution commands,
use token settings that avoid reasoning-model truncation, including
`--max_tokens 128000` and `--diff_max_tokens 128000` unless the run is
explicitly a tiny smoke.

Any fallback to another model or endpoint must be symmetric across all
methods and recorded before the run starts.

Use the current server's parallel evaluation capacity for faster
iteration, but keep compute policy comparable. Record worker count,
thread settings, scheduler policy, and auxiliary compute skew for every
run. A speedup setting may be used for all methods; it must not be
enabled for only the proposed Auto-BD method.

The initial worker and phase policy is frozen in
`auto_bd_run_policy_lock.yaml`: seed-1 preliminary reports, seed-3
screening reports, and seed-5 final reports when compute permits. Higher
parallelism is allowed for screening only when every arm in the phase uses
the same policy and PPA remeasurement of final elites uses the capped
remeasurement policy.

## Fitness Definition

Use the existing REvolution/Smooth-QD fitness:

- Sequential circuits: average improvement ratio over power, area, and
  effective clock period.
- Combinational circuits: average improvement ratio over power and area.

PPA, reference PPA, and fitness are objectives, not behavior
descriptors. They must never be used as BD inputs.

## Metrics

Report four classes of metrics for every method.

Robustness:

- functionality pass percentage
- synthesis pass percentage
- OpenROAD success percentage
- percentage of problems with at least one valid PPA
- average valid-PPA candidates per problem
- syntax, testbench, synthesis, OpenROAD, and timeout failure counts

PPA quality:

- best fitness per problem
- average and median best fitness
- top-k average fitness
- strict zero-reference PPA hypervolume
- acceptable-nadir normalized hypervolume, such as `ANHV@1.5`
- PPA-grid coverage under a fixed problem-local PPA grid
- power, area, and timing improvements
- anytime best-fitness curve
- anytime strict-HV and `ANHV@1.5` curves

QD archive quality:

- archive coverage
- QD score
- mean and median elite fitness
- occupied cells
- improved cells over time
- archive entropy
- unique elite count
- unique canonical synthesized-netlist count

Descriptor quality:

- correlation with manual BDs
- correlation with PPA metrics
- stability under signal renaming
- stability under formatting-only RTL changes
- nearest-neighbor structural similarity
- duplicate-netlist leakage across cells
- motif enrichment per archive region
- representative RTL/netlist strategy examples
- learned-BD scatter colored by area, power, timing, and fitness when the
  method uses learned or projected descriptors
- descriptor-axis correlation with PPA metrics and benchmark identity

Required visualizations for projected or learned descriptors:

- fitness anytime curve
- strict HV anytime curve
- `ANHV@1.5` anytime curve
- per-problem Pareto fronts with method overlays
- PPA-grid occupancy or PPA-front unique-netlist count by method
- common-audit descriptor occupancy heatmap
- learned-BD scatter colored by area, power, timing, and fitness
- descriptor-axis correlations with PPA metrics and benchmark identity
- problem-seed paired delta plot versus classic REvolution
- representative elites per learned-BD region

Failure taxonomy:

- LLM output malformed or no Verilog
- syntax error
- wrong module interface
- simulation compile failure
- testbench functional failure
- simulation timeout
- Yosys parse failure
- Yosys synthesis failure
- unmapped cell or unsupported construct
- OpenROAD floorplan/place/route failure
- timing report missing
- PPA extraction missing
- descriptor extraction failure
- report-generation failure

## PPA And Hypervolume Normalization

For each problem, predeclare:

- objective directions: minimize area, power, and timing/effective period
- reference/golden PPA values, when available
- normalization formula
- hypervolume reference/nadir point
- clipping or winsorization rule for extreme outliers
- invalid-candidate penalty
- combinational-circuit timing handling

Hypervolume reference points, clipping, and invalid-candidate handling
must be fixed before comparing methods. Report both valid-only PPA and
penalized/all-candidate views. If reference PPA is missing or unstable,
mark the problem invalid for reference-normalized PPA before seeing
method results.

Current seed-1 centralized reports use the existing journal convention:

- objective directions are minimize area, power, and effective clock
- normalized improvement is
  `(reference - candidate) / max(abs(reference), 1e-12)`
- combinational problems use area/power objectives
- sequential problems add effective clock period
- hypervolume is measured in normalized improvement space against the
  zero-improvement reference point
- negative objective improvements are clipped to zero inside the
  hypervolume calculation
- invalid candidates count for robustness but are excluded from
  valid-only PPA/HV

## Statistical Testing Plan

Use phased reporting so long runs produce useful evidence before final
completion:

- Seed-1 development report: fast smoke and qualitative sanity check.
- Seed-3 screening report: main screening tier for promoted methods.
- Seed-5 final report: confirmation tier for the final selected method
  when compute permits.

Development subsets may use 1-3 seeds. Main-subset screening requires at
least 3 seeds. The final selected method should use 5 seeds on the main
subset when feasible; held-out validation requires at least 3 seeds and
prefers 5 seeds if the cost is acceptable.

The primary statistical unit is the paired problem-seed comparison.
Required reporting:

- paired cluster-bootstrap confidence intervals
- per-problem sign test or paired nonparametric test
- anytime curve endpoint and area-under-curve comparison
- mean and median effects
- practical effect sizes, not p-values alone
- paired problem-seed log ratio deltas such as
  `log((metric_method + eps) / (metric_classic + eps))`

If several methods are explored on the same main subset, treat
non-selected comparisons as exploratory or apply a stated multiple-testing
correction. Use a predeclared equivalence margin when claiming parity.

## Hard Gates

Gate 0 is the non-negotiable coverage gate:

- Let `C_problem` be the set of benchmark problems where original
  REvolution produces at least one valid PPA candidate in any seed under
  the fixed budget, model, seeds, and subset.
- Let `C_problem_seed` be the set of problem/seed pairs where original
  REvolution produces at least one valid PPA candidate.
- The selected method must produce at least one valid PPA candidate for
  every problem in `C_problem`.
- Report coverage delta on `C_problem_seed`; missing more than 5 percent
  of classic-covered problem/seed pairs is high-risk even when
  `C_problem` passes.
- If classic succeeds on problems A, B, and C, an Auto-BD method that
  succeeds only on A and C fails even if its average PPA looks better.

Gate 1: No robustness regression versus landing Smooth-QD manual-BD:

- functionality pass rate drop <= 5 percentage points
- synthesis pass rate drop <= 5 percentage points
- valid-PPA problem coverage does not drop
- OpenROAD success does not materially regress

Gate 2: Optimization uplift. Pass at least one:

- >= 10 percent relative improvement in average best fitness
- >= 10 percent relative improvement in PPA hypervolume
- >= 2 additional benchmark problems with positive PPA improvement
- statistically better anytime best-fitness curve under the same budget

Gate 3: QD uplift. Pass at least one:

- >= 15 percent relative improvement in QD score
- >= 20 percent relative improvement in archive coverage
- >= 25 percent more unique synthesized elite netlists

Gate 4: Descriptor non-arbitrariness:

- no near-perfect correlation with manual BDs or PPA objectives
- stable under renaming and formatting perturbations
- nearest neighbors in descriptor space have structural similarity
- archive regions can be explained by concrete netlist/synthesis motifs

Gate 5: Journal defensibility:

- the method contains a hardware-specific insight
- the method is not merely a direct AutoQD/AURORA/VQ-Elites port
- the method can be described without hiding major complexity
- final claims are supported on held-out validation, not only tuning runs

Gate 6: Functional correctness audit:

- For combinational finalists, run Yosys equivalence checking against the
  reference/golden implementation when available.
- If full equivalence is infeasible, run bounded exhaustive or
  high-coverage randomized simulation and record the limitation.
- For sequential finalists, run additional randomized simulation beyond
  the visible benchmark testbench, or bounded checks when feasible.
- At minimum, audit the best fitness candidate, best hypervolume
  contributor, representative archive elites, and any candidate with an
  unusually large PPA improvement.
- A finalist validated only by the same visible benchmark testbench must
  be rejected unless the stronger audit is explicitly infeasible.

Before large runs, the researcher must predeclare the quantitative
thresholds and the minimum effect size needed for sign-off. Thresholds
may be tightened after baseline MDE/power analysis, but not after final
method results are known.

For Synthesis-Response Kernel PCA candidates, the seed-3 promotion bar is
stricter than a generic QD gain:

- Gate 0 passes with no missing classic-covered problems.
- valid-PPA rate drop is <= 5 percentage points versus classic
  REvolution.
- scalar fitness does not collapse relative to classic or landing
  Smooth-QD manual-BD.
- strict HV or `ANHV@1.5` improves by at least 5 percent in paired
  problem-seed comparisons versus classic, or the method has a
  predeclared equivalent PPA-quality gain.
- Pareto-front unique netlists improve by at least 20 percent.
- The uplift is visible at seed-3 before any seed-5 final claim.

If the method improves diversity but loses too much PPA or repair
robustness, report it as an ablation rather than the final journal
method.

## Implementation Organization

Auto-BD experimentation must stay modular enough to compare variants
without turning the backend into a collection of special cases. New
variant code should follow `GUIDELINES.md` and `AGENTS.md`:

- keep descriptor-family logic in the nearest Auto-BD module, not spread
  across unrelated runtime call sites;
- use explicit method/profile names and fail on unknown descriptor kinds;
- keep argument lists narrow and required values required;
- prefer typed data structures and discriminated variants over optional
  fields and broad dictionaries at public boundaries;
- add docstrings for public entry points and short comments only where
  synthesis-response plumbing is not obvious;
- keep each method's fitting artifacts, method card, reports, and
  accept/reject decision under its `auto_bd_methods/` directory;
- run `ty` on touched source modules as the primary type check, with
  pyright retained as secondary compatibility evidence while repo
  guidance still asks for it.

## Anti-Hack Rules

1. Same benchmark subset, seeds, model, prompt policy, timeouts, and
   evaluation budget across compared methods.
2. Same Smooth-QD substrate unless the method explicitly declares and
   justifies the changed substrate.
3. No PPA, reference PPA, final fitness, or hypervolume contribution as
   descriptor input.
4. No tuning on the held-out validation subset.
5. No dropping hard problems after seeing results.
6. Missing or invalid PPA counts as missing coverage, not as an excluded
   point.
7. Average PPA over valid candidates is never enough; valid coverage and
   robustness must be reported beside it.
8. Duplicate netlists cannot be counted as distinct diversity.
9. Every elite must carry a canonical synthesized-netlist hash.
10. Every failed method must keep its method card, report, and
    accept/reject decision.
11. Manual result tables are not final evidence; reports must regenerate
    from raw or standardized processed artifacts.
12. Any method that wins by reducing repair ability is rejected.

## Cross-Method Comparability And Leakage Controls

Auto-BD methods may use different internal descriptor spaces. Therefore,
internal archive coverage and QD score are not sufficient for
cross-method claims.

Every method must report two diversity views:

1. Internal search archive: the descriptor/archive actually used by the
   method during evolution.
2. Common audit archive: a fixed post-hoc descriptor space applied to all
   methods with the same dimensions, normalization, binning, number of
   cells, and cell capacity.

Centralized conclusions must rely on:

- PPA and hypervolume
- Gate 0 valid-PPA coverage
- common-audit QD score and coverage
- unique canonical netlist count
- motif-signature diversity
- PPA Pareto-front spread
- per-problem win/loss/tie

Learned or projected descriptors must declare whether they are in-loop
search descriptors or post-hoc visualization descriptors. Any PCA, UMAP,
autoencoder, GNN, VQ codebook, clustering, or learned normalization used
in-loop must be fitted only from predeclared allowed data and must be
available at candidate insertion time. Post-hoc embeddings cannot be
claimed as the descriptor that improved search.

Each learned/projected method card must record:

- descriptor fitting protocol: fixed offline, online adaptive, or
  post-hoc visualization only
- descriptor training data: source, problems, seeds, candidate count, and
  validity filters
- frozen artifacts: scaler hash, PCA hash, encoder checkpoint hash, and
  codebook hash where applicable
- descriptor version/hash logged for every candidate

If an online descriptor updates during evolution, the method must specify
when archive rebins happen and how old elites are handled.

## Structural Diversity Audit

Report three diversity levels:

1. Exact canonical netlist hash: name-insensitive, deterministic
   Yosys-normalized hash.
2. Motif-signature uniqueness: hash or distance threshold over normalized
   motif/pathlet histograms.
3. PPA-relevant uniqueness: unique non-dominated PPA points or unique
   structural clusters on the PPA Pareto front.

The unique-netlist uplift gate cannot be satisfied by exact hash count
alone. It must also show motif-signature or PPA-relevant diversity.
The seed-1 centralized report records exact netlist uniqueness,
motif-signature uniqueness, duplicate-netlist count, Pareto point count,
and unique canonical netlists on the PPA Pareto front.

## ST-NOD Observational Equivalence Rule

ST-NOD stage dumping must be observational. The final synthesized netlist
and PPA path used for scoring must remain the same as the landing
Smooth-QD baseline flow unless a change is explicitly declared as a
method change.

Required test:

- run baseline synthesis and ST-NOD-instrumented synthesis on the same RTL
- confirm final netlist hash and PPA-relevant reports match, or explain
  the difference before using ST-NOD in evaluation

If stage dumping requires a separate Yosys script, it must not feed back
into the final PPA netlist unless predeclared.

## Random Descriptor Control Definition

The random descriptor control must be deterministic per candidate.

Allowed:

- `hash(candidate canonical netlist hash, fixed random seed)` to random
  archive cell
- fixed random projection from a Yosys-stat vector to descriptor

Not allowed:

- redraw random descriptor every time the candidate is evaluated
- use a different number of cells than the compared archive
- use randomization that changes across seeds without being logged

The number of cells, archive capacity, and insertion policy must match
the landing Smooth-QD manual-BD baseline unless explicitly tested as an
ablation.

## Prompt Invariance And Archive Context Rule

For Auto-BD comparisons, the only prompt difference allowed by default is
the descriptor/archive context. Every method must log:

- prompt template hash
- archive-context rendering function hash
- parent-selection policy
- operator distribution
- temperature and sampling parameters
- archive-lane versus champion-lane usage

The report must include operator usage, parent-source distribution, and
archive/champion lane usage by method. If a method wins because its
descriptor text gives better natural-language hints to the model, that
must be disclosed as a prompt-context effect.

## Toolchain And PPA Reproducibility

Every run must save:

- git commit and branch
- container/devcontainer hash when available
- Yosys, ABC, and OpenROAD versions
- liberty file hash
- PDK/tech config hash
- constraints file hash
- OpenROAD seed/randomness settings
- CPU/thread/worker settings

For the final selected method, re-run PPA extraction for all best elites
and hypervolume-contributing elites. Report whether PPA numbers reproduce
within tolerance, and flag any candidate whose PPA drift changes the
conclusion.

## Required Method Directory Structure

The future implementation should keep method-specific planning, reports,
and accept/reject records inside this scaffold directory so
`docs/journal_features/` does not become scattered:

```text
docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/
  auto_bd_methods/
    00_random_descriptor/
    01_yosys_stat_bd/
    02_netlist_motif_occupancy/
    03_synthesis_trajectory_nod/
    04_synthesis_response_kernel_pca/
    05_contrastive_synthesis_response/
    06_aurora_netlist_encoder/
    07_vq_implementation_codebook/
    99_final_selected_method/
```

Each method directory must include:

- `method_card.md`
- `config.yaml`
- descriptor extraction code or a pointer to shared extraction code
- archive adapter/config
- raw and processed experiment artifacts
- generated report
- `accept_reject.md`

Each `method_card.md` must state:

1. motivation
2. core idea
3. input artifacts
4. descriptor extraction algorithm
5. archive integration
6. hyperparameters
7. expected advantage
8. risks
9. implementation status
10. experimental setup
11. results
12. accept/reject decision
13. reason for the decision

Shared code used by multiple methods may live in `src/revolution/` or
`scripts/`, but method cards, configs, report outputs, and decision
records should stay under
`docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/`
unless a specific artifact is too large and must be stored under `exp/`.
Large run outputs must be linked from the method report rather than
copied into docs.

## Code Organization Requirements

Adding many experimental modes must not turn the backend into a
configuration maze. Follow the repository guidance from `AGENTS.md` /
`GUIDELINES.md`:

- keep code simple, skimmable, and typed where public interfaces are added
- minimize optional arguments and state
- prefer discriminated unions or explicit method-family enums when a value
  can take multiple shapes
- handle every descriptor/method kind exhaustively and fail on unknown
  kinds
- assert required loaded data instead of adding broad defensive defaults
- keep descriptor extraction, archive integration, and reporting
  boundaries easy to trace
- add docstrings for public modules/classes/functions and non-obvious
  helpers
- use comments sparingly, only where they clarify non-obvious logic
- document new commands, configs, artifacts, and limitations in the method
  cards and reports

Type checking policy for this Auto-BD branch:

- `uv tool run ty check <touched source modules>` is the primary typed
  validation command for new Auto-BD code.
- Keep pyright as a secondary compatibility check while repository-wide
  guidance still asks for it, but do not rely on pyright alone for
  Auto-BD sign-off.
- If `ty` and pyright disagree, record both diagnostics and resolve the
  `ty` issue first unless there is a clear tool limitation.
- New public Auto-BD interfaces should be simple enough for `ty` to check
  without broad ignores, dynamic attribute tricks, or optional-state
  workarounds.

The validator should reject a method that gets a numerical win by making
the backend hard to understand, spreading mode-specific logic across many
unrelated call sites, or adding abstractions that are not justified by
repeated real use.

## Reporting Requirements

A proposed Auto-BD method is incomplete until it can generate its own
report from artifacts.

## Standard Result Schema

Every method should emit standardized files under a run-local
`standard_results/` directory and link those artifacts from the method
report. Do not copy large `exp/` outputs into this docs directory.

```text
results/
  candidates.parquet
  elites.parquet
  archive_snapshots.parquet
  per_generation_metrics.parquet
  per_problem_metrics.parquet
  descriptor_vectors.parquet
  netlist_hashes.parquet
  method_summary.json
  run_manifest.json
```

Required candidate fields:

- method_name
- method_family
- descriptor_version
- raw_feature_schema_version
- feature_schema_hash
- scaler_hash
- random_feature_map_hash
- pca_hash
- codebook_hash
- layout_hash
- descriptor_hash
- problem_id
- benchmark_source
- seed
- generation
- candidate_id
- parent_id
- operator_name
- prompt_hash
- model_id
- model_endpoint_hash
- syntax_pass
- functionality_pass
- synthesis_pass
- openroad_pass
- valid_ppa
- failure_reason
- area
- power
- timing_or_clock_period
- fitness
- ppa_hypervolume_contribution
- descriptor_vector
- common_audit_descriptor_vector
- archive_cell_id
- common_audit_cell_id
- canonical_netlist_hash
- motif_signature_hash
- rtl_path
- netlist_path
- log_path

Required `run_manifest.json` fields:

- git_commit
- branch
- config_hash
- subset_hash
- seed_list
- model_id
- endpoint
- prompt_policy_hash
- yosys_version
- abc_version
- openroad_version
- liberty_file_hash
- pdk_or_tech_config_hash
- constraints_hash
- timeout_policy
- budget_policy
- worker_count
- thread_policy

Per-method reports must include:

- one-page executive summary
- sign-off gate dashboard
- robustness funnel and failure breakdown
- per-problem valid-PPA heatmap
- anytime best-fitness and PPA hypervolume curves
- per-problem win/loss/tie chart
- QD coverage, QD score, entropy, and archive heatmaps
- descriptor/PPA/manual-BD correlation heatmaps
- motif enrichment table
- renaming/formatting stability table
- duplicate/canonical-netlist analysis
- representative elite examples

A centralized report must compare every baseline and attempted method:

- method leaderboard
- sign-off gate matrix
- cross-method anytime curves
- per-problem win/loss matrix
- robustness funnel across methods
- unique-netlist comparison
- descriptor-quality comparison
- compute-cost comparison

## Iteration Plan

Phase 0: Reproduction and locks

1. Reproduce original REvolution.
2. Reproduce landing Smooth-QD manual-BD / NSGA-II baseline.
3. Lock benchmark subsets, seeds, model, prompts, timeouts, worker policy,
   and budget.
4. Record baseline coverage set `C` for Gate 0.

Phase 1: Controls

1. Implement random descriptor QD.
2. Implement simple Yosys-stat BD.
3. Build canonical netlist hashing and report skeletons.
4. Run the development subset and write accept/reject cards.

Phase 2: First real Auto-BD

1. Implement netlist motif occupancy extraction.
2. Add descriptor stability tests.
3. Run the development subset.
4. Reject or promote based on gates and method card evidence.

Phase 3: Main RTL-native method

1. Implement synthesis-stage artifact dumps.
2. Implement ST-NOD.
3. Compare motif-only versus trajectory-motif descriptors.
4. Promote only if robustness and coverage gates hold.

Phase 4: Learned and codebook variants

1. Try PCA/random projection before neural encoders.
2. Try AURORA-style encoder only if fixed vectors are stable.
3. Try VQ/codebook only if codebook regions can be labeled.

Phase 5: Final selection

1. Select the simplest method that passes gates.
2. Produce seed-1 preliminary reports for fast sanity checks.
3. Produce seed-3 screening reports for promoted methods.
4. Produce a seed-5 final report for the selected method when compute
   permits.
5. Run held-out validation only after method selection.
6. Produce final method spec, final report, and paper-section draft.
7. Run adversarial validation.

## Boundaries

Allowed:

- `src/revolution/`
- `scripts/`
- `tests/`
- `data/configs/`
- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`
- `exp/` and method-specific run/report directories

Keep `auto_bd_methods/` under this scaffold directory. Do not create
method-card or report directories directly under `docs/journal_features/`.
Do not edit unrelated worktrees. Do not revise existing journal claims
unless new evidence requires an explicit recorded branch/narrative update.
Do not push or publish without a separate user request.

## Completion Criteria

The future goal is complete only when:

- every TODO item is checked with evidence
- baselines and controls are reproduced on the selected subset
- each attempted method has a method card, report, and accept/reject
  decision
- Gate 0 passes for the selected method
- robustness, PPA, QD, descriptor-quality, and journal-defensibility gates
  are mechanically evaluated
- final held-out validation supports the selected method's claim
- reports regenerate from artifacts
- tests/lint/`ty` checks for touched code are run or blocked with reasons;
  pyright compatibility is reported while the repository still requires it
- `auto_bd_research_subagent_validation_report.md` records adversarial PASS

If no method passes Gate 0 and the uplift gates, the correct outcome is a
documented rejection with a publishable negative finding, not a weakened
success claim.

## Risks And Blockers

- Netlist extraction cost may be too high in-loop. Resolve by caching,
  using existing Yosys artifacts, or moving heavy characterization to
  reporting while keeping online descriptors cheap.
- Learned encoders may overfit to problem identity or gate count. Resolve
  with held-out validation, correlation checks, and perturbation tests.
- Descriptor regions may not be interpretable. Resolve by motif
  enrichment and representative-elite galleries, or reject the method.
- PPA uplift may come from lower valid coverage. Gate 0 and robustness
  dashboards must block this.
- The local model endpoint may be unavailable. Record preflight evidence
  and stop rather than silently switching models.
