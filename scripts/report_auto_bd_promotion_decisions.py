#!/usr/bin/env python3
"""Generate Auto-BD seed-1 promotion and threshold decisions."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

REFERENCE_METHOD = "classic_revolution"
MANUAL_BASELINE = "landing_smooth_qd_manual_bd"
AUTO_BD_METHODS = {
    "netlist_motif_occupancy",
    "synthesis_trajectory_nod",
    "synthesis_trajectory_motif_nod",
    "sr_raw_pca_qd",
    "sr_random_relu_pca_qd",
    "sr_rff_pca_qd",
    "sr_vq_codebook_qd",
}
CONTROL_METHODS = {
    "random_descriptor_qd",
    "simple_yosys_stat_bd",
}
ROBUSTNESS_DROP_LIMIT = 0.05
FITNESS_RELATIVE_UPLIFT = 0.10
HYPERVOLUME_RELATIVE_UPLIFT = 0.10
QD_SCORE_RELATIVE_UPLIFT = 0.15
QD_COVERAGE_RELATIVE_UPLIFT = 0.20
UNIQUE_NETLIST_RELATIVE_UPLIFT = 0.25
EQUIVALENCE_MARGIN = 0.03


def build_decision_payload(report_path: Path) -> dict[str, Any]:
    """Build promotion decisions from a centralized seed-1 report."""

    report = load_json(report_path)
    gates = by_method(report["gate_matrix"])
    robustness = by_method(report["robustness_funnel"])
    leaderboard = by_method(report["leaderboard"])
    manual = robustness[MANUAL_BASELINE]
    reference = leaderboard[REFERENCE_METHOD]
    rows = [
        decision_row(method, gates[method], robustness[method], leaderboard[method], manual, reference)
        for method in leaderboard
    ]
    return {
        "source_report": report_path.as_posix(),
        "phase": report["phase"],
        "seed": report["seed"],
        "thresholds": thresholds_payload(),
        "baseline_mde_power_review": mde_power_review_payload(report),
        "decisions": rows,
        "seed3_screening_arms": seed3_screening_arms(rows),
    }


def decision_row(
    method: str,
    gate: dict[str, Any],
    robust: dict[str, Any],
    leader: dict[str, Any],
    manual: dict[str, Any],
    reference: dict[str, Any],
) -> dict[str, Any]:
    role = method_role(method)
    gate0 = gate["gate0"] == "PASS"
    drops = {
        "functionality_drop": float(manual["functionality_rate"]) - float(robust["functionality_rate"]),
        "synthesis_drop": float(manual["synthesis_rate"]) - float(robust["synthesis_rate"]),
        "openroad_drop": float(manual["openroad_rate"]) - float(robust["openroad_rate"]),
        "valid_ppa_drop": float(manual["valid_ppa_rate"]) - float(robust["valid_ppa_rate"]),
    }
    robustness_pass = all(value <= ROBUSTNESS_DROP_LIMIT for value in drops.values())
    optimization_pass = optimization_gate(role, leader, reference)
    return {
        "method_name": method,
        "role": role,
        "gate0": "PASS" if gate0 else "FAIL",
        "robustness_gate": "PASS" if robustness_pass else "FAIL",
        "optimization_gate": "PASS" if optimization_pass else "FAIL",
        "functionality_drop_pp": drops["functionality_drop"] * 100,
        "synthesis_drop_pp": drops["synthesis_drop"] * 100,
        "openroad_drop_pp": drops["openroad_drop"] * 100,
        "valid_ppa_drop_pp": drops["valid_ppa_drop"] * 100,
        "valid_ppa_candidate_count": int(leader["valid_ppa_candidate_count"]),
        "mean_best_fitness": float(leader["mean_best_fitness"]),
        "mean_hypervolume": float(leader["mean_hypervolume"]),
        "fitness_wtl": wtl(leader, "fitness"),
        "hypervolume_wtl": wtl(leader, "hv"),
        "decision": decision_label(role, gate0, robustness_pass, optimization_pass),
        "decision_reason": decision_reason(role, gate0, robustness_pass, optimization_pass, drops),
    }


def method_role(method: str) -> str:
    if method == REFERENCE_METHOD:
        return "classic_baseline"
    if method == MANUAL_BASELINE:
        return "manual_bd_baseline"
    if method in AUTO_BD_METHODS:
        return "auto_bd_method"
    if method in CONTROL_METHODS:
        return "screening_control"
    raise AssertionError(f"unknown method: {method}")


def optimization_gate(role: str, leader: dict[str, Any], reference: dict[str, Any]) -> bool:
    if role != "auto_bd_method":
        return True
    fitness_uplift = relative_uplift(leader["mean_best_fitness"], reference["mean_best_fitness"])
    hv_uplift = relative_uplift(leader["mean_hypervolume"], reference["mean_hypervolume"])
    return (
        fitness_uplift >= FITNESS_RELATIVE_UPLIFT
        or hv_uplift >= HYPERVOLUME_RELATIVE_UPLIFT
        or int(leader["fitness_wins"]) > int(leader["fitness_losses"])
        or int(leader["hv_wins"]) > int(leader["hv_losses"])
    )


def relative_uplift(value: int | float | str, reference: int | float | str) -> float:
    return (float(value) - float(reference)) / abs(float(reference))


def decision_label(
    role: str,
    gate0: bool,
    robustness_pass: bool,
    optimization_pass: bool,
) -> str:
    if role in {"classic_baseline", "manual_bd_baseline"}:
        return "RETAIN_AS_COMPARATOR"
    if gate0 and robustness_pass and optimization_pass:
        return "PROMOTE_TO_SEED3"
    return "DO_NOT_PROMOTE"


def decision_reason(
    role: str,
    gate0: bool,
    robustness_pass: bool,
    optimization_pass: bool,
    drops: dict[str, float],
) -> str:
    if role in {"classic_baseline", "manual_bd_baseline"}:
        return "Required baseline comparator for seed-3 screening."
    if not gate0:
        return "Fails Gate 0 coverage."
    if not robustness_pass:
        worst = max(drops.items(), key=lambda item: item[1])
        return f"Fails Gate 1 robustness: {worst[0]} is {worst[1] * 100:.2f} pp."
    if not optimization_pass:
        return "Fails Gate 2 screening signal versus classic REvolution."
    return "Passes development Gate 0, Gate 1, and Gate 2 screening gates."


def seed3_screening_arms(rows: list[dict[str, Any]]) -> list[str]:
    arms = [
        REFERENCE_METHOD,
        MANUAL_BASELINE,
    ]
    arms.extend(
        row["method_name"]
        for row in rows
        if row["decision"] == "PROMOTE_TO_SEED3"
    )
    return sorted(set(arms), key=arms.index)


def thresholds_payload() -> dict[str, Any]:
    return {
        "gate0": {
            "selected_method_must_cover_all_classic_problems": True,
            "problem_seed_missing_high_risk_fraction": 0.05,
        },
        "gate1_robustness": {
            "max_functionality_drop_pp": ROBUSTNESS_DROP_LIMIT * 100,
            "max_synthesis_drop_pp": ROBUSTNESS_DROP_LIMIT * 100,
            "max_openroad_drop_pp": ROBUSTNESS_DROP_LIMIT * 100,
            "max_valid_ppa_drop_pp": ROBUSTNESS_DROP_LIMIT * 100,
        },
        "gate2_optimization": {
            "mean_best_fitness_relative_uplift": FITNESS_RELATIVE_UPLIFT,
            "mean_hypervolume_relative_uplift": HYPERVOLUME_RELATIVE_UPLIFT,
            "problem_win_loss_signal": "fitness_wins > fitness_losses or hv_wins > hv_losses",
            "equivalence_margin": EQUIVALENCE_MARGIN,
        },
        "gate3_qd": {
            "qd_score_relative_uplift": QD_SCORE_RELATIVE_UPLIFT,
            "archive_coverage_relative_uplift": QD_COVERAGE_RELATIVE_UPLIFT,
            "unique_netlist_relative_uplift": UNIQUE_NETLIST_RELATIVE_UPLIFT,
        },
    }


def mde_power_review_payload(report: dict[str, Any]) -> dict[str, Any]:
    problem_count = len({row["problem_id"] for row in report["problem_metrics"]})
    return {
        "development_problem_seed_pairs": problem_count,
        "development_assessment": (
            "Seed-1 development evidence is underpowered for final claims; "
            "use only for Gate 0, robustness, and screening promotion."
        ),
        "screening_required_seeds": [1001, 1002, 1003],
        "final_preferred_seeds": [1001, 1002, 1003, 1004, 1005],
        "minimum_effect_policy": (
            "Final sign-off requires predeclared practical effect thresholds "
            "plus paired problem-seed statistics; seed-1 apparent wins are exploratory."
        ),
    }


def render_markdown(payload: dict[str, Any]) -> str:
    return "\n".join(
        [
            "# Auto-BD Seed-1 Promotion Decisions",
            "",
            "Status: predeclared seed-3 screening decision from seed-1 development artifacts.",
            "",
            "## Baseline MDE/Power Review",
            "",
            f"- Development problem-seed pairs: `{payload['baseline_mde_power_review']['development_problem_seed_pairs']}`",
            f"- Assessment: {payload['baseline_mde_power_review']['development_assessment']}",
            f"- Seed-3 screening seeds: `{payload['baseline_mde_power_review']['screening_required_seeds']}`",
            f"- Seed-5 final preferred seeds: `{payload['baseline_mde_power_review']['final_preferred_seeds']}`",
            f"- Effect policy: {payload['baseline_mde_power_review']['minimum_effect_policy']}",
            "",
            "## Predeclared Thresholds",
            "",
            markdown_table(
                ["Gate", "Threshold"],
                [
                    ["Gate 0", "cover every classic-covered problem; >5% problem-seed misses is high risk"],
                    ["Gate 1", "<= 5 pp drop in functionality, synthesis, OpenROAD, and valid-PPA rates"],
                    ["Gate 2", ">=10% mean fitness/HV uplift or positive fitness/HV W/L"],
                    ["Gate 3", ">=15% QD score, >=20% coverage, or >=25% unique-netlist uplift"],
                    ["Equivalence", f"fitness margin {EQUIVALENCE_MARGIN:.2f}"],
                ],
            ),
            "",
            "## Promotion Decisions",
            "",
            markdown_table(
                [
                    "Method",
                    "Role",
                    "Gate 0",
                    "Gate 1",
                    "Gate 2",
                    "Func Drop pp",
                    "Valid Drop pp",
                    "Fitness W/T/L",
                    "HV W/T/L",
                    "Decision",
                    "Reason",
                ],
                [
                    [
                        code(row["method_name"]),
                        row["role"],
                        row["gate0"],
                        row["robustness_gate"],
                        row["optimization_gate"],
                        fmt(row["functionality_drop_pp"]),
                        fmt(row["valid_ppa_drop_pp"]),
                        row["fitness_wtl"],
                        row["hypervolume_wtl"],
                        row["decision"],
                        row["decision_reason"],
                    ]
                    for row in payload["decisions"]
                ],
            ),
            "",
            "## Seed-3 Screening Arms",
            "",
            "\n".join(f"- `{method}`" for method in payload["seed3_screening_arms"]),
            "",
            "## Source",
            "",
            f"- Central report JSON: `{payload['source_report']}`",
            "",
        ]
    )


def by_method(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    return {str(row["method_name"]): row for row in rows}


def wtl(row: dict[str, Any], prefix: str) -> str:
    return f"{row[f'{prefix}_wins']}/{row[f'{prefix}_ties']}/{row[f'{prefix}_losses']}"


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(lines)


def fmt(value: object) -> str:
    assert isinstance(value, int | float | str)
    return f"{float(value):.2f}"


def code(value: object) -> str:
    return f"`{value}`"


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--central-report-json", type=Path, required=True)
    parser.add_argument("--output-md", type=Path, required=True)
    parser.add_argument("--output-json", type=Path, required=True)
    args = parser.parse_args(argv)

    payload = build_decision_payload(args.central_report_json)
    args.output_md.parent.mkdir(parents=True, exist_ok=True)
    args.output_md.write_text(render_markdown(payload), encoding="utf-8")
    write_json(args.output_json, payload)
    print(f"Auto-BD promotion decisions -> {args.output_md}")
    print(f"Auto-BD promotion data -> {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
