#!/usr/bin/env python3
"""Summarize PCN-v3 C-F ablation experiment stages."""

from __future__ import annotations

import argparse
import csv
import math
import random
from pathlib import Path
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from scipy import stats

sys.path.insert(0, str(Path(__file__).resolve().parents[7] / "src"))

from revolution.qd.pareto_analysis import hypervolume, pareto_front  # noqa: E402


CORE_COMPARISONS = [
    (
        "classic_no_cf_minus_classic",
        "classic_revolution_8x5",
        "classic_no_cf_8x5",
    ),
    (
        "pcn_no_cf_minus_classic_no_cf",
        "classic_no_cf_8x5",
        "pcn_v3_no_cf_memory_8x5",
    ),
    (
        "pcn_cf_restored_minus_classic",
        "classic_revolution_8x5",
        "pcn_v3_cf_restored_memory_8x5",
    ),
    (
        "pcn_cf_restored_minus_pcn_no_cf",
        "pcn_v3_no_cf_memory_8x5",
        "pcn_v3_cf_restored_memory_8x5",
    ),
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows, path
    return rows


def write_csv(path: Path, fields: list[str], rows: list[dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: float) -> str:
    assert math.isfinite(value)
    return f"{value:.12g}"


def mean(values: list[float]) -> float:
    assert values
    return sum(values) / len(values)


def median(values: list[float]) -> float:
    assert values
    ordered = sorted(values)
    middle = len(ordered) // 2
    if len(ordered) % 2:
        return ordered[middle]
    return (ordered[middle - 1] + ordered[middle]) / 2.0


def bootstrap_ci(values: list[float]) -> tuple[float, float]:
    assert values
    rng = random.Random(20260701)
    draws = []
    for _ in range(4000):
        sample = [values[rng.randrange(len(values))] for _ in values]
        draws.append(mean(sample))
    draws.sort()
    return draws[int(0.025 * len(draws))], draws[int(0.975 * len(draws))]


def wilcoxon_p(values: list[float]) -> str:
    nonzero = [value for value in values if abs(value) > 1e-12]
    if len(nonzero) < 6:
        return "not_available"
    return fmt(float(stats.wilcoxon(nonzero).pvalue))


def sign_p(wins: int, losses: int) -> str:
    trials = wins + losses
    if trials == 0:
        return "not_available"
    if hasattr(stats, "binomtest"):
        return fmt(float(stats.binomtest(wins, trials, 0.5).pvalue))
    return fmt(float(stats.binom_test(wins, trials, 0.5)))


def objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "sequential":
        return ("g_P", "g_A", "g_T")
    if circuit_type == "combinational":
        return ("g_P", "g_A")
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def hv_at_step(rows: list[dict[str, str]], step: int) -> float:
    visible = [row for row in rows if int(row["generation"]) <= step]
    if not visible:
        return 0.0
    keys = objective_keys(visible[0]["circuit_type"])
    points = [tuple(float(row[key]) for key in keys) for row in visible]
    front = [points[index] for index in pareto_front(points)]
    return hypervolume(front)


def auc(values: list[float]) -> float:
    if len(values) == 1:
        return values[0]
    total = 0.0
    for left, right in zip(values[:-1], values[1:], strict=True):
        total += (left + right) / 2.0
    return total / (len(values) - 1)


def load_hv_auc(analysis: Path) -> dict[tuple[str, str, str], float]:
    rows = read_csv(
        analysis / "reference_complete_ppa_distribution" / "data" / "ppa_candidates.csv"
    )
    by_key: dict[tuple[str, str, str], list[dict[str, str]]] = {}
    for row in rows:
        key = (row["backend"], row["benchmark"], row["problem"])
        by_key.setdefault(key, []).append(row)
    output = {}
    for key, candidates in by_key.items():
        max_generation = max(int(row["generation"]) for row in candidates)
        output[key] = auc([hv_at_step(candidates, step) for step in range(max_generation + 1)])
    return output


def method_label(method: str) -> str:
    labels = {
        "classic_revolution_8x5": "classic",
        "classic_no_cf_8x5": "classic no C-F",
        "pcn_v3_no_cf_memory_8x5": "PCN no C-F",
        "pcn_v3_cf_restored_memory_8x5": "PCN C-F restored",
        "pcn_v3_cf_restored_elite3_8x5": "PCN elite3",
        "pcn_v3_cf_restored_pareto3_8x5": "PCN pareto3",
    }
    return labels.get(method, method)


def stage_methods(manifest: list[dict[str, str]], stage: str) -> list[str]:
    if stage == "rtllm_elite":
        allowed = {"core", "elite"}
    elif stage == "verilogeval_holdout":
        allowed = {"core"}
    else:
        allowed = {"core"}
    methods = [row["method_key"] for row in manifest if row["benchmark_stage"] in allowed]
    if stage == "verilogeval_holdout":
        methods = [
            method
            for method in methods
            if method
            in {
                "classic_revolution_8x5",
                "classic_no_cf_8x5",
                "pcn_v3_cf_restored_memory_8x5",
            }
        ]
    return methods


def stage_seeds(doc_root: Path, stage: str) -> list[str]:
    analysis_root = doc_root / "analysis" / stage
    if not analysis_root.exists():
        return []
    seeds = [path.name.removeprefix("seed_") for path in analysis_root.glob("seed_*")]
    return sorted(seed for seed in seeds if seed.isdigit())


def collect_rows(doc_root: Path, stage: str, methods: list[str]) -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    method_seed_rows: list[dict[str, object]] = []
    problem_rows: list[dict[str, object]] = []
    for seed in stage_seeds(doc_root, stage):
        analysis = doc_root / "analysis" / stage / f"seed_{seed}"
        pareto_path = analysis / "reference_complete_pareto_analysis" / "backend_problem_metrics.csv"
        operator_path = analysis / "operator_contract.csv"
        if not pareto_path.exists() or not operator_path.exists():
            continue
        hv_auc = load_hv_auc(analysis)
        operator_counts = {
            row["method_key"]: row for row in read_csv(operator_path)
        }
        by_method: dict[str, list[dict[str, str]]] = {method: [] for method in methods}
        for row in read_csv(pareto_path):
            method = row["backend"]
            if method not in by_method:
                continue
            by_method[method].append(row)
            key = (method, row["benchmark"], row["problem"])
            problem_rows.append(
                {
                    "stage": stage,
                    "seed": seed,
                    "method_key": method,
                    "benchmark": row["benchmark"],
                    "problem": row["problem"],
                    "candidate_count": row["candidate_count"],
                    "pareto_point_count": row["pareto_point_count"],
                    "hypervolume": row["hypervolume"],
                    "hv_auc": fmt(hv_auc.get(key, 0.0)),
                    "reference_beating_count": row["reference_beating_count"],
                }
            )
        for method in methods:
            rows = by_method[method]
            op = operator_counts.get(method, {})
            hv_values = [float(row["hypervolume"]) for row in rows]
            auc_values = [
                hv_auc.get((method, row["benchmark"], row["problem"]), 0.0)
                for row in rows
            ]
            method_seed_rows.append(
                {
                    "stage": stage,
                    "seed": seed,
                    "method_key": method,
                    "problem_count": len(rows),
                    "covered_problem_count": sum(int(row["candidate_count"]) > 0 for row in rows),
                    "mean_hv": fmt(mean(hv_values)) if hv_values else "not_available",
                    "mean_hv_auc": fmt(mean(auc_values)) if auc_values else "not_available",
                    "mean_pareto_point_count": (
                        fmt(mean([float(row["pareto_point_count"]) for row in rows]))
                        if rows
                        else "not_available"
                    ),
                    "mean_reference_beating_count": (
                        fmt(mean([float(row["reference_beating_count"]) for row in rows]))
                        if rows
                        else "not_available"
                    ),
                    "candidate_count": op.get("candidate_count", "0"),
                    "single_thought_count": op.get("single_thought_count", "0"),
                    "c_f_count": op.get("c_f_count", "0"),
                    "operator_set": op.get("operator_set", "unknown"),
                    "operator_status": op.get("status", "not_available"),
                    "cf_policy_status": op.get("cf_policy_status", "not_available"),
                }
            )
    return method_seed_rows, problem_rows


def paired_deltas(problem_rows: list[dict[str, object]]) -> list[dict[str, object]]:
    by_key = {
        (
            str(row["seed"]),
            str(row["method_key"]),
            str(row["benchmark"]),
            str(row["problem"]),
        ): row
        for row in problem_rows
    }
    output = []
    seeds = sorted({str(row["seed"]) for row in problem_rows})
    problems = sorted({(str(row["benchmark"]), str(row["problem"])) for row in problem_rows})
    for name, baseline, method in CORE_COMPARISONS:
        for seed in seeds:
            for benchmark, problem in problems:
                left = by_key.get((seed, baseline, benchmark, problem))
                right = by_key.get((seed, method, benchmark, problem))
                if left is None or right is None:
                    continue
                hv_left = float(left["hypervolume"])
                hv_right = float(right["hypervolume"])
                auc_left = float(left["hv_auc"])
                auc_right = float(right["hv_auc"])
                output.append(
                    {
                        "comparison": name,
                        "baseline_method": baseline,
                        "candidate_method": method,
                        "seed": seed,
                        "benchmark": benchmark,
                        "problem": problem,
                        "baseline_hv": fmt(hv_left),
                        "candidate_hv": fmt(hv_right),
                        "delta_hv": fmt(hv_right - hv_left),
                        "baseline_hv_auc": fmt(auc_left),
                        "candidate_hv_auc": fmt(auc_right),
                        "delta_hv_auc": fmt(auc_right - auc_left),
                    }
                )
    return output


def comparison_summary(deltas: list[dict[str, object]]) -> list[dict[str, object]]:
    rows = []
    for comparison in sorted({str(row["comparison"]) for row in deltas}):
        subset = [row for row in deltas if row["comparison"] == comparison]
        values = [float(row["delta_hv"]) for row in subset]
        auc_values = [float(row["delta_hv_auc"]) for row in subset]
        wins = sum(value > 1e-12 for value in values)
        losses = sum(value < -1e-12 for value in values)
        ties = len(values) - wins - losses
        ci_low, ci_high = bootstrap_ci(values)
        auc_ci_low, auc_ci_high = bootstrap_ci(auc_values)
        rows.append(
            {
                "comparison": comparison,
                "paired_count": len(values),
                "mean_delta_hv": fmt(mean(values)),
                "median_delta_hv": fmt(median(values)),
                "bootstrap_ci95_low": fmt(ci_low),
                "bootstrap_ci95_high": fmt(ci_high),
                "mean_delta_hv_auc": fmt(mean(auc_values)),
                "median_delta_hv_auc": fmt(median(auc_values)),
                "hv_auc_ci95_low": fmt(auc_ci_low),
                "hv_auc_ci95_high": fmt(auc_ci_high),
                "win_count": wins,
                "loss_count": losses,
                "tie_count": ties,
                "sign_test_p": sign_p(wins, losses),
                "wilcoxon_p": wilcoxon_p(values),
            }
        )
    return rows


def bar(path: Path, rows: list[dict[str, object]], value_field: str, title: str, ylabel: str) -> None:
    fig, ax = plt.subplots(figsize=(11, 5))
    labels = [method_label(str(row["method_key"])) for row in rows]
    values = [float(row[value_field]) for row in rows]
    ax.bar(labels, values, color="#4c78a8", edgecolor="#222222", linewidth=0.7)
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.tick_params(axis="x", labelrotation=25)
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def delta_boxplot(path: Path, deltas: list[dict[str, object]], field: str, title: str) -> None:
    comparisons = sorted({str(row["comparison"]) for row in deltas})
    values = [
        [float(row[field]) for row in deltas if row["comparison"] == comparison]
        for comparison in comparisons
    ]
    fig, ax = plt.subplots(figsize=(12, 5))
    ax.boxplot(values, tick_labels=comparisons, showfliers=False)
    ax.axhline(0.0, color="#222222", linewidth=0.9)
    ax.set_title(title)
    ax.set_ylabel(field)
    ax.tick_params(axis="x", labelrotation=20)
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def scatter(path: Path, deltas: list[dict[str, object]], comparison: str) -> None:
    rows = [row for row in deltas if row["comparison"] == comparison]
    if not rows:
        return
    xs = [float(row["baseline_hv"]) for row in rows]
    ys = [float(row["candidate_hv"]) for row in rows]
    bound = max(xs + ys + [0.01])
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.scatter(xs, ys, s=28, color="#4c78a8", alpha=0.75)
    ax.plot([0, bound], [0, bound], color="#222222", linewidth=0.9)
    ax.set_title(comparison)
    ax.set_xlabel("baseline HV")
    ax.set_ylabel("candidate HV")
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def write_report(path: Path, stage: str, summary_rows: list[dict[str, object]]) -> None:
    lines = [
        f"# PCN-v3 {stage} Report",
        "",
        "## Comparison Summary",
        "",
        "| Comparison | n | Mean HV Delta | CI95 | Wins/Losses/Ties | Wilcoxon p |",
        "| --- | ---: | ---: | --- | --- | ---: |",
    ]
    for row in summary_rows:
        lines.append(
            "| {comparison} | {paired_count} | {mean_delta_hv} | [{lo}, {hi}] | "
            "{win}/{loss}/{tie} | {wilcoxon} |".format(
                comparison=row["comparison"],
                paired_count=row["paired_count"],
                mean_delta_hv=f"{float(row['mean_delta_hv']):.4f}",
                lo=f"{float(row['bootstrap_ci95_low']):.4f}",
                hi=f"{float(row['bootstrap_ci95_high']):.4f}",
                win=row["win_count"],
                loss=row["loss_count"],
                tie=row["tie_count"],
                wilcoxon=row["wilcoxon_p"],
            )
        )
    lines.extend(
        [
            "",
            "## Interpretation Rule",
            "",
            "Credit PCN memory only if the PCN arm improves over the matching "
            "operator-control baseline. A win over original classic alone is not "
            "sufficient when no-C-F classic also improves.",
            "",
            "## Generated Figures",
            "",
            "- `figures/<stage>/mean_hv_by_method_seed.png`",
            "- `figures/<stage>/cf_count_by_method_seed.png`",
            "- `figures/<stage>/delta_hv_boxplot.png`",
            "- `figures/<stage>/delta_hv_auc_boxplot.png`",
            "- `figures/<stage>/pcn_cf_restored_vs_classic_scatter.png`",
        ]
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--doc-root", type=Path, required=True)
    parser.add_argument("--stage", required=True)
    args = parser.parse_args()

    doc_root = args.doc_root.resolve()
    manifest = read_csv(doc_root / "tables" / "method_manifest.csv")
    methods = stage_methods(manifest, args.stage)
    method_seed_rows, problem_rows = collect_rows(doc_root, args.stage, methods)
    assert method_seed_rows, "no method-seed rows to summarize"
    assert problem_rows, "no problem rows to summarize"

    table_root = doc_root / "tables"
    fig_root = doc_root / "figures" / args.stage
    report_root = doc_root / "reports"
    fig_root.mkdir(parents=True, exist_ok=True)

    method_seed_fields = list(method_seed_rows[0].keys())
    problem_fields = list(problem_rows[0].keys())
    deltas = paired_deltas(problem_rows)
    delta_fields = list(deltas[0].keys())
    summary_rows = comparison_summary(deltas)
    summary_fields = list(summary_rows[0].keys())

    write_csv(table_root / f"{args.stage}_method_seed_summary.csv", method_seed_fields, method_seed_rows)
    write_csv(table_root / f"{args.stage}_problem_metrics.csv", problem_fields, problem_rows)
    write_csv(table_root / f"{args.stage}_paired_deltas.csv", delta_fields, deltas)
    write_csv(table_root / f"{args.stage}_comparison_summary.csv", summary_fields, summary_rows)

    bar(fig_root / "mean_hv_by_method_seed.png", method_seed_rows, "mean_hv", "Mean HV by method and seed", "Mean HV")
    bar(fig_root / "cf_count_by_method_seed.png", method_seed_rows, "c_f_count", "C-F count by method and seed", "C-F count")
    delta_boxplot(fig_root / "delta_hv_boxplot.png", deltas, "delta_hv", "Paired HV deltas")
    delta_boxplot(fig_root / "delta_hv_auc_boxplot.png", deltas, "delta_hv_auc", "Paired HV-AUC deltas")
    scatter(
        fig_root / "pcn_cf_restored_vs_classic_scatter.png",
        deltas,
        "pcn_cf_restored_minus_classic",
    )
    write_report(report_root / f"{args.stage}_report.md", args.stage, summary_rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
