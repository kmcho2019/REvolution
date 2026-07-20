# REvolution Component Evidence Audit

Status: `EVIDENCE_FROZEN`; candidate ranking review closed with H5 `READY`.

This audit uses completed historical runs to test the conference method's
operator claims before spending on a new mechanism. It generated no LLM or EDA
work. All headline comparisons use the 46 reference-complete RTLLM tasks and
the missing-as-zero policy in `baseline_contract.md`.

## Provenance

| Arm | Root | Seeds | Problem logs | Candidate rows |
| --- | --- | --- | ---: | ---: |
| Classic | `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5` | 1001-1005 | 250 | 12,000 |
| No C-F | `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_no_cf_8x5` | 1001-1005 | 250 | 12,000 |

The arms use the same model, 8-by-5 candidate budget, evaluator, dual pools,
UCB selection, and EoH operators. The no-C-F arm changes only
`eoh_success_operator_set` from `classic` to `one_parent`.

The operator report was regenerated with:

```bash
uv run python scripts/report_revolution_operator_evidence.py \
  --run classic=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5 \
  --run no_cf=exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_no_cf_8x5 \
  --output-dir exp/tcad_revolution_extension/component_evidence_20260720/operator_evidence
```

The canonical PPA chronology and AUC were regenerated with
`scripts/report_ppa_distribution.py` over ten labeled seed roots, followed by:

```bash
uv run python scripts/report_hv_auc.py \
  --ppa-candidates exp/tcad_revolution_extension/component_evidence_20260720/no_cf_canonical/ppa_distribution/data/ppa_candidates.csv \
  --num-generations 5 \
  --output exp/tcad_revolution_extension/component_evidence_20260720/no_cf_canonical/hv_auc.csv
```

## Descriptive Operator Evidence

These rates are observational. Parent quality, pool composition, and UCB
allocation change during a run, so a higher rate does not identify a causal
operator effect.

| Pool | Operator | N | RTL-sim functional | Valid PPA | Rewarded |
| --- | --- | ---: | ---: | ---: | ---: |
| Fail | M-E | 771 | 17.0% | 2.7% | 2.7% |
| Fail | M-F | 804 | **26.1%** | **7.1%** | **7.1%** |
| Fail | M-I | 805 | 21.0% | 5.1% | 5.1% |
| Fail | M-R | 784 | 17.3% | 4.5% | 4.5% |
| Fail | M-S | 802 | 20.8% | 4.5% | 4.5% |
| Success | C-F | 1,155 | 74.5% | 70.1% | 8.6% |
| Success | M-E | 1,178 | 51.4% | 46.7% | 8.5% |
| Success | M-I | 1,251 | 68.5% | 63.5% | 11.7% |
| Success | M-R | 1,194 | 72.9% | 66.9% | 11.0% |
| Success | M-S | 1,256 | 83.1% | 79.3% | 13.2% |

M-F is the best observed failed-parent operator on all three outcome rates. Its
prompt is dedicated to correcting a failed attempt, while M-I mixes correctness
and PPA improvement and M-S/M-E/M-R request broader transformations. Every
operator receives the parent's stored evaluator feedback. The evidence supports
a causal test of exclusive dedicated-correction routing; it does not establish
that M-F-only allocation will improve a new run or that generic operators ignore
failure evidence.

An equal-weight, problem-clustered reanalysis over 133 comparable problem-seed
units estimates an M-F functional-yield difference of `+0.0643`, with 95% CI
`[+0.0179, +0.1199]`, relative to the other failed-parent operators. The
valid-PPA-yield difference is `+0.0270`, with CI `[-0.0126, +0.0781]`.
Functional repair is associated with M-F after problem-level reweighting, but
the valid-PPA association remains unresolved. UCB allocation, parent quality,
and pool state still confound both observational comparisons.

C-F is below M-I, M-R, and M-S on rewarded-child rate, but it has high valid-PPA
yield. The logs therefore do not justify calling fusion harmful.

## Classic Failed-Parent Policy Trajectory

The regenerated reporter also measures whether classic UCB already concentrates
failed-parent requests on M-F. It does not:

| Generation | Active problem-seed units | Fail requests | M-F requests | M-F share | Mean logged M-F probability | Mean TV from uniform |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 155 | 983 | 194 | 19.7% | 21.0% | 17.6% |
| 2 | 125 | 834 | 185 | 22.2% | 21.1% | 23.1% |
| 3 | 110 | 757 | 146 | 19.3% | 19.8% | 17.7% |
| 4 | 101 | 715 | 141 | 19.7% | 20.5% | 10.1% |
| 5 | 93 | 677 | 138 | 20.4% | 20.1% | 7.1% |

