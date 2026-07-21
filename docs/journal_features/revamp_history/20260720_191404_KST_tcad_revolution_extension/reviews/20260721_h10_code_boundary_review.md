# H10 Preliminary Code-Boundary Review

Verdict: `ACCEPT_PRELIMINARY`

- Reviewer session: `019f836d-c7fe-7eb1-b305-dc7be1a0737d`
- Mode: independent read-only
- Candidate state reviewed: reduced one-line mechanism before implementation

## Accepted Boundary

- One `EoHEngine` subclass overrides only `_evaluate_candidates` and calls
  `super` before transforming consumed feedback.
- `success` is byte-identical; all six failure states receive exactly one line;
  `new` asserts impossible; unknown states reach `assert_never`.
- One fixed search-mode discriminant is sufficient. No scope or prefix option
  is permitted.
- `code_feedback.txt` remains the untouched critic artifact. One compact JSONL
  records status, prefix activation, hashes, and byte lengths.
- Direct prompt growth is one short line per selected failed parent and is
  unlikely to approach the 10% resource gate; measured resource parity remains
  mandatory.

## Rejected Alternatives

Exact raw failure diagnostics are unavailable after the clean subclass boundary
and would require a precritic sidecar. Existing artifact reads are incomplete
across evaluator stages, and full logs can materially expand prompts. The
review therefore blocked raw failure, all-candidate, and success-only payload
replacement while accepting only the categorical status invariant.

## Open Closure

The reviewer recommended RTL-simulation repair breadth. The drafted card uses
the stricter distinct-design valid-PPA repair breadth to match the program's PPA
objective and prevent the observed H5 event-gain/breadth-loss pattern. Re-review
the exact reporter and endpoint before `READY`.

## Exact-Card Review Round 1

Verdict: `BLOCK_FOR_READY`; mechanism boundary remains accepted.

The reviewer required a non-vacuous Gen0-parent smoke check, exact telemetry
filename/cardinality/lifecycle and critic-artifact hashes, unambiguous
either-seed retirement, explicit strict-format/default-prompt/backend dispatch
assertions, complete removal surfaces, reporter join tests, and prospective
confirmation/holdout rules. The card incorporates every item without changing
the treatment. Closure rereview remains required.
