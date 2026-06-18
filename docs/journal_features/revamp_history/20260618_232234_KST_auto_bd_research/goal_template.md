# Goal Template

Use this as a draft for `/goal` after reviewing the local plan. Keep the
activated goal under 4000 characters when possible.

```text
/goal Objective: research, implement, and evaluate automatic behavior
descriptors for Smooth-QD RTL PPA evolution on branch
feat/journal-auto-bd-exp-20260618. Follow
docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_plan.md,
track every item in auto_bd_research_implementation_todo.md, and log
evidence in auto_bd_research_implementation_history.md. Start with
START_HERE.md. Use auto_bd_plan_sketch.md and auto_bd_ruminations.md as
initial intent records, but the plan file is the controlling contract.

Outcome: compare original REvolution, landing Smooth-QD manual-BD /
NSGA-II baseline, random descriptor QD, Yosys-stat BD, netlist motif
occupancy, ST-NOD, and any promoted AURORA/VQ/RTL-native variants on
locked RTLLM/VerilogEval subsets. Select the simplest method that
preserves repair/PPA coverage and gives defensible PPA/QD/descriptor
uplift, or record a clean negative.

Hard gate: let C be the set of problems where original REvolution produces
at least one valid PPA candidate under the fixed model, seeds, subset,
timeouts, and budget. Any selected Auto-BD method must produce at least
one valid PPA candidate for every problem in C. Missing a classic-covered
problem is an automatic FAIL, regardless of average PPA.

Default model: preflight `curl http://20.0.0.103:8000/v1/models` and use
gpt-oss-120b symmetrically across methods. If launching/configuring vLLM,
set max_model_len >= 131072. For REvolution reasoning-model runs use
--max_tokens 128000 and --diff_max_tokens 128000 unless explicitly doing a
tiny smoke. Do not silently switch models.

Verification surface: locked subsets/config hashes; baseline/method run
policy lock; baseline/method run roots; standard result files +
run_manifest.json; method_card.md, generated report, accept_reject.md;
centralized report; internal and common-audit QD metrics; canonical
netlist and motif-signature diversity; PPA/HV normalization; descriptor
fitting hashes; ST-NOD observational equivalence; stronger functional
audit; focused tests/lint; `ty` as the primary Auto-BD typecheck with
pyright reported as secondary compatibility evidence.

Constraints: same subset, seeds, model, prompt policy, budget, timeouts,
and Smooth-QD substrate across compared methods unless predeclared. Never
use PPA, reference PPA, fitness, or hypervolume as BD inputs. No held-out
tuning. No dropping hard problems after seeing results. Duplicate netlists
do not count as diversity. Every failed method remains documented. Keep
auto_bd_methods/ under this scaffold directory, with large exp artifacts
linked from reports. Keep backend code simple, typed, exhaustively handled,
and documented with useful docstrings/comments; do not let experimental
modes turn the backend into a configuration maze.

Iteration policy: start with reports/hashing and baselines, then random
and Yosys-stat controls, then motif occupancy, then ST-NOD. Try learned
AURORA-style or VQ/codebook methods only after fixed motif/trajectory
vectors are stable and fitting data is predeclared. Use seed-1 reports for
sanity, seed-3 for screening, and seed-5 final reports when compute
permits. After each method, write the method card, generate the report,
and accept/reject before moving on.

Blocked stop condition: stop only after three concrete attempts hit the
same blocker, with commands, artifacts, missing resource/input, and the
smallest next decision needed. Completion requires every TODO item checked
or explicitly scoped out with evidence, plus PASS from
auto_bd_research_adversarial_prompt.md written to
auto_bd_research_subagent_validation_report.md.
```
