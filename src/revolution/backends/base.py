from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.llm import LLMInterface
from revolution.prompt_store import PromptStore
from revolution.runtime import (
    ArtifactWriter,
    CandidateEvaluator,
    ProblemContext,
    ProblemSpec,
)
from revolution.runtime.parallelism import ProblemConcurrencyController


@dataclass(frozen=True)
class RunBudget:
    """Termination controls shared across backends."""

    max_evaluations: int | None = None
    max_iterations: int | None = None
    max_runtime_seconds: float | None = None
    max_llm_calls: int | None = None
    max_llm_tokens: int | None = None


@dataclass
class BackendServices:
    """Shared service dependencies used by backend implementations."""

    llm: LLMInterface
    verilog_evaluator: VerilogEvaluator
    synthesis_evaluator: SynthesisEvaluator
    prompt_store: PromptStore
    artifact_writer: ArtifactWriter
    candidate_evaluator: CandidateEvaluator | None = None
    problem_concurrency: ProblemConcurrencyController | None = None


@dataclass
class BackendExecutionContext:
    """Static context describing the problem/run target."""

    backend_name: str
    model_name: str
    benchmark_name: str
    problem_name: str
    problem_context: ProblemContext
    problem_spec: ProblemSpec | None = None
    generation_mode: str = "whole"
    seed: int | None = None
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class BackendRunResult:
    """Normalized backend result consumed by runner scripts."""

    backend_name: str
    problem_name: str
    status: str
    result_string: str
    best_code_path: str | None = None
    best_report_path: str | None = None
    best_score: float | None = None
    summary_path: str | None = None
    metadata: dict[str, Any] = field(default_factory=dict)


class EvolutionBackend(ABC):
    """Base interface for all evolutionary backends."""

    @property
    @abstractmethod
    def name(self) -> str: ...

    @abstractmethod
    def initialize(self) -> None: ...

    @abstractmethod
    def run(self) -> BackendRunResult: ...

    @abstractmethod
    def get_result_summary(self) -> dict[str, Any]: ...
