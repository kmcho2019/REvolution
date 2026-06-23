"""Retrospective loader for successful classic and QD candidates.

The reporting scripts want one shared view of "successful individuals"
regardless of whether a run came from the classic scalar-fitness loop or
from a QD archive-backed backend. This module loads those candidates from
completed run artifacts, enriches them with whatever metrics are available
on disk, and exports row-shaped payloads for downstream reports.
"""

from __future__ import annotations

import csv
import json
import math
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator
from revolution.qd.descriptors import descriptor_registry, extract_descriptor_values
from revolution.qd.pareto_analysis import (
    circuit_type_for_reference,
    compute_candidate_improvements,
    objective_labels_for_metrics,
    objective_metrics_for_reference,
)
from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator
from revolution.simulation_descriptor_evaluator import SimulationDescriptorEvaluator
from revolution.source_aligned_descriptor_evaluator import SourceAlignedRTLDescriptorEvaluator


IGNORED_SUMMARY_FILENAMES = {
    "archive_summary.json",
    "global_pareto_summary.json",
}
BASE_EXPORT_COLUMNS = [
    "backend",
    "benchmark",
    "problem",
    "circuit_type",
    "search_mode",
    "archive_type",
    "descriptor_profile",
    "generation",
    "generation_views_available",
    "source",
    "candidate_id",
    "strategy",
    "score",
    "quality_score",
    "color_score",
    "origin_pool",
    "generated_mode",
    "decision",
    "inserted",
    "replaced",
    "cell_id",
    "is_final_elite",
    "area",
    "power",
    "eff_clk_period",
    "tns",
    "wns",
    "g_A",
    "g_P",
    "g_T",
    "report_path",
    "candidate_dir",
    "code_file_path",
    "metrics_json_path",
    "qd_event_path",
    "vcd_file_path",
    "has_qd_event",
    "has_metrics_json",
    "has_code_file",
    "has_vcd_file",
    "has_structural_metrics",
    "has_rtl_metrics",
    "has_graph_metrics",
    "has_dynamic_metrics",
    "has_physical_metrics",
    "warning_messages",
]


@dataclass(frozen=True)
class QdEventRecord:
    """One archived QD event keyed by candidate id and generation."""

    candidate_id: str
    generation: int | None
    path: Path
    payload: dict[str, Any]


@dataclass(frozen=True)
class ProblemRunContext:
    """Shared metadata for one backend / benchmark / problem run directory."""

    backend: str
    benchmark: str
    problem: str
    backend_root: Path
    problem_root: Path
    summary_path: Path
    ref_ppa_metrics: dict[str, float]
    objective_metrics: tuple[str, ...]
    objective_labels: tuple[str, ...]
    circuit_type: str
    generation_views_available: bool
    search_mode: str | None
    archive_type: str | None
    descriptor_profile: str | None
    descriptor_axes: tuple[str, ...]
    final_elite_ids: frozenset[str]


@dataclass
class SuccessfulCandidateRecord:
    """Normalized view of one successful individual plus recovered artifacts."""

    backend: str
    benchmark: str
    problem: str
    problem_root: Path
    circuit_type: str
    search_mode: str | None
    archive_type: str | None
    descriptor_profile: str | None
    generation: int | None
    generation_views_available: bool
    source: str
    candidate_id: str
    strategy: str
    score: float | None
    report_path: str | None
    ppa_metrics: dict[str, float]
    ref_ppa_metrics: dict[str, float]
    objective_metrics: tuple[str, ...]
    objective_labels: tuple[str, ...]
    candidate_dir: Path | None = None
    code_file_path: Path | None = None
    metrics_json_path: Path | None = None
    qd_event_path: Path | None = None
    vcd_file_path: Path | None = None
    quality_score: float | None = None
    origin_pool: str | None = None
    generated_mode: str | None = None
    decision: str | None = None
    inserted: bool = False
    replaced: bool = False
    cell_id: str | None = None
    is_final_elite: bool = False
    has_qd_event: bool = False
    has_metrics_json: bool = False
    has_code_file: bool = False
    has_vcd_file: bool = False
    has_structural_metrics: bool = False
    has_rtl_metrics: bool = False
    has_graph_metrics: bool = False
    has_dynamic_metrics: bool = False
    has_physical_metrics: bool = False
    structural_metrics: dict[str, float] = field(default_factory=dict)
    rtl_metrics: dict[str, float] = field(default_factory=dict)
    graph_metrics: dict[str, float] = field(default_factory=dict)
    dynamic_metrics: dict[str, float] = field(default_factory=dict)
    physical_metrics: dict[str, float] = field(default_factory=dict)
    descriptor_values: dict[str, float] = field(default_factory=dict)
    score_components: dict[str, float] = field(default_factory=dict)
    normalized_gains: dict[str, float] = field(default_factory=dict)
    flattened_metrics: dict[str, float] = field(default_factory=dict)
    warning_messages: list[str] = field(default_factory=list)

    @property
    def color_score(self) -> float | None:
        if self.quality_score is not None:
            return self.quality_score
        return self.score


