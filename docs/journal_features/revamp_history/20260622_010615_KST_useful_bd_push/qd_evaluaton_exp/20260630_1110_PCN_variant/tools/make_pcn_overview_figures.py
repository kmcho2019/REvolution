#!/usr/bin/env python3
"""Generate static explanatory PCN figures."""

from __future__ import annotations

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch


DOC_ROOT = Path(__file__).resolve().parents[1]
FIGURE_ROOT = DOC_ROOT / "figures"


def box(ax, xy: tuple[float, float], text: str, color: str) -> None:
    x, y = xy
    patch = FancyBboxPatch(
        (x, y),
        2.5,
        0.72,
        boxstyle="round,pad=0.04,rounding_size=0.04",
        linewidth=1.0,
        edgecolor="#1f2933",
        facecolor=color,
    )
    ax.add_patch(patch)
    ax.text(x + 1.25, y + 0.36, text, ha="center", va="center", fontsize=9)


def arrow(ax, start: tuple[float, float], end: tuple[float, float]) -> None:
    ax.annotate(
        "",
        xy=end,
        xytext=start,
        arrowprops={"arrowstyle": "->", "linewidth": 1.2, "color": "#1f2933"},
    )


def algorithm_flow() -> None:
    fig, ax = plt.subplots(figsize=(10, 5.4))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    box(ax, (0.5, 4.5), "Classic parent\nPrimaryPool", "#d7e8fa")
    box(ax, (3.8, 4.5), "LLM one-parent\nPPA-first refine", "#f8e6c4")
    box(ax, (7.0, 4.5), "Evaluate\nvalidity + PPA", "#d8f0dc")
    box(ax, (0.5, 2.3), "Valid-PPA\ncandidate", "#d8f0dc")
    box(ax, (3.8, 2.3), "Passive descriptor\nmemory insert", "#e6ddf4")
    box(ax, (7.0, 2.3), "Cell credit\nfront + quality gates", "#e6ddf4")
    box(ax, (3.8, 0.6), "At most 10%\nmemory recall", "#f4d7d7")
    box(ax, (7.0, 0.6), "Fallback to\nclassic lane", "#f3f4f6")
    arrow(ax, (3.0, 4.86), (3.8, 4.86))
    arrow(ax, (6.3, 4.86), (7.0, 4.86))
    arrow(ax, (8.25, 4.5), (8.25, 3.05))
    arrow(ax, (7.0, 2.66), (6.3, 2.66))
    arrow(ax, (3.8, 2.66), (3.0, 2.66))
    arrow(ax, (5.05, 2.3), (5.05, 1.32))
    arrow(ax, (6.3, 0.96), (7.0, 0.96))
    ax.text(
        0.5,
        5.55,
        "PCN keeps classic exploitation dominant and recalls memory only after quality evidence.",
        fontsize=12,
        weight="bold",
    )
    fig.tight_layout()
    fig.savefig(FIGURE_ROOT / "pcn_algorithm_flow.png", dpi=180)
    plt.close(fig)


def stage_ladder() -> None:
    stages = [
        ("Smoke", "3 designs\n8x5\nall arms"),
        ("Screen", "8 designs\n8x5\nall arms"),
        ("Long 20x10", "4 designs\nclassic vs PCN RF"),
        ("Long 10x20", "4 designs\nclassic vs PCN RF"),
        ("RTLLM decision", "only if gates pass"),
    ]
    fig, ax = plt.subplots(figsize=(11, 3.6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 2)
    ax.axis("off")
    for index, (title, subtitle) in enumerate(stages):
        color = "#d7e8fa" if index < 2 else "#e6ddf4" if index < 4 else "#d8f0dc"
        x = 0.3 + index * 1.9
        patch = FancyBboxPatch(
            (x, 0.72),
            1.45,
            0.86,
            boxstyle="round,pad=0.04,rounding_size=0.04",
            linewidth=1.0,
            edgecolor="#1f2933",
            facecolor=color,
        )
        ax.add_patch(patch)
        ax.text(x + 0.72, 1.15, f"{title}\n{subtitle}", ha="center", va="center", fontsize=9)
        if index < len(stages) - 1:
            arrow(ax, (x + 1.45, 1.15), (x + 1.86, 1.15))
    ax.text(0.1, 1.75, "PCN staged evidence ladder", fontsize=12, weight="bold")
    fig.tight_layout()
    fig.savefig(FIGURE_ROOT / "pcn_stage_ladder.png", dpi=180)
    plt.close(fig)


def main() -> int:
    FIGURE_ROOT.mkdir(parents=True, exist_ok=True)
    algorithm_flow()
    stage_ladder()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
