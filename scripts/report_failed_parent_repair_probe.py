#!/usr/bin/env python3
"""Validate and aggregate a frozen H5 representative probe."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path
from typing import Any

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from revolution.journal_stats import PairedSample, summarize_paired_metric  # noqa: E402
from scripts.report_failed_parent_repair import _completed_stage  # noqa: E402

ARMS = ("classic", "treatment")
REPORT_LABELS = {"classic": "classic", "treatment": "h5"}
METRICS = (
    "unconditional_valid_ppa_repair_rate",
    "final_hypervolume",
    "hypervolume_auc",
    "rtl_simulation_functionality",
    "verification_complete_valid_ppa",
    "valid_ppa_sample_yield",
    "best_normalized_ppa",
)


def _read_csv(path: Path) -> list[dict[str, str]]:
    assert path.is_file(), path
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def _write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def _path(value: str) -> Path:
    path = Path(value)
    return path if path.is_absolute() else REPO_ROOT / path


def _read_arm(
    root: Path,
    problems: list[str],
    population_size: int,
    generations: int,
    max_calls: int,
    max_tokens: int,
    max_synthesis: int,
) -> dict[str, dict[str, Any]]:
    paths = sorted(root.rglob("generation_log.jsonl"))
    assert {path.parent.name for path in paths} == set(problems)
    assert len(paths) == len(problems)
    rows: dict[str, dict[str, Any]] = {}
    candidate_budget = population_size * (generations + 1)

    for path in paths:
        problem = path.parent.name
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
        }
    return rows


def _read_seed_package(
    package: Path,
    seed: int,
    problems: list[str],
) -> tuple[dict[tuple[str, str], dict[str, str]], dict[tuple[str, str], float], dict[tuple[str, str], tuple[float, float]]]:
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
        (REPORT_LABELS[arm], problem) for arm in ARMS for problem in problems
    }
    assert set(pareto) == expected

    hv_auc_rows = _read_csv(package / "hv_auc.csv")
    hv_auc = {
        (row["backend"], row["problem"]):
        (float(row["hv_final"]), float(row["hv_auc"]))
        for row in hv_auc_rows
    }
    assert set(hv_auc) <= expected
    return mechanism, pareto, hv_auc


def generate_report(manifest_path: Path, output_dir: Path) -> dict[str, Any]:
    """Validate all frozen units and emit paired H5 probe statistics."""
    manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    assert manifest["candidate_id"] == "H5"
    assert manifest["stage"] == "representative_probe"
    budget = manifest["budget"]
    problems_payload = yaml.safe_load(
        _path(manifest["benchmarks"]["manifest_path"]).read_text(encoding="utf-8")
    )["selected_problems"]
    problems = [item["problem"] for item in problems_payload]
    circuit_types = {item["problem"]: item["circuit_type"] for item in problems_payload}
    assert len(problems) == len(set(problems))
    seeds = manifest["seeds"]["values"]
    assert all(isinstance(seed, int) for seed in seeds)
    raw_root = _path(manifest["artifacts"]["raw_root"])
    package_root = _path(manifest["artifacts"]["report_root"])
    resource_rows: list[dict[str, Any]] = []
    paired_rows: list[dict[str, Any]] = []
    samples = {metric: [] for metric in METRICS}

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
            )
            for arm in ARMS
        }
        mechanism, pareto, hv_auc = _read_seed_package(
            package_root / f"seed_{seed}", seed, problems
        )

        for arm in ARMS:
            label = REPORT_LABELS[arm]
            for problem in problems:
                row = arm_rows[arm][problem]
                mechanism_row = mechanism[(arm, problem)]
                row["unconditional_valid_ppa_repair_rate"] = float(
                    mechanism_row["unconditional_valid_ppa_repair_rate"]
                )
                row["direct_valid_ppa_repairs"] = int(
                    mechanism_row["direct_valid_ppa_repairs"]
                )
                row["fail_parent_requests"] = int(
                    mechanism_row["fail_parent_requests"]
                )
                row["final_hypervolume"] = pareto[(label, problem)]
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

        for problem in problems:
            unit_id = f"{seed}/RTLLM/{problem}"
            for metric in METRICS:
                baseline = arm_rows["classic"][problem][metric]
                treatment = arm_rows["treatment"][problem][metric]
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
    assert len(paired_rows) == len(seeds) * len(problems) * len(METRICS)
    statistics = {}
    for metric in METRICS:
        classic_values = [
            sample.baseline
            for sample in samples[metric]
            if sample.baseline is not None
        ]
        floor = min(classic_values) if metric == "best_normalized_ppa" else 0.0
        statistics[metric] = summarize_paired_metric(
            metric,
            samples[metric],
            tie_epsilon=manifest["statistics"]["tie_tolerance"],
            missing_treatment_floor=floor,
            n_resamples=manifest["statistics"]["bootstrap_replicates"],
            seed=manifest["statistics"]["bootstrap_seed"],
        ).as_dict()

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "resource_by_unit.csv", resource_rows)
    _write_csv(output_dir / "paired_metrics.csv", paired_rows)
    summary = {
        "candidate_id": "H5",
        "stage": "representative_probe",
        "seeds": seeds,
        "problems": problems,
        "expected_problem_seed_units": len(seeds) * len(problems),
        "validated_arm_units": len(resource_rows),
        "statistics": statistics,
        "performance_gate": "not_applicable_at_representative_stage",
    }
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    lines = [
        "# H5 Representative Probe Summary",
        "",
        f"Validated problem-seed units: `{summary['expected_problem_seed_units']}`; "
        f"arm units: `{summary['validated_arm_units']}`.",
        "",
        "| Metric | Mean delta | 95% problem-cluster CI | W/L/T |",
        "| --- | ---: | --- | --- |",
    ]
    for metric in METRICS:
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
    lines.extend(
        [
            "",
            "Representative performance is diagnostic and carries no promotion or retirement gate.",
            "",
        ]
    )
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
