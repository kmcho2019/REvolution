import argparse
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any


TREND_EPSILON = 0.01


@dataclass
class SummaryRow:
    backend: str
    benchmark: str
    problem: str
    search_mode: str | None
    functionality_rate: float
    synthesis_rate: float
    best_score: float | None
    score_improvement_pct: float | None
    area_improvement_pct: float | None
    power_improvement_pct: float | None
    period_improvement_pct: float | None
    avg_ppa_improvement_pct: float | None
    runtime_seconds: float
    llm_api_calls: int
    llm_prompt_tokens: int
    llm_completion_tokens: int
    primary_budget_axis: str | None
    max_evaluations: int | None
    max_llm_calls: int | None
    qd_archive_type: str | None
    qd_coverage: float | None
    qd_score: float | None
    qd_best_quality: float | None
    qd_occupied_cells: int | None
    qd_num_cells: int | None
    qd_descriptor_profile: str | None
    qd_descriptor_axes: tuple[str, ...]
    qd_observation_count: int | None
    qd_archive_entry_count: int | None
    qd_collapsed_axes: tuple[str, ...]
    qd_decision_counts: dict[str, int]


IGNORED_SUMMARY_FILENAMES = {"archive_summary.json"}


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


def _safe_int(value: Any) -> int | None:
    parsed = _safe_float(value)
    if parsed is None:
        return None
    return int(parsed)


def _metric_improvement_percent(new_value: Any, ref_value: Any) -> float | None:
    new_float = _safe_float(new_value)
    ref_float = _safe_float(ref_value)
    if new_float is None or ref_float is None or abs(ref_float) < 1e-12:
        return None
    return ((ref_float - new_float) / abs(ref_float)) * 100.0


def _mean_std_ci95(values: list[float]) -> tuple[float | None, float | None, float | None]:
    if not values:
        return None, None, None
    n = len(values)
    mean = sum(values) / n
    if n < 2:
        return mean, 0.0, 0.0
    variance = sum((value - mean) ** 2 for value in values) / (n - 1)
    std = math.sqrt(max(0.0, variance))
    ci95 = 1.96 * std / math.sqrt(n)
    return mean, std, ci95


def _trend_emoji(value: float) -> str:
    if value > TREND_EPSILON:
        return "✅"
    if value < -TREND_EPSILON:
        return "❌"
    return "➖"


def _format_pass_rate(rate: float) -> str:
    if rate > 0:
        return f"✅ Pass ({rate * 100:.1f}%)"
    return "❌ Fail (0.0%)"


def _format_delta(value: float | None) -> str:
    if value is None:
        return "N/A"
    return f"{value:+.2f}% {_trend_emoji(value)}"


def _format_count_with_rate(count: int, total: int) -> str:
    if total <= 0:
        return "N/A"
    if count == 0:
        emoji = "❌"
    elif count == total:
        emoji = "✅"
    else:
        emoji = "➖"
    return f"{emoji} {count}/{total} ({(count / total) * 100:.1f}%)"


def _format_mean_ci(values: list[float], *, precision: int = 2, signed: bool = False) -> str:
    mean, _, ci95 = _mean_std_ci95(values)
    if mean is None or ci95 is None:
        return "N/A"
    sign = "+" if signed else ""
    return f"{mean:{sign}.{precision}f} ± {ci95:.{precision}f}"


def _format_mean_ci_percent(values: list[float], *, signed: bool = False) -> str:
    mean, _, ci95 = _mean_std_ci95(values)
    if mean is None or ci95 is None:
        return "N/A"
    if signed:
        return f"{mean:+.2f}% ± {ci95:.2f}% {_trend_emoji(mean)}"
    return f"{mean * 100:.1f}% ± {ci95 * 100:.1f}%"


def _trend_counts(values: list[float]) -> tuple[int, int, int]:
    improved = sum(1 for value in values if value > TREND_EPSILON)
    regressed = sum(1 for value in values if value < -TREND_EPSILON)
    neutral = len(values) - improved - regressed
    return improved, neutral, regressed


def _format_trend_counts(values: list[float]) -> str:
    if not values:
        return "N/A"
    improved, neutral, regressed = _trend_counts(values)
    return f"✅ {improved} / ➖ {neutral} / ❌ {regressed}"


def _format_regression_count(values: list[float]) -> str:
    if not values:
        return "N/A"
    regressed = sum(1 for value in values if value < -TREND_EPSILON)
    emoji = "❌" if regressed > 0 else "✅"
    return f"{emoji} {regressed}/{len(values)}"


