#!/usr/bin/env python3
"""Summarize the 20260629 RTLLM representative full suite."""

from __future__ import annotations

import argparse
import csv
import math
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


SUMMARY_FIELDS = [
    "method_key",
    "family",
    "completion_status",
    "contract_status",
    "headline_problem_count",
    "covered_problem_count",
    "mean_hv",
    "mean_hv_auc",
    "mean_pareto_point_count",
    "mean_reference_beating_count",
    "mean_valid_ppa_count",
    "classic_delta_mean_hv",
    "classic_hv_win_count",
    "classic_hv_loss_count",
    "classic_hv_tie_count",
    "command_path",
    "descriptor_summary",
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_csv(path: Path, fields: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: float) -> str:
    assert math.isfinite(value)
    return f"{value:.12g}"


def metric(row: dict[str, str] | None, field: str) -> float:
    if row is None:
        return 0.0
    value = float(row[field])
    assert math.isfinite(value)
    return value


def parse_optional(value: str) -> float | None:
    if value in {"", "not_available"}:
        return None
    parsed = float(value)
    assert math.isfinite(parsed)
    return parsed


def status(doc_root: Path, method: str) -> str:
    if (doc_root / "logs" / f"{method}.done").exists():
        return "done"
    if (doc_root / "logs" / f"{method}.failed").exists():
        return "failed"
    return "not_started"


def method_label(method: str) -> str:
    label = method.removesuffix("_8x5")
    replacements = {
        "classic_revolution": "classic",
        "qwen_canonical_rtl_pca3": "Qwen3 RTL",
        "masterrtl_rf_leafid_structural_delayed": "MasterRTL RF",
        "deepgate_delayed_high_exploit": "DeepGate",
        "rf_deepgate_hybrid_delayed": "RF+DeepGate",
        "aurora_raw_impl_compact_delayed": "AURORA raw",
        "masterrtl_delayed_archive_activation": "MasterRTL QD",
        "fg_qdm_rf_leafid_front_credit": "FG-QDM",
    }
    return replacements.get(label, label)


def load_hv_auc(doc_root: Path) -> dict[tuple[str, str], float]:
    values: dict[tuple[str, str], float] = {}
    root = doc_root / "analysis" / "common_contract"
    for path in sorted(root.glob("*/method_problem_seed_metrics.csv")):
        for row in read_csv(path):
            parsed = parse_optional(row["hv_auc"])
            if parsed is not None:
                values.setdefault((row["method_key"], row["problem"]), parsed)
    return values


def bar(path: Path, rows: list[dict[str, str]], field: str, title: str, ylabel: str) -> None:
    labels = [method_label(row["method_key"]) for row in rows]
    values = [parse_optional(row[field]) or 0.0 for row in rows]
    colors = ["#4c78a8", "#f58518", "#54a24b", "#e45756", "#72b7b2", "#b279a2", "#ff9da6", "#9d755d"]
    fig, ax = plt.subplots(figsize=(11, 5))
    ax.bar(labels, values, color=colors[: len(rows)], edgecolor="#222222", linewidth=0.7)
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.tick_params(axis="x", labelrotation=25)
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def heatmap(path: Path, methods: list[str], problems: list[str], rows: list[dict[str, str]]) -> None:
    value_by_key = {
        (row["method_key"], row["problem"]): float(row["hv_delta_vs_classic"])
        for row in rows
    }
    matrix = []
    for method in methods:
        matrix.append([
            -1 if value_by_key[(method, problem)] < -1e-12 else 1 if value_by_key[(method, problem)] > 1e-12 else 0
            for problem in problems
        ])
    fig, ax = plt.subplots(figsize=(16, 5))
    ax.imshow(matrix, cmap="RdYlGn", vmin=-1, vmax=1, aspect="auto")
    ax.set_yticks(range(len(methods)), [method_label(method) for method in methods])
    ax.set_xticks(range(len(problems)), problems, rotation=90, fontsize=6)
    ax.set_title("Per-problem HV delta sign vs classic")
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--doc-root", type=Path, required=True)
    args = parser.parse_args()

    doc_root = args.doc_root.resolve()
    manifest = read_csv(doc_root / "tables" / "method_manifest.csv")
    problems = [row["problem"] for row in read_csv(doc_root / "tables" / "rtllm_reference_complete_manifest.csv")]
    pareto_rows = read_csv(doc_root / "analysis" / "reference_complete_pareto_analysis" / "backend_problem_metrics.csv")
    pareto = {(row["backend"], row["problem"]): row for row in pareto_rows}
    hv_auc = load_hv_auc(doc_root)
    classic_hv = {
        problem: metric(pareto.get(("classic_revolution_8x5", problem)), "hypervolume")
        for problem in problems
    }

    summary_rows = []
    problem_rows = []
    for method_row in manifest:
        method = method_row["method_key"]
        hv_values = []
        hv_auc_values = []
        valid_counts = []
        pareto_counts = []
        ref_counts = []
        wins = losses = ties = covered = 0
        for problem in problems:
            row = pareto.get((method, problem))
            hv = metric(row, "hypervolume")
            valid = int(metric(row, "candidate_count"))
            points = int(metric(row, "pareto_point_count"))
            refs = int(metric(row, "reference_beating_count"))
            delta = hv - classic_hv[problem]
            if valid > 0:
                covered += 1
            if method == "classic_revolution_8x5" or abs(delta) <= 1e-12:
                ties += 1
            elif delta > 0.0:
                wins += 1
            else:
                losses += 1
            hv_values.append(hv)
            valid_counts.append(valid)
            pareto_counts.append(points)
            ref_counts.append(refs)
            if (method, problem) in hv_auc:
                hv_auc_values.append(hv_auc[(method, problem)])
            problem_rows.append(
                {
                    "method_key": method,
                    "problem": problem,
                    "hypervolume": fmt(hv),
                    "hv_delta_vs_classic": fmt(delta),
                    "valid_ppa_count": str(valid),
                    "pareto_point_count": str(points),
                    "reference_beating_count": str(refs),
                }
            )
        mean_hv = sum(hv_values) / len(problems)
        summary_rows.append(
            {
                "method_key": method,
                "family": method_row["family"],
                "completion_status": status(doc_root, method),
                "contract_status": "available" if any(key[0] == method for key in hv_auc) else "missing",
                "headline_problem_count": str(len(problems)),
                "covered_problem_count": str(covered),
                "mean_hv": fmt(mean_hv),
                "mean_hv_auc": "not_available" if not hv_auc_values else fmt(sum(hv_auc_values) / len(hv_auc_values)),
                "mean_pareto_point_count": fmt(sum(pareto_counts) / len(problems)),
                "mean_reference_beating_count": fmt(sum(ref_counts) / len(problems)),
                "mean_valid_ppa_count": fmt(sum(valid_counts) / len(problems)),
                "classic_delta_mean_hv": "0" if method == "classic_revolution_8x5" else "",
                "classic_hv_win_count": str(wins),
                "classic_hv_loss_count": str(losses),
                "classic_hv_tie_count": str(ties),
                "command_path": method_row["command_path"],
                "descriptor_summary": method_row["descriptor_summary"],
            }
        )

    classic_mean = float(next(row["mean_hv"] for row in summary_rows if row["method_key"] == "classic_revolution_8x5"))
    for row in summary_rows:
        if row["classic_delta_mean_hv"] == "":
            row["classic_delta_mean_hv"] = fmt(float(row["mean_hv"]) - classic_mean)

    write_csv(doc_root / "tables" / "full_suite_method_summary.csv", SUMMARY_FIELDS, summary_rows)
    write_csv(
        doc_root / "tables" / "full_suite_problem_metrics.csv",
        list(problem_rows[0]),
        problem_rows,
    )

    figure_rows = summary_rows
    fig_root = doc_root / "figures"
    bar(fig_root / "mean_hv_by_method.png", figure_rows, "mean_hv", "Mean HV on reference-complete RTLLM", "Mean HV")
    bar(fig_root / "mean_hv_auc_by_method.png", figure_rows, "mean_hv_auc", "Mean HV-AUC from Phase 03.1 viewers", "Mean HV-AUC")
    bar(fig_root / "hv_delta_by_method.png", figure_rows, "classic_delta_mean_hv", "Mean HV delta vs classic", "Delta HV")
    bar(fig_root / "valid_ppa_count_by_method.png", figure_rows, "mean_valid_ppa_count", "Mean valid-PPA candidates per design", "Candidates")
    bar(fig_root / "pareto_points_by_method.png", figure_rows, "mean_pareto_point_count", "Mean Pareto points per design", "Points")
    heatmap(
        fig_root / "hv_win_loss_heatmap.png",
        [row["method_key"] for row in summary_rows if row["method_key"] != "classic_revolution_8x5"],
        problems,
        problem_rows,
    )

    ranked = sorted(summary_rows, key=lambda row: float(row["mean_hv"]), reverse=True)
    lines = [
        "# RTLLM Full Suite Results",
        "",
        "This report is generated from the reference-complete RTLLM subset.",
        "Missing method/problem rows count as zero valid-PPA coverage for the",
        "headline mean HV table.",
        "",
        "## Top Methods By Mean HV",
        "",
        "| Rank | Method | Family | Covered | Mean HV | Delta vs classic | Mean HV-AUC |",
        "| --- | --- | --- | ---: | ---: | ---: | ---: |",
    ]
    for index, row in enumerate(ranked, start=1):
        lines.append(
            f"| {index} | `{row['method_key']}` | {row['family']} | "
            f"{row['covered_problem_count']}/{row['headline_problem_count']} | "
            f"{row['mean_hv']} | {row['classic_delta_mean_hv']} | {row['mean_hv_auc']} |"
        )
    lines.extend(
        [
            "",
            "## Generated Figures",
            "",
            "- `figures/mean_hv_by_method.png`",
            "- `figures/mean_hv_auc_by_method.png`",
            "- `figures/hv_delta_by_method.png`",
            "- `figures/valid_ppa_count_by_method.png`",
            "- `figures/pareto_points_by_method.png`",
            "- `figures/hv_win_loss_heatmap.png`",
            "",
            "## Interpretation Rule",
            "",
            "A QD method supports a headline claim only if the reference-complete",
            "subset remains positive after coverage losses, missing candidate PPA,",
            "and missing-reference designs are handled by the frozen manifests.",
            "",
        ]
    )
    (doc_root / "report.md").write_text("\n".join(lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