@dataclass(frozen=True)
class SuccessfulCandidateCatalog:
    """Collected successful-candidate records for a reporting scope."""

    problem_runs: tuple[ProblemRunContext, ...]
    candidates: tuple[SuccessfulCandidateRecord, ...]
    warnings: tuple[str, ...]


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _safe_int(value: Any) -> int | None:
    parsed = _safe_float(value)
    if parsed is None:
        return None
    return int(parsed)


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[3]


def _is_problem_summary_path(summary_path: Path) -> bool:
    return (
        summary_path.name.endswith("_summary.json")
        and summary_path.name not in IGNORED_SUMMARY_FILENAMES
    )


def _canonical_summary_identity(summary_path: Path) -> tuple[str, str] | None:
    try:
        benchmark = summary_path.parent.parent.name
        problem = summary_path.parent.name
    except IndexError:
        return None
    if not benchmark or not problem:
        return None
    return benchmark, problem


def _load_json_mapping(
    path: Path,
    *,
    warnings: list[str],
    label: str,
) -> dict[str, Any] | None:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        warnings.append(f"Skipped malformed {label}: {path} ({exc})")
        return None
    if not isinstance(payload, dict):
        warnings.append(f"Skipped non-object {label}: {path}")
        return None
    return payload


def _load_reference_ppa_metrics_from_bench(benchmark: str, problem: str) -> dict[str, float]:
    path = _repo_root() / "data" / "bench" / benchmark / f"{problem}_ppa.txt"
    if not path.is_file():
        return {}
    lines = path.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return {}
    values = lines[1].split(",")
    if len(values) < 5:
        return {}
    try:
        tns = float(values[0])
        wns = float(values[1])
        eff_clk_period = float(values[2])
        power = float(values[3])
        area = float(values[4])
    except ValueError:
        return {}
    return {
        "tns": tns,
        "wns": wns,
        "eff_clk_period": eff_clk_period,
        "power": power,
        "area": area,
    }


def _flatten_numeric_mapping(payload: dict[str, Any] | None) -> dict[str, float]:
    if not isinstance(payload, dict):
        return {}
    flattened: dict[str, float] = {}
    for key, value in payload.items():
        if not isinstance(key, str):
            continue
        parsed = _safe_float(value)
        if parsed is None:
            continue
        flattened[key] = parsed
    return flattened


def _read_generation_payloads(
    generation_log_path: Path,
    *,
    warnings: list[str],
) -> list[dict[str, Any]]:
    payloads: list[dict[str, Any]] = []
    try:
        lines = generation_log_path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        warnings.append(f"Failed to read generation log: {generation_log_path} ({exc})")
        return payloads
    for line_number, raw_line in enumerate(lines, start=1):
        stripped = raw_line.strip()
        if not stripped:
            continue
        try:
            payload = json.loads(stripped)
        except json.JSONDecodeError as exc:
            warnings.append(
                f"Skipped malformed generation log line: {generation_log_path}:{line_number} ({exc})"
            )
            continue
        if not isinstance(payload, dict):
            warnings.append(
                f"Skipped non-object generation log line: {generation_log_path}:{line_number}"
            )
            continue
        payloads.append(payload)
    return payloads


def _load_archive_summary(
    problem_root: Path,
    *,
    warnings: list[str],
) -> dict[str, Any]:
    path = problem_root / "archive_summary.json"
    if not path.is_file():
        return {}
    payload = _load_json_mapping(path, warnings=warnings, label="archive summary")
    if payload is None:
        return {}
    return payload


def _load_archive_space(
    problem_root: Path,
    *,
    warnings: list[str],
) -> dict[str, Any]:
    path = problem_root / "archive_space.json"
    if not path.is_file():
        return {}
    payload = _load_json_mapping(path, warnings=warnings, label="archive space")
    if payload is None:
        return {}
    return payload


def _string_list(value: Any) -> tuple[str, ...]:
    if not isinstance(value, list):
        return ()
    items = [str(item) for item in value if isinstance(item, str) and item]
    return tuple(items)


def _descriptor_profile_from_summary_payload(summary_payload: dict[str, Any]) -> str | None:
    direct_value = summary_payload.get("descriptor_profile")
    if isinstance(direct_value, str) and direct_value:
        return direct_value
    backend_details = summary_payload.get("backend_details")
    if not isinstance(backend_details, dict):
        return None
    qd_config = backend_details.get("qd_config")
    if isinstance(qd_config, dict):
        profile = qd_config.get("descriptor_profile") or qd_config.get("qd_descriptor_profile")
        if isinstance(profile, str) and profile:
            return profile
    profile = backend_details.get("descriptor_profile")
    if isinstance(profile, str) and profile:
        return profile
    return None


