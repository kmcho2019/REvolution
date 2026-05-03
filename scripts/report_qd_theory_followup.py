#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from dataclasses import asdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

THEORY_PROFILE = "theory_grounded_full_20d"
DEFAULT_CONTROL_PROFILES = (
    "implemented_structural_fixed_5d",
    "size_control_3d",
)
DEFAULT_RECOMMENDED_AXIS_LIMIT = 8
DEFAULT_MIN_SELECTED_AXES = 4
DEFAULT_MIN_THEORY_PROBLEM_COUNT = 4


@dataclass(frozen=True)
class TheoryRunRow:
    profile: str
    archive_type: str
    benchmark: str
    problem: str
    coverage: float
    qd_score: float | None
    best_quality: float | None
    occupied_cells: int | None
    num_cells: int | None
    observation_count: int
    collapsed_axes: tuple[str, ...]
    axis_health: tuple[dict[str, Any], ...]
    root: str


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Summarize bounded theory-grounded follow-up runs and emit a compact "
            "theory-profile recommendation from descriptor-health artifacts."
        ),
    )
    parser.add_argument("--run_root", required=True, help="Run root to scan recursively.")
    parser.add_argument(
        "--output_dir",
        default=None,
        help="Output directory for markdown/json report files. Defaults to <run_root>/theory_followup_report.",
    )
    parser.add_argument(
        "--max_recommended_axes",
        type=int,
        default=DEFAULT_RECOMMENDED_AXIS_LIMIT,
        help="Maximum number of axes to keep in the compact theory recommendation.",
    )
    parser.add_argument(
        "--theory_profile",
        default=THEORY_PROFILE,
        help="Profile name to treat as the theory-grounded profile.",
    )
    parser.add_argument(
        "--control_profile",
        dest="control_profiles",
        action="append",
        default=[],
        help="Control profile name to compare against the theory profile. May be repeated.",
    )
    parser.add_argument(
        "--min_selected_axes",
        type=int,
        default=DEFAULT_MIN_SELECTED_AXES,
        help="Minimum selected compact axes required before the profile is considered ready.",
    )
    parser.add_argument(
        "--min_theory_problem_count",
        type=int,
        default=DEFAULT_MIN_THEORY_PROBLEM_COUNT,
        help="Minimum theory-profile problem count required before the profile is considered ready.",
    )
    return parser


def _safe_float(value: Any) -> float | None:
    if isinstance(value, (int, float)):
        return float(value)
    return None


def _safe_int(value: Any) -> int | None:
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value
    return None


def _safe_axis_health(value: Any) -> tuple[dict[str, Any], ...]:
    if not isinstance(value, list):
        return ()
    items: list[dict[str, Any]] = []
    for item in value:
        if isinstance(item, dict):
            items.append(item)
    return tuple(items)


def _load_json_dict(path: Path) -> dict[str, Any] | None:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None

    if not isinstance(payload, dict):
        return None
    return payload


def load_followup_rows(run_root: str | Path) -> list[TheoryRunRow]:
    root = Path(run_root).resolve()
    rows: list[TheoryRunRow] = []
    for summary_path in sorted(root.rglob("archive_summary.json")):
        health_path = summary_path.parent / "descriptor_health.json"
        if not health_path.is_file():
            continue

        archive_summary = _load_json_dict(summary_path)
        descriptor_health = _load_json_dict(health_path)
        if archive_summary is None or descriptor_health is None:
            continue

        profile = archive_summary.get("descriptor_profile")
        archive_type = archive_summary.get("archive_type")
        if not isinstance(profile, str) or not isinstance(archive_type, str):
            continue

        benchmark = summary_path.parent.parent.name
        problem = summary_path.parent.name
        collapsed_axes_raw = descriptor_health.get("collapsed_axes", [])
        collapsed_axes = tuple(
            axis for axis in collapsed_axes_raw if isinstance(axis, str)
        )
        rows.append(
            TheoryRunRow(
                profile=profile,
                archive_type=archive_type,
                benchmark=benchmark,
                problem=problem,
                coverage=float(archive_summary.get("coverage", 0.0) or 0.0),
                qd_score=_safe_float(archive_summary.get("qd_score")),
                best_quality=_safe_float(archive_summary.get("best_quality")),
                occupied_cells=_safe_int(archive_summary.get("occupied_cells")),
                num_cells=_safe_int(archive_summary.get("num_cells")),
                observation_count=int(descriptor_health.get("observation_count", 0) or 0),
                collapsed_axes=collapsed_axes,
                axis_health=_safe_axis_health(descriptor_health.get("axis_health")),
                root=str(summary_path.parent),
            )
        )
    return rows


