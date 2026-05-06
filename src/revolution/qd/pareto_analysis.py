from __future__ import annotations

from dataclasses import dataclass
import json
import math
from pathlib import Path
from typing import Any


EPSILON = 1e-12
IGNORED_SUMMARY_FILENAMES = {
    "archive_summary.json",
    "global_pareto_summary.json",
}


@dataclass(frozen=True)
class ParetoCandidate:
    candidate_id: str
    generation: int | None
    strategy: str
    source: str
    report_path: str | None
    ppa_metrics: dict[str, float]
    improvements: dict[str, float]


@dataclass(frozen=True)
class ProblemParetoMetrics:
    benchmark: str
    problem: str
    problem_dir: str
    circuit_type: str
    objective_metrics: tuple[str, ...]
    objective_labels: tuple[str, ...]
    reference_metrics: dict[str, float]
    candidate_count: int
    pareto_point_count: int
    hypervolume: float
    reference_beating_count: int
    best_improvements: dict[str, float]
    candidates: tuple[ParetoCandidate, ...]
    pareto_candidates: tuple[ParetoCandidate, ...]


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


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError(f"Expected JSON object in {path}")
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


def objective_metrics_for_reference(ref_metrics: dict[str, float]) -> tuple[str, ...]:
    eff_clk_period = _safe_float(ref_metrics.get("eff_clk_period"))
    if eff_clk_period is not None and abs(eff_clk_period) > EPSILON:
        return ("area", "power", "eff_clk_period")
    return ("area", "power")


def objective_labels_for_metrics(metric_names: tuple[str, ...]) -> tuple[str, ...]:
    label_map = {
        "area": "g_A",
        "power": "g_P",
        "eff_clk_period": "g_T",
    }
    return tuple(label_map[name] for name in metric_names)


def circuit_type_for_reference(ref_metrics: dict[str, float]) -> str:
    return (
        "sequential"
        if "eff_clk_period" in objective_metrics_for_reference(ref_metrics)
        else "combinational"
    )


def normalized_improvement(
    ref_value: float | None,
    candidate_value: float | None,
) -> float | None:
    if ref_value is None or candidate_value is None:
        return None
    denom = max(abs(float(ref_value)), EPSILON)
    return (float(ref_value) - float(candidate_value)) / denom


def compute_candidate_improvements(
    ppa_metrics: dict[str, Any],
    ref_metrics: dict[str, float],
    metric_names: tuple[str, ...],
) -> dict[str, float] | None:
    improvements: dict[str, float] = {}
    for metric_name in metric_names:
        candidate_value = _safe_float(ppa_metrics.get(metric_name))
        ref_value = _safe_float(ref_metrics.get(metric_name))
        gain = normalized_improvement(ref_value, candidate_value)
        if gain is None:
            return None
        improvements[metric_name] = gain
    return improvements


def improvement_tuple(
    candidate: ParetoCandidate,
    metric_names: tuple[str, ...],
) -> tuple[float, ...]:
    return tuple(candidate.improvements[metric_name] for metric_name in metric_names)


def dominates(
    left: tuple[float, ...],
    right: tuple[float, ...],
    *,
    eps: float = EPSILON,
) -> bool:
    return all(left_value >= right_value - eps for left_value, right_value in zip(left, right, strict=True)) and any(
        left_value > right_value + eps for left_value, right_value in zip(left, right, strict=True)
    )


def pareto_front(points: list[tuple[float, ...]]) -> list[int]:
    nondominated: list[int] = []
    for index, point in enumerate(points):
        dominated = False
        for other_index, other in enumerate(points):
            if index == other_index:
                continue
            if dominates(other, point):
                dominated = True
                break
        if not dominated:
            nondominated.append(index)
    return nondominated


def hypervolume(points: list[tuple[float, ...]]) -> float:
    clipped = [
        tuple(max(0.0, float(value)) for value in point)
        for point in points
    ]
    clipped = [
        point
        for point in clipped
        if any(value > EPSILON for value in point)
    ]
    if not clipped:
        return 0.0
    return _hypervolume_recursive(_dedupe_points(clipped), len(clipped[0]))


def _dedupe_points(points: list[tuple[float, ...]]) -> list[tuple[float, ...]]:
    deduped: list[tuple[float, ...]] = []
    seen: set[tuple[float, ...]] = set()
    for point in points:
        key = tuple(round(value, 12) for value in point)
        if key in seen:
            continue
        seen.add(key)
        deduped.append(point)
    return deduped