def _descriptor_axes_from_summary_payload(summary_payload: dict[str, Any]) -> tuple[str, ...]:
    direct_axes = _string_list(summary_payload.get("descriptor_axes"))
    if direct_axes:
        return direct_axes
    backend_details = summary_payload.get("backend_details")
    if not isinstance(backend_details, dict):
        return ()
    qd_config = backend_details.get("qd_config")
    if isinstance(qd_config, dict):
        config_axes = _string_list(qd_config.get("descriptor_axes"))
        if config_axes:
            return config_axes
    return _string_list(backend_details.get("descriptor_axes"))


def _load_final_elite_ids(
    problem_root: Path,
    *,
    warnings: list[str],
) -> frozenset[str]:
    path = problem_root / "archive_cells.csv"
    if not path.is_file():
        return frozenset()
    elite_ids: set[str] = set()
    try:
        with path.open("r", encoding="utf-8", newline="") as handle:
            reader = csv.DictReader(handle)
            for row in reader:
                candidate_id = row.get("candidate_id")
                if candidate_id:
                    elite_ids.add(candidate_id)
    except OSError as exc:
        warnings.append(f"Failed to read archive cells: {path} ({exc})")
    return frozenset(elite_ids)


def _index_qd_events(
    problem_root: Path,
    *,
    warnings: list[str],
) -> dict[str, list[QdEventRecord]]:
    indexed: dict[str, list[QdEventRecord]] = {}
    for event_path in sorted(problem_root.rglob("qd_archive_event.json")):
        payload = _load_json_mapping(event_path, warnings=warnings, label="qd archive event")
        if payload is None:
            continue
        candidate_id = str(payload.get("candidate_id") or "").strip()
        if not candidate_id:
            warnings.append(f"Skipped qd archive event without candidate_id: {event_path}")
            continue
        indexed.setdefault(candidate_id, []).append(
            QdEventRecord(
                candidate_id=candidate_id,
                generation=_safe_int(payload.get("generation")),
                path=event_path,
                payload=payload,
            )
        )
    return indexed


def _select_qd_event(
    candidate_id: str,
    generation: int | None,
    indexed_events: dict[str, list[QdEventRecord]],
) -> QdEventRecord | None:
    matches = indexed_events.get(candidate_id, [])
    if not matches:
        return None
    if generation is not None:
        for record in matches:
            if record.generation == generation:
                return record
    return matches[0]


def _resolve_report_path(problem_root: Path, report_path: str | None) -> Path | None:
    if not report_path:
        return None
    raw_path = Path(report_path).expanduser()
    if raw_path.is_absolute():
        return raw_path
    return (problem_root / raw_path).resolve()


def _resolve_candidate_dir(
    *,
    problem_root: Path,
    report_path: str | None,
    qd_event: QdEventRecord | None,
) -> Path | None:
    if qd_event is not None:
        return qd_event.path.parent
    resolved_report = _resolve_report_path(problem_root, report_path)
    if resolved_report is None:
        return None
    if resolved_report.is_dir():
        return resolved_report
    if resolved_report.parent.is_dir():
        return resolved_report.parent
    return None


def _resolve_metrics_json_path(candidate_dir: Path | None) -> Path | None:
    if candidate_dir is None:
        return None
    direct = candidate_dir / "code_synthesis_report.metrics.json"
    if direct.is_file():
        return direct
    matches = sorted(candidate_dir.glob("*.metrics.json"))
    if matches:
        return matches[0]
    return None


def _resolve_code_file_path(
    candidate_dir: Path | None,
    qd_event: QdEventRecord | None,
) -> Path | None:
    if qd_event is not None:
        current_cell_elite = qd_event.payload.get("current_cell_elite")
        if isinstance(current_cell_elite, dict):
            raw_path = current_cell_elite.get("code_file_path")
            if isinstance(raw_path, str) and raw_path:
                code_path = Path(raw_path).expanduser()
                if code_path.is_file():
                    return code_path
    if candidate_dir is None:
        return None
    direct = candidate_dir / "code.sv"
    if direct.is_file():
        return direct
    sv_matches = sorted(candidate_dir.glob("*.sv"))
    if sv_matches:
        return sv_matches[0]
    return None


def _resolve_vcd_file_path(candidate_dir: Path | None) -> Path | None:
    if candidate_dir is None:
        return None
    matches = sorted(candidate_dir.glob("*.vcd"))
    if matches:
        return matches[0]
    return None