def summarize_rows(
    rows: list[TheoryRunRow],
    *,
    theory_profile: str = THEORY_PROFILE,
    control_profiles: tuple[str, ...] = DEFAULT_CONTROL_PROFILES,
    max_recommended_axes: int = DEFAULT_RECOMMENDED_AXIS_LIMIT,
    min_selected_axes: int = DEFAULT_MIN_SELECTED_AXES,
    min_theory_problem_count: int = DEFAULT_MIN_THEORY_PROBLEM_COUNT,
) -> dict[str, Any]:
    profile_summary: dict[str, dict[str, Any]] = {}
    for row in rows:
        profile_rows = profile_summary.setdefault(
            row.profile,
            {
                "profile": row.profile,
                "archive_type": row.archive_type,
                "problem_count": 0,
                "benchmarks": set(),
                "coverage_values": [],
                "qd_scores": [],
                "best_qualities": [],
                "observation_counts": [],
                "collapsed_axes": set(),
            },
        )
        profile_rows["problem_count"] += 1
        profile_rows["benchmarks"].add(row.benchmark)
        profile_rows["coverage_values"].append(row.coverage)
        if row.qd_score is not None:
            profile_rows["qd_scores"].append(row.qd_score)
        if row.best_quality is not None:
            profile_rows["best_qualities"].append(row.best_quality)
        profile_rows["observation_counts"].append(float(row.observation_count))
        profile_rows["collapsed_axes"].update(row.collapsed_axes)

    rendered_profiles: list[dict[str, Any]] = []
    for payload in profile_summary.values():
        rendered_profiles.append(
            {
                "profile": payload["profile"],
                "archive_type": payload["archive_type"],
                "problem_count": payload["problem_count"],
                "benchmark_count": len(payload["benchmarks"]),
                "mean_coverage": _mean(payload["coverage_values"]),
                "mean_qd_score": _mean(payload["qd_scores"]),
                "mean_best_quality": _mean(payload["best_qualities"]),
                "mean_observation_count": _mean(payload["observation_counts"]),
                "collapsed_axes": sorted(payload["collapsed_axes"]),
            }
        )

    rendered_profiles.sort(key=lambda item: item["profile"])
    theory_axis_summary = summarize_theory_axes(rows, theory_profile=theory_profile)
    profile_lookup = {profile["profile"]: profile for profile in rendered_profiles}
    pairwise_deltas = summarize_profile_deltas(
        profile_lookup,
        theory_profile=theory_profile,
        control_profiles=control_profiles,
    )
    recommendation = recommend_theory_profile(
        theory_axis_summary,
        theory_profile=theory_profile,
        max_axes=max_recommended_axes,
    )
    return {
        "profiles": rendered_profiles,
        "theory_axis_summary": theory_axis_summary,
        "pairwise_deltas": pairwise_deltas,
        "recommended_theory_profile": recommendation,
        "recommendation_decision": build_recommendation_decision(
            profile_lookup,
            theory_axis_summary=theory_axis_summary,
            pairwise_deltas=pairwise_deltas,
            recommendation=recommendation,
            theory_profile=theory_profile,
            min_selected_axes=min_selected_axes,
            min_theory_problem_count=min_theory_problem_count,
        ),
    }


