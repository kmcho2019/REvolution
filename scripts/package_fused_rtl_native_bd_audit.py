#!/usr/bin/env python3
"""Package a fused Yosys-SOG plus timing-risk descriptor audit."""

from __future__ import annotations

import argparse
import csv
import hashlib
import shutil
from dataclasses import dataclass, replace
from pathlib import Path
from typing import Literal

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


CellScope = Literal["problem"]

PROFILES = {
    "operator_timing": ("operator_mix_score", "timing_risk_score"),
    "state_pipeline": ("state_control_ratio", "control_pipeline_ratio"),
    "complexity_entropy": ("sog_complexity_score", "timing_risk_entropy"),
}
PROFILE_LABELS = {
    "operator_timing": "Operator Mix + Timing Risk",
    "state_pipeline": "State/Control + Pipeline",
    "complexity_entropy": "SOG Complexity + Timing Entropy",
}
AXIS_LABELS = {
    "operator_mix_score": "Operator Mix Bin",
    "timing_risk_score": "Timing-Risk Bin",
    "state_control_ratio": "State/Control Bin",
    "control_pipeline_ratio": "Control/Pipeline Bin",
    "sog_complexity_score": "SOG Complexity Bin",
    "timing_risk_entropy": "Timing-Entropy Bin",
}

FEATURE_FIELDS = [
    "method",
    "method_label",
    "problem",
    "candidate_id",
    "generation",
    "is_pareto_front",
    "operator_mix_score",
    "state_control_ratio",
    "sog_complexity_score",
    "sog_entropy",
    "timing_risk_score",
    "control_pipeline_ratio",
    "timing_risk_entropy",
    "operator_timing_cell",
    "state_pipeline_cell",
    "complexity_entropy_cell",
    "code_file_path",
]


@dataclass(frozen=True)
class CandidateFeature:
    method: str
    method_label: str
    problem: str
    candidate_id: str
    generation: str
    is_front: bool
    operator_mix_score: float
    state_control_ratio: float
    sog_complexity_score: float
    sog_entropy: float
    timing_risk_score: float
    control_pipeline_ratio: float
    timing_risk_entropy: float
    code_file_path: str
    operator_timing_cell: str = ""
    state_pipeline_cell: str = ""
    complexity_entropy_cell: str = ""


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def join_features(
    sog_rows: list[dict[str, str]],
    timing_rows: list[dict[str, str]],
) -> list[CandidateFeature]:
    timing_by_key = {row_key(row): row for row in timing_rows}
    assert len(timing_by_key) == len(timing_rows)
    output = []
    for sog in sog_rows:
        timing = timing_by_key[row_key(sog)]
        assert sog["method_label"] == timing["method_label"]
        assert sog["generation"] == timing["generation"]
        assert sog["is_pareto_front"] == timing["is_pareto_front"]
        output.append(
            CandidateFeature(
                method=sog["method"],
                method_label=sog["method_label"],
                problem=sog["problem"],
                candidate_id=sog["candidate_id"],
                generation=sog["generation"],
                is_front=sog["is_pareto_front"] == "true",
                operator_mix_score=float(sog["operator_mix_score"]),
                state_control_ratio=float(sog["state_control_ratio"]),
                sog_complexity_score=float(sog["sog_complexity_score"]),
                sog_entropy=float(sog["sog_entropy"]),
                timing_risk_score=float(timing["timing_risk_score"]),
                control_pipeline_ratio=float(timing["control_pipeline_ratio"]),
                timing_risk_entropy=float(timing["timing_risk_entropy"]),
                code_file_path=sog["code_file_path"],
            )
        )
    assert len(output) == len(timing_rows)
    return output


def row_key(row: dict[str, str]) -> tuple[str, str, str]:
    return row["method"], row["problem"], row["candidate_id"]