def _build_problem_context(
    *,
    backend: str,
    backend_root: Path,
    summary_path: Path,
    summary_payload: dict[str, Any],
    warnings: list[str],
) -> ProblemRunContext | None:
    benchmark = summary_payload.get("benchmark_name") or summary_path.parent.parent.name
    problem = summary_payload.get("problem_name") or summary_path.parent.name
    if not isinstance(benchmark, str) or not isinstance(problem, str):
        warnings.append(f"Skipped summary without benchmark/problem identity: {summary_path}")
        return None

    canonical_identity = _canonical_summary_identity(summary_path)
    if canonical_identity != (benchmark, problem):
        warnings.append(
            "Skipped non-canonical problem summary outside selected problem directory: "
            f"{summary_path}"
        )
        return None

    summary_ref = _flatten_numeric_mapping(summary_payload.get("ref_ppa_metric"))
    if not summary_ref:
        summary_ref = _load_reference_ppa_metrics_from_bench(benchmark, problem)
    objective_metrics = objective_metrics_for_reference(summary_ref)
    archive_summary = _load_archive_summary(summary_path.parent, warnings=warnings)
    archive_space = _load_archive_space(summary_path.parent, warnings=warnings)
    search_mode = None
    backend_details = summary_payload.get("backend_details")
    if isinstance(backend_details, dict):
        search_mode_raw = backend_details.get("search_mode")
        if isinstance(search_mode_raw, str):
            search_mode = search_mode_raw
    descriptor_profile = _descriptor_profile_from_summary_payload(summary_payload)
    if descriptor_profile is None:
        archive_summary_profile = archive_summary.get("descriptor_profile")
        if isinstance(archive_summary_profile, str) and archive_summary_profile:
            descriptor_profile = archive_summary_profile
    if descriptor_profile is None:
        archive_space_profile = archive_space.get("descriptor_profile")
        if isinstance(archive_space_profile, str) and archive_space_profile:
            descriptor_profile = archive_space_profile
    descriptor_axes = _descriptor_axes_from_summary_payload(summary_payload)
    if not descriptor_axes:
        descriptor_axes = _string_list(archive_summary.get("descriptor_axes"))
    if not descriptor_axes:
        descriptor_axes = _string_list(archive_summary.get("axes"))
    if not descriptor_axes:
        descriptor_axes = _string_list(archive_space.get("descriptor_axes"))
    if not descriptor_axes:
        descriptor_axes = _string_list(archive_space.get("axes"))

    return ProblemRunContext(
        backend=backend,
        benchmark=benchmark,
        problem=problem,
        backend_root=backend_root,
        problem_root=summary_path.parent,
        summary_path=summary_path,
        ref_ppa_metrics=summary_ref,
        objective_metrics=objective_metrics,
        objective_labels=objective_labels_for_metrics(objective_metrics),
        circuit_type=circuit_type_for_reference(summary_ref),
        generation_views_available=(summary_path.parent / "generation_log.jsonl").is_file(),
        search_mode=search_mode,
        archive_type=(
            archive_summary.get("archive_type")
            if isinstance(archive_summary.get("archive_type"), str)
            else (
                archive_space.get("archive_type")
                if isinstance(archive_space.get("archive_type"), str)
                else None
            )
        ),
        descriptor_profile=descriptor_profile,
        descriptor_axes=descriptor_axes,
        final_elite_ids=_load_final_elite_ids(summary_path.parent, warnings=warnings),
    )


def _base_record_from_candidate_detail(
    *,
    context: ProblemRunContext,
    detail: dict[str, Any],
    generation: int | None,
    source: str,
    indexed_events: dict[str, list[QdEventRecord]],
) -> SuccessfulCandidateRecord | None:
    candidate_id = str(detail.get("id") or "").strip()
    if not candidate_id:
        return None
    ppa_metrics = _flatten_numeric_mapping(detail.get("ppa_metrics"))
    improvements = compute_candidate_improvements(
        ppa_metrics,
        context.ref_ppa_metrics,
        context.objective_metrics,
    )
    if improvements is None:
        return None
    qd_event = _select_qd_event(candidate_id, generation, indexed_events)
    candidate_dir = _resolve_candidate_dir(
        problem_root=context.problem_root,
        report_path=detail.get("ppa_metrics", {}).get("report_path")
        if isinstance(detail.get("ppa_metrics"), dict)
        else None,
        qd_event=qd_event,
    )
    record = SuccessfulCandidateRecord(
        backend=context.backend,
        benchmark=context.benchmark,
        problem=context.problem,
        problem_root=context.problem_root,
        circuit_type=context.circuit_type,
        search_mode=context.search_mode,
        archive_type=context.archive_type,
        descriptor_profile=context.descriptor_profile,
        generation=generation,
        generation_views_available=context.generation_views_available,
        source=source,
        candidate_id=candidate_id,
        strategy=str(detail.get("strategy") or ""),
        score=_safe_float(detail.get("score")),
        report_path=(
            str(detail.get("ppa_metrics", {}).get("report_path"))
            if isinstance(detail.get("ppa_metrics"), dict)
            and detail.get("ppa_metrics", {}).get("report_path") is not None
            else None
        ),
        ppa_metrics=ppa_metrics,
        ref_ppa_metrics=dict(context.ref_ppa_metrics),
        objective_metrics=context.objective_metrics,
        objective_labels=context.objective_labels,
        candidate_dir=candidate_dir,
        is_final_elite=candidate_id in context.final_elite_ids,
        normalized_gains=dict(zip(context.objective_labels, improvements.values(), strict=True)),
    )
    record.metrics_json_path = _resolve_metrics_json_path(record.candidate_dir)
    record.code_file_path = _resolve_code_file_path(record.candidate_dir, qd_event)
    record.vcd_file_path = _resolve_vcd_file_path(record.candidate_dir)
    record.qd_event_path = qd_event.path if qd_event is not None else None
    record.has_metrics_json = record.metrics_json_path is not None and record.metrics_json_path.is_file()
    record.has_code_file = record.code_file_path is not None and record.code_file_path.is_file()
    record.has_vcd_file = record.vcd_file_path is not None and record.vcd_file_path.is_file()
    if qd_event is not None:
        _apply_qd_event(record, qd_event)
    _apply_metrics_json(record)
    _fill_missing_gain_components(record)
    _refresh_flattened_metrics(record)
    return record


