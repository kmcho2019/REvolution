# Wave 2 Methodology Addendum

Status: `FROZEN`, 2026-07-21. Independent internal and external reviews
reproduced the arithmetic and executable state machine before candidate
treatment.

This addendum corrects process defects exposed by H5. It preserves the accepted
outcome definitions, classic comparator, metrics, practical margins, seeds,
benchmark manifests, and numeric resource thresholds. Revision 4 changes only
the prospective Wave-2 ladder and executable resource semantics. On any
conflict, `program_claims_contract_v4.md`, `baseline_contract.md`, and
`shared/program_manifest_v5.yaml` govern in that order.

## H5 Lessons

1. A candidate manifest translated a one-problem-per-seed coverage margin into
   an aggregate two-unit gate. The reporter then netted a gain in one seed
   against a two-design loss in another and emitted the wrong terminal label.
2. The mandatory smoke, representative, and full-suite matched arms exceeded
   every per-candidate discovery ceiling. Prelaunch reviews checked stage
   parity but did not sum the complete ladder.
3. The eight-design representative probe transferred weakly and consumed 1,536
   candidates without carrying a scientific decision.

## Wave 2 Candidate Ladder

Each Wave-2 candidate uses exactly this sequence:

1. Freeze one distinct mechanism card, a complete budget worksheet, and a
   contract-to-reporter gate table.
2. Complete code, test, simplicity, naturalness, novelty, and evidence-readiness
   reviews before model-backed spend.
3. Run the existing three-design technical smoke with fresh sequential classic
   and treatment arms. It is execution and telemetry evidence only.
4. Omit the separate eight-design representative probe. Small-screen transfer
   is weak and the stage does not fit the frozen candidate ceiling together
   with the full suite.
5. If smoke passes, freeze and run the complete 50-task, two-seed full-suite
   development pair sequentially. The 46 reference-complete tasks remain the
   PPA headline.
6. Audit raw evidence, contract translation, per-seed margins, cumulative
   resources, and gain concentration before writing the terminal decision.

The representative benchmark definition remains frozen for historical
comparability; omitting an optional diagnostic does not relabel any evidence.
No H5 result is reused as a Wave-2 control.

## Control-Inclusive Budget

The table below is H5 reference evidence, not an enforceable bound for a new
mechanism. Every number includes mandatory classic and treatment arms. A Wave-2
candidate must freeze separate per-arm caps before treatment evidence.

| Resource | Three-design smoke | Two-seed full suite | H5 actual total | Frozen ceiling | Headroom |
| --- | ---: | ---: | ---: | ---: | ---: |
| Candidates | 96 | 9,600 | 9,696 | 10,512 | 816 |
| LLM calls | 192 | 19,201 | 19,393 | 21,000 | 1,607 |
| LLM tokens | 473,209 | 58,767,350 | 59,240,559 | 66,000,000 | 6,759,441 |
| Synthesis evaluations | 61 | 5,056 | 5,117 | 6,000 | 883 |
| Endpoint-arm hours | 0.079355 | 5.062190 | 5.141545 | 6.000000 | 0.858455 |

For every Wave-2 card, the prospective envelope rule is fixed before candidate
selection: retain exact candidate counts, use the command-level maximum call
count, and take the larger ceiling of 110% of the two corresponding H5 arm
actuals for both members of each matched pair. Integer token and synthesis
counters use `(11 * value + 9) // 10`; wall time uses the decimal ceiling of
the unrounded raw seconds multiplied by 11/10. The pinned raw inputs and
reproduction rule are in `shared/wave2_budget_reference.yaml`. This yields:

| Arm | Candidates | Calls | Tokens | Synthesis | Wall s |
| --- | ---: | ---: | ---: | ---: | ---: |
| Smoke classic | 48 | 300 | 265,153 | 35 | 161 |
| Smoke treatment | 48 | 300 | 265,153 | 35 | 161 |
| Seed 1001 classic | 2,400 | 5,000 | 16,291,915 | 1,407 | 5,125 |
| Seed 1001 treatment | 2,400 | 5,000 | 16,291,915 | 1,407 | 5,125 |
| Seed 1002 classic | 2,400 | 5,000 | 16,146,270 | 1,415 | 4,985 |
| Seed 1002 treatment | 2,400 | 5,000 | 16,146,270 | 1,415 | 4,985 |
| Total | 9,696 | 20,600 | 65,406,676 | 5,714 | 20,542 |

The total endpoint-arm time is `5.706111111` hours. A versioned methodology
addendum is required before a later card can use another rule. A candidate card
may freeze smaller pair-equal envelopes; it may not enlarge these values or
reduce only one member of a matched pair. Before live spend, copy
`shared/candidate_budget_worksheet.template.md` into the candidate directory.
An independent reviewer must verify:

- all classic and treatment arms are included;
- candidate, call, token, synthesis, and endpoint-arm totals are below every
  per-candidate, Wave-2, and post-H5 program threshold;
- no repeated arm, representative probe, or revision is hidden from totals;
- resource feasibility is decided without inspecting performance outcomes.

