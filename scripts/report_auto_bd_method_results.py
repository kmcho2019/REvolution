#!/usr/bin/env python3
"""Generate method-local Auto-BD reports from the central JSON report."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

METHOD_DIRS = {
    "random_descriptor_qd": "00_random_descriptor",
    "simple_yosys_stat_bd": "01_yosys_stat_bd",
    "netlist_motif_occupancy": "02_netlist_motif_occupancy",
    "synthesis_trajectory_nod": "03_synthesis_trajectory_nod",
    "sr_raw_pca_qd": "04_synthesis_response_kernel_pca",
    "sr_random_relu_pca_qd": "04_synthesis_response_kernel_pca",
    "sr_rff_pca_qd": "04_synthesis_response_kernel_pca",
}


def build_reports(
    *,
    central_report_json: Path,
    method_root: Path,
    output_name: str,
) -> dict[str, Path]:
    """Write one generated method report per configured Auto-BD method."""

    assert central_report_json.is_file(), central_report_json
    assert method_root.is_dir(), method_root
    report = load_json(central_report_json)
    outputs = {}
    for method, directory in METHOD_DIRS.items():
        method_dir = method_root / directory
        assert method_dir.is_dir(), method_dir
        output_path = method_dir / method_output_name(method, output_name)
        output_path.write_text(render_method_report(report, method), encoding="utf-8")
        outputs[method] = output_path
    return outputs


def method_output_name(method: str, output_name: str) -> str:
    """Return a non-clobbering filename for variants sharing one directory."""

    if method == "sr_random_relu_pca_qd":
        return f"sr_random_relu_{output_name}"
    if method == "sr_rff_pca_qd":
        return f"sr_rff_{output_name}"
    return output_name


def render_method_report(report: dict[str, Any], method: str) -> str:
    gate = one(report["gate_matrix"], method)
    leader = one(report["leaderboard"], method)
    robust = one(report["robustness_funnel"], method)
    qd = one(report["qd_summary"], method)
    elites = rows_for(report["representative_elites"], method)
    method_best = [
        row
        for row in elites
        if row["selection_kind"] == "method_best_fitness"
    ]
    assert len(method_best) == 1, method
    problem_best = [
        row
        for row in elites
        if row["selection_kind"] == "problem_best_fitness"
    ]
    artifact_root = report["artifact_roots"][method]
    return "\n".join(
        [
            f"# {method} Seed-1 Artifact Report",
            "",
            "Status: generated from standardized Auto-BD artifacts.",
            "",
            "## Source",
            "",
            f"- Phase: `{report['phase']}`",
            f"- Seed: `{report['seed']}`",
            f"- Reference method: `{report['reference_method']}`",
            f"- Standard result root: `{artifact_root}`",
            "",
            "## Gate 0",
            "",
            markdown_table(
                ["Metric", "Value"],
                [
                    ["Gate 0", gate["gate0"]],
                    ["Covered problems", gate["covered_problems"]],
                    ["Classic covered problems", gate["classic_covered_problems"]],
                    ["Missing classic problems", ", ".join(gate["missing_classic_problems"]) or "-"],
                ],
            ),
            "",
            "## PPA And Diversity Summary",
            "",
            markdown_table(
                ["Metric", "Value"],
                [
                    ["Valid PPA candidates", leader["valid_ppa_candidate_count"]],
                    ["Mean best fitness", fmt(leader["mean_best_fitness"])],
                    ["Fitness W/T/L", f"{leader['fitness_wins']}/{leader['fitness_ties']}/{leader['fitness_losses']}"],
                    ["Mean hypervolume", fmt(leader["mean_hypervolume"])],
                    ["Hypervolume W/T/L", f"{leader['hv_wins']}/{leader['hv_ties']}/{leader['hv_losses']}"],
                    ["Unique canonical netlists", leader["unique_canonical_netlist_count"]],
                    ["Unique motif signatures", leader["unique_motif_signature_count"]],
                    ["PPA-front unique netlists", leader["ppa_front_unique_netlist_count"]],
                ],
            ),
            "",
            "## Robustness Funnel",
            "",
            markdown_table(
                ["Stage", "Count", "Rate"],
                [
                    ["Syntax", robust["syntax_pass"], fmt_rate(robust["syntax_rate"])],
                    ["Functionality", robust["functionality_pass"], fmt_rate(robust["functionality_rate"])],
                    ["Synthesis", robust["synthesis_pass"], fmt_rate(robust["synthesis_rate"])],
                    ["OpenROAD", robust["openroad_pass"], fmt_rate(robust["openroad_rate"])],
                    ["Valid PPA", robust["valid_ppa"], fmt_rate(robust["valid_ppa_rate"])],
                ],
            ),
            "",
            "## QD Archive",
            "",
            markdown_table(
                ["Metric", "Value"],
                [
                    ["Archive type", qd["archive_type"]],
                    ["Internal occupied cells", qd["internal_occupied_cells"] or "-"],
                    ["Internal QD score", fmt(qd["internal_qd_score"])],
                    ["Common-audit occupied cells", qd["common_audit_occupied_cells"]],
                    ["Common-audit coverage", fmt(qd["common_audit_coverage"])],
                    ["Common-audit QD score", fmt(qd["common_audit_qd_score"])],
                    ["Common-audit entropy", fmt(qd["common_audit_entropy_bits"])],
                ],
            ),
            "",
            "## Representative Elites",
            "",
            markdown_table(
                [
                    "Selection",
                    "Problem",
                    "Fitness",
                    "Area",
                    "Power",
                    "Timing",
                    "RTL",
                    "Netlist",
                ],
                [
                    elite_row("method_best", method_best[0]),
                    *[
                        elite_row("problem_best", row)
                        for row in problem_best
                    ],
                ],
            ),
            "",
            "## Notes",
            "",
            "- This report is generated; keep interpretation and final decisions in `accept_reject.md`.",
            "- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.",
            "",
        ]
    )


def elite_row(selection: str, row: dict[str, Any]) -> list[object]:
    return [
        selection,
        code(row["problem_id"]),
        fmt(row["fitness"]),
        fmt(row["area"]),
        fmt(row["power"]),
        fmt(row["timing_or_clock_period"]),
        short_path(row["rtl_path"]),
        short_path(row["netlist_path"]),
    ]


def one(rows: list[dict[str, Any]], method: str) -> dict[str, Any]:
    matches = rows_for(rows, method)
    assert len(matches) == 1, method
    return matches[0]


def rows_for(rows: list[dict[str, Any]], method: str) -> list[dict[str, Any]]:
    return [
        row
        for row in rows
        if row["method_name"] == method
    ]


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(lines)


def fmt(value: object) -> str:
    if value is None:
        return "-"
    assert isinstance(value, int | float | str)
    return f"{float(value):.4f}"


def fmt_rate(value: object) -> str:
    assert isinstance(value, int | float | str)
    return f"{float(value):.1%}"


def code(value: object) -> str:
    return f"`{value}`"


def short_path(value: object) -> str:
    path = Path(str(value))
    parts = path.parts
    if len(parts) <= 5:
        return code(path.as_posix())
    return code(Path("...", *parts[-5:]).as_posix())


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--central-report-json", type=Path, required=True)
    parser.add_argument("--method-root", type=Path, required=True)
    parser.add_argument("--output-name", default="seed1_artifact_report.md")
    args = parser.parse_args(argv)

    outputs = build_reports(
        central_report_json=args.central_report_json,
        method_root=args.method_root,
        output_name=args.output_name,
    )
    for method, path in outputs.items():
        print(f"{method} -> {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
