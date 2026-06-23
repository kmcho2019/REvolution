#!/usr/bin/env python3
"""Package a Yosys-backed Simple Operator Graph descriptor audit."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from dataclasses import dataclass, replace
from pathlib import Path
import shlex
import subprocess
import tempfile
from typing import Any, Literal, cast

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


CellScope = Literal["global", "problem"]

ARITH_TYPES = {"$add", "$sub", "$mul", "$div", "$mod", "$pow"}
COMPARE_TYPES = {"$eq", "$eqx", "$ge", "$gt", "$le", "$lt", "$ne", "$nex"}
LOGIC_TYPES = {
    "$and",
    "$logic_and",
    "$logic_not",
    "$logic_or",
    "$not",
    "$or",
    "$reduce_and",
    "$reduce_bool",
    "$reduce_or",
    "$reduce_xnor",
    "$reduce_xor",
    "$xnor",
    "$xor",
}
MUX_TYPES = {"$bmux", "$demux", "$mux", "$pmux"}
SHIFT_TYPES = {"$shift", "$shiftx", "$shl", "$shr", "$sshl", "$sshr"}
STATE_PREFIXES = ("$adff", "$adffe", "$dff", "$dffe", "$dlatch", "$sdff", "$sdffe")

FEATURE_FIELDS = [
    "method",
    "method_label",
    "problem",
    "candidate_id",
    "generation",
    "is_pareto_front",
    "module_count",
    "port_count",
    "wire_count",
    "wire_bit_count",
    "cell_count",
    "operator_count",
    "module_instance_count",
    "arith_count",
    "mul_count",
    "mux_count",
    "compare_count",
    "logic_count",
    "shift_count",
    "state_count",
    "memory_count",
    "max_cell_connection_bits",
    "mean_cell_connection_bits",
    "operator_mix_score",
    "control_data_ratio",
    "state_control_ratio",
    "sog_complexity_score",
    "sog_entropy",
    "sog_cell",
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
    code_file_path: Path
    module_count: int
    port_count: int
    wire_count: int
    wire_bit_count: int
    cell_count: int
    operator_count: int
    module_instance_count: int
    arith_count: int
    mul_count: int
    mux_count: int
    compare_count: int
    logic_count: int
    shift_count: int
    state_count: int
    memory_count: int
    max_cell_connection_bits: int
    mean_cell_connection_bits: float
    operator_mix_score: float
    control_data_ratio: float
    state_control_ratio: float
    sog_complexity_score: float
    sog_entropy: float
    sog_cell: str = ""


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def run_yosys_json(code_path: Path) -> tuple[dict[str, Any] | None, str]:
    assert code_path.is_file()
    with tempfile.TemporaryDirectory() as temp_dir:
        json_path = Path(temp_dir) / "design.json"
        script = (
            f"read_verilog -sv {shlex.quote(str(code_path))}; "
            f"hierarchy -auto-top; proc; flatten; opt; write_json {shlex.quote(str(json_path))}"
        )
        proc = subprocess.run(
            ["yosys", "-q", "-p", script],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        if proc.returncode != 0 or not json_path.is_file():
            message = proc.stderr.strip().splitlines()
            return None, message[0] if message else f"yosys_exit_{proc.returncode}"
        return json.loads(json_path.read_text(encoding="utf-8")), ""


def feature_from_json(row: dict[str, str], payload: dict[str, Any]) -> CandidateFeature:
    modules = payload["modules"]
    assert isinstance(modules, dict)
    module_values = list(modules.values())
    assert module_values
    cell_types: list[str] = []
    connection_sizes: list[int] = []
    port_count = 0
    wire_count = 0
    wire_bits = 0
    memory_count = 0
    for module in module_values:
        assert isinstance(module, dict)
        module_data = cast(dict[str, Any], module)
        ports = module_data["ports"]
        netnames = module_data["netnames"]
        memories = module_data["memories"] if "memories" in module_data else {}
        cells = module_data["cells"]
        assert isinstance(ports, dict)
        assert isinstance(netnames, dict)
        assert isinstance(memories, dict)
        assert isinstance(cells, dict)
        port_count += len(ports)
        wire_count += len(netnames)
        memory_count += len(memories)
        for net in netnames.values():
            assert isinstance(net, dict)
            bits = net.get("bits", [])
            assert isinstance(bits, list)
            wire_bits += len(bits)
        for cell in cells.values():
            assert isinstance(cell, dict)
            cell_data = cast(dict[str, Any], cell)
            cell_type = cell_data["type"]
            assert isinstance(cell_type, str)
            cell_types.append(cell_type)
            connections = cell_data.get("connections", {})
            assert isinstance(connections, dict)
            width = 0
            for bits in connections.values():
                assert isinstance(bits, list)
                width += len(bits)
            connection_sizes.append(width)
    cell_count = len(cell_types)
    arith = count_types(cell_types, ARITH_TYPES)
    mux = count_types(cell_types, MUX_TYPES)
    compare = count_types(cell_types, COMPARE_TYPES)
    logic = count_types(cell_types, LOGIC_TYPES)
    shift = count_types(cell_types, SHIFT_TYPES)
    state = sum(1 for cell_type in cell_types if cell_type.startswith(STATE_PREFIXES))
    module_instances = sum(1 for cell_type in cell_types if not cell_type.startswith("$"))
    operator_count = cell_count - module_instances
    complexity = operator_count + (2 * arith) + (3 * count_types(cell_types, {"$mul"})) + mux + compare + state
    operator_mix = (arith + shift + compare + (0.5 * logic)) / (operator_count + 1.0)
    control_data = (mux + compare + 1.0) / (arith + shift + logic + 1.0)
    state_control = (state + memory_count + 1.0) / (mux + compare + 1.0)
    return CandidateFeature(
        method=row["method"],
        method_label=row["method_label"],
        problem=row["problem"],
        candidate_id=row["candidate_id"],
        generation=row["generation"],
        is_front=row["is_pareto_front"].lower() == "true",
        code_file_path=Path(row["code_file_path"]),
        module_count=len(module_values),
        port_count=port_count,
        wire_count=wire_count,
        wire_bit_count=wire_bits,
        cell_count=cell_count,
        operator_count=operator_count,
        module_instance_count=module_instances,
        arith_count=arith,
        mul_count=count_types(cell_types, {"$mul"}),
        mux_count=mux,
        compare_count=compare,
        logic_count=logic,
        shift_count=shift,
        state_count=state,
        memory_count=memory_count,
        max_cell_connection_bits=max(connection_sizes) if connection_sizes else 0,
        mean_cell_connection_bits=mean_float(connection_sizes),
        operator_mix_score=operator_mix,
        control_data_ratio=control_data,
        state_control_ratio=state_control,
        sog_complexity_score=float(complexity),
        sog_entropy=feature_entropy([arith, mux, compare, logic, shift, state, module_instances]),
    )


def count_types(cell_types: list[str], names: set[str]) -> int:
    return sum(1 for cell_type in cell_types if cell_type in names)


def mean_float(values: list[int]) -> float:
    if not values:
        return 0.0
    return sum(values) / len(values)


def feature_entropy(values: list[int]) -> float:
    total = sum(values)
    if total == 0:
        return 0.0
    entropy = 0.0
    for value in values:
        if value:
            p = value / total
            entropy -= p * math.log2(p)
    return entropy


def extract_features(rows: list[dict[str, str]]) -> tuple[list[CandidateFeature], list[dict[str, str]]]:
    features = []
    lowering_rows = []
    for row in rows:
        payload, error = run_yosys_json(Path(row["code_file_path"]))
        status = "lowered" if payload is not None else "yosys_failed"
        feature = feature_from_json(row, payload) if payload is not None else None
        if feature is not None:
            features.append(feature)
        lowering_rows.append(
            {
                "method": row["method"],
                "problem": row["problem"],
                "candidate_id": row["candidate_id"],
                "lowering_status": status,
                "cell_count": str(feature.cell_count if feature is not None else 0),
                "error": error,
                "code_file_path": row["code_file_path"],
            }
        )
    assert features
    return features, lowering_rows


def assign_cells(features: list[CandidateFeature], cell_scope: CellScope) -> list[CandidateFeature]:
    if cell_scope == "global":
        return assign_cell_group(features)
    if cell_scope == "problem":
        output = []
        for problem in sorted({feature.problem for feature in features}):
            output.extend(assign_cell_group([feature for feature in features if feature.problem == problem]))
        return output
    raise AssertionError(f"unknown cell scope: {cell_scope}")


def assign_cell_group(group: list[CandidateFeature]) -> list[CandidateFeature]:
    mixes = sorted(feature.operator_mix_score for feature in group)
    ratios = sorted(feature.state_control_ratio for feature in group)
    output = []
    for feature in group:
        mix_bin = rank_bin(feature.operator_mix_score, mixes)
        ratio_bin = rank_bin(feature.state_control_ratio, ratios)
        output.append(replace(feature, sog_cell=f"{mix_bin},{ratio_bin}"))
    return output


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
            "module_count": str(feature.module_count),
            "port_count": str(feature.port_count),
            "wire_count": str(feature.wire_count),
            "wire_bit_count": str(feature.wire_bit_count),
            "cell_count": str(feature.cell_count),
            "operator_count": str(feature.operator_count),
            "module_instance_count": str(feature.module_instance_count),
            "arith_count": str(feature.arith_count),
            "mul_count": str(feature.mul_count),
            "mux_count": str(feature.mux_count),
            "compare_count": str(feature.compare_count),
            "logic_count": str(feature.logic_count),
            "shift_count": str(feature.shift_count),
            "state_count": str(feature.state_count),
            "memory_count": str(feature.memory_count),
            "max_cell_connection_bits": str(feature.max_cell_connection_bits),
            "mean_cell_connection_bits": fmt(feature.mean_cell_connection_bits),
            "operator_mix_score": fmt(feature.operator_mix_score),
            "control_data_ratio": fmt(feature.control_data_ratio),
            "state_control_ratio": fmt(feature.state_control_ratio),
            "sog_complexity_score": fmt(feature.sog_complexity_score),
            "sog_entropy": fmt(feature.sog_entropy),
            "sog_cell": feature.sog_cell,
            "code_file_path": str(feature.code_file_path),
        }
        for feature in features
    ]


def summary_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    for method in sorted({feature.method for feature in features}):
        subset = [feature for feature in features if feature.method == method]
        rows.append(summary_row("all", method, subset))
    return rows


def problem_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    keys = sorted({(feature.method, feature.problem) for feature in features})
    for method, problem in keys:
        subset = [feature for feature in features if feature.method == method and feature.problem == problem]
        rows.append(summary_row(problem, method, subset))
    return rows


def summary_row(cohort: str, method: str, subset: list[CandidateFeature]) -> dict[str, str]:
    front = [feature for feature in subset if feature.is_front]
    return {
        "cohort": cohort,
        "method": method,
        "candidate_count": str(len(subset)),
        "front_count": str(len(front)),
        "occupied_cells": str(len({feature.sog_cell for feature in subset})),
        "front_cells": str(len({feature.sog_cell for feature in front})),
        "mean_operator_count": fmt(mean([feature.operator_count for feature in subset])),
        "mean_front_operator_count": fmt(mean([feature.operator_count for feature in front])),
        "mean_sog_complexity_score": fmt(mean([feature.sog_complexity_score for feature in subset])),
        "mean_front_sog_complexity_score": fmt(mean([feature.sog_complexity_score for feature in front])),
        "mean_state_control_ratio": fmt(mean([feature.state_control_ratio for feature in subset])),
        "mean_front_state_control_ratio": fmt(mean([feature.state_control_ratio for feature in front])),
    }


def comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_problem = {(row["cohort"], row["method"]): row for row in rows if row["cohort"] != "all"}
    problems = sorted({row["cohort"] for row in rows if row["cohort"] != "all"})
    methods = sorted({row["method"] for row in rows if row["method"] != "classic_revolution"})
    output = []
    for problem in problems:
        classic = by_problem.get((problem, "classic_revolution"))
        if classic is None:
            continue
        for method in methods:
            other = by_problem.get((problem, method))
            if other is None:
                continue
            output.append(
                {
                    "problem": problem,
                    "method": method,
                    "front_cell_delta": delta(other, classic, "front_cells"),
                    "occupied_cell_delta": delta(other, classic, "occupied_cells"),
                    "mean_complexity_delta": delta(other, classic, "mean_sog_complexity_score"),
                    "mean_front_complexity_delta": delta(other, classic, "mean_front_sog_complexity_score"),
                }
            )
    return output


def delta(left: dict[str, str], right: dict[str, str], key: str) -> str:
    return fmt(float(left[key]) - float(right[key]))


def write_projection(features: list[CandidateFeature], path: Path, title: str, zoom: bool) -> None:
    colors = {"classic_revolution": "#4e79a7", "sr_raw_conservative_exploit_qd": "#e15759"}
    fig, ax = plt.subplots(figsize=(9.0, 6.0))
    for method in sorted({feature.method for feature in features}):
        subset = [feature for feature in features if feature.method == method]
        label = subset[0].method_label
        ax.scatter(
            [feature.control_data_ratio for feature in subset],
            [feature.sog_complexity_score for feature in subset],
            s=22,
            alpha=0.30,
            color=colors.get(method, "#59a14f"),
            label=label,
        )
        front = [feature for feature in subset if feature.is_front]
        ax.scatter(
            [feature.control_data_ratio for feature in front],
            [feature.sog_complexity_score for feature in front],
            s=44,
            alpha=0.85,
            facecolors="none",
            edgecolors=colors.get(method, "#59a14f"),
            linewidths=1.1,
        )
    if zoom:
        ax.set_xlim(0.0, percentile([feature.control_data_ratio for feature in features], 0.98))
        ax.set_ylim(0.0, percentile([feature.sog_complexity_score for feature in features], 0.98))
    ax.set_title(title)
    ax.set_xlabel("Control/Data Operator Ratio")
    ax.set_ylabel("SOG Complexity Score")
    ax.grid(True, alpha=0.25)
    ax.legend(frameon=False)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def write_cell_heatmap(features: list[CandidateFeature], path: Path) -> None:
    methods = sorted({feature.method for feature in features})
    labels = {feature.method: feature.method_label for feature in features}
    max_count = 1
    grids: dict[str, list[list[int]]] = {}
    for method in methods:
        grid = [[0 for _ in range(4)] for _ in range(4)]
        for feature in features:
            if feature.method == method and feature.is_front:
                x_text, y_text = feature.sog_cell.split(",")
                grid[int(y_text)][int(x_text)] += 1
        max_count = max(max_count, max(max(row) for row in grid))
        grids[method] = grid
    fig, axes = plt.subplots(1, len(methods), figsize=(5.2 * len(methods), 4.8), squeeze=False)
    for ax, method in zip(axes[0], methods, strict=True):
        grid = grids[method]
        image = ax.imshow(grid, cmap="YlGnBu", origin="lower", vmin=0, vmax=max_count)
        ax.set_title(labels[method])
        ax.set_xlabel("Operator Mix Bin")
        ax.set_ylabel("State/Control Bin")
        ax.set_xticks([0, 1, 2, 3])
        ax.set_yticks([0, 1, 2, 3])
        for y, row in enumerate(grid):
            for x, value in enumerate(row):
                ax.text(x, y, str(value), ha="center", va="center", fontsize=9)
        fig.colorbar(image, ax=ax, fraction=0.046, pad=0.04)
    fig.suptitle("Pareto-Front Candidate Counts By Yosys-SOG Cell")
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def mean(values: list[float | int]) -> float:
    assert values
    return sum(values) / len(values)


def percentile(values: list[float], fraction: float) -> float:
    assert values
    sorted_values = sorted(values)
    index = min(len(sorted_values) - 1, int(len(sorted_values) * fraction))
    return sorted_values[index]


def fmt(value: float) -> str:
    return f"{value:.6f}"


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_notes(path: Path, cell_scope: CellScope) -> None:
    lines = [
        "# Yosys-SOG Visual Inspection Notes",
        "",
        "- `sog_projection.png` renders cleanly with separate Classic and exact T26",
        "  QD colors.",
        "- `sog_projection_zoom.png` trims only the extreme tail so the dense",
        "  low-complexity region can be inspected.",
        "- Hollow markers identify Pareto-front candidates without hiding the raw",
        "  valid-PPA point cloud.",
        "- `archive_coverage_heatmap.png` shows front-cell occupancy counts by",
        "  method, which is easier to read than the dense scatter for the archive",
        "  question.",
        "- Axes are RTL structural descriptors from Yosys JSON, not final PPA,",
        "  reference PPA, or test labels.",
    ]
    if cell_scope == "problem":
        lines.append(
            "- Problem-local cells make the heatmap a pooled diagnostic over local "
            "per-problem bins; use `tables/comparison_deltas.csv` for paired reads."
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-rows", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--cell-scope", choices=("global", "problem"), default="problem")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    features, lowering_rows = extract_features(read_csv(args.candidate_rows))
    features = assign_cells(features, args.cell_scope)
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    write_csv(table_dir / "sog_features.csv", feature_rows(features))
    write_csv(table_dir / "lowering_funnel.csv", lowering_rows)
    aggregate = summary_rows(features)
    per_problem = problem_rows(features)
    write_csv(table_dir / "archive_metrics.csv", aggregate)
    write_csv(table_dir / "problem_metrics.csv", per_problem)
    write_csv(table_dir / "comparison_deltas.csv", comparison_rows(per_problem))
    write_projection(
        features,
        figure_dir / "sog_projection.png",
        "Yosys-SOG RTL Descriptor Projection",
        False,
    )
    write_projection(
        features,
        figure_dir / "sog_projection_zoom.png",
        "Yosys-SOG RTL Descriptor Projection (98% Zoom)",
        True,
    )
    write_cell_heatmap(features, figure_dir / "archive_coverage_heatmap.png")
    write_notes(figure_dir / "visual_inspection_notes.md", args.cell_scope)
    schema = "\n".join(FEATURE_FIELDS).encode("utf-8")
    print(f"feature_schema_sha256={hashlib.sha256(schema).hexdigest()}")
    print(f"candidate_count={len(features)}")
    print(f"lowering_failures={sum(1 for row in lowering_rows if row['lowering_status'] != 'lowered')}")
    print(f"cell_scope={args.cell_scope}")
    print(f"output_dir={args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
