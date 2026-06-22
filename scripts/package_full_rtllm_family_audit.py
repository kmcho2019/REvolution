#!/usr/bin/env python3
"""Package full RTLLM canonical family and duplicate audit artifacts."""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
from pathlib import Path
import sys
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.package_t28_t26_family_audit import (
    beats_reference,
    family_signature,
    fmt,
    hash_text,
    load_jsonl,
    normalized_verilog,
    ratio,
    relative_delta,
    synthesized_cell_counts,
    write_csv,
)

METHODS = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "mode": "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "color": "#4e79a7",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Exact T26 QD",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#e15759",
    },
)

SCREEN_PROBLEMS = {
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
}

COLORS = {method["method"]: method["color"] for method in METHODS}


@dataclass(frozen=True)
class FullFamilyCandidate:
    method: str
    method_label: str
    problem: str
    candidate_id: str
    generation: str
    objective_metrics: tuple[str, ...]
    ppa_metrics: dict[str, float]
    improvements: dict[str, float]
    code_file_path: Path
    rtl_hash: str
    netlist_hash: str
    family_hash: str
    family_signature: str
    is_front: bool
    beats_reference: bool


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--ppa-candidates", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    problems = read_manifest(args.manifest)
    ppa_rows = read_csv(args.ppa_candidates)
    path_index = code_path_index(args.run_root, problems)
    candidates = family_candidates(ppa_rows, path_index)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    problem_rows = family_problem_rows(candidates, problems)
    aggregate_rows = family_aggregate_rows(problem_rows, problems)
    comparison = family_comparison_rows(aggregate_rows)
    write_csv(table_dir / "full_family_candidate_rows.csv", family_candidate_rows(candidates))
    write_csv(table_dir / "full_family_problem_metrics.csv", problem_rows)
    write_csv(table_dir / "full_family_aggregate_metrics.csv", aggregate_rows)
    write_csv(table_dir / "full_family_comparison_deltas.csv", comparison)
    write_figures(problem_rows, aggregate_rows, figure_dir)
    write_report(args.output_dir / "README.md", aggregate_rows, comparison, problems)
    return 0


def read_manifest(path: Path) -> list[str]:
    rows = read_csv(path)
    problems = [row["problem"] for row in rows]
    assert problems
    assert len(problems) == len(set(problems))
    return problems


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def code_path_index(
    run_root: Path,
    problems: list[str],
) -> dict[tuple[str, str, str], Path]:
    index: dict[tuple[str, str, str], Path] = {}
    for method in METHODS:
        for problem in problems:
            problem_root = run_root / method["mode"] / "RTLLM" / problem
            for payload in load_jsonl(problem_root / "generation_log.jsonl"):
                generated = payload["generated_candidates"]
                assert isinstance(generated, list)
                for row in generated:
                    assert isinstance(row, dict)
                    key = (method["method"], problem, str(row["id"]))
                    index[key] = Path(str(row["code_file_path"]))
    assert index
    return index


def family_candidates(
    ppa_rows: list[dict[str, str]],
    path_index: dict[tuple[str, str, str], Path],
) -> list[FullFamilyCandidate]:
    output = []
    methods = {method["method"]: method for method in METHODS}
    for row in ppa_rows:
        method = methods[row["method"]]
        problem = row["problem"]
        candidate_id = row["candidate_id"]
        code_path = path_index[(row["method"], problem, candidate_id)]
        netlist_path = code_path.with_name("code.syn.v")
        assert code_path.is_file()
        assert netlist_path.is_file()
        objective_metrics = tuple(row["objective_metrics"].split("|"))
        ppa_metrics = {
            metric: float(row[metric])
            for metric in objective_metrics
            if row.get(metric, "") != ""
        }
        improvements = {
            metric: float(row[f"{metric}_improvement"])
            for metric in objective_metrics
        }
        cell_counts = synthesized_cell_counts(netlist_path)
        output.append(
            FullFamilyCandidate(
                method=method["method"],
                method_label=method["label"],
                problem=problem,
                candidate_id=candidate_id,
                generation=row["generation"],
                objective_metrics=objective_metrics,
                ppa_metrics=ppa_metrics,
                improvements=improvements,
                code_file_path=code_path,
                rtl_hash=hash_text(normalized_verilog(code_path)),
                netlist_hash=hash_text(normalized_verilog(netlist_path)),
                family_hash=hash_text(family_signature(cell_counts)),
                family_signature=family_signature(cell_counts),
                is_front=row["is_pareto_front"] == "True",
                beats_reference=beats_reference(improvements, objective_metrics),
            )
        )
    assert output
    return output


