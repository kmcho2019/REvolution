#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import math
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.pareto_analysis import collect_backend_problem_pareto  # noqa: E402


IGNORED_SUMMARY_FILENAMES = {"archive_summary.json"}


@dataclass(frozen=True)
class ProblemMetrics:
    backend: str
    benchmark: str
    problem: str
    functionality_rate: float
    synthesis_rate: float
    best_score: float | None
    runtime_seconds: float
    qd_archive_type: str | None
    qd_coverage: float | None
    qd_score: float | None
    qd_best_quality: float | None
    pareto_hypervolume: float
    pareto_point_count: int
    pareto_candidate_count: int
    pareto_reference_beating_count: int


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _safe_rate(value: Any) -> float:
    parsed = _safe_float(value)
    if parsed is None:
        return 0.0
    return max(0.0, parsed)


def _mean(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def _format_percent(value: float | None) -> str:
    if value is None:
        return "N/A"
    return f"{value * 100.0:.1f}%"


def _format_float(value: float | None, digits: int = 4) -> str:
    if value is None:
        return "N/A"
    return f"{value:.{digits}f}"


def _load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    selected = payload.get("selected_problems") or []
    problems: list[tuple[str, str]] = []
    for entry in selected:
        if not isinstance(entry, dict):
            continue
        benchmark = entry.get("benchmark")
        problem = entry.get("problem")
        if isinstance(benchmark, str) and isinstance(problem, str):
            problems.append((benchmark, problem))
    if not problems:
        raise ValueError(f"No selected problems found in subset config '{config_path}'.")
    return problems


def _load_qd_archive_summary(summary_path: Path) -> dict[str, Any]:
    archive_summary_path = summary_path.parent / "archive_summary.json"
    if not archive_summary_path.is_file():
        return {}
    try:
        payload = json.loads(archive_summary_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}
    if not isinstance(payload, dict):
        return {}
    return payload


def _is_problem_summary_path(summary_path: Path) -> bool:
    return (
        summary_path.name.endswith("_summary.json")
        and summary_path.name not in IGNORED_SUMMARY_FILENAMES
    )


def _load_problem_metrics(backend: str, root: Path) -> dict[tuple[str, str], ProblemMetrics]:
    rows: dict[tuple[str, str], ProblemMetrics] = {}
    pareto_metrics_by_problem = collect_backend_problem_pareto(backend, root)
    for summary_path in sorted(root.rglob("*_summary.json")):
        if not _is_problem_summary_path(summary_path):
            continue

        payload = json.loads(summary_path.read_text(encoding="utf-8"))
        benchmark = payload.get("benchmark_name") or summary_path.parent.parent.name
        problem = payload.get("problem_name") or summary_path.parent.name
        if not isinstance(benchmark, str) or not isinstance(problem, str):
            continue

        rates = {}
        for rate_key in ("success_rates", "accumulated_success_rates"):
            value = payload.get(rate_key)
            if isinstance(value, dict):
                rates = value
                break
        qd_archive_summary = _load_qd_archive_summary(summary_path)
        pareto_metrics = pareto_metrics_by_problem.get((benchmark, problem))
        rows[(benchmark, problem)] = ProblemMetrics(
            backend=backend,
            benchmark=benchmark,
            problem=problem,
            functionality_rate=_safe_rate(
                rates.get("total_functionality", rates.get("functionality", 0.0))
            ),
            synthesis_rate=_safe_rate(
                rates.get("total_synthesis_ppa", rates.get("synthesis_ppa", rates.get("synthesis", 0.0)))
            ),
            best_score=_safe_float(payload.get("best_score")),
            runtime_seconds=float(payload.get("total_runtime_seconds", 0.0)),
            qd_archive_type=(
                qd_archive_summary.get("archive_type")
                if isinstance(qd_archive_summary.get("archive_type"), str)
                else None
            ),
            qd_coverage=_safe_float(qd_archive_summary.get("coverage")),
            qd_score=_safe_float(qd_archive_summary.get("qd_score")),
            qd_best_quality=_safe_float(qd_archive_summary.get("best_quality")),
            pareto_hypervolume=pareto_metrics.hypervolume if pareto_metrics is not None else 0.0,
            pareto_point_count=pareto_metrics.pareto_point_count if pareto_metrics is not None else 0,
            pareto_candidate_count=pareto_metrics.candidate_count if pareto_metrics is not None else 0,
            pareto_reference_beating_count=(
                pareto_metrics.reference_beating_count if pareto_metrics is not None else 0
            ),
        )
    return rows


def _placeholder_metrics(backend: str, benchmark: str, problem: str) -> ProblemMetrics:
    return ProblemMetrics(
        backend=backend,
        benchmark=benchmark,
        problem=problem,
        functionality_rate=0.0,
        synthesis_rate=0.0,
        best_score=None,
        runtime_seconds=0.0,
        qd_archive_type=None,
        qd_coverage=None,
        qd_score=None,
        qd_best_quality=None,
        pareto_hypervolume=0.0,
        pareto_point_count=0,
        pareto_candidate_count=0,
        pareto_reference_beating_count=0,
    )


def _aggregate_backend(
    backend: str,
    problems: list[tuple[str, str]],
    metrics_by_problem: dict[tuple[str, str], ProblemMetrics],
) -> dict[str, Any]:
    ordered = [
        metrics_by_problem.get((benchmark, problem), _placeholder_metrics(backend, benchmark, problem))
        for benchmark, problem in problems
    ]
    solved_scores = [
        row.best_score for row in ordered if row.synthesis_rate > 0.0 and row.best_score is not None
    ]
    qd_coverages = [row.qd_coverage for row in ordered if row.qd_coverage is not None]
    qd_scores = [row.qd_score for row in ordered if row.qd_score is not None]
    qd_best_qualities = [row.qd_best_quality for row in ordered if row.qd_best_quality is not None]
    qd_archive_types = sorted({row.qd_archive_type for row in ordered if row.qd_archive_type})
    return {
        "backend": backend,
        "problem_count": len(ordered),
        "functionality_mean": _mean([row.functionality_rate for row in ordered]),
        "synthesis_mean": _mean([row.synthesis_rate for row in ordered]),
        "solved_problem_count": sum(1 for row in ordered if row.synthesis_rate > 0.0),
        "best_score_mean": _mean([value for value in solved_scores if value is not None]),
        "runtime_seconds_mean": _mean([row.runtime_seconds for row in ordered]),
        "qd_archive_types": qd_archive_types,
        "qd_coverage_mean": _mean([value for value in qd_coverages if value is not None]),
        "qd_score_mean": _mean([value for value in qd_scores if value is not None]),
        "qd_best_quality_mean": _mean([value for value in qd_best_qualities if value is not None]),
        "pareto_problem_count": sum(1 for row in ordered if row.pareto_candidate_count > 0),
        "pareto_hypervolume_mean": _mean([row.pareto_hypervolume for row in ordered]),
        "pareto_point_count_mean": _mean([float(row.pareto_point_count) for row in ordered]),
        "pareto_reference_beating_mean": _mean(
            [float(row.pareto_reference_beating_count) for row in ordered]
        ),
    }


def _recommend_backend(
    aggregates: list[dict[str, Any]],
    *,
    qd_only: bool = False,
    archive_health: bool = False,
    multi_objective: bool = False,
) -> str | None:
    candidates = [
        agg for agg in aggregates if (not qd_only or agg["qd_archive_types"])
    ]
    if not candidates:
        return None

    def sort_key(agg: dict[str, Any]) -> tuple[float, float, float]:
        if multi_objective:
            return (
                agg.get("pareto_hypervolume_mean") or -1.0,
                agg.get("pareto_point_count_mean") or -1.0,
                agg.get("pareto_reference_beating_mean") or -1.0,
            )
        if archive_health:
            return (
                agg.get("qd_coverage_mean") or -1.0,
                agg.get("qd_score_mean") or -1.0,
                agg.get("synthesis_mean") or -1.0,
            )
        return (
            agg.get("synthesis_mean") or -1.0,
            agg.get("best_score_mean") or -1.0,
            agg.get("functionality_mean") or -1.0,
        )

    return max(candidates, key=sort_key)["backend"]


def _best_backend_by_problem(
    problems: list[tuple[str, str]],
    backend_rows: dict[str, dict[tuple[str, str], ProblemMetrics]],
) -> list[dict[str, str | float | None]]:
    rows: list[dict[str, str | float | None]] = []
    for benchmark, problem in problems:
        candidates: list[ProblemMetrics] = []
        for metrics in backend_rows.values():
            row = metrics.get((benchmark, problem))
            if row is not None:
                candidates.append(row)
        if not candidates:
            continue
        winner = max(
            candidates,
            key=lambda row: (
                row.synthesis_rate,
                row.best_score if row.best_score is not None else -1e18,
                row.functionality_rate,
            ),
        )
        rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "winner_backend": winner.backend,
                "winner_synthesis_rate": winner.synthesis_rate,
                "winner_best_score": winner.best_score,
            }
        )
    return rows