def _hypervolume_recursive(points: list[tuple[float, ...]], dimensions: int) -> float:
    if not points:
        return 0.0
    front = [points[index] for index in pareto_front(points)]
    if dimensions == 1:
        return max(point[0] for point in front)
    layers = sorted(
        {
            point[dimensions - 1]
            for point in front
            if point[dimensions - 1] > EPSILON
        }
    )
    volume = 0.0
    previous = 0.0
    for layer in layers:
        slice_points = [
            point[: dimensions - 1]
            for point in front
            if point[dimensions - 1] >= layer - EPSILON
        ]
        volume += (layer - previous) * _hypervolume_recursive(slice_points, dimensions - 1)
        previous = layer
    return volume


def analyze_problem_pareto(
    problem_root: Path,
    *,
    benchmark: str | None = None,
    problem: str | None = None,
) -> ProblemParetoMetrics:
    summary_path = problem_root / f"{problem_root.name}_summary.json"
    if not summary_path.is_file():
        candidates = sorted(problem_root.glob("*_summary.json"))
        candidates = [path for path in candidates if _is_problem_summary_path(path)]
        if not candidates:
            raise FileNotFoundError(f"Could not find problem summary under {problem_root}")
        summary_path = candidates[0]
    summary_payload = _load_json(summary_path)
    benchmark_name = (
        benchmark
        or summary_payload.get("benchmark_name")
        or problem_root.parent.name
    )
    problem_name = (
        problem
        or summary_payload.get("problem_name")
        or problem_root.name
    )
    if not isinstance(benchmark_name, str) or not isinstance(problem_name, str):
        raise ValueError(f"Invalid benchmark/problem names in {summary_path}")

    ref_metrics = summary_payload.get("ref_ppa_metric")
    if not isinstance(ref_metrics, dict):
        ref_metrics = {}
    if not ref_metrics:
        ref_metrics = _load_reference_ppa_metrics_from_bench(benchmark_name, problem_name)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    objective_labels = objective_labels_for_metrics(objective_metrics)
    deduped_candidates = _load_pareto_candidates(
        problem_root=problem_root,
        summary_payload=summary_payload,
        ref_metrics=ref_metrics,
        objective_metrics=objective_metrics,
    )
    candidate_points = [
        improvement_tuple(candidate, objective_metrics)
        for candidate in deduped_candidates
    ]
    front_indexes = pareto_front(candidate_points)
    pareto_candidates = tuple(deduped_candidates[index] for index in front_indexes)
    pareto_points = [candidate_points[index] for index in front_indexes]
    reference_beating_count = sum(
        1
        for point in candidate_points
        if all(value >= -EPSILON for value in point) and any(value > EPSILON for value in point)
    )
    best_improvements = {
        metric_name: max(
            (candidate.improvements[metric_name] for candidate in pareto_candidates),
            default=0.0,
        )
        for metric_name in objective_metrics
    }
    return ProblemParetoMetrics(
        benchmark=benchmark_name,
        problem=problem_name,
        problem_dir=str(problem_root),
        circuit_type=circuit_type_for_reference(ref_metrics),
        objective_metrics=objective_metrics,
        objective_labels=objective_labels,
        reference_metrics={
            metric_name: float(ref_metrics[metric_name])
            for metric_name in objective_metrics
            if _safe_float(ref_metrics.get(metric_name)) is not None
        },
        candidate_count=len(deduped_candidates),
        pareto_point_count=len(pareto_candidates),
        hypervolume=hypervolume(pareto_points),
        reference_beating_count=reference_beating_count,
        best_improvements=best_improvements,
        candidates=tuple(deduped_candidates),
        pareto_candidates=pareto_candidates,
    )


def collect_backend_problem_pareto(
    backend: str,
    root: Path,
    *,
    allowed_problems: set[tuple[str, str]] | None = None,
) -> dict[tuple[str, str], ProblemParetoMetrics]:
    if not root.is_dir():
        raise FileNotFoundError(f"Experiment path not found: {root}")
    rows: dict[tuple[str, str], ProblemParetoMetrics] = {}
    for summary_path in sorted(root.rglob("*_summary.json")):
        if not _is_problem_summary_path(summary_path):
            continue
        try:
            payload = _load_json(summary_path)
        except (OSError, ValueError, json.JSONDecodeError):
            continue
        benchmark = payload.get("benchmark_name") or summary_path.parent.parent.name
        problem = payload.get("problem_name") or summary_path.parent.name
        if not isinstance(benchmark, str) or not isinstance(problem, str):
            continue
        key = (benchmark, problem)
        if allowed_problems is not None and key not in allowed_problems:
            continue
        rows[key] = analyze_problem_pareto(
            summary_path.parent,
            benchmark=benchmark,
            problem=problem,
        )
    return rows


