# RF Timing State Gate Report

## Purpose

T81 tests whether a real MasterRTL pretrained artifact can produce useful,
noncollapsed descriptor state on generated RTL. This responds to the concern
that previous MasterRTL descriptors were only raw SOG/BOG counts or collapsed
pretrained Area-head leaves.

## Method

The probe uses:

- MasterRTL commit `5bccf38f8db7bb511a793a709863e7cb1b333ab5`;
- saved model `ML_model/saved_model/rfr_model.pkl`;
- saved training features `ML_model/saved_data/feat_all_lst.pkl`;
- T70 generated RTL extractor-smoke candidates.

For each candidate, the script loads the source-aligned SOG graph, runs
MasterRTL timing-DAG splitting and delay initialization, runs
`ProcessGraph.Graph_STA`, captures the exact eight-feature path vectors sent
to the RF timing model, and records RF predictions and leaf states.

## Findings

| Item | Finding |
| --- | --- |
| Model validity | The saved RF model loads under pinned compatible dependencies and asserts the expected eight path features. |
| Candidate coverage | `13/19` generated candidates evaluate; `6/19` are skipped as `no_clock_split`. |
| Non-collapse | The evaluated set has `53` unique RF leaf rows and `414` unique leaf IDs. |
| Feature range | Evaluated candidates have feature out-of-range fractions from `0.125` to `0.243` relative to saved RF training features. |
| Claim boundary | This is an offline descriptor gate, not a live QD or PPA result. |

## Recommendation

Proceed to one narrow runtime hook:

1. Use RF timing leaf-state clusters or prediction quantiles as one BD axis.
2. Use one raw structural axis, such as MasterRTL branching or sequential
   fraction, as the second BD axis.
3. Assign no-clock candidates to an explicit `no_timing_path` descriptor
   state rather than silently falling back to unrelated features.
4. Run a one-problem smoke, then the frozen eight-design `8x5` screen if the
   hook passes non-collapse and archive-artifact checks.

Do not run full RTLLM from T81 alone.
