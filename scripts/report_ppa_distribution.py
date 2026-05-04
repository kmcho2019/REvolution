#!/usr/bin/env python3
# pyright: reportMissingImports=false, reportMissingModuleSource=false
"""Generate contour-shaded successful-candidate PPA distribution figures."""

from __future__ import annotations

import argparse
import csv
import json
import math
import os
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Literal, cast

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import matplotlib.tri as mtri
import yaml
from matplotlib.colors import Normalize

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

from revolution.qd.scoring import CircuitType, compute_quality_score  # noqa: E402
from revolution.qd.successful_candidate_catalog import (  # noqa: E402
    SuccessfulCandidateRecord,
    load_successful_candidate_catalog,
)


PlotView = Literal["absolute", "gain"]

PAIR_SPECS = {
    "combinational": (("power", "area", "power_vs_area"),),
    "sequential": (
        ("power", "area", "power_vs_area"),
        ("power", "eff_clk_period", "power_vs_effective_clock_period"),
        ("area", "eff_clk_period", "area_vs_effective_clock_period"),
    ),
}
ABSOLUTE_LABELS = {
    "power": "Power",
    "area": "Area",
    "eff_clk_period": "Effective clock period",
}
GAIN_LABELS = {
    "power": "Power gain",
    "area": "Area gain",
    "eff_clk_period": "Timing gain",
}
GAIN_KEYS = {
    "power": "g_P",
    "area": "g_A",
    "eff_clk_period": "g_T",
}
CSV_FIELDS = [
    "backend",
    "benchmark",
    "problem",
    "circuit_type",
    "generation",
    "candidate_id",
    "strategy",
    "source",
    "score_from_run",
    "ppa_score",
    "area",
    "power",
    "eff_clk_period",
    "ref_area",
    "ref_power",
    "ref_eff_clk_period",
    "g_A",
    "g_P",
    "g_T",
    "candidate_dir",
    "report_path",
]


@dataclass(frozen=True)
class PpaRow:
    values: dict[str, Any]

    @property
    def backend(self) -> str:
        return str(self.values["backend"])

    @property
    def benchmark(self) -> str:
        return str(self.values["benchmark"])

    @property
    def problem(self) -> str:
        return str(self.values["problem"])

    @property
    def circuit_type(self) -> str:
        return str(self.values["circuit_type"])


def _parse_backend_run(value: str) -> tuple[str, Path]:
    if "=" not in value:
        raise argparse.ArgumentTypeError(f"Expected BACKEND=PATH, got {value!r}")
    backend, raw_path = value.split("=", 1)
    assert backend
    return backend, Path(raw_path).expanduser().resolve()


def _discover_backend_runs(run_root: Path) -> list[tuple[str, Path]]:
    runs: list[tuple[str, Path]] = []
    for child in sorted(run_root.iterdir()):
        if not child.is_dir() or child.name == "final_analysis":
            continue
        if any(path.name.endswith("_summary.json") for path in child.rglob("*_summary.json")):
            runs.append((child.name, child.resolve()))
    assert runs
    return runs


def _load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    selected = payload["selected_problems"]
    assert isinstance(selected, list)
    problems: list[tuple[str, str]] = []
    for item in selected:
        assert isinstance(item, dict)
        benchmark = item["benchmark"]
        problem = item["problem"]
        assert isinstance(benchmark, str)
        assert isinstance(problem, str)
        problems.append((benchmark, problem))
    assert problems
    return problems


def _metric(row: PpaRow, metric_name: str, view: PlotView) -> float:
    if view == "absolute":
        value = row.values[metric_name]
    elif view == "gain":
        value = row.values[GAIN_KEYS[metric_name]]
    else:
        raise AssertionError(f"unknown plot view: {view}")
    assert isinstance(value, float)
    return value


def _reference_metric(reference: dict[str, Any], metric_name: str, view: PlotView) -> float:
    if view == "absolute":
        value = reference[f"ref_{metric_name}"]
        assert isinstance(value, float)
        return value
    if view == "gain":
        return 0.0
    raise AssertionError(f"unknown plot view: {view}")


