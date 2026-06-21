#!/usr/bin/env python3
"""Package the T24 SR-RFF live-screen result."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

PROBLEMS = (
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
)

CLASSIC_MODE = "classic_revolution/seed_1001/openai_gpt-oss-120b"
SR_RFF_MODE = "sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    args.output_dir.mkdir(parents=True, exist_ok=True)
    figure_dir = args.output_dir.parent / "figures"
    figure_dir.mkdir(parents=True, exist_ok=True)

    rows = [_problem_row(args.run_root, problem) for problem in PROBLEMS]
    _write_csv(args.output_dir / "live_sr_rff_vs_classic.csv", rows)
    _plot(rows, figure_dir / "live_sr_rff_vs_classic.png")
    return 0


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _problem_row(run_root: Path, problem: str) -> dict[str, str]:
    classic_root = run_root / CLASSIC_MODE / "RTLLM" / problem
    sr_rff_root = run_root / SR_RFF_MODE / "RTLLM" / problem
    classic = _load_json(classic_root / f"{problem}_summary.json")
    sr_rff = _load_json(sr_rff_root / f"{problem}_summary.json")
    archive = _load_json(sr_rff_root / "archive_summary.json")
    global_pareto = _load_json(sr_rff_root / "global_pareto_summary.json")

    classic_best = float(classic["final_population_ppa"]["best_score"])
    sr_rff_best = float(sr_rff["final_population_ppa"]["best_score"])
    best_delta = sr_rff_best - classic_best
    relative_delta = best_delta / abs(classic_best)
    classic_synthesis = float(classic["accumulated_success_rates"]["synthesis_ppa"])
    sr_rff_synthesis = float(sr_rff["accumulated_success_rates"]["synthesis_ppa"])

    return {
        "problem": problem,
        "classic_best_score": _format_float(classic_best),
        "sr_rff_best_score": _format_float(sr_rff_best),
        "best_score_delta": _format_float(best_delta),
        "best_score_relative_delta": _format_float(relative_delta),
        "classic_synthesis_ppa_rate": _format_float(classic_synthesis),
        "sr_rff_synthesis_ppa_rate": _format_float(sr_rff_synthesis),
        "synthesis_ppa_rate_delta": _format_float(sr_rff_synthesis - classic_synthesis),
        "sr_rff_occupied_cells": str(int(archive["occupied_cells"])),
        "sr_rff_archive_members": str(int(archive["total_archive_members"])),
        "sr_rff_max_front_size": str(int(archive["max_front_size"])),
        "sr_rff_global_pareto_members": str(
            int(global_pareto["total_global_pareto_members"])
        ),
    }


def _format_float(value: float) -> str:
    return f"{value:.6f}"


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _plot(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["problem"].replace("Prob", "P") for row in rows]
    x_positions = list(range(len(rows)))
    best_deltas = [float(row["best_score_delta"]) for row in rows]
    synthesis_deltas = [float(row["synthesis_ppa_rate_delta"]) for row in rows]
    archive_members = [int(row["sr_rff_archive_members"]) for row in rows]
    global_members = [int(row["sr_rff_global_pareto_members"]) for row in rows]

    fig, axes = plt.subplots(1, 3, figsize=(13.2, 4.4))
    colors = ["#2f7f5f" if value >= 0 else "#b54d4d" for value in best_deltas]
    axes[0].bar(x_positions, best_deltas, color=colors)
    axes[0].axhline(0.0, color="#404040", linewidth=0.8)
    axes[0].set_title("Best Score Delta")
    axes[0].set_ylabel("SR-RFF minus classic")

    colors = ["#2f7f5f" if value >= 0 else "#b54d4d" for value in synthesis_deltas]
    axes[1].bar(x_positions, synthesis_deltas, color=colors)
    axes[1].axhline(0.0, color="#404040", linewidth=0.8)
    axes[1].set_title("Synthesis-PPA Rate Delta")

    width = 0.36
    axes[2].bar(
        [value - width / 2 for value in x_positions],
        archive_members,
        width,
        color="#4c78a8",
        label="Archive members",
    )
    axes[2].bar(
        [value + width / 2 for value in x_positions],
        global_members,
        width,
        color="#f28e2b",
        label="Global Pareto members",
    )
    axes[2].set_title("SR-RFF Front Material")
    axes[2].legend(frameon=False, fontsize=8)

    for axis in axes:
        axis.set_xticks(x_positions)
        axis.set_xticklabels(labels, rotation=25, ha="right")
        axis.grid(axis="y", color="#e2e2e2", linewidth=0.8)

    fig.suptitle("T24 Live Screen: SR-RFF Pareto QD vs Classic", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    raise SystemExit(main())
