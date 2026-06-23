#!/usr/bin/env python3
"""Package a posthoc RTL-native secondary-cell audit from viewer datasets."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from dataclasses import dataclass, replace
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator


PROFILES = {
    "timing_risk": ("control_pipeline_ratio", "timing_risk_score"),
    "operator_timing": ("operator_pressure_score", "timing_risk_score"),
    "control_pipeline": ("control_count", "pipeline_event_count"),
}
PROFILE_LABELS = {
    "timing_risk": "Control/Pipeline + Timing Risk",
    "operator_timing": "Operator Pressure + Timing Risk",
    "control_pipeline": "Control + Pipeline",
}
PROFILE_SHORT_LABELS = {
    "timing_risk": "Timing",
    "operator_timing": "Operator",
    "control_pipeline": "Control",
}
METHOD_LABELS = {
    "classic_revolution": "Classic",
    "code_thought_front_slot_qd": "T51 code-thought",
    "fused_rtl_state_pipeline_qd": "T63 state/pipeline",
    "fused_rtl_operator_timing_qd": "T64 operator/timing",
}
METHOD_SHORT_LABELS = {
    "code_thought_front_slot_qd": "T51",
    "fused_rtl_state_pipeline_qd": "T63",
    "fused_rtl_operator_timing_qd": "T64",
}
FEATURE_FIELDS = [
    "method",
    "method_label",
    "benchmark",
    "problem",
    "candidate_id",
    "generation",
    "is_front",
    "line_count",
    "operator_pressure_score",
    "timing_risk_score",
    "control_pipeline_ratio",
    "pipeline_event_count",
    "control_count",
    "timing_risk_entropy",
    "unique_identifier_count",
    "timing_risk_cell",
    "operator_timing_cell",
    "control_pipeline_cell",
    "code_file_path",
]


@dataclass(frozen=True)
class CandidateFeature:
    method: str
    method_label: str
    benchmark: str
    problem: str
    candidate_id: str
    generation: int
    is_front: bool
    code_file_path: Path
    line_count: float
    operator_pressure_score: float
    timing_risk_score: float
    control_pipeline_ratio: float
    pipeline_event_count: float
    control_count: float
    timing_risk_entropy: float
    unique_identifier_count: float
    timing_risk_cell: str = ""
    operator_timing_cell: str = ""
    control_pipeline_cell: str = ""


def load_features(dataset_dirs: list[Path], candidate_csvs: list[Path]) -> list[CandidateFeature]:
    evaluator = RTLDescriptorEvaluator()
    code_paths = load_code_paths(dataset_dirs)
    rows: dict[tuple[str, str], CandidateFeature] = {}
    for candidate_csv in candidate_csvs:
        assert candidate_csv.is_file()
        for row in read_csv(candidate_csv):
            key = (row["method"], row["candidate_id"])
            code_file_path = code_paths[key]
            feature = extract_feature(evaluator, code_file_path, row)
            if key in rows:
                assert rows[key].is_front == feature.is_front
                assert rows[key].code_file_path == feature.code_file_path
                continue
            rows[key] = feature
    assert rows
    return assign_cells(list(rows.values()))


def load_code_paths(dataset_dirs: list[Path]) -> dict[tuple[str, str], Path]:
    code_paths: dict[tuple[str, str], Path] = {}
    for dataset_dir in dataset_dirs:
        assert dataset_dir.is_dir()
        for path in sorted(dataset_dir.glob("*.json")):
            data = json.loads(path.read_text(encoding="utf-8"))
            for sample in data["samples"]:
                if sample["status"] != "ppa_valid":
                    continue
                method = method_id(sample["technique"])
                key = (method, sample["candidate_id"])
                code_file_path = Path(str(sample["code_file_path"]))
                assert code_file_path.is_file()
                if key in code_paths:
                    assert code_paths[key] == code_file_path
                    continue
                code_paths[key] = code_file_path
    assert code_paths
    return code_paths


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def method_id(technique: str) -> str:
    if technique == "classic":
        return "classic_revolution"
    return technique


def extract_feature(
    evaluator: RTLDescriptorEvaluator,
    code_file_path: Path,
    row: dict[str, str],
) -> CandidateFeature:
    assert code_file_path.is_file()
    text = code_file_path.read_text(encoding="utf-8", errors="ignore")
    metrics = evaluator.extract_text_metrics(text)
    operator_pressure = (
        metrics["arith_count"]
        + metrics["compare_count"]
        + metrics["logic_op_count"]
        + (2.0 * metrics["mul_count"])
        + metrics["max_rhs_operator_count"]
    )
    return CandidateFeature(
        method=row["method"],
        method_label=METHOD_LABELS.get(row["method"], row["method_label"]),
        benchmark=row["benchmark"],
        problem=row["problem"],
        candidate_id=row["candidate_id"],
        generation=int(row["generation"]),
        is_front=parse_bool(row["is_pareto_front"]),
        code_file_path=code_file_path,
        line_count=metrics["rtl_nonempty_line_count"],
        operator_pressure_score=operator_pressure,
        timing_risk_score=metrics["timing_risk_score"],
        control_pipeline_ratio=metrics["control_pipeline_ratio"],
        pipeline_event_count=metrics["pipeline_event_count"],
        control_count=metrics["control_count"],
        timing_risk_entropy=metrics["timing_risk_entropy"],
        unique_identifier_count=metrics["unique_identifier_count"],
    )


def parse_bool(value: str) -> bool:
    if value == "True" or value == "true":
        return True
    if value == "False" or value == "false":
        return False
    raise AssertionError(f"unknown bool: {value}")


def assign_cells(features: list[CandidateFeature]) -> list[CandidateFeature]:
    output = features
    for profile, axes in PROFILES.items():
        profile_output = []
        for problem in sorted({feature.problem for feature in output}):
            group = [feature for feature in output if feature.problem == problem]
            profile_output.extend(assign_profile_cells(group, profile, axes))
        output = profile_output
    return output


def assign_profile_cells(
    group: list[CandidateFeature],
    profile: str,
    axes: tuple[str, str],
) -> list[CandidateFeature]:
    xs = sorted(feature_value(feature, axes[0]) for feature in group)
    ys = sorted(feature_value(feature, axes[1]) for feature in group)
    output = []
    for feature in group:
        cell = f"{rank_bin(feature_value(feature, axes[0]), xs)},{rank_bin(feature_value(feature, axes[1]), ys)}"
        if profile == "timing_risk":
            output.append(replace(feature, timing_risk_cell=cell))
        elif profile == "operator_timing":
            output.append(replace(feature, operator_timing_cell=cell))
        elif profile == "control_pipeline":
            output.append(replace(feature, control_pipeline_cell=cell))
        else:
            raise AssertionError(f"unknown profile: {profile}")
    return output


def feature_value(feature: CandidateFeature, name: str) -> float:
    if name == "control_pipeline_ratio":
        return feature.control_pipeline_ratio
    if name == "timing_risk_score":
        return feature.timing_risk_score
    if name == "operator_pressure_score":
        return feature.operator_pressure_score
    if name == "control_count":
        return feature.control_count
    if name == "pipeline_event_count":
        return feature.pipeline_event_count
    raise AssertionError(f"unknown feature: {name}")


def rank_bin(value: float, sorted_values: list[float]) -> int:
    index = sorted_values.index(value)
    return min(3, int(index * 4 / len(sorted_values)))


def feature_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    return [
        {
            "method": feature.method,
            "method_label": feature.method_label,
            "benchmark": feature.benchmark,
            "problem": feature.problem,
            "candidate_id": feature.candidate_id,
            "generation": str(feature.generation),
            "is_front": str(feature.is_front).lower(),
            "line_count": fmt(feature.line_count),
            "operator_pressure_score": fmt(feature.operator_pressure_score),
            "timing_risk_score": fmt(feature.timing_risk_score),
            "control_pipeline_ratio": fmt(feature.control_pipeline_ratio),
            "pipeline_event_count": fmt(feature.pipeline_event_count),
            "control_count": fmt(feature.control_count),
            "timing_risk_entropy": fmt(feature.timing_risk_entropy),
            "unique_identifier_count": fmt(feature.unique_identifier_count),
            "timing_risk_cell": feature.timing_risk_cell,
            "operator_timing_cell": feature.operator_timing_cell,
            "control_pipeline_cell": feature.control_pipeline_cell,
            "code_file_path": str(feature.code_file_path),
        }
        for feature in features
    ]


def metric_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    for profile in PROFILES:
        for method in sorted({feature.method for feature in features}):
            subset = [feature for feature in features if feature.method == method]
            rows.append(summary_row("all", profile, method, subset))
    return rows


def problem_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    keys = sorted({(feature.method, feature.problem) for feature in features})
    for profile in PROFILES:
        for method, problem in keys:
            subset = [
                feature
                for feature in features
                if feature.method == method and feature.problem == problem
            ]
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
        "method_label": subset[0].method_label,
        "candidate_count": str(len(subset)),
        "front_count": str(len(front)),
        "occupied_cells": str(len({profile_cell(feature, profile) for feature in subset})),
        "front_cells": str(len({profile_cell(feature, profile) for feature in front})),
        "mean_timing_risk_score": fmt(mean([feature.timing_risk_score for feature in subset])),
        "mean_front_timing_risk_score": fmt(mean([feature.timing_risk_score for feature in front])),
        "mean_operator_pressure_score": fmt(
            mean([feature.operator_pressure_score for feature in subset])
        ),
        "mean_front_operator_pressure_score": fmt(
            mean([feature.operator_pressure_score for feature in front])
        ),
    }


def profile_cell(feature: CandidateFeature, profile: str) -> str:
    if profile == "timing_risk":
        return feature.timing_risk_cell
    if profile == "operator_timing":
        return feature.operator_timing_cell
    if profile == "control_pipeline":
        return feature.control_pipeline_cell
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
            classic = by_key[(problem, profile, "classic_revolution")]
            for method in methods:
                other = by_key.get((problem, profile, method))
                if other is None:
                    continue
                output.append(
                    {
                        "problem": problem,
                        "profile": profile,
                        "method": method,
                        "method_label": other["method_label"],
                        "front_cell_delta": delta(other, classic, "front_cells"),
                        "occupied_cell_delta": delta(other, classic, "occupied_cells"),
                        "front_count_delta": delta(other, classic, "front_count"),
                        "candidate_count_delta": delta(other, classic, "candidate_count"),
                    }
                )
    return output


def delta_summary_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for method in sorted({row["method"] for row in rows}):
        for profile in PROFILES:
            subset = [row for row in rows if row["method"] == method and row["profile"] == profile]
            front = [float(row["front_cell_delta"]) for row in subset]
            occupied = [float(row["occupied_cell_delta"]) for row in subset]
            output.append(
                {
                    "method": method,
                    "method_label": subset[0]["method_label"],
                    "profile": profile,
                    "mean_front_cell_delta": fmt(mean(front)),
                    "front_positive": str(sum(value > 0 for value in front)),
                    "front_negative": str(sum(value < 0 for value in front)),
                    "front_tie": str(sum(value == 0 for value in front)),
                    "mean_occupied_cell_delta": fmt(mean(occupied)),
                    "occupied_positive": str(sum(value > 0 for value in occupied)),
                    "occupied_negative": str(sum(value < 0 for value in occupied)),
                    "occupied_tie": str(sum(value == 0 for value in occupied)),
                }
            )
    return output


def delta(left: dict[str, str], right: dict[str, str], key: str) -> str:
    return fmt(float(left[key]) - float(right[key]))


def write_delta_figure(rows: list[dict[str, str]], path: Path) -> None:
    labels = [
        f"{METHOD_SHORT_LABELS[row['method']]}\n{PROFILE_SHORT_LABELS[row['profile']]}"
        for row in rows
    ]
    front = [float(row["mean_front_cell_delta"]) for row in rows]
    occupied = [float(row["mean_occupied_cell_delta"]) for row in rows]
    x_positions = range(len(rows))
    fig, ax = plt.subplots(figsize=(13.0, 6.4))
    ax.bar([x - 0.18 for x in x_positions], front, width=0.36, color="#4e79a7", label="Front cells")
    ax.bar(
        [x + 0.18 for x in x_positions],
        occupied,
        width=0.36,
        color="#f28e2b",
        label="Occupied cells",
    )
    ax.axhline(0.0, color="#333333", linewidth=1.0)
    ax.set_xticks(list(x_positions), labels, rotation=35, ha="right")
    ax.set_ylabel("Mean Delta Versus Classic")
    ax.set_title("Secondary RTL-Native Cell Deltas")
    ax.grid(axis="y", alpha=0.25)
    ax.legend(frameon=False)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def write_heatmap(features: list[CandidateFeature], rows: list[dict[str, str]], path: Path) -> str:
    best = max(rows, key=lambda row: float(row["mean_front_cell_delta"]))
    profile = best["profile"]
    methods = ["classic_revolution"] + sorted(
        {feature.method for feature in features if feature.method != "classic_revolution"}
    )
    max_count = 1
    grids: dict[str, list[list[int]]] = {}
    for method in methods:
        grid = [[0 for _ in range(4)] for _ in range(4)]
        for feature in features:
            if feature.method == method and feature.is_front:
                x_text, y_text = profile_cell(feature, profile).split(",")
                grid[int(y_text)][int(x_text)] += 1
        max_count = max(max_count, max(max(row) for row in grid))
        grids[method] = grid
    fig, axes = plt.subplots(1, len(methods), figsize=(4.7 * len(methods), 4.6), squeeze=False)
    for ax, method in zip(axes[0], methods, strict=True):
        image = ax.imshow(grids[method], cmap="YlGnBu", origin="lower", vmin=0, vmax=max_count)
        ax.set_title(METHOD_LABELS.get(method, method))
        ax.set_xlabel("Axis 0 bin")
        ax.set_ylabel("Axis 1 bin")
        ax.set_xticks([0, 1, 2, 3])
        ax.set_yticks([0, 1, 2, 3])
        for y, values in enumerate(grids[method]):
            for x, value in enumerate(values):
                ax.text(x, y, str(value), ha="center", va="center", fontsize=9)
        fig.colorbar(image, ax=ax, fraction=0.046, pad=0.04)
    fig.suptitle(f"Front Candidates In Secondary Cells: {PROFILE_LABELS[profile]}")
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return profile


def write_projection(features: list[CandidateFeature], path: Path) -> None:
    colors = {
        "classic_revolution": "#4e79a7",
        "code_thought_front_slot_qd": "#f28e2b",
        "fused_rtl_state_pipeline_qd": "#59a14f",
        "fused_rtl_operator_timing_qd": "#e15759",
    }
    fig, ax = plt.subplots(figsize=(9.5, 6.2))
    for method in sorted({feature.method for feature in features}):
        subset = [feature for feature in features if feature.method == method]
        color = colors.get(method, "#79706e")
        ax.scatter(
            [feature.control_pipeline_ratio for feature in subset],
            [feature.timing_risk_score for feature in subset],
            s=18,
            alpha=0.22,
            color=color,
            label=subset[0].method_label,
        )
        front = [feature for feature in subset if feature.is_front]
        ax.scatter(
            [feature.control_pipeline_ratio for feature in front],
            [feature.timing_risk_score for feature in front],
            s=42,
            alpha=0.88,
            facecolors="none",
            edgecolors=color,
            linewidths=1.1,
        )
    ax.set_title("RTLTimer-Style Secondary Descriptor Projection")
    ax.set_xlabel("Control / Pipeline Ratio")
    ax.set_ylabel("Timing-Risk Score")
    ax.grid(True, alpha=0.25)
    ax.legend(frameon=False)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def write_notes(path: Path, best_profile: str) -> None:
    lines = [
        "# T65 Visual Inspection Notes",
        "",
        "- `secondary_cell_delta_summary.png` uses a zero baseline so positive",
        "  front-cell or occupied-cell deltas are visually separable from losses.",
        "- `front_cell_heatmap.png` uses shared color limits across methods and",
        f"  shows the best observed profile: `{PROFILE_LABELS[best_profile]}`.",
        "- `timing_risk_projection.png` uses hollow markers for direct method",
        "  Pareto-front candidates and translucent filled markers for all valid",
        "  PPA candidates.",
        "- The descriptors are source-level RTL features. They do not use final",
        "  PPA, reference PPA, hypervolume, Pareto rank, fitness, or tests as BD",
        "  inputs.",
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
    parser.add_argument("--dataset-dir", type=Path, action="append", required=True)
    parser.add_argument("--candidate-csv", type=Path, action="append", required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    features = load_features(args.dataset_dir, args.candidate_csv)
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    write_csv(table_dir / "secondary_rtl_features.csv", feature_rows(features))
    aggregate = metric_rows(features)
    per_problem = problem_rows(features)
    deltas = comparison_rows(per_problem)
    delta_summary = delta_summary_rows(deltas)
    write_csv(table_dir / "secondary_cell_metrics.csv", aggregate)
    write_csv(table_dir / "secondary_problem_metrics.csv", per_problem)
    write_csv(table_dir / "secondary_deltas_vs_classic.csv", deltas)
    write_csv(table_dir / "secondary_delta_summary.csv", delta_summary)
    write_delta_figure(delta_summary, figure_dir / "secondary_cell_delta_summary.png")
    best_profile = write_heatmap(features, delta_summary, figure_dir / "front_cell_heatmap.png")
    write_projection(features, figure_dir / "timing_risk_projection.png")
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
