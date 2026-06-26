# Useful BD Push Stop-Condition Audit

Status: live-spend stop condition satisfied for the tested families; final
negative-map adversarial PASS recorded.

## Policy

`anti_reward_hacking_policy.md` permits stopping broad live search only after
one of these conditions is met:

1. a `T2` or `T3` method is found and validated on holdout;
2. at least 10 real method packages across required method classes are
   complete and all fail with a documented negative map; or
3. the same external blocker repeats across three concrete attempts.

This audit uses condition 2. It does not claim QD is impossible. It says the
current tested families are documented enough that the next step should be
reporting, validation, or a materially different mechanism, not another small
descriptor-axis live run.

## Required Method Breadth

| Required Class | Evidence | Result |
| --- | --- | --- |
| Simple/control | T22 random descriptor; classic/manual controls in live matrices | satisfied |
| Synthesis/netlist descriptor | T04/T19/T20/T24-T32 synthesis-response family | satisfied |
| Learned/projection descriptor | Qwen/T33/T34, DeepGate/T89-T95, T96 hybrid, T99 AURORA/raw, T08-T16 closures | satisfied |
| Archive-coupling/Pareto variant | T17/T23-T59, T72-T75, auxiliary archive, FG-QDM T85-T100 | satisfied |
| At least 10 real packages | T01-T100 package/plan sequence with T01-T22 scaffold closures and later live packages | satisfied |

## Promising Signals Were Escalated

| Signal | Follow-Up | Outcome |
| --- | --- | --- |
| T26 SR conservative exploit looked locally useful. | T27/T28 audit, T30 holdout, T31/T32/T47-T59 variants, RTLLM reference-complete correction. | Mechanism evidence remains, but no headline PPA-front win. |
| T36/T37 replay front-lane looked positive. | T38-T46 live one-slot, sparse-yield, graph-axis, and control matrix. | Live screens remain negative versus classic. |
| T72 source-aligned RTL cells were near-classic. | T73/T74/T75 source-aligned variants and T79 budget-shape ablation. | Exact family remains below classic across tested shapes. |
| T83 and auxiliary archive were near-classic single-seed clues. | T88 and auxiliary archive seed replication. | Both replicate negative with zero seed-level HV wins. |
| DeepGate official embeddings became usable. | T89-T95 bridge, runtime hook, live smoke, and matched screens. | Best pure DeepGate T95 trails classic. |
| Hybrid RF/DeepGate could combine RTL and netlist signals. | T96 matched screen. | Improves over T95 but regresses versus sibling T83 and classic. |
| AURORA/raw implementation replay had a signal. | T99 live delayed screen. | Category representative only; below classic. |
| FG-QDM should avoid archive-fill tax. | T85/T86/T87/T97/T98/T100 smokes and controls. | T100 is best smoke, but still below classic and not frozen-screen-ready. |

## Anti-Gaming Checks

| Check | Evidence |
| --- | --- |
| Missing reference PPA not used for headline claims | Current policy excludes missing-reference designs; recent screens use `ppa_completeness.csv`. |
| Candidate PPA missing remains visible | Completeness tables and valid-PPA yield statuses are required and present for recent screens. |
| Smoke-only result not promoted | T100 is explicitly category-representative only. |
| Single-seed result not overclaimed | T83 and auxiliary archive replication gates are negative and recorded. |
| Validity/yield drops not hidden | T96 and earlier T44/T85/T87 reports call out yield and memory-lane failures. |
| Pretrained claims are scoped | T95/T96 use official DeepGate bridges; MasterRTL Area-head leaves and DeepCell/CircuitFusion/NetTAG proxies are not claimed as true reproductions. |
| T0 results get retirement/follow-up rationale | Technique packages and `technique_lineage_ledger.md` record retire/hold/advance decisions. |

## Stop Decision

The broad negative-map stop condition is satisfied for the current tested
families. The active branch should not spend more vLLM budget on:

- another direct encoder-axis swap;
- another small archive fill/front-slot fraction tweak;
- another unreplicated single-seed near-miss;
- a smoke-only FG-QDM continuation without a stronger memory-lane mechanism.

The next live run is justified only if it materially changes the mechanism and
pre-registers how it will improve front contribution per LLM call or trains a
validated encoder objective. Otherwise the next work should be:

1. finish the central comparison package;
2. record final figure and metric caveats;
3. run adversarial validation on the negative-map claim; and
4. write the final validation report.

## Final Validation Status

This stop audit is paired with the clean PASS recorded in
`useful_bd_push_subagent_validation_report.md`. The remaining limitations are
documented scope caveats, not blockers for stopping broad live spend on the
tested families.
