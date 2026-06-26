# Useful BD Push Central Comparison Report

Status: current negative-map report, not final adversarial sign-off.

## Conclusion

No screened QD/MAP-Elites behavior-descriptor or archive-coupling method is
currently promoted for full RTLLM spend. The strongest evidence supports a
negative but useful conclusion:

> Generic descriptor diversity and direct encoder-axis swaps have not beaten
> matched classic REvolution on reference-complete PPA-front metrics. The most
> defensible future QD framing is guarded auxiliary memory for
> PPA-competitive RTL implementation families, but the tested memory lanes do
> not yet create enough quality-productive front material per LLM call.

This does not prove QD/MAP-Elites is useless for RTL. It shows that, under the
tested budgets, descriptors, and coupling policies, QD pressure has not earned
its evaluation cost against a strong classic hill-climbing baseline.

## Terms

- `classic REvolution`: the non-QD baseline optimizer. It samples and retains
  candidates using direct quality/PPA feedback.
- `QD/MAP-Elites`: archive-based search that stores candidates by behavior
  descriptor cells while still optimizing quality.
- `BD`: behavior descriptor, the PPA-free feature vector used for archive
  cell assignment.
- `valid-PPA`: a candidate that is functional, synthesis-valid, and has usable
  area, power, and timing metrics.
- `PPA front`: nondominated valid-PPA candidates over normalized area, power,
  and timing objectives.
- `HV`: PPA hypervolume. Larger is better after objectives are normalized into
  maximize-form gains.
- `HV-AUC`: area under the HV-over-time curve. Larger means useful front
  material appeared earlier or stayed stronger through the run.
- `reference-complete`: a comparison subset where benchmark reference PPA is
  present and usable, so normalized improvement and HV are not defaulted.
- `smoke`: a small bounded run used for mechanism evidence, not promotion.
- `category representative`: the best current member of a method family. It
  stays visible even if it is below classic.

## Primary Evidence Table

| Lane | Representative | Scope | QD Mean HV | Matched Classic | Decision |
| --- | --- | --- | ---: | ---: | --- |
| MasterRTL auxiliary archive | `masterrtl_aux_archive_high_exploit_8x5` | 8-design, 3 seeds | `0.1261` | `0.1442` | Best replicated QD by mean HV, but `0/3` seed wins. |
| RF model-state RTL-native | `T83_rf_leafid_structural_delayed_qd` via T88 | 8-design, 3 seeds | `0.1260` | `0.1442` | Closest RF model-state clue; replication blocks promotion. |
| Delayed archive activation | `masterrtl_delayed_archive_activation_8x5` | 8-design, seed `1001` | `0.1324` | `0.1406` | Useful timing clue, single-seed and still negative. |
| Pure DeepGate | `T95_deepgate_delayed_high_exploit_8x5` | 8-design, seed `1001` | `0.1153` | `0.1406` | Best official DeepGate representative, not promoted. |
| RF/DeepGate hybrid | `T96_rf_deepgate_hybrid_delayed_8x5` | 8-design, seed `1001` | `0.1199` | `0.1406` | Improves over T95 but regresses versus sibling T83 `0.1369`. |
| AURORA/raw implementation | `T99_aurora_raw_impl_delayed_qd` | 8-design, seed `1001` | `0.1201` | `0.1406` | Stronger than Qwen and pure DeepGate, still front-negative. |
| Qwen3 text/code | `qwen_canonical_rtl_pca3_8x5` | 8-design, seed `1001` | `0.1108` | `0.1406` | Real pretrained text/code path, weak live HV. |
| Graph-like bridge | `t11_runtime_top4_front_slot_8x5` | 8-design, seed `1001` | `0.1208` | `0.1406` | Replay signal did not survive as a primary live archive. |
| FG-QDM memory | `T100_fg_qdm_rf_leafid_front_credit_12x3` | 3-problem smoke | `0.1566` | `0.1903` | Best FG-QDM smoke, but still negative and not comparable to 8-design rows. |