def assign_cells(features: list[CandidateFeature]) -> list[CandidateFeature]:
    output = features
    for profile, axes in PROFILES.items():
        profile_output = []
        for problem in sorted({feature.problem for feature in output}):
            group = [feature for feature in output if feature.problem == problem]
            profile_output.extend(assign_profile_cell_group(group, profile, axes))
        output = profile_output
    return output


def assign_profile_cell_group(
    group: list[CandidateFeature],
    profile: str,
    axes: tuple[str, str],
) -> list[CandidateFeature]:
    xs = sorted(feature_value(feature, axes[0]) for feature in group)
    ys = sorted(feature_value(feature, axes[1]) for feature in group)
    output = []
    for feature in group:
        cell = f"{rank_bin(feature_value(feature, axes[0]), xs)},{rank_bin(feature_value(feature, axes[1]), ys)}"
        if profile == "operator_timing":
            output.append(replace(feature, operator_timing_cell=cell))
        elif profile == "state_pipeline":
            output.append(replace(feature, state_pipeline_cell=cell))
        elif profile == "complexity_entropy":
            output.append(replace(feature, complexity_entropy_cell=cell))
        else:
            raise AssertionError(f"unknown profile: {profile}")
    return output


def feature_value(feature: CandidateFeature, name: str) -> float:
    if name == "operator_mix_score":
        return feature.operator_mix_score
    if name == "state_control_ratio":
        return feature.state_control_ratio
    if name == "sog_complexity_score":
        return feature.sog_complexity_score
    if name == "timing_risk_score":
        return feature.timing_risk_score
    if name == "control_pipeline_ratio":
        return feature.control_pipeline_ratio
    if name == "timing_risk_entropy":
        return feature.timing_risk_entropy
    raise AssertionError(f"unknown feature: {name}")


def rank_bin(value: float, sorted_values: list[float]) -> int:
    index = sorted_values.index(value)
    return min(3, int(index * 4 / len(sorted_values)))


def feature_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    return [
        {
            "method": feature.method,
            "method_label": feature.method_label,
            "problem": feature.problem,
            "candidate_id": feature.candidate_id,
            "generation": feature.generation,
            "is_pareto_front": str(feature.is_front).lower(),
            "operator_mix_score": fmt(feature.operator_mix_score),
            "state_control_ratio": fmt(feature.state_control_ratio),
            "sog_complexity_score": fmt(feature.sog_complexity_score),
            "sog_entropy": fmt(feature.sog_entropy),
            "timing_risk_score": fmt(feature.timing_risk_score),
            "control_pipeline_ratio": fmt(feature.control_pipeline_ratio),
            "timing_risk_entropy": fmt(feature.timing_risk_entropy),
            "operator_timing_cell": feature.operator_timing_cell,
            "state_pipeline_cell": feature.state_pipeline_cell,
            "complexity_entropy_cell": feature.complexity_entropy_cell,
            "code_file_path": feature.code_file_path,
        }
        for feature in features
    ]


def profile_metric_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    for profile in PROFILES:
        for method in sorted({feature.method for feature in features}):
            subset = [feature for feature in features if feature.method == method]
            rows.append(summary_row("all", profile, method, subset))
    return rows


def profile_problem_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    for profile in PROFILES:
        keys = sorted({(feature.method, feature.problem) for feature in features})
        for method, problem in keys:
            subset = [feature for feature in features if feature.method == method and feature.problem == problem]
            rows.append(summary_row(problem, profile, method, subset))
    return rows


def summary_row(
    cohort: str,
    profile: str,
    method: str,
    subset: list[CandidateFeature],
) -> dict[str, str]:
    front = [feature for feature in subset if feature.is_front]
    return {
        "cohort": cohort,
        "profile": profile,
        "method": method,
        "candidate_count": str(len(subset)),
        "front_count": str(len(front)),
        "occupied_cells": str(len({profile_cell(feature, profile) for feature in subset})),
        "front_cells": str(len({profile_cell(feature, profile) for feature in front})),
        "mean_sog_complexity_score": fmt(mean([feature.sog_complexity_score for feature in subset])),
        "mean_timing_risk_score": fmt(mean([feature.timing_risk_score for feature in subset])),
    }


