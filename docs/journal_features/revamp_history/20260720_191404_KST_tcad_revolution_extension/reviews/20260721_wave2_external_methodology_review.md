# Wave 2 External Methodology Review

- Date: 2026-07-21
- Reviewer: Claude Code through read-only `claude -p`
- Timeout allowance: 600 seconds
- Initial verdict: `PASS_CONDITIONAL`
- Final closure verdict: `PASS`

The review compared the H5 contract audit, prospective revision-4 claims
contract, Wave-2 addendum, manifest and budget templates, and executable gate
requirements. It edited no file. Treatment remained disabled while its five
conditions were closed.

## Verified Findings

1. The pair-equal arm caps sum to 9,696 candidates, 20,600 calls, 65,406,676
   tokens, 5,714 synthesis starts, and 20,542 endpoint-arm seconds. Removing the
   representative stage explains the difference from the independently audited
   H5 ladder.
2. Per-seed, per-surface coverage gates repair H5's invalid cross-seed netting.
   The required two-loss/one-gain and one-loss-per-seed tests distinguish the
   governing rules.
3. Omitting the representative probe is valid only as a prospective revision:
   it carried no positive claim gate, transferred weakly, and no evidence is
   relabeled.
4. Non-atomic token and synthesis enforcement is defensible only when disclosed
   as a sequential post-arm eligibility gate. Any overrun must retire the
   candidate, seal performance, charge actual spend, and forbid later arms.
5. A required classic infrastructure rerun that cannot fit the zero-rerun
   worksheet must become `BLOCKED` until an outcome-blind versioned worksheet is
   independently reviewed.

## Conditions And Dispositions

| Condition | Owner disposition |
| --- | --- |
| Reproduce every arm envelope from raw H5 resource evidence. | `ACCEPT`: `shared/wave2_budget_reference.yaml` pins the raw CSVs; the admission test recomputes the caps. |
| Freeze claims-contract revision 4 and program-manifest version 5. | `ACCEPT`: freeze only after all independent reviews pass and hashes replace placeholders. |
| Add contract-to-reporter tests for per-seed coverage. | `ACCEPT`: the shared gate test requires both seeds and prevents noninferiority and catastrophic netting; each candidate reporter must add an integration test. |
| Pin the admission tool, append-only ledger behavior, and tests. | `ACCEPT`: exact six-arm sequence, worksheet hash binding, resource reconstruction, and ceiling cases are tested; final hashes belong in manifest v5. |
| Freeze each candidate worksheet independently before treatment. | `ACCEPT`: this remains a candidate-level launch precondition, not a program-level assumption. |

## Residual Disclosures

- One executing arm can exceed its token or synthesis envelope before the
  authoritative post-arm check. This cannot support performance evidence and
  may cause conservative candidate retirement.
- `PASS`/`STOP` is a minimal outcome-correlated bit because synthesis count
  proxies functionality. It stays sealed from candidate selection within the
  wave.
- The envelope favors mechanisms that fit the fixed REvolution compute budget.
  A more expensive mechanism requires a new prospective methodology rather than
  an exception.

These are scope and infrastructure limitations, not permission to weaken a
numeric ceiling or comparison gate.

## Closure Retry

A second focused read-only retry received the full corrected tool and contract
surface with a 600-second timeout. It exited 124 with only `Execution error` and
therefore supplies no additional evidence. The independent internal reviewer
reproduced the corrected arithmetic and 25 focused tests and returned `PASS`;
the earlier external conditions remain the only Claude findings used here.

## Final Closure Recheck

A third read-only review used the current tree after the internal serialization
and code-audit fixes. It returned `PASS` and independently verified:

- `fcntl.LOCK_EX` spans ledger load, validation, and append, with a real
  four-process contention test;
- accounting and raw-evidence hashes are both unique and replay returns `STOP`
  without ledger mutation;
- the resource reference is accurately labeled as terminal H5 pair-derived
  telemetry rather than classic-only evidence;
- current backend SHA-256 and Git blob provenance are distinct from, and retain,
  the historical classic-baseline backend hash;
- the contract, addendum, templates, constants, and per-seed coverage helper
  encode the same state machine and arithmetic.

Claude could not execute tests in its read-only session. The owner separately
ran 37 focused tests plus Ruff, Pyright, and `ty`; all passed. The only residual
limitations are the already disclosed one-arm token/synthesis overshoot and
the one-bit `PASS`/`STOP` resource-gate leak.
