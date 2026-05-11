#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import importlib
import json
from pathlib import Path
from typing import Any


SOURCE_LABELS = {"archive", "fail_pool", "seed"}


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def _load_yaml(path: Path) -> dict[str, Any]:
    yaml = importlib.import_module("yaml")
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _expected_problems(path: Path) -> list[dict[str, str]]:
    config = _load_yaml(path)
    return [
        {"benchmark": str(item["benchmark"]), "problem": str(item["problem"])}
        for item in config["selected_problems"]
    ]


def _csv_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _problem_root(run_root: Path, mode: str, benchmark: str, problem: str) -> Path | None:
    direct = run_root / mode / benchmark / problem
    for summary_name in ("archive_summary.json", f"{problem}_summary.json"):
        if (direct / summary_name).is_file():
            return direct
        matches = sorted((run_root / mode).rglob(f"{benchmark}/{problem}/{summary_name}"))
        if matches:
            return matches[-1].parent
        matches = sorted((run_root / mode).rglob(f"{problem}/{summary_name}"))
        if matches:
            return matches[-1].parent
    return None


def _mode_missing_problems(
    *,
    run_root: Path,
    mode: str,
    expected: list[dict[str, str]],
) -> list[str]:
    return [
        f"{item['benchmark']}/{item['problem']}"
        for item in expected
        if _problem_root(run_root, mode, item["benchmark"], item["problem"]) is None
    ]


def _check_source_counts(
    *,
    errors: list[str],
    row_label: str,
    payload: dict[str, Any],
    field: str,
    total_field: str,
) -> None:
    counts = payload.get(field)
    if counts in (None, {}):
        return
    if not isinstance(counts, dict):
        errors.append(f"{row_label} {field} is not an object")
        return
    labels = {str(label) for label in counts}
    unknown = sorted(labels - SOURCE_LABELS)
    if unknown:
        errors.append(f"{row_label} {field} has unknown source labels: {unknown}")
    if total_field in payload and payload[total_field] is not None:
        total = int(payload[total_field])
        observed = sum(int(value) for value in counts.values())
        if observed != total:
            errors.append(
                f"{row_label} {field} sums to {observed}, expected {total_field}={total}"
            )


def _validate_problem(
    *,
    problem_root: Path,
    benchmark: str,
    problem: str,
    acceptance_hard_subset: bool,
) -> dict[str, Any]:
    errors: list[str] = []
    summary_path = problem_root / "archive_summary.json"
    history_path = problem_root / "archive_history.jsonl"
    cells_path = problem_root / "archive_cells.csv"

    if not summary_path.is_file():
        errors.append("missing archive_summary.json")
        summary: dict[str, Any] = {}
    else:
        summary = _load_json(summary_path)
    if not history_path.is_file():
        errors.append("missing archive_history.jsonl")
        history: list[dict[str, Any]] = []
    else:
        history = _load_jsonl(history_path)
    rows = _csv_rows(cells_path) if cells_path.is_file() else []

    if acceptance_hard_subset:
        if summary.get("archive_type") != "grid_quantile":
            errors.append("archive_type is not grid_quantile")
        if summary.get("descriptor_profile") != "journal_logic_ff_width_3d":
            errors.append("descriptor_profile is not journal_logic_ff_width_3d")
        if summary.get("cell_mode") != "pareto_front":
            errors.append("cell_mode is not pareto_front")

    occupied_cells = int(summary.get("occupied_cells", -1))
    total_members = int(summary.get("total_archive_members", -1))
    archive_member_count = int(summary.get("archive_member_count", total_members))
    if archive_member_count != total_members:
        errors.append("archive_member_count does not match total_archive_members")
    if summary.get("cell_mode") == "pareto_front" and archive_member_count < occupied_cells:
        errors.append("archive_member_count is lower than occupied_cells")
    if cells_path.is_file() and len(rows) != total_members:
        errors.append("archive_cells.csv row count does not equal total_archive_members")

    for field in (
        "fail_pool_size",
        "coverage_fail_share",
        "p_fail_cap",
        "effective_fail_share",
    ):
        if field not in summary:
            errors.append(f"archive_summary.json missing {field}")
    _check_source_counts(
        errors=errors,
        row_label="archive_summary.json",
        payload=summary,
        field="planned_parent_source_counts",
        total_field="total_budget",
    )
    _check_source_counts(
        errors=errors,
        row_label="archive_summary.json",
        payload=summary,
        field="generated_parent_source_counts",
        total_field="generated_candidate_count",
    )

    initialized_generations = 0
    capped_generations = 0
    for index, row in enumerate(history):
        row_label = f"archive_history[{index}]"
        if summary.get("cell_mode") == "pareto_front":
            row_member_count = int(row.get("archive_member_count", row.get("total_archive_members", -1)))
            row_occupied = int(row.get("occupied_cells", -1))
            if row_member_count < row_occupied:
                errors.append(f"{row_label} archive_member_count is lower than occupied_cells")
        _check_source_counts(
            errors=errors,
            row_label=row_label,
            payload=row,
            field="planned_parent_source_counts",
            total_field="total_budget",
        )
        _check_source_counts(
            errors=errors,
            row_label=row_label,
            payload=row,
            field="generated_parent_source_counts",
            total_field="generated_candidate_count",
        )
        if row.get("phase") not in {"fill", "improve"}:
            continue
        initialized_generations += 1
        coverage = row.get("coverage_fail_share")
        cap = row.get("p_fail_cap")
        effective = row.get("effective_fail_share")
        if coverage is None:
            errors.append(f"{row_label} missing coverage_fail_share")
            continue
        if cap is None:
            errors.append(f"{row_label} missing p_fail_cap")
            continue
        if effective is None:
            errors.append(f"{row_label} missing effective_fail_share")
            continue
        coverage_float = float(coverage)
        cap_float = float(cap)
        effective_float = float(effective)
        if effective_float > coverage_float + 1e-9:
            errors.append(f"{row_label} effective_fail_share exceeds coverage_fail_share")
        if int(row.get("fail_pool_size", 0)) > 0 and int(row.get("archive_member_count", 0)) > 0:
            if effective_float > cap_float + 1e-9:
                errors.append(f"{row_label} effective_fail_share exceeds p_fail_cap")
            capped_generations += 1

    return {
        "benchmark": benchmark,
        "problem": problem,
        "problem_root": str(problem_root),
        "valid": not errors,
        "errors": errors,
        "initialized_generations": initialized_generations,
        "capped_generations": capped_generations,
        "occupied_cells": occupied_cells,
        "total_archive_members": total_members,
    }