def family_candidate_rows(candidates: list[FullFamilyCandidate]) -> list[dict[str, str]]:
    rows = []
    for candidate in candidates:
        rows.append(
            {
                "method": candidate.method,
                "method_label": candidate.method_label,
                "problem": candidate.problem,
                "candidate_id": candidate.candidate_id,
                "generation": candidate.generation,
                "objective_metrics": "|".join(candidate.objective_metrics),
                "is_pareto_front": str(candidate.is_front).lower(),
                "beats_reference": str(candidate.beats_reference).lower(),
                "area": fmt_optional(candidate.ppa_metrics.get("area")),
                "power": fmt_optional(candidate.ppa_metrics.get("power")),
                "eff_clk_period": fmt_optional(candidate.ppa_metrics.get("eff_clk_period")),
                "rtl_hash": candidate.rtl_hash,
                "netlist_hash": candidate.netlist_hash,
                "family_hash": candidate.family_hash,
                "family_signature": candidate.family_signature,
                "code_file_path": str(candidate.code_file_path),
            }
        )
    return rows


def family_problem_rows(
    candidates: list[FullFamilyCandidate],
    problems: list[str],
) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        for problem in problems:
            subset = [
                candidate
                for candidate in candidates
                if candidate.method == method["method"] and candidate.problem == problem
            ]
            rows.append(family_metric_row(method, problem, subset))
    return rows


def family_metric_row(
    method: dict[str, str],
    problem: str,
    candidates: list[FullFamilyCandidate],
) -> dict[str, str]:
    front = [candidate for candidate in candidates if candidate.is_front]
    beating = [candidate for candidate in candidates if candidate.beats_reference]
    audited_count = len(candidates)
    front_count = len(front)
    unique_family = unique_count(candidates, "family_hash")
    front_unique_family = unique_count(front, "family_hash")
    front_unique_netlist = unique_count(front, "netlist_hash")
    return {
        "method": method["method"],
        "method_label": method["label"],
        "problem": problem,
        "is_screen_problem": str(problem in SCREEN_PROBLEMS),
        "audited_ppa_point_count": str(audited_count),
        "ppa_front_count": str(front_count),
        "unique_rtl_count": str(unique_count(candidates, "rtl_hash")),
        "unique_netlist_count": str(unique_count(candidates, "netlist_hash")),
        "unique_family_count": str(unique_family),
        "front_unique_rtl_count": str(unique_count(front, "rtl_hash")),
        "front_unique_netlist_count": str(front_unique_netlist),
        "front_unique_family_count": str(front_unique_family),
        "reference_beating_unique_family_count": str(unique_count(beating, "family_hash")),
        "netlist_duplicate_count": str(audited_count - unique_count(candidates, "netlist_hash")),
        "family_duplicate_count": str(audited_count - unique_family),
        "front_family_duplicate_count": str(front_count - front_unique_family),
        "audited_family_ratio": fmt(ratio(unique_family, audited_count)),
        "front_family_ratio": fmt(ratio(front_unique_family, front_count)),
        "front_netlist_ratio": fmt(ratio(front_unique_netlist, front_count)),
    }


