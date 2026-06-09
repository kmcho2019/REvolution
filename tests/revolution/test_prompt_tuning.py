from __future__ import annotations

import json
from pathlib import Path

import pytest

from revolution.prompt_tuning import (
    JOURNAL_THOUGHT_ONLY_KEYS,
    _candidate_scalar_score,
    export_prompt_bundle,
    format_prompt_bundle,
    load_prompt_tuning_problems,
    materialize_prompt_profile,
    parse_prompt_bundle,
    score_run_root,
    validate_optimized_against_baselines,
)


PROXY_PROBLEMS = load_prompt_tuning_problems(
    Path("data/configs/gepa_prompt_tuning_proxy_problems.yaml")
)


def _write_profile(root: Path, profile: str) -> dict[str, str]:
    sections = {
        key: f"{key} body\n"
        for key in JOURNAL_THOUGHT_ONLY_KEYS
    }
    for key, content in sections.items():
        path = root / profile / f"{key}.txt"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
    return sections


def _write_problem(
    run_root: Path,
    benchmark: str,
    problem: str,
    *,
    valid_ppa: int = 1,
    average_score: float = 0.4,
    ppa_area: float = 90.0,
    coverage: float = 0.25,
    occupied: int = 2,
    qd_score: float = 1.5,
) -> None:
    problem_root = run_root / benchmark / problem
    thought_root = problem_root / "Gen0" / "g000_thought_0001"
    thought_root.mkdir(parents=True, exist_ok=True)
    details = [
        {
            "id": f"sample_{idx}",
            "score": average_score,
            "ppa_metrics": {"area": ppa_area, "power": 0.9},
        }
        for idx in range(valid_ppa)
    ]
    summary = {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "accumulated_success_rates": {
            "functionality": 0.5,
            "synthesis_ppa": 0.25 if valid_ppa else 0.0,
        },
        "final_population_ppa": {
            "average_score": average_score if valid_ppa else None,
            "best_metrics": {"area": ppa_area, "power": 0.9} if valid_ppa else {},
        },
        "final_population_ppa_details": details,
        "ref_ppa_metric": {"area": 100.0, "power": 1.0},
        "worker_errors": [],
    }
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(summary),
        encoding="utf-8",
    )
    (problem_root / "archive_summary.json").write_text(
        json.dumps(
            {
                "archive_type": "grid_quantile",
                "coverage": coverage,
                "occupied_cells": occupied,
                "qd_score": qd_score,
            }
        ),
        encoding="utf-8",
    )
    (thought_root / "thought_evaluation.json").write_text(
        json.dumps(
            {
                "aggregate_status": "partial_success",
                "code_samples_per_thought": 4,
                "sample_records": [],
            }
        ),
        encoding="utf-8",
    )


def _write_proxy_run(run_root: Path, *, valid_ppa: int = 1) -> None:
    for problem_ref in PROXY_PROBLEMS:
        _write_problem(
            run_root,
            problem_ref.benchmark,
            problem_ref.problem,
            valid_ppa=valid_ppa,
        )


def _subset_config(path: Path, problems: list[tuple[str, str]]) -> None:
    path.write_text(
        "selected_problems:\n"
        + "\n".join(
            f"  - benchmark: {benchmark}\n    problem: {problem}"
            for benchmark, problem in problems
        )
        + "\n",
        encoding="utf-8",
    )


def test_prompt_bundle_round_trip_for_journal_thought_only(tmp_path):
    sections = _write_profile(tmp_path, "journal_thought_only")

    bundle = export_prompt_bundle(tmp_path, "journal_thought_only")
    assert bundle.sections == sections

    materialized = materialize_prompt_profile(
        prompt_root=tmp_path,
        profile="journal_thought_only_gepa",
        bundle_text=bundle.text,
    )
    assert materialized.sections == sections
    assert sorted(
        path.relative_to(tmp_path / "journal_thought_only_gepa").as_posix()
        for path in (tmp_path / "journal_thought_only_gepa").rglob("*.txt")
    ) == sorted(f"{key}.txt" for key in JOURNAL_THOUGHT_ONLY_KEYS)


