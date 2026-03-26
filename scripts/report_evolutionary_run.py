#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
from collections import Counter, defaultdict
from pathlib import Path
from statistics import mean
from typing import Any

import matplotlib.pyplot as plt
import yaml


def _parse_backend_run(value: str) -> tuple[str, Path]:
    if "=" not in value:
        raise argparse.ArgumentTypeError(
            f"Expected BACKEND=PATH, got {value!r}"
        )
    backend, raw_path = value.split("=", 1)
    backend = backend.strip()
    path = Path(raw_path).expanduser().resolve()
    if not backend:
        raise argparse.ArgumentTypeError(f"Invalid backend label in {value!r}")
    return backend, path


def _safe_float(value: Any) -> float | None:
    if value is None:
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _mean(values: list[float | None]) -> float | None:
    present = [value for value in values if value is not None]
    if not present:
        return None
    return mean(present)


def _load_selected_problems(config_path: Path) -> list[tuple[str, str]]:
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    selected = payload.get("selected_problems") or []
    return [
        (entry["benchmark"], entry["problem"])
        for entry in selected
        if isinstance(entry, dict)
        and isinstance(entry.get("benchmark"), str)
        and isinstance(entry.get("problem"), str)
    ]


def _load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def _summary_matches_problem(summary_path: Path, benchmark: str, problem: str) -> bool:
    if summary_path.parent.name != problem:
        return False
    if summary_path.parent.parent.name == benchmark:
        return True

    payload = _load_json(summary_path)
    return (
        payload.get("benchmark_name") == benchmark
        and payload.get("problem_name") == problem
    )


def _find_problem_summary_path(
    backend_root: Path,
    benchmark: str,
    problem: str,
) -> Path | None:
    direct_path = backend_root / benchmark / problem / f"{problem}_summary.json"
    if direct_path.exists():
        return direct_path

    for summary_path in sorted(backend_root.rglob(f"{problem}_summary.json")):
        if _summary_matches_problem(summary_path, benchmark, problem):
            return summary_path
    return None


def _iter_problem_roots(
    backend_root: Path,
    selected: list[tuple[str, str]],
) -> list[tuple[str, str, Path]]:
    rows: list[tuple[str, str, Path]] = []
    for benchmark, problem in selected:
        summary_path = _find_problem_summary_path(backend_root, benchmark, problem)
        if summary_path is None:
            continue
        rows.append((benchmark, problem, summary_path.parent))
    return rows


def _collect_generation_rows(problem_root: Path) -> list[dict[str, Any]]:
    path = problem_root / "generation_log.jsonl"
    if not path.exists():
        return []
    rows: list[dict[str, Any]] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            rows.append(json.loads(line))
    return rows


def _collect_archive_rows(problem_root: Path) -> list[dict[str, Any]]:
    path = problem_root / "archive_history.jsonl"
    if not path.exists():
        return []
    rows: list[dict[str, Any]] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            rows.append(json.loads(line))
    return rows


def _format_percent(value: float | None) -> str:
    if value is None:
        return "n/a"
    return f"{value * 100.0:.1f}%"


def _format_float(value: float | None) -> str:
    if value is None:
        return "n/a"
    return f"{value:.4f}"


