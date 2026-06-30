#!/usr/bin/env python3
"""Summarize a corrected RTLLM representative suite stage."""

from __future__ import annotations

import argparse
import csv
import math
from pathlib import Path
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parents[7] / "src"))

from revolution.qd.pareto_analysis import hypervolume, pareto_front  # noqa: E402


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
    "classic_delta_mean_hv_auc",
    "mean_hv_retention_pct",
    "coverage_pct",
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


def pct(value: float) -> str:
    return fmt(100.0 * value)


def report_float(value: str) -> str:
    return f"{float(value):.4f}"


def report_percent(value: str) -> str:
    return f"{float(value):.1f}%"


def status(doc_root: Path, method: str, stage: str) -> str:
    if (doc_root / "logs" / f"{stage}.{method}.done").exists():
        return "done"
    if (doc_root / "logs" / f"{stage}.{method}.failed").exists():
        return "failed"
    return "not_started"


def method_label(method: str) -> str:
    label = method.removesuffix("_8x5")
    replacements = {
        "classic_revolution": "classic",
        "qwen_canonical_rtl_pca3_eoh": "Qwen3 EoH",
        "masterrtl_rf_leafid_structural_eoh": "MasterRTL RF EoH",
        "deepgate_high_exploit_eoh": "DeepGate EoH",
        "rf_deepgate_hybrid_eoh": "RF+DeepGate EoH",
        "aurora_raw_impl_compact_eoh": "AURORA raw EoH",
        "masterrtl_archive_activation_eoh": "MasterRTL QD EoH",
        "pcn_v3_rf_stagnation_memory": "PCN-v3 RF",
    }
    return replacements.get(label, label)


def objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "sequential":
        return ("g_P", "g_A", "g_T")
    if circuit_type == "combinational":
        return ("g_P", "g_A")
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def hv_at_step(rows: list[dict[str, str]], step: int) -> float:
    visible = [row for row in rows if int(row["generation"]) <= step]
    if not visible:
        return 0.0
    keys = objective_keys(visible[0]["circuit_type"])
    points = [tuple(float(row[key]) for key in keys) for row in visible]
    front = [points[index] for index in pareto_front(points)]
    return hypervolume(front)


def auc(values: list[float]) -> float:
    assert len(values) >= 2
    total = 0.0
    for left, right in zip(values[:-1], values[1:], strict=True):
        total += (left + right) / 2.0
    return total / (len(values) - 1)


def load_hv_auc(analysis_root: Path, methods: list[str], problems: list[str]) -> dict[tuple[str, str], float]:
    rows = read_csv(
        analysis_root
        / "reference_complete_ppa_distribution"
        / "data"
        / "ppa_candidates.csv"
    )
    by_key: dict[tuple[str, str], list[dict[str, str]]] = {}
    for row in rows:
        if row["problem"] in problems:
            by_key.setdefault((row["backend"], row["problem"]), []).append(row)
    values: dict[tuple[str, str], float] = {}
    for method in methods:
        for problem in problems:
            candidates = by_key.get((method, problem), [])
            hvs = [hv_at_step(candidates, step) if candidates else 0.0 for step in range(6)]
            values[(method, problem)] = auc(hvs)
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


