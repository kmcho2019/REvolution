# Method Interaction & Evolutionary Loop

## High-level control flow

`EoHEngine.run()` is the public entry point. It orchestrates the loop shown below:

1. Load reference data (`_calculate_reference_ppa`) and instantiate the run logger.
2. Generate and evaluate the initial population (`initialize_population`).
3. Repeat for each generation until `num_generations` is exhausted or no parents remain:
   - `evolve_one_generation` decides resource allocation, requests offspring from the LLM, evaluates results, and updates statistics.
4. Summarise the run with `EoHLogger.finalize_summary` and return a concise status string.

The `SingleShotEngine` subclasses `EoHEngine` with `num_generations=0` so it shares the same initialisation logic but skips the evolutionary loop.

## Initial population

`initialize_population` uses `LLMInterface.generate_n_responses` to request `population_size` JSON objects in “whole” mode. The engine:

- Saves the thought, raw JSON, and Verilog under `Gen0`.
- Places each artefact in a unique subdirectory named like `Gen0/prob_sample1_initial/`, containing `code.sv`, `thought.txt`, diff metadata, and any feedback files so concurrent evaluations do not clobber one another.
- Marks candidates with `status="failed_format"` when the JSON schema is invalid and, if `require_strict_format=True`, writes debug artefacts before skipping evaluation.
- Evaluates conforming candidates via `_evaluate_candidates`.
- Populates `fail_pool` and `success_pool` based on evaluation outcomes, or stores everyone in `self.population` when `population_pool_mode="single"`.

For rapid experimentation, `Gen0LatencyEngine` short-circuits after this stage: it requests feedback-only scoring for every candidate, writes the feedback artefacts, assigns the returned `score`, and selects the highest-ranked design without running simulation, synthesis, or PPA analysis.

LLM usage statistics are collected through `LLMInterface.get_and_reset_usage_stats()` and passed to `EoHLogger.log_generation` to seed the metrics timeline.

## Candidate evaluation stages

`_evaluate_candidates` enforces a consistent pipeline for both initial populations and newly generated offspring:

1. **Simulation** – `VerilogEvaluator.evaluate` compiles and runs the design with the benchmark testbench. Outcomes are interpreted and converted into statuses:
   - `failed_format` / `failed_diff`: bypass simulation and queue for feedback prompting.
   - `failed_syntax` / `failed_functionality`: store logs, request LLM feedback, and assign `score = -inf`.
   - `success`: proceed to synthesis.
2. **Synthesis and PPA** – `SynthesisEvaluator.evaluate` runs Yosys, optionally post-synthesis simulation, and OpenROAD. Missing reports or failing regressions mark candidates as `failed_synthesis` or `failed_synthesis_functionality`. Successful runs record `ppa_metrics` and compute a fitness score relative to the reference design (`_calculate_fitness_score`).

Feedback requests for failed candidates are batched and issued via `LLMInterface.generate_batch_feedback`, capturing guiding analysis inside `<candidate>_feedback.txt` files.

## Offspring generation

`evolve_one_generation` coordinates the evolutionary step:

- **Pool views** – `_get_fail_view` and `_get_success_view` expose slices of the current candidates based on `population_pool_mode`.
- **Allocation** – determines how many offspring to sample from each pool (`num_from_fail`, `num_from_success`). Single-pool mode throttles fail allocations once successes exist via `single_fail_allocation_cap`.
- **Strategy selection** – `_select_strategy` delegates to `_run_selection_algorithm` which implements random, epsilon-greedy, or UCB selection, returning both the chosen operator and the pre-selection probability distribution. The distribution later feeds logging and reward calculations.
- **Prompt construction** – strategy metadata (`strategies` dict) describes how many parents are required and which prompt builder to call. `_with_mode` ensures failed parents always use “whole” mode, while successful parents honour the configured `generation_mode`.
- **LLM execution** – `LLMInterface.generate_batch_responses` issues the prepared requests. Each response includes the parsed JSON payload and the raw text.
- **Diff handling** – diff-mode children use `_apply_diff` to materialise the updated source. Failures to apply patches turn into `status="failed_diff"` with diagnostic JSON saved next to the candidate.
- **Persistence** – `_save_result_to_file` writes thought/code pairs to disk, setting `candidate.code_file_path` for later evaluation.
- **Evaluation** – `_evaluate_candidates` is invoked on the new offspring list. The resulting statuses and scores feed the reward system.

## Reward updates and logging

For each offspring, the engine computes a scalar reward:

- Fail-pool parents earn reward `1.0` when the child transitions to `status="success"`.
- Success-pool parents earn reward `1.0` when the child remains successful and beats the best parent score (or, for fusion, both parents).

Rewards accumulate in `fail_rewards_this_gen` / `success_rewards_this_gen` and update `fail_strategy_stats` / `success_strategy_stats` via a stochastic approximation (incremental mean). These statistics are reused by epsilon-greedy and UCB meta-strategies on later generations.

`EoHLogger.log_generation` captures:

- The full list of candidates for the generation with their statuses and metrics.
- LLM call counts and token usage (code and feedback volumes).
- Strategy usage, origin pools, reward tallies, diff attempts, and the probability distribution emitted during selection.
- Generation runtime and elapsed wall-clock time.

## Failure recovery and housekeeping

- `_remove_duplicate_candidates` prevents identical code from flooding the pools.
- `_prune_pool` enforces `population_size` limits and ensures the highest-scoring candidates survive.
- `_save_format_error_artifacts` and diff-related helpers write supplementary files next to the code whenever parsing or patching fails, simplifying debugging and post-mortem analysis.

## Variants

- `SingleShotEngine` overrides `run` to execute only the initial population (no reproduction), but still logs results and final summaries.
- `CVDPEngine` adapts the flow for JSONL-based problems. It bypasses benchmark folder discovery, uses dataset metadata for prompts, and disables synthesis (CVDP is a code completion benchmark).

## Data flow summary

```
benchmark description
        ↓
LLMInterface.generate_* ──► Heuristic objects (thought + code) ──► disk artefacts
        ↓                                               │
   simulation (iverilog/vvp) ───────────────────────────┤
        ↓ (pass)                                        │
   synthesis + PPA (Yosys/OpenROAD) ────────────────────┤
        ↓                                               │
  fitness score + status ──► fail/success pools ──► strategy selection ─┐
        └───────────────────────────────────────────────────────────────┘
```

Logging, reward updates, and prompt feedback requests tap into each stage, ensuring the next generation has the context it needs to improve.
