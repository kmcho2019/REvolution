# Generic Candidate Goal Contract

Every candidate `/goal` must produce a scientific decision, not merely code.

## Required outputs

- hypothesis card and natural-extension score;
- minimal method specification;
- implementation and focused tests;
- frozen experiment manifest;
- smoke and development reports;
- holdout report when screen promotion gates pass;
- `decision.md` containing PROMOTED, RETIRED, or BLOCKED;
- methodology-ready description and limitations;
- adversarial validation report.

## Default iteration policy

1. Establish exact paired baseline.
2. Implement the smallest mechanism-complete version.
3. Prove code correctness and logging before live spend.
4. Run smoke only to detect catastrophic failure.
5. Run one development screen.
6. Permit at most two preregistered revisions.
7. Freeze and run holdout once.
8. Decide; do not tune on holdout or final results.
