# Claude V1 Prelaunch Review

Date: 2026-07-13 UTC.
Command: `claude -p`, read-only prelaunch prompt, 900-second timeout.
Result: completed with exit code 0 after approximately ten minutes.
Verdict: `FAIL`.

## Blocking Findings

1. The four RTLLM reference-incomplete tasks have
   `ProblemSpec.circuit_type == "unknown"`. The V1 contract requested negative
   raw active PPA without defining active axes. Freeze a reviewed circuit type
   for each task and assert the exact mapping at runtime.
2. The V1 small check used `Prob024_fsm`, whose current PPA proxy has effective
   period zero and therefore did not exercise the three-objective path. Use a
   genuine sequential reference-complete task and exercise a raw-objective
   reference-incomplete task.
3. The scaffold called plan-table Stage 4 unavailable even though Stage 4 is
   RTLLM seed 1002, retained an impossible holdout as a prelaunch requirement,
   and left primary-win language active. Discharge the infeasible holdout and
   make the unreachable paper-facing stage consistent everywhere.

## Optional Findings Accepted

- Do not inherit the QD synthetic-reference fallback. Accept only the exact
  frozen unknown-task mapping.
- Candidate UUID is random and must not break selection ties. Use a unique
  insertion index as the strict total order; retain UUID only for auditing.
- Both classic and Pareto already place successes before failures because
  classic failures have `-inf` score. Describe the actual changes as scalar
  ordering and champion-lane removal among successes.
- Record historical classic seed-1001 mean HV
  `0.1114014700215706` and its 90% diagnostic
  `0.10026132301941354`.
- Historical server metadata is insufficient to prove an identical vLLM
  revision. Use fresh matched classic for all gates and keep old roots
  descriptive.

## Optional Finding Rejected

The reviewer suggested small parent/survivor hooks in
`src/revolution/algorithm.py` to reduce generation-loop duplication. The user
explicitly requires the classic core engine to remain intact. This campaign
instead keeps that file byte-for-byte unchanged and isolates the experimental
engine under `src/revolution/pareto_revolution/`, with classic regression and
file-hash checks. The tradeoff is a small, explicit experimental orchestration
override rather than mutation of the conference engine.
