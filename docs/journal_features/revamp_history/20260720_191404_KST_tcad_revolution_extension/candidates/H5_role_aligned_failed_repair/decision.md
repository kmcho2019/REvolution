# H5 Candidate Decision

Current state: `SUITE_EVALUATED`.

## Outcome

`RETIRED`

Allowed outcomes: `PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, `BLOCKED`.

## Frozen Hypothesis And Gates

`hypothesis_card.md` froze M-F-only failed-pool routing as a one-factor core
correction. The benefit endpoint was unconditional fail-origin valid-PPA
repairs per fixed 48-candidate problem budget, required to improve in each
development seed. Every other primary surface had to remain inside the
practical limits in `baseline_contract.md`, including a valid-PPA and
RTL-functionality deficit of at most one problem per seed.

## Evidence By Stage

- Code gate: `PASS` at implementation commit
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- Technical smoke: `PASS`; three problems, seed 42, exact activation and
  candidate budgets, complete telemetry, and no infrastructure failure.
- Representative diagnostic: technical `PASS`; all 32 arm units completed and
  registered repair direction was positive at both development seeds.
- Full suite: all 200 arm units completed across 50 RTLLM problems and seeds
  1001-1002 at execution HEAD `69eff4aa733499738fe5494ff58bd745735987b6`.
  There were no missing units, exclusions, or reruns.
- Confirmation and holdout: not authorized after the terminal suite decision.

## Full-Suite Results

| Metric | H5 minus classic | 95% problem-cluster CI | W/L/T |
| --- | ---: | --- | ---: |
| Direct valid-PPA repair rate, all 50 | +0.001667 | [-0.002292, +0.006250] | 14/12/74 |
| Final HV46 | +0.006678 | [-0.000627, +0.017287] | 20/11/61 |
| HV-AUC46 | +0.004498 | [-0.002928, +0.016273] | 24/15/53 |
| RTL functionality50 | -0.010000 | [-0.050000, +0.020000] | 1/2/97 |
| Valid-PPA coverage46 | -0.010870 | [-0.043478, +0.021739] | 1/2/89 |
| Valid-PPA sample yield46 | +0.009964 | [-0.007020, +0.026947] | 34/24/34 |

Repair-rate, final-HV, and HV-AUC directions were positive in both seeds.
Direct valid-PPA repairs were 36 to 41 at seed 1001 and 37 to 40 at seed 1002,
or 73 to 81 pooled. The confidence intervals include zero.

## Governing Gate Failure

The canonical reporter emitted `VIABLE`, but its aggregate coverage gate is a
contract-translation defect. It summed signed deficits across seeds and
allowed the seed-1002 gain to offset the seed-1001 loss. The accepted claims
contract, frozen baseline contract, and machine-readable program manifest
instead require a deficit of at most one problem independently in each seed.

At seed 1001, verification-complete valid-PPA coverage fell from 34/46 to
32/46. The two-problem deficit fails the frozen primary-surface margin. Seed
1002 improved from 32/46 to 33/46, but cannot rescue a per-seed failure. Under
the contract hierarchy, this requires `RETIRED`; the generated reporter label
is preserved in `full_suite_probe/summary.json` for auditability.

## Resource-Ceiling Deviation

The complete H5 discovery ladder also exceeded every frozen per-candidate
ceiling when mandatory fresh classic controls are counted. Smoke,
representative, and full-suite discovery consumed 11,232 candidates, 22,466
calls, 69,289,552 tokens, 6,056 synthesis evaluations, and 6.231970
endpoint-arm hours, versus ceilings of 10,512, 21,000, 66,000,000, 6,000, and
6.0. Full-suite arms themselves remained matched; this is a program-process
violation, not a within-pair fairness claim.

## Mechanism And Causal Findings

- Every one of 1,561 H5 failed-parent requests used M-F; both arms retained the
  five classic EoH success operators.
- The net repair gain is primarily syntax-stage correction and occurs in fewer
  problem-seed units than classic, so it does not establish broader reliability.
- `Prob024_fsm` contributes seven of the net eight repairs, making the benefit
  highly concentrated.
- `Prob036_edge_detect` contributes 63.97% of final-HV uplift and 114.13% of
  HV-AUC uplift despite zero failed-parent requests in both arms and seeds.
- Excluding `Prob036`, final-HV delta remains +0.002459 but HV-AUC becomes
  -0.000650. Excluding the four largest gain problems makes final-HV delta
  -0.000964.

These diagnostics reject a causal claim that increased repair events produced
the observed PPA uplift.

## Naturalness, Novelty, And Code

H5 remains a clean and natural conference-component ablation: one fixed search
mode narrows failed-pool routing while classic success evolution stays intact.
The classic engine and default configuration retain their frozen hashes, and
the model-backed run used only `eoh_operators`. Its TCAD novelty is nevertheless
thin: M-F is a generic Verilog correction prompt, and the measured benefit is
syntax-oriented rather than a new hardware/CAD repair principle.

## Review Findings And Dispositions

The prelaunch review missed the aggregate-versus-per-seed gate mismatch and the
cumulative budget arithmetic. Two independent post-run audits identified the
conflict and converged on `FAIL / RETIRED` after explicit arbitration. A focused
read-only `claude -p` review independently confirmed both findings. The reviews
are recorded under `../../reviews/`. No gate, contract, raw arm, or generated
report was changed after observing outcomes.

## Allowed Claim And Paper Role

Allowed: under the frozen two-seed RTLLM development protocol, M-F-only routing
produced five and three additional direct fail-origin valid-PPA repairs at
equal full-suite candidate budgets. Mean final HV and HV-AUC were higher but
unresolved; aggregate valid-PPA and RTL-functionality coverage each ended one
unit below classic; seed 1001 exceeded the valid-PPA coverage margin.

Not allowed: `VIABLE`, coverage preservation, general reliability improvement,
causal PPA improvement, integration, confirmation, or journal candidacy. H5 is
retained as scoped negative-map evidence that role alignment can increase
repair events without reliably broadening design coverage or causing PPA gain.
