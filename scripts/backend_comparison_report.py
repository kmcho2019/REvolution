import argparse
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass
class SummaryRow:
    backend: str
    benchmark: str
    problem: str
    functionality_rate: float
    synthesis_rate: float
    best_score: float | None
    runtime_seconds: float
    llm_api_calls: int


def _mean_std_ci95(values: list[float]) -> tuple[float, float, float]:
    if not values:
        return 0.0, 0.0, 0.0
    n = len(values)
    mean = sum(values) / n
    if n < 2:
        return mean, 0.0, 0.0
    variance = sum((value - mean) ** 2 for value in values) / (n - 1)
    std = math.sqrt(max(0.0, variance))
    ci95 = 1.96 * std / math.sqrt(n)
    return mean, std, ci95


def _render_aggregate_section(rows: list[SummaryRow], *, group_by_benchmark: bool) -> list[str]:
    grouped: dict[tuple[str, str], list[SummaryRow]] = {}
    for row in rows:
        key = (row.backend, row.benchmark if group_by_benchmark else "ALL")
        grouped.setdefault(key, []).append(row)

    heading = "## Aggregate Metrics by Backend and Benchmark" if group_by_benchmark else "## Aggregate Metrics by Backend (All Benchmarks)"
    lines = [
        heading,
        "",
        "| Backend | Benchmark | N | Func Mean | Func Std | Func CI95 | Synth Mean | Synth Std | Synth CI95 | Score Mean | Score Std | Score CI95 | Runtime Mean (s) | Runtime Std (s) | Runtime CI95 (s) | Calls Mean | Calls Std | Calls CI95 |",
        "|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for (backend, benchmark), group in sorted(grouped.items()):
        func_mean, func_std, func_ci = _mean_std_ci95([row.functionality_rate for row in group])
        synth_mean, synth_std, synth_ci = _mean_std_ci95([row.synthesis_rate for row in group])
        best_scores = [float(row.best_score) for row in group if row.best_score is not None]
        score_mean, score_std, score_ci = _mean_std_ci95(best_scores) if best_scores else (0.0, 0.0, 0.0)
        runtime_mean, runtime_std, runtime_ci = _mean_std_ci95([row.runtime_seconds for row in group])
        calls_mean, calls_std, calls_ci = _mean_std_ci95([float(row.llm_api_calls) for row in group])
        lines.append(
            f"| `{backend}` | {benchmark} | {len(group)} | "
            f"{func_mean:.3f} | {func_std:.3f} | {func_ci:.3f} | "
            f"{synth_mean:.3f} | {synth_std:.3f} | {synth_ci:.3f} | "
            f"{score_mean:.4f} | {score_std:.4f} | {score_ci:.4f} | "
            f"{runtime_mean:.2f} | {runtime_std:.2f} | {runtime_ci:.2f} | "
            f"{calls_mean:.2f} | {calls_std:.2f} | {calls_ci:.2f} |"
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
                "functionality": stage_rates.get("functionality", 0.0),
                "synthesis_ppa": stage_rates.get("synthesis", 0.0),
            }
        final_ppa = payload.get("final_population_ppa", {})
        rows.append(
            SummaryRow(
                backend=backend,
                benchmark=payload.get("benchmark_name", summary_path.parent.parent.name),
                problem=payload.get("problem_name", summary_path.stem.replace("_summary", "")),
                functionality_rate=float(rates.get("functionality", 0.0)),
                synthesis_rate=float(rates.get("synthesis_ppa", 0.0)),
                best_score=final_ppa.get("best_score"),
                runtime_seconds=float(payload.get("total_runtime_seconds", 0.0)),
                llm_api_calls=int(payload.get("total_llm_api_calls", 0)),
            )
        )
    return rows


def _render_markdown(rows: list[SummaryRow]) -> str:
    lines = [
        "# Backend Comparison Report",
        "",
        "## Per-Problem Metrics",
        "",
        "| Backend | Benchmark | Problem | Functionality Rate | Synthesis Rate | Best Score | Runtime (s) | LLM Calls |",
        "|:---|:---|:---|---:|---:|---:|---:|---:|",
    ]
    for row in sorted(rows, key=lambda item: (item.benchmark, item.problem, item.backend)):
        best_score = "N/A" if row.best_score is None else f"{float(row.best_score):.4f}"
        lines.append(
            f"| `{row.backend}` | {row.benchmark} | {row.problem} | "
            f"{row.functionality_rate:.3f} | {row.synthesis_rate:.3f} | {best_score} | "
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
