#!/usr/bin/env python3
"""Plot compact T72 matched-comparison summary figures."""

from __future__ import annotations

import csv
from pathlib import Path

import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[1]
TABLES = ROOT / "tables"
FIGURES = ROOT / "figures"
CLASSIC = "classic_revolution"
T72 = "source_aligned_rtl_cell_qd"


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


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


def plot_hv_delta() -> None:
    rows = read_rows(TABLES / "backend_problem_metrics.csv")
    by_problem: dict[tuple[str, str], dict[str, dict[str, str]]] = {}
    for row in rows:
        key = (row["benchmark"], row["problem"])
        by_problem.setdefault(key, {})[row["backend"]] = row

    labels: list[str] = []
    deltas: list[float] = []
    for key in sorted(by_problem):
        pair = by_problem[key]
        classic = float(pair[CLASSIC]["hypervolume"])
        t72 = float(pair[T72]["hypervolume"])
        labels.append(problem_label(pair[T72]))
        deltas.append(t72 - classic)

    colors = ["#178f63" if value > 0 else "#9f3f3f" if value < 0 else "#6b7280" for value in deltas]
    fig, axis = plt.subplots(figsize=(11.5, 4.8))
    axis.bar(range(len(deltas)), deltas, color=colors, width=0.72)
    axis.axhline(0, color="#2f3437", linewidth=1)
    axis.set_title("T72 minus classic hypervolume by problem", fontsize=15, pad=12)
    axis.set_ylabel("HV delta")
    axis.set_xticks(range(len(labels)))
    axis.set_xticklabels(labels, rotation=35, ha="right", fontsize=8)
    axis.grid(axis="y", color="#d8dee6", linewidth=0.8, alpha=0.8)
    axis.spines[["top", "right"]].set_visible(False)
    fig.tight_layout()
    fig.savefig(FIGURES / "t72_hv_delta_by_problem.png", dpi=180)
    plt.close(fig)


def plot_valid_ppa_counts() -> None:
    rows = read_rows(TABLES / "t72_ppa_completeness.csv")
    labels = [problem_label(row) for row in rows]
    classic = [int(row["classic_valid_ppa_count"]) for row in rows]
    t72 = [int(row["qd_valid_ppa_count"]) for row in rows]

    xs = list(range(len(labels)))
    fig, axis = plt.subplots(figsize=(11.5, 4.8))
    axis.bar([x - 0.18 for x in xs], classic, width=0.36, label="classic", color="#2f79b7")
    axis.bar([x + 0.18 for x in xs], t72, width=0.36, label="T72", color="#d87932")
    axis.set_title("Valid PPA sample counts by problem", fontsize=15, pad=12)
    axis.set_ylabel("valid PPA samples")
    axis.set_xticks(xs)
    axis.set_xticklabels(labels, rotation=35, ha="right", fontsize=8)
    axis.legend(frameon=False, ncols=2, loc="upper right")
    axis.grid(axis="y", color="#d8dee6", linewidth=0.8, alpha=0.8)
    axis.spines[["top", "right"]].set_visible(False)
    fig.tight_layout()
    fig.savefig(FIGURES / "t72_valid_ppa_counts.png", dpi=180)
    plt.close(fig)


def main() -> None:
    FIGURES.mkdir(exist_ok=True)
    plot_hv_delta()
    plot_valid_ppa_counts()


if __name__ == "__main__":
    main()