def _axis_label(metric_name: str, view: PlotView) -> str:
    if view == "absolute":
        return ABSOLUTE_LABELS[metric_name]
    if view == "gain":
        return GAIN_LABELS[metric_name]
    raise AssertionError(f"unknown plot view: {view}")


def _axis_limits(values: list[float], reference: float) -> tuple[float, float]:
    assert values
    low = min(values + [reference])
    high = max(values + [reference])
    if math.isclose(low, high):
        pad = max(abs(low) * 0.1, 0.1)
        return low - pad, high + pad
    pad = (high - low) * 0.08
    return low - pad, high + pad


def _surface_points(
    xs: list[float],
    ys: list[float],
    zs: list[float],
) -> tuple[list[float], list[float], list[float]]:
    grouped: dict[tuple[float, float], list[float]] = {}
    for x_value, y_value, z_value in zip(xs, ys, zs, strict=True):
        grouped.setdefault((round(x_value, 12), round(y_value, 12)), []).append(z_value)
    out_xs: list[float] = []
    out_ys: list[float] = []
    out_zs: list[float] = []
    for (x_value, y_value), values in grouped.items():
        out_xs.append(x_value)
        out_ys.append(y_value)
        out_zs.append(sum(values) / len(values))
    return out_xs, out_ys, out_zs


def _collinear(xs: list[float], ys: list[float]) -> bool:
    if len(xs) < 3:
        return True
    x0, y0 = xs[0], ys[0]
    x1, y1 = xs[1], ys[1]
    return all(
        abs((x1 - x0) * (ys[index] - y0) - (xs[index] - x0) * (y1 - y0)) <= 1e-12
        for index in range(2, len(xs))
    )


def _mask_flat_triangles(triangulation: mtri.Triangulation) -> None:
    mask: list[bool] = []
    for triangle in triangulation.triangles:
        x0, x1, x2 = triangulation.x[triangle]
        y0, y1, y2 = triangulation.y[triangle]
        area_twice = abs((x1 - x0) * (y2 - y0) - (x2 - x0) * (y1 - y0))
        mask.append(area_twice <= 1e-12)
    if any(mask):
        triangulation.set_mask(mask)


def _front_points(xs: list[float], ys: list[float], view: PlotView) -> list[tuple[float, float]]:
    points = list(dict.fromkeys(zip(xs, ys, strict=True)))
    front: list[tuple[float, float]] = []
    for x_value, y_value in points:
        dominated = False
        for other_x, other_y in points:
            if view == "absolute":
                no_worse = other_x <= x_value and other_y <= y_value
                better = other_x < x_value or other_y < y_value
            elif view == "gain":
                no_worse = other_x >= x_value and other_y >= y_value
                better = other_x > x_value or other_y > y_value
            else:
                raise AssertionError(f"unknown plot view: {view}")
            if no_worse and better:
                dominated = True
                break
        if not dominated:
            front.append((x_value, y_value))
    return sorted(front)


def _layout(count: int) -> tuple[int, int]:
    if count <= 1:
        return 1, 1
    if count <= 2:
        return 1, 2
    if count <= 4:
        return 2, 2
    return 2, 3


def _format_csv_value(value: Any) -> Any:
    if isinstance(value, float):
        return f"{value:.12g}"
    if value is None:
        return ""
    return value


def _write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: _format_csv_value(row.get(field)) for field in fields})


def _row_from_record(record: SuccessfulCandidateRecord) -> PpaRow:
    assert record.circuit_type in PAIR_SPECS
    circuit_type = cast(CircuitType, record.circuit_type)
    ppa_score, components = compute_quality_score(
        record.ppa_metrics,
        record.ref_ppa_metrics,
        circuit_type=circuit_type,
    )
    values = {
        "backend": record.backend,
        "benchmark": record.benchmark,
        "problem": record.problem,
        "circuit_type": record.circuit_type,
        "generation": record.generation,
        "candidate_id": record.candidate_id,
        "strategy": record.strategy,
        "source": record.source,
        "score_from_run": record.score,
        "ppa_score": ppa_score,
        "area": float(record.ppa_metrics["area"]),
        "power": float(record.ppa_metrics["power"]),
        "eff_clk_period": float(record.ppa_metrics.get("eff_clk_period", 0.0)),
        "ref_area": float(record.ref_ppa_metrics["area"]),
        "ref_power": float(record.ref_ppa_metrics["power"]),
        "ref_eff_clk_period": float(record.ref_ppa_metrics.get("eff_clk_period", 0.0)),
        "g_A": float(components["g_A"]),
        "g_P": float(components["g_P"]),
        "g_T": float(components["g_T"]),
        "candidate_dir": str(record.candidate_dir) if record.candidate_dir is not None else "",
        "report_path": record.report_path or "",
    }
    return PpaRow(values)


