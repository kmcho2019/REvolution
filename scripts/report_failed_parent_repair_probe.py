#!/usr/bin/env python3
"""Validate and aggregate a frozen H5 probe."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path
from typing import Any, Literal, assert_never

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from revolution.journal_stats import PairedSample, summarize_paired_metric  # noqa: E402
from scripts.report_failed_parent_repair import _completed_stage  # noqa: E402

ARMS = ("classic", "treatment")
REPORT_LABELS = {"classic": "classic", "treatment": "h5"}
MissingPolicy = Literal["forbid", "zero"]
MetricScope = Literal["all", "headline"]
MetricSpec = tuple[str, str, MetricScope]
REPRESENTATIVE_METRICS = (
    "unconditional_valid_ppa_repair_rate",
    "final_hypervolume",
    "hypervolume_auc",
    "rtl_simulation_functionality",
    "verification_complete_valid_ppa",
    "valid_ppa_sample_yield",
    "best_normalized_ppa",
)
FULL_SUITE_METRICS: tuple[MetricSpec, ...] = (
    (
        "unconditional_valid_ppa_repair_rate_all_50",
        "unconditional_valid_ppa_repair_rate",
        "all",
    ),
    ("final_hypervolume", "final_hypervolume", "headline"),
    ("hypervolume_auc", "hypervolume_auc", "headline"),
    ("rtl_simulation_functionality_50", "rtl_simulation_functionality", "all"),
    ("rtl_simulation_functionality_46", "rtl_simulation_functionality", "headline"),
    (
        "verification_complete_valid_ppa",
        "verification_complete_valid_ppa",
        "headline",
    ),
    ("valid_ppa_sample_yield", "valid_ppa_sample_yield", "headline"),
    ("best_normalized_ppa", "best_normalized_ppa", "headline"),
)


def _read_csv(path: Path) -> list[dict[str, str]]:
    assert path.is_file(), path
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def _write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _path(value: str) -> Path:
    path = Path(value)
    return path if path.is_absolute() else REPO_ROOT / path


def _read_run_wall(root: Path) -> float:
    paths = list(root.rglob("*_scheduler_telemetry.json"))
    assert len(paths) == 1, paths
    payload = json.loads(paths[0].read_text(encoding="utf-8"))
    wall = float(payload["run_wall_seconds"])
    assert wall > 0
    return wall


def _read_arm(
    root: Path,
    problems: list[str],
    population_size: int,
    generations: int,
    max_calls: int,
    max_tokens: int,
    max_synthesis: int,
    missing_policy: MissingPolicy,
) -> dict[str, dict[str, Any]]:
    paths = sorted(root.rglob("generation_log.jsonl"))
    paths_by_problem = {path.parent.name: path for path in paths}
    assert len(paths_by_problem) == len(paths)
    assert paths_by_problem.keys() <= set(problems)
    match missing_policy:
        case "forbid":
            assert paths_by_problem.keys() == set(problems)
        case "zero":
            pass
        case _:
            raise AssertionError(f"Unknown missing-unit policy: {missing_policy}")
    rows: dict[str, dict[str, Any]] = {}
    candidate_budget = population_size * (generations + 1)

    for problem in problems:
        if problem not in paths_by_problem:
            rows[problem] = {
                "unit_status": "missing_method_failure",
                "candidate_count": 0,
                "llm_calls": 0,
                "llm_tokens": 0,
                "synthesis_evaluations": 0,
                "rtl_simulation_functionality": 0.0,
                "verification_complete_valid_ppa": 0.0,
                "valid_ppa_sample_count": 0,
                "valid_ppa_sample_yield": 0.0,
                "best_normalized_ppa": None,
                "runtime_seconds": 0.0,
            }
            continue
        path = paths_by_problem[problem]
        records = [json.loads(line) for line in path.read_text().splitlines()]
        assert [record["generation"] for record in records] == list(
            range(generations + 1)
        )
        candidates = [
            candidate
            for record in records
            for candidate in record["generated_candidates"]
        ]
        assert all(len(record["generated_candidates"]) == population_size for record in records)
        assert len(candidates) == candidate_budget
        for candidate in candidates:
            _completed_stage(candidate)

        summary_paths = list(path.parent.glob("*_summary.json"))
        assert len(summary_paths) == 1
        summary = json.loads(summary_paths[0].read_text(encoding="utf-8"))
        assert summary["total_candidates_generated"] == candidate_budget
        calls = summary["total_llm_api_calls"]
        tokens = summary["total_llm_prompt_tokens"] + summary["total_llm_completion_tokens"]
        synthesis = sum(candidate["rtl_simulation_success"] for candidate in candidates)
        assert calls <= max_calls, (problem, calls, max_calls)
        assert tokens <= max_tokens, (problem, tokens, max_tokens)
        assert synthesis <= max_synthesis, (problem, synthesis, max_synthesis)
        best_score = summary["final_population_ppa"]["best_score"]
        assert best_score is None or isinstance(best_score, (int, float))
        valid_ppa_count = sum(candidate["ppa_success"] for candidate in candidates)
        rows[problem] = {
            "unit_status": "complete",
            "candidate_count": len(candidates),
            "llm_calls": calls,
            "llm_tokens": tokens,
            "synthesis_evaluations": synthesis,
            "rtl_simulation_functionality": float(
                any(candidate["rtl_simulation_success"] for candidate in candidates)
            ),
            "verification_complete_valid_ppa": float(valid_ppa_count > 0),
            "valid_ppa_sample_count": valid_ppa_count,
            "valid_ppa_sample_yield": valid_ppa_count / candidate_budget,
            "best_normalized_ppa": (
                float(best_score) if best_score is not None else None
            ),
            "runtime_seconds": float(summary["total_runtime_seconds"]),
        }
    return rows


def _read_seed_package(
    package: Path,
    seed: int,
    problems: list[str],
    headline_problems: list[str],
    missing_treatment: set[str],
) -> tuple[
    dict[tuple[str, str], dict[str, str]],
    dict[tuple[str, str], float],
    dict[tuple[str, str], tuple[float, float]],
]:
    mechanism_summary = json.loads(
        (package / "mechanism/summary.json").read_text(encoding="utf-8")
    )
    assert mechanism_summary["seed"] == seed
    assert mechanism_summary["problems"] == problems
    mechanism_rows = _read_csv(package / "mechanism/mechanism_by_problem.csv")
    mechanism = {(row["arm"], row["problem"]): row for row in mechanism_rows}
    assert set(mechanism) == {(arm, problem) for arm in ARMS for problem in problems}

    pareto_rows = _read_csv(package / "pareto_analysis/backend_problem_metrics.csv")
    pareto = {
        (row["backend"], row["problem"]): float(row["hypervolume"])
        for row in pareto_rows
    }
    expected = {
        (REPORT_LABELS[arm], problem)
        for arm in ARMS
        for problem in headline_problems
    }
    required = expected - {
        (REPORT_LABELS["treatment"], problem)
        for problem in missing_treatment
        if problem in headline_problems
    }
    assert required <= set(pareto) <= expected

    hv_auc_rows = _read_csv(package / "hv_auc.csv")
    hv_auc = {
        (row["backend"], row["problem"]):
        (float(row["hv_final"]), float(row["hv_auc"]))
        for row in hv_auc_rows
    }
    assert set(hv_auc) <= expected
    return mechanism, pareto, hv_auc


def _full_suite_gate(
    seed_metric_rows: list[dict[str, Any]],
    resource_total_rows: list[dict[str, Any]],
    statistics: dict[str, dict[str, Any]],
    seeds: list[int],
    headline_problem_count: int,
    expected_candidates_per_arm: int,
    gates: dict[str, Any],
) -> dict[str, Any]:
    metrics = {(row["seed"], row["metric"]): row for row in seed_metric_rows}
    resources = {(row["seed"], row["arm"]): row for row in resource_total_rows}
    valid_ppa_deficit = -sum(
        metrics[(seed, "verification_complete_valid_ppa")]["mean_delta"]
        * headline_problem_count
        for seed in seeds
    )
    rtl_deficit = -sum(
        metrics[(seed, "rtl_simulation_functionality_46")]["mean_delta"]
        * headline_problem_count
        for seed in seeds
    )
    mean_classic_hv = sum(
        metrics[(seed, "final_hypervolume")]["classic_mean"] for seed in seeds
    ) / len(seeds)
    mean_treatment_hv = sum(
        metrics[(seed, "final_hypervolume")]["treatment_mean"] for seed in seeds
    ) / len(seeds)
    resource_skews = []
    for seed in seeds:
        for name in ("llm_calls", "llm_tokens", "run_wall_seconds"):
            classic = resources[(seed, "classic")][name]
            assert classic > 0
            resource_skews.append(
                abs(resources[(seed, "treatment")][name] - classic) / classic
            )
    candidate_budget_equal = all(
        row["candidate_count"] == expected_candidates_per_arm
        for row in resource_total_rows
    )
    results = {
        "repair_benefit_each_seed": all(
            metrics[(seed, "unconditional_valid_ppa_repair_rate_all_50")]["mean_delta"]
            > 0
            for seed in seeds
        ),
        "final_hv_noninferiority": statistics["final_hypervolume"]["mean_delta"]
        >= gates["final_hv_noninferiority"],
        "hv_auc_noninferiority": statistics["hypervolume_auc"]["mean_delta"]
        >= gates["hv_auc_noninferiority"],
        "valid_ppa_noninferiority": valid_ppa_deficit
        <= gates["maximum_coverage_deficit"],
        "rtl_functionality_noninferiority": rtl_deficit
        <= gates["maximum_coverage_deficit"],
        "candidate_budget_equality": candidate_budget_equal,
        "auxiliary_resource_parity": max(resource_skews)
        <= gates["maximum_auxiliary_resource_relative_skew"],
        "catastrophic_hv": mean_treatment_hv / mean_classic_hv
        < gates["catastrophic_minimum_hv_ratio"],
        "catastrophic_valid_ppa": valid_ppa_deficit
        > gates["catastrophic_maximum_coverage_deficit"],
        "catastrophic_rtl_functionality": rtl_deficit
        > gates["catastrophic_maximum_coverage_deficit"],
        "catastrophic_candidate_budget": not candidate_budget_equal,
    }
    required = (
        "repair_benefit_each_seed",
        "final_hv_noninferiority",
        "hv_auc_noninferiority",
        "valid_ppa_noninferiority",
        "rtl_functionality_noninferiority",
        "candidate_budget_equality",
        "auxiliary_resource_parity",
    )
    catastrophic = (
        "catastrophic_hv",
        "catastrophic_valid_ppa",
        "catastrophic_rtl_functionality",
        "catastrophic_candidate_budget",
    )
    viable = all(results[name] for name in required) and not any(
        results[name] for name in catastrophic
    )
    return {
        "gate_results": results,
        "valid_ppa_coverage_deficit_46": valid_ppa_deficit,
        "rtl_functionality_deficit_46": rtl_deficit,
        "maximum_auxiliary_resource_relative_skew": max(resource_skews),
        "performance_gate": "VIABLE" if viable else "RETIRED",
    }


def generate_report(manifest_path: Path, output_dir: Path) -> dict[str, Any]:
    """Validate all frozen units and emit paired H5 probe statistics."""
    manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    assert manifest["candidate_id"] == "H5"
    stage = manifest["stage"]
    budget = manifest["budget"]
    match stage:
        case "representative_probe":
            problems_payload = yaml.safe_load(
                _path(manifest["benchmarks"]["manifest_path"]).read_text(
                    encoding="utf-8"
                )
            )["selected_problems"]
            headline_problems = [item["problem"] for item in problems_payload]
            metric_specs: list[MetricSpec] = [
                (metric, metric, "all") for metric in REPRESENTATIVE_METRICS
            ]
            metric_aliases = {
                "unconditional_fail_origin_valid_ppa_repairs_per_48_candidates": (
                    "unconditional_valid_ppa_repair_rate"
                )
            }
        case "full_suite_probe":
            problems_payload = yaml.safe_load(
                _path(manifest["benchmarks"]["run_manifest_path"]).read_text(
                    encoding="utf-8"
                )
            )["selected_problems"]
            headline_payload = yaml.safe_load(
                _path(manifest["benchmarks"]["headline_manifest_path"]).read_text(
                    encoding="utf-8"
                )
            )["selected_problems"]
            headline_problems = [item["problem"] for item in headline_payload]
            metric_specs = list(FULL_SUITE_METRICS)
            metric_aliases = {
                "unconditional_fail_origin_valid_ppa_repairs_per_48_candidates_all_50": (
                    "unconditional_valid_ppa_repair_rate_all_50"
                )
            }
        case _:
            raise AssertionError(f"Unknown H5 probe stage: {stage}")
    problems = [item["problem"] for item in problems_payload]
    circuit_types = {item["problem"]: item["circuit_type"] for item in problems_payload}
    assert len(problems) == len(set(problems))
    assert len(headline_problems) == len(set(headline_problems))
    assert set(headline_problems) <= set(problems)
    headline_set = set(headline_problems)
    seeds = manifest["seeds"]["values"]
    assert all(isinstance(seed, int) for seed in seeds)
    raw_root = _path(manifest["artifacts"]["raw_root"])
    package_root = _path(manifest["artifacts"]["report_root"])
    resource_rows: list[dict[str, Any]] = []
    paired_rows: list[dict[str, Any]] = []
    samples = {metric: [] for metric, _, _ in metric_specs}
    pool_trajectory_rows: list[dict[str, Any]] = []
    resource_total_rows: list[dict[str, Any]] = []

    for seed in seeds:
        arm_rows = {
            arm: _read_arm(
                raw_root / f"seed_{seed}" / arm,
                problems,
                budget["population_size"],
                budget["generations"],
                budget["max_llm_calls_per_problem"],
                budget["max_total_tokens_per_problem"],
                budget["max_synthesis_calls_per_problem"],
                (
                    "zero"
                    if stage == "full_suite_probe" and arm == "treatment"
                    else "forbid"
                ),
            )
            for arm in ARMS
        }
        if stage == "full_suite_probe":
            assert all(
                row["runtime_seconds"] <= budget["max_wall_seconds_per_problem"]
                for rows in arm_rows.values()
                for row in rows.values()
            )
        missing_treatment = {
            problem
            for problem, row in arm_rows["treatment"].items()
            if row["unit_status"] == "missing_method_failure"
        }
        mechanism, pareto, hv_auc = _read_seed_package(
            package_root / f"seed_{seed}",
            seed,
            problems,
            headline_problems,
            missing_treatment,
        )

        for arm in ARMS:
            label = REPORT_LABELS[arm]
            for problem in problems:
                row = arm_rows[arm][problem]
                mechanism_row = mechanism[(arm, problem)]
                row["unconditional_valid_ppa_repair_rate"] = float(
                    mechanism_row["unconditional_valid_ppa_repair_rate"]
                )
                row["direct_rtl_repairs"] = int(mechanism_row["direct_rtl_repairs"])
                row["direct_valid_ppa_repairs"] = int(
                    mechanism_row["direct_valid_ppa_repairs"]
                )
                row["fail_parent_requests"] = int(
                    mechanism_row["fail_parent_requests"]
                )
                row["conditional_rtl_simulation_repair_yield"] = float(
                    mechanism_row["conditional_rtl_simulation_repair_yield"]
                )
                row["conditional_valid_ppa_repair_yield"] = float(
                    mechanism_row["conditional_valid_ppa_repair_yield"]
                )
                row["first_direct_valid_ppa_repair_generation"] = (
                    int(mechanism_row["first_direct_valid_ppa_generation"])
                    if mechanism_row["first_direct_valid_ppa_generation"]
                    else None
                )
                row["recovered_design"] = int(mechanism_row["recovered_design"])
                row["initial_fail_pool_size"] = int(
                    mechanism_row["initial_fail_pool_size"]
                )
                row["initial_success_pool_size"] = int(
                    mechanism_row["initial_success_pool_size"]
                )
                row["direct_repair_stage_transitions"] = mechanism_row[
                    "direct_repair_stage_transitions"
                ]
                row["final_hypervolume"] = None
                row["hypervolume_auc"] = None
                if problem in headline_set:
                    key = (label, problem)
                    if key not in pareto:
                        assert arm == "treatment" and problem in missing_treatment
                        row["final_hypervolume"] = 0.0
                    else:
                        row["final_hypervolume"] = pareto[key]
                    hv_final, auc = hv_auc.get((label, problem), (0.0, 0.0))
                    if (label, problem) not in hv_auc:
                        assert row["valid_ppa_sample_count"] == 0
                    assert abs(hv_final - row["final_hypervolume"]) <= 1e-9
                    row["hypervolume_auc"] = auc
                resource_rows.append(
                    {
                        "seed": seed,
                        "problem": problem,
                        "circuit_type": circuit_types[problem],
                        "arm": arm,
                        **row,
                    }
                )

            resource_total_rows.append(
                {
                    "seed": seed,
                    "arm": arm,
                    "candidate_count": sum(
                        arm_rows[arm][problem]["candidate_count"]
                        for problem in problems
                    ),
                    "llm_calls": sum(
                        arm_rows[arm][problem]["llm_calls"] for problem in problems
                    ),
                    "llm_tokens": sum(
                        arm_rows[arm][problem]["llm_tokens"] for problem in problems
                    ),
                    "synthesis_evaluations": sum(
                        arm_rows[arm][problem]["synthesis_evaluations"]
                        for problem in problems
                    ),
                    "summed_problem_runtime_seconds": sum(
                        arm_rows[arm][problem]["runtime_seconds"]
                        for problem in problems
                    ),
                    "run_wall_seconds": (
                        _read_run_wall(raw_root / f"seed_{seed}" / arm)
                        if stage == "full_suite_probe"
                        else None
                    ),
                    "missing_unit_count": sum(
                        arm_rows[arm][problem]["unit_status"]
                        == "missing_method_failure"
                        for problem in problems
                    ),
                }
            )

        pool_paths = sorted(
            (raw_root / f"seed_{seed}" / "treatment").rglob(
                "failed_parent_repair_pool_telemetry.jsonl"
            )
        )
        assert {path.parent.name for path in pool_paths} == (
            set(problems) - missing_treatment
        )
        for path in pool_paths:
            records = [
                json.loads(line)
                for line in path.read_text(encoding="utf-8").splitlines()
            ]
            assert [record["generation"] for record in records] == list(
                range(1, budget["generations"] + 1)
            )
            for record in records:
                pool_trajectory_rows.append(
                    {"seed": seed, "problem": path.parent.name, **record}
                )

        for metric, source, scope in metric_specs:
            match scope:
                case "all":
                    metric_problems = problems
                case "headline":
                    metric_problems = headline_problems
                case _:
                    assert_never(scope)
            for problem in metric_problems:
                unit_id = f"{seed}/RTLLM/{problem}"
                baseline = arm_rows["classic"][problem][source]
                treatment = arm_rows["treatment"][problem][source]
                samples[metric].append(
                    PairedSample(
                        unit_id=unit_id,
                        baseline=baseline,
                        treatment=treatment,
                    )
                )
                paired_rows.append(
                    {
                        "seed": seed,
                        "problem": problem,
                        "metric": metric,
                        "classic": baseline,
                        "treatment": treatment,
                        "delta": (
                            treatment - baseline
                            if baseline is not None and treatment is not None
                            else None
                        ),
                        "status": (
                            "paired"
                            if baseline is not None and treatment is not None
                            else "missing_metric_counted_as_loss"
                        ),
                    }
                )

    assert len(resource_rows) == len(seeds) * len(problems) * len(ARMS)
    expected_pairs = len(seeds) * sum(
        len(problems) if scope == "all" else len(headline_problems)
        for _, _, scope in metric_specs
    )
    assert len(paired_rows) == expected_pairs
    statistics = {}
    metric_floors: dict[str, float] = {}
    for metric, _, _ in metric_specs:
        classic_values = [
            sample.baseline
            for sample in samples[metric]
            if sample.baseline is not None
        ]
        floor = min(classic_values) if metric == "best_normalized_ppa" else 0.0
        metric_floors[metric] = floor
        statistics[metric] = summarize_paired_metric(
            metric,
            samples[metric],
            tie_epsilon=manifest["statistics"]["tie_tolerance"],
            missing_treatment_floor=floor,
            n_resamples=manifest["statistics"]["bootstrap_replicates"],
            seed=manifest["statistics"]["bootstrap_seed"],
        ).as_dict()

    seed_metric_rows: list[dict[str, Any]] = []
    seed_sensitivity_rows: list[dict[str, Any]] = []
    for metric, _, _ in metric_specs:
        for seed in seeds:
            rows = [
                row
                for row in paired_rows
                if row["metric"] == metric and row["seed"] == seed
            ]
            complete_rows = [row for row in rows if row["classic"] is not None]
            baseline = [row["classic"] for row in complete_rows]
            treatment = [
                row["treatment"]
                if row["treatment"] is not None
                else metric_floors[metric]
                for row in complete_rows
            ]
            assert baseline and len(baseline) == len(treatment)
            seed_metric_rows.append(
                {
                    "seed": seed,
                    "metric": metric,
                    "unit_count": len(rows),
                    "classic_mean": sum(baseline) / len(baseline),
                    "treatment_mean": sum(treatment) / len(treatment),
                    "mean_delta": sum(treatment) / len(treatment)
                    - sum(baseline) / len(baseline),
                }
            )
            retained = [
                row
                for row in paired_rows
                if row["metric"] == metric and row["seed"] != seed
            ]
            retained_deltas = [
                (
                    row["treatment"]
                    if row["treatment"] is not None
                    else metric_floors[metric]
                )
                - row["classic"]
                for row in retained
                if row["classic"] is not None
            ]
            assert retained_deltas
            seed_sensitivity_rows.append(
                {
                    "metric": metric,
                    "omitted_seed": seed,
                    "retained_unit_count": len(retained_deltas),
                    "mean_delta": sum(retained_deltas) / len(retained_deltas),
                }
            )

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "resource_by_unit.csv", resource_rows)
    _write_csv(output_dir / "resource_totals.csv", resource_total_rows)
    _write_csv(output_dir / "paired_metrics.csv", paired_rows)
    _write_csv(output_dir / "seed_metrics.csv", seed_metric_rows)
    _write_csv(output_dir / "leave_one_seed_out.csv", seed_sensitivity_rows)
    _write_csv(output_dir / "treatment_pool_trajectory.csv", pool_trajectory_rows)
    summary: dict[str, Any] = {
        "candidate_id": "H5",
        "stage": stage,
        "seeds": seeds,
        "problems": problems,
        "headline_problems": headline_problems,
        "expected_problem_seed_units": len(seeds) * len(problems),
        "expected_headline_problem_seed_units": len(seeds) * len(headline_problems),
        "validated_arm_units": len(resource_rows),
        "statistics": statistics,
        "resource_totals": resource_total_rows,
        "seed_metrics": seed_metric_rows,
        "metric_aliases": metric_aliases,
        "metric_definitions": {
            "unconditional_valid_ppa_repair_rate": (
                "direct fail-origin valid-PPA repairs divided by the fixed "
                "48-candidate problem budget"
            ),
        },
    }
    if stage == "representative_probe":
        summary["performance_gate"] = "not_applicable_at_representative_stage"
        summary["protocol_deviations"] = [
            {
                "metric": "llm_calls_to_first_improvement",
                "severity": "non_gating",
                "disposition": (
                    "not reported because the frozen manifest inherited the generic "
                    "name without defining improvement or call attribution; no post-hoc "
                    "definition is introduced after observing outcomes"
                ),
            }
        ]
    else:
        summary.update(
            _full_suite_gate(
                seed_metric_rows,
                resource_total_rows,
                statistics,
                seeds,
                len(headline_problems),
                len(problems)
                * budget["population_size"]
                * (budget["generations"] + 1),
                manifest["frozen_gates"],
            )
        )
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    lines = [
        f"# H5 {stage.replace('_', ' ').title()} Summary",
        "",
        f"Validated problem-seed units: `{summary['expected_problem_seed_units']}`; "
        f"arm units: `{summary['validated_arm_units']}`.",
        "",
        "| Metric | Mean delta | 95% problem-cluster CI | W/L/T |",
        "| --- | ---: | --- | --- |",
    ]
    for metric, _, _ in metric_specs:
        result = statistics[metric]
        mean = result["mean_delta"]
        low = result["bootstrap_ci_low"]
        high = result["bootstrap_ci_high"]
        lines.append(
            f"| {metric} | {mean if mean is not None else 'n/a'} | "
            f"[{low if low is not None else 'n/a'}, "
            f"{high if high is not None else 'n/a'}] | "
            f"{result['wins']}/{result['losses']}/{result['ties']} |"
        )
    lines.append("")
    if stage == "representative_probe":
        lines.extend(
            [
                "Representative performance is diagnostic and carries no promotion or retirement gate.",
                "",
                "Protocol deviation: `llm_calls_to_first_improvement` had no frozen "
                "definition of improvement or call attribution. It is not reported or "
                "used for a gate; defining it after outcomes would be post-hoc.",
            ]
        )
    else:
        lines.append(f"Frozen full-suite outcome: `{summary['performance_gate']}`.")
    lines.extend(
        [
            "",
            "## Per-Seed Direction",
            "",
            "| Seed | Metric | Classic | H5 | Delta |",
            "| ---: | --- | ---: | ---: | ---: |",
        ]
    )
    for row in seed_metric_rows:
        lines.append(
            f"| {row['seed']} | {row['metric']} | {row['classic_mean']} | "
            f"{row['treatment_mean']} | {row['mean_delta']} |"
        )
    lines.extend(
        [
            "",
            "## Resources",
            "",
            "| Seed | Arm | Candidates | Calls | Tokens | Synthesis | Summed problem runtime (s) | Arm wall (s) | Missing |",
            "| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in resource_total_rows:
        lines.append(
            f"| {row['seed']} | {row['arm']} | {row['candidate_count']} | "
            f"{row['llm_calls']} | {row['llm_tokens']} | "
            f"{row['synthesis_evaluations']} | "
            f"{row['summed_problem_runtime_seconds']} | "
            f"{row['run_wall_seconds']} | {row['missing_unit_count']} |"
        )
    lines.append("")
    (output_dir / "summary.md").write_text("\n".join(lines), encoding="utf-8")
    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)
    generate_report(args.manifest.resolve(), args.output_dir.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
