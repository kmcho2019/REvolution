# Executive Summary

Date: 2026-06-25.

## Bottom Line

The current attempt has not yet shown that QD/MAP-Elites improves RTL PPA
evolution over classic REvolution. The strongest honest status is:

> Diversity is measurable and sometimes diagnostically useful, but current
> QD/MAP-Elites variants have not produced a clean, reference-complete
> RTLLM-wide PPA hypervolume win over classic REvolution.

This is not enough to conclude that QD is wrong for RTL. It is enough to say
that naive or weakly coupled diversity pressure is currently losing to a strong
small-budget hill climber.

## Main Evidence

| Area | Best signal | Blocking result |
| --- | --- | --- |
| Synthesis-response / AutoQD-style | T19 replay improved mean HV by `+16.82%`; T04 stayed near classic and improved passive QD/front evidence. | T24 live SR-family test lost too much quality on `Prob015_multi_pipe_8bit`; full RTLLM exact T26 became negative after missing-reference designs were excluded. |
| Qwen3 text/code embeddings | T33 canonical RTL selected-HV beat lexical by about `+2.63%`; netlist views reduced same-problem collapse. | Netlist views did not improve HV; RTL views retained nuisance clustering and did not become live QD wins. |
| DeepGate-style netlist graphs | T07 WL graph surrogate slightly beat lexical HV and reduced collapse. | It was a surrogate, not validated pretrained DeepGate; front hits still trailed lexical. |
| AURORA / autoencoder | T13 raw implementation features beat lexical HV by `+1.06%`. | Compressed AURORA-style bottlenecks lost HV; no live win. |
| DE-HNN / hypergraph | T14 hybrid improved lexical HV by `+1.01%` and unique PPA points. | Hypergraph-only variants lost HV; front hits trailed lexical. |
| MGVGA-style structural contrastive | T11 reached `+1.82%` replay HV; T36 bounded front lane reached `+4.04%` replay HV and more front hits. | Live graph-coordinate variants such as T58 lost HV/HV-AUC/front breadth despite yield or best-score gains. |
| MasterRTL / RTLTimer RTL-native | T72 nearly matched classic mean HV (`0.0920` vs `0.0926`); T75 improved over T73/T74 and valid-PPA yield. | T75 still lost classic on mean HV, Pareto points, and reference-beating candidates; T79 showed exact T75 loses classic under `12x3`, `8x5`, and `6x7`. |
| Pretrained MasterRTL models | T76 loaded MasterRTL saved tree artifacts; RF model showed nonconstant leaf structure on saved features. | T77 showed direct pretrained Area-head leaves collapse to one prediction/leaf row on generated candidates. |

## Most Important Correction

The first full RTLLM exact-T26 result looked positive under all-50 aggregates.
That positive read depended on four RTLLM problems with missing or defaulted
reference `ppa.txt`:

- `Prob006_adder_pipe_64bit`
- `Prob013_multi_booth_8bit`
- `Prob018_float_multi`
- `Prob040_synchronizer`

After restricting headline claims to the reference-complete paired subset,
exact T26 lost classic on mean HV, HV-AUC, valid-PPA yield, best score, and
unique PPA points. This is why the current conclusion is diagnostic-negative,
not positive.

## Why Classic Is Strong

Classic REvolution is a strong baseline because it behaves like a direct,
small-budget hill climber:

- it optimizes the actual scalar objective immediately;
- it does not spend candidates filling archive cells;
- it stays near valid-producing regions;
- LLM sampling already gives implicit diversity;
- many RTL problems have narrow fronts or fragile validity;
- QD has too few evaluations to mature discovered niches.

The key failure pattern is not "no diversity exists." The failure pattern is:

> Archive diversity has often increased descriptor coverage, valid-yield, or
> replay front material without improving the live PPA Pareto front enough to
> beat classic.

## Current Best Candidate Families

These are worth expert attention, not promotion:

| Candidate family | Status | Why it is still worth considering |
| --- | --- | --- |
| SR guarded/conservative QD | Diagnostic lead | Best synthesis-response archive family; live screen had promising recovery, but RTLLM reference-complete read was negative. |
| T36-style bounded front lane | Replay candidate | Best replay HV/front-hit combination; needs careful live implementation without post-hoc leakage. |
| RTL-native structural mix | Descriptor candidate | Best methodology story; T80 shows non-collapsed MasterRTL structural axes, but no live PPA result yet. |
| Verified pretrained encoder lane | Unproven | Strong external-review appeal, but only if real checkpoint loading, schema, and noncollapse are verified. |

## Reviewer Decision We Need

We need advice on whether to:

1. run one decisive full RTLLM comparison with a small selected config set;
2. pivot the TCAD claim away from "QD beats classic" toward a negative or
   diagnostic study;
3. redesign the QD algorithm around auxiliary memory, staged exploitation, or
   front-preserving cells rather than standard MAP-Elites pressure;
4. invest in verified pretrained circuit encoders, or stop using opaque
   encoders until they pass stronger collapse and live-front tests.
