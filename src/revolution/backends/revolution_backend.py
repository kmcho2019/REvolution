from __future__ import annotations

import json
from dataclasses import dataclass
from typing import Any

from revolution.algorithm import EoHEngine
from revolution.backends.base import (
    BackendExecutionContext,
    BackendRunResult,
    BackendServices,
    EvolutionBackend,
)
from revolution.qd import QDEngine
from revolution.runtime.run_artifacts import add_legacy_strategy_key_alias


@dataclass(frozen=True)
class RevolutionBackendConfig:
    """Configuration snapshot for the REvolution backend adapter."""

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
    classic_operator_kind: str = "eoh_strategies"
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
    qd_cell_mode: str = "scalar_elite"
    qd_max_elites_per_cell: int = 1
    qd_objectives: str = "ppa"
    qd_two_parent_probability: float = 0.5
    qd_neighbor_k: int = 8
    qd_cvt_warmup_successes: int | None = None
    qd_grid_quantile_warmup_successes: int = 20
    qd_grid_quantile_warmup_max_buffer: int = 0
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
    qd_operator_kind: str = "eoh_strategies"
    qd_operator_one_parent_fraction: float = 0.5
    qd_operator_archive_context_size: int = 4
    qd_operator_fail_feedback_chars: int = 0
    qd_operator_two_parent_allow_intra_bin: bool = True
    qd_rebinning_kind: str = "disabled"
    qd_rebinning_recent_generations: int = 3
    qd_rebinning_min_archive_members: int = 20
    qd_rebinning_cooldown_generations: int = 3
    qd_rebinning_base_p_threshold: float = 0.05
    representation_kind: str = "code_individual"
    code_samples_per_thought: int = 4
    qd_thought_code_seeded: bool = False
    qd_champion_lane_fraction: float = 0.0
    representative_sample: str = "best_successful_quality"
    repair_kind: str = "none"
    repair_max_attempts_per_sample: int = 0
    repair_max_attempts_per_thought: int = 0
    repair_evidence: str = "stage_scoped_logs"


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
        engine_cls = QDEngine if self.config.search_mode == "revolution_qd" else EoHEngine
        engine_kwargs: dict[str, Any] = dict(
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
            strategy_selection_method=self.config.strategy_selection_method,
            epsilon=self.config.epsilon,
            ucb_c=self.config.ucb_c,
            generation_mode=self.config.generation_mode,
            population_pool_mode=self.config.population_pool_mode,
            classic_operator_kind=self.config.classic_operator_kind,
            diff_apply_policy=self.config.diff_apply_policy,
            diff_max_tokens=self.config.diff_max_tokens,
            diff_compact_context=self.config.diff_compact_context,
            diff_similarity_threshold=self.config.diff_similarity_threshold,
            diff_fuzzy_margin=self.config.diff_fuzzy_margin,
            require_strict_format=self.config.require_strict_format,
            prompt_profile=self.config.prompt_profile,
            prompt_root=self.config.prompt_root,
            candidate_workers=self.config.candidate_workers,
            problem_concurrency=getattr(self.services, "problem_concurrency", None),
            problem_spec=self.context.problem_spec,
        )
        if engine_cls is QDEngine:
            engine_kwargs.update(
                qd_archive_type=self.config.qd_archive_type,
                qd_num_cells=self.config.qd_num_cells,
                qd_fill_target_fraction=self.config.qd_fill_target_fraction,
                qd_cell_reservoir=self.config.qd_cell_reservoir,
                qd_cell_mode=self.config.qd_cell_mode,
                qd_max_elites_per_cell=self.config.qd_max_elites_per_cell,
                qd_objectives=self.config.qd_objectives,
                qd_two_parent_probability=self.config.qd_two_parent_probability,
                qd_cvt_warmup_successes=self.config.qd_cvt_warmup_successes,
                qd_grid_quantile_warmup_successes=self.config.qd_grid_quantile_warmup_successes,
                qd_grid_quantile_warmup_max_buffer=self.config.qd_grid_quantile_warmup_max_buffer,
                qd_descriptor_profile=self.config.qd_descriptor_profile,
                qd_descriptor_axes=self.config.qd_descriptor_axes,
                qd_descriptor_file=self.config.qd_descriptor_file,
                qd_grid_axes=self.config.qd_grid_axes,
                qd_cvt_axes=self.config.qd_cvt_axes,
                qd_fail_generation_mode=self.config.qd_fail_generation_mode,
                qd_seed_generation_mode=self.config.qd_seed_generation_mode,
                qd_backfill_generation_mode=self.config.qd_backfill_generation_mode,
                qd_refine_generation_mode=self.config.qd_refine_generation_mode,
                qd_crossover_generation_mode=self.config.qd_crossover_generation_mode,
                qd_operator_kind=self.config.qd_operator_kind,
                qd_operator_one_parent_fraction=self.config.qd_operator_one_parent_fraction,
                qd_operator_archive_context_size=self.config.qd_operator_archive_context_size,
                qd_operator_fail_feedback_chars=self.config.qd_operator_fail_feedback_chars,
                qd_operator_two_parent_allow_intra_bin=self.config.qd_operator_two_parent_allow_intra_bin,
                qd_rebinning_kind=self.config.qd_rebinning_kind,
                qd_rebinning_recent_generations=self.config.qd_rebinning_recent_generations,
                qd_rebinning_min_archive_members=self.config.qd_rebinning_min_archive_members,
                qd_rebinning_cooldown_generations=self.config.qd_rebinning_cooldown_generations,
                qd_rebinning_base_p_threshold=self.config.qd_rebinning_base_p_threshold,
                representation_kind=self.config.representation_kind,
                code_samples_per_thought=self.config.code_samples_per_thought,
                qd_thought_code_seeded=self.config.qd_thought_code_seeded,
                qd_champion_lane_fraction=self.config.qd_champion_lane_fraction,
                representative_sample=self.config.representative_sample,
                repair_kind=self.config.repair_kind,
                repair_max_attempts_per_sample=self.config.repair_max_attempts_per_sample,
                repair_max_attempts_per_thought=self.config.repair_max_attempts_per_thought,
                repair_evidence=self.config.repair_evidence,
            )
        self.engine = engine_cls(**engine_kwargs)

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
            problem_spec_details: dict[str, object] = {
                "quality_mode": self.context.problem_spec.quality_mode,
                "circuit_type": self.context.problem_spec.circuit_type,
                "default_descriptor_profile": self.context.problem_spec.default_descriptor_profile,
            }
            capabilities = self.context.problem_spec.capabilities
            if capabilities is not None:
                problem_spec_details["benchmark_capabilities"] = capabilities.as_dict()
            backend_details.setdefault("problem_spec", problem_spec_details)
        evaluator = getattr(self.services, "candidate_evaluator", None)
        counters = getattr(evaluator, "telemetry_counters", None)
        if isinstance(counters, dict) and counters:
            backend_details.setdefault("evaluator_telemetry", dict(counters))
        if self.config.search_mode == "revolution_qd":
            backend_details.setdefault(
                "qd_config",
                {
                    "archive_type": self.config.qd_archive_type,
                    "cell_mode": self.config.qd_cell_mode,
                    "max_elites_per_cell": self.config.qd_max_elites_per_cell,
                    "objectives": self.config.qd_objectives,
                    "two_parent_probability": self.config.qd_two_parent_probability,
                    "num_cells": self.config.qd_num_cells,
                    "fill_target_fraction": self.config.qd_fill_target_fraction,
                    "quality_mode": self.config.qd_quality_mode,
                    "grid_quantile_warmup_successes": self.config.qd_grid_quantile_warmup_successes,
                    "grid_quantile_warmup_max_buffer": self.config.qd_grid_quantile_warmup_max_buffer,
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
                    "operator": {
                        "kind": self.config.qd_operator_kind,
                        "one_parent_fraction": self.config.qd_operator_one_parent_fraction,
                        "archive_context_size": self.config.qd_operator_archive_context_size,
                        "fail_feedback_chars": self.config.qd_operator_fail_feedback_chars,
                        "two_parent_allow_intra_bin": self.config.qd_operator_two_parent_allow_intra_bin,
                    },
                    "rebinning": {
                        "kind": self.config.qd_rebinning_kind,
                        "recent_generations": self.config.qd_rebinning_recent_generations,
                        "min_archive_members": self.config.qd_rebinning_min_archive_members,
                        "cooldown_generations": self.config.qd_rebinning_cooldown_generations,
                        "base_p_threshold": self.config.qd_rebinning_base_p_threshold,
                    },
                    "representation": {
                        "kind": self.config.representation_kind,
                        "code_samples_per_thought": self.config.code_samples_per_thought,
                        "representative_sample": self.config.representative_sample,
                        "thought_population_size": (
                            self.config.population_size
                            // self.config.code_samples_per_thought
                            if self.config.representation_kind == "thought_only"
                            else self.config.population_size
                        ),
                    },
                    "repair": {
                        "kind": self.config.repair_kind,
                        "max_attempts_per_sample": self.config.repair_max_attempts_per_sample,
                        "max_attempts_per_thought": self.config.repair_max_attempts_per_thought,
                        "evidence": self.config.repair_evidence,
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
        if self.config.representation_kind == "thought_only":
            run_budget.setdefault(
                "base_code_samples_per_generation",
                self.config.population_size,
            )
            run_budget.setdefault(
                "code_samples_per_thought",
                self.config.code_samples_per_thought,
            )
            run_budget.setdefault(
                "thought_population_size",
                self.config.population_size // self.config.code_samples_per_thought,
            )
            run_budget.setdefault(
                "max_base_thoughts",
                (
                    self.config.population_size
                    // self.config.code_samples_per_thought
                )
                * (self.config.num_generations + 1),
            )
        run_budget.setdefault("max_llm_calls", metadata.get("max_llm_calls_per_problem"))
        run_budget.setdefault("max_runtime_seconds", metadata.get("max_runtime_seconds"))
        run_budget.setdefault("evaluation_mode", metadata.get("evaluation_mode"))
        run_budget.setdefault(
            "accelerated_synthesis_top_k",
            metadata.get("accelerated_synthesis_top_k"),
        )
        run_budget.setdefault("total_worker_slots", metadata.get("total_worker_slots"))
        run_budget.setdefault("max_active_problems", metadata.get("max_active_problems"))
        run_budget.setdefault(
            "max_workers_per_problem",
            metadata.get("max_workers_per_problem"),
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
