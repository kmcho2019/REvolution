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
    population_size: int = 5
    num_generations: int = 5
    default_llm_temp: float = 1.0
    default_llm_top_p: float = 0.95
    default_llm_max_tokens: int = 2048
    strategy_selection_method: str = "random"
    epsilon: float = 0.1
    ucb_c: float = 2.0
    generation_mode: str = "whole"
    population_pool_mode: str = "dual"
    require_strict_format: bool = True
    prompt_profile: str = "default"
    prompt_root: str | None = None
    candidate_workers: int = 0


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
        payload.setdefault("backend_details", {})
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
