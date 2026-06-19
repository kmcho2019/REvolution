#!/usr/bin/env python3
"""Report cross-method Auto-BD metrics from standard result directories."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    hypervolume,
    objective_metrics_for_reference,
    pareto_front,
)

REPO_ROOT = Path(__file__).resolve().parents[1]
METHOD_ORDER = (
    "classic_revolution",
    "landing_smooth_qd_manual_bd",
    "random_descriptor_qd",
    "simple_yosys_stat_bd",
    "netlist_motif_occupancy",
    "synthesis_trajectory_nod",
)
FITNESS_EPSILON = 0.03
HV_EPSILON = 1e-9
REFERENCE_METHOD = "classic_revolution"
PPA_METRICS = ("area", "power", "timing_or_clock_period", "fitness")


def build_report(
    *,
    results_root: Path,
    repo_root: Path,
    phase: str,
    seed: int,
) -> dict[str, Any]:
    """Build centralized seed-level report data from standard result tables."""

    result_dirs = standard_result_dirs(results_root, seed)
    assert REFERENCE_METHOD in result_dirs, f"missing {REFERENCE_METHOD}"
    per_method = {
        method: load_method_result(method, path, repo_root)
        for method, path in sorted(result_dirs.items(), key=method_sort_key)
    }
    classic_problems = covered_problems(per_method[REFERENCE_METHOD]["problem_metrics"])
    gate_rows = [
        gate_row(method, payload["problem_metrics"], classic_problems)
        for method, payload in per_method.items()
    ]
    leaderboard_rows = [
        leaderboard_row(method, payload, per_method[REFERENCE_METHOD])
        for method, payload in per_method.items()
    ]
    comparison_rows = per_problem_comparison_rows(per_method)
    robustness_rows = [
        payload["robustness"]
        for payload in per_method.values()
    ]
    failure_rows = [
        row
        for payload in per_method.values()
        for row in payload["failure_breakdown"]
    ]
    anytime_rows = [
        row
        for payload in per_method.values()
        for row in payload["anytime_metrics"]
    ]
    anytime_summary_rows = [
        anytime_summary_row(method, payload["anytime_metrics"])
        for method, payload in per_method.items()
    ]
    qd_rows = [
        payload["qd_summary"]
        for payload in per_method.values()
    ]
    problem_rows = [
        row
        for payload in per_method.values()
        for row in payload["problem_metrics"]
    ]
    archive_rows = [
        row
        for payload in per_method.values()
        for row in payload["archive"]
    ]
    representative_rows = [
        row
        for payload in per_method.values()
        for row in payload["representative_elites"]
    ]
    correlation_rows = [
        row
        for payload in per_method.values()
        for row in payload["descriptor_correlations"]
    ]
    return {
        "version": 1,
        "phase": phase,
        "seed": seed,
        "reference_method": REFERENCE_METHOD,
        "normalization": normalization_payload(),
        "gate_matrix": gate_rows,
        "leaderboard": leaderboard_rows,
        "robustness_funnel": robustness_rows,
        "failure_breakdown": failure_rows,
        "anytime_summary": anytime_summary_rows,
        "anytime_metrics": anytime_rows,
        "qd_summary": qd_rows,
        "archive_metrics": archive_rows,
        "representative_elites": representative_rows,
        "descriptor_correlations": correlation_rows,
        "comparison_matrix": comparison_rows,
        "problem_metrics": problem_rows,
        "artifact_roots": {
            method: path.as_posix()
            for method, path in sorted(result_dirs.items(), key=method_sort_key)
        },
    }


def standard_result_dirs(results_root: Path, seed: int) -> dict[str, Path]:
    assert results_root.is_dir(), f"missing results root: {results_root}"
    rows: dict[str, Path] = {}
    for path in sorted(results_root.glob(f"*/seed_{seed}/standard_results")):
        assert path.is_dir()
        rows[path.parents[1].name] = path
    assert rows, f"no seed {seed} standard_results directories under: {results_root}"
    return rows


def load_method_result(method: str, result_dir: Path, repo_root: Path) -> dict[str, Any]:
    candidates = pd.read_parquet(result_dir / "candidates.parquet")
    per_generation = pd.read_parquet(result_dir / "per_generation_metrics.parquet")
    archive = pd.read_parquet(result_dir / "archive_snapshots.parquet")
    descriptors = pd.read_parquet(result_dir / "descriptor_vectors.parquet")
    elites = pd.read_parquet(result_dir / "elites.parquet")
    summary = load_json(result_dir / "method_summary.json")
    problem_rows = [
        problem_metric_row(method, str(problem_id), group, repo_root)
        for problem_id, group in candidates.groupby("problem_id", sort=True)
    ]
    return {
        "summary": summary,
        "problem_metrics": problem_rows,
        "robustness": robustness_row(method, candidates),
        "failure_breakdown": failure_breakdown_rows(method, candidates),
        "anytime_metrics": build_anytime_rows(method, candidates, repo_root),
        "qd_summary": qd_summary_row(method, candidates, archive, descriptors),
        "representative_elites": representative_elite_rows(method, elites),
        "descriptor_correlations": descriptor_correlation_rows(
            method,
            candidates,
            descriptors,
        ),
        "archive": archive.to_dict("records"),
        "generation": per_generation.to_dict("records"),
    }


def problem_metric_row(
    method: str,
    problem_id: str,
    candidates: pd.DataFrame,
    repo_root: Path,
) -> dict[str, Any]:
    benchmark, problem = problem_id.split("/", 1)
    ref_metrics = load_reference_ppa(repo_root, benchmark, problem)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    valid = candidates.loc[candidates["valid_ppa"].eq(True)].copy()
    points = ppa_points(valid, ref_metrics, objective_metrics)
    front_indexes = pareto_front([row["point"] for row in points]) if points else []
    front = [points[index] for index in front_indexes]
    best_fitness = finite_max(valid["fitness"].tolist())
    ppa_front_hashes = {
        str(row["canonical_netlist_hash"])
        for row in front
        if row["canonical_netlist_hash"]
    }
    return {
        "method_name": method,
        "problem_id": problem_id,
        "benchmark_source": benchmark,
        "valid_ppa_candidate_count": int(len(valid)),
        "best_fitness": best_fitness,
        "objective_metrics": list(objective_metrics),
        "reference_metrics": {
            metric: ref_metrics[metric]
            for metric in objective_metrics
        },
        "pareto_point_count": len(front),
        "hypervolume": hypervolume([row["point"] for row in front]),
        "reference_beating_count": sum(
            1
            for row in points
            if all(value >= -1e-12 for value in row["point"])
            and any(value > 1e-12 for value in row["point"])
        ),
        "unique_canonical_netlist_count": nunique(valid, "canonical_netlist_hash"),
        "unique_motif_signature_count": nunique(valid, "motif_signature_hash"),
        "duplicate_netlist_count": int(len(valid)) - nunique(valid, "canonical_netlist_hash"),
        "ppa_front_unique_netlist_count": len(ppa_front_hashes),
        "best_improvements": best_improvements(front, objective_metrics),
    }


def robustness_row(method: str, candidates: pd.DataFrame) -> dict[str, Any]:
    total = int(len(candidates))
    assert total > 0
    return {
        "method_name": method,
        "total_candidates": total,
        "syntax_pass": bool_count(candidates, "syntax_pass"),
        "functionality_pass": bool_count(candidates, "functionality_pass"),
        "synthesis_pass": bool_count(candidates, "synthesis_pass"),
        "openroad_pass": bool_count(candidates, "openroad_pass"),
        "valid_ppa": bool_count(candidates, "valid_ppa"),
        "syntax_rate": bool_count(candidates, "syntax_pass") / total,
        "functionality_rate": bool_count(candidates, "functionality_pass") / total,
        "synthesis_rate": bool_count(candidates, "synthesis_pass") / total,
        "openroad_rate": bool_count(candidates, "openroad_pass") / total,
        "valid_ppa_rate": bool_count(candidates, "valid_ppa") / total,
    }


def failure_breakdown_rows(method: str, candidates: pd.DataFrame) -> list[dict[str, Any]]:
    failures = candidates.loc[candidates["valid_ppa"].eq(False)].copy()
    if failures.empty:
        return []
    counts = failures["failure_reason"].fillna("unknown").replace("", "unknown").value_counts()
    return [
        {
            "method_name": method,
            "failure_reason": str(reason),
            "count": int(count),
        }
        for reason, count in counts.items()
    ]


def build_anytime_rows(
    method: str,
    candidates: pd.DataFrame,
    repo_root: Path,
) -> list[dict[str, Any]]:
    generations = sorted(int(value) for value in candidates["generation"].dropna().unique())
    problem_ids = sorted(str(value) for value in candidates["problem_id"].dropna().unique())
    rows = []
    for generation in generations:
        best_values = []
        hv_values = []
        covered = 0
        valid_count = 0
        for problem_id in problem_ids:
            problem_candidates = candidates.loc[
                candidates["problem_id"].eq(problem_id)
                & candidates["generation"].le(generation)
                & candidates["valid_ppa"].eq(True)
            ].copy()
            if problem_candidates.empty:
                continue
            covered += 1
            valid_count += int(len(problem_candidates))
            best = finite_max(problem_candidates["fitness"].tolist())
            if best is not None:
                best_values.append(best)
            benchmark, problem = problem_id.split("/", 1)
            ref_metrics = load_reference_ppa(repo_root, benchmark, problem)
            objective_metrics = objective_metrics_for_reference(ref_metrics)
            points = ppa_points(problem_candidates, ref_metrics, objective_metrics)
            front_indexes = pareto_front([row["point"] for row in points]) if points else []
            hv_values.append(hypervolume([points[index]["point"] for index in front_indexes]))
        rows.append(
            {
                "method_name": method,
                "generation": generation,
                "covered_problems": covered,
                "valid_ppa_candidate_count": valid_count,
                "mean_best_fitness": mean(best_values) if best_values else None,
                "mean_hypervolume": mean(hv_values) if hv_values else None,
            }
        )
    return rows


def anytime_summary_row(method: str, rows: list[dict[str, Any]]) -> dict[str, Any]:
    assert rows, method
    final = rows[-1]
    return {
        "method_name": method,
        "final_generation": final["generation"],
        "final_covered_problems": final["covered_problems"],
        "final_mean_best_fitness": final["mean_best_fitness"],
        "final_mean_hypervolume": final["mean_hypervolume"],
        "auc_mean_best_fitness": mean(row["mean_best_fitness"] for row in rows),
        "auc_mean_hypervolume": mean(row["mean_hypervolume"] for row in rows),
    }


def qd_summary_row(
    method: str,
    candidates: pd.DataFrame,
    archive: pd.DataFrame,
    descriptors: pd.DataFrame,
) -> dict[str, Any]:
    assert not archive.empty, method
    assert not descriptors.empty, method
    archive_types = sorted(str(value) for value in archive["archive_type"].dropna().unique())
    assert archive_types, method
    audit_total = finite_sum(archive["common_audit_total_cells"].tolist())
    assert audit_total is not None and audit_total > 0
    audit_cells = int(finite_sum(archive["common_audit_occupied_cells"].tolist()) or 0.0)
    audit_entropy = cell_entropy(descriptors, "common_audit_cell_id")
    internal_cells = finite_sum(archive["internal_occupied_cells"].tolist())
    internal_entropy = cell_entropy(
        candidates.loc[candidates["valid_ppa"].eq(True)],
        "archive_cell_id",
    )
    return {
        "method_name": method,
        "archive_type": "+".join(archive_types),
        "problem_count": int(archive["problem_id"].nunique()),
        "internal_occupied_cells": none_or_int(internal_cells),
        "internal_qd_score": finite_sum(archive["internal_qd_score"].tolist()),
        "internal_entropy_bits": internal_entropy,
        "internal_entropy_evenness": entropy_evenness(internal_entropy, internal_cells),
        "common_audit_total_cells": int(audit_total),
        "common_audit_occupied_cells": audit_cells,
        "common_audit_coverage": audit_cells / audit_total,
        "common_audit_qd_score": finite_sum(archive["common_audit_qd_score"].tolist()),
        "common_audit_entropy_bits": audit_entropy,
        "common_audit_entropy_normalized": entropy_normalized(audit_entropy, audit_total),
    }


def descriptor_correlation_rows(
    method: str,
    candidates: pd.DataFrame,
    descriptors: pd.DataFrame,
) -> list[dict[str, Any]]:
    rows = []
    for descriptor_space in ("internal", "common_audit"):
        rows.extend(
            descriptor_space_correlation_rows(
                method,
                candidates,
                descriptors,
                descriptor_space,
            )
        )
    return rows


def representative_elite_rows(method: str, elites: pd.DataFrame) -> list[dict[str, Any]]:
    assert not elites.empty, method
    valid = elites.loc[elites["valid_ppa"].eq(True)].copy()
    assert not valid.empty, method
    rows = [representative_elite_row(method, "method_best_fitness", best_row(valid))]
    for problem_id, group in valid.groupby("problem_id", sort=True):
        row = representative_elite_row(
            method,
            "problem_best_fitness",
            best_row(group),
        )
        row["problem_id"] = str(problem_id)
        rows.append(row)
    return rows


def representative_elite_row(
    method: str,
    selection_kind: str,
    row: dict[str, Any],
) -> dict[str, Any]:
    return {
        "method_name": method,
        "selection_kind": selection_kind,
        "problem_id": str(row["problem_id"]),
        "candidate_id": str(row["candidate_id"]),
        "generation": int(row["generation"]),
        "operator_name": str(row["operator_name"]),
        "fitness": finite_float(row["fitness"]),
        "area": finite_float(row["area"]),
        "power": finite_float(row["power"]),
        "timing_or_clock_period": finite_float(row["timing_or_clock_period"]),
        "archive_cell_id": empty_to_none(row["archive_cell_id"]),
        "common_audit_cell_id": empty_to_none(row["common_audit_cell_id"]),
        "canonical_netlist_hash": str(row["canonical_netlist_hash"]),
        "motif_signature_hash": str(row["motif_signature_hash"]),
        "rtl_path": str(row["rtl_path"]),
        "netlist_path": str(row["netlist_path"]),
        "log_path": str(row["log_path"]),
        "descriptor_vector": str(row["descriptor_vector"]),
        "common_audit_descriptor_vector": str(row["common_audit_descriptor_vector"]),
    }


def descriptor_space_correlation_rows(
    method: str,
    candidates: pd.DataFrame,
    descriptors: pd.DataFrame,
    descriptor_space: str,
) -> list[dict[str, Any]]:
    if descriptor_space == "internal":
        axes_column = "descriptor_axes"
        vector_column = "descriptor_vector"
    elif descriptor_space == "common_audit":
        axes_column = "common_audit_axes"
        vector_column = "common_audit_descriptor_vector"
    else:
        raise AssertionError(f"unknown descriptor space: {descriptor_space}")

    valid = candidates.loc[
        candidates["valid_ppa"].eq(True),
        ["problem_id", "candidate_id", *PPA_METRICS],
    ].copy()
    merged = valid.merge(
        descriptors[
            [
                "problem_id",
                "candidate_id",
                axes_column,
                vector_column,
            ]
        ],
        on=["problem_id", "candidate_id"],
        how="inner",
    )
    values: dict[tuple[str, str], dict[str, list[float]]] = {}
    for record in merged.to_dict("records"):
        axes = parse_axes(record[axes_column])
        vector = parse_float_vector(record[vector_column])
        assert len(axes) == len(vector), (method, descriptor_space, record["candidate_id"])
        for axis, axis_value in zip(axes, vector, strict=True):
            for metric in PPA_METRICS:
                metric_value = record[metric]
                if not is_finite(metric_value):
                    continue
                bucket = values.setdefault((axis, metric), {"x": [], "y": []})
                bucket["x"].append(axis_value)
                bucket["y"].append(float(metric_value))

    return [
        {
            "method_name": method,
            "descriptor_space": descriptor_space,
            "descriptor_axis": axis,
            "metric": metric,
            "pearson_r": pearson(bucket["x"], bucket["y"]),
            "sample_count": len(bucket["x"]),
        }
        for (axis, metric), bucket in sorted(values.items())
    ]


def ppa_points(
    candidates: pd.DataFrame,
    ref_metrics: dict[str, float],
    objective_metrics: tuple[str, ...],
) -> list[dict[str, Any]]:
    rows = []
    for row in candidates.to_dict("records"):
        ppa = {
            "area": row.get("area"),
            "power": row.get("power"),
            "eff_clk_period": row.get("timing_or_clock_period"),
        }
        improvements = compute_candidate_improvements(ppa, ref_metrics, objective_metrics)
        if improvements is None:
            continue
        rows.append(
            {
                "point": tuple(improvements[metric] for metric in objective_metrics),
                "canonical_netlist_hash": row.get("canonical_netlist_hash"),
            }
        )
    return rows


def best_improvements(
    front: list[dict[str, Any]],
    objective_metrics: tuple[str, ...],
) -> dict[str, float]:
    if not front:
        return {metric: 0.0 for metric in objective_metrics}
    return {
        metric: max(row["point"][index] for row in front)
        for index, metric in enumerate(objective_metrics)
    }


def gate_row(
    method: str,
    problem_rows: list[dict[str, Any]],
    classic_problems: set[str],
) -> dict[str, Any]:
    method_problems = covered_problems(problem_rows)
    missing = sorted(classic_problems - method_problems)
    extra = sorted(method_problems - classic_problems)
    return {
        "method_name": method,
        "covered_problems": len(method_problems),
        "classic_covered_problems": len(classic_problems),
        "missing_classic_problems": missing,
        "extra_problems": extra,
        "gate0": "PASS" if not missing else "FAIL",
    }


def leaderboard_row(
    method: str,
    payload: dict[str, Any],
    classic_payload: dict[str, Any],
) -> dict[str, Any]:
    problem_rows = payload["problem_metrics"]
    classic_rows = by_problem(classic_payload["problem_metrics"])
    fitness_result = compare_problem_metric(
        problem_rows,
        classic_rows,
        metric_name="best_fitness",
        epsilon=FITNESS_EPSILON,
    )
    hv_result = compare_problem_metric(
        problem_rows,
        classic_rows,
        metric_name="hypervolume",
        epsilon=HV_EPSILON,
    )
    summary = payload["summary"]
    return {
        "method_name": method,
        "problem_count": len(problem_rows),
        "covered_problems": len(covered_problems(problem_rows)),
        "valid_ppa_candidate_count": int(summary["valid_ppa_candidate_count"]),
        "mean_best_fitness": mean(row["best_fitness"] for row in problem_rows),
        "fitness_wins": fitness_result["wins"],
        "fitness_ties": fitness_result["ties"],
        "fitness_losses": fitness_result["losses"],
        "mean_hypervolume": mean(row["hypervolume"] for row in problem_rows),
        "hv_wins": hv_result["wins"],
        "hv_ties": hv_result["ties"],
        "hv_losses": hv_result["losses"],
        "unique_canonical_netlist_count": int(summary["unique_canonical_netlist_count"]),
        "duplicate_netlist_count": sum(int(row["duplicate_netlist_count"]) for row in problem_rows),
        "unique_motif_signature_count": int(summary["unique_motif_signature_count"]),
        "ppa_front_unique_netlist_count": sum(
            int(row["ppa_front_unique_netlist_count"]) for row in problem_rows
        ),
        "common_audit_occupied_cells": int(summary["common_audit_occupied_cells"]),
        "common_audit_qd_score": float(summary["common_audit_qd_score"]),
        "runtime_seconds": runtime_seconds(payload["generation"]),
        "llm_api_calls": llm_api_calls(payload["generation"]),
    }


def per_problem_comparison_rows(per_method: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    classic_rows = by_problem(per_method[REFERENCE_METHOD]["problem_metrics"])
    rows = []
    for method, payload in per_method.items():
        for row in payload["problem_metrics"]:
            classic = classic_rows[row["problem_id"]]
            fitness_delta = float(row["best_fitness"] or 0.0) - float(
                classic["best_fitness"] or 0.0
            )
            hv_delta = float(row["hypervolume"] or 0.0) - float(
                classic["hypervolume"] or 0.0
            )
            rows.append(
                {
                    "method_name": method,
                    "problem_id": row["problem_id"],
                    "fitness_delta": fitness_delta,
                    "fitness_outcome": outcome(fitness_delta, FITNESS_EPSILON),
                    "hypervolume_delta": hv_delta,
                    "hypervolume_outcome": outcome(hv_delta, HV_EPSILON),
                }
            )
    return rows


def compare_problem_metric(
    rows: list[dict[str, Any]],
    classic_rows: dict[str, dict[str, Any]],
    *,
    metric_name: str,
    epsilon: float,
) -> dict[str, int]:
    wins = ties = losses = 0
    for row in rows:
        classic = classic_rows[row["problem_id"]]
        delta = float(row[metric_name] or 0.0) - float(classic[metric_name] or 0.0)
        if delta > epsilon:
            wins += 1
            continue
        if delta < -epsilon:
            losses += 1
            continue
        ties += 1
    return {"wins": wins, "ties": ties, "losses": losses}


def outcome(delta: float, epsilon: float) -> str:
    if delta > epsilon:
        return "W"
    if delta < -epsilon:
        return "L"
    return "T"


def render_markdown(report: dict[str, Any]) -> str:
    rows = [
        "# Auto-BD Centralized Report",
        "",
        f"Phase: `{report['phase']}`",
        "",
        f"Seed: `{report['seed']}`",
        "",
        "Status: generated from standardized result artifacts.",
        "",
        "## Normalization",
        "",
        "- Objective directions: minimize area, power, and effective clock.",
        "- Improvement: `(reference - candidate) / max(abs(reference), 1e-12)`.",
        "- Combinational tasks use area/power; sequential tasks also use effective clock.",
        "- Hypervolume uses normalized improvement space against the zero-improvement reference point.",
        "- Negative objective improvements are clipped to zero inside the hypervolume computation.",
        "- Invalid candidates remain in generated/robustness counts but are excluded from valid-only PPA/HV.",
        "",
        "## Gate Matrix",
        "",
        markdown_table(
            ["Method", "Gate 0", "Covered", "Classic Covered", "Missing Classic"],
            [
                [
                    code(row["method_name"]),
                    row["gate0"],
                    row["covered_problems"],
                    row["classic_covered_problems"],
                    ", ".join(row["missing_classic_problems"]) or "-",
                ]
                for row in report["gate_matrix"]
            ],
        ),
        "",
        "## Leaderboard",
        "",
        markdown_table(
            [
                "Method",
                "Valid PPA",
                "Mean Fitness",
                "Fitness W/T/L",
                "Mean HV",
                "HV W/T/L",
                "Unique Netlists",
                "Dup Netlists",
                "Unique Motifs",
                "PPA-Front Netlists",
                "Audit Cells",
                "Audit QD",
                "Runtime s",
                "LLM Calls",
            ],
            [
                [
                    code(row["method_name"]),
                    row["valid_ppa_candidate_count"],
                    fmt(row["mean_best_fitness"]),
                    f"{row['fitness_wins']}/{row['fitness_ties']}/{row['fitness_losses']}",
                    fmt(row["mean_hypervolume"]),
                    f"{row['hv_wins']}/{row['hv_ties']}/{row['hv_losses']}",
                    row["unique_canonical_netlist_count"],
                    row["duplicate_netlist_count"],
                    row["unique_motif_signature_count"],
                    row["ppa_front_unique_netlist_count"],
                    row["common_audit_occupied_cells"],
                    fmt(row["common_audit_qd_score"]),
                    fmt(row["runtime_seconds"]),
                    row["llm_api_calls"],
                ]
                for row in report["leaderboard"]
            ],
        ),
        "",
        "## QD Archive Metrics",
        "",
        "Coverage and entropy are reported in the fixed common-audit space so methods with different internal BDs remain comparable.",
        "",
        markdown_table(
            [
                "Method",
                "Archive",
                "Internal Cells",
                "Internal QD",
                "Internal Entropy",
                "Audit Cells",
                "Audit Coverage",
                "Audit QD",
                "Audit Entropy",
                "Audit Entropy Norm",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["archive_type"]),
                    row["internal_occupied_cells"] or "-",
                    fmt(row["internal_qd_score"]),
                    fmt(row["internal_entropy_bits"]),
                    row["common_audit_occupied_cells"],
                    fmt(row["common_audit_coverage"]),
                    fmt(row["common_audit_qd_score"]),
                    fmt(row["common_audit_entropy_bits"]),
                    fmt(row["common_audit_entropy_normalized"]),
                ]
                for row in report["qd_summary"]
            ],
        ),
        "",
        "## Descriptor/PPA Correlations",
        "",
        "The JSON report includes Pearson correlations between descriptor axes and PPA/fitness metrics for internal and common-audit descriptor spaces.",
        "",
        "## Representative Elite Examples",
        "",
        "This compact table shows each method's best-fitness representative elite. The JSON report also includes per-problem best-fitness elite rows with RTL, netlist, and log paths.",
        "",
        markdown_table(
            [
                "Method",
                "Problem",
                "Gen",
                "Op",
                "Fitness",
                "Area",
                "Power",
                "Timing",
                "Archive Cell",
                "Audit Cell",
                "RTL",
                "Netlist",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["problem_id"]),
                    row["generation"],
                    code(row["operator_name"]),
                    fmt(row["fitness"]),
                    fmt(row["area"]),
                    fmt(row["power"]),
                    fmt(row["timing_or_clock_period"]),
                    code(row["archive_cell_id"] or "-"),
                    code(row["common_audit_cell_id"] or "-"),
                    short_path(row["rtl_path"]),
                    short_path(row["netlist_path"]),
                ]
                for row in report["representative_elites"]
                if row["selection_kind"] == "method_best_fitness"
            ],
        ),
        "",
        "## Robustness Funnel",
        "",
        markdown_table(
            [
                "Method",
                "Total",
                "Syntax",
                "Functionality",
                "Synthesis",
                "OpenROAD",
                "Valid PPA",
            ],
            [
                [
                    code(row["method_name"]),
                    row["total_candidates"],
                    count_rate(row, "syntax_pass", "syntax_rate"),
                    count_rate(row, "functionality_pass", "functionality_rate"),
                    count_rate(row, "synthesis_pass", "synthesis_rate"),
                    count_rate(row, "openroad_pass", "openroad_rate"),
                    count_rate(row, "valid_ppa", "valid_ppa_rate"),
                ]
                for row in report["robustness_funnel"]
            ],
        ),
        "",
        "## Failure Breakdown",
        "",
        markdown_table(
            ["Method", "Failure Reason", "Count"],
            [
                [
                    code(row["method_name"]),
                    code(row["failure_reason"]),
                    row["count"],
                ]
                for row in report["failure_breakdown"]
            ],
        ),
        "",
        "## Anytime Summary",
        "",
        markdown_table(
            [
                "Method",
                "Final Gen",
                "Final Covered",
                "Final Fitness",
                "Final HV",
                "Fitness AUC",
                "HV AUC",
            ],
            [
                [
                    code(row["method_name"]),
                    row["final_generation"],
                    row["final_covered_problems"],
                    fmt(row["final_mean_best_fitness"]),
                    fmt(row["final_mean_hypervolume"]),
                    fmt(row["auc_mean_best_fitness"]),
                    fmt(row["auc_mean_hypervolume"]),
                ]
                for row in report["anytime_summary"]
            ],
        ),
        "",
        "The JSON report includes per-generation anytime rows for each method.",
        "",
        "## Figures",
        "",
        figure_list(report),
        "",
        "## Per-Problem Win/Loss Matrix",
        "",
        markdown_table(
            [
                "Method",
                "Problem",
                "Fitness Delta",
                "Fitness",
                "HV Delta",
                "HV",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["problem_id"]),
                    fmt(row["fitness_delta"]),
                    row["fitness_outcome"],
                    fmt(row["hypervolume_delta"]),
                    row["hypervolume_outcome"],
                ]
                for row in report["comparison_matrix"]
            ],
        ),
        "",
        "## Per-Problem PPA And Diversity",
        "",
        markdown_table(
            [
                "Method",
                "Problem",
                "Valid PPA",
                "Best Fitness",
                "HV",
                "Pareto Points",
                "Ref-Beating",
                "Unique Netlists",
                "Dup Netlists",
                "PPA-Front Netlists",
                "Objectives",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["problem_id"]),
                    row["valid_ppa_candidate_count"],
                    fmt(row["best_fitness"]),
                    fmt(row["hypervolume"]),
                    row["pareto_point_count"],
                    row["reference_beating_count"],
                    row["unique_canonical_netlist_count"],
                    row["duplicate_netlist_count"],
                    row["ppa_front_unique_netlist_count"],
                    "/".join(row["objective_metrics"]),
                ]
                for row in report["problem_metrics"]
            ],
        ),
        "",
        "## Artifact Roots",
        "",
    ]
    for method, path in report["artifact_roots"].items():
        rows.append(f"- `{method}`: `{path}`")
    rows.append("")
    return "\n".join(rows)


def write_figures(report: dict[str, Any], output_dir: Path) -> dict[str, str]:
    output_dir.mkdir(parents=True, exist_ok=True)
    figures = {
        "anytime_mean_best_fitness": output_dir / "anytime_mean_best_fitness.png",
        "anytime_mean_hypervolume": output_dir / "anytime_mean_hypervolume.png",
        "qd_common_audit_coverage": output_dir / "qd_common_audit_coverage.png",
        "qd_common_audit_entropy": output_dir / "qd_common_audit_entropy.png",
        "qd_common_audit_cells_heatmap": output_dir
        / "qd_common_audit_cells_heatmap.png",
        "descriptor_common_audit_ppa_correlation": output_dir
        / "descriptor_common_audit_ppa_correlation.png",
        "descriptor_internal_ppa_correlation": output_dir
        / "descriptor_internal_ppa_correlation.png",
        "manual_bd_ppa_correlation": output_dir / "manual_bd_ppa_correlation.png",
    }
    plot_anytime(
        report["anytime_metrics"],
        "mean_best_fitness",
        "Mean Best Fitness",
        figures["anytime_mean_best_fitness"],
    )
    plot_anytime(
        report["anytime_metrics"],
        "mean_hypervolume",
        "Mean Hypervolume",
        figures["anytime_mean_hypervolume"],
    )
    plot_qd_bar(
        report["qd_summary"],
        "common_audit_coverage",
        "Common-Audit Coverage",
        figures["qd_common_audit_coverage"],
    )
    plot_qd_bar(
        report["qd_summary"],
        "common_audit_entropy_normalized",
        "Normalized Common-Audit Entropy",
        figures["qd_common_audit_entropy"],
    )
    plot_archive_heatmap(
        report["archive_metrics"],
        "common_audit_occupied_cells",
        "Common-Audit Occupied Cells",
        figures["qd_common_audit_cells_heatmap"],
    )
    plot_descriptor_correlation_heatmap(
        report["descriptor_correlations"],
        "common_audit",
        "Common-Audit Descriptor/PPA Correlation",
        figures["descriptor_common_audit_ppa_correlation"],
    )
    plot_descriptor_correlation_heatmap(
        report["descriptor_correlations"],
        "internal",
        "Internal Descriptor/PPA Correlation",
        figures["descriptor_internal_ppa_correlation"],
    )
    plot_descriptor_correlation_heatmap(
        report["descriptor_correlations"],
        "internal",
        "Manual-BD/PPA Correlation",
        figures["manual_bd_ppa_correlation"],
        method="landing_smooth_qd_manual_bd",
    )
    return {name: path.as_posix() for name, path in figures.items()}


def plot_anytime(
    rows: list[dict[str, Any]],
    metric_name: str,
    ylabel: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    fig, axis = plt.subplots(figsize=(8.0, 4.8))
    for method in METHOD_ORDER:
        method_frame = frame.loc[frame["method_name"].eq(method)].sort_values("generation")
        if method_frame.empty:
            continue
        axis.plot(
            method_frame["generation"],
            method_frame[metric_name],
            marker="o",
            linewidth=1.8,
            label=method,
        )
    axis.set_xlabel("Generation")
    axis.set_ylabel(ylabel)
    axis.grid(True, alpha=0.3)
    axis.legend(fontsize=7, ncols=2)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_qd_bar(
    rows: list[dict[str, Any]],
    metric_name: str,
    ylabel: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    methods = ordered_methods(frame["method_name"].tolist())
    frame = frame.set_index("method_name").loc[methods]
    fig, axis = plt.subplots(figsize=(8.0, 4.8))
    axis.bar(range(len(frame)), frame[metric_name].fillna(0.0))
    axis.set_xticks(range(len(frame)), methods, rotation=35, ha="right")
    axis.set_ylabel(ylabel)
    axis.grid(True, axis="y", alpha=0.3)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_archive_heatmap(
    rows: list[dict[str, Any]],
    metric_name: str,
    title: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    pivot = frame.pivot_table(
        index="method_name",
        columns="problem_id",
        values=metric_name,
        aggfunc="sum",
    ).fillna(0.0)
    methods = ordered_methods(pivot.index.tolist())
    problems = sorted(str(value) for value in pivot.columns)
    pivot = pivot.reindex(index=methods, columns=problems)
    fig, axis = plt.subplots(
        figsize=(max(8.0, len(problems) * 1.25), max(4.8, len(methods) * 0.55))
    )
    image = axis.imshow(pivot.to_numpy(dtype=float), cmap="Blues", aspect="auto")
    axis.set_title(title)
    axis.set_xticks(range(len(problems)), problems, rotation=40, ha="right")
    axis.set_yticks(range(len(methods)), methods)
    for y, method in enumerate(methods):
        for x, problem in enumerate(problems):
            axis.text(x, y, str(int(pivot.loc[method, problem])), ha="center", va="center")
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_descriptor_correlation_heatmap(
    rows: list[dict[str, Any]],
    descriptor_space: str,
    title: str,
    output_path: Path,
    method: str | None = None,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    frame = frame.loc[frame["descriptor_space"].eq(descriptor_space)].copy()
    if method is not None:
        frame = frame.loc[frame["method_name"].eq(method)].copy()
    assert not frame.empty, (descriptor_space, method)
    frame["row_label"] = [
        descriptor_row_label(row, method is None)
        for row in frame.to_dict("records")
    ]
    row_labels = sorted(str(value) for value in frame["row_label"].unique())
    pivot = pd.DataFrame(
        index=pd.Index(row_labels),
        columns=pd.Index(PPA_METRICS),
        dtype=float,
    )
    for row in frame.to_dict("records"):
        pivot.loc[str(row["row_label"]), str(row["metric"])] = row["pearson_r"]
    values = pivot.fillna(0.0)
    fig, axis = plt.subplots(
        figsize=(8.0, max(4.8, len(row_labels) * 0.32))
    )
    image = axis.imshow(values.to_numpy(dtype=float), cmap="coolwarm", vmin=-1, vmax=1)
    axis.set_title(title)
    axis.set_xticks(range(len(PPA_METRICS)), PPA_METRICS, rotation=25, ha="right")
    axis.set_yticks(range(len(row_labels)), row_labels)
    for y, label in enumerate(row_labels):
        for x, metric in enumerate(PPA_METRICS):
            value = pivot.loc[label, metric]
            text = "-" if pd.isna(value) else f"{float(value):.2f}"
            axis.text(x, y, text, ha="center", va="center", fontsize=7)
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def figure_list(report: dict[str, Any]) -> str:
    paths = report.get("figure_paths", {})
    if not isinstance(paths, dict) or not paths:
        return "No figure artifacts generated."
    return "\n".join(f"- `{name}`: `{path}`" for name, path in sorted(paths.items()))


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(lines)


def load_reference_ppa(repo_root: Path, benchmark: str, problem: str) -> dict[str, float]:
    path = repo_root / "data" / "bench" / benchmark / f"{problem}_ppa.txt"
    assert path.is_file(), f"missing reference PPA: {path}"
    lines = path.read_text(encoding="utf-8").splitlines()
    assert len(lines) >= 2, f"invalid reference PPA: {path}"
    values = lines[1].split(",")
    assert len(values) >= 5, f"invalid reference PPA: {path}"
    return {
        "tns": float(values[0]),
        "wns": float(values[1]),
        "eff_clk_period": float(values[2]),
        "power": float(values[3]),
        "area": float(values[4]),
    }


def covered_problems(rows: list[dict[str, Any]]) -> set[str]:
    return {
        str(row["problem_id"])
        for row in rows
        if int(row["valid_ppa_candidate_count"]) > 0
    }


def by_problem(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    return {str(row["problem_id"]): row for row in rows}


def bool_count(frame: pd.DataFrame, column: str) -> int:
    return int(frame[column].eq(True).sum())


def finite_max(values: list[Any]) -> float | None:
    finite = [float(value) for value in values if is_finite(value)]
    if not finite:
        return None
    return max(finite)


def finite_sum(values: list[Any]) -> float | None:
    finite = [float(value) for value in values if is_finite(value)]
    if not finite:
        return None
    return sum(finite)


def mean(values: Any) -> float:
    finite = [float(value) for value in values if is_finite(value)]
    assert finite
    return sum(finite) / len(finite)


def is_finite(value: Any) -> bool:
    if value in ("", None):
        return False
    return math.isfinite(float(value))


def nunique(frame: pd.DataFrame, column: str) -> int:
    return int(frame[column].dropna().nunique())


def none_or_int(value: float | None) -> int | None:
    if value is None:
        return None
    return int(value)


def finite_float(value: Any) -> float | None:
    if not is_finite(value):
        return None
    return float(value)


def empty_to_none(value: Any) -> str | None:
    if value in ("", None):
        return None
    if pd.isna(value):
        return None
    return str(value)


def best_row(frame: pd.DataFrame) -> dict[str, Any]:
    rows = frame.sort_values("fitness", ascending=False, na_position="last")
    assert not rows.empty
    return rows.iloc[0].to_dict()


def cell_entropy(frame: pd.DataFrame, column: str) -> float | None:
    assert "problem_id" in frame.columns
    assert column in frame.columns
    cell_frame = frame.loc[frame[column].notna() & frame[column].ne("")]
    if cell_frame.empty:
        return None
    cells = [
        f"{row['problem_id']}::{row[column]}"
        for row in cell_frame[["problem_id", column]].to_dict("records")
    ]
    counts = pd.Series(cells).value_counts()
    total = float(counts.sum())
    return -sum((count / total) * math.log2(count / total) for count in counts)


def parse_axes(value: Any) -> list[str]:
    axes = json.loads(str(value))
    assert isinstance(axes, list)
    return [str(axis) for axis in axes]


def parse_float_vector(value: Any) -> list[float]:
    vector = json.loads(str(value))
    assert isinstance(vector, list)
    return [float(item) for item in vector]


def pearson(xs: list[float], ys: list[float]) -> float | None:
    assert len(xs) == len(ys)
    if len(xs) < 2:
        return None
    x_mean = sum(xs) / len(xs)
    y_mean = sum(ys) / len(ys)
    numerator = sum((x - x_mean) * (y - y_mean) for x, y in zip(xs, ys, strict=True))
    x_denom = sum((x - x_mean) ** 2 for x in xs)
    y_denom = sum((y - y_mean) ** 2 for y in ys)
    if x_denom == 0.0 or y_denom == 0.0:
        return None
    return numerator / math.sqrt(x_denom * y_denom)


def descriptor_row_label(row: dict[str, Any], include_method: bool) -> str:
    if include_method:
        return f"{row['method_name']}:{row['descriptor_axis']}"
    return str(row["descriptor_axis"])


def entropy_evenness(entropy: float | None, occupied_cells: float | None) -> float | None:
    if entropy is None or occupied_cells is None or occupied_cells <= 1:
        return None
    return entropy / math.log2(occupied_cells)


def entropy_normalized(entropy: float | None, total_cells: float) -> float | None:
    if entropy is None or total_cells <= 1:
        return None
    return entropy / math.log2(total_cells)


def runtime_seconds(rows: list[dict[str, Any]]) -> float:
    return sum(float(row["runtime_seconds"] or 0.0) for row in rows)


def llm_api_calls(rows: list[dict[str, Any]]) -> int:
    return sum(int(row["llm_api_calls"] or 0) for row in rows)


def normalization_payload() -> dict[str, Any]:
    return {
        "objective_directions": {
            "area": "minimize",
            "power": "minimize",
            "eff_clk_period": "minimize",
        },
        "improvement_formula": "(reference - candidate) / max(abs(reference), 1e-12)",
        "hypervolume_reference_point": 0.0,
        "hypervolume_negative_clipping": "clip each objective improvement at 0",
        "combinational_objectives": ["area", "power"],
        "sequential_objectives": ["area", "power", "eff_clk_period"],
        "invalid_candidate_policy": "count for robustness, exclude from valid-only PPA/HV",
        "fitness_win_epsilon": FITNESS_EPSILON,
        "hypervolume_win_epsilon": HV_EPSILON,
    }


def method_sort_key(item: tuple[str, Path]) -> tuple[int, str]:
    method = item[0]
    if method in METHOD_ORDER:
        return (METHOD_ORDER.index(method), method)
    return (len(METHOD_ORDER), method)


def ordered_methods(values: list[Any]) -> list[str]:
    names = sorted({str(value) for value in values})
    return sorted(
        names,
        key=lambda method: (
            METHOD_ORDER.index(method) if method in METHOD_ORDER else len(METHOD_ORDER),
            method,
        ),
    )


def code(value: object) -> str:
    return f"`{value}`"


def count_rate(row: dict[str, Any], count_name: str, rate_name: str) -> str:
    count = int(row[count_name])
    rate = float(row[rate_name])
    return f"{count} ({rate:.1%})"


def fmt(value: object) -> str:
    if value is None:
        return "-"
    assert isinstance(value, int | float | str)
    return f"{float(value):.4f}"


def short_path(value: object) -> str:
    if value in ("", None):
        return "-"
    path = Path(str(value))
    parts = path.parts
    if len(parts) <= 5:
        return code(path.as_posix())
    return code(Path("...", *parts[-5:]).as_posix())


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--output-md", type=Path, required=True)
    parser.add_argument("--output-json", type=Path, required=True)
    parser.add_argument("--figure-dir", type=Path)
    parser.add_argument("--repo-root", type=Path, default=REPO_ROOT)
    parser.add_argument("--phase", default="development_preliminary_seed1")
    parser.add_argument("--seed", type=int, default=1001)
    args = parser.parse_args(argv)

    report = build_report(
        results_root=args.results_root,
        repo_root=args.repo_root,
        phase=args.phase,
        seed=args.seed,
    )
    if args.figure_dir is not None:
        report["figure_paths"] = write_figures(report, args.figure_dir)
    args.output_md.parent.mkdir(parents=True, exist_ok=True)
    args.output_md.write_text(render_markdown(report), encoding="utf-8")
    write_json(args.output_json, report)
    print(f"Auto-BD centralized report -> {args.output_md}")
    print(f"Auto-BD centralized report data -> {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