def summarize_theory_axes(
    rows: list[TheoryRunRow],
    *,
    theory_profile: str = THEORY_PROFILE,
) -> list[dict[str, Any]]:
    theory_rows = [row for row in rows if row.profile == theory_profile]
    axis_values: dict[str, dict[str, Any]] = {}
    for row in theory_rows:
        for axis_payload in row.axis_health:
            axis = axis_payload.get("axis")
            observation_stats = axis_payload.get("observation_stats")
            if not isinstance(axis, str) or not isinstance(observation_stats, dict):
                continue
            unique_count = int(observation_stats.get("unique_count", 0) or 0)
            nonzero_fraction = float(observation_stats.get("nonzero_fraction", 0.0) or 0.0)
            stddev = float(observation_stats.get("stddev", 0.0) or 0.0)
            payload = axis_values.setdefault(
                axis,
                {
                    "axis": axis,
                    "cases": 0,
                    "noncollapsed_cases": 0,
                    "unique_counts": [],
                    "nonzero_fractions": [],
                    "stddevs": [],
                },
            )
            payload["cases"] += 1
            if unique_count > 1 and stddev > 0.0:
                payload["noncollapsed_cases"] += 1
            payload["unique_counts"].append(float(unique_count))
            payload["nonzero_fractions"].append(nonzero_fraction)
            payload["stddevs"].append(stddev)

    rendered_axes: list[dict[str, Any]] = []
    for payload in axis_values.values():
        cases = int(payload["cases"])
        noncollapsed_cases = int(payload["noncollapsed_cases"])
        rendered_axes.append(
            {
                "axis": payload["axis"],
                "cases": cases,
                "noncollapsed_cases": noncollapsed_cases,
                "noncollapsed_fraction": (
                    float(noncollapsed_cases) / float(cases) if cases else 0.0
                ),
                "mean_unique_count": _mean(payload["unique_counts"]),
                "mean_nonzero_fraction": _mean(payload["nonzero_fractions"]),
                "mean_stddev": _mean(payload["stddevs"]),
            }
        )

    rendered_axes.sort(
        key=lambda item: (
            item["noncollapsed_fraction"],
            item["mean_unique_count"] or 0.0,
            item["mean_stddev"] or 0.0,
        ),
        reverse=True,
    )
    return rendered_axes


def recommend_theory_profile(
    axis_summary: list[dict[str, Any]],
    *,
    theory_profile: str = THEORY_PROFILE,
    max_axes: int = DEFAULT_RECOMMENDED_AXIS_LIMIT,
) -> dict[str, Any]:
    if max_axes < 1:
        max_axes = 1

    eligible_axes = [
        axis
        for axis in axis_summary
        if (axis.get("noncollapsed_fraction") or 0.0) >= 0.5
        and (axis.get("mean_nonzero_fraction") or 0.0) >= 0.1
    ]
    selected_axes = [axis["axis"] for axis in eligible_axes[:max_axes]]
    return {
        "profile_name": f"theory_grounded_compact_candidate_{len(selected_axes)}d",
        "source_profile": theory_profile,
        "selected_axes": selected_axes,
    }


def summarize_profile_deltas(
    profile_lookup: dict[str, dict[str, Any]],
    *,
    theory_profile: str,
    control_profiles: tuple[str, ...],
) -> list[dict[str, Any]]:
    theory_metrics = profile_lookup.get(theory_profile)
    if theory_metrics is None:
        return []

    rendered: list[dict[str, Any]] = []
    for control_profile in control_profiles:
        control_metrics = profile_lookup.get(control_profile)
        if control_metrics is None:
            continue
        rendered.append(
            {
                "theory_profile": theory_profile,
                "control_profile": control_profile,
                "mean_coverage_delta": _delta_metric(
                    theory_metrics.get("mean_coverage"),
                    control_metrics.get("mean_coverage"),
                ),
                "mean_qd_score_delta": _delta_metric(
                    theory_metrics.get("mean_qd_score"),
                    control_metrics.get("mean_qd_score"),
                ),
                "mean_best_quality_delta": _delta_metric(
                    theory_metrics.get("mean_best_quality"),
                    control_metrics.get("mean_best_quality"),
                ),
                "mean_observation_count_delta": _delta_metric(
                    theory_metrics.get("mean_observation_count"),
                    control_metrics.get("mean_observation_count"),
                ),
            }
        )
    return rendered