def _format_aggregate_ppa_deltas(
    area_values: list[float], power_values: list[float], period_values: list[float]
) -> str:
    return " / ".join(
        [
            _format_mean_ci_percent(area_values, signed=True),
            _format_mean_ci_percent(power_values, signed=True),
            _format_mean_ci_percent(period_values, signed=True),
        ]
    )


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


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
    if power == 0.0 or area == 0.0:
        return {}
    return {
        "tns": tns,
        "wns": wns,
        "eff_clk_period": eff_clk_period,
        "power": power,
        "area": area,
    }


def _format_cap(values: list[int | None]) -> str:
    finite_values = sorted({int(value) for value in values if value is not None})
    if not finite_values:
        return "N/A"
    if len(finite_values) == 1:
        return str(finite_values[0])
    return f"mixed ({finite_values[0]}..{finite_values[-1]})"


def _format_ratio(numerator: float, denominator: int) -> str:
    if denominator <= 0:
        return "N/A"
    return f"{numerator / denominator:.2f}"


def _is_problem_summary_path(summary_path: Path) -> bool:
    """Return whether a JSON summary path is a canonical per-problem summary."""

    return (
        summary_path.name.endswith("_summary.json")
        and summary_path.name not in IGNORED_SUMMARY_FILENAMES
    )


def _load_qd_archive_summary(summary_path: Path) -> dict[str, Any]:
    """Load QD archive sidecar metrics stored beside the problem summary."""

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


def _load_qd_descriptor_health(summary_path: Path) -> dict[str, Any]:
    """Load QD descriptor-health sidecar metrics stored beside the problem summary."""

    health_path = summary_path.parent / "descriptor_health.json"
    if not health_path.is_file():
        return {}
    try:
        payload = json.loads(health_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}
    if not isinstance(payload, dict):
        return {}
    return payload


def _render_budget_fairness_section(rows: list[SummaryRow]) -> list[str]:
    grouped: dict[tuple[str, str], list[SummaryRow]] = {}
    for row in rows:
        grouped.setdefault((row.backend, row.benchmark), []).append(row)
        grouped.setdefault((row.backend, "ALL"), []).append(row)

    lines = [
        "## Budget and Fairness Diagnostics",
        "",
        "| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |",
        "|:---|:---|:---|:---|:---|:---|:---|:---|:---|",
    ]
    for (backend, benchmark), group in sorted(grouped.items()):
        func_any_pass = sum(1 for row in group if row.functionality_rate > 0)
        synth_any_pass = sum(1 for row in group if row.synthesis_rate > 0)
        total_calls = float(sum(row.llm_api_calls for row in group))
        axis_values = sorted(
            {
                row.primary_budget_axis
                for row in group
                if row.primary_budget_axis and row.primary_budget_axis != "unspecified"
            }
        )
        axis = axis_values[0] if len(axis_values) == 1 else (
            "mixed" if axis_values else "unspecified"
        )
        lines.append(
            f"| `{backend}` | {benchmark} | {axis} | "
            f"{_format_cap([row.max_evaluations for row in group])} | "
            f"{_format_cap([row.max_llm_calls for row in group])} | "
            f"{_format_mean_ci([float(row.llm_api_calls) for row in group], precision=2)} | "
            f"{_format_mean_ci([float(row.llm_prompt_tokens + row.llm_completion_tokens) for row in group], precision=2)} | "
            f"{_format_ratio(total_calls, func_any_pass)} | "
            f"{_format_ratio(total_calls, synth_any_pass)} |"
        )
    lines.append("")
    return lines


def _render_qd_archive_section(rows: list[SummaryRow]) -> list[str]:
    """Render an optional section summarizing QD archive coverage and quality."""

    qd_rows = [row for row in rows if row.search_mode == "revolution_qd"]
    if not qd_rows:
        return []
    lines = [
        "## QD Archive Metrics",
        "",
        "| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |",
        "|:---|:---|:---|:---|:---|:---|:---|:---|",
    ]
    for row in sorted(qd_rows, key=lambda item: (item.benchmark, item.problem, item.backend)):
        occupied = (
            f"{row.qd_occupied_cells}/{row.qd_num_cells}"
            if row.qd_occupied_cells is not None and row.qd_num_cells is not None
            else "N/A"
        )
        coverage = (
            f"{row.qd_coverage * 100:.1f}%"
            if row.qd_coverage is not None
            else "N/A"
        )
        qd_score = f"{row.qd_score:.4f}" if row.qd_score is not None else "N/A"
        best_quality = (
            f"{row.qd_best_quality:.4f}" if row.qd_best_quality is not None else "N/A"
        )
        lines.append(
            f"| `{row.backend}` | {row.benchmark} | {row.problem} | "
            f"{row.qd_archive_type or 'N/A'} | {coverage} | {qd_score} | {best_quality} | "
            f"{occupied} |"
        )
    lines.append("")
    return lines