def _best_rows(rows: list[PpaRow]) -> list[dict[str, Any]]:
    best: dict[tuple[str, str, str], PpaRow] = {}
    for row in rows:
        key = (row.backend, row.benchmark, row.problem)
        current = best.get(key)
        if current is None or row.values["ppa_score"] > current.values["ppa_score"]:
            best[key] = row
    return [best[key].values for key in sorted(best)]


def _plot_group(
    *,
    output_dir: Path,
    title: str,
    methods: list[str],
    rows_by_backend: dict[str, list[PpaRow]],
    reference: dict[str, Any],
    view: PlotView,
    x_metric: str,
    y_metric: str,
) -> None:
    all_rows = [row for method in methods for row in rows_by_backend.get(method, [])]
    assert all_rows
    scores = [float(row.values["ppa_score"]) for row in all_rows]
    score_low = min(scores)
    score_high = max(scores)
    if math.isclose(score_low, score_high):
        score_low -= 0.1
        score_high += 0.1
    norm = Normalize(vmin=score_low, vmax=score_high)
    ref_x = _reference_metric(reference, x_metric, view)
    ref_y = _reference_metric(reference, y_metric, view)
    x_values = [_metric(row, x_metric, view) for row in all_rows]
    y_values = [_metric(row, y_metric, view) for row in all_rows]
    rows_count, cols_count = _layout(len(methods))
    fig, axes = plt.subplots(
        rows_count,
        cols_count,
        figsize=(cols_count * 5.0, rows_count * 4.2),
        sharex=True,
        sharey=True,
    )
    axes_list = list(axes.flat) if hasattr(axes, "flat") else [axes]
    mappable = None
    for axis, backend in zip(axes_list, methods):
        subset = rows_by_backend.get(backend, [])
        xs = [_metric(row, x_metric, view) for row in subset]
        ys = [_metric(row, y_metric, view) for row in subset]
        zs = [float(row.values["ppa_score"]) for row in subset]
        surface_xs, surface_ys, surface_zs = _surface_points(xs, ys, zs)
        if len(surface_xs) >= 3 and not _collinear(surface_xs, surface_ys):
            triangulation = mtri.Triangulation(surface_xs, surface_ys)
            _mask_flat_triangles(triangulation)
            mappable = axis.tricontourf(
                triangulation,
                surface_zs,
                levels=12,
                cmap="viridis",
                norm=norm,
                alpha=0.42,
            )
            axis.tricontour(
                triangulation,
                surface_zs,
                levels=8,
                colors="white",
                linewidths=0.45,
                alpha=0.45,
            )
        if xs:
            mappable = axis.scatter(
                xs,
                ys,
                c=zs,
                cmap="viridis",
                norm=norm,
                s=28,
                edgecolors="black",
                linewidths=0.25,
                alpha=0.9,
            )
            front = _front_points(xs, ys, view)
            if len(front) >= 2:
                axis.plot(
                    [point[0] for point in front],
                    [point[1] for point in front],
                    color="black",
                    linewidth=1.8,
                    alpha=0.85,
                    zorder=5,
                )
        axis.scatter([ref_x], [ref_y], marker="*", s=150, color="crimson", zorder=4)
        if view == "gain":
            axis.axhline(0.0, color="#777777", linewidth=0.8, linestyle="--")
            axis.axvline(0.0, color="#777777", linewidth=0.8, linestyle="--")
        axis.set_xlim(*_axis_limits(x_values, ref_x))
        axis.set_ylim(*_axis_limits(y_values, ref_y))
        axis.grid(True, alpha=0.25)
        axis.set_title(f"{backend} ({len(subset)})", fontsize=10)
        axis.set_xlabel(_axis_label(x_metric, view))
        axis.set_ylabel(_axis_label(y_metric, view))
    for axis in axes_list[len(methods):]:
        axis.axis("off")
    fig.suptitle(title, fontsize=13)
    fig.subplots_adjust(left=0.08, right=0.88, top=0.84, bottom=0.13, wspace=0.22, hspace=0.35)
    if mappable is not None:
        colorbar_axis = fig.add_axes([0.90, 0.16, 0.018, 0.66])
        fig.colorbar(mappable, cax=colorbar_axis).set_label("PPA score")
    output_dir.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_dir, dpi=220, bbox_inches="tight")
    plt.close(fig)