def _render_markdown(
    subset_name: str,
    problems: list[tuple[str, str]],
    aggregates: list[dict[str, Any]],
    recommendations: dict[str, str | None],
    per_problem_winners: list[dict[str, str | float | None]],
) -> str:
    lines = [
        "# Hard Iteration Subset Analysis",
        "",
        f"- Subset: `{subset_name}`",
        f"- Problems: `{len(problems)}`",
        "- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.",
        "",
        "## Summary Table",
        "",
        "| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |",
        "|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|",
    ]
    for agg in aggregates:
        lines.append(
            f"| `{agg['backend']}` | {_format_percent(agg['functionality_mean'])} | "
            f"{_format_percent(agg['synthesis_mean'])} | {agg['solved_problem_count']}/{agg['problem_count']} | "
            f"{_format_float(agg['best_score_mean'])} | {_format_float(agg['runtime_seconds_mean'], 2)} | "
            f"{_format_percent(agg['qd_coverage_mean'])} | {_format_float(agg['qd_score_mean'])} | "
            f"{_format_float(agg['pareto_hypervolume_mean'])} | {_format_float(agg['pareto_point_count_mean'], 2)} |"
        )
    lines.extend(
        [
            "",
            "## Recommendations",
            "",
            f"- Overall: `{recommendations.get('overall') or 'N/A'}`",
            f"- Score-oriented QD: `{recommendations.get('score_qd') or 'N/A'}`",
            f"- Archive-health QD: `{recommendations.get('archive_qd') or 'N/A'}`",
            f"- Multi-objective: `{recommendations.get('multi_objective') or 'N/A'}`",
            "",
            "## Per-Problem Winners",
            "",
            "| Benchmark | Problem | Winner | Synthesis Rate | Best Score |",
            "|:---|:---|:---|:---|:---|",
        ]
    )
    for row in per_problem_winners:
        winner_synthesis_rate = _safe_float(row.get("winner_synthesis_rate"))
        winner_best_score = _safe_float(row.get("winner_best_score"))
        lines.append(
            f"| {row['benchmark']} | {row['problem']} | `{row['winner_backend']}` | "
            f"{_format_percent(winner_synthesis_rate)} | {_format_float(winner_best_score)} |"
        )
    lines.append("")
    return "\n".join(lines)


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate a hard-subset classic-vs-QD analysis report."
    )
    parser.add_argument(
        "--subset-config",
        type=Path,
        required=True,
        help="Frozen hard subset config path.",
    )
    parser.add_argument(
        "--backend_run",
        action="append",
        required=True,
        help="Backend mapping in the form <name>=<experiment_path>. Repeat for multiple backends.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        required=True,
        help="Directory to write report.md and summary.json.",
    )
    return parser.parse_args()


