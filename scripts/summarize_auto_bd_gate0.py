#!/usr/bin/env python3
"""Summarize Auto-BD Gate 0 valid-PPA coverage for one run."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[1]
SCAFFOLD_DIR = (
    REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260618_232234_KST_auto_bd_research"
)
DEFAULT_RUN_DIR = (
    REPO_ROOT
    / "exp"
    / "auto_bd_research"
    / "development_preliminary_seed1"
    / "classic_revolution"
    / "seed_1001"
    / "revolution"
    / "openai_gpt-oss-120b"
)
DEFAULT_OUTPUT = SCAFFOLD_DIR / "auto_bd_gate0_coverage_seed1.json"


@dataclass(frozen=True)
class Gate0Inputs:
    """Inputs for one Gate 0 coverage summary."""

    run_dir: Path
    method_name: str
    phase: str
    seed: int


def build_summary(inputs: Gate0Inputs) -> dict[str, Any]:
    """Build a valid-PPA coverage summary from run artifacts."""

    assert inputs.run_dir.is_dir(), f"missing run directory: {inputs.run_dir}"
    statuses = load_summary_statuses(inputs.run_dir)
    problems = []
    for summary_path in sorted(inputs.run_dir.glob("*/*/*_summary.json")):
        if summary_path.name != f"{summary_path.parent.name}_summary.json":
            continue
        problem_dir = summary_path.parent
        benchmark = problem_dir.parent.name
        problem = problem_dir.name
        problem_id = f"{benchmark}/{problem}"
        summary = load_json_mapping(summary_path)
        ppa_paths = sorted(problem_dir.rglob("code_synthesis_report.ppa"))
        metrics_paths = sorted(problem_dir.rglob("code_synthesis_report.metrics.json"))
        status = statuses[problem]
        best_ppa = mapping_at(summary, "final_population_ppa")
        problems.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "problem_id": problem_id,
                "summary_status": status["summary_status"],
                "valid_ppa": len(ppa_paths) > 0,
                "ppa_artifact_count": len(ppa_paths),
                "metrics_artifact_count": len(metrics_paths),
                "total_candidates_generated": summary["total_candidates_generated"],
                "total_generations": summary["total_generations"],
                "best_score": best_ppa["best_score"],
                "best_code_path": status["best_code_path"],
                "problem_summary_path": rel(summary_path),
            }
        )

    assert problems, f"no problem summaries found in: {inputs.run_dir}"
    covered = [item["problem_id"] for item in problems if item["valid_ppa"]]
    missing = [item["problem_id"] for item in problems if not item["valid_ppa"]]
    return {
        "version": 1,
        "method_name": inputs.method_name,
        "phase": inputs.phase,
        "seed": inputs.seed,
        "run_dir": rel(inputs.run_dir),
        "problem_count": len(problems),
        "covered_problem_count": len(covered),
        "missing_problem_count": len(missing),
        "coverage_problem_set": covered,
        "coverage_problem_seed_set": [
            f"{problem_id}#seed={inputs.seed}" for problem_id in covered
        ],
        "missing_problem_set": missing,
        "problems": problems,
    }


def load_summary_statuses(run_dir: Path) -> dict[str, dict[str, str]]:
    """Load top-level summary result statuses by problem name."""

    statuses: dict[str, dict[str, str]] = {}
    for path in sorted(run_dir.glob("*_summary_results.txt")):
        for line in path.read_text(encoding="utf-8").splitlines():
            if not line:
                continue
            parts = line.split(",", 4)
            assert len(parts) == 5, f"bad summary line in {path}: {line}"
            problem, status, best_code_path, _, _score = parts
            statuses[problem] = {
                "summary_status": status,
                "best_code_path": rel(Path(best_code_path)),
            }
    assert statuses, f"no summary result statuses found in: {run_dir}"
    return statuses


def load_json_mapping(path: Path) -> dict[str, Any]:
    """Load a required JSON mapping."""

    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict), f"JSON root must be a mapping: {path}"
    return payload


def mapping_at(payload: dict[str, Any], key: str) -> dict[str, Any]:
    value = payload[key]
    assert isinstance(value, dict), f"{key} must be a mapping"
    return value


def rel(path: Path) -> str:
    if path.is_absolute() and path.is_relative_to(REPO_ROOT):
        return path.relative_to(REPO_ROOT).as_posix()
    return path.as_posix()


def write_summary(summary: dict[str, Any], output: Path) -> None:
    """Write the Gate 0 summary artifact."""

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-dir", type=Path, default=DEFAULT_RUN_DIR)
    parser.add_argument("--method-name", type=str, default="classic_revolution")
    parser.add_argument("--phase", type=str, default="development_preliminary_seed1")
    parser.add_argument("--seed", type=int, default=1001)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args(argv)

    summary = build_summary(
        Gate0Inputs(
            run_dir=args.run_dir,
            method_name=args.method_name,
            phase=args.phase,
            seed=args.seed,
        )
    )
    write_summary(summary, args.output)
    print(f"Auto-BD Gate 0 coverage -> {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
