#!/usr/bin/env python3
"""Package the T83 RF leaf-ID seed-robustness gate."""

from __future__ import annotations

import csv
import json
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


PACKAGE = Path(__file__).resolve().parents[1]
ANALYSIS = PACKAGE / "analysis" / "pareto_analysis"
SEEDS = ("1001", "1002", "1003")
PROB135 = "Prob135_m2014_q6b"
TableRow = dict[str, str | float | int]


def main() -> None:
    tables = PACKAGE / "tables"
    figures = PACKAGE / "figures"
    tables.mkdir(exist_ok=True)
    figures.mkdir(exist_ok=True)

    aggregate = read_csv(ANALYSIS / "aggregate_backend_metrics.csv")
    problems = read_csv(ANALYSIS / "backend_problem_metrics.csv")
    seed_rows = seed_metrics(aggregate)
    deltas = problem_deltas(problems)
    robustness = robustness_rows(deltas)
    descriptor_rows = descriptor_health_rows()
    summary = rollup_summary(seed_rows, robustness, deltas)

    write_csv(tables / "seed_pair_metrics.csv", seed_rows)
    write_csv(tables / "problem_seed_deltas.csv", deltas)
    write_csv(tables / "seed_pair_robustness.csv", robustness)
    write_csv(tables / "descriptor_health_summary.csv", descriptor_rows)
    write_json(tables / "rollup_summary.json", summary)
    plot_seed_pairs(seed_rows, figures / "seed_hv_pairs.png")
    plot_robustness(robustness, figures / "seed_hv_delta_robustness.png")
    plot_problem_mean_deltas(deltas, figures / "problem_mean_hv_delta.png")
    write_report(PACKAGE / "seed_robustness_report.md", summary)


def read_csv(path: Path) -> list[dict[str, str]]:
    assert path.is_file(), path
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))


