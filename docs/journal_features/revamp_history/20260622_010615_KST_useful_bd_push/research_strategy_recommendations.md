# Research Strategy Recommendations

This note consolidates the current discussion about why classic REvolution is
hard to beat, what that means for QD/MAP-Elites in RTL PPA evolution, and which
roadmap changes should follow. It is a strategy note, not a result claim.

## Core Assessment

Classic REvolution is strong because the current benchmark setting rewards a
small-budget hill climber:

| Factor | Why It Helps Classic |
| --- | --- |
| Direct PPA pressure | Classic samples and keeps candidates using the actual objective. QD spends part of the budget maintaining descriptor coverage. |
| Tiny budget | `12 x 3` gives little time for archive fill, local improvement, and later front contribution. |
| Expensive candidates | LLM generations and synthesis are costly, so MAP-Elites has few chances to mature cells. |
| Fragile RTL validity | Many diverse-looking RTL variants fail before PPA. Classic naturally stays near valid-producing regions. |
| Hard descriptor design | Useful BDs must separate implementation families that can improve the PPA front, not only syntax or graph appearance. |
| Implicit diversity | LLM sampling, prompts, operators, and mutation history already create variation without an explicit archive. |
| Narrow fronts | Some small RTL tasks have few meaningful area/power/timing tradeoffs. |

This does not show that QD or MAP-Elites literature is wrong. It shows that
the standard QD premise does not transfer automatically when evaluations are
expensive, validity is brittle, budgets are shallow, and descriptors are easy
to decouple from useful implementation strategy.

The goal is therefore still valid, but the burden of proof is different from
the usual cheap-evaluation QD setting. A positive RTL result should show that
archive pressure protects implementation families that remain competitive on
PPA. A negative result should identify which part failed: descriptor meaning,
archive coupling, validity, budget depth, or benchmark saturation.

## Recommended Framing

Do not frame the claim as "generic MAP-Elites beats classic REvolution." The
stronger and more defensible claim is:

> Useful diversity in RTL evolution is preserving PPA-competitive RTL
> implementation families under validity constraints.

The most promising architecture is conservative:

| Direction | Operational Meaning |
| --- | --- |
| QD as auxiliary memory | Keep classic-like exploitation as the main engine, then use archive cells to avoid losing promising alternatives. |
| Front-preserving cells | Archive or sample candidates that are locally Pareto-relevant, not every structurally novel candidate. |
| RTL-native descriptors | Prefer source-aligned operator/control/dataflow, register, pipeline, and timing-risk features over opaque syntactic spread. |
| Adaptive pressure | Increase diversity pressure when classic stagnates or a near-front cell exists; avoid constant exploration tax. |
| Passive archive first | Measure whether classic already discovers useful niches before forcing QD to sample them. |
| Staged budgets | Let valid regions form first, then use QD to broaden PPA fronts. |

## Budget Hypothesis

`12 x 3` may be structurally biased against QD. It is wide enough to find some
valid RTL, but shallow for the sequence "discover family, improve locally,
become Pareto useful." This is plausible from the live results, but not yet
proven.

Run a fixed-total-budget shape ablation before a broad budget-shape claim:

| Shape | Candidates | Purpose |
| --- | ---: | --- |
| `12 x 3` | 48 | Current matched baseline. |
| `8 x 5` | 48 | Balanced depth and initial diversity. |
| `6 x 7` | 48 | More archive and hill-climb maturation. |
| `4 x 11` | 48 | Deep exploitation; low initial diversity risk. |
| `16 x 2` | 48 | Wide/shallow control. |

The decision question is not whether deeper runs help absolutely. It is whether
deeper runs help the selected QD method more than they help classic under the
same candidate budget.

T78 adds a retrospective diagnostic before spending live budget. It shows that
the existing T75 `12 x 3` archive still matures late: `9/13` problem archives
add or replace cells in generation `2` or later, mean occupied cells rise from
`1.54` to `5.15` through generation `3`, and front-slot requests rise from
`17` in generation `1` to `77` in generation `3`. This supports the ablation
but does not answer it. The fixed-total-budget run remains required.

T79 is the active live test of this hypothesis. Do not use the budget argument
as a reason to keep moving the target; finish the pre-registered matched arms
or record the infrastructure blocker. Do not promote a deeper shape unless it
helps QD more than classic on the frozen reference-complete design set.

## Discriminative Design Set

The screening set should be chosen for PPA-front variance and medium validity,
not only benchmark representativeness. Avoid designs that are saturated,
invalid-heavy, missing reference PPA, or too small to support multiple
implementation families.

Useful properties:

- valid benchmark `ppa.txt`;
- several classic valid-PPA candidates;
- multiple unique nondominated PPA points or prior near-front candidates;
- nontrivial area/power/timing variance;
- enough RTL structure: FSM, pipeline, arithmetic, muxing, memory, or
  control/dataflow interaction.

Candidate designs for a budget-shape screen include
`RTLLM/Prob015_multi_pipe_8bit`, `RTLLM/Prob041_traffic_light`,
`RTLLM/Prob045_alu`, `RTLLM/Prob049_signal_generator`,
`RTLLM/Prob024_fsm`, `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`,
`VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`, and
`VerilogEval-Spec-to-RTL/Prob153_gshare`. The final subset must still be
frozen before interpreting outcomes.

## MasterRTL And RTLTimer Credibility Gate

Current live RTL-native methods use source-aligned extractor/count features.
They do not yet prove end-to-end use of pretrained MasterRTL or RTLTimer model
pipelines.

Local evidence confirms MasterRTL includes saved model files:

