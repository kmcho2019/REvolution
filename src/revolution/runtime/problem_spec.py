from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal

from revolution.runtime.problem_context import ProblemContext, resolve_top_module_name

CircuitType = Literal["sequential", "combinational", "unknown"]
QualityMode = Literal["ppa", "functional_only"]

_SMALL_BENCH_PHASE_DEFAULTS: dict[str, str] = {
    "fail": "whole",
    "seed": "whole",
    "backfill": "whole",
    "refine": "diff",
    "crossover": "whole",
}
_LARGE_BENCH_PHASE_DEFAULTS: dict[str, str] = {
    "fail": "whole",
    "seed": "whole",
    "backfill": "diff",
    "refine": "diff",
    "crossover": "whole",
}


@dataclass(frozen=True)
class ProblemSpec:
    """Normalized benchmark/problem capabilities for runtime decisions."""

    benchmark_name: str
    problem_name: str
    prompt_text: str
    top_module: str
    benchmark_root: Path
    reference_sources: tuple[str, ...] = ()
    test_harness: str | None = None
    aux_files: tuple[str, ...] = ()
    supports_synthesis: bool = True
    supports_formal: bool = False
    supports_reference_ppa: bool = False
    quality_mode: QualityMode = "functional_only"
    circuit_type: CircuitType = "unknown"
    default_descriptor_profile: str = "rtl_core"
    phase_generation_defaults: dict[str, str] = field(default_factory=dict)
    metadata: dict[str, str] = field(default_factory=dict)


def _default_phase_generation_defaults(benchmark_name: str) -> dict[str, str]:
    if benchmark_name.lower() in {"cvdp", "realbench"}:
        return dict(_LARGE_BENCH_PHASE_DEFAULTS)
    return dict(_SMALL_BENCH_PHASE_DEFAULTS)


def _default_descriptor_profile(
    benchmark_name: str,
    circuit_type: CircuitType,
    quality_mode: QualityMode,
) -> str:
    if quality_mode == "functional_only":
        return "rtl_core"
    if benchmark_name.lower() == "cvdp":
        return "rtl_core"
    if benchmark_name.lower() == "realbench":
        return "hybrid_phys_seq"
    if circuit_type == "combinational":
        return "hybrid_comb_default"
    return "hybrid_seq_default"


def build_problem_spec(
    context: ProblemContext,
    *,
    supports_reference_ppa: bool,
) -> ProblemSpec:
    """Build a normalized spec for on-disk benchmark problems."""

    benchmark_name = context.benchmark_name
    reference_sources = (
        (str(context.ref_sv_path),) if context.ref_sv_path is not None else ()
    )
    if benchmark_name.lower() in {"rtllm", "verilogeval-spec-to-rtl"}:
        circuit_type: CircuitType = "sequential"
        quality_mode: QualityMode = "ppa" if supports_reference_ppa else "functional_only"
    elif benchmark_name.lower() == "realbench":
        circuit_type = "unknown"
        quality_mode = "ppa" if supports_reference_ppa else "functional_only"
    else:
        circuit_type = "unknown"
        quality_mode = "functional_only"

    return ProblemSpec(
        benchmark_name=benchmark_name,
        problem_name=context.problem_name,
        prompt_text=context.problem_description,
        top_module=resolve_top_module_name(context),
        benchmark_root=context.benchmark_path,
        reference_sources=reference_sources,
        test_harness=str(context.test_sv_path),
        supports_synthesis=benchmark_name.lower() != "cvdp",
        supports_formal=False,
        supports_reference_ppa=supports_reference_ppa,
        quality_mode=quality_mode,
        circuit_type=circuit_type,
        default_descriptor_profile=_default_descriptor_profile(
            benchmark_name,
            circuit_type,
            quality_mode,
        ),
        phase_generation_defaults=_default_phase_generation_defaults(benchmark_name),
    )


def build_cvdp_problem_spec(
    context: ProblemContext,
    *,
    cvdp_record: dict[str, object],
    supports_reference_ppa: bool = False,
) -> ProblemSpec:
    """Build a normalized spec for CVDP JSONL records."""

    raw_categories = cvdp_record.get("categories", [])
    if isinstance(raw_categories, list):
        categories = tuple(str(cat) for cat in raw_categories)
    else:
        categories = ()
    quality_mode: QualityMode = "ppa" if supports_reference_ppa else "functional_only"
    return ProblemSpec(
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        prompt_text=context.problem_description,
        top_module="TopModule",
        benchmark_root=context.benchmark_path,
        reference_sources=(),
        test_harness="pytest",
        supports_synthesis=supports_reference_ppa,
        supports_formal=False,
        supports_reference_ppa=supports_reference_ppa,
        quality_mode=quality_mode,
        circuit_type="unknown",
        default_descriptor_profile=_default_descriptor_profile(
            context.benchmark_name,
            "unknown",
            quality_mode,
        ),
        phase_generation_defaults=_default_phase_generation_defaults(
            context.benchmark_name
        ),
        metadata={"categories": ",".join(categories)},
    )