def profile_cell(feature: CandidateFeature, profile: str) -> str:
    if profile == "operator_timing":
        return feature.operator_timing_cell
    if profile == "state_pipeline":
        return feature.state_pipeline_cell
    if profile == "complexity_entropy":
        return feature.complexity_entropy_cell
    raise AssertionError(f"unknown profile: {profile}")


def comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_key = {
        (row["cohort"], row["profile"], row["method"]): row
        for row in rows
        if row["cohort"] != "all"
    }
    problems = sorted({row["cohort"] for row in rows if row["cohort"] != "all"})
    methods = sorted({row["method"] for row in rows if row["method"] != "classic_revolution"})
    output = []
    for problem in problems:
        for profile in PROFILES:
            classic = by_key.get((problem, profile, "classic_revolution"))
            if classic is None:
                continue
            for method in methods:
                other = by_key.get((problem, profile, method))
                if other is None:
                    continue
                output.append(
                    {
                        "problem": problem,
                        "profile": profile,
                        "method": method,
                        "front_cell_delta": delta(other, classic, "front_cells"),
                        "occupied_cell_delta": delta(other, classic, "occupied_cells"),
                    }
                )
    return output


def profile_delta_summary_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for profile in PROFILES:
        subset = [row for row in rows if row["profile"] == profile]
        front = [float(row["front_cell_delta"]) for row in subset]
        occupied = [float(row["occupied_cell_delta"]) for row in subset]
        output.append(
            {
                "profile": profile,
                "mean_front_cell_delta": fmt(mean(front)),
                "front_t26_better": str(sum(value > 0 for value in front)),
                "front_classic_better": str(sum(value < 0 for value in front)),
                "front_tie": str(sum(value == 0 for value in front)),
                "mean_occupied_cell_delta": fmt(mean(occupied)),
                "occupied_t26_better": str(sum(value > 0 for value in occupied)),
                "occupied_classic_better": str(sum(value < 0 for value in occupied)),
                "occupied_tie": str(sum(value == 0 for value in occupied)),
            }
        )
    return output


def delta(left: dict[str, str], right: dict[str, str], key: str) -> str:
    return fmt(float(left[key]) - float(right[key]))


def write_profile_delta_figure(rows: list[dict[str, str]], path: Path) -> None:
    profiles = [row["profile"] for row in rows]
    front = [float(row["mean_front_cell_delta"]) for row in rows]
    occupied = [float(row["mean_occupied_cell_delta"]) for row in rows]
    x_positions = range(len(profiles))
    fig, ax = plt.subplots(figsize=(9.0, 5.4))
    ax.bar([x - 0.18 for x in x_positions], front, width=0.36, color="#4e79a7", label="Front cells")
    ax.bar([x + 0.18 for x in x_positions], occupied, width=0.36, color="#e15759", label="Occupied cells")
    ax.axhline(0.0, color="#333333", linewidth=1.0)
    ax.set_xticks(list(x_positions), [PROFILE_LABELS[profile] for profile in profiles], rotation=12, ha="right")
    ax.set_ylabel("Mean Exact T26 QD Delta Versus Classic")
    ax.set_title("Fused RTL-Native Descriptor Cell Deltas")
    ax.grid(axis="y", alpha=0.25)
    ax.legend(frameon=False)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def write_best_heatmap(features: list[CandidateFeature], summary_rows: list[dict[str, str]], path: Path) -> str:
    best_profile = max(summary_rows, key=lambda row: float(row["mean_front_cell_delta"]))["profile"]
    profile_axes = PROFILES[best_profile]
    methods = sorted({feature.method for feature in features})
    labels = {feature.method: feature.method_label for feature in features}
    max_count = 1
    grids: dict[str, list[list[int]]] = {}
    for method in methods:
        grid = [[0 for _ in range(4)] for _ in range(4)]
        for feature in features:
            if feature.method == method and feature.is_front:
                x_text, y_text = profile_cell(feature, best_profile).split(",")
                grid[int(y_text)][int(x_text)] += 1
        max_count = max(max_count, max(max(row) for row in grid))
        grids[method] = grid
    fig, axes = plt.subplots(1, len(methods), figsize=(5.2 * len(methods), 4.8), squeeze=False)
    for ax, method in zip(axes[0], methods, strict=True):
        grid = grids[method]
        image = ax.imshow(grid, cmap="YlGnBu", origin="lower", vmin=0, vmax=max_count)
        ax.set_title(labels[method])
        ax.set_xlabel(AXIS_LABELS[profile_axes[0]])
        ax.set_ylabel(AXIS_LABELS[profile_axes[1]])
        ax.set_xticks([0, 1, 2, 3])
        ax.set_yticks([0, 1, 2, 3])
        for y, row in enumerate(grid):
            for x, value in enumerate(row):
                ax.text(x, y, str(value), ha="center", va="center", fontsize=9)
        fig.colorbar(image, ax=ax, fraction=0.046, pad=0.04)
    fig.suptitle(f"Pareto-Front Counts For Best Fused Profile: {PROFILE_LABELS[best_profile]}")
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return best_profile


