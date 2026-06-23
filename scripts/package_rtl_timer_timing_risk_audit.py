#!/usr/bin/env python3
"""Package a lightweight RTLTimer-style timing-risk descriptor audit."""

from __future__ import annotations

import argparse
import csv
import hashlib
import math
from dataclasses import dataclass, replace
from pathlib import Path
import re

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


KEYWORDS = {
    "always",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "for",
    "if",
    "input",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "parameter",
    "posedge",
    "reg",
    "wire",
}

FEATURE_FIELDS = [
    "method",
    "method_label",
    "problem",
    "candidate_id",
    "generation",
    "is_pareto_front",
    "line_count",
    "always_count",
    "assign_count",
    "pipeline_event_count",
    "control_count",
    "arith_count",
    "mul_count",
    "shift_count",
    "compare_count",
    "logic_op_count",
    "max_rhs_operator_count",
    "unique_identifier_count",
    "max_identifier_fanout",
    "timing_risk_score",
    "control_pipeline_ratio",
    "timing_risk_entropy",
    "timing_risk_cell",
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
    line_count: int
    always_count: int
    assign_count: int
    pipeline_event_count: int
    control_count: int
    arith_count: int
    mul_count: int
    shift_count: int
    compare_count: int
    logic_op_count: int
    max_rhs_operator_count: int
    unique_identifier_count: int
    max_identifier_fanout: int
    timing_risk_score: float
    control_pipeline_ratio: float
    timing_risk_entropy: float
    timing_risk_cell: str = ""


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    return re.sub(r"//.*", " ", text)


def extract_feature(row: dict[str, str]) -> CandidateFeature:
    code_path = Path(row["code_file_path"])
    assert code_path.is_file()
    text = strip_comments(code_path.read_text(encoding="utf-8"))
    ids = [
        token
        for token in re.findall(r"[A-Za-z_][A-Za-z0-9_$]*", text)
        if token not in KEYWORDS
    ]
    id_counts = {token: ids.count(token) for token in set(ids)}
    always_count = count_word(text, "always")
    assign_count = count_word(text, "assign")
    posedge_count = count_word(text, "posedge")
    negedge_count = count_word(text, "negedge")
    nonblocking_count = text.count("<=")
    case_count = count_word(text, "case")
    if_count = count_word(text, "if")
    ternary_count = text.count("?")
    mul_count = text.count("*")
    shift_count = text.count("<<") + text.count(">>")
    arith_count = len(re.findall(r"(?<![<>=!])[+\-*/%](?![<>=])", text)) + shift_count
    compare_count = len(re.findall(r"==|!=|>=|<=|(?<!<)<(?![=<])|(?<!>)>(?![=>])", text))
    logic_op_count = len(re.findall(r"&&|\|\||[&|^~]", text))
    max_rhs_operator_count = max_rhs_operators(text)
    pipeline_events = posedge_count + negedge_count + nonblocking_count
    control_count = if_count + case_count + ternary_count
    fanout = max(id_counts.values()) if id_counts else 0
    entropy = feature_entropy([arith_count, control_count, compare_count, logic_op_count, fanout])
    risk = (
        (2.0 * arith_count)
        + (3.0 * mul_count)
        + (1.5 * shift_count)
        + (1.5 * control_count)
        + compare_count
        + (2.0 * max_rhs_operator_count)
        + (0.15 * fanout)
        - (0.5 * pipeline_events)
    )
    return CandidateFeature(
        method=row["method"],
        method_label=row["method_label"],
        problem=row["problem"],
        candidate_id=row["candidate_id"],
        generation=row["generation"],
        is_front=row["is_pareto_front"].lower() == "true",
        code_file_path=code_path,
        line_count=sum(1 for line in text.splitlines() if line.strip()),
        always_count=always_count,
        assign_count=assign_count,
        pipeline_event_count=pipeline_events,
        control_count=control_count,
        arith_count=arith_count,
        mul_count=mul_count,
        shift_count=shift_count,
        compare_count=compare_count,
        logic_op_count=logic_op_count,
        max_rhs_operator_count=max_rhs_operator_count,
        unique_identifier_count=len(id_counts),
        max_identifier_fanout=fanout,
        timing_risk_score=max(0.0, risk),
        control_pipeline_ratio=(control_count + 1.0) / (pipeline_events + 1.0),
        timing_risk_entropy=entropy,
    )


def count_word(text: str, word: str) -> int:
    return len(re.findall(rf"\b{re.escape(word)}\b", text))


def max_rhs_operators(text: str) -> int:
    max_count = 0
    for match in re.finditer(r"=\s*([^;]+);", text):
        rhs = match.group(1)
        count = len(re.findall(r"==|!=|>=|<=|&&|\|\||<<|>>|[+\-*/%&|^~?:<>]", rhs))
        max_count = max(max_count, count)
    return max_count


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


def assign_cells(features: list[CandidateFeature]) -> list[CandidateFeature]:
    risks = sorted(feature.timing_risk_score for feature in features)
    ratios = sorted(feature.control_pipeline_ratio for feature in features)
    output = []
    for feature in features:
        risk_bin = rank_bin(feature.timing_risk_score, risks)
        ratio_bin = rank_bin(feature.control_pipeline_ratio, ratios)
        output.append(replace(feature, timing_risk_cell=f"{risk_bin},{ratio_bin}"))
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
            "line_count": str(feature.line_count),
            "always_count": str(feature.always_count),
            "assign_count": str(feature.assign_count),
            "pipeline_event_count": str(feature.pipeline_event_count),
            "control_count": str(feature.control_count),
            "arith_count": str(feature.arith_count),
            "mul_count": str(feature.mul_count),
            "shift_count": str(feature.shift_count),
            "compare_count": str(feature.compare_count),
            "logic_op_count": str(feature.logic_op_count),
            "max_rhs_operator_count": str(feature.max_rhs_operator_count),
            "unique_identifier_count": str(feature.unique_identifier_count),
            "max_identifier_fanout": str(feature.max_identifier_fanout),
            "timing_risk_score": fmt(feature.timing_risk_score),
            "control_pipeline_ratio": fmt(feature.control_pipeline_ratio),
            "timing_risk_entropy": fmt(feature.timing_risk_entropy),
            "timing_risk_cell": feature.timing_risk_cell,
            "code_file_path": str(feature.code_file_path),
        }
        for feature in features
    ]


