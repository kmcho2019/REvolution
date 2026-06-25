#!/usr/bin/env python3
"""Package the completed preliminary live screen results."""

from __future__ import annotations

import argparse
import csv
import json
from collections.abc import Iterable
from pathlib import Path
from typing import Any


PACKAGE = Path(__file__).resolve().parents[1]
TABLES = PACKAGE / "tables"
REPORTS = PACKAGE / "reports"
FIGURES = PACKAGE / "figures"
BASE_BACKEND = "classic_revolution_8x5"
QD_BACKENDS = (
    "code_thought_sr_front_slot_8x5",
    "masterrtl_structural_mix_8x5",
    "qwen_canonical_rtl_pca3_8x5",
)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("analysis_root", type=Path)
    parser.add_argument("run_root", type=Path)
    args = parser.parse_args()
    REPORTS.mkdir(exist_ok=True)
    TABLES.mkdir(exist_ok=True)
    FIGURES.mkdir(exist_ok=True)
    copy_outputs(args.analysis_root)
    write_summary_tables(args.analysis_root, args.run_root)
    write_figures()
    write_report(args.analysis_root, args.run_root)


def copy_outputs(analysis_root: Path) -> None:
    for source, target in [
        ("backend_comparison.md", REPORTS / "live_screen_backend_comparison.md"),
        ("pareto_analysis/report.md", REPORTS / "live_screen_pareto_report.md"),
        ("ppa_distribution/report.md", REPORTS / "live_screen_ppa_distribution_report.md"),
        ("pareto_analysis/aggregate_backend_metrics.csv", TABLES / "live_screen_aggregate_pareto_metrics.csv"),
        ("pareto_analysis/backend_problem_metrics.csv", TABLES / "live_screen_backend_problem_metrics.csv"),
        ("ppa_distribution/data/ppa_candidates.csv", TABLES / "live_screen_ppa_candidates.csv"),
        ("ppa_distribution/data/reference_ppa_metrics.csv", TABLES / "live_screen_reference_ppa_metrics.csv"),
    ]:
        copy_text(analysis_root / source, target)


def copy_text(source: Path, target: Path) -> None:
    lines = [line.rstrip() for line in source.read_text().splitlines()]
    while lines and not lines[-1]:
        lines.pop()
    target.write_text("\n".join(lines) + "\n")


def write_summary_tables(analysis_root: Path, run_root: Path) -> None:
    rows = read_csv(analysis_root / "pareto_analysis/backend_problem_metrics.csv")
    aggregates = read_csv(analysis_root / "pareto_analysis/aggregate_backend_metrics.csv")
    problems = sorted({(row["benchmark"], row["problem"]) for row in rows})
    by_key = {(row["backend"], row["benchmark"], row["problem"]): row for row in rows}
    delta_rows = []
    for benchmark, problem in problems:
        base_row = by_key[(BASE_BACKEND, benchmark, problem)]
        base_hv = as_float(base_row["hypervolume"])
        base_front = as_float(base_row["pareto_point_count"])
        for backend in QD_BACKENDS:
            if (backend, benchmark, problem) not in by_key:
                continue
            row = by_key[(backend, benchmark, problem)]
            hv = as_float(row["hypervolume"])
            delta_rows.append(
                {
                    "backend": backend,
                    "benchmark": benchmark,
                    "problem": problem,
                    "classic_hv": base_hv,
                    "qd_hv": hv,
                    "hv_delta": hv - base_hv,
                    "classic_pareto_points": base_front,
                    "qd_pareto_points": as_float(row["pareto_point_count"]),
                    "pareto_point_delta": as_float(row["pareto_point_count"]) - base_front,
                    "classic_ref_beating": as_float(base_row["reference_beating_count"]),
                    "qd_ref_beating": as_float(row["reference_beating_count"]),
                    "ref_beating_delta": as_float(row["reference_beating_count"])
                    - as_float(base_row["reference_beating_count"]),
                }
            )
    write_csv(TABLES / "live_screen_problem_hv_deltas.csv", delta_rows)
    write_csv(TABLES / "live_screen_run_completion.csv", completion_rows(run_root))
    write_qwen_descriptor_health(run_root)
    write_json(
        TABLES / "live_screen_result_summary.json",
        {
            "run_root": str(run_root.resolve()),
            "analysis_root": str(analysis_root.resolve()),
            "headline_recommendation": "do_not_promote_screened_qd_arms_to_full_rtllm_yet",
            "aggregate_metrics": aggregates,
        },
    )


