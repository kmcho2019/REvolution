#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import importlib
import json
import math
import statistics
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


MAX_ACCEPTANCE_WORKERS = 16
QD_SCORE_FLOOR_FRACTION = 0.05


@dataclass
class ProblemMetrics:
    benchmark: str
    problem: str
    problem_root: str | None
    functionality_rate: float | None
    synthesis_rate: float | None
    valid_ppa_sample_count: int
    average_quality_score: float | None
    average_ppa_improvement: float | None
    qd_coverage: float | None
    qd_score: float | None
    occupied_cells: int | None
    total_archive_members: int | None
    best_archive_quality: float | None
    effective_cell_count: int | None
    collapsed_axes: list[str]
    healthy_cell_count: int
    initialized: bool
    initialization_mode: str | None
    errors: list[str]


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_jsonl(path: Path) -> list[dict[str, Any]]:
    if not path.is_file():
        return []
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def _load_yaml(path: Path) -> dict[str, Any]:
    yaml = importlib.import_module("yaml")
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _csv_rows(path: Path) -> list[dict[str, str]]:
    if not path.is_file():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


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


def _mean(values: list[float]) -> float | None:
    return statistics.fmean(values) if values else None


def _expected_problems(path: Path) -> list[dict[str, str]]:
    config = _load_yaml(path)
    return [
        {"benchmark": str(item["benchmark"]), "problem": str(item["problem"])}
        for item in config["selected_problems"]
    ]