def _apply_qd_event(record: SuccessfulCandidateRecord, event: QdEventRecord) -> None:
    record.has_qd_event = True
    record.archive_type = (
        str(event.payload.get("archive_type"))
        if event.payload.get("archive_type") is not None
        else record.archive_type
    )
    record.quality_score = _safe_float(event.payload.get("quality_score"))
    record.origin_pool = (
        str(event.payload.get("origin_pool"))
        if event.payload.get("origin_pool") is not None
        else None
    )
    record.generated_mode = (
        str(event.payload.get("generated_mode"))
        if event.payload.get("generated_mode") is not None
        else None
    )
    record.decision = (
        str(event.payload.get("decision"))
        if event.payload.get("decision") is not None
        else None
    )
    record.inserted = bool(event.payload.get("inserted", False))
    record.replaced = bool(event.payload.get("replaced", False))
    record.cell_id = (
        str(event.payload.get("cell_id"))
        if event.payload.get("cell_id") is not None
        else None
    )
    structural_metrics = _flatten_numeric_mapping(event.payload.get("structural_metrics"))
    rtl_metrics = _flatten_numeric_mapping(event.payload.get("rtl_metrics"))
    graph_metrics = _flatten_numeric_mapping(event.payload.get("graph_metrics"))
    dynamic_metrics = _flatten_numeric_mapping(event.payload.get("dynamic_metrics"))
    physical_metrics = _flatten_numeric_mapping(event.payload.get("physical_metrics"))
    descriptor_values = _flatten_numeric_mapping(event.payload.get("descriptor_values"))
    score_components = _flatten_numeric_mapping(event.payload.get("score_components"))

    if structural_metrics:
        record.structural_metrics.update(structural_metrics)
        record.has_structural_metrics = True
    if rtl_metrics:
        record.rtl_metrics.update(rtl_metrics)
        record.has_rtl_metrics = True
    if graph_metrics:
        record.graph_metrics.update(graph_metrics)
        record.has_graph_metrics = True
    if dynamic_metrics:
        record.dynamic_metrics.update(dynamic_metrics)
        record.has_dynamic_metrics = True
    if physical_metrics:
        record.physical_metrics.update(physical_metrics)
        record.has_physical_metrics = True
    if descriptor_values:
        record.descriptor_values.update(descriptor_values)
    if score_components:
        record.score_components.update(score_components)


def _apply_metrics_json(record: SuccessfulCandidateRecord) -> None:
    path = record.metrics_json_path
    if path is None or not path.is_file():
        return
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        record.warning_messages.append("metrics_json_malformed")
        return
    if not isinstance(payload, dict):
        record.warning_messages.append("metrics_json_not_object")
        return

    file_ppa = _flatten_numeric_mapping(payload.get("ppa_metrics"))
    if file_ppa:
        for metric_name, metric_value in file_ppa.items():
            record.ppa_metrics.setdefault(metric_name, metric_value)

    structural_metrics = _flatten_numeric_mapping(payload.get("structural_metrics"))
    if structural_metrics:
        for metric_name, metric_value in structural_metrics.items():
            record.structural_metrics.setdefault(metric_name, metric_value)
        record.has_structural_metrics = True

    physical_metrics = _flatten_numeric_mapping(payload.get("physical_metrics"))
    if physical_metrics:
        for metric_name, metric_value in physical_metrics.items():
            record.physical_metrics.setdefault(metric_name, metric_value)
        record.has_physical_metrics = True


def _fill_missing_gain_components(record: SuccessfulCandidateRecord) -> None:
    if not record.normalized_gains:
        improvements = compute_candidate_improvements(
            record.ppa_metrics,
            record.ref_ppa_metrics,
            record.objective_metrics,
        )
        if improvements is None:
            return
        record.normalized_gains = dict(zip(record.objective_labels, improvements.values(), strict=True))
    for label, value in record.normalized_gains.items():
        record.score_components.setdefault(label, value)