def build_recommendation_decision(
    profile_lookup: dict[str, dict[str, Any]],
    *,
    theory_axis_summary: list[dict[str, Any]],
    pairwise_deltas: list[dict[str, Any]],
    recommendation: dict[str, Any],
    theory_profile: str,
    min_selected_axes: int,
    min_theory_problem_count: int,
) -> dict[str, Any]:
    theory_metrics = profile_lookup.get(theory_profile)
    selected_axes = recommendation.get("selected_axes", [])
    if not isinstance(selected_axes, list):
        selected_axes = []

    reasons: list[str] = []
    if theory_metrics is None:
        reasons.append("theory profile was not present in the scanned run root")
        return {
            "status": "needs_more_data",
            "reason_count": len(reasons),
            "reasons": reasons,
            "selected_axis_count": 0,
            "required_min_selected_axes": min_selected_axes,
            "theory_problem_count": 0,
            "required_min_theory_problem_count": min_theory_problem_count,
            "noncollapsed_axis_count": 0,
        }

    theory_problem_count = int(theory_metrics.get("problem_count", 0) or 0)
    if theory_problem_count < min_theory_problem_count:
        reasons.append(
            "theory profile has not yet been run on enough problems for a compact recommendation"
        )
    if len(selected_axes) < max(1, min_selected_axes):
        reasons.append("compact theory candidate does not yet have enough stable axes")

    noncollapsed_axes = [
        axis["axis"]
        for axis in theory_axis_summary
        if (axis.get("noncollapsed_fraction") or 0.0) >= 0.5
    ]
    if not noncollapsed_axes:
        reasons.append("no theory axes remained non-collapsed across the scanned runs")

    if not pairwise_deltas:
        reasons.append("no configured control profiles were available for comparison")
    elif not any(_delta_is_positive_enough(item) for item in pairwise_deltas):
        reasons.append(
            "theory profile did not beat a configured control on mean coverage or mean QD score"
        )

    status = "candidate_ready" if not reasons else "needs_more_data"
    return {
        "status": status,
        "reason_count": len(reasons),
        "reasons": reasons,
        "selected_axis_count": len(selected_axes),
        "required_min_selected_axes": max(1, min_selected_axes),
        "theory_problem_count": theory_problem_count,
        "required_min_theory_problem_count": min_theory_problem_count,
        "noncollapsed_axis_count": len(noncollapsed_axes),
        "noncollapsed_axes": noncollapsed_axes,
    }


