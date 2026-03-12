# src/revolution/__init__.py

from .algorithm import EoHEngine, Gen0LatencyEngine, Heuristic, SingleShotEngine, CVDPEngine
from .backends import (
    BACKEND_REGISTRY,
    BackendExecutionContext,
    BackendMetadata,
    BackendRunResult,
    BackendServices,
    CodeEvolveBackend,
    CodeEvolveBackendConfig,
    EoHBackend,
    EoHBackendConfig,
    FunSearchBackend,
    FunSearchBackendConfig,
    RevolutionBackend,
    RevolutionBackendConfig,
    backend_supports_cvdp,
    default_prompt_profile_for_backend,
    registered_backend_names,
)
from .evaluation import VerilogEvaluator, SynthesisEvaluator
from .llm import LLMInterface
from .logging import EoHLogger
from .runtime import (
    ArtifactWriter,
    CandidateEvaluator,
    CandidateWorkItem,
    ProblemContext,
    ProblemSpec,
    build_cvdp_problem_spec,
    build_problem_spec,
)
from .utils import StreamRedirector

# This defines the public API of your package
__all__ = [
    "ArtifactWriter",
    "BACKEND_REGISTRY",
    "BackendExecutionContext",
    "BackendMetadata",
    "BackendRunResult",
    "BackendServices",
    "CandidateEvaluator",
    "CandidateWorkItem",
    "CodeEvolveBackend",
    "CodeEvolveBackendConfig",
    "EoHBackend",
    "EoHBackendConfig",
    "ProblemContext",
    "ProblemSpec",
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
    "backend_supports_cvdp",
    "build_cvdp_problem_spec",
    "build_problem_spec",
    "default_prompt_profile_for_backend",
    "registered_backend_names",
]