def _write_figures(output_dir: Path, rows: list[PpaRow], backend_order: list[str]) -> int:
    figure_count = 0
    references: dict[tuple[str, str], dict[str, Any]] = {}
    grouped: dict[tuple[str, str, str], dict[str, list[PpaRow]]] = {}
    for row in rows:
        references.setdefault(
            (row.benchmark, row.problem),
            {
                "benchmark": row.benchmark,
                "problem": row.problem,
                "circuit_type": row.circuit_type,
                "ref_area": row.values["ref_area"],
                "ref_power": row.values["ref_power"],
                "ref_eff_clk_period": row.values["ref_eff_clk_period"],
            },
        )
        grouped.setdefault((row.benchmark, row.problem, row.circuit_type), {}).setdefault(
            row.backend, []
        ).append(row)
    for (benchmark, problem, circuit_type), rows_by_backend in sorted(grouped.items()):
        methods = [backend for backend in backend_order if backend in rows_by_backend]
        reference = references[(benchmark, problem)]
        for view in ("absolute", "gain"):
            for x_metric, y_metric, slug in PAIR_SPECS[circuit_type]:
                _plot_group(
                    output_dir=(
                        output_dir
                        / "figures"
                        / "all_backends"
                        / benchmark
                        / problem
                        / view
                        / f"{slug}.png"
                    ),
                    title=f"{benchmark}/{problem} {view} {slug}",
                    methods=methods,
                    rows_by_backend=rows_by_backend,
                    reference=reference,
                    view=view,
                    x_metric=x_metric,
                    y_metric=y_metric,
                )
                figure_count += 1
                if "classic" not in methods:
                    continue
                for backend in methods:
                    if backend == "classic":
                        continue
                    _plot_group(
                        output_dir=(
                            output_dir
                            / "figures"
                            / "classic_vs"
                            / backend
                            / benchmark
                            / problem
                            / view
                            / f"{slug}.png"
                        ),
                        title=f"{benchmark}/{problem} classic vs {backend} {view} {slug}",
                        methods=["classic", backend],
                        rows_by_backend=rows_by_backend,
                        reference=reference,
                        view=view,
                        x_metric=x_metric,
                        y_metric=y_metric,
                    )
                    figure_count += 1
    return figure_count


def _write_report(output_dir: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# PPA Distribution Analysis",
        "",
        f"- candidate_count: `{summary['candidate_count']}`",
        f"- reference_problem_count: `{summary['reference_problem_count']}`",
        f"- best_backend_problem_count: `{summary['best_backend_problem_count']}`",
        f"- figure_count: `{summary['figure_count']}`",
        "",
        "## Outputs",
        "",
        "- candidates: [ppa_candidates.csv](data/ppa_candidates.csv)",
        "- best candidates: [best_candidate_by_backend_problem.csv](data/best_candidate_by_backend_problem.csv)",
        "- references: [reference_ppa_metrics.csv](data/reference_ppa_metrics.csv)",
        "- all-backend figures: [figures/all_backends](figures/all_backends)",
        "- classic-vs figures: [figures/classic_vs](figures/classic_vs)",
        "",
        "Figures use filled score contours when enough non-collinear candidates are "
        "available, white contour lines for local score levels, black projected "
        "Pareto-front lines, and a red star for the reference design.",
        "",
        "## Problems",
        "",
        "| Benchmark | Problem | Circuit | Candidates | Figure Root |",
        "| --- | --- | --- | ---: | --- |",
    ]
    for row in summary["problems"]:
        figure_root = f"figures/all_backends/{row['benchmark']}/{row['problem']}"
        lines.append(
            f"| `{row['benchmark']}` | `{row['problem']}` | `{row['circuit_type']}` | "
            f"{row['candidate_count']} | [{figure_root}]({figure_root}) |"
        )
    lines.append("")
    (output_dir / "report.md").write_text("\n".join(lines), encoding="utf-8")


