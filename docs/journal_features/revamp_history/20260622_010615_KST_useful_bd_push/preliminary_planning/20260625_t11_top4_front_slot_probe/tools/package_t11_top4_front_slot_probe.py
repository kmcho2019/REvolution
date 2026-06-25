#!/usr/bin/env python3
"""Package the T11 top-4 front-slot live probe."""

from __future__ import annotations

import csv
import json
from pathlib import Path

import matplotlib.pyplot as plt


PACKAGE = Path(__file__).resolve().parents[1]
ANALYSIS = Path(
    "exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/"
    "live/final_analysis_with_t11_top4_front_slot"
)
RUN_ROOT = Path(
    "exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live"
)
BASE = "classic_revolution_8x5"
NEW = "t11_runtime_top4_front_slot_8x5"
BACKENDS = [
    BASE,
    "masterrtl_structural_front_slot_8x5",
    NEW,
    "masterrtl_structural_mix_8x5",
    "code_thought_sr_front_slot_8x5",
    "qwen_canonical_rtl_pca3_8x5",
]
TableValue = str | float
TableRow = dict[str, TableValue]


def main() -> None:
    assert ANALYSIS.is_dir(), ANALYSIS
    tables = PACKAGE / "tables"
    figures = PACKAGE / "figures"
    reports = PACKAGE / "reports"
    tables.mkdir(exist_ok=True)
    figures.mkdir(exist_ok=True)
    reports.mkdir(exist_ok=True)

    aggregate = read_csv(ANALYSIS / "pareto_analysis/aggregate_backend_metrics.csv")
    problem_rows = read_csv(ANALYSIS / "pareto_analysis/backend_problem_metrics.csv")
    copy_text(
        ANALYSIS / "pareto_analysis/aggregate_backend_metrics.csv",
        tables / "aggregate_backend_metrics.csv",
    )
    copy_text(
        ANALYSIS / "pareto_analysis/backend_problem_metrics.csv",
        tables / "backend_problem_metrics.csv",
    )
    copy_text(
        ANALYSIS / "ppa_distribution/data/ppa_candidates.csv",
        tables / "ppa_candidates.csv",
    )
    copy_text(
        ANALYSIS / "backend_comparison.md",
        reports / "backend_comparison.md",
    )
    copy_text(
        ANALYSIS / "pareto_analysis/report.md",
        reports / "pareto_report.md",
    )
    copy_text(
        ANALYSIS / "ppa_distribution/report.md",
        reports / "ppa_distribution_report.md",
    )

    deltas = problem_deltas(problem_rows)
    write_csv(tables / "t11_top4_front_slot_problem_deltas.csv", deltas)
    write_json(tables / "run_summary.json", run_summary(aggregate, deltas))
    plot_mean_hv(aggregate, figures / "mean_hv_by_backend.png")
    plot_problem_deltas(deltas, figures / "t11_top4_front_slot_hv_delta.png")


def read_csv(path: Path) -> list[dict[str, str]]:
    assert path.is_file(), path
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))


def write_csv(path: Path, rows: list[TableRow]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def copy_text(source: Path, target: Path) -> None:
    assert source.is_file(), source
    target.write_text(source.read_text(encoding="utf-8").rstrip() + "\n", encoding="utf-8")


def problem_deltas(rows: list[dict[str, str]]) -> list[TableRow]:
    by_key = {(r["backend"], r["benchmark"], r["problem"]): r for r in rows}
    result: list[TableRow] = []
    for backend, benchmark, problem in sorted(by_key):
        if backend != BASE:
            continue
        base = by_key[(BASE, benchmark, problem)]
        new = by_key[(NEW, benchmark, problem)]
        result.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "classic_hv": fnum(base["hypervolume"]),
                "t11_hv": fnum(new["hypervolume"]),
                "hv_delta": fnum(new["hypervolume"]) - fnum(base["hypervolume"]),
                "classic_pareto_points": fnum(base["pareto_point_count"]),
                "t11_pareto_points": fnum(new["pareto_point_count"]),
                "pareto_point_delta": fnum(new["pareto_point_count"])
                - fnum(base["pareto_point_count"]),
                "classic_ref_beating": fnum(base["reference_beating_count"]),
                "t11_ref_beating": fnum(new["reference_beating_count"]),
                "ref_beating_delta": fnum(new["reference_beating_count"])
                - fnum(base["reference_beating_count"]),
            }
        )
    return result