The mixed-scope absolute HV values above are not a promotion ranking. The
most comparable promotion evidence is the frozen 8-design screen and the
three-seed replications. On those surfaces, every QD representative remains
below matched classic.

## What The Search Shows

### Diversity Matters Only When It Preserves PPA-Competitive Families

The useful signal is not archive occupancy by itself. The strongest clues
come from methods that keep classic-like exploitation while preserving
alternative implementation families:

- T75 and T73 show source-aligned RTL-native descriptors can improve valid-PPA
  yield or archive health, but not front breadth.
- T83 and the auxiliary archive show near-classic single-seed HV is possible,
  but seed replication removes the apparent win.
- T100 shows a front-rescue memory lane can add global-front candidates, but
  the overall smoke remains below classic and memory-refine still adds none.

### Generic Descriptor Spread Is Not Enough

The following families consistently fail to convert descriptor diversity into
headline PPA-front wins:

- direct Qwen-style text/code embeddings;
- pure official DeepGate axes;
- RF/DeepGate feature concatenation;
- raw AURORA-style implementation features;
- top-k graph-coordinate archive axes;
- direct local-front widening or more archive pressure;
- deeper equal-budget shapes for exact T75 and auxiliary archive variants.

### Classic Is A Strong Small-Budget Hill Climber

The evidence supports the current strategic explanation. With small budgets,
fragile RTL validity, and expensive LLM samples, classic immediately spends
budget on high-quality candidates. QD variants often pay an archive-fill or
parent-selection entropy cost before the archive has enough time to mature.

## Guardrail Checks

| Guardrail | Current State |
| --- | --- |
| Missing reference PPA | Corrected after the T26 full-RTLLM issue; recent headline screens use reference-complete tables. |
| Smoke-only promotion | Blocked. T100 is visible as a category representative but not promoted. |
| Single-seed overclaiming | Blocked by T83 and auxiliary archive seed replication, both negative. |
| Valid-PPA yield collapse | Recent reports expose yield drops, especially T96 on `Prob015` and `Prob045`. |
| Pretrained-model honesty | DeepGate uses official-model bridges; MasterRTL Area-head leaves are retired after collapse; T16/T10/T09/T08 are labeled proxy closures. |
| Passive archive and metric parity | Recent T95/T96/T99/T100 rows are covered; older Qwen/T83/auxiliary rows are marked legacy/partial in `tables/completion_gap_inventory.csv`. |

## Artifact Coverage

`tables/completion_gap_inventory.csv` records metric and visualization
coverage for the current representative packages.

Rows suitable for the current category-level negative claim:

- T95 pure DeepGate;
- T96 RF/DeepGate hybrid;
- T99 AURORA/raw implementation;
- T100 FG-QDM smoke, with the caveat that it is not a full-screen promotion
  row.

Rows that should remain representative-only unless backfilled:

- Qwen canonical RTL;
- T83/T88 RF leaf-ID replication;
- auxiliary archive high-exploit replication.

## Current Answer To The Two Main Questions

1. Does diversity matter for RTL/Verilog PPA evolution?

   It can matter diagnostically: diversity reveals alternative implementation
   families, validity/yield tradeoffs, and front material that scalar
   retention would discard. It has not yet mattered enough as an active search
   pressure to beat classic REvolution on reference-complete HV/front metrics.

2. What kind of diversity matters?

   The only defensible kind so far is PPA-competitive, RTL-native or
   implementation-family diversity under strict validity constraints. Opaque
   embedding spread, broad archive recall, and direct feature concatenation
   are not enough.

## Decision

Do not launch a full RTLLM QD comparison now. The final RTLLM shortlist remains
empty.

Before any new live run, require a method that changes the mechanism, not just
one descriptor axis. The next candidate should prove at least one of:

- memory-refine or front-rescue has a higher global-front-add rate per LLM call
  than classic-like sampling;
- a retained family that classic would discard later creates a stronger PPA
  front point;
- a trained or validated encoder changes the descriptor objective rather than
  only swapping axes;
- the method survives a reference-complete frozen screen, not only a smoke.