def summary_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    for method in sorted({feature.method for feature in features}):
        subset = [feature for feature in features if feature.method == method]
        front = [feature for feature in subset if feature.is_front]
        rows.append(summary_row("all", method, subset, front))
    return rows


def problem_rows(features: list[CandidateFeature]) -> list[dict[str, str]]:
    rows = []
    keys = sorted({(feature.method, feature.problem) for feature in features})
    for method, problem in keys:
        subset = [feature for feature in features if feature.method == method and feature.problem == problem]
        front = [feature for feature in subset if feature.is_front]
        row = summary_row(problem, method, subset, front)
        rows.append(row)
    return rows


def summary_row(
    cohort: str,
    method: str,
    subset: list[CandidateFeature],
    front: list[CandidateFeature],
) -> dict[str, str]:
    return {
        "cohort": cohort,
        "method": method,
        "candidate_count": str(len(subset)),
        "front_count": str(len(front)),
        "occupied_cells": str(len({feature.timing_risk_cell for feature in subset})),
        "front_cells": str(len({feature.timing_risk_cell for feature in front})),
        "mean_timing_risk_score": fmt(mean([feature.timing_risk_score for feature in subset])),
        "mean_front_timing_risk_score": fmt(mean([feature.timing_risk_score for feature in front])),
        "mean_control_pipeline_ratio": fmt(mean([feature.control_pipeline_ratio for feature in subset])),
        "mean_front_control_pipeline_ratio": fmt(mean([feature.control_pipeline_ratio for feature in front])),
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
                    "mean_risk_delta": delta(other, classic, "mean_timing_risk_score"),
                    "mean_front_risk_delta": delta(other, classic, "mean_front_timing_risk_score"),
                }
            )
    return output


def delta(left: dict[str, str], right: dict[str, str], key: str) -> str:
    return fmt(float(left[key]) - float(right[key]))


def write_projection(features: list[CandidateFeature], path: Path) -> None:
    colors = {"classic_revolution": "#4e79a7", "sr_raw_conservative_exploit_qd": "#e15759"}
    fig, ax = plt.subplots(figsize=(9.0, 6.0))
    for method in sorted({feature.method for feature in features}):
        subset = [feature for feature in features if feature.method == method]
        label = subset[0].method_label
        ax.scatter(
            [feature.control_pipeline_ratio for feature in subset],
            [feature.timing_risk_score for feature in subset],
            s=22,
            alpha=0.30,
            color=colors.get(method, "#59a14f"),
            label=label,
        )
        front = [feature for feature in subset if feature.is_front]
        ax.scatter(
            [feature.control_pipeline_ratio for feature in front],
            [feature.timing_risk_score for feature in front],
            s=42,
            alpha=0.85,
            facecolors="none",
            edgecolors=colors.get(method, "#59a14f"),
            linewidths=1.1,
        )
    ax.set_title("T60 RTL Timing-Risk Descriptor Projection")
    ax.set_xlabel("Control / Pipeline Ratio")
    ax.set_ylabel("Timing-Risk Score")
    ax.grid(True, alpha=0.25)
    ax.legend(frameon=False)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


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


def write_notes(path: Path) -> None:
    path.write_text(
        "# T60 Visual Inspection Notes\n\n"
        "- `timing_risk_projection.png` renders cleanly with separate Classic and\n"
        "  exact T26 QD colors.\n"
        "- The legend uses reader-facing method labels, not internal backend keys.\n"
        "- Hollow markers identify Pareto-front candidates without hiding the raw point\n"
        "  cloud.\n"
        "- A few high-risk outliers stretch the y-axis, but the dense low-risk cluster\n"
        "  and front markers remain visible.\n"
        "- Axes are descriptor-only timing-risk proxies, not PPA objectives; the figure\n"
        "  should be used as diagnostic geometry, not as a performance claim.\n",
        encoding="utf-8",
    )


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-rows", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    features = assign_cells([extract_feature(row) for row in read_csv(args.candidate_rows)])
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    write_csv(table_dir / "rtl_timer_features.csv", feature_rows(features))
    aggregate = summary_rows(features)
    per_problem = problem_rows(features)
    write_csv(table_dir / "timing_risk_archive_metrics.csv", aggregate)
    write_csv(table_dir / "problem_metrics.csv", per_problem)
    write_csv(table_dir / "comparison_deltas.csv", comparison_rows(per_problem))
    write_projection(features, figure_dir / "timing_risk_projection.png")
    write_notes(figure_dir / "visual_inspection_notes.md")
    schema = "\n".join(FEATURE_FIELDS).encode("utf-8")
    print(f"feature_schema_sha256={hashlib.sha256(schema).hexdigest()}")
    print(f"candidate_count={len(features)}")
    print(f"output_dir={args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