def generate_ppa_distribution_report(
    *,
    subset_config: Path,
    backend_runs: list[tuple[str, Path]],
    output_dir: Path,
) -> dict[str, Any]:
    """Generate candidate-level PPA scatter figures for a completed run."""

    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    problems = _load_subset_problems(subset_config.resolve())
    backend_roots = {backend: root.resolve() for backend, root in backend_runs}
    catalog = load_successful_candidate_catalog(
        backend_roots=backend_roots,
        allowed_problems=set(problems),
    )
    rows = [_row_from_record(record) for record in catalog.candidates]
    assert rows
    backend_order = [backend for backend, _ in backend_runs]
    reference_by_problem: dict[tuple[str, str], dict[str, Any]] = {}
    for context in catalog.problem_runs:
        reference_by_problem.setdefault(
            (context.benchmark, context.problem),
            {
                "benchmark": context.benchmark,
                "problem": context.problem,
                "circuit_type": context.circuit_type,
                "ref_area": context.ref_ppa_metrics["area"],
                "ref_power": context.ref_ppa_metrics["power"],
                "ref_eff_clk_period": context.ref_ppa_metrics.get("eff_clk_period", 0.0),
                "summary_path": str(context.summary_path),
            },
        )
    reference_rows = [reference_by_problem[key] for key in sorted(reference_by_problem)]
    _write_csv(output_dir / "data" / "ppa_candidates.csv", [row.values for row in rows], CSV_FIELDS)
    _write_csv(output_dir / "data" / "reference_ppa_metrics.csv", reference_rows, list(reference_rows[0]))
    _write_csv(output_dir / "data" / "best_candidate_by_backend_problem.csv", _best_rows(rows), CSV_FIELDS)
    figure_count = _write_figures(output_dir, rows, backend_order)

    problem_rows: list[dict[str, Any]] = []
    for benchmark, problem in problems:
        problem_candidates = [row for row in rows if row.benchmark == benchmark and row.problem == problem]
        if not problem_candidates:
            continue
        circuit_type = problem_candidates[0].circuit_type
        problem_rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "circuit_type": circuit_type,
                "candidate_count": len(problem_candidates),
                "backends": {
                    backend: sum(1 for row in problem_candidates if row.backend == backend)
                    for backend in backend_order
                },
            }
        )
    summary = {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "subset_config": str(subset_config.resolve()),
        "output_dir": str(output_dir),
        "backend_runs": [
            {"backend": backend, "root": str(root.resolve())}
            for backend, root in backend_runs
        ],
        "candidate_count": len(rows),
        "reference_problem_count": len(reference_rows),
        "best_backend_problem_count": len(_best_rows(rows)),
        "figure_count": figure_count,
        "problems": problem_rows,
        "warnings": list(catalog.warnings),
        "report_path": str(output_dir / "report.md"),
    }
    (output_dir / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    _write_report(output_dir, summary)
    return {
        "report_path": str(output_dir / "report.md"),
        "summary_path": str(output_dir / "summary.json"),
        "summary": summary,
    }


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Generate successful-candidate PPA distribution figures."
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--run-root", type=Path)
    source.add_argument("--backend_run", action="append", type=_parse_backend_run, default=[])
    parser.add_argument("--subset-config", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, default=None)
    return parser


def main() -> int:
    args = build_argument_parser().parse_args()
    backend_runs = args.backend_run or _discover_backend_runs(args.run_root.resolve())
    if args.output_dir is not None:
        output_dir = args.output_dir.resolve()
    elif args.run_root is not None:
        output_dir = args.run_root.resolve() / "ppa_distribution"
    else:
        raise ValueError("--output-dir is required with --backend_run")
    result = generate_ppa_distribution_report(
        subset_config=args.subset_config,
        backend_runs=backend_runs,
        output_dir=output_dir,
    )
    print(json.dumps(result["summary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