The worksheet is immutable after freeze. One append-only Wave-2 program ledger
accepts each candidate's exact six arms and order, records completed and stopped
spend across candidates, and holds an exclusive lock across every validation
and append. Concurrent commands cannot admit overlapping candidates. The tool
computes, for every resource `r` before arm `k`:

```text
candidate_projection_r(k) = current-candidate actuals
                          + current-candidate unlaunched caps
wave_projection_r(k)      = all Wave-2 actuals + current unlaunched caps
program_projection_r(k)   = all Wave-2 actuals + current unlaunched caps
```

Count resources use exact integers and authoritative wall time uses exact
decimal seconds. Candidate counts and calls are bounded structurally by the
command, and the command timeout enforces wall time. The current concurrent
runner cannot atomically hard-cap authoritative
API tokens or synthesis starts without invasive cross-process changes. Those
two envelopes are therefore preregistered admission and post-arm stop gates,
not claimed dispatch guarantees. Adding a polling sidecar would create false
assurance because work can remain in flight.

An independent resource monitor writes an arm-bound accounting artifact with
the candidate ID, worksheet SHA-256, capture time, exact pending arm, required
`completed | timed_out` status, and hashed raw-evidence artifact. The fixed tool
writes it to the sealed program ledger and gives the launch operator only
`PASS` or `STOP`. A timed-out arm is charged and retires the candidate even when
its numeric totals fit. Synthesis count is a functionality proxy, so neither
its value nor a subtractable cumulative total is exposed before the terminal
decision. Apply all three projections before every classic and treatment arm,
not only after seed 1001.

Malformed, non-integral count, Boolean, missing-source, replayed, or
unauthenticated accounting returns `STOP` without appending a fabricated
zero-spend event. The admitted arm remains pending and no later arm is
admissible until the authoritative totals are reconstructed and charged.
Neither an accounting artifact nor its raw-evidence artifact may be reused by
another arm.
Program start and deadline are fixed UTC values spanning exactly 21 days.
Admission uses and records the process clock; no caller or candidate worksheet
can reset or forward-date that window.

If a projection fails or the post-arm resource gate returns `STOP`, launch no
later arm, seal all partial performance evidence, and record `RETIRED` for
budget infeasibility.
The decision may disclose resource totals only. `BLOCKED` remains reserved for
an external resource failure. Elapsed-time admission requires the current UTC
time plus all remaining sequential wall envelopes to be no later than the
program start plus 21 days.

A required classic rerun that the frozen zero-rerun worksheet cannot admit is
`BLOCKED`, not silently omitted or charged to a different arm. Resumption
requires an outcome-blind, versioned worksheet revision with the named
infrastructure failure and independent review before any output is read. No
generic resumption path is preimplemented: the candidate remains blocked until
that prospective worksheet, tool behavior, and retained-spend accounting
receive a separate review.

This one-arm overshoot risk is a frozen infrastructure limitation. It requires
prospective claims-contract review before Wave 2; it must not be hidden behind
an unimplemented sentinel. A token or synthesis envelope violation retires the
candidate and forbids every later arm.

## Contract-To-Reporter Gate Table

Every full-suite manifest and reporter test must encode these governing rules
directly:

| Surface | Governing rule | Evaluation scope |
| --- | --- | --- |
| Candidate benefit | Candidate-card endpoint is strictly positive in each development seed; all seeds must pass | Per seed |
| Final HV46 | Mean delta is at least -0.0050 | Pooled problem-seed units |
| HV-AUC46 | Mean delta is at least -0.0036 | Pooled problem-seed units |
| Valid-PPA coverage46 | Deficit is at most one design | Independently per seed |
| RTL functionality46 and 50 | Deficit is at most one design on each declared surface | Independently per seed |
| Candidate budget | Exact equality | Every arm |
| Auxiliary resources | Persistent matched skew is at most 10% | Per matched seed and pooled |
| Candidate discovery resources | Every total remains below its frozen ceiling | Smoke plus full suite, all arms |

The prelaunch test suite must include a distinguishing synthetic case where
coverage loses two designs in seed 1001 and gains one in seed 1002. That case
must fail noninferiority on valid-PPA46, RTL-functionality46, and
RTL-functionality50. A case with one loss in each seed must pass all three
surfaces. The manifest pins the test path and SHA-256. Generated labels never
override the governing contracts; post-run reviewers recompute the decision
from raw per-seed rows.

Every surface must contain exactly development seeds 1001 and 1002. The
aggregate catastrophic check sums only per-seed losses, so a gain in one seed
cannot offset a loss in another. A candidate terminal reporter must import this
shared implementation and add one end-to-end gate-translation test before its
manifest can freeze.

## Wave 2 Boundaries

- Select a distinct mechanism from an unresolved audited weakness. H5 operator
  ratios, mixtures, alternate correction prompts, no-C-F interactions, and
  nearby routing policies are barred.
- Keep classic byte-identical and use `eoh_operators` unless the candidate's
  single frozen mechanism is explicitly an operator-family treatment.
- One active candidate at a time; no parameter scan, fallback, hidden optional
  state, benchmark-specific condition, or treatment-dependent filtering.
- A reporter or process defect cannot be repaired by weakening a gate. Preserve
  the raw result, fix future tooling prospectively, and apply the accepted
  contract to the candidate decision.