def _write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def _plot_generation_rates(path: Path, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return
    generations = [int(row["generation"]) for row in rows]
    functionality = [
        _safe_float(row.get("functionality_mean")) or float("nan") for row in rows
    ]
    synthesis = [_safe_float(row.get("synthesis_mean")) or float("nan") for row in rows]
    plt.figure(figsize=(8, 4.8))
    plt.plot(generations, functionality, marker="o", label="functionality")
    plt.plot(generations, synthesis, marker="o", label="synthesis")
    plt.xlabel("generation")
    plt.ylabel("mean success rate")
    plt.ylim(0.0, 1.0)
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(path, dpi=150)
    plt.close()


def _plot_generation_scores(path: Path, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return
    generations = [int(row["generation"]) for row in rows]
    best_score = [_safe_float(row.get("best_score_mean")) or float("nan") for row in rows]
    average_score = [
        _safe_float(row.get("average_score_mean")) or float("nan") for row in rows
    ]
    plt.figure(figsize=(8, 4.8))
    plt.plot(generations, best_score, marker="o", label="best_score")
    plt.plot(generations, average_score, marker="o", label="average_score")
    plt.xlabel("generation")
    plt.ylabel("mean score")
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(path, dpi=150)
    plt.close()


def _plot_qd_archive_metrics(path: Path, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return
    generations = [int(row["generation"]) for row in rows]
    coverage = [row.get("coverage_mean") for row in rows]
    qd_score = [row.get("qd_score_mean") for row in rows]
    best_quality = [row.get("best_quality_mean") for row in rows]
    new_filled = [row.get("new_filled_cells_mean") for row in rows]

    fig, axes = plt.subplots(2, 1, figsize=(8, 7), sharex=True)
    axes[0].plot(generations, coverage, marker="o", label="coverage")
    axes[0].plot(generations, new_filled, marker="o", label="new_filled_cells")
    axes[0].set_ylabel("archive fill")
    axes[0].grid(True, alpha=0.3)
    axes[0].legend()

    axes[1].plot(generations, qd_score, marker="o", label="qd_score")
    axes[1].plot(generations, best_quality, marker="o", label="best_quality")
    axes[1].set_xlabel("generation")
    axes[1].set_ylabel("quality")
    axes[1].grid(True, alpha=0.3)
    axes[1].legend()

    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=150)
    plt.close(fig)


def _write_backend_report(
    path: Path,
    backend: str,
    summary: dict[str, Any],
    per_problem_rows: list[dict[str, Any]],
    generation_rows: list[dict[str, Any]],
    status_rows: list[dict[str, Any]],
    strategy_rows: list[dict[str, Any]],
) -> None:
    rate_plot = "generation_rates.png" if generation_rows else None
    score_plot = "generation_scores.png" if generation_rows else None
    archive_plot = "generation_archive_metrics.png" if summary["has_qd_archive"] else None

    sorted_problems = sorted(
        per_problem_rows,
        key=lambda row: (
            row.get("synthesis_rate") or -1.0,
            row.get("functionality_rate") or -1.0,
            row.get("best_score") or -999.0,
        ),
        reverse=True,
    )
    lines = [
        f"# Evolutionary report: {backend}",
        "",
        "## Run summary",
        "",
        f"- backend: `{backend}`",
        f"- problem_count: `{summary['problem_count']}`",
        f"- qd_archive_present: `{summary['has_qd_archive']}`",
        f"- mean_functionality_rate: `{_format_percent(summary['functionality_mean'])}`",
        f"- mean_synthesis_rate: `{_format_percent(summary['synthesis_mean'])}`",
        f"- mean_best_score: `{_format_float(summary['best_score_mean'])}`",
        f"- mean_runtime_seconds: `{_format_float(summary['runtime_seconds_mean'])}`",
        f"- total_llm_api_calls: `{summary['total_llm_api_calls']}`",
        "",
        "## Plot files",
        "",
        f"- generation rates: {'![](' + rate_plot + ')' if rate_plot else 'n/a'}",
        f"- generation scores: {'![](' + score_plot + ')' if score_plot else 'n/a'}",
        f"- QD archive trends: {'![](' + archive_plot + ')' if archive_plot else 'n/a'}",
        "",
        "## Per-problem summary",
        "",
        "| Benchmark | Problem | Func | Synth | Best score | Runtime (s) | Final coverage | Final QD score |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for row in sorted_problems:
        lines.append(
            "| "
            f"{row['benchmark']} | {row['problem']} | "
            f"{_format_percent(row.get('functionality_rate'))} | "
            f"{_format_percent(row.get('synthesis_rate'))} | "
            f"{_format_float(row.get('best_score'))} | "
            f"{_format_float(row.get('runtime_seconds'))} | "
            f"{_format_percent(row.get('final_coverage'))} | "
            f"{_format_float(row.get('final_qd_score'))} |"
        )
    if generation_rows:
        lines.extend(
            [
                "",
                "## Generation aggregates",
                "",
                "| Gen | Problems | Func | Synth | Best score | Avg score | Diff success | Coverage | QD score |",
                "| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
            ]
        )
        for row in generation_rows:
            lines.append(
                "| "
                f"{row['generation']} | {row['problem_count']} | "
                f"{_format_percent(row.get('functionality_mean'))} | "
                f"{_format_percent(row.get('synthesis_mean'))} | "
                f"{_format_float(row.get('best_score_mean'))} | "
                f"{_format_float(row.get('average_score_mean'))} | "
                f"{_format_percent(row.get('diff_success_rate_mean'))} | "
                f"{_format_percent(row.get('coverage_mean'))} | "
                f"{_format_float(row.get('qd_score_mean'))} |"
            )
    if status_rows:
        lines.extend(
            [
                "",
                "## Aggregated status counts by generation",
                "",
                "| Gen | failed_syntax | failed_functionality | failed_diff | failed_synthesis_functionality | success |",
                "| ---: | ---: | ---: | ---: | ---: | ---: |",
            ]
        )
        for row in status_rows:
            lines.append(
                "| "
                f"{row['generation']} | {row.get('failed_syntax', 0)} | "
                f"{row.get('failed_functionality', 0)} | {row.get('failed_diff', 0)} | "
                f"{row.get('failed_synthesis_functionality', 0)} | {row.get('success', 0)} |"
            )
    if strategy_rows:
        lines.extend(
            [
                "",
                "## Aggregated strategy counts by generation",
                "",
                "| Gen | Top strategies |",
                "| ---: | --- |",
            ]
        )
        for row in strategy_rows:
            top = sorted(
                ((key, value) for key, value in row.items() if key != "generation" and value),
                key=lambda item: item[1],
                reverse=True,
            )[:5]
            top_text = ", ".join(f"{name}={count}" for name, count in top) or "n/a"
            lines.append(f"| {row['generation']} | {top_text} |")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _build_backend_summary(
    backend: str,
    backend_root: Path,
    selected: list[tuple[str, str]],
) -> tuple[dict[str, Any], list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]]]:
    problem_roots = _iter_problem_roots(backend_root, selected)
    per_problem_rows: list[dict[str, Any]] = []
    generation_buckets: dict[int, list[dict[str, Any]]] = defaultdict(list)
    archive_buckets: dict[int, list[dict[str, Any]]] = defaultdict(list)
    status_counts: dict[int, Counter[str]] = defaultdict(Counter)
    strategy_counts: dict[int, Counter[str]] = defaultdict(Counter)
    has_qd_archive = False

    for benchmark, problem, problem_root in problem_roots:
        summary_payload = _load_json(problem_root / f"{problem}_summary.json")
        rates = {}
        for rate_key in ("accumulated_success_rates", "success_rates"):
            value = summary_payload.get(rate_key)
            if isinstance(value, dict):
                rates = value
                break
        archive_rows = _collect_archive_rows(problem_root)
        if archive_rows:
            has_qd_archive = True
            for row in archive_rows:
                generation_buckets[int(row["generation"])].append({})
                archive_buckets[int(row["generation"])].append(row)
        per_problem_rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "functionality_rate": _safe_float(rates.get("functionality") or rates.get("total_functionality")),
                "synthesis_rate": _safe_float(rates.get("synthesis_ppa") or rates.get("total_synthesis_ppa")),
                "best_score": _safe_float(
                    summary_payload.get("best_score")
                    or (summary_payload.get("final_population_ppa") or {}).get("best_score")
                ),
                "runtime_seconds": _safe_float(summary_payload.get("total_runtime_seconds")),
                "final_coverage": _safe_float(archive_rows[-1]["coverage"]) if archive_rows else None,
                "final_qd_score": _safe_float(archive_rows[-1]["qd_score"]) if archive_rows else None,
            }
        )
        for generation_row in _collect_generation_rows(problem_root):
            generation = int(generation_row["generation"])
            generation_buckets[generation].append(generation_row)
            for key, value in (generation_row.get("status_counts_this_generation") or {}).items():
                status_counts[generation][key] += int(value)
            for key, value in (generation_row.get("strategy_counts_this_generation") or {}).items():
                strategy_counts[generation][key] += int(value)

    generation_rows: list[dict[str, Any]] = []
    for generation in sorted(generation_buckets):
        rows = [row for row in generation_buckets[generation] if row]
        archive_rows = archive_buckets.get(generation, [])
        generation_rows.append(
            {
                "generation": generation,
                "problem_count": len(rows),
                "functionality_mean": _mean(
                    [
                        _safe_float((row.get("success_rates") or {}).get("total_functionality"))
                        for row in rows
                    ]
                ),
                "synthesis_mean": _mean(
                    [
                        _safe_float((row.get("success_rates") or {}).get("total_synthesis_ppa"))
                        for row in rows
                    ]
                ),
                "best_score_mean": _mean(
                    [
                        _safe_float((row.get("generation_ppa") or {}).get("best_score"))
                        for row in rows
                    ]
                ),
                "average_score_mean": _mean(
                    [
                        _safe_float((row.get("generation_ppa") or {}).get("average_score"))
                        for row in rows
                    ]
                ),
                "diff_success_rate_mean": _mean(
                    [
                        _safe_float((row.get("diff_stats") or {}).get("success_rate"))
                        for row in rows
                    ]
                ),
                "coverage_mean": _mean([_safe_float(row.get("coverage")) for row in archive_rows]),
                "qd_score_mean": _mean([_safe_float(row.get("qd_score")) for row in archive_rows]),
                "best_quality_mean": _mean([_safe_float(row.get("best_quality")) for row in archive_rows]),
                "new_filled_cells_mean": _mean([_safe_float(row.get("new_filled_cells")) for row in archive_rows]),
                "replaced_cells_mean": _mean([_safe_float(row.get("replaced_cells")) for row in archive_rows]),
            }
        )

    status_rows = [
        {"generation": generation, **dict(counter)}
        for generation, counter in sorted(status_counts.items())
    ]
    strategy_rows = [
        {"generation": generation, **dict(counter)}
        for generation, counter in sorted(strategy_counts.items())
    ]

    summary = {
        "backend": backend,
        "problem_count": len(per_problem_rows),
        "has_qd_archive": has_qd_archive,
        "functionality_mean": _mean([row["functionality_rate"] for row in per_problem_rows]),
        "synthesis_mean": _mean([row["synthesis_rate"] for row in per_problem_rows]),
        "best_score_mean": _mean([row["best_score"] for row in per_problem_rows]),
        "runtime_seconds_mean": _mean([row["runtime_seconds"] for row in per_problem_rows]),
        "total_llm_api_calls": int(
            sum(
                int(_load_json(problem_root / f"{problem}_summary.json").get("total_llm_api_calls", 0))
                for _, problem, problem_root in problem_roots
            )
        ),
    }
    return summary, per_problem_rows, generation_rows, status_rows, strategy_rows


