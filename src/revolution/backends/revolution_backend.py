from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from revolution.algorithm import EoHEngine
from revolution.backends.base import (
    BackendExecutionContext,
    BackendRunResult,
    BackendServices,
    EvolutionBackend,
)
from revolution.runtime.run_artifacts import add_legacy_strategy_key_alias


@dataclass(frozen=True)
class RevolutionBackendConfig:
    search_mode: str = "revolution"
    population_size: int = 5
    num_generations: int = 5
    default_llm_temp: float = 1.0
    default_llm_top_p: float = 0.95
    default_llm_max_tokens: int = 2048
    strategy_selection_method: str = "ucb"
    epsilon: float = 0.1
    ucb_c: float = 2.0
    generation_mode: str = "whole"
    population_pool_mode: str = "dual"
    diff_apply_policy: str = "hybrid"
    diff_max_tokens: int = 1024
    diff_compact_context: bool = True
    diff_similarity_threshold: float = 0.86
    diff_fuzzy_margin: float = 0.03
    require_strict_format: bool = True
    prompt_profile: str = "default"
    prompt_root: str | None = None
    candidate_workers: int = 0
    qd_archive_type: str = "grid"
    qd_num_cells: int = 64
    qd_fill_target_fraction: float = 0.25
    qd_cell_reservoir: int = 2
    qd_neighbor_k: int = 8
    qd_cvt_warmup_successes: int | None = None
    qd_quality_mode: str = "auto"
    qd_alpha: float | None = None
    qd_beta: float | None = None
    qd_gamma: float | None = None
    qd_descriptor_profile: str | None = None
    qd_descriptor_axes: tuple[str, ...] = ()
    qd_descriptor_file: str | None = None
    qd_enable_descriptor_experiments: bool = False
    qd_descriptor_probe_budget: int = 0
    qd_grid_axes: tuple[str, ...] = ()
    qd_cvt_axes: tuple[str, ...] = ()
    qd_fail_generation_mode: str = "auto"
    qd_seed_generation_mode: str = "auto"
    qd_backfill_generation_mode: str = "auto"
    qd_refine_generation_mode: str = "auto"
    qd_crossover_generation_mode: str = "auto"
    qd_formal_mode: str = "auto"