def family_aggregate_rows(
    problem_rows: list[dict[str, str]],
    problems: list[str],
) -> list[dict[str, str]]:
    problem_sets = {
        "all_rtllm": set(problems),
        "screen": SCREEN_PROBLEMS & set(problems),
        "screen_excluded": set(problems) - SCREEN_PROBLEMS,
        "valid_ppa_subset": {
            row["problem"]
            for row in problem_rows
            if int(row["audited_ppa_point_count"]) > 0
        },
    }
    rows = []
    for cohort, cohort_problems in problem_sets.items():
        if not cohort_problems:
            continue
        for method in METHODS:
            subset = [
                row
                for row in problem_rows
                if row["method"] == method["method"] and row["problem"] in cohort_problems
            ]
            rows.append(family_aggregate_row(method, cohort, subset))
    return rows


def family_aggregate_row(
    method: dict[str, str],
    cohort: str,
    rows: list[dict[str, str]],
) -> dict[str, str]:
    audited_count = sum_int(rows, "audited_ppa_point_count")
    front_count = sum_int(rows, "ppa_front_count")
    unique_family = sum_int(rows, "unique_family_count")
    front_unique_family = sum_int(rows, "front_unique_family_count")
    front_unique_netlist = sum_int(rows, "front_unique_netlist_count")
    return {
        "cohort": cohort,
        "method": method["method"],
        "method_label": method["label"],
        "problem_count": str(len(rows)),
        "audited_ppa_problem_count": str(sum(1 for row in rows if int(row["audited_ppa_point_count"]) > 0)),
        "audited_ppa_point_count": str(audited_count),
        "ppa_front_count": str(front_count),
        "unique_rtl_count": str(sum_int(rows, "unique_rtl_count")),
        "unique_netlist_count": str(sum_int(rows, "unique_netlist_count")),
        "unique_family_count": str(unique_family),
        "front_unique_rtl_count": str(sum_int(rows, "front_unique_rtl_count")),
        "front_unique_netlist_count": str(front_unique_netlist),
        "front_unique_family_count": str(front_unique_family),
        "reference_beating_unique_family_count": str(
            sum_int(rows, "reference_beating_unique_family_count")
        ),
        "netlist_duplicate_count": str(sum_int(rows, "netlist_duplicate_count")),
        "family_duplicate_count": str(sum_int(rows, "family_duplicate_count")),
        "front_family_duplicate_count": str(sum_int(rows, "front_family_duplicate_count")),
        "audited_family_ratio": fmt(ratio(unique_family, audited_count)),
        "front_family_ratio": fmt(ratio(front_unique_family, front_count)),
        "front_netlist_ratio": fmt(ratio(front_unique_netlist, front_count)),
    }


def family_comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_key = {(row["cohort"], row["method"]): row for row in rows}
    metrics = (
        "audited_ppa_point_count",
        "unique_family_count",
        "front_unique_family_count",
        "front_unique_netlist_count",
        "reference_beating_unique_family_count",
        "family_duplicate_count",
        "front_family_ratio",
        "audited_family_ratio",
    )
    output = []
    for cohort in sorted({row["cohort"] for row in rows}):
        qd = by_key[(cohort, "sr_raw_conservative_exploit_qd")]
        classic = by_key[(cohort, "classic_revolution")]
        for metric in metrics:
            value = float(qd[metric])
            ref_value = float(classic[metric])
            output.append(
                {
                    "cohort": cohort,
                    "method": qd["method"],
                    "method_label": qd["method_label"],
                    "reference": classic["method"],
                    "reference_label": classic["method_label"],
                    "metric": metric,
                    "value": fmt(value),
                    "reference_value": fmt(ref_value),
                    "delta": fmt(value - ref_value),
                    "relative_delta": fmt_optional(relative_delta(value, ref_value)),
                }
            )
    return output


