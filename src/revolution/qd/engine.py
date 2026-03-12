from __future__ import annotations

import asyncio
import datetime
import math
import os
import random
import time
import traceback
from collections import defaultdict
from typing import Any, Literal, cast

from revolution.algorithm import EoHEngine, EvolStrategyMethodFail, EvolStrategyMethodSuccess, Heuristic
from revolution.logging import EoHLogger
from revolution.qd.archive import GridArchive, GridAxisSpec
from revolution.qd.scoring import compute_ppa_gains
from revolution.qd.scheduler import split_qd_budget


class QDEngine(EoHEngine):
    """Grid-first QD engine that reuses the existing REvolution prompt/eval stack."""

    def __init__(
        self,
        *args: Any,
        qd_archive_type: str = "grid",
        qd_num_cells: int = 64,
        qd_fill_target_fraction: float = 0.25,
        qd_grid_axes: tuple[str, ...] = (),
        qd_fail_generation_mode: str = "auto",
        qd_seed_generation_mode: str = "auto",
        qd_backfill_generation_mode: str = "auto",
        qd_refine_generation_mode: str = "auto",
        qd_crossover_generation_mode: str = "auto",
        **kwargs: Any,
    ) -> None:
        super().__init__(*args, **kwargs)
        self.qd_archive_type = qd_archive_type
        self.qd_num_cells = max(1, int(qd_num_cells))
        self.qd_fill_target_fraction = float(qd_fill_target_fraction)
        self.qd_grid_axes = tuple(qd_grid_axes) if qd_grid_axes else self._default_grid_axes()
        self.qd_fail_generation_mode = qd_fail_generation_mode
        self.qd_seed_generation_mode = qd_seed_generation_mode
        self.qd_backfill_generation_mode = qd_backfill_generation_mode
        self.qd_refine_generation_mode = qd_refine_generation_mode
        self.qd_crossover_generation_mode = qd_crossover_generation_mode
        if self.qd_archive_type != "grid":
            raise NotImplementedError(
                "QDEngine currently supports qd_archive_type=grid only. CVT lands in Stage 4."
            )
        self.success_archive = self._build_grid_archive()

    def _default_grid_axes(self) -> tuple[str, ...]:
        if self.ref_ppa_metrics.get("eff_clk_period", 0.0):
            return ("g_A", "g_T")
        return ("g_A", "g_P")

    def _build_grid_archive(self) -> GridArchive:
        dim = max(1, len(self.qd_grid_axes))
        bins_per_axis = max(2, round(self.qd_num_cells ** (1 / dim)))
        axes = [
            GridAxisSpec(name=axis, bins=bins_per_axis, lower_bound=-1.0, upper_bound=1.0)
            for axis in self.qd_grid_axes
        ]
        return GridArchive(axes)

    def _phase_mode(self, phase: str) -> Literal["whole", "diff"]:
        override = {
            "fail": self.qd_fail_generation_mode,
            "seed": self.qd_seed_generation_mode,
            "backfill": self.qd_backfill_generation_mode,
            "refine": self.qd_refine_generation_mode,
            "crossover": self.qd_crossover_generation_mode,
        }.get(phase, "auto")
        if override in {"whole", "diff"}:
            if phase == "seed" and override == "diff":
                return "whole"
            return cast(Literal["whole", "diff"], override)
        if phase == "refine" and self.generation_mode == "diff":
            return "diff"
        return "whole"

    def _descriptor_tuple(self, candidate: Heuristic) -> tuple[float, ...] | None:
        if candidate.status != "success" or not candidate.ppa_success:
            return None
        gains = compute_ppa_gains(candidate.ppa_metrics, self.ref_ppa_metrics)
        return tuple(float(gains.get(axis, 0.0)) for axis in self.qd_grid_axes)

    def _rebuild_archive_from_success_pool(self) -> None:
        self.success_archive = self._build_grid_archive()
        for cand in self.success_pool:
            descriptors = self._descriptor_tuple(cand)
            if descriptors is None:
                continue
            self.success_archive.insert(cand.id, descriptors, cand.score, cand)
        self.success_pool = self._archive_elites()

    def _archive_elites(self) -> list[Heuristic]:
        elites = [entry.payload for entry in self.success_archive.entries().values()]
        elites.sort(key=lambda cand: cand.score, reverse=True)
        return elites

    def initialize_population(self) -> None:
        super().initialize_population()
        self._rebuild_archive_from_success_pool()

    def _sample_success_parents(self, count: int) -> list[Heuristic]:
        elites = self._archive_elites()
        if not elites:
            return []
        base = min(c.score for c in elites)
        weights = [max(c.score - base + 0.1, 1e-6) for c in elites]
        return random.choices(elites, weights=weights, k=count)

    def _materialize_offspring(
        self,
        llm_results_with_meta: list[tuple[str | None, str | None, dict[str, Any]]],
        metadata: list[dict[str, Any]],
    ) -> list[Heuristic]:
        if len(llm_results_with_meta) < len(metadata):
            missing = len(metadata) - len(llm_results_with_meta)
            for _ in range(missing):
                llm_results_with_meta.append(
                    (None, None, {"format_ok": False, "error": "missing_response", "raw": "", "parsed_mode": None})
                )

        new_offspring: list[Heuristic] = []
        for i, (thought, code_content, meta) in enumerate(llm_results_with_meta):
            meta_rec = metadata[i]
            strategy = meta_rec["strategy"]
            is_format_ok = meta.get("format_ok", False)
            resolved_mode = meta_rec.get("resolved_mode", self.generation_mode)

            if not is_format_ok and self.require_strict_format:
                code_path, _ = self._save_result_to_file(
                    (code_content or meta.get("raw", "") or ""),
                    thought or "",
                    self.current_generation,
                    i + 1,
                    strategy,
                    None,
                )
                self._save_format_error_artifacts(code_path, meta)
                cand = Heuristic(
                    thought=thought or "",
                    code=(code_content or meta.get("raw", "") or ""),
                    feedback=f"FORMAT_ERROR: {meta.get('error', 'unknown')}",
                    generation=self.current_generation,
                    parent_ids=[p.id for p in meta_rec.get("parents", [])],
                    strategy=strategy,
                    origin_pool=meta_rec["origin_pool"],
                    status="failed_format",
                )
                cand.code_file_path = code_path
                cand.generated_mode = resolved_mode
                new_offspring.append(cand)
                continue

            final_code = ""
            diff_to_save = ""
            if resolved_mode == "diff":
                diff_to_save = code_content or ""
                base_parent = meta_rec["parents"][0]
                with open(base_parent.code_file_path, "r", encoding="utf-8") as handle:
                    original_code = handle.read()
                new_code = self._apply_diff(
                    original_code,
                    diff_to_save,
                    target_file_path=base_parent.code_file_path,
                )
                if new_code:
                    final_code = new_code
                else:
                    diagnostics = dict(self._last_diff_apply_diagnostics)
                    reason_code = diagnostics.get("reason_code") or "diff_apply_failed"
                    reason_text = diagnostics.get("reason") or "Diff application returned no result."
                    final_code = original_code + "\n" + diff_to_save
                    code_path, _ = self._save_result_to_file(
                        final_code,
                        thought or "",
                        self.current_generation,
                        i + 1,
                        strategy,
                        diff_to_save,
                    )
                    self._save_diff_error_artifacts(
                        code_path,
                        diff_to_save,
                        parent_file=base_parent.code_file_path,
                        reason=reason_text,
                        diagnostics=diagnostics,
                    )
                    cand = Heuristic(
                        thought=thought or "",
                        code=original_code,
                        feedback=f"DIFF_APPLY_ERROR[{reason_code}]: {reason_text}",
                        generation=self.current_generation,
                        parent_ids=[p.id for p in meta_rec["parents"]],
                        strategy=strategy,
                        origin_pool=meta_rec["origin_pool"],
                        status="failed_diff",
                    )
                    cand.code_file_path = code_path
                    cand.generated_mode = "diff"
                    cand.diff_apply_phase = diagnostics.get("phase")
                    cand.diff_apply_reason_code = reason_code
                    new_offspring.append(cand)
                    continue
            else:
                final_code = code_content or ""

            code_path, _ = self._save_result_to_file(
                final_code,
                thought or "",
                self.current_generation,
                i + 1,
                strategy,
                diff_to_save,
            )
            cand = Heuristic(
                thought=thought or "",
                code=final_code,
                feedback="",
                generation=self.current_generation,
                parent_ids=[p.id for p in meta_rec.get("parents", [])],
                strategy=strategy,
                origin_pool=meta_rec["origin_pool"],
            )
            cand.code_file_path = code_path
            cand.generated_mode = resolved_mode
            new_offspring.append(cand)
        return new_offspring

    def _update_fail_pool(self, candidates: list[Heuristic]) -> None:
        status_rank = {
            "failed_format": 0,
            "failed_diff": 1,
            "failed_syntax": 2,
            "failed_functionality": 3,
            "failed_synthesis": 4,
            "failed_synthesis_functionality": 5,
        }
        combined = [cand for cand in self.fail_pool + candidates if cand.status != "success"]
        combined.sort(
            key=lambda cand: (
                status_rank.get(cand.status, -1),
                cand.generation,
            ),
            reverse=True,
        )
        self.fail_pool = combined[: self.population_size]

    def _insert_successes(self, candidates: list[Heuristic]) -> tuple[int, int]:
        inserted = 0
        replaced = 0
        for cand in candidates:
            descriptors = self._descriptor_tuple(cand)
            if descriptors is None:
                continue
            result = self.success_archive.insert(cand.id, descriptors, cand.score, cand)
            if result.inserted:
                inserted += 1
            if result.replaced:
                replaced += 1
        self.success_pool = self._archive_elites()
        return inserted, replaced

    def evolve_one_generation(self):
        self.current_generation += 1
        print(f"\n--- Starting QD Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        budget = split_qd_budget(
            total_budget=self.num_offspring_lambda,
            occupied_cells=self.success_archive.occupied_count(),
            num_cells=self.success_archive.num_cells,
            fill_target_fraction=self.qd_fill_target_fraction,
            fail_pool_empty=not bool(self.fail_pool),
            archive_empty=self.success_archive.occupied_count() == 0,
            empty_cells_remaining=self.success_archive.occupied_count() < self.success_archive.num_cells,
        )

        new_offspring: list[Heuristic] = []
        fail_rewards_this_gen = defaultdict(float)
        success_rewards_this_gen = defaultdict(float)
        strategy_avg_selection_probabilities = {"fail_pool": defaultdict(float), "success_pool": defaultdict(float)}

        if budget.seed_budget > 0:
            seed_mode = self._phase_mode("seed")
            seed_results = asyncio.run(
                self.llm.generate_n_responses(
                    prompt=self.problem_description,
                    n=budget.seed_budget,
                    temperature=self.default_llm_temp,
                    top_p=self.default_llm_top_p,
                    max_tokens=self.default_llm_max_tokens,
                    generation_mode=seed_mode,
                    system_prompt_override=self._get_generation_system_prompt(seed_mode),
                )
            )
            seed_meta = [
                {
                    "strategy": "initial",
                    "parents": [],
                    "origin_pool": "success_pool",
                    "resolved_mode": seed_mode,
                }
                for _ in range(len(seed_results))
            ]
            new_offspring.extend(self._materialize_offspring(seed_results, seed_meta))

        llm_requests = []
        request_meta: list[dict[str, Any]] = []

        if self.fail_pool and budget.fail_budget > 0:
            fail_strategies: list[EvolStrategyMethodFail] = ["M-F", "M-E"]
            fail_selected: set[EvolStrategyMethodFail] = set()
            for _ in range(budget.fail_budget):
                strat_name, prob_dist = self._select_strategy("fail", fail_strategies, fail_selected)
                if strat_name is None or prob_dist is None:
                    continue
                fail_selected.add(strat_name)
                parent = random.choice(self.fail_pool)
                mode = self._phase_mode("fail")
                prompt_text = self._with_mode(mode, getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"), [parent])
                llm_requests.append(
                    self._build_prompt_request(
                        prompt=prompt_text,
                        mode=mode,
                        system_prompt=self._get_generation_system_prompt(mode),
                    )
                )
                request_meta.append(
                    {
                        "strategy": strat_name,
                        "parents": [parent],
                        "origin_pool": "fail_pool",
                        "resolved_mode": mode,
                    }
                )
                for key, value in prob_dist.items():
                    strategy_avg_selection_probabilities["fail_pool"][key] += value

        success_selected: set[EvolStrategyMethodSuccess] = set()
        success_total_requests = budget.backfill_budget + budget.refine_budget
        for idx in range(success_total_requests):
            parents = self._sample_success_parents(2 if budget.phase == "improve" and idx == success_total_requests - 1 and len(self.success_pool) > 1 else 1)
            if not parents:
                break
            if budget.phase == "fill" or idx < budget.backfill_budget:
                strat_name: EvolStrategyMethodSuccess = "M-E"
                mode = self._phase_mode("backfill")
            else:
                available: list[EvolStrategyMethodSuccess] = ["M-S", "M-R", "M-I"]
                if len(self.success_pool) > 1:
                    available.append("C-F")
                strat_name, prob_dist = self._select_strategy("success", available, success_selected)
                if strat_name is None or prob_dist is None:
                    continue
                success_selected.add(strat_name)
                mode = self._phase_mode("crossover" if strat_name == "C-F" else "refine")
                for key, value in prob_dist.items():
                    strategy_avg_selection_probabilities["success_pool"][key] += value

            if strat_name == "C-F" and len(parents) < 2:
                parents = self._sample_success_parents(2)
                if len(parents) < 2:
                    continue
            if strat_name != "C-F":
                prompt_text = self._with_mode(mode, getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"), [parents[0]])
            else:
                if parents[0].id == parents[1].id:
                    alt = [cand for cand in self.success_pool if cand.id != parents[0].id]
                    if not alt:
                        continue
                    parents[1] = random.choice(alt)
                prompt_text = self._with_mode(mode, self._create_prompt_C_F, parents)

            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt_text,
                    mode=mode,
                    system_prompt=self._get_generation_system_prompt(mode),
                )
            )
            request_meta.append(
                {
                    "strategy": strat_name,
                    "parents": parents,
                    "origin_pool": "success_pool",
                    "resolved_mode": mode,
                }
            )

        if llm_requests:
            llm_results = asyncio.run(
                self.llm.generate_batch_responses(
                    llm_requests,
                    self.default_llm_temp,
                    self.default_llm_top_p,
                    self.default_llm_max_tokens,
                )
            )
            new_offspring.extend(self._materialize_offspring(llm_results, request_meta))

        if not new_offspring:
            return "STOP"

        self._evaluate_candidates(new_offspring)
        inserted, replaced = self._insert_successes([cand for cand in new_offspring if cand.status == "success"])
        self._update_fail_pool([cand for cand in new_offspring if cand.status != "success"])

        for cand in new_offspring:
            if cand.origin_pool == "fail_pool" and cand.status == "success":
                fail_rewards_this_gen[cand.strategy] += 1.0
            elif cand.origin_pool == "success_pool" and cand.status == "success":
                success_rewards_this_gen[cand.strategy] += 1.0

        gen_runtime = time.time() - self.gen_start_time
        llm_stat_dict = asyncio.run(self.llm.get_and_reset_usage_stats())
        if self.logger:
            self.logger.log_generation(
                self.current_generation,
                new_offspring,
                gen_runtime,
                llm_stat_dict.get("api_calls", 0),
                llm_stat_dict.get("prompt_tokens", 0),
                llm_stat_dict.get("completion_tokens", 0),
                llm_stat_dict.get("code_prompt_tokens", 0),
                llm_stat_dict.get("code_completion_tokens", 0),
                llm_stat_dict.get("feedback_prompt_tokens", 0),
                llm_stat_dict.get("feedback_completion_tokens", 0),
                llm_stat_dict,
                fail_rewards_this_gen,
                success_rewards_this_gen,
                self.fail_strategy_stats,
                self.success_strategy_stats,
                strategy_avg_selection_probabilities,
            )

        print(
            f"--- QD Gen {self.current_generation} Complete. Archive({self.success_archive.occupied_count()}), "
            f"Inserted({inserted}), Replaced({replaced}), Fail({len(self.fail_pool)}) ---"
        )
        return None

    def run(self):
        print(
            f"--- Starting REvolution QD Run: Problem '{self.benchmark_name}/{self.problem_name}' ---"
        )
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            self._calculate_reference_ppa()
            self.logger = EoHLogger(
                self.problem_name,
                self.benchmark_name,
                self.llm.model_name,
                self.base_save_path,
                self.ref_ppa_metrics,
                self.generation_mode,
            )
            self.logger.meta_strategy_name = f"{self.strategy_selection_method}_qd_grid"
            self.initialize_population()
        except Exception as exc:
            print(f"Critical error during QD initialization: {exc}")
            traceback.print_exc()
            return f"{self.problem_name},initialization_failed"

        for _ in range(self.num_generations):
            if self.evolve_one_generation() == "STOP":
                break

        print("\n--- REvolution QD Run Finished ---")
        total_runtime = time.time() - self.run_start_time
        end_utc = datetime.datetime.now(datetime.timezone.utc)
        if self.logger:
            self.logger.finalize_summary(
                self.run_start_utc,
                end_utc,
                total_runtime,
                self.current_generation,
                self.success_pool,
            )

        if self.success_pool:
            best_solution = self.success_pool[0]
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = best_solution.score if best_solution.score is not None else "N/A"
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        return f"{self.problem_name},failed"