def _combined_raw_metrics(record: SuccessfulCandidateRecord) -> dict[str, float]:
    combined: dict[str, float] = {}
    combined.update(record.structural_metrics)
    combined.update(record.rtl_metrics)
    combined.update(record.graph_metrics)
    combined.update(record.dynamic_metrics)
    combined.update(record.physical_metrics)
    combined.update(record.score_components)
    return combined


def _refresh_flattened_metrics(record: SuccessfulCandidateRecord) -> None:
    raw_metrics = _combined_raw_metrics(record)
    computed_descriptors = _compute_descriptor_values(raw_metrics)
    for metric_name, metric_value in computed_descriptors.items():
        record.descriptor_values.setdefault(metric_name, metric_value)
    flattened: dict[str, float] = {}
    flattened.update(record.structural_metrics)
    flattened.update(record.rtl_metrics)
    flattened.update(record.graph_metrics)
    flattened.update(record.dynamic_metrics)
    flattened.update(record.physical_metrics)
    flattened.update(record.descriptor_values)
    flattened.update(record.score_components)
    record.flattened_metrics = flattened
    record.has_structural_metrics = bool(record.structural_metrics)
    record.has_rtl_metrics = bool(record.rtl_metrics)
    record.has_graph_metrics = bool(record.graph_metrics)
    record.has_dynamic_metrics = bool(record.dynamic_metrics)
    record.has_physical_metrics = bool(record.physical_metrics)


def _compute_descriptor_values(metrics: dict[str, float]) -> dict[str, float]:
    if not metrics:
        return {}
    registry = descriptor_registry()
    axes = [axis for axis in registry if axis in metrics]
    if not axes:
        return {}
    return extract_descriptor_values(metrics, axes)


def _collect_generation_candidates(
    context: ProblemRunContext,
    *,
    indexed_events: dict[str, list[QdEventRecord]],
    warnings: list[str],
) -> list[SuccessfulCandidateRecord]:
    generation_log_path = context.problem_root / "generation_log.jsonl"
    if not generation_log_path.is_file():
        return []
    payloads = _read_generation_payloads(generation_log_path, warnings=warnings)
    records: list[SuccessfulCandidateRecord] = []
    for payload in payloads:
        generation = _safe_int(payload.get("generation"))
        details = payload.get("population_ppa_details")
        if not isinstance(details, list):
            continue
        for detail in details:
            if not isinstance(detail, dict):
                continue
            record = _base_record_from_candidate_detail(
                context=context,
                detail=detail,
                generation=generation,
                source="generation_log",
                indexed_events=indexed_events,
            )
            if record is None:
                continue
            records.append(record)
    return records


def _collect_summary_fallback_candidates(
    context: ProblemRunContext,
    *,
    summary_payload: dict[str, Any],
    indexed_events: dict[str, list[QdEventRecord]],
    warnings: list[str],
) -> list[SuccessfulCandidateRecord]:
    details = summary_payload.get("final_population_ppa_details")
    if not isinstance(details, list):
        return []
    warnings.append(
        "Generation log missing or unusable; using final_population_ppa_details only for "
        f"{context.backend}/{context.benchmark}/{context.problem}."
    )
    records: list[SuccessfulCandidateRecord] = []
    for detail in details:
        if not isinstance(detail, dict):
            continue
        record = _base_record_from_candidate_detail(
            context=context,
            detail=detail,
            generation=None,
            source="final_population",
            indexed_events=indexed_events,
        )
        if record is None:
            continue
        records.append(record)
    return records


def load_successful_candidate_catalog(
    *,
    backend_roots: dict[str, Path],
    allowed_problems: set[tuple[str, str]],
) -> SuccessfulCandidateCatalog:
    """Load successful individuals from completed run directories.

    The generation log is treated as the canonical source when present. If a
    run only has end-state summary details, the loader falls back to those
    rows and marks generation views as unavailable in the emitted context.
    """

    warnings: list[str] = []
    problem_runs: list[ProblemRunContext] = []
    candidates: list[SuccessfulCandidateRecord] = []

    for backend, root in backend_roots.items():
        resolved_root = root.resolve()
        if not resolved_root.is_dir():
            raise ValueError(f"Backend root does not exist: {resolved_root}")
        selected_summary_paths = [
            path
            for path in sorted(resolved_root.rglob("*_summary.json"))
            if _is_problem_summary_path(path)
        ]
        for summary_path in selected_summary_paths:
            summary_payload = _load_json_mapping(
                summary_path,
                warnings=warnings,
                label="problem summary",
            )
            if summary_payload is None:
                continue
            benchmark = summary_payload.get("benchmark_name") or summary_path.parent.parent.name
            problem = summary_payload.get("problem_name") or summary_path.parent.name
            if (benchmark, problem) not in allowed_problems:
                continue
            context = _build_problem_context(
                backend=backend,
                backend_root=resolved_root,
                summary_path=summary_path,
                summary_payload=summary_payload,
                warnings=warnings,
            )
            if context is None:
                continue
            problem_runs.append(context)
            indexed_events = _index_qd_events(context.problem_root, warnings=warnings)
            problem_candidates = _collect_generation_candidates(
                context,
                indexed_events=indexed_events,
                warnings=warnings,
            )
            if not problem_candidates:
                problem_candidates = _collect_summary_fallback_candidates(
                    context,
                    summary_payload=summary_payload,
                    indexed_events=indexed_events,
                    warnings=warnings,
                )
            candidates.extend(problem_candidates)
    return SuccessfulCandidateCatalog(
        problem_runs=tuple(problem_runs),
        candidates=tuple(candidates),
        warnings=tuple(warnings),
    )