- `ML_model/saved_model/rfr_model.pkl`;
- `ML_model/saved_model/xgboost_Area_model.pkl`;
- `ML_model/saved_model/xgboost_Power_model.pkl`;
- `ML_model/saved_model/xgboost_TNS_model.pkl`;
- `ML_model/saved_model/xgboost_WNS_model.pkl`.

RTLTimer currently has model scripts and TinyRocket feature/label/report
artifacts in the local clone; clear bundled pretrained checkpoint usage still
needs a sharper inventory and reproduction check.

Before claiming pretrained-model descriptors, require:

1. exact repo commits and file hashes;
2. original upstream inference command captured;
3. internal loader reproduces upstream predictions within tolerance;
4. feature vector schema, length, and ordering are asserted;
5. generated RTL candidates produce nonconstant plausible outputs;
6. the live QD logs state exactly which model or extractor outputs define each
   BD axis.

For MasterRTL, the most promising learned representation is probably not a
neural "pre-head embedding" because the shipped models are tree models. Use
tree-leaf embeddings or per-tree margin/contribution vectors from the saved
Area, Power, WNS, TNS, and RF models, then combine them with raw RTL-native
structure. Treat scalar predicted PPA-risk axes carefully so they do not become
hidden PPA-proxy descriptors.

T76 partially closes this gate. It confirms that the MasterRTL XGBoost heads
and RF model artifacts exist, hashes them, asserts the shipped feature-schema
lengths, and loads the RF model through `joblib`. It does not complete the gate
because the shipped TinyRocket XGBoost example is all-zero and one-design, and
because RTLTimer still lacks a confirmed packaged pretrained checkpoint in the
local clone. The next MasterRTL step should measure generated-candidate
variation in tree leaves or margins before any live vLLM spend.

T77 runs that generated-candidate variation check for the only source-faithful
head available without extra side-channel data: MasterRTL Area. The result is
negative. Generated candidates produce `17` unique Area feature rows out of
`19`, but the pretrained Area XGBoost head emits one scalar prediction and one
tree-leaf row for all candidates. Direct Area-head leaves should be retired
unless the model is retrained or replaced. The remaining pretrained-model path
is timing/power only after reproducing the required toggle-rate or timing-DAG
feature flows.

If MasterRTL is added as a submodule or pinned external source, the first
deliverable should be a reproduction package, not a live QD run. It should
compare upstream inference outputs with the internal loader, assert feature
schema identity, record model hashes, and only then expose tree-leaf, margin,
or retrained-model embeddings as descriptor candidates.

## Latest Discussion Review

The latest discussion adds two recommendations that should be treated as
accepted, but not overclaimed:

| Recommendation | Assessment |
| --- | --- |
| Classic strength does not falsify QD/MAP-Elites. | Accepted. It means RTL PPA evolution needs constrained, PPA-competitive diversity rather than generic archive coverage. |
| `12 x 3` may be biased against QD. | Plausible and now roadmap-worthy, but not proven. Test equal-candidate budget shapes before changing headline protocol. |
| Existing `12 x 3` archives still mature late. | Accepted as T78 diagnostic evidence. Use it to justify the ablation, not to claim that deeper QD wins. |
| Choose medium-validity, front-variable designs for screens. | Accepted. This is screening discipline, not cherry-picking, if frozen before outcomes. |
| Use MasterRTL pretrained tree artifacts as an encoder. | Narrowed after T77. Direct Area-head leaves collapse; continue only through retraining, replacement, or reproduced timing/power feature flows. |
| Treat T75/T76/T77 as positive enough to launch broad claims. | Rejected. They are useful diagnostics and gates, not classic-beating evidence. |

## Current Goal Evaluation

The goal should not terminate early because classic remains ahead. Classic is
the benchmark pressure that makes the result useful. The right next actions
are to finish the budget-shape test, keep headline metrics on
reference-complete paired subsets, and continue RTL-native descriptor work only
when it is source-faithful or explicitly labeled as a proxy.

The goal should also not loosen into reward hacking. Archive occupancy, yield,
or descriptor spread can support an explanation, but they do not replace PPA
front evidence. A method becomes a promotion candidate only when it preserves
classic-covered designs and improves, matches, or credibly explains the PPA
front under the registered comparison.

The current evaluation of the goal remains positive but narrower: the goal is
not to prove that any diversity measure helps. It is to identify which
front-preserving and RTL-native diversity mechanisms can survive the strong
classic hill-climbing baseline under fair, reference-complete comparisons.

## Roadmap Changes Accepted

- Treat T75 as packaged positive diagnostic evidence, not a promotion.
- Add a fixed-total-budget shape ablation as the next evaluation-structure
  check.
- Use T78 as the reproducible rationale for that ablation: current archives
  still change late, but no equal-budget shape has been tested yet.
- Use T79 as the pre-registered live protocol: eight frozen primary designs,
  `12x3`, `8x5`, and `6x7`, and matched classic versus T75 QD arms.
- Add a MasterRTL-pretrained verification and tree-leaf embedding lane before
  spending live budget on "pretrained MasterRTL" QD claims.
- Add a generated-candidate MasterRTL leaf/margin variation gate after T76 and
  before any live pretrained-model BD run. T77 completes the Area-head gate and
  retires direct Area leaves.
- Use discriminative, reference-complete, medium-validity designs for budget
  and descriptor screens.
- Keep headline claims on reference-complete paired subsets.

## Roadmap Changes Rejected Or Delayed

- Do not conclude that QD is wrong because classic is strong.
- Do not promote generic archive occupancy, yield-only gains, or all-RTLLM
  defaulted-reference aggregates.
- Do not claim pretrained MasterRTL or RTLTimer use until model-loading and
  inference reproduction are verified.
- Do not use direct final PPA, reference PPA, test pass rate, hypervolume, or
  Pareto rank as in-loop BD inputs.