def run_summary(aggregate: list[dict[str, str]], deltas: list[TableRow]) -> dict[str, object]:
    all_rows = {
        row["backend"]: row for row in aggregate if row["benchmark"] == "ALL"
    }
    new_row = all_rows[NEW]
    base_row = all_rows[BASE]
    return {
        "run_root": str(RUN_ROOT),
        "analysis_root": str(ANALYSIS),
        "candidate": NEW,
        "decision": "diagnostic_not_promoted",
        "mean_hv": fnum(new_row["mean_hypervolume"]),
        "classic_mean_hv": fnum(base_row["mean_hypervolume"]),
        "mean_hv_delta": fnum(new_row["mean_hypervolume"])
        - fnum(base_row["mean_hypervolume"]),
        "mean_pareto_points": fnum(new_row["mean_pareto_point_count"]),
        "classic_mean_pareto_points": fnum(base_row["mean_pareto_point_count"]),
        "mean_reference_beating": fnum(new_row["mean_reference_beating_count"]),
        "classic_mean_reference_beating": fnum(
            base_row["mean_reference_beating_count"]
        ),
        "hv_wins": int(new_row["hypervolume_win_count"]),
        "problem_hv_wins_vs_classic": sum(
            1 for row in deltas if row_float(row, "hv_delta") > 0.0
        ),
        "problem_count": len(deltas),
        "reporting_caveat": (
            "report_final_analysis_bundle was interrupted during source-aligned "
            "design-space feature recovery after Pareto, PPA, and evolutionary "
            "reports were written."
        ),
    }


def plot_mean_hv(rows: list[dict[str, str]], path: Path) -> None:
    selected = [row for row in rows if row["benchmark"] == "ALL" and row["backend"] in BACKENDS]
    values = [fnum(row["mean_hypervolume"]) for row in selected]
    labels = [short_name(row["backend"]) for row in selected]
    colors = ["#4c78a8" if row["backend"] == BASE else "#f58518" for row in selected]
    fig, ax = plt.subplots(figsize=(10.5, 4.7))
    ax.bar(labels, values, color=colors)
    ax.set_ylabel("Mean hypervolume")
    ax.set_title("Frozen 8-design screen: mean PPA hypervolume")
    ax.grid(axis="y", alpha=0.25)
    ax.set_axisbelow(True)
    for index, value in enumerate(values):
        ax.text(index, value + 0.003, f"{value:.4f}", ha="center", fontsize=9)
    fig.autofmt_xdate(rotation=18, ha="right")
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_problem_deltas(rows: list[TableRow], path: Path) -> None:
    labels = [str(row["problem"]).replace("Prob", "P") for row in rows]
    values = [row_float(row, "hv_delta") for row in rows]
    colors = ["#54a24b" if value > 0.0 else "#e45756" if value < 0.0 else "#9d9d9d" for value in values]
    fig, ax = plt.subplots(figsize=(10.0, 4.4))
    ax.axhline(0.0, color="#333333", linewidth=1.0)
    ax.bar(labels, values, color=colors)
    ax.set_ylabel("HV delta vs classic")
    ax.set_title("T11 top-4 front-slot: per-problem HV delta")
    ax.grid(axis="y", alpha=0.25)
    ax.set_axisbelow(True)
    for index, value in enumerate(values):
        if abs(value) < 0.001:
            continue
        va = "bottom" if value >= 0 else "top"
        offset = 0.002 if value >= 0 else -0.002
        ax.text(index, value + offset, f"{value:+.4f}", ha="center", va=va, fontsize=8)
    fig.autofmt_xdate(rotation=25, ha="right")
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def fnum(value: str) -> float:
    return float(value)


def row_float(row: TableRow, key: str) -> float:
    value = row[key]
    assert isinstance(value, float)
    return value


def short_name(name: str) -> str:
    return {
        "classic_revolution_8x5": "Classic",
        "code_thought_sr_front_slot_8x5": "SR front-slot",
        "masterrtl_structural_mix_8x5": "MasterRTL",
        "masterrtl_structural_front_slot_8x5": "MasterRTL front-slot",
        "qwen_canonical_rtl_pca3_8x5": "Qwen3",
        "t11_runtime_top4_front_slot_8x5": "T11 top-4 front-slot",
    }[name]


if __name__ == "__main__":
    main()