Across all 3,966 classic failed-parent requests, M-F receives 804, or 20.3%.
Its generation-2 increase is not sustained, and the five-operator policy moves
closer to uniform by generation 5. Thus H5 is causally distinct from what
classic UCB already does at this budget. This finding strengthens the need for
a controlled role-constraint test; it still does not predict that M-F-only will
improve coverage or HV.

## Canonical No-C-F Comparison

| Metric | Classic | No C-F | Delta | 95% problem-cluster CI | W/L/T |
| --- | ---: | ---: | ---: | --- | --- |
| Final HV46 | 0.103802 | 0.106846 | +0.003044 | [-0.004214, +0.013837] | 41/41/148 |
| HV-AUC46 | 0.086982 | 0.094729 | +0.007747 | [-0.000467, +0.018882] | 50/46/134 |
| Valid-PPA | 164/230 | 166/230 | +2 | descriptive | 7/5/218 |
| RTL-sim functionality | 188/230 | 191/230 | +3 | descriptive | 9/6/215 |

Across all 50 RTLLM tasks, RTL-simulation functionality is `208/250` for
classic and `211/250` for no-C-F. The two later-designated development seeds
alone have final HV `0.104479` versus `0.099809`, delta `-0.004671`, CI
`[-0.020366, +0.006758]`, and HV-AUC `0.085867` versus `0.090240`, delta
`+0.004373`, CI `[-0.001067, +0.010573]`. Valid-PPA and 46-task
RTL-simulation coverage are both tied at `66/92` and `76/92`.

The final-HV exact sign-test p-value is `1.0`, Wilcoxon p-value is `0.9410`,
and paired t-test p-value is `0.5994`. For HV-AUC they are `0.7596`, `0.3374`,
and `0.0973`. These tests are secondary to the frozen clustered interval.

No-C-F final-HV seed deltas are `-0.010665`, `+0.001324`, `-0.003598`,
`+0.010771`, and `+0.017387`. Leaving out seed 1005 makes the mean delta
`-0.000542`. HV-AUC deltas are positive in development seeds 1001 and 1002,
but seed 1003 loses `0.001198`. Fusion removal is therefore a useful
trajectory/coverage simplification, not a resolved final-HV win.

Resource accounting is matched: classic versus no-C-F used 24,003 versus
24,001 calls and 74.408M versus 73.062M tokens, a 1.8% difference. Summed
per-problem generation runtime differs by 1.2%.

No average-fitness improvement is claimed. Under the frozen missing-result
floor, the best normalized-PPA delta is `-0.0110`, CI
`[-0.0498, +0.0167]`; the valid-pair complete-case delta is `+0.0109`.
Missing-result handling changes the direction, so both surfaces must accompany
any later use of this historical evidence.

## Decisions Enabled By This Audit

1. **Advance M-F-only failed-pool routing to scientific review.** It tests
   whether the dedicated correction intent should exclusively serve the failed
   pool and can be isolated with the existing EoH M-F operator.
2. **Record no-C-F as retrospective historical support.** Its current seed
   roles, AUC gate, and margins were frozen after these outcomes existed. It is
   useful component evidence, but it is outside the prospective candidate
   state machine and cannot receive a retroactive `VIABLE` outcome.
3. **Keep UCB-versus-uniform outside the candidate wave.** Aggregate classic
   allocations are already near uniform and the mechanism has no hardware/CAD
   grounding. Run it only if a policy-allocation audit establishes an
   informative diagnostic question.
4. **Do not promote stage-aware rewards or retained partial failures yet.**
   COEVO occupies continuous correctness, category rewards, and adaptive gates;
   retaining old failed lineages also requires copying or refactoring the
   monolithic classic generation method.
5. **Do not revive QD, global Pareto, or single-thought operators.** Their
   frozen negative evidence addresses those mechanism families directly.

## Integrity Hashes

| Artifact | SHA-256 |
| --- | --- |
| Canonical `hv_auc.csv` | `15f2025a9eb4506b238e3043037d870db79d9da385f09d37196461d1d07aa891` |
| PPA summary | `bf14cbd0c411327bbc3616b361dd04de33279f95b1946f09010dfbc76a2ae813` |
| Operator yield | `8d0f6669f8366bc261bcdb014dbfec2b588707f3fe342a947e2d174263d15b98` |
| Status distribution | `93494030f81ec693d6d4238d11cd4e908b3a140d4db0d6dea6ebcaa4cf56469a` |
| Failed-policy units | `591012f684b2714b630a3bedc135038d481f178c95b538d021726cf92a7bb2e0` |
| Failed-policy by generation | `bff38dfe3e53a8261232266394c23f8dd78ebafd62c2b41ee36eb6f15d95f186` |