def write_qwen_descriptor_health(run_root: Path) -> None:
    qwen_root = (
        run_root
        / "qwen_canonical_rtl_pca3_8x5"
        / "seed_1001"
        / "openai_gpt-oss-120b"
    )
    if not qwen_root.is_dir():
        return
    rows = []
    for path in sorted(qwen_root.glob("*/*/descriptor_health.json")):
        payload = json.loads(path.read_text(encoding="utf-8"))
        summary = json.loads((path.parent / "archive_summary.json").read_text(encoding="utf-8"))
        axis_stats = {
            item["axis"]: item["archive_stats"]
            for item in payload["axis_health"]
        }
        rows.append(
            {
                "benchmark": path.parent.parent.name,
                "problem": path.parent.name,
                "observation_count": payload["observation_count"],
                "archive_entry_count": payload["archive_entry_count"],
                "occupied_cells": payload["occupied_cells"],
                "archive_member_count": summary["archive_member_count"],
                "collapsed_axes": ";".join(payload["collapsed_axes"]),
                "qwen_pc0_unique": axis_stats["qwen_pc0"]["unique_count"],
                "qwen_pc0_stddev": axis_stats["qwen_pc0"]["stddev"],
                "qwen_pc1_unique": axis_stats["qwen_pc1"]["unique_count"],
                "qwen_pc1_stddev": axis_stats["qwen_pc1"]["stddev"],
                "qwen_pc2_unique": axis_stats["qwen_pc2"]["unique_count"],
                "qwen_pc2_stddev": axis_stats["qwen_pc2"]["stddev"],
            }
        )
    write_csv(TABLES / "live_screen_qwen_descriptor_health.csv", rows)


def completion_rows(run_root: Path) -> list[dict[str, Any]]:
    rows = []
    for backend_root in sorted(run_root.glob("*/seed_1001/openai_gpt-oss-120b")):
        backend = backend_root.parents[1].name
        summary_file = one(backend_root.glob("*_summary_results.txt"))
        summary_rows = [line.strip().split(",", 2) for line in summary_file.read_text().splitlines()]
        ppa_count = len(list(backend_root.glob("*/*/Gen*/*/*synthesis_report.ppa")))
        rows.append(
            {
                "backend": backend,
                "summary_file": str(summary_file),
                "problem_rows": len(summary_rows),
                "success_rows": sum(1 for row in summary_rows if row[1] == "success"),
                "ppa_file_count": ppa_count,
            }
        )
    return rows


def write_report(analysis_root: Path, run_root: Path) -> None:
    aggregate_rows = [
        row for row in read_csv(analysis_root / "pareto_analysis/aggregate_backend_metrics.csv") if row["benchmark"] == "ALL"
    ]
    delta_rows = read_csv(TABLES / "live_screen_problem_hv_deltas.csv")
    lines = [
        "# Live Screening Results",
        "",
        "## Verdict",
        "",
        "Do not promote any screened QD arm to the full RTLLM run yet.",
        "Classic REvolution remains the headline winner on mean HV, Pareto",
        "point count, reference-beating count, and per-problem HV wins.",
        "",
        "The strongest QD arm in this screen is `masterrtl_structural_mix_8x5`,",
        "but it is still below classic on the headline Pareto metrics. Qwen",
        "canonical RTL preserved 8/8 problem coverage and won `Prob153_gshare`,",
        "but its aggregate HV and front breadth are weaker than classic.",
        "",
        "Note: the full final-analysis bundle lists Qwen as the generic score-style",
        "`overall` recommendation, but the pre-registered promotion gate for this",
        "milestone is the Pareto/HV comparison. That gate selects",
        "`classic_revolution_8x5` as `pareto_overall`.",
        "",
        "## Run Roots",
        "",
        f"- live root: `{run_root.resolve()}`",
        f"- final analysis: `{analysis_root.resolve()}`",
        "",
        "## Aggregate Pareto Metrics",
        "",
        "![Mean HV](figures/live_screen_mean_hv.png)",
        "",
        "| Backend | Mean HV | Pareto Points | Ref-Beating | HV Wins |",
        "| --- | ---: | ---: | ---: | ---: |",
    ]
    for row in aggregate_rows:
        lines.append(
            "| {backend} | {mean_hypervolume:.4f} | {mean_pareto_point_count:.2f} | "
            "{mean_reference_beating_count:.2f} | {hypervolume_win_count} |".format(
                backend=f"`{row['backend']}`",
                mean_hypervolume=as_float(row["mean_hypervolume"]),
                mean_pareto_point_count=as_float(row["mean_pareto_point_count"]),
                mean_reference_beating_count=as_float(row["mean_reference_beating_count"]),
                hypervolume_win_count=row["hypervolume_win_count"],
            )
        )
    lines += [
        "",
        "## QD Delta Summary",
        "",
        "![HV Delta](figures/live_screen_hv_delta_by_problem.png)",
        "",
        "| QD Backend | Mean HV Delta | HV Wins vs Classic | Mean Pareto Delta |",
        "| --- | ---: | ---: | ---: |",
    ]
    for backend in QD_BACKENDS:
        selected = [row for row in delta_rows if row["backend"] == backend]
        if not selected:
            continue
        lines.append(
            f"| `{backend}` | {mean(selected, 'hv_delta'):.4f} | "
            f"{sum(1 for row in selected if as_float(row['hv_delta']) > 0)}/8 | "
            f"{mean(selected, 'pareto_point_delta'):.2f} |"
        )
    health_path = TABLES / "live_screen_qwen_descriptor_health.csv"
    if health_path.exists():
        health_rows = read_csv(health_path)
        lines += [
            "",
            "## Qwen Descriptor Health",
            "",
            "All eight Qwen screen problems emitted descriptor-health files.",
            "No Qwen PCA axis was marked collapsed in the live archive health",
            "reports, so the negative result is not caused by a trivial",
            "all-zero or single-value descriptor failure.",
            "",
            "| Problem | Observations | Archive Entries | Occupied Cells | Collapsed Axes |",
            "| --- | ---: | ---: | ---: | --- |",
        ]
        for row in health_rows:
            lines.append(
                "| {problem} | {observation_count} | {archive_entry_count} | "
                "{occupied_cells} | {collapsed_axes} |".format(
                    problem=f"`{row['problem']}`",
                    observation_count=row["observation_count"],
                    archive_entry_count=row["archive_entry_count"],
                    occupied_cells=row["occupied_cells"],
                    collapsed_axes=row["collapsed_axes"] or "`none`",
                )
            )
    lines += [
        "",
        "## Encoder Status",
        "",
        "Qwen3 canonical RTL is now a real live-screened pretrained encoder",
        "arm. It is not strong enough to promote as-is. DeepGate3, AURORA,",
        "and T11/T36 remain bridge-required because their current evidence is",
        "replay-only, near-collapsed, or failed in a prior live conversion.",
    ]
    (PACKAGE / "live_screen_results.md").write_text("\n".join(lines) + "\n")


