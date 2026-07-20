#!/usr/bin/env python3
"""Validate and report H5 failed-parent repair evidence."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

import yaml


FAIL_OPERATORS = {"M-F", "M-S", "M-E", "M-R", "M-I"}
SUCCESS_OPERATORS = {"M-S", "M-E", "M-R", "M-I", "C-F"}
PROGRAM_MANIFEST = (
    Path(__file__).resolve().parents[1]
    / "docs/journal_features/revamp_history"
    / "20260720_191404_KST_tcad_revolution_extension/shared/program_manifest.yaml"
)
REQUIRED_CANDIDATE_FIELDS = {
    "id",
    "parent_ids",
    "origin_pool",
    "strategy",
    "status",
    "rtl_simulation_success",
    "synthesis_success",
    "post_synthesis_functionality_success",
    "ppa_success",
    "code_file_path",
    "generated_mode",
}


def _completed_stage(candidate: dict[str, Any]) -> str:
    assert REQUIRED_CANDIDATE_FIELDS <= candidate.keys()
    rtl = candidate["rtl_simulation_success"]
    synthesis = candidate["synthesis_success"]
    post_synthesis = candidate["post_synthesis_functionality_success"]
    ppa = candidate["ppa_success"]
    assert all(
        isinstance(value, bool) for value in (rtl, synthesis, post_synthesis, ppa)
    )

    match candidate["status"]:
        case "failed_format" | "failed_diff":
            assert not rtl and not synthesis and not post_synthesis and not ppa
            return "generation_format"
        case "failed_syntax":
            assert not rtl and not synthesis and not post_synthesis and not ppa
            return "format"
        case "failed_functionality":
            assert not rtl and not synthesis and not post_synthesis and not ppa
            return "syntax"
        case "failed_synthesis" if not synthesis:
            assert rtl and not post_synthesis and not ppa
            return "rtl_simulation"
        case "failed_synthesis" if synthesis:
            assert rtl and post_synthesis and not ppa
            return "post_synthesis_functionality"
        case "failed_synthesis_functionality":
            assert rtl and synthesis and not post_synthesis and not ppa
            return "synthesis"
        case "success":
            assert rtl and synthesis and post_synthesis and ppa
            return "valid_ppa"
        case _:
            raise AssertionError(f"Unknown candidate state: {candidate}")


def _write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def _read_run_config(root: Path) -> tuple[dict[str, Any], Path]:
    paths = sorted(root.rglob("*_revolution_config.yaml"))
    assert len(paths) == 1, paths
    config = yaml.safe_load(paths[0].read_text(encoding="utf-8"))
    assert isinstance(config, dict)
    return config, paths[0]


def _validate_pair_configs(
    classic_root: Path,
    treatment_root: Path,
    seed: int,
    problems: list[str],
    population_size: int,
    generations: int,
) -> dict[str, str]:
    classic, classic_path = _read_run_config(classic_root)
    treatment, treatment_path = _read_run_config(treatment_root)
    assert classic.pop("search_mode") == "revolution"
    assert treatment.pop("search_mode") == "revolution_failed_parent_repair"
    classic.pop("save_path")
    treatment.pop("save_path")
    assert classic == treatment
    program = yaml.safe_load(PROGRAM_MANIFEST.read_text(encoding="utf-8"))
    assert isinstance(program, dict)
    endpoint = urlparse(program["model"]["endpoint"])
    expected = {
        "backend": "revolution",
        "benchmarks": ["RTLLM"],
        "api_backend": program["model"]["provider"],
        "vllm_host": endpoint.hostname,
        "vllm_port": endpoint.port,
        "vllm_min_model_len": 128000,
        "model_name": program["model"]["name"],
        "temperature": program["method"]["temperature"],
        "top_p": program["method"]["top_p"],
        "max_tokens": program["method"]["max_tokens_per_call"],
        "diff_max_tokens": program["method"]["diff_max_tokens_per_call"],
        "evaluation_mode": "strict_ablation",
        "generation_mode": "whole",
        "population_pool_mode": "dual",
        "classic_operator_kind": "eoh_strategies",
        "eoh_success_operator_set": "classic",
        "strategy_selection": "ucb",
        "representation_kind": "code_individual",
        "repair_kind": "none",
        "prompt_profile": "default",
        "prompt_root": None,
        "max_llm_calls_per_problem": program["budgets"]["per_problem"]["llm_calls"],
        "seed": seed,
        "problems": problems,
        "population_size": population_size,
        "num_generations": generations,
    }
    assert all(classic[key] == value for key, value in expected.items())
    return {
        "classic_config_sha256": hashlib.sha256(classic_path.read_bytes()).hexdigest(),
        "treatment_config_sha256": hashlib.sha256(
            treatment_path.read_bytes()
        ).hexdigest(),
    }


def _read_arm(
    label: str,
    root: Path,
    problems: list[str],
    population_size: int,
    generations: int,
) -> list[dict[str, Any]]:
    paths = sorted(root.rglob("generation_log.jsonl"))
    assert {path.parent.name for path in paths} == set(problems)
    assert len(paths) == len(problems)
    rows: list[dict[str, Any]] = []

    for path in paths:
        problem = path.parent.name
        records = [
            json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()
        ]
        assert [record["generation"] for record in records] == list(
            range(generations + 1)
        )
        candidates: list[tuple[int, dict[str, Any]]] = []
        seen: dict[str, dict[str, Any]] = {}
        for record in records:
            generation = record["generation"]
            generated = record["generated_candidates"]
            assert isinstance(generated, list) and len(generated) == population_size
            generation_ids: set[str] = set()
            if generation > 0:
                probabilities = record["average_strategy_probabilities"]
                expected_fail = {"M-F"} if label == "treatment" else FAIL_OPERATORS
                assert set(probabilities["fail_pool"]) == expected_fail
                assert set(probabilities["success_pool"]) == SUCCESS_OPERATORS
            for candidate in generated:
                assert isinstance(candidate, dict)
                assert REQUIRED_CANDIDATE_FIELDS <= candidate.keys()
                assert isinstance(candidate["id"], str) and candidate["id"]
                assert candidate["id"] not in seen.keys() | generation_ids
                assert isinstance(candidate["parent_ids"], list)
                assert all(
                    isinstance(parent, str) and parent
                    for parent in candidate["parent_ids"]
                )
                assert (
                    isinstance(candidate["code_file_path"], str)
                    and candidate["code_file_path"]
                )
                assert candidate["generated_mode"] == "whole"
                if generation == 0:
                    assert candidate["origin_pool"] == "initial"
                    assert candidate["strategy"] == "initial"
                    assert candidate["parent_ids"] == []
                else:
                    assert candidate["origin_pool"] in {"fail_pool", "success_pool"}
                    assert candidate["parent_ids"]
                    assert set(candidate["parent_ids"]) <= seen.keys()
                    if candidate["origin_pool"] == "fail_pool":
                        expected = {"M-F"} if label == "treatment" else FAIL_OPERATORS
                        assert candidate["strategy"] in expected
                        assert len(candidate["parent_ids"]) == 1
                        assert seen[candidate["parent_ids"][0]]["status"] != "success"
                    else:
                        assert candidate["strategy"] in SUCCESS_OPERATORS
                        expected_parents = 2 if candidate["strategy"] == "C-F" else 1
                        assert len(candidate["parent_ids"]) == expected_parents
                        assert len(set(candidate["parent_ids"])) == expected_parents
                        assert all(
                            seen[parent_id]["status"] == "success"
                            and seen[parent_id]["ppa_success"]
                            for parent_id in candidate["parent_ids"]
                        )
                _completed_stage(candidate)
                candidates.append((generation, candidate))
                generation_ids.add(candidate["id"])
            seen.update({candidate["id"]: candidate for candidate in generated})

        assert len(candidates) == population_size * (generations + 1)
        initial_candidates = [
            candidate for generation, candidate in candidates if generation == 0
        ]
        fail_candidates = [
            (generation, candidate)
            for generation, candidate in candidates
            if candidate["origin_pool"] == "fail_pool"
        ]
        rtl_repairs = sum(
            candidate["rtl_simulation_success"] for _, candidate in fail_candidates
        )
        ppa_repairs = sum(candidate["ppa_success"] for _, candidate in fail_candidates)
        transitions = Counter(
            f"{_completed_stage(seen[candidate['parent_ids'][0]])}->{_completed_stage(candidate)}"
            for _, candidate in fail_candidates
        )
        first_ppa = min(
            (
                generation
                for generation, candidate in fail_candidates
                if candidate["ppa_success"]
            ),
            default=None,
        )
        rows.append(
            {
                "arm": label,
                "problem": problem,
                "candidate_count": len(candidates),
                "initial_fail_pool_size": sum(
                    candidate["status"] != "success" for candidate in initial_candidates
                ),
                "initial_success_pool_size": sum(
                    candidate["status"] == "success" for candidate in initial_candidates
                ),
                "fail_parent_requests": len(fail_candidates),
                "direct_rtl_repairs": rtl_repairs,
                "direct_valid_ppa_repairs": ppa_repairs,
                "unconditional_valid_ppa_repair_rate": ppa_repairs / len(candidates),
                "conditional_rtl_simulation_repair_yield": (
                    rtl_repairs / len(fail_candidates) if fail_candidates else 0.0
                ),
                "conditional_valid_ppa_repair_yield": (
                    ppa_repairs / len(fail_candidates) if fail_candidates else 0.0
                ),
                "first_direct_valid_ppa_generation": first_ppa,
                "recovered_design": int(
                    not any(
                        candidate["status"] == "success"
                        for candidate in initial_candidates
                    )
                    and ppa_repairs > 0
                ),
                "direct_repair_stage_transitions": json.dumps(
                    dict(sorted(transitions.items())), separators=(",", ":")
                ),
            }
        )
    return rows


def _validate_pool_telemetry(
    treatment_root: Path,
    treatment_rows: list[dict[str, Any]],
    population_size: int,
    generations: int,
) -> None:
    problem_rows = {row["problem"]: row for row in treatment_rows}
    paths = sorted(treatment_root.rglob("failed_parent_repair_pool_telemetry.jsonl"))
    assert {path.parent.name for path in paths} == set(problem_rows)
    for path in paths:
        generation_records = {
            record["generation"]: record
            for record in (
                json.loads(line)
                for line in (path.parent / "generation_log.jsonl")
                .read_text(encoding="utf-8")
                .splitlines()
            )
        }
        records = [
            json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()
        ]
        assert [record["generation"] for record in records] == list(
            range(1, generations + 1)
        )
        previous_post: tuple[int, int] | None = None
        for record in records:
            pre = (
                record["pre_selection_fail_pool_size"],
                record["pre_selection_success_pool_size"],
            )
            post = (
                record["post_selection_fail_pool_size"],
                record["post_selection_success_pool_size"],
            )
            assert all(isinstance(value, int) and value >= 0 for value in (*pre, *post))
            if previous_post is None:
                problem = problem_rows[path.parent.name]
                assert pre == (
                    problem["initial_fail_pool_size"],
                    problem["initial_success_pool_size"],
                )
            else:
                assert pre == previous_post
            match record["generation_outcome"]:
                case "completed":
                    generated_successes = sum(
                        candidate["status"] == "success"
                        for candidate in generation_records[record["generation"]][
                            "generated_candidates"
                        ]
                    )
                    expected_successes = min(
                        population_size, pre[1] + generated_successes
                    )
                    assert post == (
                        population_size - expected_successes,
                        expected_successes,
                    )
                case "stop":
                    assert post == pre
                case outcome:
                    raise AssertionError(f"Unknown generation outcome: {outcome}")
            previous_post = post
        assert all(record["generation_outcome"] == "completed" for record in records)


def generate_report(
    classic_root: Path,
    treatment_root: Path,
    output_dir: Path,
    seed: int,
    problems: list[str],
    population_size: int,
    generations: int,
) -> dict[str, Any]:
    """Generate a strict paired mechanism report for one H5 seed."""
    assert seed >= 0 and problems and len(problems) == len(set(problems))
    assert population_size > 0 and generations > 0
    config_hashes = _validate_pair_configs(
        classic_root,
        treatment_root,
        seed,
        problems,
        population_size,
        generations,
    )
    classic = _read_arm("classic", classic_root, problems, population_size, generations)
    treatment = _read_arm(
        "treatment", treatment_root, problems, population_size, generations
    )
    _validate_pool_telemetry(treatment_root, treatment, population_size, generations)
    classic_by_problem = {row["problem"]: row for row in classic}
    treatment_by_problem = {row["problem"]: row for row in treatment}
    assert classic_by_problem.keys() == treatment_by_problem.keys()
    paired = []
    for problem in sorted(classic_by_problem):
        control = classic_by_problem[problem]
        candidate = treatment_by_problem[problem]
        paired.append(
            {
                "seed": seed,
                "problem": problem,
                "classic_direct_valid_ppa_repairs": control["direct_valid_ppa_repairs"],
                "treatment_direct_valid_ppa_repairs": candidate[
                    "direct_valid_ppa_repairs"
                ],
                "direct_valid_ppa_repair_delta": candidate["direct_valid_ppa_repairs"]
                - control["direct_valid_ppa_repairs"],
                "classic_unconditional_valid_ppa_repair_rate": control[
                    "unconditional_valid_ppa_repair_rate"
                ],
                "treatment_unconditional_valid_ppa_repair_rate": candidate[
                    "unconditional_valid_ppa_repair_rate"
                ],
                "unconditional_valid_ppa_repair_rate_delta": candidate[
                    "unconditional_valid_ppa_repair_rate"
                ]
                - control["unconditional_valid_ppa_repair_rate"],
                "classic_fail_parent_requests": control["fail_parent_requests"],
                "treatment_fail_parent_requests": candidate["fail_parent_requests"],
            }
        )

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "mechanism_by_problem.csv", classic + treatment)
    _write_csv(output_dir / "paired_repair_delta.csv", paired)
    summary = {
        "seed": seed,
        "problems": problems,
        "population_size": population_size,
        "generations": generations,
        "candidate_budget_per_problem": population_size * (generations + 1),
        "classic_direct_valid_ppa_repairs": sum(
            row["direct_valid_ppa_repairs"] for row in classic
        ),
        "treatment_direct_valid_ppa_repairs": sum(
            row["direct_valid_ppa_repairs"] for row in treatment
        ),
        "mean_paired_unconditional_valid_ppa_repair_rate_delta": sum(
            row["unconditional_valid_ppa_repair_rate_delta"] for row in paired
        )
        / len(paired),
        "classic_root": str(classic_root),
        "treatment_root": str(treatment_root),
        **config_hashes,
    }
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", type=Path, required=True)
    parser.add_argument("--treatment-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--seed", type=int, required=True)
    parser.add_argument("--problems", nargs="+", required=True)
    parser.add_argument("--population-size", type=int, required=True)
    parser.add_argument("--generations", type=int, required=True)
    args = parser.parse_args(argv)
    generate_report(
        args.classic_root.resolve(),
        args.treatment_root.resolve(),
        args.output_dir.resolve(),
        args.seed,
        args.problems,
        args.population_size,
        args.generations,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
