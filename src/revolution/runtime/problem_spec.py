from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal

from revolution.runtime.benchmark_capabilities import (
    BenchmarkCapabilities,
    canonical_benchmark_family,
    derive_quality_mode,
    family_defaults,
    family_infers_circuit_type,
    resolve_benchmark_capabilities,
)
from revolution.runtime.problem_context import (
    ProblemContext,
    resolve_synthesis_top_module_name,
    resolve_testbench_top_module,
)

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
    testbench_top_module: str = "tb"
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
    capabilities: BenchmarkCapabilities | None = None


def _default_phase_generation_defaults(benchmark_name: str) -> dict[str, str]:
    if family_defaults(benchmark_name).workload_class == "large":
        return dict(_LARGE_BENCH_PHASE_DEFAULTS)
    return dict(_SMALL_BENCH_PHASE_DEFAULTS)


def _default_descriptor_profile(
    benchmark_name: str,
    circuit_type: CircuitType,
    quality_mode: QualityMode,
) -> str:
    family = canonical_benchmark_family(benchmark_name)
    if quality_mode == "functional_only":
        return "rtl_core"
    if family == "cvdp":
        return "rtl_core"
    if family == "realbench":
        return "hybrid_phys_seq"
    if circuit_type == "combinational":
        return "hybrid_comb_default"
    return "hybrid_seq_default"


def infer_circuit_type_from_reference_ppa_path(ppa_path: Path) -> CircuitType:
    """Infer whether a benchmark problem is sequential or combinational."""

    if not ppa_path.is_file():
        return "unknown"

    lines = ppa_path.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return "unknown"

    values = lines[1].split(",")
    if len(values) < 3:
        return "unknown"

    try:
        eff_clk_period = float(values[2])
    except ValueError:
        return "unknown"

    if abs(eff_clk_period) <= 1e-12:
        return "combinational"
    return "sequential"


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
    top_module = resolve_synthesis_top_module_name(context)
    capabilities = resolve_benchmark_capabilities(
        benchmark_name,
        supports_reference_ppa=supports_reference_ppa,
        top_module=top_module,
    )
    quality_mode = derive_quality_mode(capabilities)
    if family_infers_circuit_type(benchmark_name):
        circuit_type = infer_circuit_type_from_reference_ppa_path(
            context.benchmark_path / f"{context.problem_name}_ppa.txt"
        )
    else:
        circuit_type = "unknown"

    return ProblemSpec(
        benchmark_name=benchmark_name,
        problem_name=context.problem_name,
        prompt_text=context.problem_description,
        top_module=top_module,
        testbench_top_module=resolve_testbench_top_module(context),
        benchmark_root=context.benchmark_path,
        reference_sources=reference_sources,
        test_harness=str(context.test_sv_path),
        supports_synthesis=capabilities.supports_synthesis,
        supports_formal=False,
        supports_reference_ppa=capabilities.supports_reference_ppa,
        quality_mode=quality_mode,
        circuit_type=circuit_type,
        default_descriptor_profile=_default_descriptor_profile(
            benchmark_name,
            circuit_type,
            quality_mode,
        ),
        phase_generation_defaults=_default_phase_generation_defaults(benchmark_name),
        capabilities=capabilities,
    )


def build_cvdp_problem_spec(
    context: ProblemContext,
    *,
    cvdp_record: dict[str, object],
    supports_reference_ppa: bool = False,
    enable_synthesis: bool = False,
) -> ProblemSpec:
    """Build a normalized spec for CVDP JSONL records.

    CVDP never uses reference-normalized PPA: a ``supports_reference_ppa``
    request is suppressed by the capability model and recorded in
    ``capabilities.notes``. ``enable_synthesis`` opts a record into the
    absolute-only PPA path once synthesis is known to be reliable.
    """

    raw_categories = cvdp_record.get("categories", [])
    if isinstance(raw_categories, list):
        categories = tuple(str(cat) for cat in raw_categories)
    else:
        categories = ()
    capabilities = resolve_benchmark_capabilities(
        context.benchmark_name,
        supports_reference_ppa=supports_reference_ppa,
        supports_synthesis=True if enable_synthesis else None,
        top_module="TopModule",
    )
    quality_mode = derive_quality_mode(capabilities)
    return ProblemSpec(
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        prompt_text=context.problem_description,
        top_module="TopModule",
        testbench_top_module="tb",
        benchmark_root=context.benchmark_path,
        reference_sources=(),
        test_harness="pytest",
        supports_synthesis=capabilities.supports_synthesis,
        supports_formal=False,
        supports_reference_ppa=capabilities.supports_reference_ppa,
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
        capabilities=capabilities,
    )
