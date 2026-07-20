# Independent Candidate Statistics Review

- Date: 2026-07-20
- Mode: read-only independent subagent
- Scope: frozen baseline/statistical contract and H5-H7 evidence
- Initial verdict: `NOT READY`
- Live spend: none

## Findings

1. M-F is associated with higher failed-parent RTL-simulation yield, but not a
   resolved valid-PPA-yield improvement. Over 133 equal-weight comparable
   problem-seed units, the functional-yield delta is `+0.0643`, 95% CI
   `[+0.0179, +0.1199]`; valid-PPA-yield delta is `+0.0270`, CI
   `[-0.0126, +0.0781]`. These observational rates justify H5 as an experiment,
   not as an established improvement.
2. H5's draft `yield or final HV` development gate was outcome-disjunctive.
   Freeze one benefit before running the treatment.
3. The representative set has classic valid PPA and RTL-simulation success on
   all 16 problem-seed units. It cannot demonstrate coverage uplift and the
   full-suite catastrophic gate must not be applied there.
4. H6 is useful historical support but cannot be retroactively `VIABLE` under
   seed roles and margins frozen after its results existed.
5. Functionality counts denote pre-synthesis RTL-simulation any-pass. They must
   not be called hardened or post-synthesis functionality.
6. Historical no-C-F normalized-PPA direction depends on missing-data handling:
   penalized delta `-0.0110`, CI `[-0.0498, +0.0167]`, versus complete-case
   delta `+0.0109`.
7. H7 is an auxiliary ablation. Aggregate UCB allocation is already close to
   uniform and no prospective treatment evidence exists.
8. Confirmation must run all five fresh seeds without outcome-based early
   stopping. Per-candidate discovery ceilings must explicitly exclude
   confirmation and holdout.

## Dispositions

| Finding | Disposition |
| --- | --- |
| H5 benefit gate | `ACCEPT`: valid-PPA problem coverage must improve in each development seed; repair yield is telemetry. |
| Representative scope | `ACCEPT`: activation/regression only; no coverage or catastrophic claim. |
| H6 role | `ACCEPT`: move to `HISTORICAL_SUPPORT` outside the state machine. |
| Metric naming | `ACCEPT`: distinguish RTL-simulation functionality from verification-complete valid PPA. |
| Missing-data sensitivity | `ACCEPT`: prohibit an average-fitness claim and report both estimands. |
| H7 role | `ACCEPT`: defer outside candidate waves pending policy analysis. |
| Manifest/resources | `ACCEPT`: add smoke/holdout roles, CVDP reference flag, and discovery-only ceiling scope. |

## Required H5 Evidence

Report conditional failed-parent repair yield and unconditional successful
repairs per 48-candidate problem budget. Preserve parent ID, origin pool,
operator, parent/child verification stage, first-success generation, recovered
design count, downstream success-pool lineage, and valid-PPA/HV contribution.
The full-suite analysis must use all 92 fixed-denominator development units.

Subsequent hardware/EDA review accepted parent/stage and unconditional-count
telemetry but rejected descendant HV credit as ambiguous. The frozen H5 schema
therefore records direct repairs and pool trajectories without causal
descendant attribution.