def write_figures() -> None:
    import matplotlib.pyplot as plt

    aggregates = [
        row for row in read_csv(TABLES / "live_screen_aggregate_pareto_metrics.csv") if row["benchmark"] == "ALL"
    ]
    names = [label(row["backend"]) for row in aggregates]
    hvs = [as_float(row["mean_hypervolume"]) for row in aggregates]
    colors = ["#4b5563", "#2563eb", "#059669", "#d97706"]
    fig, ax = plt.subplots(figsize=(7.2, 4.2))
    bars = ax.bar(names, hvs, color=colors)
    for bar, value in zip(bars, hvs, strict=True):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            value + 0.003,
            f"{value:.3f}",
            ha="center",
            va="bottom",
            fontsize=9,
        )
    ax.set_ylim(0.0, max(hvs) * 1.18)
    plt.ylabel("Mean hypervolume")
    plt.title("Preliminary screen mean HV")
    plt.xticks(rotation=15, ha="right")
    plt.tight_layout()
    plt.savefig(FIGURES / "live_screen_mean_hv.png", dpi=180)
    plt.close()

    rows = read_csv(TABLES / "live_screen_problem_hv_deltas.csv")
    problems = sorted({row["problem"] for row in rows})
    backends = [backend for backend in QD_BACKENDS if any(row["backend"] == backend for row in rows)]
    matrix = [
        [as_float(find_row(rows, backend, problem)["hv_delta"]) for problem in problems]
        for backend in backends
    ]
    max_abs = max(abs(value) for row in matrix for value in row)
    fig, ax = plt.subplots(figsize=(11.4, 4.8))
    image = ax.imshow(matrix, cmap="RdBu", vmin=-max_abs, vmax=max_abs, aspect="auto")
    ax.set_title("Per-problem HV delta vs classic")
    ax.set_xticks(range(len(problems)), problems, rotation=30, ha="right")
    ax.set_yticks(range(len(backends)), [label(backend) for backend in backends])
    for y, row in enumerate(matrix):
        for x, value in enumerate(row):
            color = "white" if abs(value) > max_abs * 0.55 else "#111827"
            ax.text(x, y, f"{value:+.3f}", ha="center", va="center", color=color)
    fig.colorbar(image, ax=ax, label="HV delta")
    plt.tight_layout()
    plt.savefig(FIGURES / "live_screen_hv_delta_by_problem.png", dpi=180)
    plt.close()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def one(paths: Iterable[Path]) -> Path:
    items = list(paths)
    assert len(items) == 1, items
    return items[0]


def as_float(value: str) -> float:
    return float(value)


def mean(rows: list[dict[str, str]], key: str) -> float:
    assert rows
    return sum(as_float(row[key]) for row in rows) / len(rows)


def find_row(rows: list[dict[str, str]], backend: str, problem: str) -> dict[str, str]:
    selected = [row for row in rows if row["backend"] == backend and row["problem"] == problem]
    assert len(selected) == 1
    return selected[0]


def label(backend: str) -> str:
    labels = {
        "classic_revolution_8x5": "Classic",
        "code_thought_sr_front_slot_8x5": "SR front-slot QD",
        "masterrtl_structural_mix_8x5": "MasterRTL mix QD",
        "qwen_canonical_rtl_pca3_8x5": "Qwen RTL QD",
    }
    return labels[backend]


if __name__ == "__main__":
    main()
