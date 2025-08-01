from __future__ import annotations

import datetime
import json
import os
from collections import defaultdict
from typing import TYPE_CHECKING, Any

import numpy as np

# Import Heuristic class from local module for type checking
if TYPE_CHECKING:
    from .algorithm import EvolStrategyMethodFail, EvolStrategyMethodSuccess, Heuristic


class EoHLogger:
    """
    Handles logging for the evolutionary coding process.

    Creates a detailed generation-by-generation log (JSON-lines) and a final summary
    (JSON) for each problem, including PPA statistics, success rates, strategy usage,
    and accumulated rewards.
    """

    def __init__(
        self,
        problem_name: str,
        benchmark_name: str,
        model_name: str,
        save_path: str,
        ref_ppa: dict[str, Any] | None,
    ):
        """
        Initialize logger directories, file paths, and counters.

        :param problem_name:     Identifier for the current problem instance.
        :param benchmark_name:   Name of the benchmark suite.
        :param model_name:       Name of the LLM or method generating candidates.
        :param save_path:        Root folder where logs and summaries will be written.
        :param ref_ppa:          Reference PPA metrics to compare against (may be None).
        """

        self.problem_name: str = problem_name
        self.benchmark_name: str = benchmark_name
        self.model_name: str = model_name
        self.ref_ppa_metrics: dict[str, Any] = ref_ppa or {}

        # Setup save paths
        model_name_cleaned = model_name.replace("/", "_")
        self.log_dir: str = os.path.join(
            save_path, model_name_cleaned, benchmark_name, problem_name
        )
        os.makedirs(self.log_dir, exist_ok=True)
        self.gen_log_path: str = os.path.join(self.log_dir, "generation_log.jsonl")
        self.summary_path: str = os.path.join(
            self.log_dir, f"{problem_name}_summary.json"
        )

        # Initialize generation log file delete if it exists
        if os.path.exists(self.gen_log_path):
            os.remove(self.gen_log_path)

        # Data for final summary
        self.generation_stats_summary: list[dict[str, Any]] = []
        self.all_candidates_generated: set[str] = set()
        self.all_syntax_passed: set[str] = set()
        self.all_func_passed: set[str] = set()
        self.all_synth_passed: set[str] = set()
        self.total_llm_api_calls: int = 0
        self.strategy_counter: defaultdict[str, int] = defaultdict(
            int
        )  # Accumulated across generations, count of how many times each strategy was used
        self.strategy_counter_fail: defaultdict[str, int] = defaultdict(
            int
        )  # Count of how many times each strategy resulted in a failure (syntax, functionality, or synthesis)
        self.strategy_counter_success: defaultdict[str, int] = defaultdict(
            int
        )  # Count of how many times each strategy resulted in a success (syntax, functionality, and synthesis)
        self.strategy_counter_origin_pool_fail: defaultdict[str, int] = defaultdict(
            int
        )  # Count of how many times each strategy was used in the fail pool
        self.strategy_counter_origin_pool_success: defaultdict[str, int] = defaultdict(
            int
        )  # Count of how many times each strategy was used in the success pool
        self.strategy_counter_origin_pool_initial: defaultdict[str, int] = defaultdict(
            int
        )  # Count of how many times each strategy was used in the initial pool
        # Add attributes for tracking rewards and meta-strategies
        # Initialize rewards for fail and success pools as dictionaries with default float values(0.0)
        self.fail_pool_strategy_rewards: defaultdict[str, float] = defaultdict(float)
        self.success_pool_strategy_rewards: defaultdict[str, float] = defaultdict(float)
        self.meta_strategy_name: str = (
            "random"  # Default meta-strategy name to be updated by engine
        )

    def _calculate_ppa_stats(
        self, ppa_candidates: list["Heuristic"] | None
    ) -> dict[str, float | dict[str, float] | None]:
        """
        Compute best and average PPA scores and metrics over a list of candidates.

        :param ppa_candidates:  List of Heuristic instances whose `.score` and
                                `.ppa_metrics` fields will be aggregated.
        :return: A dict with keys
                 - best_score:       Maximum of all candidate scores, or None if empty.
                 - average_score:    Mean of all scores, or None if empty.
                 - best_metrics:     ppa_metrics dict from the top-scoring candidate.
                 - average_metrics:  Dict mapping each metric name to its average
                                     across candidates.
        """
        if not ppa_candidates:
            return {
                "best_score": None,
                "average_score": None,
                "best_metrics": {},
                "average_metrics": {},
            }

        scores = [c.score for c in ppa_candidates]
        best_cand = max(ppa_candidates, key=lambda c: c.score)

        metrics = [
            c.ppa_metrics
            for c in ppa_candidates
            if c.ppa_metrics
            and all(
                isinstance(v, (int, float))
                for v in c.ppa_metrics.values()
                if isinstance(v, (int, float))
            )
        ]
        avg_metrics = {}
        if metrics:
            # Get all keys from all metrics dictionaries
            all_keys = set(
                key for m in metrics for key in m if isinstance(m[key], (int, float))
            )
            for key in all_keys:
                values = [m[key] for m in metrics if key in m]
                if values:
                    avg_metrics[key] = np.mean(values)

        return {
            "best_score": float(max(scores)) if scores else None,
            "average_score": float(np.mean(scores)) if scores else None,
            "best_metrics": best_cand.ppa_metrics if best_cand else {},
            "average_metrics": avg_metrics,
        }

    def log_generation(
        self,
        generation_num: int,
        candidates_this_gen: list["Heuristic"],
        runtime_sec: float,
        llm_calls_this_gen: int,
        fail_rewards_this_gen: defaultdict[str, float],
        success_rewards_this_gen: defaultdict[str, float],
        fail_strategy_stats: dict["EvolStrategyMethodFail", dict[str, int | float]],
        success_strategy_stats: dict[
            "EvolStrategyMethodSuccess", dict[str, int | float]
        ],
        strategy_avg_selection_probabilities: dict[str, float]
        | dict[str, dict[str, float]],
    ) -> None:
        """
        Record all per-generation statistics to the JSONL log file.

        :param generation_num:                     Zero-based index of this generation.
        :type generation_num: int
        :param candidates_this_gen:                All Heuristic objects produced.
        :type candidates_this_gen: list[Heuristic]
        :param runtime_sec:                        Wall-clock time in seconds for this generation.
        :type runtime_sec: float
        :param llm_calls_this_gen:                 Number of LLM API calls made.
        :type llm_calls_this_gen: int
        :param fail_rewards_this_gen:              Mapping from strategy name to
                                                   the reward obtained for fail-pool Q.
        :type fail_rewards_this_gen: defaultdict[str, float]
        :param success_rewards_this_gen:           Mapping from strategy name to
                                                   the reward obtained for success-pool Q.
        :type success_rewards_this_gen: defaultdict[str, float]
        :param fail_strategy_stats:                Q-value dicts for each strategy in the
                                                   fail pool (contains “count” and “value”).
        :type fail_strategy_stats: dict[EvolStrategyMethodFail, dict[str, int | float]]
        :param success_strategy_stats:             Q-value dicts for each strategy in the
                                                   success pool (contains “count” and “value”).
        :type success_strategy_stats: dict[EvolStrategyMethodSuccess, dict[str, int | float]]
        :param strategy_avg_selection_probabilities:
                                                   Mapping from strategy name to its
                                                   selection probabilities (next generation).
                                                   (dict[str, float] for initial generation,
                                                   dict[str, dict[str, float]] for subsequent generations).
        :type strategy_avg_selection_probabilities: dict[str, float] | dict[str, dict[str, float]]
        :return: None (appends one JSON line to `generation_log.jsonl`).
        :rtype: None
        """

        total_generated = len(candidates_this_gen)
        if total_generated == 0:
            print("Logger: No new candidates to log for this generation.")
            return

        # 1. Group candidates by strategy
        candidates_by_strategy = defaultdict(list)
        strategy_count_this_gen = defaultdict(int)
        # Track of strategies that lead to success or failure in this generation
        # Success or failure means if the candidate was successful or failed in the syntax + functionality check + synthesis process
        strategy_count_this_gen_fail = defaultdict(int)
        strategy_count_this_gen_success = defaultdict(int)
        # Track of strategies used in each type of pool
        strategy_count_for_fail_pool = defaultdict(int)
        strategy_count_for_success_pool = defaultdict(int)
        strategy_count_for_initial_pool = defaultdict(int)
        for c in candidates_this_gen:
            candidates_by_strategy[c.strategy].append(c)
            strategy_count_this_gen[c.strategy] += 1
            self.strategy_counter[c.strategy] += 1  # accumulate
            if c.status == "success":
                self.strategy_counter_success[c.strategy] += 1
                strategy_count_this_gen_success[c.strategy] += 1
            else:
                self.strategy_counter_fail[c.strategy] += 1
                strategy_count_this_gen_fail[c.strategy] += 1
            # Update the strategy counts for each origin pool
            if c.origin_pool == "fail_pool":
                self.strategy_counter_origin_pool_fail[c.strategy] += 1
                strategy_count_for_fail_pool[c.strategy] += 1
            elif c.origin_pool == "success_pool":
                self.strategy_counter_origin_pool_success[c.strategy] += 1
                strategy_count_for_success_pool[c.strategy] += 1
            elif c.origin_pool == "initial":
                self.strategy_counter_origin_pool_initial[c.strategy] += 1
                strategy_count_for_initial_pool[c.strategy] += 1
        # 2. Calculate total success rates
        total_syntax_success = sum(
            1 for c in candidates_this_gen if c.status != "failed_syntax"
        )
        total_func_success = sum(
            1
            for c in candidates_this_gen
            if c.status != "failed_syntax" and c.status != "failed_functionality"
        )
        total_synth_success = sum(
            1 for c in candidates_this_gen if c.status == "success"
        )

        # 3. Calculate strategy-wise success rates
        strategy_success_rates = {}
        for strategy, candidates in candidates_by_strategy.items():
            count = len(candidates)
            if count == 0:
                continue
            strategy_success_rates[strategy] = {
                "syntax": sum(1 for c in candidates if c.status != "failed_syntax")
                / count,
                "functionality": sum(
                    1
                    for c in candidates
                    if c.status not in ["failed_syntax", "failed_functionality"]
                )
                / count,
                "synthesis_ppa": sum(1 for c in candidates if c.status == "success")
                / count,
            }

        # 4. Calculate generation-wide PPA stats
        ppa_candidates_this_gen = [
            c for c in candidates_this_gen if c.status == "success"
        ]
        generation_ppa_stats = self._calculate_ppa_stats(ppa_candidates_this_gen)
        # Collect detailed PPA metrics for all successful individuals
        population_ppa = [
            {
                "id": c.id,
                "strategy": c.strategy,
                "score": c.score,
                "ppa_metrics": c.ppa_metrics,
            }
            for c in ppa_candidates_this_gen
        ]

        # 5. Calculate strategy-wise PPA stats
        strategy_ppa_stats = {}
        for strategy, candidates in candidates_by_strategy.items():
            ppa_cands = [c for c in candidates if c.status == "success"]
            if ppa_cands:
                strategy_ppa_stats[strategy] = self._calculate_ppa_stats(ppa_cands)

        # 6. Update accumulated strategy rewards for each pool
        for strategy, reward in fail_rewards_this_gen.items():
            self.fail_pool_strategy_rewards[strategy] += reward
        for strategy, reward in success_rewards_this_gen.items():
            self.success_pool_strategy_rewards[strategy] += reward

        # 7. Assemble log entry
        log_entry = {
            "generation": generation_num,
            "timestamp": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "runtime_seconds": runtime_sec,
            "llm_api_calls": llm_calls_this_gen,
            "strategy_counts_this_generation": dict(strategy_count_this_gen),
            "strategy_counts_for_each_origin_pool": {
                "fail_pool": strategy_count_for_fail_pool,
                "success_pool": strategy_count_for_success_pool,
                "initial_pool": strategy_count_for_initial_pool,
            },
            "strategy_counts_for_successful_synthesis_generation": {
                "fail": strategy_count_this_gen_fail,
                "success": strategy_count_this_gen_success,
            },
            "strategy_values_after_evolution": {
                # Use fail_strategy_stats and success_strategy_stats, actual Q-values used to select strategies next generation
                # fail_strategy_stats and success_strategy_stats structure:
                # key: strategy name
                # value: dictionary {"count": 0, "value": 0.0},
                # count is how many times this strategy was used, value is the Q-value to be used for next generation selection
                # We want to only print the Q-values, not the counts.
                "fail_pool": {k: v["value"] for k, v in fail_strategy_stats.items()},
                "success_pool": {
                    k: v["value"] for k, v in success_strategy_stats.items()
                },
            },
            "average_strategy_probabilities": dict(
                strategy_avg_selection_probabilities
            ),
            "accumulated_strategy_rewards": {
                "fail_pool": dict(self.fail_pool_strategy_rewards),
                "success_pool": dict(self.success_pool_strategy_rewards),
            },
            "strategy_rewards_this_generation": {
                "fail_pool": dict(fail_rewards_this_gen),
                "success_pool": dict(success_rewards_this_gen),
            },
            "success_rates": {
                "total_syntax": total_syntax_success / total_generated
                if total_generated > 0
                else 0,
                "total_functionality": total_func_success / total_generated
                if total_generated > 0
                else 0,
                "total_synthesis_ppa": total_synth_success / total_generated
                if total_generated > 0
                else 0,
            },
            "strategy_success_rates": strategy_success_rates,
            "generation_ppa": generation_ppa_stats,
            "strategy_ppa": strategy_ppa_stats,
            "population_ppa_details": population_ppa,
        }

        # 8. Write to file and update accumulators
        def numpy_converter(o):
            if isinstance(o, (np.generic, np.ndarray)):
                return o.item() if o.size == 1 else o.tolist()
            if isinstance(o, float) and (np.isnan(o) or np.isinf(o)):
                return None
            return o

        with open(self.gen_log_path, "a") as f:
            f.write(json.dumps(log_entry, default=numpy_converter) + "\n")

        self.total_llm_api_calls += llm_calls_this_gen
        self.generation_stats_summary.append(
            {
                "generation": generation_num,
                "runtime_seconds": runtime_sec,
                "llm_api_calls": llm_calls_this_gen,
                "best_score": generation_ppa_stats.get("best_score"),
                "average_score": generation_ppa_stats.get("average_score"),
            }
        )
        for c in candidates_this_gen:
            self.all_candidates_generated.add(c.id)
            if c.status != "failed_syntax":
                self.all_syntax_passed.add(c.id)
            if c.status not in ["failed_syntax", "failed_functionality"]:
                self.all_func_passed.add(c.id)
            if c.status == "success":
                self.all_synth_passed.add(c.id)

    def finalize_summary(
        self,
        start_utc: datetime.datetime,
        end_utc: datetime.datetime,
        total_runtime_sec: float,
        total_generations: int,
        final_ppa_pool: list["Heuristic"],
    ) -> None:
        """
        Compute overall statistics across all generations and write the final summary file.

        :param start_utc:             UTC timestamp when evolution began.
        :param end_utc:               UTC timestamp when evolution ended.
        :param total_runtime_sec:     Total elapsed time (sum of all generation runtimes).
        :param total_generations:     Count of generations executed.
        :param final_ppa_pool:        List of Heuristic objects from the last generation
                                      (used to compute final PPA stats).
        :return: None (writes a JSON summary to `<problem>_summary.json`).
        """

        # 1. Final PPA stats from the last generation's ppa_pool
        final_ppa_stats = self._calculate_ppa_stats(final_ppa_pool)
        # Collect detailed PPA metrics for all successful individuals in the final population pool
        final_population_ppa = [
            {
                "id": c.id,
                "strategy": c.strategy,
                "score": c.score,
                "ppa_metrics": c.ppa_metrics,
            }
            for c in final_ppa_pool
            if c.status == "success"
        ]

        # 2. Strategy-wise PPA for the final pool
        final_strategy_ppa_stats = {}
        if final_ppa_pool:
            candidates_by_strategy = defaultdict(list)
            for c in final_ppa_pool:
                candidates_by_strategy[c.strategy].append(c)
            for strategy, candidates in candidates_by_strategy.items():
                if candidates:
                    final_strategy_ppa_stats[strategy] = self._calculate_ppa_stats(
                        candidates
                    )

        # 3. Accumulated success rates across all generations
        total_unique_generated = len(self.all_candidates_generated)
        acc_rates = {"syntax": 0.0, "functionality": 0.0, "synthesis_ppa": 0.0}
        if total_unique_generated > 0:
            acc_rates["syntax"] = len(self.all_syntax_passed) / total_unique_generated
            acc_rates["functionality"] = (
                len(self.all_func_passed) / total_unique_generated
            )
            acc_rates["synthesis_ppa"] = (
                len(self.all_synth_passed) / total_unique_generated
            )

        # 4. Assemble summary data
        summary_data = {
            "problem_name": self.problem_name,
            "benchmark_name": self.benchmark_name,
            "model_name": self.model_name,
            "strategy_selection_method": self.meta_strategy_name,
            "start_time": start_utc.isoformat(),
            "end_time": end_utc.isoformat(),
            "total_runtime_seconds": total_runtime_sec,
            "total_llm_api_calls": self.total_llm_api_calls,
            "total_generations": total_generations,
            "total_candidates_generated": total_unique_generated,
            "accumulated_strategy_counts:": dict(self.strategy_counter),
            "accumulated_strategy_counts_by_pool": {
                "fail_pool": dict(self.strategy_counter_origin_pool_fail),
                "success_pool": dict(self.strategy_counter_origin_pool_success),
                "initial_pool": dict(self.strategy_counter_origin_pool_initial),
            },
            "accumulated_strategy_counts_by_result": {  # Counts of strategies that resulted in success or failure of synthesis (i.e., syntax + functionality + synthesis)
                "fail": dict(self.strategy_counter_fail),
                "success": dict(self.strategy_counter_success),
            },
            "accumulated_strategy_rewards": {
                "fail_pool": dict(self.fail_pool_strategy_rewards),
                "success_pool": dict(self.success_pool_strategy_rewards),
            },
            "accumulated_success_rates": acc_rates,
            "ref_ppa_metric": self.ref_ppa_metrics,
            "final_population_ppa": final_ppa_stats,
            "final_strategy_ppa": final_strategy_ppa_stats,
            "final_population_ppa_details": final_population_ppa,
            "generation_statistics": self.generation_stats_summary,
        }

        # 5. Write to file
        def numpy_converter(o):
            if isinstance(o, (np.generic, np.ndarray)):
                return o.item() if o.size == 1 else o.tolist()
            if isinstance(o, float) and (np.isnan(o) or np.isinf(o)):
                return None
            return o

        with open(self.summary_path, "w") as f:
            json.dump(summary_data, f, indent=2, default=numpy_converter)
        print(f"Final summary saved to: {self.summary_path}")