def test_bundle_parser_rejects_missing_duplicate_and_extra_sections():
    sections = {
        key: f"{key} body\n"
        for key in JOURNAL_THOUGHT_ONLY_KEYS
    }
    missing = dict(sections)
    missing.pop(JOURNAL_THOUGHT_ONLY_KEYS[0])
    with pytest.raises(ValueError, match="Missing prompt sections"):
        parse_prompt_bundle(format_prompt_bundle(missing, missing.keys()), JOURNAL_THOUGHT_ONLY_KEYS)

    duplicate = (
        format_prompt_bundle(sections, JOURNAL_THOUGHT_ONLY_KEYS)
        + "\n===== PROMPT: system/thought_spec =====\ndupe\n===== END PROMPT =====\n"
    )
    with pytest.raises(ValueError, match="Duplicate prompt section"):
        parse_prompt_bundle(duplicate, JOURNAL_THOUGHT_ONLY_KEYS)

    extra = (
        format_prompt_bundle(sections, JOURNAL_THOUGHT_ONLY_KEYS)
        + "\n===== PROMPT: extra/file =====\nextra\n===== END PROMPT =====\n"
    )
    with pytest.raises(ValueError, match="Unexpected prompt section"):
        parse_prompt_bundle(extra, JOURNAL_THOUGHT_ONLY_KEYS)


def test_load_prompt_tuning_problems_accepts_mapping_shape(tmp_path):
    path = tmp_path / "proxy.yaml"
    path.write_text(
        "problems:\n"
        "  - benchmark: RTLLM\n"
        "    problem: Prob045_alu\n",
        encoding="utf-8",
    )

    problems = load_prompt_tuning_problems(path)

    assert problems[0].benchmark == "RTLLM"
    assert problems[0].problem == "Prob045_alu"


def test_scorer_rejects_zero_valid_ppa_problem(tmp_path):
    _write_proxy_run(tmp_path, valid_ppa=0)

    score = score_run_root(tmp_path, PROXY_PROBLEMS)

    assert score.status == "failed"
    assert score.scalar_score == 0.0
    assert any("zero valid PPA" in error for error in score.errors)


def test_candidate_scalar_score_prioritizes_ppa_after_validity_gate():
    high_validity = {
        "functionality_pass_rate": 1.0,
        "synthesis_pass_rate": 1.0,
        "valid_ppa_sample_count": 32,
        "average_score": 0.05,
        "average_ppa_improvement": 0.05,
        "area_improvement": 0.05,
        "power_improvement": 0.05,
        "clock_improvement": 0.0,
        "qd_coverage": 0.0,
        "qd_score": 0.0,
    }
    better_ppa = {
        "functionality_pass_rate": 0.6,
        "synthesis_pass_rate": 0.6,
        "valid_ppa_sample_count": 4,
        "average_score": 0.25,
        "average_ppa_improvement": 0.35,
        "area_improvement": 0.20,
        "power_improvement": 0.50,
        "clock_improvement": 0.0,
        "qd_coverage": 0.0,
        "qd_score": 0.0,
    }

    assert _candidate_scalar_score(better_ppa) > _candidate_scalar_score(high_validity)


def test_validator_enforces_no_regression_and_improvement(tmp_path):
    problems = [(f"Bench{i}", f"Problem{i}") for i in range(13)]
    subset = tmp_path / "subset.yaml"
    _subset_config(subset, problems)
    classic = tmp_path / "classic"
    baseline = tmp_path / "baseline"
    optimized = tmp_path / "optimized"
    for benchmark, problem in problems:
        _write_problem(classic, benchmark, problem, average_score=0.40, coverage=0.30)
        _write_problem(baseline, benchmark, problem, average_score=0.40, coverage=0.30)
        _write_problem(optimized, benchmark, problem, average_score=0.42, coverage=0.31)

    result = validate_optimized_against_baselines(
        classic_root=classic,
        baseline_root=baseline,
        optimized_root=optimized,
        subset_config=subset,
    )
    assert result.passed
    assert result.deltas["average_score_pp"] == pytest.approx(2.0)

    weak = tmp_path / "weak"
    for benchmark, problem in problems:
        _write_problem(weak, benchmark, problem, average_score=0.40, coverage=0.30)
    failed = validate_optimized_against_baselines(
        classic_root=classic,
        baseline_root=baseline,
        optimized_root=weak,
        subset_config=subset,
    )
    assert not failed.passed
    assert any("did not improve" in error for error in failed.errors)