def _load_pareto_candidates(
    *,
    problem_root: Path,
    summary_payload: dict[str, Any],
    ref_metrics: dict[str, float],
    objective_metrics: tuple[str, ...],
) -> list[ParetoCandidate]:
    deduped: dict[tuple[str, str], ParetoCandidate] = {}
    generation_log_path = problem_root / "generation_log.jsonl"
    if generation_log_path.is_file():
        for line in generation_log_path.read_text(encoding="utf-8").splitlines():
            if not line.strip():
                continue
            try:
                payload = json.loads(line)
            except json.JSONDecodeError:
                continue
            if not isinstance(payload, dict):
                continue
            generation = _safe_int(payload.get("generation"))
            details = payload.get("population_ppa_details")
            if not isinstance(details, list):
                continue
            for index, detail in enumerate(details):
                candidate = _candidate_from_payload(
                    detail=detail,
                    ref_metrics=ref_metrics,
                    objective_metrics=objective_metrics,
                    generation=generation,
                    fallback_id=f"{problem_root.name}_g{generation if generation is not None else 'x'}_{index}",
                    source="generation_log",
                )
                if candidate is None:
                    continue
                _insert_deduped_candidate(deduped, candidate, objective_metrics)

    if not deduped:
        final_details = summary_payload.get("final_population_ppa_details")
        if isinstance(final_details, list):
            for index, detail in enumerate(final_details):
                candidate = _candidate_from_payload(
                    detail=detail,
                    ref_metrics=ref_metrics,
                    objective_metrics=objective_metrics,
                    generation=None,
                    fallback_id=f"{problem_root.name}_final_{index}",
                    source="summary_final_population",
                )
                if candidate is None:
                    continue
                _insert_deduped_candidate(deduped, candidate, objective_metrics)

    return sorted(
        deduped.values(),
        key=lambda item: (
            item.generation if item.generation is not None else 10**9,
            item.candidate_id,
        ),
    )


def _candidate_from_payload(
    *,
    detail: Any,
    ref_metrics: dict[str, float],
    objective_metrics: tuple[str, ...],
    generation: int | None,
    fallback_id: str,
    source: str,
) -> ParetoCandidate | None:
    if not isinstance(detail, dict):
        return None
    ppa_metrics = detail.get("ppa_metrics")
    if not isinstance(ppa_metrics, dict):
        return None
    improvements = compute_candidate_improvements(ppa_metrics, ref_metrics, objective_metrics)
    if improvements is None:
        return None
    normalized_ppa = {
        metric_name: float(ppa_metrics[metric_name])
        for metric_name in objective_metrics
        if _safe_float(ppa_metrics.get(metric_name)) is not None
    }
    report_path = ppa_metrics.get("report_path")
    return ParetoCandidate(
        candidate_id=str(detail.get("id") or fallback_id),
        generation=generation,
        strategy=str(detail.get("strategy") or ""),
        source=source,
        report_path=str(report_path) if report_path else None,
        ppa_metrics=normalized_ppa,
        improvements=improvements,
    )


def _insert_deduped_candidate(
    deduped: dict[tuple[str, str], ParetoCandidate],
    candidate: ParetoCandidate,
    objective_metrics: tuple[str, ...],
) -> None:
    if candidate.report_path:
        key = ("report_path", candidate.report_path)
    else:
        key = (
            "metrics",
            "|".join(
                f"{metric_name}={candidate.ppa_metrics[metric_name]:.12f}"
                for metric_name in objective_metrics
            ),
        )
    existing = deduped.get(key)
    if existing is None:
        deduped[key] = candidate
        return
    existing_point = improvement_tuple(existing, objective_metrics)
    candidate_point = improvement_tuple(candidate, objective_metrics)
    if dominates(candidate_point, existing_point):
        deduped[key] = candidate
        return
    if dominates(existing_point, candidate_point):
        return
    if sum(max(0.0, value) for value in candidate_point) > sum(
        max(0.0, value) for value in existing_point
    ):
        deduped[key] = candidate
