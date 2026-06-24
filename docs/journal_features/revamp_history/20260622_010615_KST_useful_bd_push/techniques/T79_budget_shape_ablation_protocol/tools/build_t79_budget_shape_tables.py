"""Build the T79 budget-shape protocol tables and subset figure."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt


WORKSPACE = Path("/workspace")
REVAMP = (
    WORKSPACE
    / "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push"
)
PACKAGE = Path(__file__).resolve().parents[1]
SOURCE_TABLES = [
    REVAMP / "tables/frozen_screening_subset.csv",
    REVAMP / "tables/holdout_screening_subset.csv",
]
PRIMARY_IDS = [
    "RTLLM/Prob015_multi_pipe_8bit",
    "RTLLM/Prob024_fsm",
    "RTLLM/Prob041_traffic_light",
    "RTLLM/Prob045_alu",
    "RTLLM/Prob049_signal_generator",
    "VerilogEval-Spec-to-RTL/Prob116_m2014_q3",
    "VerilogEval-Spec-to-RTL/Prob135_m2014_q6b",
    "VerilogEval-Spec-to-RTL/Prob153_gshare",
]
EXCLUSION_REASONS = {
    "RTLLM/Prob004_adder_8bit": "too_easy_high_prior_pareto_size_control_only",
    "RTLLM/Prob037_parallel2serial": "bit_vector_candidate_deferred_to_stress_slice",
    "VerilogEval-Spec-to-RTL/Prob098_circuit7": "very_high_duplicate_rate_appendix_only",
    "VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot": "holdout_control_deferred",
    "VerilogEval-Spec-to-RTL/Prob151_review2015_fsm": "t78_empty_archive_primary_exclusion",
}


def read_rows() -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for path in SOURCE_TABLES:
        with path.open(newline="") as handle:
            rows.extend(csv.DictReader(handle))
    return rows


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def split_problem(problem_id: str) -> tuple[str, str]:
    benchmark, problem = problem_id.split("/", 1)
    return benchmark, problem


def build_subset(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    by_id = {row["problem_id"]: row for row in rows}
    selected: list[dict[str, Any]] = []
    for rank, problem_id in enumerate(PRIMARY_IDS, start=1):
        row = by_id[problem_id]
        benchmark, problem = split_problem(problem_id)
        selected.append(
            {
                "rank": rank,
                "benchmark": benchmark,
                "problem": problem,
                "stratum": row["stratum"],
                "classic_valid_ppa_count": int(row["classic_valid_ppa_count"]),
                "ppa_variance": float(row["ppa_variance"]),
                "pareto_size": int(row["pareto_size"]),
                "unique_family_count": int(row["unique_family_count"]),
                "duplicate_rate": float(row["duplicate_rate"]),
                "source_selection_reason": row["selection_reason"],
            }
        )
    return selected


def build_exclusions(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    by_id = {row["problem_id"]: row for row in rows}
    excluded: list[dict[str, Any]] = []
    for problem_id, reason in EXCLUSION_REASONS.items():
        row = by_id[problem_id]
        benchmark, problem = split_problem(problem_id)
        excluded.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "stratum": row["stratum"],
                "classic_valid_ppa_count": int(row["classic_valid_ppa_count"]),
                "ppa_variance": float(row["ppa_variance"]),
                "pareto_size": int(row["pareto_size"]),
                "duplicate_rate": float(row["duplicate_rate"]),
                "exclusion_reason": reason,
            }
        )
    return excluded


def build_shape_matrix() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for shape, population, generations in [
        ("12x3", 12, 3),
        ("8x5", 8, 5),
        ("6x7", 6, 7),
    ]:
        for method in ["classic_revolution", "shape_density_front_pressure_qd"]:
            rows.append(
                {
                    "shape": shape,
                    "method": method,
                    "population_size": population,
                    "num_generations": generations,
                    "candidate_budget": population * (generations + 1),
                    "seed": 1001,
                    "status": "planned",
                }
            )
    return rows


def write_subset_yaml(rows: list[dict[str, Any]]) -> None:
    lines = ["selected_problems:"]
    for row in rows:
        lines.extend(
            [
                f"  - benchmark: {row['benchmark']}",
                f"    problem: {row['problem']}",
            ]
        )
    (PACKAGE / "tables/budget_shape_subset.yaml").write_text("\n".join(lines) + "\n")


def write_contract() -> None:
    contract = {
        "technique_id": "T79",
        "slug": "T79_budget_shape_ablation_protocol",
        "status": "pre_registered_not_run",
        "lane": "L8_budget_and_benchmark_shape",
        "methods": ["classic_revolution", "shape_density_front_pressure_qd"],
        "shapes": ["12x3", "8x5", "6x7"],
        "candidate_budget_per_design": 48,
        "seed": 1001,
        "primary_subset_path": "tables/t79_budget_ablation_subset.csv",
        "subset_config_path": "tables/budget_shape_subset.yaml",
        "selection_lock": "freeze_before_any_T79_live_outcome",
        "headline_rule": "reference_complete_paired_subset_only",
        "promotion_question": "does_deeper_budget_help_qd_more_than_classic",
    }
    (PACKAGE / "tables/t79_method_contract.json").write_text(
        json.dumps(contract, indent=2) + "\n"
    )


def plot_subset(rows: list[dict[str, Any]], excluded: list[dict[str, Any]]) -> None:
    fig, ax = plt.subplots(figsize=(10, 6), constrained_layout=True)
    ax.scatter(
        [float(row["classic_valid_ppa_count"]) for row in excluded],
        [float(row["ppa_variance"]) for row in excluded],
        s=70,
        color="#bab0ac",
        label="Deferred",
    )
    ax.scatter(
        [float(row["classic_valid_ppa_count"]) for row in rows],
        [float(row["ppa_variance"]) for row in rows],
        s=90,
        color="#4c78a8",
        label="T79 primary",
    )
    for row in rows:
        ax.annotate(
            str(row["problem"]).replace("Prob", "P"),
            (float(row["classic_valid_ppa_count"]), float(row["ppa_variance"])),
            xytext=(5, 4),
            textcoords="offset points",
            fontsize=8,
        )
    ax.set_title("T79 Frozen Budget-Ablation Subset")
    ax.set_xlabel("Prior classic valid-PPA count")
    ax.set_ylabel("Prior PPA variance")
    ax.grid(alpha=0.25)
    ax.legend(frameon=False)
    fig.savefig(PACKAGE / "figures/t79_budget_subset_selection.png", dpi=180)
    plt.close(fig)


def main() -> None:
    rows = read_rows()
    subset = build_subset(rows)
    excluded = build_exclusions(rows)
    write_csv(PACKAGE / "tables/t79_budget_ablation_subset.csv", subset)
    write_csv(PACKAGE / "tables/t79_deferred_candidates.csv", excluded)
    write_csv(PACKAGE / "tables/t79_budget_shape_matrix.csv", build_shape_matrix())
    write_subset_yaml(subset)
    write_contract()
    plot_subset(subset, excluded)


if __name__ == "__main__":
    main()