def delta_boxplot(path: Path, methods: list[str], rows: list[dict[str, str]]) -> None:
    values = [
        [float(row["hv_delta_vs_classic"]) for row in rows if row["method_key"] == method]
        for method in methods
    ]
    fig, ax = plt.subplots(figsize=(11, 5))
    ax.boxplot(values, tick_labels=[method_label(method) for method in methods], showfliers=False)
    ax.axhline(0.0, color="#222222", linewidth=0.9)
    ax.set_title("Per-problem HV delta distribution vs classic")
    ax.set_ylabel("HV delta")
    ax.tick_params(axis="x", labelrotation=25)
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def coverage_scatter(path: Path, rows: list[dict[str, str]]) -> None:
    fig, ax = plt.subplots(figsize=(8, 5))
    for row in rows:
        ax.scatter(float(row["coverage_pct"]), float(row["mean_hv"]), s=70)
        ax.annotate(method_label(row["method_key"]), (float(row["coverage_pct"]), float(row["mean_hv"])), fontsize=8)
    ax.set_title("Coverage and mean HV")
    ax.set_xlabel("Reference-complete designs covered (%)")
    ax.set_ylabel("Mean HV")
    ax.grid(alpha=0.25)
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
    parser.add_argument("--stage", choices=["smoke", "full"], required=True)
    args = parser.parse_args()

    doc_root = args.doc_root.resolve()
    stage = args.stage
    analysis_root = doc_root / "analysis" / stage
    fig_root = doc_root / "figures" / stage
    report_path = doc_root / "reports" / f"{stage}_report.md"
    table_prefix = "full_suite" if stage == "full" else f"{stage}_suite"
    manifest = read_csv(doc_root / "tables" / "method_manifest.csv")
    methods = [row["method_key"] for row in manifest]
    problem_manifest = "rtllm_reference_complete_manifest.csv" if stage == "full" else "rtllm_smoke_manifest.csv"
    problems = [row["problem"] for row in read_csv(doc_root / "tables" / problem_manifest)]
    pareto_rows = read_csv(analysis_root / "reference_complete_pareto_analysis" / "backend_problem_metrics.csv")
    pareto = {(row["backend"], row["problem"]): row for row in pareto_rows}
    hv_auc = load_hv_auc(analysis_root, methods, problems)
    classic_hv = {
        problem: metric(pareto.get(("classic_revolution_8x5", problem)), "hypervolume")
        for problem in problems
    }
    classic_auc = {
        problem: hv_auc[("classic_revolution_8x5", problem)]
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
            auc_value = hv_auc[(method, problem)]
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
            hv_auc_values.append(auc_value)
            problem_rows.append(
                {
                    "method_key": method,
                    "problem": problem,
                    "hypervolume": fmt(hv),
                    "hv_delta_vs_classic": fmt(delta),
                    "hv_auc": fmt(auc_value),
                    "hv_auc_delta_vs_classic": fmt(auc_value - classic_auc[problem]),
                    "valid_ppa_count": str(valid),
                    "pareto_point_count": str(points),
                    "reference_beating_count": str(refs),
                }
            )
        mean_hv = sum(hv_values) / len(problems)
        mean_auc = sum(hv_auc_values) / len(problems)
        summary_rows.append(
            {
                "method_key": method,
                "family": method_row["family"],
                "completion_status": status(doc_root, method, stage),
                "contract_status": "computed_from_ppa_candidates",
                "headline_problem_count": str(len(problems)),
                "covered_problem_count": str(covered),
                "mean_hv": fmt(mean_hv),
                "mean_hv_auc": fmt(mean_auc),
                "mean_pareto_point_count": fmt(sum(pareto_counts) / len(problems)),
                "mean_reference_beating_count": fmt(sum(ref_counts) / len(problems)),
                "mean_valid_ppa_count": fmt(sum(valid_counts) / len(problems)),
                "classic_delta_mean_hv": "0" if method == "classic_revolution_8x5" else "",
                "classic_delta_mean_hv_auc": "0" if method == "classic_revolution_8x5" else "",
                "mean_hv_retention_pct": "",
                "coverage_pct": pct(covered / len(problems)),
                "classic_hv_win_count": str(wins),
                "classic_hv_loss_count": str(losses),
                "classic_hv_tie_count": str(ties),
                "command_path": method_row["command_path"],
                "descriptor_summary": method_row["descriptor_summary"],
            }
        )

    classic_mean = float(next(row["mean_hv"] for row in summary_rows if row["method_key"] == "classic_revolution_8x5"))
    classic_mean_auc = float(next(row["mean_hv_auc"] for row in summary_rows if row["method_key"] == "classic_revolution_8x5"))
    for row in summary_rows:
        if row["classic_delta_mean_hv"] == "":
            row["classic_delta_mean_hv"] = fmt(float(row["mean_hv"]) - classic_mean)
        if row["classic_delta_mean_hv_auc"] == "":
            row["classic_delta_mean_hv_auc"] = fmt(float(row["mean_hv_auc"]) - classic_mean_auc)
        row["mean_hv_retention_pct"] = pct(float(row["mean_hv"]) / classic_mean)

    write_csv(doc_root / "tables" / f"{table_prefix}_method_summary.csv", SUMMARY_FIELDS, summary_rows)
    write_csv(
        doc_root / "tables" / f"{table_prefix}_problem_metrics.csv",
        list(problem_rows[0]),
        problem_rows,
    )

    figure_rows = summary_rows
    fig_root.mkdir(parents=True, exist_ok=True)
    bar(fig_root / "mean_hv_by_method.png", figure_rows, "mean_hv", "Mean HV on reference-complete RTLLM", "Mean HV")
    bar(fig_root / "mean_hv_auc_by_method.png", figure_rows, "mean_hv_auc", "Mean HV-AUC from Phase 03.1 viewers", "Mean HV-AUC")
    bar(fig_root / "hv_delta_by_method.png", figure_rows, "classic_delta_mean_hv", "Mean HV delta vs classic", "Delta HV")
    bar(fig_root / "valid_ppa_count_by_method.png", figure_rows, "mean_valid_ppa_count", "Mean valid-PPA candidates per design", "Candidates")
    bar(fig_root / "pareto_points_by_method.png", figure_rows, "mean_pareto_point_count", "Mean Pareto points per design", "Points")
    coverage_scatter(fig_root / "coverage_vs_hv.png", figure_rows)
    heatmap(
        fig_root / "hv_win_loss_heatmap.png",
        [row["method_key"] for row in summary_rows if row["method_key"] != "classic_revolution_8x5"],
        problems,
        problem_rows,
    )
    delta_boxplot(
        fig_root / "hv_delta_distribution.png",
        [row["method_key"] for row in summary_rows if row["method_key"] != "classic_revolution_8x5"],
        problem_rows,
    )

    ranked = sorted(summary_rows, key=lambda row: float(row["mean_hv"]), reverse=True)
    best_qd = next(row for row in ranked if row["method_key"] != "classic_revolution_8x5")
    lines = [
        "# RTLLM Full Suite Results",
        "",
        f"This report is generated from the `{stage}` stage.",
        "Missing method/problem rows count as zero valid-PPA coverage for the",
        "headline mean HV table.",
        "",
        "## Executive Conclusion",
        "",
        "This is the corrected EoH-preserving suite. The QD arms keep the",
        "classic thought/code/feedback operator stack and add only descriptor",
        "archive or PCN memory pressure.",
        "",
        f"The best non-classic arm by mean HV is `{best_qd['method_key']}`,",
        f"which retains {report_percent(best_qd['mean_hv_retention_pct'])} of",
        "classic mean HV.",
        "",
        "Use this report only after checking `analysis/<stage>/operator_contract.csv`.",
        "Any nonzero `single_thought_count` invalidates the corrected comparison.",
        "",
        "## Run Status",
        "",
        "- Method arms are tracked with stage-prefixed `.done` sentinels.",
        "- Packaging completed and generated direct PPA/Pareto reports.",
        f"- Headline metrics use {len(problems)} reference-complete design(s).",
        "",
        "## Top Methods By Mean HV",
        "",
        "| Rank | Method | Family | Covered | Mean HV | HV retention | Delta HV | Mean HV-AUC | Delta HV-AUC |",
        "| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for index, row in enumerate(ranked, start=1):
        lines.append(
            f"| {index} | `{row['method_key']}` | {row['family']} | "
            f"{row['covered_problem_count']}/{row['headline_problem_count']} | "
            f"{report_float(row['mean_hv'])} | "
            f"{report_percent(row['mean_hv_retention_pct'])} | "
            f"{report_float(row['classic_delta_mean_hv'])} | "
            f"{report_float(row['mean_hv_auc'])} | "
            f"{report_float(row['classic_delta_mean_hv_auc'])} |"
        )
    lines.extend(
        [
            "",
            "## Metric Definitions",
            "",
            "- `Covered`: number of reference-complete designs with at least one",
            "  valid-PPA candidate for the method.",
            "- `Mean HV`: mean final PPA hypervolume over all 46 headline designs;",
            "  missing method/problem PPA rows contribute zero.",
            "- `Mean HV-AUC`: mean generation-wise hypervolume area under curve,",
            "  recomputed from `ppa_candidates.csv` over generations 0 through 5.",
            "- `HV retention`: method mean HV divided by classic mean HV.",
            "- `Delta HV`: method mean HV minus classic mean HV.",
            "",
            "## Method Takeaways",
            "",
            "- Compare this report against 20260629 only as an operator-corrected",
            "  rerun, not as a direct same-method continuation.",
            "- The PCN arm is the only active QD-memory method in this suite.",
            "- The other QD arms test descriptor/archive pressure under EoH",
            "  thought/code/feedback operators.",
            "",
            "## Comparison Tables",
            "",
            f"- `tables/{table_prefix}_method_summary.csv`: one row per method with",
            "  coverage, mean HV, mean HV-AUC, Pareto count, reference-beating",
            "  count, and win/loss/tie totals.",
            f"- `tables/{table_prefix}_problem_metrics.csv`: one row per method/problem",
            "  with final HV, HV-AUC, deltas versus classic, valid-PPA count,",
            "  Pareto count, and reference-beating count.",
            f"- `analysis/{stage}/reference_complete_pareto_analysis/backend_problem_metrics.csv`:",
            "  canonical final Pareto metrics emitted by the repo analysis script.",
            f"- `analysis/{stage}/completeness/*.csv`: method-specific candidate/reference",
            "  completeness gates.",
            f"- `analysis/{stage}/operator_contract.csv`: per-method operator audit.",
            "",
            "## Generated Figures",
            "",
            "- `figures/mean_hv_by_method.png`",
            "- `figures/mean_hv_auc_by_method.png`",
            "- `figures/hv_delta_by_method.png`",
            "- `figures/valid_ppa_count_by_method.png`",
            "- `figures/pareto_points_by_method.png`",
            "- `figures/hv_win_loss_heatmap.png`",
            "- `figures/hv_delta_distribution.png`",
            "- `figures/coverage_vs_hv.png`",
            "",
            "## Viewer Caveat",
            "",
            "The direct PPA/Pareto reports and suite figures were generated",
            "successfully. The Phase 03.1 viewer export failed in the initial",
            "packaging pass because the viewer exporter expected staged PPA inputs",
            "under each viewer source root, then strict export also encountered",
            "reference-complete designs with no PPA rows for a pairwise viewer.",
            "Therefore common-contract archive metrics are not used for the",
            "headline result in this report. HV-AUC here is recomputed directly",
            "from the reference-complete `ppa_candidates.csv` chronology.",
            "",
            "## Research Read",
            "",
            "This corrected suite tests whether prior QD underperformance was",
            "caused by the single-thought operator mismatch. A positive result",
            "requires the operator contract to pass and the reference-complete",
            "mean HV/HV-AUC comparison to improve over the 20260629 QD arms.",
            "",
            "## Interpretation Rule",
            "",
            "A QD method supports a headline claim only if the reference-complete",
            "subset remains positive after coverage losses, missing candidate PPA,",
            "and missing-reference designs are handled by the frozen manifests.",
            "This run does not pass that standard for any QD arm.",
            "",
        ]
    )
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text("\n".join(lines), encoding="utf-8")
    if stage == "full":
        (doc_root / "report.md").write_text("\n".join(lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
