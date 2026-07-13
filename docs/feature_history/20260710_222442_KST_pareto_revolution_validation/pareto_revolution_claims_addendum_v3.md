# Pareto REvolution Claims Addendum V3

Status: preregistered before implementation and live evidence.

V3 supersedes V2 only for the four clarifications below. Every other V2 method,
comparator, metric, stop rule, and forbidden-follow-up clause remains frozen.
This revision adds no treatment and changes no search mechanism.

1. The three-problem seed-42 check uses the same `8 x 5` candidate budget as
   the full-suite arms. It is technical evidence only; no performance inference
   or promotion decision may use it. This meaning supersedes the V2 config's
   `technical_and_directional_only` label.
2. Every tournament draws contestants uniformly with `random.sample` from the
   run-seeded Python RNG. The second `C-F` tournament uses the same rule after
   excluding the first winner.
3. The two-seed promotion gate remains final mean HV at least fresh classic so
   an exact tie may continue to confirmation. Positive development evidence at
   five seeds requires final mean HV strictly greater than fresh classic;
   valid-PPA and functional-any-pass coverage may tie. Exact final-HV parity is
   a supporting result.
4. Because the user requires `src/revolution/algorithm.py` to remain
   byte-for-byte unchanged, the isolated engine must record copied classic
   generation-loop line ranges and source commit. The pre-seed-1001 audit must
   compare the experimental override against that source and verify that only
   successful-parent and successful-survivor selection differ.
