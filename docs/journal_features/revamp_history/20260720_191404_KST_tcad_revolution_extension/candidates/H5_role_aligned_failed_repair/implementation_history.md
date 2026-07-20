# H5 Implementation And Experiment History

Append candidate-specific state transitions, commands, raw roots, reports,
reruns, and decisions here. Program-level consequences also belong in the root
history.

## 2026-07-20: Code Gate

- Implemented one isolated `revolution_failed_parent_repair` mode at commit
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- Preserved the frozen classic engine and default configuration hashes.
- Closed focused, broad, static, external code, internal code, and evidence
  readiness reviews before live evidence.
- Froze a shared smoke configuration and sequential three-problem execution
  commands. No H5 model-backed result had been inspected at this transition.
- Program manifest revision 4 SHA-256:
  `1ace858fdaf2bc3a9468526a48293d674afac7badaa726592d3a72a0b624be34`.
- Smoke config SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`.
- Smoke experiment manifest SHA-256:
  `b663c89673bd3b8a336d3ef36253a7774f11550bc9421a374994dc2446792fb9`.

## 2026-07-20: Technical Smoke

- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42`.
- Ran fresh classic and H5 arms sequentially after a passing vLLM preflight.
  Each arm completed the three frozen problems at seed 42 with 48 total
  candidates and 96 LLM calls.
- The strict mechanism report accepted both runtime configs, all 96 candidate
  records, lineage, stage states, exact budgets, operator sets, and treatment
  pool trajectories. A replay reproduced every report file byte-for-byte.
- Classic failed-parent allocation was M-E 1, M-F 1, M-I 2, M-R 2, and M-S 2.
  All nine H5 failed-parent requests used M-F. Success-side operators remained
  the classic set in both arms.
- Classic had 31 valid-PPA candidates and H5 had 30; every design had at least
  one. Direct failed-parent valid-PPA repairs were 1 and 4, respectively. The
  `+0.0625` normalized delta is smoke telemetry, not performance evidence.
- Classic used 232,161 tokens in 140.14 wall seconds; H5 used 241,048 tokens in
  145.54 wall seconds. Both stayed inside the frozen stage budget.
- Independent read-only audit session
  `019f80e8-a363-7af3-81bd-43094e71a965` returned `PASS` with no technical
  finding and declared the representative probe technically admissible.
- Candidate state: `SMOKE_VALIDATED`.

## 2026-07-20: Representative Probe Freeze

- Froze the eight classic-only-selected tasks, development seeds 1001 and 1002,
  population 8, five generations, and fresh matched controls before inspecting
  representative treatment evidence.
- Shared run config SHA-256:
  `b3c85757e2d18b3fa94d00f8decfd44c6468fdc0139a2bd93bced3b7c8997169`.
- Problem manifest SHA-256:
  `9ed95986946980858b1391ce6c8725ba002959c864fed6706a0f8714b31286e5`.
- Experiment manifest SHA-256:
  `0dcbc2f1012a06d5aac3f0ed64abbdfecc87ee902b174fcd096128af3fe0266f`.
- Canonical probe report SHA-256:
  `15d2c6698a781ab5aa8dca46adefbbcec1c25edb4ea83b202a803aa68a0e0689`.
- The independent preregistration review found and closed incomplete metric,
  unit-accounting, resource, prompt-hash, and classic-only floor issues. Final
  verdict: `PASS`.
- No representative H5 result existed when the commands and hashes froze.
