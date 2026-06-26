#!/usr/bin/env python3
"""Package the auxiliary archive seed-replication gate."""

from __future__ import annotations

import csv
import json
from pathlib import Path

import matplotlib


matplotlib.use("Agg")
import matplotlib.pyplot as plt


PACKAGE = Path(__file__).resolve().parents[1]
ANALYSIS = Path(
    "exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live/"
    "final_analysis_seed_replication"
)
SEEDS = ("1001", "1002", "1003")
PROB135 = "Prob135_m2014_q6b"
TableRow = dict[str, str | float | int]


def main() -> None:
    assert ANALYSIS.is_dir(), ANALYSIS
    tables = PACKAGE / "tables"
    figures = PACKAGE / "figures"
    reports = PACKAGE / "reports"
    for path in (tables, figures, reports):
        path.mkdir(exist_ok=True)

    aggregate = read_csv(ANALYSIS / "pareto_analysis/aggregate_backend_metrics.csv")
    problems = read_csv(ANALYSIS / "pareto_analysis/backend_problem_metrics.csv")
    seed_rows = seed_metrics(aggregate)
    deltas = problem_deltas(problems)
    robustness = robustness_rows(deltas)
    summary = rollup_summary(seed_rows, robustness, deltas)

    write_csv(tables / "seed_pair_metrics.csv", seed_rows)
    write_csv(tables / "problem_seed_deltas.csv", deltas)
    write_csv(tables / "seed_pair_robustness.csv", robustness)
    write_json(tables / "rollup_summary.json", summary)
    plot_seed_pairs(seed_rows, figures / "seed_hv_pairs.png")
    plot_robustness(robustness, figures / "seed_hv_delta_robustness.png")
    plot_problem_mean_deltas(deltas, figures / "problem_mean_hv_delta.png")
    write_report(PACKAGE / "seed_replication_rollup_report.md", summary)


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
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def backend_parts(name: str) -> tuple[str, str]:
    method, seed = name.split("_s", maxsplit=1)
    assert method in {"classic", "aux"}, name
    assert seed in SEEDS, name
    return method, seed