def recover_candidate_features(
    candidates: list[SuccessfulCandidateRecord] | tuple[SuccessfulCandidateRecord, ...],
    *,
    requested_features: list[str] | tuple[str, ...] | None = None,
) -> list[str]:
    """Best-effort recovery for missing feature families on successful candidates."""

    warnings: list[str] = []
    recover_rtl, recover_graph, recover_dynamic, recover_source_aligned = _recovery_plan(
        requested_features
    )
    rtl_evaluator = RTLDescriptorEvaluator()
    graph_evaluator = GraphDescriptorEvaluator() if recover_graph else None
    simulation_evaluator = SimulationDescriptorEvaluator() if recover_dynamic else None
    source_aligned_evaluator = (
        SourceAlignedRTLDescriptorEvaluator() if recover_source_aligned else None
    )

    for record in candidates:
        _recover_features_for_record(
            record,
            recover_rtl=recover_rtl,
            recover_graph=recover_graph,
            recover_dynamic=recover_dynamic,
            recover_source_aligned=recover_source_aligned,
            rtl_evaluator=rtl_evaluator,
            graph_evaluator=graph_evaluator,
            simulation_evaluator=simulation_evaluator,
            source_aligned_evaluator=source_aligned_evaluator,
        )

    for record in candidates:
        for warning in record.warning_messages:
            warnings.append(
                f"{record.backend}/{record.benchmark}/{record.problem}/{record.candidate_id}: {warning}"
            )
    return warnings


def _recovery_plan(
    requested_features: list[str] | tuple[str, ...] | None,
) -> tuple[bool, bool, bool, bool]:
    if requested_features is None:
        return True, True, True, False
    registry = descriptor_registry()
    recover_rtl = False
    recover_graph = False
    recover_dynamic = False
    recover_source_aligned = False
    for feature in requested_features:
        definition = registry.get(feature)
        if definition is None:
            continue
        if definition.source_tool in {"rtl_text", "rtl_estimator", "yosys_ast"}:
            recover_rtl = True
            continue
        if definition.source_tool == "yosys_graph":
            recover_graph = True
            continue
        if definition.source_tool == "icarus_vcd":
            recover_dynamic = True
            continue
        if definition.source_tool == "source_aligned_rtl":
            recover_source_aligned = True
    return recover_rtl, recover_graph, recover_dynamic, recover_source_aligned


def _recover_features_for_record(
    record: SuccessfulCandidateRecord,
    *,
    recover_rtl: bool,
    recover_graph: bool,
    recover_dynamic: bool,
    recover_source_aligned: bool,
    rtl_evaluator: RTLDescriptorEvaluator,
    graph_evaluator: GraphDescriptorEvaluator | None,
    simulation_evaluator: SimulationDescriptorEvaluator | None,
    source_aligned_evaluator: SourceAlignedRTLDescriptorEvaluator | None,
) -> None:
    if record.has_code_file:
        if recover_rtl:
            _recover_rtl_metrics(record, evaluator=rtl_evaluator)
        if recover_graph and graph_evaluator is not None:
            _recover_graph_metrics(record, evaluator=graph_evaluator)
        if recover_source_aligned and source_aligned_evaluator is not None:
            _recover_source_aligned_metrics(record, evaluator=source_aligned_evaluator)
    if recover_dynamic and simulation_evaluator is not None:
        _recover_dynamic_metrics(record, evaluator=simulation_evaluator)
    _fill_missing_gain_components(record)
    _refresh_flattened_metrics(record)


def _recover_rtl_metrics(
    record: SuccessfulCandidateRecord,
    *,
    evaluator: RTLDescriptorEvaluator,
) -> None:
    """Recover RTL-derived metrics without reaching into evaluator internals."""

    if record.code_file_path is None or not record.code_file_path.is_file():
        return
    try:
        code_text = record.code_file_path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        record.warning_messages.append("code_file_unreadable")
        return

    metrics = evaluator.extract_metrics(
        code_text=code_text,
        code_file_path=record.code_file_path,
        mapped_cell_count=record.structural_metrics.get("total_cells"),
    )
    for metric_name, metric_value in metrics.items():
        record.rtl_metrics.setdefault(metric_name, metric_value)


