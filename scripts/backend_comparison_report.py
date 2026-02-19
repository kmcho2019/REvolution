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
        "| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs | Avg PPA Delta | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |",
        "|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|",
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
        try:
            payload = json.loads(summary_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
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
        ref_metrics = (
            payload.get("ref_ppa_metric", {})
            if isinstance(payload.get("ref_ppa_metric", {}), dict)
            else {}
        )
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
                benchmark=payload.get("benchmark_name", summary_path.parent.parent.name),
                problem=payload.get("problem_name", summary_path.stem.replace("_summary", "")),
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
        "## Per-Problem Metrics",
        "",
        "| Backend | Benchmark | Problem | Functionality | Synthesis | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |",
        "|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|",
    ]
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
