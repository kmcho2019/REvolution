"""Experimental REvolution engine with descriptor-free NSGA-II selection.

Generation orchestration follows ``EoHEngine.evolve_one_generation`` from
``src/revolution/algorithm.py:3773-4145`` at commit ``9702534157``. The frozen
mode removes unreachable single-pool/single-thought branches and changes only
successful-parent and successful-survivor selection.
"""

from __future__ import annotations

import asyncio
import random
import time
from collections import defaultdict
from typing import Any, Literal, cast

from revolution.algorithm import (
    EoHEngine,
    EvolStrategyMethodFail,
    EvolStrategyMethodSuccess,
    Heuristic,
)
from revolution.llm import LLMRequest
from revolution.runtime.problem_spec import ProblemSpec

from .selection import (
    rank_successes,
    resolve_circuit_type,
    select_success_parents,
    select_survivors,
)


class ParetoEoHEngine(EoHEngine):
    """Classic EoH orchestration with Pareto-aware success selection."""

    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        assert self.population_pool_mode == "dual"
        assert self.classic_operator_kind == "eoh_strategies"
        assert self.eoh_success_operator_set == "classic"
        assert self.problem_spec is not None
        assert self.problem_spec.benchmark_name == "RTLLM"
        assert self.problem_spec.supports_synthesis
        self.pareto_problem_spec: ProblemSpec = self.problem_spec
        resolve_circuit_type(self.pareto_problem_spec)

    def evolve_one_generation(self) -> Literal["STOP"] | None:
        """Run one pinned EoH generation with NSGA-II success selection."""

        self.current_generation += 1
        print(f"\n--- Starting Pareto Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        strategies: dict[str, dict[str, Any]] = {
            "M-F": {"func": self._create_prompt_M_F, "num_parents": 1},
            "M-S": {"func": self._create_prompt_M_S, "num_parents": 1},
            "M-E": {"func": self._create_prompt_M_E, "num_parents": 1},
            "M-R": {"func": self._create_prompt_M_R, "num_parents": 1},
            "M-I": {"func": self._create_prompt_M_I, "num_parents": 1},
            "C-F": {"func": self._create_prompt_C_F, "num_parents": 2},
        }
        fail_view = self._get_fail_view()
        success_view = self._get_success_view()
        total_current_pop = len(fail_view) + len(success_view)
        if total_current_pop == 0:
            return "STOP"

        num_from_fail = round(
            self.num_offspring_lambda * len(fail_view) / total_current_pop
        )
        num_from_success = self.num_offspring_lambda - num_from_fail
        ranked_successes = rank_successes(
            success_view,
            self.pareto_problem_spec,
            self.ref_ppa_metrics,
        )

        llm_requests: list[LLMRequest] = []
        metadata: list[dict[str, Any]] = []
        success_probabilities: dict[str, float] = {
            strategy: 0.0 for strategy in self.success_strats
        }
        fail_probabilities: dict[str, float] = {
            strategy: 0.0 for strategy in self.fail_strats
        }
        fail_selected: set[EvolStrategyMethodFail] = set()
        success_selected: set[EvolStrategyMethodSuccess] = set()

        for _ in range(num_from_fail):
            strategy, probabilities = self._select_strategy(
                "fail",
                self.fail_strats,
                fail_selected,
            )
            if strategy is None or probabilities is None:
                continue
            fail_selected.add(strategy)
            parents = random.choices(
                fail_view,
                k=strategies[strategy]["num_parents"],
            )
            mode = self.generation_mode
            prompt = self._with_mode(mode, strategies[strategy]["func"], parents)
            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt,
                    mode=mode,
                    system_prompt=self._get_generation_system_prompt(mode),
                )
            )
            metadata.append(
                {
                    "parents": parents,
                    "strategy": strategy,
                    "pool": "fail",
                    "prob_dist": probabilities,
                    "resolved_mode": mode,
                }
            )
            for name, probability in probabilities.items():
                fail_probabilities[name] += probability
        if num_from_fail > 0:
            for name in fail_probabilities:
                fail_probabilities[name] /= num_from_fail

        available_success = self.success_strats.copy()
        if len(success_view) < 2 and "C-F" in available_success:
            available_success.remove("C-F")
        for _ in range(num_from_success):
            strategy, probabilities = self._select_strategy(
                "success",
                available_success,
                success_selected,
            )
            if strategy is None or probabilities is None:
                continue
            success_selected.add(strategy)
            parents = select_success_parents(
                ranked_successes,
                strategies[strategy]["num_parents"],
            )
            mode = self.generation_mode
            prompt = self._with_mode(mode, strategies[strategy]["func"], parents)
            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt,
                    mode=mode,
                    system_prompt=self._get_generation_system_prompt(mode),
                )
            )
            metadata.append(
                {
                    "parents": parents,
                    "strategy": strategy,
                    "pool": "success",
                    "prob_dist": probabilities,
                    "resolved_mode": mode,
                }
            )
            for name, probability in probabilities.items():
                success_probabilities[name] += probability
        if num_from_success > 0:
            for name in success_probabilities:
                success_probabilities[name] /= num_from_success

        if not llm_requests:
            return "STOP"
        strategy_probabilities: dict[str, dict[str, float]] = {
            "fail_pool": fail_probabilities,
            "success_pool": success_probabilities,
        }
        llm_results = asyncio.run(
            self.llm.generate_batch_responses(
                llm_requests,
                self.default_llm_temp,
                self.default_llm_top_p,
                self.default_llm_max_tokens,
            )
        )
        new_offspring = self._materialize_offspring_batch(llm_results, metadata)
        self._evaluate_candidates(new_offspring)

        fail_rewards: defaultdict[str, float] = defaultdict(float)
        success_rewards: defaultdict[str, float] = defaultdict(float)
        for index, candidate in enumerate(new_offspring):
            record = metadata[index]
            strategy = cast(str, record["strategy"])
            parent_pool = cast(str, record["pool"])
            parents = cast(list[Heuristic], record["parents"])
            parent = parents[0]
            reward = 0.0
            if parent_pool == "fail":
                if parent.status != "success" and candidate.status == "success":
                    reward = 1.0
            elif parent_pool == "success":
                if len(parents) == 1:
                    if candidate.status == "success" and candidate.score > parent.score:
                        reward = 1.0
                elif len(parents) == 2:
                    if candidate.status == "success" and candidate.score > max(
                        parents[0].score,
                        parents[1].score,
                    ):
                        reward = 1.0
                else:
                    raise AssertionError(f"unsupported parent count: {len(parents)}")
            else:
                raise AssertionError(f"unknown parent pool: {parent_pool}")

            candidate.reward_from_parent = reward
            if parent_pool == "fail":
                typed_strategy = cast(EvolStrategyMethodFail, strategy)
                fail_rewards[strategy] += reward
                stats = self.fail_strategy_stats[typed_strategy]
            else:
                typed_strategy = cast(EvolStrategyMethodSuccess, strategy)
                success_rewards[strategy] += reward
                stats = self.success_strategy_stats[typed_strategy]
            stats["count"] += 1
            stats["value"] = stats["value"] + (reward - stats["value"]) / stats["count"]

        next_population = select_survivors(
            self.success_pool,
            new_offspring,
            self.population_size,
            self.pareto_problem_spec,
            self.ref_ppa_metrics,
        )
        self.fail_pool.clear()
        self.success_pool.clear()
        for candidate in next_population:
            if candidate.status == "success":
                self.success_pool.append(candidate)
            else:
                self.fail_pool.append(candidate)

        self._log_generation_stats(
            new_offspring,
            time.time() - self.gen_start_time,
            fail_rewards,
            success_rewards,
            strategy_probabilities,
        )
        print(
            f"--- Gen {self.current_generation} Complete. Pools: "
            f"Success({len(self.success_pool)}), Fail({len(self.fail_pool)}) ---"
        )
        if self.success_pool:
            print(f"Best Pareto-ranked candidate: {self.success_pool[0]}")
        return None