def write_notes(path: Path, best_profile: str) -> None:
    lines = [
        "# Fused RTL-Native Visual Inspection Notes",
        "",
        "- `profile_cell_delta_summary.png` cleanly shows that each fused profile",
        "  should be read as a delta versus classic, not as a standalone quality",
        "  score.",
        f"- `best_profile_archive_heatmap.png` uses `{PROFILE_LABELS[best_profile]}`, the profile",
        "  with the largest mean front-cell delta in this retrospective audit.",
        "- The heatmap uses shared color scaling and reader-facing method labels.",
        "- Axes are descriptor-only RTL structural/timing features; they exclude",
        "  final PPA, reference PPA, fitness, hypervolume, Pareto rank, and tests.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def mean(values: list[float]) -> float:
    assert values
    return sum(values) / len(values)


def fmt(value: float) -> str:
    return f"{value:.6f}"


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sog-features", type=Path, required=True)
    parser.add_argument("--timing-features", type=Path, required=True)
    parser.add_argument("--ppa-completeness", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    features = assign_cells(join_features(read_csv(args.sog_features), read_csv(args.timing_features)))
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    write_csv(table_dir / "fused_rtl_features.csv", feature_rows(features))
    aggregate = profile_metric_rows(features)
    per_problem = profile_problem_rows(features)
    deltas = comparison_rows(per_problem)
    delta_summary = profile_delta_summary_rows(deltas)
    write_csv(table_dir / "profile_archive_metrics.csv", aggregate)
    write_csv(table_dir / "profile_problem_metrics.csv", per_problem)
    write_csv(table_dir / "profile_comparison_deltas.csv", deltas)
    write_csv(table_dir / "profile_delta_summary.csv", delta_summary)
    shutil.copyfile(args.ppa_completeness, table_dir / "ppa_completeness.csv")
    write_profile_delta_figure(delta_summary, figure_dir / "profile_cell_delta_summary.png")
    best_profile = write_best_heatmap(features, delta_summary, figure_dir / "best_profile_archive_heatmap.png")
    write_notes(figure_dir / "visual_inspection_notes.md", best_profile)
    schema = "\n".join(FEATURE_FIELDS).encode("utf-8")
    print(f"feature_schema_sha256={hashlib.sha256(schema).hexdigest()}")
    print(f"candidate_count={len(features)}")
    print(f"profiles={','.join(PROFILES)}")
    print(f"best_profile={best_profile}")
    print(f"output_dir={args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
