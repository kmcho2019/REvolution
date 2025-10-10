# src/revolution/__init__.py

from .algorithm import EoHEngine, Gen0LatencyEngine, Heuristic, SingleShotEngine, CVDPEngine
from .evaluation import VerilogEvaluator, SynthesisEvaluator
from .llm import LLMInterface
from .logging import EoHLogger
from .utils import StreamRedirector

# This defines the public API of your package
__all__ = [
    "EoHEngine",
    "Heuristic",
    "SingleShotEngine",
    "Gen0LatencyEngine",
    "CVDPEngine",
    "VerilogEvaluator",
    "SynthesisEvaluator",
    "LLMInterface",
    "EoHLogger",
    "StreamRedirector",
]