def generate_evolutionary_reports(
    *,
    subset_config: Path,
    backend_runs: list[tuple[str, Path]],
    output_dir: Path,
) -> dict[str, Any]:
    selected = _load_selected_problems(subset_config.resolve())
    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    index_lines = [
        "# Evolutionary run reports",
        "",
        f"- subset_config: `{subset_config.resolve()}`",
        f"- selected_problem_count: `{len(selected)}`",
        "",
        "## Backends",
        "",
    ]
    backend_payloads: dict[str, Any] = {}

    for backend, backend_root in backend_runs:
        backend_dir = output_dir / backend
        backend_dir.mkdir(parents=True, exist_ok=True)
        summary, per_problem_rows, generation_rows, status_rows, strategy_rows = _build_backend_summary(
            backend=backend,
            backend_root=backend_root,
            selected=selected,
        )
        _write_csv(
            backend_dir / "per_problem_summary.csv",
            per_problem_rows,
            [
                "benchmark",
                "problem",
                "functionality_rate",
                "synthesis_rate",
                "best_score",
                "runtime_seconds",
                "final_coverage",
                "final_qd_score",
            ],
        )
        _write_csv(
            backend_dir / "generation_metrics.csv",
            generation_rows,
            [
                "generation",
                "problem_count",
                "functionality_mean",
                "synthesis_mean",
                "best_score_mean",
                "average_score_mean",
                "diff_success_rate_mean",
                "coverage_mean",
                "qd_score_mean",
                "best_quality_mean",
                "new_filled_cells_mean",
                "replaced_cells_mean",
            ],
        )
        _write_csv(
            backend_dir / "generation_status_counts.csv",
            status_rows,
            sorted(
                {key for row in status_rows for key in row.keys()},
                key=lambda item: (item != "generation", item),
            ),
        )
        _write_csv(
            backend_dir / "generation_strategy_counts.csv",
            strategy_rows,
            sorted(
                {key for row in strategy_rows for key in row.keys()},
                key=lambda item: (item != "generation", item),
            ),
        )
        summary_payload = {
            "summary": summary,
            "per_problem_rows": per_problem_rows,
            "generation_rows": generation_rows,
            "status_rows": status_rows,
            "strategy_rows": strategy_rows,
        }
        (backend_dir / "summary.json").write_text(
            json.dumps(summary_payload, indent=2) + "\n",
            encoding="utf-8",
        )
        _plot_generation_rates(backend_dir / "generation_rates.png", generation_rows)
        _plot_generation_scores(backend_dir / "generation_scores.png", generation_rows)
        if summary["has_qd_archive"]:
            _plot_qd_archive_metrics(backend_dir / "generation_archive_metrics.png", generation_rows)
        _write_backend_report(
            backend_dir / "report.md",
            backend=backend,
            summary=summary,
            per_problem_rows=per_problem_rows,
            generation_rows=generation_rows,
            status_rows=status_rows,
            strategy_rows=strategy_rows,
        )
        index_lines.append(f"- `{backend}`: [report.md]({backend}/report.md)")
        backend_payloads[backend] = summary_payload

    index_path = output_dir / "report.md"
    index_path.write_text("\n".join(index_lines) + "\n", encoding="utf-8")
    return {
        "output_dir": str(output_dir),
        "report_path": str(index_path),
        "backends": backend_payloads,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate per-backend evolutionary reports from finished run roots."
    )
    parser.add_argument(
        "--subset-config",
        required=True,
        type=Path,
        help="Subset config used to select problems.",
    )
    parser.add_argument(
        "--backend-run",
        action="append",
        default=[],
        type=_parse_backend_run,
        help="Backend label and experiment root in the form backend=/path/to/root",
    )
    parser.add_argument(
        "--output-dir",
        required=True,
        type=Path,
        help="Directory to write reports into.",
    )
    args = parser.parse_args()
    generate_evolutionary_reports(
        subset_config=args.subset_config,
        backend_runs=args.backend_run,
        output_dir=args.output_dir,
    )


if __name__ == "__main__":
    main()
