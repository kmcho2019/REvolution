# Executive Summary

Classic REvolution remains the strongest method found so far. It behaves like
a small-budget, direct PPA hill climber, and this appears well matched to RTL
generation where candidates are expensive and functional validity is fragile.

The current result is not that QD is impossible. The result is narrower:

> Under tested budgets and tested descriptor/archive-coupling policies,
> QD/MAP-Elites pressure has not yet earned its evaluation cost versus classic
> REvolution on reference-complete PPA hypervolume.

Best current representative results:

| Lane | Best representative | QD HV | Matched classic | Status |
| --- | --- | ---: | ---: | --- |
| MasterRTL auxiliary archive | `masterrtl_aux_archive_high_exploit_8x5` | `0.1261` | `0.1442` | 3-seed negative |
| MasterRTL RF leaf-ID | `T83_rf_leafid_structural_delayed_qd` | `0.1260` | `0.1442` | 3-seed negative |
| Delayed archive timing | `masterrtl_delayed_archive_activation_8x5` | `0.1324` | `0.1406` | single-seed clue |
| Pure DeepGate | `T95_deepgate_delayed_high_exploit_8x5` | `0.1153` | `0.1406` | negative |
| RF/DeepGate hybrid | `T96_rf_deepgate_hybrid_delayed_8x5` | `0.1199` | `0.1406` | negative |
| AURORA/raw implementation | `T99_aurora_raw_impl_delayed_qd` | `0.1201` | `0.1406` | negative |
| Qwen3 RTL embedding | `qwen_canonical_rtl_pca3_8x5` | `0.1108` | `0.1406` | weak live result |
| FG-QDM RF memory | `T100_fg_qdm_rf_leafid_front_credit_12x3` | `0.1566` | `0.1903` | smoke-only negative |

What seems most important:

- Generic descriptor spread is not enough.
- Archive fill and archive parent sampling often cost more than they return.
- Classic's direct quality pressure is very strong at small budgets.
- The most plausible future route is QD as guarded auxiliary memory or
  adaptive diversification around PPA-competitive families, not full
  descriptor-space illumination.

What we need from reviewers:

- Identify mechanisms that preserve classic's hill-climbing advantage while
  using diversity to avoid premature family collapse.
- Propose descriptor or encoder objectives that are more likely to preserve
  useful RTL implementation families than current Qwen/DeepGate/MasterRTL
  axis swaps.
- Recommend a small, decisive experiment that can show whether the idea has a
  real chance before spending full RTLLM budget.