def _recover_graph_metrics(
    record: SuccessfulCandidateRecord,
    *,
    evaluator: GraphDescriptorEvaluator,
) -> None:
    if record.code_file_path is None or not record.code_file_path.is_file():
        return
    metrics = evaluator.extract_metrics(
        code_file_path=record.code_file_path,
        top_module_name=None,
    )
    if not metrics:
        return
    for metric_name, metric_value in metrics.items():
        record.graph_metrics.setdefault(metric_name, metric_value)


def _recover_source_aligned_metrics(
    record: SuccessfulCandidateRecord,
    *,
    evaluator: SourceAlignedRTLDescriptorEvaluator,
) -> None:
    if record.code_file_path is None or not record.code_file_path.is_file():
        return
    metrics = evaluator.extract_metrics(
        code_file_path=record.code_file_path,
        top_module_name=None,
    )
    for metric_name, metric_value in metrics.items():
        record.graph_metrics.setdefault(metric_name, metric_value)


def _recover_dynamic_metrics(
    record: SuccessfulCandidateRecord,
    *,
    evaluator: SimulationDescriptorEvaluator,
) -> None:
    if record.vcd_file_path is None or not record.vcd_file_path.is_file():
        return
    metrics = evaluator.extract_metrics(
        vcd_file_path=record.vcd_file_path,
        top_module_name="tb",
    )
    if not metrics:
        return
    for metric_name, metric_value in metrics.items():
        record.dynamic_metrics.setdefault(metric_name, metric_value)


def candidate_to_row(record: SuccessfulCandidateRecord) -> dict[str, Any]:
    """Flatten one candidate record into a CSV/report row."""

    row: dict[str, Any] = {
        "backend": record.backend,
        "benchmark": record.benchmark,
        "problem": record.problem,
        "circuit_type": record.circuit_type,
        "search_mode": record.search_mode,
        "archive_type": record.archive_type,
        "descriptor_profile": record.descriptor_profile,
        "generation": record.generation,
        "generation_views_available": record.generation_views_available,
        "source": record.source,
        "candidate_id": record.candidate_id,
        "strategy": record.strategy,
        "score": record.score,
        "quality_score": record.quality_score,
        "color_score": record.color_score,
        "origin_pool": record.origin_pool,
        "generated_mode": record.generated_mode,
        "decision": record.decision,
        "inserted": record.inserted,
        "replaced": record.replaced,
        "cell_id": record.cell_id,
        "is_final_elite": record.is_final_elite,
        "area": record.ppa_metrics.get("area"),
        "power": record.ppa_metrics.get("power"),
        "eff_clk_period": record.ppa_metrics.get("eff_clk_period"),
        "tns": record.ppa_metrics.get("tns"),
        "wns": record.ppa_metrics.get("wns"),
        "g_A": record.score_components.get("g_A"),
        "g_P": record.score_components.get("g_P"),
        "g_T": record.score_components.get("g_T"),
        "report_path": record.report_path,
        "candidate_dir": str(record.candidate_dir) if record.candidate_dir is not None else "",
        "code_file_path": str(record.code_file_path) if record.code_file_path is not None else "",
        "metrics_json_path": (
            str(record.metrics_json_path) if record.metrics_json_path is not None else ""
        ),
        "qd_event_path": str(record.qd_event_path) if record.qd_event_path is not None else "",
        "vcd_file_path": str(record.vcd_file_path) if record.vcd_file_path is not None else "",
        "has_qd_event": record.has_qd_event,
        "has_metrics_json": record.has_metrics_json,
        "has_code_file": record.has_code_file,
        "has_vcd_file": record.has_vcd_file,
        "has_structural_metrics": record.has_structural_metrics,
        "has_rtl_metrics": record.has_rtl_metrics,
        "has_graph_metrics": record.has_graph_metrics,
        "has_dynamic_metrics": record.has_dynamic_metrics,
        "has_physical_metrics": record.has_physical_metrics,
        "warning_messages": ";".join(sorted(set(record.warning_messages))),
    }
    for metric_name, metric_value in sorted(record.flattened_metrics.items()):
        if metric_name in row:
            continue
        row[metric_name] = metric_value
    return row


def catalog_rows(
    catalog: SuccessfulCandidateCatalog,
    *,
    only_qd_candidates: bool = False,
) -> list[dict[str, Any]]:
    """Convert a catalog into row dictionaries for reports and CSV export."""

    rows: list[dict[str, Any]] = []
    for record in catalog.candidates:
        if only_qd_candidates and not record.has_qd_event:
            continue
        rows.append(candidate_to_row(record))
    return rows


def export_fieldnames(rows: list[dict[str, Any]]) -> list[str]:
    """Build a stable CSV header from the exported candidate rows."""

    extra_columns = sorted(
        {
            key
            for row in rows
            for key in row
            if key not in BASE_EXPORT_COLUMNS
        }
    )
    return BASE_EXPORT_COLUMNS + extra_columns
