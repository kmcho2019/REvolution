# src/revolution/__init__.py

from .algorithm import EoHEngine, Gen0LatencyEngine, Heuristic, SingleShotEngine, CVDPEngine
from .backends import (
    BackendExecutionContext,
    BackendRunResult,
    BackendServices,
    EoHBackend,
    EoHBackendConfig,
    FunSearchBackend,
    FunSearchBackendConfig,
    RevolutionBackend,
    RevolutionBackendConfig,
)
from .evaluation import VerilogEvaluator, SynthesisEvaluator
from .llm import LLMInterface
from .logging import EoHLogger
from .runtime import ArtifactWriter, CandidateEvaluator, CandidateWorkItem, ProblemContext
from .utils import StreamRedirector

# This defines the public API of your package
__all__ = [
    "ArtifactWriter",
    "BackendExecutionContext",
    "BackendRunResult",
    "BackendServices",
    "CandidateEvaluator",
    "CandidateWorkItem",
    "EoHBackend",
    "EoHBackendConfig",
    "ProblemContext",
    "EoHEngine",
    "FunSearchBackend",
    "FunSearchBackendConfig",
    "Heuristic",
    "SingleShotEngine",
    "Gen0LatencyEngine",
    "CVDPEngine",
    "RevolutionBackend",
    "RevolutionBackendConfig",
    "VerilogEvaluator",
    "SynthesisEvaluator",
    "LLMInterface",
    "EoHLogger",
    "StreamRedirector",
]