def _write_report(path: Path, payload: dict[str, Any]) -> None:
    lines = [
        "# Two-Tier Fail-Pool Validation",
        "",
        f"- valid: `{payload['valid']}`",
        f"- problem_count: `{payload['problem_count']}`",
        f"- failure_count: `{payload['failure_count']}`",
        f"- problem_invalid_count: `{payload['problem_invalid_count']}`",
        f"- acceptance_error_count: `{payload['acceptance_error_count']}`",
        f"- initialized_generation_count: `{payload['initialized_generation_count']}`",
        f"- capped_generation_count: `{payload['capped_generation_count']}`",
        "",
        "## Problems",
        "",
    ]
    for problem in payload["problems"]:
        lines.append(
            f"- `{problem['benchmark']}/{problem['problem']}`: "
            f"valid={problem['valid']}, initialized={problem['initialized_generations']}, "
            f"capped={problem['capped_generations']}, members={problem['total_archive_members']}"
        )
        for error in problem["errors"]:
            lines.append(f"  - {error}")
    if payload["acceptance_errors"]:
        lines.extend(["", "## Acceptance Errors", ""])
        for error in payload["acceptance_errors"]:
            lines.append(f"- {error}")
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--subset-config", required=True, type=Path)
    parser.add_argument("--classic-mode", default="classic")
    parser.add_argument("--structural-qd-mode", default="grid_struct")
    parser.add_argument("--scalar-journal-mode", default="grid_quantile_journal_bd")
    parser.add_argument("--pareto-journal-mode", required=True)
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    args = parser.parse_args(argv)

    expected = _expected_problems(args.subset_config)
    acceptance_errors: list[str] = []
    if args.acceptance_hard_subset and len(expected) != 13:
        acceptance_errors.append(f"expected 13 hard-subset problems, found {len(expected)}")
    if args.require_full_subset:
        for mode in (
            args.classic_mode,
            args.structural_qd_mode,
            args.scalar_journal_mode,
            args.pareto_journal_mode,
        ):
            missing = _mode_missing_problems(
                run_root=args.run_root,
                mode=mode,
                expected=expected,
            )
            if missing:
                acceptance_errors.append(f"{mode} missing problems: {', '.join(missing)}")

    problems = []
    for item in expected:
        root = _problem_root(
            args.run_root,
            args.pareto_journal_mode,
            item["benchmark"],
            item["problem"],
        )
        if root is None:
            problems.append(
                {
                    "benchmark": item["benchmark"],
                    "problem": item["problem"],
                    "problem_root": None,
                    "valid": False,
                    "errors": ["missing pareto journal problem root"],
                    "initialized_generations": 0,
                    "capped_generations": 0,
                    "occupied_cells": -1,
                    "total_archive_members": -1,
                }
            )
            continue
        problems.append(
            _validate_problem(
                problem_root=root,
                benchmark=item["benchmark"],
                problem=item["problem"],
                acceptance_hard_subset=args.acceptance_hard_subset,
            )
        )

    initialized_generation_count = sum(
        int(problem["initialized_generations"]) for problem in problems
    )
    capped_generation_count = sum(int(problem["capped_generations"]) for problem in problems)
    if args.acceptance_hard_subset and initialized_generation_count == 0:
        acceptance_errors.append("no initialized archive scheduling generation was observed")

    problem_invalid_count = sum(1 for problem in problems if not problem["valid"])
    problem_error_count = sum(len(problem["errors"]) for problem in problems)
    acceptance_error_count = len(acceptance_errors)
    failure_count = problem_error_count + acceptance_error_count
    payload = {
        "valid": failure_count == 0,
        "problem_count": len(problems),
        "failure_count": failure_count,
        "problem_invalid_count": problem_invalid_count,
        "acceptance_error_count": acceptance_error_count,
        "initialized_generation_count": initialized_generation_count,
        "capped_generation_count": capped_generation_count,
        "classic_mode": args.classic_mode,
        "structural_qd_mode": args.structural_qd_mode,
        "scalar_journal_mode": args.scalar_journal_mode,
        "pareto_journal_mode": args.pareto_journal_mode,
        "problems": problems,
        "acceptance_errors": acceptance_errors,
    }
    json_path = args.run_root / "two_tier_fail_pool_validation.json"
    report_path = args.run_root / "two_tier_fail_pool_validation.md"
    json_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    _write_report(report_path, payload)
    return 0 if payload["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
