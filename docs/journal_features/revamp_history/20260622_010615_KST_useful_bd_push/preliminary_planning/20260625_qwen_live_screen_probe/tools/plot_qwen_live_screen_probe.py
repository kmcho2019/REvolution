#!/usr/bin/env python3
"""Plot Qwen live-screen probe diagnostics."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

import matplotlib.pyplot as plt


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--package-dir", required=True, type=Path)
    args = parser.parse_args()

    package = args.package_dir
    figures = package / "figures"
    figures.mkdir(exist_ok=True)
    rows = read_csv(package / "tables/qwen_live_screen_probe_candidates.csv")
    summary = json.loads((package / "tables/qwen_live_screen_probe_summary.json").read_text(encoding="utf-8"))

    problems = sorted({row["problem"] for row in rows})
    colors = plt.get_cmap("tab10")
    fig, axes = plt.subplots(1, 2, figsize=(12.5, 4.8), gridspec_kw={"width_ratios": [1.35, 1.0]})
    for index, problem in enumerate(problems):
        selected = [row for row in rows if row["problem"] == problem]
        axes[0].scatter(
            [float(row["qwen_pc0"]) for row in selected],
            [float(row["qwen_pc1"]) for row in selected],
            s=18,
            alpha=0.72,
            color=colors(index % 10),
            label=problem.replace("Prob", "P"),
        )
    axes[0].set_title("Qwen canonical RTL PCA")
    axes[0].set_xlabel("PC0")
    axes[0].set_ylabel("PC1")
    axes[0].grid(alpha=0.18)
    axes[0].legend(fontsize=7, frameon=False, loc="best")

    labels = ["Same problem", "Same backend", "Duplicate RTL"]
    values = [
        summary["nearest_same_problem_fraction"],
        summary["nearest_same_backend_fraction"],
        summary["nearest_same_canonical_sha256_fraction"],
    ]
    bars = axes[1].bar(labels, values, color=["#dc2626", "#64748b", "#2563eb"])
    axes[1].set_ylim(0.0, 1.12)
    axes[1].set_title("Nearest-neighbor collapse checks")
    axes[1].set_ylabel("Fraction")
    axes[1].tick_params(axis="x", rotation=20)
    axes[1].grid(axis="y", alpha=0.18)
    for bar, value in zip(bars, values):
        axes[1].text(
            bar.get_x() + bar.get_width() / 2.0,
            value + 0.025,
            f"{value:.2f}",
            ha="center",
            va="bottom",
            fontsize=9,
        )
    fig.tight_layout()
    fig.savefig(figures / "qwen_live_screen_probe.png", dpi=180)


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


if __name__ == "__main__":
    main()