def _render_qd_descriptor_health_section(rows: list[SummaryRow]) -> list[str]:
    """Render descriptor-health diagnostics for QD runs when available."""

    qd_rows = [
        row
        for row in rows
        if row.search_mode == "revolution_qd"
        and (
            row.qd_observation_count is not None
            or row.qd_archive_entry_count is not None
            or row.qd_collapsed_axes
        )
    ]
    if not qd_rows:
        return []
    lines = [
        "## QD Descriptor Health",
        "",
        "| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Collapsed Axes | Decisions |",
        "|:---|:---|:---|:---|:---|---:|---:|:---|:---|",
    ]
    for row in sorted(qd_rows, key=lambda item: (item.benchmark, item.problem, item.backend)):
        axes = ", ".join(row.qd_descriptor_axes) if row.qd_descriptor_axes else "N/A"
        collapsed_axes = ", ".join(row.qd_collapsed_axes) if row.qd_collapsed_axes else "none"
        decision_counts = (
            ", ".join(
                f"{decision}={count}"
                for decision, count in sorted(row.qd_decision_counts.items())
            )
            if row.qd_decision_counts
            else "N/A"
        )
        lines.append(
            f"| `{row.backend}` | {row.benchmark} | {row.problem} | "
            f"{row.qd_descriptor_profile or 'N/A'} | {axes} | "
            f"{row.qd_observation_count if row.qd_observation_count is not None else 'N/A'} | "
            f"{row.qd_archive_entry_count if row.qd_archive_entry_count is not None else 'N/A'} | "
            f"{collapsed_axes} | {decision_counts} |"
        )
    lines.append("")
    return lines


def _render_aggregate_section(rows: list[SummaryRow], *, group_by_benchmark: bool) -> list[str]:
    grouped: dict[tuple[str, str], list[SummaryRow]] = {}
    for row in rows:
        key = (row.backend, row.benchmark if group_by_benchmark else "ALL")
        grouped.setdefault(key, []).append(row)

    heading = (
        "## Aggregate Backend Metrics by Benchmark"
        if group_by_benchmark
        else "## Aggregate Backend Metrics (All Benchmarks)"
    )
    lines = [
        heading,
        "",
        "| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |",
        "|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|",
    ]
    for (backend, benchmark), group in sorted(grouped.items()):
        func_any_pass = sum(1 for row in group if row.functionality_rate > 0)
        synth_any_pass = sum(1 for row in group if row.synthesis_rate > 0)
        score_values = [
            row.score_improvement_pct
            for row in group
            if row.score_improvement_pct is not None
        ]
        avg_ppa_values = [
            row.avg_ppa_improvement_pct
            for row in group
            if row.avg_ppa_improvement_pct is not None
        ]
        area_values = [
            row.area_improvement_pct
            for row in group
            if row.area_improvement_pct is not None
        ]
        power_values = [
            row.power_improvement_pct
            for row in group
            if row.power_improvement_pct is not None
        ]
        period_values = [
            row.period_improvement_pct
            for row in group
            if row.period_improvement_pct is not None
        ]

        runtime_values = [row.runtime_seconds for row in group]
        call_values = [float(row.llm_api_calls) for row in group]

        lines.append(
            f"| `{backend}` | {benchmark} | {len(group)} | "
            f"{_format_count_with_rate(func_any_pass, len(group))} | "
            f"{_format_count_with_rate(synth_any_pass, len(group))} | "
            f"{_format_mean_ci_percent([row.functionality_rate for row in group])} | "
            f"{_format_mean_ci_percent([row.synthesis_rate for row in group])} | "
            f"{len(score_values)}/{len(group)} | "
            f"{_format_mean_ci_percent(score_values, signed=True)} | "
            f"{_format_trend_counts(score_values)} | "
            f"{len(avg_ppa_values)}/{len(group)} | "
            f"{_format_mean_ci_percent(avg_ppa_values, signed=True)} | "
            f"{_format_aggregate_ppa_deltas(area_values, power_values, period_values)} | "
            f"{_format_trend_counts(avg_ppa_values)} | "
            f"A {_format_regression_count(area_values)} / P {_format_regression_count(power_values)} / T {_format_regression_count(period_values)} | "
            f"{_format_mean_ci(runtime_values, precision=2)} | "
            f"{_format_mean_ci(call_values, precision=2)} |"
        )
    lines.append("")
    return lines