def _parse_manifest(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.is_file():
        return values
    for line in path.read_text(encoding="utf-8").splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def _problem_root(run_root: Path, mode: str, benchmark: str, problem: str) -> Path | None:
    direct = run_root / mode / benchmark / problem
    for summary_name in ("archive_summary.json", f"{problem}_summary.json"):
        if (direct / summary_name).is_file():
            return direct
    for summary_name in ("archive_summary.json", f"{problem}_summary.json"):
        for pattern in (f"{benchmark}/{problem}/{summary_name}", f"{problem}/{summary_name}"):
            matches = sorted((run_root / mode).rglob(pattern))
            if matches:
                return matches[-1].parent
    return None


def _problem_summary_path(problem_root: Path, problem: str) -> Path | None:
    direct = problem_root / f"{problem}_summary.json"
    if direct.is_file():
        return direct
    summaries = [
        path
        for path in problem_root.glob("*_summary.json")
        if path.name not in {"archive_summary.json", "global_pareto_summary.json"}
    ]
    return summaries[0] if summaries else None


def _generation_ppa_details(problem_root: Path) -> list[dict[str, Any]]:
    details: list[dict[str, Any]] = []
    for row in _load_jsonl(problem_root / "generation_log.jsonl"):
        row_details = row.get("population_ppa_details", [])
        if not isinstance(row_details, list):
            continue
        details.extend(detail for detail in row_details if isinstance(detail, dict))
    return details


def _detail_average_ppa(
    detail: dict[str, Any],
    ref_metrics: dict[str, Any],
) -> float | None:
    ppa_metrics = detail.get("ppa_metrics", {})
    if not isinstance(ppa_metrics, dict):
        return None
    values: list[float] = []
    for key in ("area", "power", "eff_clk_period"):
        value = _safe_float(ppa_metrics.get(key))
        ref = _safe_float(ref_metrics.get(key))
        if value is None or ref is None or ref == 0.0:
            continue
        values.append((ref - value) / ref)
    return _mean(values)


def _row_average_ppa(row: dict[str, str]) -> float | None:
    values = [
        parsed
        for key in ("g_P", "g_A", "g_T")
        if (parsed := _safe_float(row.get(key))) is not None
    ]
    return _mean(values)


def _effective_cell_count(summary: dict[str, Any], space: dict[str, Any]) -> int | None:
    shape = summary.get("effective_shape", space.get("effective_shape", []))
    if isinstance(shape, list) and shape:
        product = 1
        for value in shape:
            parsed = _safe_int(value)
            if parsed is None:
                return None
            product *= parsed
        return product
    return _safe_int(summary.get("num_cells", space.get("num_cells")))


def _healthy_cells(rows: list[dict[str, str]]) -> int:
    healthy: set[str] = set()
    for row in rows:
        try:
            descriptors = json.loads(row.get("descriptors_json") or "[]")
        except json.JSONDecodeError:
            continue
        if not isinstance(descriptors, list):
            continue
        if descriptors and all(_safe_float(value) is not None for value in descriptors):
            healthy.add(row["cell_id"])
    return len(healthy)


def _collect_problem_metrics(
    *,
    run_root: Path,
    mode: str,
    benchmark: str,
    problem: str,
) -> ProblemMetrics:
    root = _problem_root(run_root, mode, benchmark, problem)
    if root is None:
        return ProblemMetrics(
            benchmark=benchmark,
            problem=problem,
            problem_root=None,
            functionality_rate=None,
            synthesis_rate=None,
            valid_ppa_sample_count=0,
            average_quality_score=None,
            average_ppa_improvement=None,
            qd_coverage=None,
            qd_score=None,
            occupied_cells=None,
            total_archive_members=None,
            best_archive_quality=None,
            effective_cell_count=None,
            collapsed_axes=[],
            healthy_cell_count=0,
            initialized=False,
            initialization_mode=None,
            errors=[f"missing problem root for {mode}"],
        )

    errors: list[str] = []
    summary_path = _problem_summary_path(root, problem)
    summary = _load_json(summary_path) if summary_path is not None else {}
    if summary_path is None:
        errors.append("missing problem summary")
    archive_summary_path = root / "archive_summary.json"
    archive_summary = _load_json(archive_summary_path) if archive_summary_path.is_file() else {}
    archive_space_path = root / "archive_space.json"
    archive_space = _load_json(archive_space_path) if archive_space_path.is_file() else {}
    rows = _csv_rows(root / "archive_cells.csv")

    rates = summary.get("accumulated_success_rates", {})
    if not isinstance(rates, dict):
        rates = {}
    functionality_rate = _safe_float(rates.get("functionality"))
    synthesis_rate = _safe_float(rates.get("synthesis_ppa", rates.get("synthesis")))

    details = _generation_ppa_details(root)
    ref_metrics = summary.get("ref_ppa_metric", {})
    if not isinstance(ref_metrics, dict):
        ref_metrics = {}
    detail_scores = [
        parsed
        for detail in details
        if (parsed := _safe_float(detail.get("score", detail.get("quality_score")))) is not None
    ]
    detail_ppa = [
        parsed
        for detail in details
        if (parsed := _detail_average_ppa(detail, ref_metrics)) is not None
    ]
    row_scores = [
        parsed
        for row in rows
        if (parsed := _safe_float(row.get("quality_score"))) is not None
    ]
    row_ppa = [
        parsed
        for row in rows
        if (parsed := _row_average_ppa(row)) is not None
    ]
    collapsed_axes = archive_summary.get("collapsed_axes", archive_space.get("collapsed_axes", []))
    if not isinstance(collapsed_axes, list):
        collapsed_axes = []
    initialized = bool(
        archive_summary.get(
            "initialized",
            archive_space.get("initialized", archive_space.get("archive_type") == "grid"),
        )
    )
    initialization_mode = archive_summary.get(
        "initialization_mode",
        archive_space.get("initialization_mode"),
    )
    if initialization_mode is not None:
        initialization_mode = str(initialization_mode)
    return ProblemMetrics(
        benchmark=benchmark,
        problem=problem,
        problem_root=str(root),
        functionality_rate=functionality_rate,
        synthesis_rate=synthesis_rate,
        valid_ppa_sample_count=len(details),
        average_quality_score=_mean(detail_scores) if detail_scores else _mean(row_scores),
        average_ppa_improvement=_mean(detail_ppa) if detail_ppa else _mean(row_ppa),
        qd_coverage=_safe_float(archive_summary.get("coverage")),
        qd_score=_safe_float(archive_summary.get("qd_score")),
        occupied_cells=_safe_int(archive_summary.get("occupied_cells")),
        total_archive_members=_safe_int(archive_summary.get("total_archive_members")),
        best_archive_quality=_safe_float(archive_summary.get("best_quality")),
        effective_cell_count=_effective_cell_count(archive_summary, archive_space),
        collapsed_axes=[str(axis) for axis in collapsed_axes],
        healthy_cell_count=_healthy_cells(rows),
        initialized=initialized,
        initialization_mode=initialization_mode,
        errors=errors,
    )


def _paired_gate(
    *,
    name: str,
    on: dict[str, ProblemMetrics],
    off: dict[str, ProblemMetrics],
    field: str,
    floor: float,
) -> dict[str, Any]:
    deltas: list[float] = []
    for key, on_metrics in on.items():
        off_metrics = off.get(key)
        if off_metrics is None:
            continue
        on_value = getattr(on_metrics, field)
        off_value = getattr(off_metrics, field)
        if on_value is None or off_value is None:
            continue
        deltas.append(float(on_value) - float(off_value))
    mean_delta = _mean(deltas)
    standard_error = 0.0
    if len(deltas) > 1:
        standard_error = statistics.stdev(deltas) / math.sqrt(len(deltas))
    threshold = floor if len(deltas) < 4 else max(2.0 * standard_error, floor)
    return {
        "metric": name,
        "field": field,
        "paired_count": len(deltas),
        "mean_delta": mean_delta,
        "standard_error": standard_error,
        "floor": floor,
        "threshold": threshold,
        "passed": bool(mean_delta is not None and mean_delta >= -threshold),
    }


def _qd_score_floor(off: dict[str, ProblemMetrics]) -> float:
    values = [
        abs(float(metrics.qd_score))
        for metrics in off.values()
        if metrics.qd_score is not None
    ]
    return QD_SCORE_FLOOR_FRACTION * (statistics.fmean(values) if values else 0.0)


def _event_kind(event: dict[str, Any]) -> str:
    return str(event.get("event_kind", event.get("event_type", "")))


def _rebin_events(root: Path) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    history = _load_jsonl(root / "archive_history.jsonl")
    checks = [event for event in history if _event_kind(event) == "rebin_check"]
    rebins = [event for event in history if _event_kind(event) == "rebin"]
    return checks, rebins


def _check_explains_no_rebin(check: dict[str, Any]) -> bool:
    status = str(check.get("check_status", "tested"))
    if status != "tested":
        return status.startswith("skipped_")
    threshold = _safe_float(check.get("corrected_p_threshold"))
    if threshold is None:
        return False
    for axis_result in check.get("axis_results", []):
        if not isinstance(axis_result, dict):
            continue
        p_value = _safe_float(axis_result.get("ks_p_value"))
        if p_value is not None and p_value < threshold:
            return False
    return True


def _validate_rebin_events(root: Path) -> list[str]:
    checks, rebins = _rebin_events(root)
    errors: list[str] = []
    if rebins:
        for event in rebins:
            replay_count = _safe_int(event.get("replay_member_count"))
            attempt_count = _safe_int(event.get("replay_attempt_count"))
            if replay_count is None or attempt_count is None or replay_count != attempt_count:
                errors.append("rebin replay_attempt_count does not match replay_member_count")
            if not event.get("trigger_axes"):
                errors.append("rebin event missing trigger_axes")
            if _safe_float(event.get("corrected_p_threshold")) is None:
                errors.append("rebin event missing corrected_p_threshold")
            for key in (
                "old_geometry",
                "new_geometry",
                "retained_member_count",
                "final_active_member_count",
                "displaced_replay_member_count",
                "reactivated_displaced_member_count",
                "cooldown_remaining",
            ):
                if key not in event:
                    errors.append(f"rebin event missing {key}")
    elif checks:
        for check in checks:
            if _check_explains_no_rebin(check):
                continue
            if str(check.get("check_status", "tested")) != "tested":
                errors.append("rebin_check has unknown skipped status")
            elif _safe_float(check.get("corrected_p_threshold")) is None:
                errors.append("rebin_check missing corrected_p_threshold")
            else:
                errors.append("no rebin event despite p-value below corrected threshold")
    return errors


def _adaptive_problem_audits(
    *,
    metrics: dict[str, ProblemMetrics],
) -> list[dict[str, Any]]:
    audits = []
    for key, item in metrics.items():
        checks: list[dict[str, Any]] = []
        rebins: list[dict[str, Any]] = []
        errors = list(item.errors)
        if item.problem_root is not None:
            root = Path(item.problem_root)
            checks, rebins = _rebin_events(root)
            errors.extend(_validate_rebin_events(root))
            if (
                item.initialized
                and not checks
                and item.initialization_mode != "run_finalization_fallback"
            ):
                errors.append("initialized adaptive problem has no rebin_check event")
        audits.append(
            {
                "problem": key,
                "problem_root": item.problem_root,
                "initialized": item.initialized,
                "initialization_mode": item.initialization_mode,
                "rebin_check_count": len(checks),
                "rebin_count": len(rebins),
                "errors": errors,
            }
        )
    return audits


def _localized_candidates(
    *,
    off_metrics: dict[str, ProblemMetrics],
) -> list[tuple[str, ProblemMetrics]]:
    candidates = [
        (key, metrics)
        for key, metrics in off_metrics.items()
        if metrics.initialized
        and metrics.valid_ppa_sample_count > 0
        and (
            bool(metrics.collapsed_axes)
            or (
                metrics.effective_cell_count is not None
                and metrics.effective_cell_count <= 4
            )
        )
    ]
    return sorted(
        candidates,
        key=lambda item: (
            0 if item[1].collapsed_axes else 1,
            item[1].effective_cell_count
            if item[1].effective_cell_count is not None
            else 10**9,
            item[1].occupied_cells if item[1].occupied_cells is not None else 10**9,
            item[0],
        ),
    )[:3]


def _localized_report(
    *,
    off_metrics: dict[str, ProblemMetrics],
    on_metrics: dict[str, ProblemMetrics],
) -> dict[str, Any]:
    selected = []
    any_rebin = False
    any_health_improved = False
    every_no_rebin_explained = True
    catastrophic_losses: list[str] = []
    for key, off in _localized_candidates(off_metrics=off_metrics):
        on = on_metrics[key]
        checks: list[dict[str, Any]] = []
        rebins: list[dict[str, Any]] = []
        if on.problem_root is not None:
            checks, rebins = _rebin_events(Path(on.problem_root))
        any_rebin = any_rebin or bool(rebins)
        if not rebins:
            if checks:
                every_no_rebin_explained = every_no_rebin_explained and all(
                    _check_explains_no_rebin(check) for check in checks
                )
            else:
                every_no_rebin_explained = (
                    every_no_rebin_explained
                    and on.initialization_mode == "run_finalization_fallback"
                )
        health_delta = on.healthy_cell_count - off.healthy_cell_count
        occupied_delta = (on.occupied_cells or 0) - (off.occupied_cells or 0)
        any_health_improved = any_health_improved or health_delta > 0 or occupied_delta > 0
        if off.valid_ppa_sample_count > 0 and on.valid_ppa_sample_count == 0:
            catastrophic_losses.append(key)
        selected.append(
            {
                "problem": key,
                "selection_reason": {
                    "collapsed_axes": off.collapsed_axes,
                    "effective_cell_count": off.effective_cell_count,
                    "occupied_cells": off.occupied_cells,
                },
                "adaptive_off": {
                    "effective_cell_count": off.effective_cell_count,
                    "collapsed_axes": off.collapsed_axes,
                    "occupied_cells": off.occupied_cells,
                    "healthy_cell_count": off.healthy_cell_count,
                    "retained_member_count": off.total_archive_members,
                    "initialization_mode": off.initialization_mode,
                    "qd_coverage": off.qd_coverage,
                    "qd_score": off.qd_score,
                },
                "adaptive_on": {
                    "effective_cell_count": on.effective_cell_count,
                    "collapsed_axes": on.collapsed_axes,
                    "occupied_cells": on.occupied_cells,
                    "healthy_cell_count": on.healthy_cell_count,
                    "retained_member_count": on.total_archive_members,
                    "initialization_mode": on.initialization_mode,
                    "qd_coverage": on.qd_coverage,
                    "qd_score": on.qd_score,
                },
                "deltas": {
                    "effective_cell_count": (
                        None
                        if on.effective_cell_count is None or off.effective_cell_count is None
                        else on.effective_cell_count - off.effective_cell_count
                    ),
                    "occupied_cells": occupied_delta,
                    "healthy_cell_count": health_delta,
                    "qd_coverage": (
                        None
                        if on.qd_coverage is None or off.qd_coverage is None
                        else on.qd_coverage - off.qd_coverage
                    ),
                    "qd_score": (
                        None
                        if on.qd_score is None or off.qd_score is None
                        else on.qd_score - off.qd_score
                    ),
                },
                "rebin_checks": checks,
                "rebins": rebins,
            }
        )

    errors: list[str] = []
    if selected:
        for item in selected:
            if (
                not item["rebin_checks"]
                and item["adaptive_on"]["initialization_mode"]
                != "run_finalization_fallback"
            ):
                errors.append(f"{item['problem']} has no adaptive-on rebin_check event")
        if not any_rebin and not every_no_rebin_explained:
            errors.append("selected localized checks do not explain absence of rebin")
        if not any_health_improved:
            errors.append("no selected localized problem improved healthy or occupied cells")
        for key in catastrophic_losses:
            errors.append(f"{key} lost all valid PPA samples")
    status = "pass" if selected and not errors else "inconclusive" if selected else "not_applicable"
    return {
        "status": status,
        "selected_problem_count": len(selected),
        "selected_problems": selected,
        "errors": errors,
    }


def _per_problem_degradation(
    *,
    on_metrics: dict[str, ProblemMetrics],
    off_metrics: dict[str, ProblemMetrics],
) -> list[dict[str, Any]]:
    rows = []
    fields = (
        "functionality_rate",
        "synthesis_rate",
        "valid_ppa_sample_count",
        "average_quality_score",
        "average_ppa_improvement",
        "qd_coverage",
        "qd_score",
        "occupied_cells",
        "total_archive_members",
        "best_archive_quality",
    )
    for key, on in on_metrics.items():
        off = off_metrics[key]
        row: dict[str, Any] = {"problem": key}
        for field in fields:
            on_value = getattr(on, field)
            off_value = getattr(off, field)
            row[f"{field}_delta"] = (
                None
                if on_value is None or off_value is None
                else float(on_value) - float(off_value)
            )
        rows.append(row)
    return rows


def _write_report(path: Path, payload: dict[str, Any]) -> None:
    lines = [
        "# Adaptive Re-Binning Validation",
        "",
        f"- valid: `{payload['valid']}`",
        f"- failure_count: `{payload['failure_count']}`",
        f"- problem_invalid_count: `{payload['problem_invalid_count']}`",
        f"- acceptance_error_count: `{payload['acceptance_error_count']}`",
        f"- problem_count: `{payload['problem_count']}`",
        "",
        "## Paired Gates",
        "",
    ]
    for gate in payload["paired_gates"]:
        lines.append(
            f"- `{gate['metric']}`: enforced={gate['enforced']}, "
            f"passed={gate['passed']}, paired={gate['paired_count']}, "
            f"mean_delta={gate['mean_delta']}, threshold=-{gate['threshold']}"
        )
    lines.extend(["", "## Re-Binning Audit", ""])
    for audit in payload["adaptive_problem_audits"]:
        lines.append(
            f"- `{audit['problem']}`: initialized={audit['initialized']}, "
            f"checks={audit['rebin_check_count']}, rebins={audit['rebin_count']}, "
            f"errors={len(audit['errors'])}"
        )
    if payload["acceptance_errors"]:
        lines.extend(["", "## Acceptance Errors", ""])
        for error in payload["acceptance_errors"]:
            lines.append(f"- {error}")
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def _write_localized_report(path: Path, payload: dict[str, Any]) -> None:
    lines = [
        "# Adaptive Re-Binning Localized Trigger Evidence",
        "",
        f"- status: `{payload['status']}`",
        f"- selected_problem_count: `{payload['selected_problem_count']}`",
        "",
    ]
    for item in payload["selected_problems"]:
        lines.extend(
            [
                f"## {item['problem']}",
                "",
                f"- checks: `{len(item['rebin_checks'])}`",
                f"- rebins: `{len(item['rebins'])}`",
                f"- off_effective_cells: `{item['adaptive_off']['effective_cell_count']}`",
                f"- on_effective_cells: `{item['adaptive_on']['effective_cell_count']}`",
                f"- healthy_cell_delta: `{item['deltas']['healthy_cell_count']}`",
                f"- occupied_cell_delta: `{item['deltas']['occupied_cells']}`",
                "",
            ]
        )
    if payload["errors"]:
        lines.extend(["## Errors", ""])
        for error in payload["errors"]:
            lines.append(f"- {error}")
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--subset-config", required=True, type=Path)
    parser.add_argument("--classic-mode", required=True)
    parser.add_argument("--off-mode", required=True)
    parser.add_argument("--on-mode", required=True)
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    args = parser.parse_args(argv)

    expected = _expected_problems(args.subset_config)
    if not args.require_full_subset and not args.acceptance_hard_subset:
        observed = [
            item
            for item in expected
            if any(
                _problem_root(args.run_root, mode, item["benchmark"], item["problem"])
                is not None
                for mode in (args.classic_mode, args.off_mode, args.on_mode)
            )
        ]
        if observed:
            expected = observed

    acceptance_errors: list[str] = []
    if args.acceptance_hard_subset and len(expected) != 13:
        acceptance_errors.append(f"expected 13 hard-subset problems, found {len(expected)}")

    manifest = _parse_manifest(args.run_root / "hard_iteration_manifest.txt")
    if args.acceptance_hard_subset:
        total_slots = _safe_float(manifest.get("total_worker_slots"))
        if total_slots is None or total_slots > MAX_ACCEPTANCE_WORKERS:
            acceptance_errors.append("manifest total_worker_slots must be <= 16")
        if manifest.get(f"mode.{args.off_mode}.qd_rebinning_kind") != "disabled":
            acceptance_errors.append("adaptive-off manifest qd_rebinning_kind is not disabled")
        if manifest.get(f"mode.{args.on_mode}.qd_rebinning_kind") != "ks_triggered":
            acceptance_errors.append("adaptive-on manifest qd_rebinning_kind is not ks_triggered")
        for key, expected_value in (
            ("qd_rebinning_recent_generations", "3"),
            ("qd_rebinning_min_archive_members", "20"),
            ("qd_rebinning_cooldown_generations", "3"),
            ("qd_rebinning_base_p_threshold", "0.05"),
        ):
            if manifest.get(f"mode.{args.on_mode}.{key}") != expected_value:
                acceptance_errors.append(
                    f"adaptive-on manifest {key} is not {expected_value}"
                )

    modes = (args.classic_mode, args.off_mode, args.on_mode)
    metrics_by_mode: dict[str, dict[str, ProblemMetrics]] = {mode: {} for mode in modes}
    for mode in modes:
        for item in expected:
            key = f"{item['benchmark']}/{item['problem']}"
            metrics_by_mode[mode][key] = _collect_problem_metrics(
                run_root=args.run_root,
                mode=mode,
                benchmark=item["benchmark"],
                problem=item["problem"],
            )

    if args.require_full_subset:
        for mode, by_problem in metrics_by_mode.items():
            missing = [
                key
                for key, metrics in by_problem.items()
                if metrics.problem_root is None
            ]
            if missing:
                acceptance_errors.append(f"{mode} missing problems: {', '.join(missing)}")

    on_metrics = metrics_by_mode[args.on_mode]
    off_metrics = metrics_by_mode[args.off_mode]
    classic_metrics = metrics_by_mode[args.classic_mode]
    if args.acceptance_hard_subset:
        for key, metrics in on_metrics.items():
            if off_metrics[key].valid_ppa_sample_count > 0 and metrics.valid_ppa_sample_count == 0:
                acceptance_errors.append(f"adaptive-off had valid PPA but adaptive-on did not for {key}")
            if classic_metrics[key].valid_ppa_sample_count > 0 and metrics.valid_ppa_sample_count == 0:
                acceptance_errors.append(f"classic had valid PPA but adaptive-on did not for {key}")

    paired_gates = [
        _paired_gate(
            name="functional pass rate",
            on=on_metrics,
            off=off_metrics,
            field="functionality_rate",
            floor=0.03,
        ),
        _paired_gate(
            name="synthesis pass rate",
            on=on_metrics,
            off=off_metrics,
            field="synthesis_rate",
            floor=0.03,
        ),
        _paired_gate(
            name="valid PPA sample count",
            on=on_metrics,
            off=off_metrics,
            field="valid_ppa_sample_count",
            floor=1.0,
        ),
        _paired_gate(
            name="average quality score",
            on=on_metrics,
            off=off_metrics,
            field="average_quality_score",
            floor=0.03,
        ),
        _paired_gate(
            name="average PPA improvement",
            on=on_metrics,
            off=off_metrics,
            field="average_ppa_improvement",
            floor=0.06,
        ),
        _paired_gate(
            name="QD coverage",
            on=on_metrics,
            off=off_metrics,
            field="qd_coverage",
            floor=0.05,
        ),
        _paired_gate(
            name="QD score",
            on=on_metrics,
            off=off_metrics,
            field="qd_score",
            floor=_qd_score_floor(off_metrics),
        ),
    ]
    for gate in paired_gates:
        gate["enforced"] = args.acceptance_hard_subset
        if args.acceptance_hard_subset and not gate["passed"]:
            acceptance_errors.append(
                f"{gate['metric']} gate failed: mean_delta={gate['mean_delta']} "
                f"threshold=-{gate['threshold']}"
            )

    adaptive_problem_audits = _adaptive_problem_audits(metrics=on_metrics)
    for audit in adaptive_problem_audits:
        for error in audit["errors"]:
            acceptance_errors.append(f"{audit['problem']}: {error}")

    localized_payload = _localized_report(off_metrics=off_metrics, on_metrics=on_metrics)
    if args.acceptance_hard_subset and localized_payload["status"] != "pass":
        acceptance_errors.append(
            f"localized trigger evidence is {localized_payload['status']}"
        )
    for error in localized_payload["errors"]:
        acceptance_errors.append(f"localized evidence: {error}")

    if args.acceptance_hard_subset:
        viewer_root = args.run_root / "visualization" / "qd_ppa_viewer"
        if not (viewer_root / "index.html").is_file():
            acceptance_errors.append("missing visualization/qd_ppa_viewer/index.html")

    problem_invalid_count = sum(
        1
        for by_problem in metrics_by_mode.values()
        for metrics in by_problem.values()
        if metrics.errors
    )
    problem_error_count = sum(
        len(metrics.errors)
        for by_problem in metrics_by_mode.values()
        for metrics in by_problem.values()
    )
    acceptance_error_count = len(acceptance_errors)
    failure_count = problem_error_count + acceptance_error_count
    payload = {
        "valid": failure_count == 0,
        "failure_count": failure_count,
        "problem_invalid_count": problem_invalid_count,
        "acceptance_error_count": acceptance_error_count,
        "classic_mode": args.classic_mode,
        "off_mode": args.off_mode,
        "on_mode": args.on_mode,
        "problem_count": len(expected),
        "metrics_by_mode": {
            mode: {key: asdict(metrics) for key, metrics in by_problem.items()}
            for mode, by_problem in metrics_by_mode.items()
        },
        "paired_gates": paired_gates,
        "per_problem_degradation": _per_problem_degradation(
            on_metrics=on_metrics,
            off_metrics=off_metrics,
        ),
        "adaptive_problem_audits": adaptive_problem_audits,
        "acceptance_errors": acceptance_errors,
    }
    validation_json = args.run_root / "adaptive_rebinning_validation.json"
    validation_md = args.run_root / "adaptive_rebinning_validation.md"
    localized_json = args.run_root / "adaptive_rebinning_localized_trigger_evidence.json"
    localized_md = args.run_root / "adaptive_rebinning_localized_trigger_evidence.md"
    validation_json.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    localized_json.write_text(json.dumps(localized_payload, indent=2), encoding="utf-8")
    _write_report(validation_md, payload)
    _write_localized_report(localized_md, localized_payload)
    return 0 if payload["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
