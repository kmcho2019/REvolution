# Technical Stack And Infrastructure

## Runtime Stack

| Layer | Current implementation |
| --- | --- |
| Language/environment | Python 3.11+, `uv`, typed repository modules, `pytest`, `ruff`, pyright/ty checks |
| Main runner | `scripts/run_backend.py` with elastic multi-problem scheduling |
| Classic search | `EoHEngine`: direct-code Thought/Code/Feedback individuals, dual Fail/Success pools, EoH prompt operators, UCB/random/epsilon strategy selection |
| QD search | `QDEngine`: grid, quantile-grid, and CVT archives; scalar, Pareto, and elite-slot cells; multiple parent-selection modes |
| LLM | Local `openai/gpt-oss-120b` through vLLM, 131072 context, 128000 output caps; optional OpenAI-compatible, DeepSeek, Gemini, and OpenRouter providers |
| Functional evaluation | Icarus Verilog for RTLLM/VerilogEval; cocotb/Icarus for CVDP; Verilator for RealBench |
| Synthesis/PPA | Yosys + OpenROAD with Nangate45, typical corner, synthesis/floorplan-stage proxies |
| Verification | Post-synthesis simulation on reference-bearing small suites; Yosys equivalence spot-check script; RealBench pre-synthesis functional gate plus synthesis sanity policy |
| Reporting | PPA Pareto fronts, global HV, fixed-denominator HV-AUC, PPA distributions, descriptor health, archive histories, paired statistics |
| Reproducibility | Seeds 1001-1005, locked manifests/configs, vLLM preflights, operator-contract audits, run validators, signed atomic commits |

## Current Experiment Shape

The suite campaign uses population 8, five generations, 4800 LLM API calls
per full 50-problem RTLLM run, 48 total worker slots, 12 active problems, and
four workers per problem. Recent full-suite seeds finish in roughly 80-90
minutes on the shared endpoint, subject to queue and EDA load.

The headline normalized RTLLM denominator is 46 designs. Four of 50 RTLLM
problems lack usable reference PPA and are excluded from normalized HV.

## Benchmark State

| Suite | Current capability |
| --- | --- |
| RTLLM | 50 tasks, 46 reference-PPA complete; primary full-suite PPA surface |
| VerilogEval-Spec-to-RTL | Functional and reference-normalized PPA support; hard and held-out manifests exist |
| CVDP | Cocotb functionality works after prompt-interface repair; easy 9/10 and medium 7/10 for both classic and V2 in prior debug evidence; normalized PPA is not a current claim surface |
| RealBench e203 | 34 synthesizable modules with generated reference PPA; 23 carry nondegenerate timing; large from-scratch candidates remain functionally invalid |

## Measurement Model

PPA values are synthesis-stage proxies, not signoff results. The flow stops
before placement, CTS, routing, and parasitic extraction. Power uses estimated
activity; timing uses the repository's effective-clock proxy and a uniform
clocking policy. Comparisons are paired within a problem and use the same flow
for treatment and baseline.

Sequential and combinational designs use different active objective sets:
power/area/timing for sequential designs and power/area for combinational
designs. The timing axis is dropped for combinational designs rather than
zero-filled.

## Known Infrastructure Risks

- Heavy parallel RealBench evaluation can undercount valid candidates under
  resource contention. Use capped concurrency and isolated re-verification.
- RealBench uses two-state Verilator semantics and skips gate-level functional
  re-simulation because the golden itself can mismatch after synthesis. Its
  synthesis sanity check prevents stubs but does not prove equivalence.
- Some benchmark testbenches have don't-care behavior that makes unrestricted
  formal equivalence inappropriate.
- Full-suite means are sensitive to a small number of high-HV problems.
- Comparator variation can exceed the small deltas separating QD variants.
- The accepted journal contract's held-out reference set has not been run for
  the current QD headline.

## Code Organization Posture

The recent natural-QD campaign kept experimental mechanisms outside core loop
files. The small natural parent-sampling extension lives under
`src/revolution/qd_natural/`; reporting and validation stay under `scripts/`.
The proposed Pareto-Revolution implementation should follow the same pattern:
one small typed selection module, existing ranking primitives, no trigger
stack, and no descriptor or scheduler additions.

The full code map is in the repository `README.md`. Selected small review
surfaces are copied under `source/`; large runtime files remain canonical in
`src/revolution/` to avoid a stale duplicate code tree in this bundle.
