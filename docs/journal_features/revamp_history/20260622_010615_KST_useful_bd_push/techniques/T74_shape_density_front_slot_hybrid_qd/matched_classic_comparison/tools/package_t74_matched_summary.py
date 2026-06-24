#!/usr/bin/env python3
"""Package compact T74 matched-comparison tables and figures."""

from __future__ import annotations

import csv
import shutil
from pathlib import Path

import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = Path(
    "exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC"
    "/hard_tuning/final_analysis"
)
TABLES = ROOT / "tables"
DATA = ROOT / "data"
FIGURES = ROOT / "figures"
CLASSIC = "classic_revolution"
T74 = "shape_density_front_slot_hybrid_qd"


def copy_text(source: Path, target: Path) -> None:
    text = source.read_text(encoding="utf-8").replace("\r\n", "\n").rstrip() + "\n"
    target.write_text(text, encoding="utf-8")


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def write_rows(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def problem_label(row: dict[str, str]) -> str:
    prefix = "R" if row["benchmark"] == "RTLLM" else "V"
    raw = row["problem"].removeprefix("Prob")
    number, _, name = raw.partition("_")
    aliases = {
        "adder_8bit": "adder8",
        "multi_pipe_8bit": "pipe8",
        "parallel2serial": "p2s",
        "traffic_light": "traffic",
        "signal_generator": "signal",
        "circuit7": "circuit7",
        "m2014_q3": "q3",
        "m2014_q6b": "q6b",
        "review2015_fsmonehot": "onehot",
        "review2015_fsm": "fsm",
    }
    return f"{prefix}{number}\n{aliases.get(name, name)}"


def copy_compact_outputs() -> None:
    TABLES.mkdir(parents=True, exist_ok=True)
    DATA.mkdir(parents=True, exist_ok=True)
    FIGURES.mkdir(parents=True, exist_ok=True)
    for source, target in {
        ANALYSIS / "backend_comparison.md": TABLES / "backend_comparison.md",
        ANALYSIS / "summary.json": TABLES / "final_analysis_summary.json",
        ANALYSIS / "hard_iteration_analysis" / "summary.json": TABLES / "hard_iteration_summary.json",
        ANALYSIS / "pareto_analysis" / "aggregate_backend_metrics.csv": TABLES / "aggregate_backend_metrics.csv",
        ANALYSIS / "pareto_analysis" / "backend_problem_metrics.csv": TABLES / "backend_problem_metrics.csv",
        ANALYSIS / "pareto_analysis" / "report.md": TABLES / "pareto_report.md",
        ANALYSIS / "pareto_analysis" / "summary.json": TABLES / "pareto_summary.json",
        ANALYSIS / "ppa_distribution" / "data" / "ppa_candidates.csv": DATA / "ppa_candidates.csv",
        ANALYSIS / "ppa_distribution" / "data" / "reference_ppa_metrics.csv": DATA / "reference_ppa_metrics.csv",
        ANALYSIS / "ppa_distribution" / "data" / "best_candidate_by_backend_problem.csv": DATA / "best_candidate_by_backend_problem.csv",
    }.items():
        copy_text(source, target)


def write_completeness_table() -> None:
    candidates = read_rows(DATA / "ppa_candidates.csv")
    refs = {(row["benchmark"], row["problem"]) for row in read_rows(DATA / "reference_ppa_metrics.csv")}
    counts: dict[tuple[str, str, str], int] = {}
    for row in candidates:
        key = (row["benchmark"], row["problem"], row["backend"])
        counts[key] = counts.get(key, 0) + 1

    rows: list[dict[str, str]] = []
    for benchmark, problem in sorted(refs):
        classic = counts.get((benchmark, problem, CLASSIC), 0)
        qd = counts.get((benchmark, problem, T74), 0)
        rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "classic_valid_ppa_count": str(classic),
                "qd_valid_ppa_count": str(qd),
                "reference_ppa_valid": "yes",
                "comparison_status": "headline" if classic > 0 and qd > 0 else "diagnostic_only",
            }
        )
    write_rows(TABLES / "t74_ppa_completeness.csv", rows)