class RevolutionBackend(EvolutionBackend):
    """Adapter backend that preserves existing EoHEngine behavior."""

    def __init__(
        self,
        context: BackendExecutionContext,
        services: BackendServices,
        config: RevolutionBackendConfig,
        base_save_path: str,
    ) -> None:
        self.context = context
        self.services = services
        self.config = config
        self.base_save_path = base_save_path
        self.engine: EoHEngine | None = None
        self._result: BackendRunResult | None = None

    @property
    def name(self) -> str:
        return "revolution"

    def initialize(self) -> None:
        if (
            self.config.search_mode == "revolution_qd"
            and self.config.population_pool_mode == "single"
        ):
            raise ValueError(
                "search_mode=revolution_qd requires archive-backed success state and "
                "does not support population_pool_mode=single."
            )
        self.engine = EoHEngine(
            benchmark_name=self.context.benchmark_name,
            problem_name=self.context.problem_name,
            llm_interface=self.services.llm,
            verilog_evaluator=self.services.verilog_evaluator,
            synthesis_evaluator=self.services.synthesis_evaluator,
            population_size=self.config.population_size,
            num_generations=self.config.num_generations,
            default_llm_temp=self.config.default_llm_temp,
            default_llm_top_p=self.config.default_llm_top_p,
            default_llm_max_tokens=self.config.default_llm_max_tokens,
            base_save_path=self.base_save_path,
            strategy_selection_method=self.config.strategy_selection_method,  # type: ignore[arg-type]
            epsilon=self.config.epsilon,
            ucb_c=self.config.ucb_c,
            generation_mode=self.config.generation_mode,  # type: ignore[arg-type]
            population_pool_mode=self.config.population_pool_mode,  # type: ignore[arg-type]
            diff_apply_policy=self.config.diff_apply_policy,  # type: ignore[arg-type]
            diff_max_tokens=self.config.diff_max_tokens,
            diff_compact_context=self.config.diff_compact_context,
            diff_similarity_threshold=self.config.diff_similarity_threshold,
            diff_fuzzy_margin=self.config.diff_fuzzy_margin,
            require_strict_format=self.config.require_strict_format,
            prompt_profile=self.config.prompt_profile,
            prompt_root=self.config.prompt_root,
            candidate_workers=self.config.candidate_workers,
        )

    def _annotate_summary(self) -> str | None:
        summary_path = self.services.artifact_writer.paths.summary_path
        if not summary_path.is_file():
            return None
        try:
            payload = json.loads(summary_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            return str(summary_path)
        payload = add_legacy_strategy_key_alias(payload)
        payload.setdefault("backend_name", self.name)
        backend_details = payload.setdefault("backend_details", {})
        backend_details.setdefault("population_size", self.config.population_size)
        backend_details.setdefault("num_generations", self.config.num_generations)
        backend_details.setdefault("search_mode", self.config.search_mode)
        if self.context.problem_spec is not None:
            backend_details.setdefault(
                "problem_spec",
                {
                    "quality_mode": self.context.problem_spec.quality_mode,
                    "circuit_type": self.context.problem_spec.circuit_type,
                    "default_descriptor_profile": self.context.problem_spec.default_descriptor_profile,
                },
            )
        if self.config.search_mode == "revolution_qd":
            backend_details.setdefault(
                "qd_config",
                {
                    "archive_type": self.config.qd_archive_type,
                    "num_cells": self.config.qd_num_cells,
                    "fill_target_fraction": self.config.qd_fill_target_fraction,
                    "quality_mode": self.config.qd_quality_mode,
                    "descriptor_profile": self.config.qd_descriptor_profile,
                    "descriptor_axes": list(self.config.qd_descriptor_axes),
                    "grid_axes": list(self.config.qd_grid_axes),
                    "cvt_axes": list(self.config.qd_cvt_axes),
                    "phase_generation_modes": {
                        "fail": self.config.qd_fail_generation_mode,
                        "seed": self.config.qd_seed_generation_mode,
                        "backfill": self.config.qd_backfill_generation_mode,
                        "refine": self.config.qd_refine_generation_mode,
                        "crossover": self.config.qd_crossover_generation_mode,
                    },
                },
            )

        metadata = self.context.metadata if isinstance(self.context.metadata, dict) else {}
        run_budget = payload.setdefault("run_budget", {})
        run_budget.setdefault("primary_budget_axis", metadata.get("primary_budget_axis"))
        run_budget.setdefault(
            "max_evaluations",
            int(self.config.population_size * (self.config.num_generations + 1)),
        )
        run_budget.setdefault("max_llm_calls", metadata.get("max_llm_calls_per_problem"))
        run_budget.setdefault("max_runtime_seconds", metadata.get("max_runtime_seconds"))
        run_budget.setdefault("evaluation_mode", metadata.get("evaluation_mode"))
        run_budget.setdefault(
            "accelerated_synthesis_top_k",
            metadata.get("accelerated_synthesis_top_k"),
        )
        summary_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
        return str(summary_path)

    def run(self) -> BackendRunResult:
        if self.engine is None:
            self.initialize()
        assert self.engine is not None
        result_str = self.engine.run()
        parts = result_str.split(",")
        status = "failed"
        best_code_path: str | None = None
        best_report_path: str | None = None
        best_score: float | None = None
        if len(parts) >= 2:
            status = parts[1]
        if status == "success":
            if len(parts) >= 3:
                best_code_path = parts[2]
            if len(parts) >= 4:
                best_report_path = parts[3]
            if len(parts) >= 5:
                try:
                    best_score = float(parts[4])
                except ValueError:
                    best_score = None
        summary_path = self._annotate_summary()
        self._result = BackendRunResult(
            backend_name=self.name,
            problem_name=self.context.problem_name,
            status=status,
            result_string=result_str,
            best_code_path=best_code_path,
            best_report_path=best_report_path,
            best_score=best_score,
            summary_path=summary_path,
        )
        return self._result

    def get_result_summary(self) -> dict[str, Any]:
        summary_path = self.services.artifact_writer.paths.summary_path
        if not summary_path.is_file():
            return {}
        try:
            return json.loads(summary_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            return {}