def seed_metrics(rows: list[dict[str, str]]) -> list[TableRow]:
    by_backend = {row["backend"]: row for row in rows if row["benchmark"] == "ALL"}
    output: list[TableRow] = []
    for seed in SEEDS:
        classic = by_backend[f"classic_s{seed}"]
        aux = by_backend[f"aux_s{seed}"]
        classic_hv = fnum(classic["mean_hypervolume"])
        aux_hv = fnum(aux["mean_hypervolume"])
        output.append(
            {
                "seed": seed,
                "classic_hv": classic_hv,
                "aux_hv": aux_hv,
                "hv_delta": aux_hv - classic_hv,
                "relative_hv_delta_percent": pct(aux_hv - classic_hv, classic_hv),
                "classic_pareto_points": fnum(classic["mean_pareto_point_count"]),
                "aux_pareto_points": fnum(aux["mean_pareto_point_count"]),
                "pareto_point_delta": fnum(aux["mean_pareto_point_count"])
                - fnum(classic["mean_pareto_point_count"]),
                "classic_ref_beating": fnum(classic["mean_reference_beating_count"]),
                "aux_ref_beating": fnum(aux["mean_reference_beating_count"]),
                "ref_beating_delta": fnum(aux["mean_reference_beating_count"])
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
            aux = by_key[(f"aux_s{seed}", benchmark, problem)]
            classic_hv = fnum(classic["hypervolume"])
            aux_hv = fnum(aux["hypervolume"])
            output.append(
                {
                    "seed": seed,
                    "benchmark": benchmark,
                    "problem": problem,
                    "classic_hv": classic_hv,
                    "aux_hv": aux_hv,
                    "hv_delta": aux_hv - classic_hv,
                    "classic_pareto_points": fnum(classic["pareto_point_count"]),
                    "aux_pareto_points": fnum(aux["pareto_point_count"]),
                    "pareto_point_delta": fnum(aux["pareto_point_count"])
                    - fnum(classic["pareto_point_count"]),
                    "classic_ref_beating": fnum(classic["reference_beating_count"]),
                    "aux_ref_beating": fnum(aux["reference_beating_count"]),
                    "ref_beating_delta": fnum(aux["reference_beating_count"])
                    - fnum(classic["reference_beating_count"]),
                }
            )
    return output


def robustness_rows(deltas: list[TableRow]) -> list[TableRow]:
    output: list[TableRow] = []
    for seed in SEEDS:
        seed_rows = [row for row in deltas if row["seed"] == seed]
        for label, rows in (
            ("all", seed_rows),
            ("without_prob135", [row for row in seed_rows if row["problem"] != PROB135]),
            ("rtllm_only", [row for row in seed_rows if row["benchmark"] == "RTLLM"]),
        ):
            classic = mean([float(row["classic_hv"]) for row in rows])
            aux = mean([float(row["aux_hv"]) for row in rows])
            output.append(
                {
                    "seed": seed,
                    "slice": label,
                    "problem_count": len(rows),
                    "classic_mean_hv": classic,
                    "aux_mean_hv": aux,
                    "hv_delta": aux - classic,
                    "relative_hv_delta_percent": pct(aux - classic, classic),
                }
            )
    return output


def rollup_summary(
    seed_rows: list[TableRow],
    robustness: list[TableRow],
    deltas: list[TableRow],
) -> dict[str, object]:
    classic_mean = mean([float(row["classic_hv"]) for row in seed_rows])
    aux_mean = mean([float(row["aux_hv"]) for row in seed_rows])
    no_prob135 = [row for row in robustness if row["slice"] == "without_prob135"]
    no_prob135_classic = mean([float(row["classic_mean_hv"]) for row in no_prob135])
    no_prob135_aux = mean([float(row["aux_mean_hv"]) for row in no_prob135])
    problem_means = mean_problem_deltas(deltas)
    return {
        "status": "diagnostic_negative_not_promoted",
        "classic_three_seed_mean_hv": classic_mean,
        "aux_three_seed_mean_hv": aux_mean,
        "three_seed_hv_delta": aux_mean - classic_mean,
        "three_seed_relative_hv_delta_percent": pct(aux_mean - classic_mean, classic_mean),
        "without_prob135_classic_mean_hv": no_prob135_classic,
        "without_prob135_aux_mean_hv": no_prob135_aux,
        "without_prob135_hv_delta": no_prob135_aux - no_prob135_classic,
        "without_prob135_relative_hv_delta_percent": pct(
            no_prob135_aux - no_prob135_classic, no_prob135_classic
        ),
        "aux_hv_seed_wins": sum(float(row["hv_delta"]) > 0.0 for row in seed_rows),
        "problem_mean_hv_deltas": problem_means,
    }


def mean_problem_deltas(deltas: list[TableRow]) -> list[TableRow]:
    problems = sorted({str(row["problem"]) for row in deltas})
    output: list[TableRow] = []
    for problem in problems:
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
    aux = [float(row["aux_hv"]) for row in rows]
    x = list(range(len(seeds)))
    _, ax = plt.subplots(figsize=(7.0, 4.2))
    ax.bar([i - 0.18 for i in x], classic, width=0.36, label="Classic", color="#2f6f9f")
    ax.bar([i + 0.18 for i in x], aux, width=0.36, label="Aux archive", color="#c66b3d")
    ax.set_xticks(x, seeds)
    ax.set_xlabel("Seed")
    ax.set_ylabel("Mean hypervolume")
    ax.set_title("Seed-level HV comparison")
    ax.legend(frameon=False)
    ax.grid(axis="y", alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def plot_robustness(rows: list[TableRow], path: Path) -> None:
    labels = [f"{row['seed']} {row['slice']}" for row in rows]
    values = [float(row["hv_delta"]) for row in rows]
    colors = ["#3a7d44" if value >= 0 else "#a23e48" for value in values]
    _, ax = plt.subplots(figsize=(9.5, 4.6))
    ax.bar(labels, values, color=colors)
    ax.axhline(0.0, color="#222222", linewidth=1.0)
    ax.set_ylabel("Aux minus classic mean HV")
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
    labels = [str(row["problem"]) for row in problem_rows]
    values = [float(row["mean_hv_delta"]) for row in problem_rows]
    colors = ["#3a7d44" if value >= 0 else "#a23e48" for value in values]
    _, ax = plt.subplots(figsize=(8.2, 4.8))
    ax.barh(labels, values, color=colors)
    ax.axvline(0.0, color="#222222", linewidth=1.0)
    ax.set_xlabel("Mean HV delta over seeds")
    ax.set_title("Problem-level mean HV delta")
    ax.grid(axis="x", alpha=0.25)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def write_report(path: Path, summary: dict[str, object]) -> None:
    path.write_text(
        "\n".join(
            [
                "# Seed Replication Rollup",
                "",
                "Status: `diagnostic_negative_not_promoted`.",
                "",
                "## Conclusion",
                "",
                "The high-exploit auxiliary archive mechanism does not survive the",
                "seed-replication gate as a final RTLLM candidate. Classic wins the",
                "three-seed mean HV comparison, and the no-Prob135 robustness slice",
                "is also negative.",
                "",
                "## Key Numbers",
                "",
                f"- Classic three-seed mean HV: `{summary['classic_three_seed_mean_hv']:.6f}`",
                f"- Aux three-seed mean HV: `{summary['aux_three_seed_mean_hv']:.6f}`",
                f"- Relative HV delta: `{summary['three_seed_relative_hv_delta_percent']:.2f}%`",
                f"- Relative HV delta without Prob135: "
                f"`{summary['without_prob135_relative_hv_delta_percent']:.2f}%`",
                f"- Aux seed-level HV wins: `{summary['aux_hv_seed_wins']}/3`",
                "",
                "## Interpretation",
                "",
                "`Prob135_m2014_q6b` was a one-seed positive swing, not a stable",
                "mechanism signal. The current auxiliary archive geometry should not",
                "be promoted to the full RTLLM comparison. The next QD attempt should",
                "change coupling pressure, for example by using an adaptive archive",
                "pressure schedule, rather than retuning the same MasterRTL geometry.",
                "",
                "## Artifacts",
                "",
                "- `tables/seed_pair_metrics.csv`",
                "- `tables/seed_pair_robustness.csv`",
                "- `tables/problem_seed_deltas.csv`",
                "- `figures/seed_hv_pairs.png`",
                "- `figures/seed_hv_delta_robustness.png`",
                "- `figures/problem_mean_hv_delta.png`",
                "",
            ]
        ),
        encoding="utf-8",
    )


def fnum(value: str) -> float:
    return float(value)


def mean(values: list[float]) -> float:
    assert values
    return sum(values) / len(values)


def pct(delta: float, base: float) -> float:
    assert base != 0.0
    return 100.0 * delta / base


if __name__ == "__main__":
    main()