def plot_hv_delta() -> None:
    rows = read_rows(TABLES / "backend_problem_metrics.csv")
    by_problem: dict[tuple[str, str], dict[str, dict[str, str]]] = {}
    for row in rows:
        by_problem.setdefault((row["benchmark"], row["problem"]), {})[row["backend"]] = row

    labels: list[str] = []
    deltas: list[float] = []
    for key in sorted(by_problem):
        pair = by_problem[key]
        labels.append(problem_label(pair[T74]))
        deltas.append(float(pair[T74]["hypervolume"]) - float(pair[CLASSIC]["hypervolume"]))

    colors = ["#178f63" if value > 0 else "#9f3f3f" if value < 0 else "#6b7280" for value in deltas]
    fig, axis = plt.subplots(figsize=(11.5, 4.8))
    axis.bar(range(len(deltas)), deltas, color=colors, width=0.72)
    axis.axhline(0, color="#2f3437", linewidth=1)
    axis.set_title("T74 minus classic hypervolume by problem", fontsize=15, pad=12)
    axis.set_ylabel("HV delta")
    axis.set_xticks(range(len(labels)))
    axis.set_xticklabels(labels, rotation=35, ha="right", fontsize=8)
    axis.grid(axis="y", color="#d8dee6", linewidth=0.8, alpha=0.8)
    axis.spines[["top", "right"]].set_visible(False)
    fig.tight_layout()
    fig.savefig(FIGURES / "t74_hv_delta_by_problem.png", dpi=180)
    plt.close(fig)


def plot_valid_ppa_counts() -> None:
    rows = read_rows(TABLES / "t74_ppa_completeness.csv")
    labels = [problem_label(row) for row in rows]
    classic = [int(row["classic_valid_ppa_count"]) for row in rows]
    t74 = [int(row["qd_valid_ppa_count"]) for row in rows]
    xs = list(range(len(labels)))

    fig, axis = plt.subplots(figsize=(11.5, 4.8))
    axis.bar([x - 0.18 for x in xs], classic, width=0.36, label="classic", color="#2f79b7")
    axis.bar([x + 0.18 for x in xs], t74, width=0.36, label="T74", color="#d87932")
    axis.set_title("Valid PPA sample counts by problem", fontsize=15, pad=12)
    axis.set_ylabel("valid PPA samples")
    axis.set_xticks(xs)
    axis.set_xticklabels(labels, rotation=35, ha="right", fontsize=8)
    axis.legend(frameon=False, ncols=2, loc="upper right")
    axis.grid(axis="y", color="#d8dee6", linewidth=0.8, alpha=0.8)
    axis.spines[["top", "right"]].set_visible(False)
    fig.tight_layout()
    fig.savefig(FIGURES / "t74_valid_ppa_counts.png", dpi=180)
    plt.close(fig)


def copy_representative_fronts() -> None:
    target = FIGURES / "pareto_examples"
    target.mkdir(exist_ok=True)
    base = ANALYSIS / "ppa_distribution" / "figures" / "all_backends"
    for source, name in {
        base / "RTLLM" / "Prob037_parallel2serial" / "gain" / "power_vs_effective_clock_period.png": "rtllm_prob037_p2s_gain_power_period.png",
        base / "RTLLM" / "Prob045_alu" / "gain" / "power_vs_area.png": "rtllm_prob045_alu_gain_power_area.png",
        base / "RTLLM" / "Prob049_signal_generator" / "gain" / "power_vs_effective_clock_period.png": "rtllm_prob049_signal_gain_power_period.png",
        base / "VerilogEval-Spec-to-RTL" / "Prob116_m2014_q3" / "gain" / "power_vs_area.png": "verilogeval_prob116_q3_gain_power_area.png",
    }.items():
        shutil.copyfile(source, target / name)


def main() -> None:
    copy_compact_outputs()
    write_completeness_table()
    plot_hv_delta()
    plot_valid_ppa_counts()
    copy_representative_fronts()


if __name__ == "__main__":
    main()
