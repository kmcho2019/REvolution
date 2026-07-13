# Seed-42 Smoke Package Review

Independent read-only review run with `claude -p` on 2026-07-13 UTC.

## Verdict

**PASS** - launch full-RTLLM seed 1001 unchanged.

No blocking finding was identified. Every load-bearing smoke-package claim
reproduced from raw artifacts.

## Independently Reconstructed Evidence

| Check | Classic | Pareto |
| --- | ---: | ---: |
| Problems x logged generations | 3 x 6 | 3 x 6 |
| Evaluated candidates | 144 | 144 |
| LLM calls | 288 | 288 |
| Prompt tokens | 508604 | 505900 |
| Completion tokens | 437614 | 432312 |
| Total tokens | 946218 | 938212 |
| Functional-any-pass | 3/3 | 3/3 |
| Valid-PPA coverage | 2/3 | 2/3 |
| PPA samples | 48 | 47 |
| Wall time | 682.73 s | 648.29 s |

Pareto used `-0.846%` fewer total tokens, inside the frozen `+/-10%` budget
bound. Runtime configs differ only in `save_path` and `search_mode`.

Operator reconstruction found only initial candidates and the classic EoH
operators. Classic counts were initial 24, M-F 15, M-S 24, M-E 24, M-R 21,
M-I 26, and C-F 10. Pareto counts were initial 24, M-F 12, M-S 21, M-E 27,
M-R 23, M-I 29, and C-F 8. Neither arm contained `M-T`, `C-D`, or
single-thought candidates.

Pareto summaries recorded the exact frozen objective contracts:

- Prob003: combinational, normalized reference gains, two active axes.
- Prob025: sequential, normalized reference gains, three active axes.
- Prob006: sequential, negative raw PPA, three active axes.

They also recorded `descriptors: false` and
`delivered_front: posthoc_only`. Classic summaries contained no Pareto
selection metadata. No descriptor, cell, or archive state was present.

The classic engine SHA-256 reproduced as
`78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
All source-touching commits stop at frozen evidence commit `0bb3fbc51d`; later
commits are documentation-only. Quoted report, config, manifest, addendum, and
engine hashes reproduced, and tracked compact CSV values matched the packaged
CSVs.

No benchmark or report process was active during review. The arm windows were
sequential and non-overlapping, no rerun siblings existed, and no full-RTLLM
root existed before launch.

## Non-Blocking Limitations

Prob006 produced functional candidates in both arms but no valid synthesized
PPA. The smoke therefore exercised the live raw-objective mapping and axis
assertions, but not raw-objective arithmetic on a successful candidate. The
review judged this non-blocking because the arithmetic is a short asserted
branch with an exact unit test and would fail loudly during seed 1001. The
frozen protocol must not substitute a task or tune the smoke.

Two report surfaces use different tie semantics for the descriptive HV-win
count. That field does not feed a frozen gate and must not be quoted without an
explicit tie rule. The generated comparison report's multi-objective winner
line is likewise not evidence; smoke metrics remain technical-only.

## Recommendation

Run a fresh 128k endpoint preflight, then launch the classic and Pareto
full-RTLLM seed-1001 arms sequentially with all 50 frozen tasks. Apply the
locked seed-1001 stop rule mechanically.
