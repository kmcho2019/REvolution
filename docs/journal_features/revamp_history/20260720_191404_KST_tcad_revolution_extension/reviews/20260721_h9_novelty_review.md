# H9 Novelty And Naturalness Review

Verdict: `BLOCK`

- Reviewer session: `019f834f-ec2b-7dd3-ab9c-73cd1274fb71`
- Mode: independent read-only
- Candidate state reviewed: pre-implementation proposal

## Findings

1. AlphaEvolve already uses parent-relative deltas inside evolutionary code
   search and reports a Verilog hardware-optimization case.
2. CodeEvolve explicitly branches between diff-based evolution and full-code
   rewrite. Delta evolution is therefore not a defensible H9 novelty claim.
3. The classic premise selected 1,900 success-origin one-parent rows while H9
   proposed changing all 4,000 post-Gen0 rows. Independent recomputation found
   the fail-origin association reverses direction.
4. The treatment would identify the complete strict-diff protocol, including
   output schema and instructions, not edit breadth alone.
5. REvolution individuals remain full code objects; calling a generation
   protocol a new evolutionary representation overstates the method delta.

## Verified Disposition

The owner checked the two direct literature collisions against the primary
papers and reproduced the 4,000-row stratum counts and correlations from raw
classic artifacts. The reviewed score is `2/1/1/2/1/2/0 = 9/14`; novelty zero
triggers hard rejection. H9 is retired without implementation or live spend.