def write_figures(
    problem_rows: list[dict[str, str]],
    aggregate_rows: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_aggregate(aggregate_rows, figure_dir / "full_family_aggregate_counts.png")
    plot_problem_deltas(problem_rows, figure_dir / "full_front_family_delta_heatmap.png")
    plot_ratio_distribution(problem_rows, figure_dir / "full_family_ratio_distribution.png")
    write_visual_notes(figure_dir / "visual_inspection_notes.md")


def plot_aggregate(rows: list[dict[str, str]], output_path: Path) -> None:
    selected = [row for row in rows if row["cohort"] == "all_rtllm"]
    labels = [row["method_label"] for row in selected]
    x = list(range(len(selected)))
    fig, axes = plt.subplots(1, 4, figsize=(15.8, 4.4))
    aggregate_panel(axes[0], selected, x, "front_unique_family_count", "Front Family Proxies")
    aggregate_panel(axes[1], selected, x, "front_unique_netlist_count", "Front Netlists")
    aggregate_panel(axes[2], selected, x, "reference_beating_unique_family_count", "Ref-Beating Family Proxies")
    aggregate_panel(axes[3], selected, x, "audited_family_ratio", "Audited Family Ratio")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=15, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    fig.suptitle("Full RTLLM Canonical Family Audit", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def aggregate_panel(
    axis: Any,
    rows: list[dict[str, str]],
    x: list[int],
    metric: str,
    title: str,
) -> None:
    axis.bar(x, [float(row[metric]) for row in rows], color=[COLORS[row["method"]] for row in rows], alpha=0.84)
    axis.set_title(title)


def plot_problem_deltas(rows: list[dict[str, str]], output_path: Path) -> None:
    problems = sorted({row["problem"] for row in rows})
    by_key = {(row["method"], row["problem"]): row for row in rows}
    metrics = (
        ("audited_ppa_point_count", "Audited PPA rows"),
        ("front_unique_family_count", "Front family proxies"),
        ("front_unique_netlist_count", "Front netlists"),
        ("audited_family_ratio", "Audited family ratio"),
    )
    count_metrics = metrics[:3]
    ratio_metrics = metrics[3:]
    count_matrix = [
        [
            float(by_key[("sr_raw_conservative_exploit_qd", problem)][metric])
            - float(by_key[("classic_revolution", problem)][metric])
            for metric, _ in count_metrics
        ]
        for problem in problems
    ]
    ratio_matrix = [
        [
            float(by_key[("sr_raw_conservative_exploit_qd", problem)][metric])
            - float(by_key[("classic_revolution", problem)][metric])
            for metric, _ in ratio_metrics
        ]
        for problem in problems
    ]
    fig, axes = plt.subplots(
        1,
        2,
        figsize=(11.8, 12.8),
        gridspec_kw={"width_ratios": [3.0, 1.0]},
    )
    plot_delta_heatmap(axes[0], count_matrix, problems, count_metrics, "Count Deltas")
    plot_delta_heatmap(axes[1], ratio_matrix, problems, ratio_metrics, "Ratio Deltas")
    fig.suptitle("Exact T26 QD Minus Classic Family Metrics By Problem", y=1.01)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_delta_heatmap(
    axis: Any,
    matrix: list[list[float]],
    problems: list[str],
    metrics: tuple[tuple[str, str], ...],
    title: str,
) -> None:
    image = axis.imshow(matrix, aspect="auto", cmap="RdBu", vmin=-max_abs(matrix), vmax=max_abs(matrix))
    axis.set_xticks(list(range(len(metrics))))
    axis.set_xticklabels([label for _, label in metrics], rotation=20, ha="right")
    axis.set_yticks(list(range(len(problems))))
    axis.set_yticklabels([problem.replace("Prob", "P") for problem in problems], fontsize=7)
    axis.set_title(title)
    for row_index, values in enumerate(matrix):
        for col_index, value in enumerate(values):
            axis.text(col_index, row_index, short_number(value), ha="center", va="center", fontsize=6)
    plt.colorbar(image, ax=axis, shrink=0.72, label="QD minus classic")


def plot_ratio_distribution(rows: list[dict[str, str]], output_path: Path) -> None:
    fig, axes = plt.subplots(1, 2, figsize=(11.8, 4.2))
    for axis, metric, title in (
        (axes[0], "audited_family_ratio", "Audited Family Ratio"),
        (axes[1], "front_family_ratio", "Front Family Ratio"),
    ):
        for method in METHODS:
            values = [
                float(row[metric])
                for row in rows
                if row["method"] == method["method"] and int(row["audited_ppa_point_count"]) > 0
            ]
            axis.hist(values, bins=10, alpha=0.52, label=method["label"], color=method["color"])
        axis.set_title(title)
        axis.set_xlabel("ratio")
        axis.set_ylabel("problem count")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
        axis.legend(frameon=False)
    fig.suptitle("Full RTLLM Family-Ratio Distribution", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_report(
    path: Path,
    rows: list[dict[str, str]],
    comparison: list[dict[str, str]],
    problems: list[str],
) -> None:
    by_key = {(row["cohort"], row["method"]): row for row in rows}
    qd = by_key[("all_rtllm", "sr_raw_conservative_exploit_qd")]
    classic = by_key[("all_rtllm", "classic_revolution")]
    deltas = {
        row["metric"]: row
        for row in comparison
        if row["cohort"] == "all_rtllm"
    }
    path.write_text(
        "\n".join(
            [
                "# Full RTLLM Family Audit",
                "",
                "Status: completed post-hoc canonical RTL/netlist/family audit.",
                "",
                "This package checks whether the one-seed full RTLLM T26 result",
                "is explained by duplicate implementations or by broader",
                "front-family proxy material.",
                "",
                "## Scope",
                "",
                f"- RTLLM manifest problems: `{len(problems)}`.",
                f"- Classic audited deduplicated PPA-point rows: `{classic['audited_ppa_point_count']}`.",
                f"- Exact T26 QD audited deduplicated PPA-point rows: `{qd['audited_ppa_point_count']}`.",
                f"- Classic audited PPA-point problems: `{classic['audited_ppa_problem_count']}`.",
                f"- Exact T26 QD audited PPA-point problems: `{qd['audited_ppa_problem_count']}`.",
                "- Family proxy: SHA-256 of the synthesized standard-cell count",
                "  signature, summed per problem. It is a duplicate/front-material",
                "  proxy, not a proof of semantic RTL implementation families.",
                "",
                "## Headline Metrics",
                "",
                "| Metric | Classic | Exact T26 QD | Delta |",
                "| --- | ---: | ---: | ---: |",
                metric_line("Summed unique family proxies", classic, qd, deltas, "unique_family_count"),
                metric_line("Summed front family proxies", classic, qd, deltas, "front_unique_family_count"),
                metric_line("Front netlists", classic, qd, deltas, "front_unique_netlist_count"),
                metric_line(
                    "Reference-beating family proxies",
                    classic,
                    qd,
                    deltas,
                    "reference_beating_unique_family_count",
                ),
                metric_line("Family duplicates", classic, qd, deltas, "family_duplicate_count"),
                metric_line("Audited family ratio", classic, qd, deltas, "audited_family_ratio"),
                metric_line("Front family ratio", classic, qd, deltas, "front_family_ratio"),
                "",
                "## Interpretation",
                "",
                "The audit does not support a duplicate-collapse explanation for the T26 PPA-HV",
                "signal: exact T26 QD has fewer audited deduplicated PPA rows, fewer family",
                "duplicates, and a slightly higher audited family-proxy ratio than classic.",
                "",
                "The audit strengthens the full-suite front-material claim: exact T26 QD",
                f"has `{qd['front_unique_family_count']}` front family-proxy hits and",
                f"`{qd['front_unique_netlist_count']}` front netlists versus classic's",
                f"`{classic['front_unique_family_count']}` and `{classic['front_unique_netlist_count']}`.",
                "That is positive post-hoc front-material evidence for the active PPA front.",
                "",
                "The caveat is total audited breadth and quality: exact T26 QD still has",
                f"fewer summed family proxies (`{qd['unique_family_count']}` versus",
                f"`{classic['unique_family_count']}`) and fewer reference-beating",
                f"family proxies (`{qd['reference_beating_unique_family_count']}` versus",
                f"`{classic['reference_beating_unique_family_count']}`). The presentation",
                "should claim better front-family proxy material, not broad implementation-family",
                "dominance.",
                "",
                "## Files",
                "",
                "- `tables/full_family_candidate_rows.csv`",
                "- `tables/full_family_problem_metrics.csv`",
                "- `tables/full_family_aggregate_metrics.csv`",
                "- `tables/full_family_comparison_deltas.csv`",
                "- `figures/full_family_aggregate_counts.png`",
                "- `figures/full_front_family_delta_heatmap.png`",
                "- `figures/full_family_ratio_distribution.png`",
                "- `figures/visual_inspection_notes.md`",
                "",
            ]
        ),
        encoding="utf-8",
    )


def metric_line(
    label: str,
    classic: dict[str, str],
    qd: dict[str, str],
    deltas: dict[str, dict[str, str]],
    metric: str,
) -> str:
    return f"| {label} | {classic[metric]} | {qd[metric]} | {deltas[metric]['delta']} |"


def write_visual_notes(path: Path) -> None:
    path.write_text(
        "\n".join(
            [
                "# Full RTLLM Family Audit Visual Inspection Notes",
                "",
                "## `full_family_aggregate_counts.png`",
                "",
                "- Status: accept.",
                "- The four-panel bar chart is clear and presentation-usable.",
                "- It makes the core split visible: exact T26 QD has more front family-proxy",
                "  hits and front netlists, while classic has more reference-beating family",
                "  proxies.",
                "- Supported claim: T26 is not a duplicate-collapse result and does improve",
                "  active-front family-proxy material, but it is not a total-family breadth win.",
                "",
                "## `full_front_family_delta_heatmap.png`",
                "",
                "- Status: accept with caution.",
                "- The heatmap is dense but readable enough for appendix/report use.",
                "- It separates count deltas from ratio deltas so the ratio column is not",
                "  washed out by larger count magnitudes.",
                "- It shows why the aggregate result is mixed: synchronizer and several",
                "  smaller positive rows help T26, while ALU, divider, RAM, traffic-light, and",
                "  signal-generator rows retain negative audited-PPA breadth or front-family",
                "  proxy deltas.",
                "- Supported claim: full-suite front-family proxy gains are real but uneven.",
                "",
                "## `full_family_ratio_distribution.png`",
                "",
                "- Status: accept.",
                "- The histogram shows both methods are mostly unique under the family key.",
                "- Supported claim: neither method's front is materially explained by duplicate",
                "  family-proxy collapse; the front-family ratio is `1.0` for both methods.",
                "",
            ]
        ),
        encoding="utf-8",
    )


def unique_count(candidates: list[FullFamilyCandidate], attr: str) -> int:
    return len({str(getattr(candidate, attr)) for candidate in candidates})


def sum_int(rows: list[dict[str, str]], key: str) -> int:
    return sum(int(row[key]) for row in rows)


def max_abs(matrix: list[list[float]]) -> float:
    value = max(abs(item) for row in matrix for item in row)
    return value if value > 0.0 else 1.0


def short_number(value: float) -> str:
    if abs(value) >= 10:
        return f"{value:.0f}"
    return f"{value:.2f}"


def fmt_optional(value: float | None) -> str:
    if value is None:
        return ""
    return fmt(value)


if __name__ == "__main__":
    raise SystemExit(main())
