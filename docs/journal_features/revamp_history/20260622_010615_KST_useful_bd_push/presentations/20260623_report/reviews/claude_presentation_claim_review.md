# Claude Presentation Claim Review

Date: 2026-06-23 UTC

Prompt summary:

```bash
claude -p "review the 20260623 presentation package for claim-evidence alignment"
```

The full prompt asked Claude to inspect the report, slides, README, glossary,
retrospective package, full RTLLM package, and review logs for overclaiming,
stale status, unclear terminology, missing caveats, and retrospective clarity.

## Key Findings

1. `Prob040_synchronizer` was treated asymmetrically: it was removed to show
   HV sensitivity but retained in the all-RTLLM best-score loss.
2. The same `Prob040` cell reports near-max QD HV and catastrophic scalar
   `best_score`, so it should be quarantined from both optimistic and
   pessimistic headline claims.
3. The screen-excluded cohort still contained `Prob040`, so it needed its own
   caveat or screen-plus-Prob040-excluded rows.
4. The T26 screen selection was weak and reversed on the same screen problems
   in the full run; that should be called a determinism and selection-validity
   caveat.
5. The retrospective term `restart` was undefined for a reader.
6. `commands/full_rtllm_v0.md` still used stale claim status `reviewable`.

## Resolution

- The report now states that `Prob040` should be quarantined from both HV and
  best-score headlines.
- The executive answer and conclusion now use `Prob040`-excluded best-score
  parity instead of treating all-RTLLM best score as an independent weakness.
- The report and package README now include screen-plus-Prob040-excluded rows.
- The report now records the screen-selection reversal on the same three
  screen problems.
- The retrospective README defines the restarted 20260621 pass.
- The full-run command record now uses claim status `diagnostic`.
