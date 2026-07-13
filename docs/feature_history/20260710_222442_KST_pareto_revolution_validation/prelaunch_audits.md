# Pareto REvolution Prelaunch Audits

Audit date: 2026-07-13 UTC. Audit HEAD:
`5ba3fce7648c02c6506d43a6be0d4c03c3b15fdd`.

## Holdout Feasibility

The source inventory contains 156 VerilogEval-Spec-to-RTL tasks. The archived
conference root below contains one evaluated summary for every one of them:

`exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/deepseek_clean_results/VerilogEval-Spec-to-RTL`

- Source problem-id inventory: 156 entries, SHA-256
  `301e28ce3c9653a664b4fda2358202eafdaf0f1f8104e08f7a48085a80e6cf06`.
- Evaluated-summary inventory: 156 entries, SHA-256
  `4d9147f84d768f6f0b5071f282482933dc315ef3fa814ee43bfed4897def7629`.
- Source ids absent from the evaluated root: 0.

The reviewed fresh-holdout rule is infeasible. No task was substituted and no
exclusion rule was relaxed. Addendum V2 limits this campaign to development
evidence on RTLLM.

## Reference-Incomplete Circuit Types

The four RTLLM tasks without reference PPA are also the exact four tasks whose
loaded `ProblemSpec` circuit type is `unknown`. Their reference RTL establishes
the active objective count without a synthetic PPA reference:

| Task | Frozen type | Structural evidence |
| --- | --- | --- |
| `Prob006_adder_pipe_64bit` | sequential | Clocked pipeline state on `posedge clk` |
| `Prob013_multi_booth_8bit` | sequential | Clocked iterative multiplier state |
| `Prob018_float_multi` | sequential | Clocked counter and result state |
| `Prob040_synchronizer` | sequential | Clocked state in both clock domains |

The V2 config freezes this exact mapping. Pareto execution must assert the
unknown-task set and reject any other unknown circuit type. It cannot use the
QD synthetic-reference fallback.

## Coverage Definition Reconciliation

Canonical reanalysis of the shared classic seed-1001 root produced:

| Definition | Count |
| --- | ---: |
| RTLLM summaries | 50/50 |
| Functional any-pass | 42/50 |
| Valid-PPA coverage on locked manifest | 33/46 |
| Weak reference-beating coverage | 26/46 |
| Positive-HV coverage | 24/46 |

The apparent S07/S32 discrepancy was terminology, not different source data:
S07 reported valid-PPA coverage (`33/46`); S32 labeled positive-HV coverage
(`24/46`) simply as coverage. Future reports must name these counts
separately. The canonical gate uses valid-PPA coverage; positive-HV and weak
reference-beating counts are descriptive.

## Historical Survivor Audit

Classic generation logs record every newly evaluated successful candidate but
not each retained pool after environmental selection. They support
full-history Pareto/HV reconstruction but cannot identify every globally
nondominated candidate discarded at each historical generation. This state is
reported unavailable rather than inferred.

QD archive-event logs expose local insertions and evictions, but comparing
those events to unlogged classic retained pools would not be a symmetric
discard audit. No quantitative discarded-survivor claim is made.

## Comparator And Tool Freeze

- Classic roots: five complete 50-task roots under
  `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5`.
- V2 roots: five complete 50-task descriptive roots under
  `exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5`.
- Classic engine SHA-256:
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- Accepted narrative SHA-256:
  `aee1d8b7c2e3a5f54adf6003e8ca8ce988d393809152afa0d51dd737c05d3d8c`.
- Seed manifest SHA-256:
  `3f319e325d0fe8578ed54c565ad8f90affdd51935b06411cdd77e796a99e0629`.
- Locked 46-task manifest SHA-256:
  `92d6ad2981b04a8aed531ca04ca1ac085bb9fb6fee866ada2a4bf397ee52497b`.
- V2 execution config SHA-256:
  `22ed6fcfeaa18b8f8db526a47a456b1830e58a6808e46c2d6e290da9cfd2aadb`.
- Claims addendum V2 SHA-256:
  `cdf284610e5f9e0cdeca2b328ac9ca2a97439bf8d042ee5e11a887f641c2688e`.
- Python 3.11.15, Yosys 0.54+29, OpenROAD 2.0-22560, Icarus Verilog 12.0.
- vLLM preflight passed at `20.0.0.103:8000`: model
  `openai/gpt-oss-120b`, maximum context 131072.
- The historical roots do not retain enough server metadata to prove the same
  vLLM revision. Fresh matched classic runs are therefore required for every
  gate; historical classic and V2 are descriptive only.