def _mean(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def _delta_metric(left: Any, right: Any) -> float | None:
    if not isinstance(left, (int, float)):
        return None
    if not isinstance(right, (int, float)):
        return None
    return float(left) - float(right)


def _delta_is_positive_enough(delta_row: dict[str, Any]) -> bool:
    coverage_delta = delta_row.get("mean_coverage_delta")
    qd_score_delta = delta_row.get("mean_qd_score_delta")
    if isinstance(coverage_delta, (int, float)) and float(coverage_delta) > 0.0:
        return True
    if isinstance(qd_score_delta, (int, float)) and float(qd_score_delta) > 0.0:
        return True
    return False


def render_markdown(rows: list[TheoryRunRow], summary: dict[str, Any]) -> str:
    lines = [
        "# Theory QD Follow-Up Report",
        "",
        f"- scanned_runs: `{len(rows)}`",
        "",
        "## Profile Summary",
        "",
        "| Profile | Problems | Mean Coverage | Mean QD Score | Mean Best Quality | Collapsed Axes |",
        "| --- | ---: | ---: | ---: | ---: | --- |",
    ]

    for profile in summary["profiles"]:
        lines.append(
            f"| {profile['profile']} | {profile['problem_count']} | "
            f"{_format_metric(profile['mean_coverage'])} | "
            f"{_format_metric(profile['mean_qd_score'])} | "
            f"{_format_metric(profile['mean_best_quality'])} | "
            f"{', '.join(profile['collapsed_axes']) or '-'} |"
        )

    lines.extend(
        [
            "",
            "## Theory Axis Health",
            "",
            "| Axis | Noncollapsed Fraction | Mean Unique Count | Mean Nonzero Fraction | Mean Stddev |",
            "| --- | ---: | ---: | ---: | ---: |",
        ]
    )

    for axis in summary["theory_axis_summary"]:
        lines.append(
            f"| {axis['axis']} | "
            f"{_format_metric(axis['noncollapsed_fraction'])} | "
            f"{_format_metric(axis['mean_unique_count'])} | "
            f"{_format_metric(axis['mean_nonzero_fraction'])} | "
            f"{_format_metric(axis['mean_stddev'])} |"
        )

    lines.extend(
        [
            "",
            "## Theory Vs Control",
            "",
            "| Control Profile | Coverage Delta | QD Score Delta | Best Quality Delta | Observation Delta |",
            "| --- | ---: | ---: | ---: | ---: |",
        ]
    )

    for item in summary["pairwise_deltas"]:
        lines.append(
            f"| {item['control_profile']} | "
            f"{_format_metric(item['mean_coverage_delta'])} | "
            f"{_format_metric(item['mean_qd_score_delta'])} | "
            f"{_format_metric(item['mean_best_quality_delta'])} | "
            f"{_format_metric(item['mean_observation_count_delta'])} |"
        )

    recommendation = summary["recommended_theory_profile"]
    decision = summary["recommendation_decision"]
    lines.extend(
        [
            "",
            "## Compact Candidate",
            "",
            f"- profile_name: `{recommendation['profile_name']}`",
            f"- selected_axes: `{', '.join(recommendation['selected_axes']) or 'none'}`",
            f"- status: `{decision['status']}`",
            f"- selected_axis_count: `{decision['selected_axis_count']}`",
            f"- theory_problem_count: `{decision['theory_problem_count']}`",
            f"- noncollapsed_axis_count: `{decision['noncollapsed_axis_count']}`",
            "",
        ]
    )
    if decision["reasons"]:
        lines.append("### Decision Notes")
        lines.append("")
        for reason in decision["reasons"]:
            lines.append(f"- {reason}")
        lines.append("")
    return "\n".join(lines)


def _format_metric(value: Any) -> str:
    if not isinstance(value, (int, float)):
        return "-"
    return f"{float(value):.6f}"


def write_report_files(
    rows: list[TheoryRunRow],
    summary: dict[str, Any],
    *,
    output_dir: Path,
) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    report_payload = {
        "rows": [asdict(row) for row in rows],
        "summary": summary,
    }
    (output_dir / "theory_followup_summary.json").write_text(
        json.dumps(report_payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (output_dir / "recommended_theory_profile.json").write_text(
        json.dumps(summary["recommended_theory_profile"], indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (output_dir / "theory_promotion_decision.json").write_text(
        json.dumps(summary["recommendation_decision"], indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (output_dir / "theory_followup_report.md").write_text(
        render_markdown(rows, summary),
        encoding="utf-8",
    )


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    rows = load_followup_rows(args.run_root)
    summary = summarize_rows(
        rows,
        theory_profile=args.theory_profile,
        control_profiles=tuple(args.control_profiles or DEFAULT_CONTROL_PROFILES),
        max_recommended_axes=args.max_recommended_axes,
        min_selected_axes=args.min_selected_axes,
        min_theory_problem_count=args.min_theory_problem_count,
    )
    output_dir = (
        Path(args.output_dir)
        if args.output_dir is not None
        else Path(args.run_root) / "theory_followup_report"
    )
    write_report_files(rows, summary, output_dir=output_dir)
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
