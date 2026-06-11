"""Declarative benchmark capability model.

This module centralizes what each benchmark suite can legitimately claim so
runners and reports stop switching on raw benchmark names. Capabilities are
resolved per problem: suite-level family defaults are merged with per-problem
facts (reference-PPA availability, manifest overrides) and normalized into one
frozen snapshot that travels with :class:`~revolution.runtime.problem_spec.ProblemSpec`
and is serialized into run summaries.

Key journal-revamp rule encoded here: CVDP must never report
reference-normalized PPA gains. Families that disallow reference-normalized
PPA have requested reference support suppressed, and the suppression is
recorded in ``notes`` so reports can show why a metric is absent instead of
silently blending suites.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Literal, Mapping, Sequence

PpaMode = Literal["reference_normalized", "absolute_only", "none"]
QualityObjectivePolicy = Literal["reference_ppa", "functional_only"]
WorkloadClass = Literal["small", "large"]

_KNOWN_FAMILIES = {
    "rtllm",
    "verilogeval-spec-to-rtl",
    "verilogeval-code-complete",
    "cvdp",
    "realbench",
}


def canonical_benchmark_family(benchmark_name: str) -> str:
    """Normalize a benchmark name to its capability-family key."""

    return benchmark_name.strip().lower()


@dataclass(frozen=True)
class BenchmarkCapabilities:
    """Per-problem snapshot of what a benchmark suite can legitimately claim."""

    benchmark_name: str
    benchmark_family: str
    supports_functional: bool = True
    functional_harness_kind: str = "iverilog_testbench"
    supports_synthesis: bool = True
    supports_post_synth_check: bool = False
    supports_reference_ppa: bool = False
    ppa_mode: PpaMode = "none"
    quality_objective_policy: QualityObjectivePolicy = "functional_only"
    allows_reference_normalized_ppa: bool = True
    workload_class: WorkloadClass = "small"
    top_module: str | None = None
    clock_metadata: dict[str, str] = field(default_factory=dict)
    reset_metadata: dict[str, str] = field(default_factory=dict)
    aux_files: tuple[str, ...] = ()
    default_timeout_s: float | None = None
    license_tag: str | None = None
    notes: tuple[str, ...] = ()

    def as_dict(self) -> dict[str, object]:
        """Return a JSON-serializable snapshot for run artifacts/reports."""

        return {
            "benchmark_name": self.benchmark_name,
            "benchmark_family": self.benchmark_family,
            "supports_functional": self.supports_functional,
            "functional_harness_kind": self.functional_harness_kind,
            "supports_synthesis": self.supports_synthesis,
            "supports_post_synth_check": self.supports_post_synth_check,
            "supports_reference_ppa": self.supports_reference_ppa,
            "ppa_mode": self.ppa_mode,
            "quality_objective_policy": self.quality_objective_policy,
            "allows_reference_normalized_ppa": self.allows_reference_normalized_ppa,
            "workload_class": self.workload_class,
            "top_module": self.top_module,
            "clock_metadata": dict(self.clock_metadata),
            "reset_metadata": dict(self.reset_metadata),
            "aux_files": list(self.aux_files),
            "default_timeout_s": self.default_timeout_s,
            "license_tag": self.license_tag,
            "notes": list(self.notes),
        }


@dataclass(frozen=True)
class _FamilyDefaults:
    supports_functional: bool = True
    functional_harness_kind: str = "iverilog_testbench"
    supports_synthesis: bool = True
    supports_reference_ppa_default: bool = False
    quality_objective_policy: QualityObjectivePolicy = "functional_only"
    allows_reference_normalized_ppa: bool = True
    infers_circuit_type_from_reference_ppa: bool = False
    workload_class: WorkloadClass = "small"
    clock_metadata: Mapping[str, str] = field(default_factory=dict)
    reset_metadata: Mapping[str, str] = field(default_factory=dict)
    default_timeout_s: float | None = None
    license_tag: str | None = None


_UNIFORM_FLOW_CLOCK: dict[str, str] = {
    "clock_period_ns": "0.01",
    "clock_policy": "uniform_flow_clock",
}

_GENERIC_DEFAULTS = _FamilyDefaults()

_FAMILY_DEFAULTS: dict[str, _FamilyDefaults] = {
    "rtllm": _FamilyDefaults(
        quality_objective_policy="reference_ppa",
        infers_circuit_type_from_reference_ppa=True,
        clock_metadata=_UNIFORM_FLOW_CLOCK,
    ),
    "verilogeval-spec-to-rtl": _FamilyDefaults(
        quality_objective_policy="reference_ppa",
        infers_circuit_type_from_reference_ppa=True,
        clock_metadata=_UNIFORM_FLOW_CLOCK,
    ),
    "verilogeval-code-complete": _FamilyDefaults(
        quality_objective_policy="functional_only",
        clock_metadata=_UNIFORM_FLOW_CLOCK,
    ),
    "cvdp": _FamilyDefaults(
        functional_harness_kind="cocotb_pytest",
        supports_synthesis=False,
        quality_objective_policy="functional_only",
        allows_reference_normalized_ppa=False,
        workload_class="large",
        license_tag="no_commercial",
    ),
    "realbench": _FamilyDefaults(
        quality_objective_policy="reference_ppa",
        workload_class="large",
    ),
}


def family_defaults(benchmark_name: str) -> _FamilyDefaults:
    """Return the suite-level capability defaults for a benchmark name."""

    return _FAMILY_DEFAULTS.get(
        canonical_benchmark_family(benchmark_name), _GENERIC_DEFAULTS
    )


def family_infers_circuit_type(benchmark_name: str) -> bool:
    """Whether this family infers circuit type from the reference PPA file."""

    return family_defaults(benchmark_name).infers_circuit_type_from_reference_ppa


def is_known_benchmark_family(benchmark_name: str) -> bool:
    """Whether the benchmark maps to a family with explicit defaults."""

    return canonical_benchmark_family(benchmark_name) in _KNOWN_FAMILIES


def resolve_benchmark_capabilities(
    benchmark_name: str,
    *,
    supports_reference_ppa: bool = False,
    supports_synthesis: bool | None = None,
    supports_functional: bool | None = None,
    functional_harness_kind: str | None = None,
    top_module: str | None = None,
    aux_files: Sequence[str] = (),
    default_timeout_s: float | None = None,
    clock_metadata: Mapping[str, str] | None = None,
    reset_metadata: Mapping[str, str] | None = None,
    license_tag: str | None = None,
) -> BenchmarkCapabilities:
    """Merge family defaults with per-problem facts into one snapshot.

    ``supports_reference_ppa`` states whether a usable reference PPA exists for
    this problem. Families that disallow reference-normalized PPA (CVDP) have
    the request suppressed and the suppression recorded in ``notes``.
    """

    family = canonical_benchmark_family(benchmark_name)
    defaults = _FAMILY_DEFAULTS.get(family, _GENERIC_DEFAULTS)
    notes: list[str] = []

    effective_functional = (
        defaults.supports_functional if supports_functional is None else supports_functional
    )
    effective_harness = functional_harness_kind or defaults.functional_harness_kind
    effective_synthesis = (
        defaults.supports_synthesis if supports_synthesis is None else supports_synthesis
    )

    effective_reference_ppa = supports_reference_ppa
    if supports_reference_ppa and not defaults.allows_reference_normalized_ppa:
        effective_reference_ppa = False
        notes.append(
            "reference_normalized_ppa_suppressed: "
            f"family '{family}' reports absolute PPA only"
        )

    if not effective_synthesis:
        ppa_mode: PpaMode = "none"
    elif (
        defaults.quality_objective_policy == "reference_ppa"
        and effective_reference_ppa
    ):
        ppa_mode = "reference_normalized"
    else:
        ppa_mode = "absolute_only"

    return BenchmarkCapabilities(
        benchmark_name=benchmark_name,
        benchmark_family=family,
        supports_functional=effective_functional,
        functional_harness_kind=effective_harness,
        supports_synthesis=effective_synthesis,
        supports_post_synth_check=effective_synthesis and effective_functional,
        supports_reference_ppa=effective_reference_ppa,
        ppa_mode=ppa_mode,
        quality_objective_policy=defaults.quality_objective_policy,
        allows_reference_normalized_ppa=defaults.allows_reference_normalized_ppa,
        workload_class=defaults.workload_class,
        top_module=top_module,
        clock_metadata=dict(clock_metadata or defaults.clock_metadata),
        reset_metadata=dict(reset_metadata or defaults.reset_metadata),
        aux_files=tuple(str(item) for item in aux_files),
        default_timeout_s=(
            default_timeout_s if default_timeout_s is not None else defaults.default_timeout_s
        ),
        license_tag=license_tag if license_tag is not None else defaults.license_tag,
        notes=tuple(notes),
    )


def derive_quality_mode(
    capabilities: BenchmarkCapabilities,
) -> Literal["ppa", "functional_only"]:
    """Derive the runtime search objective from capability facts.

    Reference-normalized PPA is the only mode where the evolutionary quality
    score may use PPA gains versus a reference design; absolute-only suites
    keep a functional-only search objective so suite metrics stay comparable.
    """

    if capabilities.ppa_mode == "reference_normalized":
        return "ppa"
    return "functional_only"