def _load_summary_rows(backend: str, root: Path) -> list[SummaryRow]:
    rows: list[SummaryRow] = []
    for summary_path in root.rglob("*_summary.json"):
        if not _is_problem_summary_path(summary_path):
            continue
        try:
            payload = json.loads(summary_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        qd_archive_summary = _load_qd_archive_summary(summary_path)
        qd_descriptor_health = _load_qd_descriptor_health(summary_path)
        rates = payload.get("accumulated_success_rates", {})
        if not rates and "stage_success_rates" in payload:
            stage_rates = payload["stage_success_rates"]
            rates = {
                "syntax": stage_rates.get("syntax", 0.0),
                "functionality": stage_rates.get("functionality", 0.0),
                "synthesis_ppa": stage_rates.get("synthesis", 0.0),
            }
        final_ppa = payload.get("final_population_ppa", {})
        best_metrics = (
            final_ppa.get("best_metrics", {})
            if isinstance(final_ppa.get("best_metrics", {}), dict)
            else {}
        )
        benchmark_name = payload.get("benchmark_name", summary_path.parent.parent.name)
        problem_name = payload.get(
            "problem_name", summary_path.stem.replace("_summary", "")
        )
        ref_metrics = payload.get("ref_ppa_metric", {})
        if not isinstance(ref_metrics, dict):
            ref_metrics = {}
        if not ref_metrics:
            # Backfill legacy runs where reference PPA was not propagated into summaries.
            ref_metrics = _load_reference_ppa_metrics_from_bench(
                benchmark=benchmark_name,
                problem=problem_name,
            )
        run_budget = (
            payload.get("run_budget", {})
            if isinstance(payload.get("run_budget", {}), dict)
            else {}
        )
        backend_details = (
            payload.get("backend_details", {})
            if isinstance(payload.get("backend_details", {}), dict)
            else {}
        )
        qd_config = (
            backend_details.get("qd_config", {})
            if isinstance(backend_details.get("qd_config", {}), dict)
            else {}
        )
        descriptor_axes_raw = qd_descriptor_health.get(
            "descriptor_axes",
            qd_archive_summary.get("descriptor_axes"),
        )
        descriptor_axes = tuple(
            axis
            for axis in descriptor_axes_raw
            if isinstance(axis, str)
        ) if isinstance(descriptor_axes_raw, list) else ()
        collapsed_axes_raw = qd_descriptor_health.get("collapsed_axes", [])
        collapsed_axes = tuple(
            axis
            for axis in collapsed_axes_raw
            if isinstance(axis, str)
        ) if isinstance(collapsed_axes_raw, list) else ()
        decision_counts_raw = qd_descriptor_health.get("decision_counts", {})
        decision_counts: dict[str, int] = {}
        if isinstance(decision_counts_raw, dict):
            for key, value in decision_counts_raw.items():
                parsed = _safe_int(value)
                if parsed is None:
                    continue
                decision_counts[str(key)] = int(parsed)
        functionality_rate = _safe_rate(rates.get("functionality", 0.0))
        synthesis_rate = _safe_rate(rates.get("synthesis_ppa", 0.0))
        best_score = _safe_float(final_ppa.get("best_score"))

        score_improvement_pct: float | None = None
        area_improvement_pct: float | None = None
        power_improvement_pct: float | None = None
        period_improvement_pct: float | None = None
        avg_ppa_improvement_pct: float | None = None

        if synthesis_rate > 0:
            if best_score is not None:
                score_improvement_pct = best_score * 100.0
            area_improvement_pct = _metric_improvement_percent(
                best_metrics.get("area"),
                ref_metrics.get("area"),
            )
            power_improvement_pct = _metric_improvement_percent(
                best_metrics.get("power"),
                ref_metrics.get("power"),
            )
            period_improvement_pct = _metric_improvement_percent(
                best_metrics.get("eff_clk_period"),
                ref_metrics.get("eff_clk_period"),
            )
            valid_ppa_values = [
                value
                for value in (
                    area_improvement_pct,
                    power_improvement_pct,
                    period_improvement_pct,
                )
                if value is not None
            ]
            if valid_ppa_values:
                avg_ppa_improvement_pct = sum(valid_ppa_values) / len(valid_ppa_values)

        rows.append(
            SummaryRow(
                backend=backend,
                benchmark=benchmark_name,
                problem=problem_name,
                search_mode=(
                    backend_details.get("search_mode")
                    if isinstance(backend_details.get("search_mode"), str)
                    else None
                ),
                functionality_rate=functionality_rate,
                synthesis_rate=synthesis_rate,
                best_score=best_score,
                score_improvement_pct=score_improvement_pct,
                area_improvement_pct=area_improvement_pct,
                power_improvement_pct=power_improvement_pct,
                period_improvement_pct=period_improvement_pct,
                avg_ppa_improvement_pct=avg_ppa_improvement_pct,
                runtime_seconds=float(payload.get("total_runtime_seconds", 0.0)),
                llm_api_calls=int(payload.get("total_llm_api_calls", 0)),
                llm_prompt_tokens=int(payload.get("total_llm_prompt_tokens", 0)),
                llm_completion_tokens=int(payload.get("total_llm_completion_tokens", 0)),
                primary_budget_axis=run_budget.get("primary_budget_axis"),
                max_evaluations=_safe_int(run_budget.get("max_evaluations")),
                max_llm_calls=_safe_int(run_budget.get("max_llm_calls")),
                qd_archive_type=(
                    qd_archive_summary.get("archive_type")
                    if isinstance(qd_archive_summary.get("archive_type"), str)
                    else (
                        qd_config.get("archive_type")
                        if isinstance(qd_config.get("archive_type"), str)
                        else None
                    )
                ),
                qd_coverage=_safe_float(qd_archive_summary.get("coverage")),
                qd_score=_safe_float(qd_archive_summary.get("qd_score")),
                qd_best_quality=_safe_float(qd_archive_summary.get("best_quality")),
                qd_occupied_cells=_safe_int(qd_archive_summary.get("occupied_cells")),
                qd_num_cells=_safe_int(qd_archive_summary.get("num_cells")),
                qd_descriptor_profile=(
                    qd_descriptor_health.get("descriptor_profile")
                    if isinstance(qd_descriptor_health.get("descriptor_profile"), str)
                    else (
                        qd_archive_summary.get("descriptor_profile")
                        if isinstance(qd_archive_summary.get("descriptor_profile"), str)
                        else None
                    )
                ),
                qd_descriptor_axes=descriptor_axes,
                qd_observation_count=_safe_int(qd_descriptor_health.get("observation_count")),
                qd_archive_entry_count=_safe_int(qd_descriptor_health.get("archive_entry_count")),
                qd_collapsed_axes=collapsed_axes,
                qd_decision_counts=decision_counts,
            )
        )
    return rows


def _render_markdown(rows: list[SummaryRow]) -> str:
    lines = [
        "# Backend Comparison Report",
        "",
        "Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.",
        "Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.",
        "",
    ]
    lines.extend(_render_budget_fairness_section(rows))
    lines.extend(
        [
        "## Per-Problem Metrics",
        "",
        "| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |",
        "|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|",
        ]
    )
    for row in sorted(rows, key=lambda item: (item.benchmark, item.problem, item.backend)):
        ppa_components = " / ".join(
            [
                _format_delta(row.area_improvement_pct),
                _format_delta(row.power_improvement_pct),
                _format_delta(row.period_improvement_pct),
            ]
        )
        lines.append(
            f"| `{row.backend}` | {row.benchmark} | {row.problem} | "
            f"{_format_pass_rate(row.functionality_rate)} | "
            f"{_format_pass_rate(row.synthesis_rate)} | "
            f"{_format_delta(row.score_improvement_pct)} | "
            f"{ppa_components} | "
            f"{_format_delta(row.avg_ppa_improvement_pct)} | "
            f"{row.runtime_seconds:.2f} | {row.llm_api_calls} |"
        )
    lines.append("")
    lines.extend(_render_aggregate_section(rows, group_by_benchmark=True))
    lines.extend(_render_aggregate_section(rows, group_by_benchmark=False))
    lines.extend(_render_qd_archive_section(rows))
    lines.extend(_render_qd_descriptor_health_section(rows))
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate a side-by-side backend report from experiment directories."
    )
    parser.add_argument(
        "--backend_run",
        action="append",
        required=True,
        help="Backend mapping in the form <name>=<experiment_path>. Repeat for multiple backends.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional markdown output path. Defaults to stdout only.",
    )
    args = parser.parse_args()

    rows: list[SummaryRow] = []
    for mapping in args.backend_run:
        if "=" not in mapping:
            raise ValueError(
                f"Invalid --backend_run '{mapping}'. Expected format <backend>=<path>."
            )
        backend, path_str = mapping.split("=", 1)
        root = Path(path_str).expanduser().resolve()
        if not root.is_dir():
            raise FileNotFoundError(f"Experiment path not found: {root}")
        rows.extend(_load_summary_rows(backend=backend, root=root))

    report = _render_markdown(rows)
    print(report)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(report, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