def write_csv(path: Path, rows: list[TableRow]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def seed_metrics(rows: list[dict[str, str]]) -> list[TableRow]:
    by_backend = {row["backend"]: row for row in rows if row["benchmark"] == "ALL"}
    output: list[TableRow] = []
    for seed in SEEDS:
        classic = by_backend[f"classic_s{seed}"]
        t83 = by_backend[f"t83_s{seed}"]
        classic_hv = fnum(classic["mean_hypervolume"])
        t83_hv = fnum(t83["mean_hypervolume"])
        output.append(
            {
                "seed": seed,
                "classic_hv": classic_hv,
                "t83_hv": t83_hv,
                "hv_delta": t83_hv - classic_hv,
                "relative_hv_delta_percent": pct(t83_hv - classic_hv, classic_hv),
                "classic_pareto_points": fnum(classic["mean_pareto_point_count"]),
                "t83_pareto_points": fnum(t83["mean_pareto_point_count"]),
                "pareto_point_delta": fnum(t83["mean_pareto_point_count"])
                - fnum(classic["mean_pareto_point_count"]),
                "classic_ref_beating": fnum(classic["mean_reference_beating_count"]),
                "t83_ref_beating": fnum(t83["mean_reference_beating_count"]),
                "ref_beating_delta": fnum(t83["mean_reference_beating_count"])
                - fnum(classic["mean_reference_beating_count"]),
            }
        )
    return output


def problem_deltas(rows: list[dict[str, str]]) -> list[TableRow]:
    by_key = {(row["backend"], row["benchmark"], row["problem"]): row for row in rows}
    output: list[TableRow] = []
    for seed in SEEDS:
        for backend, benchmark, problem in sorted(by_key):
            if backend != f"classic_s{seed}":
                continue
            classic = by_key[(backend, benchmark, problem)]
            t83 = by_key[(f"t83_s{seed}", benchmark, problem)]
            classic_hv = fnum(classic["hypervolume"])
            t83_hv = fnum(t83["hypervolume"])
            output.append(
                {
                    "seed": seed,
                    "benchmark": benchmark,
                    "problem": problem,
                    "classic_hv": classic_hv,
                    "t83_hv": t83_hv,
                    "hv_delta": t83_hv - classic_hv,
                    "classic_pareto_points": fnum(classic["pareto_point_count"]),
                    "t83_pareto_points": fnum(t83["pareto_point_count"]),
                    "pareto_point_delta": fnum(t83["pareto_point_count"])
                    - fnum(classic["pareto_point_count"]),
                    "classic_ref_beating": fnum(classic["reference_beating_count"]),
                    "t83_ref_beating": fnum(t83["reference_beating_count"]),
                    "ref_beating_delta": fnum(t83["reference_beating_count"])
                    - fnum(classic["reference_beating_count"]),
                }
            )
    return output


def robustness_rows(deltas: list[TableRow]) -> list[TableRow]:
    output: list[TableRow] = []
    for seed in SEEDS:
        seed_rows = [row for row in deltas if row["seed"] == seed]
        slices = (
            ("all", seed_rows),
            ("without_prob135", [row for row in seed_rows if row["problem"] != PROB135]),
            ("rtllm_only", [row for row in seed_rows if row["benchmark"] == "RTLLM"]),
        )
        for label, rows in slices:
            classic = mean([float(row["classic_hv"]) for row in rows])
            t83 = mean([float(row["t83_hv"]) for row in rows])
            output.append(
                {
                    "seed": seed,
                    "slice": label,
                    "problem_count": len(rows),
                    "classic_mean_hv": classic,
                    "t83_mean_hv": t83,
                    "hv_delta": t83 - classic,
                    "relative_hv_delta_percent": pct(t83 - classic, classic),
                }
            )
    return output


def descriptor_health_rows() -> list[TableRow]:
    rows: list[TableRow] = []
    for seed in SEEDS:
        run_root = run_root_for_seed(seed)
        for path in sorted(run_root.glob("*/*/descriptor_health.json")):
            health = json.loads(path.read_text(encoding="utf-8"))
            summary = json.loads(
                (path.parent / "archive_summary.json").read_text(encoding="utf-8")
            )
            stats = {
                item["axis"]: item["archive_stats"] for item in health["axis_health"]
            }
            rows.append(
                {
                    "seed": seed,
                    "benchmark": path.parent.parent.name,
                    "problem": path.parent.name,
                    "observations": health["observation_count"],
                    "archive_members": summary["archive_member_count"],
                    "occupied_cells": health["occupied_cells"],
                    "active_effective_axes": health["active_effective_axes"],
                    "collapsed_axes": ";".join(health["collapsed_axes"]),
                    "rf_leaf_archive_unique": stats[
                        "source_aligned_rf_timing_leaf_ids"
                    ]["unique_count"],
                    "branch_archive_unique": stats[
                        "source_aligned_masterrtl_branching"
                    ]["unique_count"],
                    "wire_density_archive_unique": stats[
                        "source_aligned_rtltimer_wire_density"
                    ]["unique_count"],
                }
            )
    return rows


def run_root_for_seed(seed: str) -> Path:
    if seed == "1001":
        return Path(
            "exp/useful_bd_push/prelim_rf_leafid_structural_delayed_20260626_052350_UTC/"
            "live/masterrtl_rf_leafid_structural_delayed_8x5/seed_1001/"
            "openai_gpt-oss-120b"
        )
    return Path(
        "exp/useful_bd_push/prelim_rf_leafid_seed_robustness_20260626_UTC/"
        f"live/masterrtl_rf_leafid_structural_delayed_8x5/seed_{seed}/"
        "openai_gpt-oss-120b"
    )


def rollup_summary(
    seed_rows: list[TableRow],
    robustness: list[TableRow],
    deltas: list[TableRow],
) -> dict[str, object]:
    classic_mean = mean([float(row["classic_hv"]) for row in seed_rows])
    t83_mean = mean([float(row["t83_hv"]) for row in seed_rows])
    no_prob135 = [row for row in robustness if row["slice"] == "without_prob135"]
    rtllm = [row for row in robustness if row["slice"] == "rtllm_only"]
    return {
        "status": "diagnostic_negative_not_promoted",
        "classic_three_seed_mean_hv": classic_mean,
        "t83_three_seed_mean_hv": t83_mean,
        "three_seed_hv_delta": t83_mean - classic_mean,
        "three_seed_relative_hv_delta_percent": pct(t83_mean - classic_mean, classic_mean),
        "without_prob135_classic_mean_hv": mean(
            [float(row["classic_mean_hv"]) for row in no_prob135]
        ),
        "without_prob135_t83_mean_hv": mean(
            [float(row["t83_mean_hv"]) for row in no_prob135]
        ),
        "rtllm_classic_mean_hv": mean([float(row["classic_mean_hv"]) for row in rtllm]),
        "rtllm_t83_mean_hv": mean([float(row["t83_mean_hv"]) for row in rtllm]),
        "t83_hv_seed_wins": sum(float(row["hv_delta"]) > 0.0 for row in seed_rows),
        "problem_mean_hv_deltas": mean_problem_deltas(deltas),
    }


def mean_problem_deltas(deltas: list[TableRow]) -> list[TableRow]:
    output: list[TableRow] = []
    for problem in sorted({str(row["problem"]) for row in deltas}):
        rows = [row for row in deltas if row["problem"] == problem]
        output.append(
            {
                "problem": problem,
                "mean_hv_delta": mean([float(row["hv_delta"]) for row in rows]),
            }
        )
    return output


def plot_seed_pairs(rows: list[TableRow], path: Path) -> None:
    seeds = [str(row["seed"]) for row in rows]
    classic = [float(row["classic_hv"]) for row in rows]
    t83 = [float(row["t83_hv"]) for row in rows]
    x = list(range(len(seeds)))
    _, ax = plt.subplots(figsize=(7.0, 4.2))
    ax.bar([i - 0.18 for i in x], classic, width=0.36, label="Classic", color="#334155")
    ax.bar([i + 0.18 for i in x], t83, width=0.36, label="T83", color="#2563eb")
    ax.set_xticks(x, seeds)
    ax.set_xlabel("Seed")
    ax.set_ylabel("Mean hypervolume")
    ax.set_title("T83 seed-level HV comparison")
    ax.legend(frameon=False)
    ax.grid(axis="y", alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def plot_robustness(rows: list[TableRow], path: Path) -> None:
    labels = [f"{row['seed']} {row['slice']}" for row in rows]
    values = [float(row["hv_delta"]) for row in rows]
    colors = ["#047857" if value >= 0 else "#b91c1c" for value in values]
    _, ax = plt.subplots(figsize=(9.5, 4.6))
    ax.bar(labels, values, color=colors)
    ax.axhline(0.0, color="#111827", linewidth=1.0)
    ax.set_ylabel("T83 minus classic mean HV")
    ax.set_title("Robustness slices by seed")
    ax.tick_params(axis="x", rotation=35)
    ax.grid(axis="y", alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def plot_problem_mean_deltas(rows: list[TableRow], path: Path) -> None:
    problem_rows = sorted(
        mean_problem_deltas(rows),
        key=lambda row: float(row["mean_hv_delta"]),
    )
    labels = [str(row["problem"]).replace("Prob", "P") for row in problem_rows]
    values = [float(row["mean_hv_delta"]) for row in problem_rows]
    colors = ["#047857" if value >= 0 else "#b91c1c" for value in values]
    _, ax = plt.subplots(figsize=(9.4, 4.8))
    ax.bar(labels, values, color=colors)
    ax.axhline(0.0, color="#111827", linewidth=1.0)
    ax.set_ylabel("Mean HV delta")
    ax.set_title("Problem-level mean HV delta across seeds")
    ax.tick_params(axis="x", rotation=35)
    ax.grid(axis="y", alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def write_report(path: Path, summary: dict[str, object]) -> None:
    classic = summary_num(summary, "classic_three_seed_mean_hv")
    t83 = summary_num(summary, "t83_three_seed_mean_hv")
    no_prob135_classic = summary_num(summary, "without_prob135_classic_mean_hv")
    no_prob135_t83 = summary_num(summary, "without_prob135_t83_mean_hv")
    rtllm_classic = summary_num(summary, "rtllm_classic_mean_hv")
    rtllm_t83 = summary_num(summary, "rtllm_t83_mean_hv")
    lines = [
        "# T88 RF Leaf-ID Seed Robustness Results",
        "",
        "Status: diagnostic negative; do not promote exact T83 to full RTLLM.",
        "",
        "## Headline",
        "",
        f"- Three-seed classic mean HV: `{classic:.6f}`",
        f"- Three-seed T83 mean HV: `{t83:.6f}`",
        f"- Relative HV delta: `{pct(t83 - classic, classic):+.2f}%`",
        f"- T83 seed-level HV wins: `{summary['t83_hv_seed_wins']}/3`",
        "",
        "## Robustness",
        "",
        f"- No-Prob135 classic mean HV: `{no_prob135_classic:.6f}`",
        f"- No-Prob135 T83 mean HV: `{no_prob135_t83:.6f}`",
        f"- RTLLM-only classic mean HV: `{rtllm_classic:.6f}`",
        f"- RTLLM-only T83 mean HV: `{rtllm_t83:.6f}`",
        "",
        "## Decision",
        "",
        "T83 remains the current MasterRTL RF model-state category",
        "representative, but the seed gate blocks promotion. The exact",
        "configuration does not meet the near-classic robustness rule and",
        "should not receive larger RTLLM budget without a materially different",
        "coupling mechanism.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def mean(values: list[float]) -> float:
    assert values
    return sum(values) / len(values)


def summary_num(summary: dict[str, object], key: str) -> float:
    value = summary[key]
    assert isinstance(value, float | int)
    return float(value)


def fnum(value: str) -> float:
    return float(value)


def pct(delta: float, base: float) -> float:
    assert base != 0.0
    return 100.0 * delta / base


if __name__ == "__main__":
    main()