def parse_backend_runs(mappings: list[str]) -> list[tuple[str, Path]]:
    backend_runs: list[tuple[str, Path]] = []
    for mapping in mappings:
        if "=" not in mapping:
            raise ValueError(
                f"Invalid --backend_run '{mapping}'. Expected format <backend>=<path>."
            )
        backend, path_str = mapping.split("=", 1)
        root = Path(path_str).expanduser().resolve()
        if not root.is_dir():
            raise FileNotFoundError(f"Experiment path not found: {root}")
        backend_runs.append((backend, root))
    return backend_runs


def generate_hard_iteration_analysis(
    *,
    subset_config: Path,
    backend_runs: list[tuple[str, Path]],
    output_dir: Path,
) -> dict[str, Any]:
    problems = _load_subset_problems(subset_config)
    subset_payload = yaml.safe_load(subset_config.read_text(encoding="utf-8"))
    subset_name = str(subset_payload.get("subset_name", "hard_iteration_subset"))

    backend_rows: dict[str, dict[tuple[str, str], ProblemMetrics]] = {}
    aggregates: list[dict[str, Any]] = []
    for backend, root in backend_runs:
        rows = _load_problem_metrics(backend, root)
        backend_rows[backend] = rows
        aggregates.append(_aggregate_backend(backend, problems, rows))

    recommendations = {
        "overall": _recommend_backend(aggregates),
        "score_qd": _recommend_backend(aggregates, qd_only=True),
        "archive_qd": _recommend_backend(aggregates, qd_only=True, archive_health=True),
        "multi_objective": _recommend_backend(aggregates, multi_objective=True),
    }
    per_problem_winners = _best_backend_by_problem(problems, backend_rows)

    output_dir.mkdir(parents=True, exist_ok=True)
    report_path = output_dir / "report.md"
    summary_path = output_dir / "summary.json"

    report = _render_markdown(
        subset_name=subset_name,
        problems=problems,
        aggregates=aggregates,
        recommendations=recommendations,
        per_problem_winners=per_problem_winners,
    )
    payload = {
        "subset_name": subset_name,
        "problem_count": len(problems),
        "aggregates": aggregates,
        "recommendations": recommendations,
        "per_problem_winners": per_problem_winners,
    }
    report_path.write_text(report, encoding="utf-8")
    summary_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    return {
        "report_path": str(report_path),
        "summary_path": str(summary_path),
        "payload": payload,
    }


def main() -> int:
    args = _parse_args()
    result = generate_hard_iteration_analysis(
        subset_config=args.subset_config.resolve(),
        backend_runs=parse_backend_runs(args.backend_run),
        output_dir=args.output_dir.resolve(),
    )
    print(f"Wrote {result['report_path']}")
    print(f"Wrote {result['summary_path']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
