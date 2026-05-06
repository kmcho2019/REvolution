#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import importlib
import json
from pathlib import Path
from typing import Any


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


def _csv_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _expected_problems(path: Path) -> list[dict[str, str]]:
    config = _load_yaml(path)
    return [
        {"benchmark": str(item["benchmark"]), "problem": str(item["problem"])}
        for item in config["selected_problems"]
    ]


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


def _dominates(
    left: dict[str, float],
    right: dict[str, float],
    objective_names: list[str],
) -> bool:
    greater_or_equal = True
    strictly_greater = False
    for name in objective_names:
        greater_or_equal = greater_or_equal and left[name] >= right[name]
        strictly_greater = strictly_greater or left[name] > right[name]
    return greater_or_equal and strictly_greater


def _local_ranks(
    members: list[dict[str, Any]],
    objective_names: list[str],
) -> dict[str, int]:
    remaining = list(members)
    ranks: dict[str, int] = {}
    rank = 1
    while remaining:
        current = [
            member
            for member in remaining
            if not any(
                other is not member
                and _dominates(other["objectives"], member["objectives"], objective_names)
                for other in remaining
            )
        ]
        for member in current:
            ranks[member["candidate_id"]] = rank
        remaining = [member for member in remaining if member not in current]
        rank += 1
    return ranks


def _validate_global_archive(
    *,
    problem_root: Path,
    objective_names: list[str],
) -> list[str]:
    errors: list[str] = []
    archive_path = problem_root / "global_pareto_archive.csv"
    summary_path = problem_root / "global_pareto_summary.json"
    if not archive_path.is_file():
        errors.append("missing global_pareto_archive.csv")
        rows: list[dict[str, str]] = []
    else:
        rows = _csv_rows(archive_path)
    if not summary_path.is_file():
        errors.append("missing global_pareto_summary.json")
        summary: dict[str, Any] = {}
    else:
        summary = _load_json(summary_path)

    summary_count = int(summary.get("total_global_pareto_members", -1))
    if rows and len(rows) != summary_count:
        errors.append("global archive row count does not match summary")

    members: list[dict[str, Any]] = []
    seen_keys: set[tuple[float, ...]] = set()
    for row in rows:
        objectives = json.loads(row.get("objectives_json") or "{}")
        assert isinstance(objectives, dict)
        missing = [name for name in objective_names if name not in objectives]
        if missing:
            errors.append(f"{row['candidate_id']} missing global objectives {missing}")
            continue
        key = tuple(float(objectives[name]) for name in objective_names)
        if key in seen_keys:
            errors.append("global archive contains duplicate objective vectors")
        seen_keys.add(key)
        members.append(
            {
                "candidate_id": row["candidate_id"],
                "objectives": {name: float(objectives[name]) for name in objective_names},
            }
        )

    for left_index, left in enumerate(members):
        for right in members[left_index + 1 :]:
            if _dominates(left["objectives"], right["objectives"], objective_names):
                errors.append(
                    f"global {left['candidate_id']} dominates {right['candidate_id']}"
                )
            if _dominates(right["objectives"], left["objectives"], objective_names):
                errors.append(
                    f"global {right['candidate_id']} dominates {left['candidate_id']}"
                )
    return errors


def _validate_problem(
    *,
    problem_root: Path,
    benchmark: str,
    problem: str,
    acceptance_hard_subset: bool,
) -> dict[str, Any]:
    errors: list[str] = []
    summary_path = problem_root / "archive_summary.json"
    cells_path = problem_root / "archive_cells.csv"
    history_path = problem_root / "archive_history.jsonl"

    if not summary_path.is_file():
        errors.append("missing archive_summary.json")
        summary: dict[str, Any] = {}
    else:
        summary = _load_json(summary_path)
    if not cells_path.is_file():
        errors.append("missing archive_cells.csv")
        rows: list[dict[str, str]] = []
    else:
        rows = _csv_rows(cells_path)
    history = _load_jsonl(history_path) if history_path.is_file() else []
    if not history_path.is_file():
        errors.append("missing archive_history.jsonl")

    objective_names = [str(name) for name in summary.get("objective_names", [])]
    if not objective_names:
        errors.append("archive_summary.json missing objective_names")

    if summary.get("cell_mode") != "pareto_front":
        errors.append("archive_summary.json cell_mode is not pareto_front")
    if acceptance_hard_subset:
        if summary.get("archive_type") != "grid_quantile":
            errors.append("archive_type is not grid_quantile")
        if summary.get("descriptor_profile") != "journal_logic_ff_width_3d":
            errors.append("descriptor_profile is not journal_logic_ff_width_3d")

    total_members = int(summary.get("total_archive_members", -1))
    occupied_cells = int(summary.get("occupied_cells", -1))
    max_elites = int(summary.get("max_elites_per_cell", -1))
    summary_max_front = int(summary.get("max_front_size", 0))
    if len(rows) != total_members:
        errors.append("archive_cells.csv row count does not equal total_archive_members")

    rows_by_cell: dict[str, list[dict[str, Any]]] = {}
    for row in rows:
        cell_id = row["cell_id"]
        objectives = json.loads(row.get("objectives_json") or "{}")
        assert isinstance(objectives, dict)
        for name in objective_names:
            if name not in objectives:
                errors.append(f"{row['candidate_id']} missing objective {name}")
        rows_by_cell.setdefault(cell_id, []).append(
            {
                "candidate_id": row["candidate_id"],
                "front_size": int(row.get("front_size") or 0),
                "cell_member_count": int(row.get("cell_member_count") or row.get("front_size") or 0),
                "pareto_rank": int(row.get("pareto_rank") or 0),
                "objectives": {name: float(objectives[name]) for name in objective_names if name in objectives},
            }
        )

    if len(rows_by_cell) != occupied_cells:
        errors.append("distinct cell_id count does not equal occupied_cells")
    observed_max_front = max((len(members) for members in rows_by_cell.values()), default=0)
    if observed_max_front != summary_max_front:
        errors.append("archive_cells.csv max front size does not equal summary max_front_size")
    if max_elites <= 0:
        errors.append("max_elites_per_cell must be positive")
    elif observed_max_front > max_elites:
        errors.append("max_front_size exceeds max_elites_per_cell")

    for cell_id, members in rows_by_cell.items():
        reported_sizes = {member["front_size"] for member in members}
        if reported_sizes != {len(members)}:
            errors.append(f"{cell_id} front_size values do not match cell row count")
        reported_counts = {member["cell_member_count"] for member in members}
        if reported_counts != {len(members)}:
            errors.append(f"{cell_id} cell_member_count values do not match cell row count")
        objective_keys = {
            tuple(member["objectives"].get(name) for name in objective_names)
            for member in members
        }
        if len(objective_keys) != len(members):
            errors.append(f"{cell_id} contains duplicate objective vectors")
        recomputed = _local_ranks(members, objective_names)
        for member in members:
            if member["pareto_rank"] < 1:
                errors.append(f"{member['candidate_id']} has invalid pareto_rank")
                continue
            expected_rank = recomputed.get(member["candidate_id"])
            if member["pareto_rank"] != expected_rank:
                errors.append(
                    f"{member['candidate_id']} pareto_rank mismatch in {cell_id}"
                )

    if history:
        latest = history[-1]
        if int(latest.get("total_archive_members", -1)) != total_members:
            errors.append("latest history total_archive_members mismatch")
        if int(latest.get("occupied_cells", -1)) != occupied_cells:
            errors.append("latest history occupied_cells mismatch")
        if int(latest.get("max_front_size", -1)) != summary_max_front:
            errors.append("latest history max_front_size mismatch")
        if int(latest.get("global_pareto_size", -1)) < 0:
            errors.append("latest history missing global_pareto_size")

    errors.extend(
        _validate_global_archive(
            problem_root=problem_root,
            objective_names=objective_names,
        )
    )

    return {
        "benchmark": benchmark,
        "problem": problem,
        "problem_root": str(problem_root),
        "valid": not errors,
        "errors": errors,
        "occupied_cells": occupied_cells,
        "total_archive_members": total_members,
        "max_front_size": observed_max_front,
    }


def _mode_has_all_problems(
    *,
    run_root: Path,
    mode: str,
    expected: list[dict[str, str]],
) -> tuple[bool, list[str]]:
    missing = []
    for item in expected:
        if _problem_root(run_root, mode, item["benchmark"], item["problem"]) is None:
            missing.append(f"{item['benchmark']}/{item['problem']}")
    return not missing, missing


def _problem_has_verified_synthesis(problem_root: Path) -> bool:
    archive_summary = problem_root / "archive_summary.json"
    if archive_summary.is_file():
        payload = _load_json(archive_summary)
        return int(payload.get("total_archive_members", 0) or 0) > 0

    summary_paths = [
        path
        for path in problem_root.glob("*_summary.json")
        if path.name != "archive_summary.json"
    ]
    for path in summary_paths:
        payload = _load_json(path)
        if payload.get("status") == "success":
            return True
        if payload.get("best_code_path") or payload.get("best_report_path"):
            return True
        if payload.get("best_score") is not None:
            return True
        if int(payload.get("synthesis_success_count", 0) or 0) > 0:
            return True
    return False


def _write_report(path: Path, payload: dict[str, Any]) -> None:
    lines = [
        "# Pareto Front Validation",
        "",
        f"- valid: `{payload['valid']}`",
        f"- failure_count: `{payload['failure_count']}`",
        f"- problem_invalid_count: `{payload['problem_invalid_count']}`",
        f"- acceptance_error_count: `{payload['acceptance_error_count']}`",
        f"- max_front_size_seen: `{payload['max_front_size_seen']}`",
        "",
        "## Problems",
        "",
    ]
    for problem in payload["problems"]:
        lines.append(
            f"- `{problem['benchmark']}/{problem['problem']}`: valid={problem['valid']}, "
            f"members={problem['total_archive_members']}, max_front={problem['max_front_size']}"
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
    parser.add_argument("--scalar-qd-mode", default="")
    parser.add_argument("--pareto-qd-mode", required=True)
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    args = parser.parse_args(argv)

    expected = _expected_problems(args.subset_config)
    acceptance_errors: list[str] = []
    if args.require_full_subset:
        for mode in (args.classic_mode, args.scalar_qd_mode, args.pareto_qd_mode):
            if not mode:
                continue
            complete, missing = _mode_has_all_problems(
                run_root=args.run_root,
                mode=mode,
                expected=expected,
            )
            if not complete:
                acceptance_errors.append(
                    f"{mode} missing problems: {', '.join(missing)}"
                )

    problems = []
    for item in expected:
        root = _problem_root(
            args.run_root,
            args.pareto_qd_mode,
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
                    "errors": ["missing pareto problem root"],
                    "occupied_cells": -1,
                    "total_archive_members": -1,
                    "max_front_size": 0,
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

    max_front_size_seen = max(
        (int(problem["max_front_size"]) for problem in problems),
        default=0,
    )
    if args.acceptance_hard_subset:
        for item in expected:
            classic_root = _problem_root(
                args.run_root,
                args.classic_mode,
                item["benchmark"],
                item["problem"],
            )
            pareto_root = _problem_root(
                args.run_root,
                args.pareto_qd_mode,
                item["benchmark"],
                item["problem"],
            )
            if classic_root is None or pareto_root is None:
                continue
            if _problem_has_verified_synthesis(classic_root) and not _problem_has_verified_synthesis(pareto_root):
                acceptance_errors.append(
                    "classic solved but Pareto QD did not: "
                    f"{item['benchmark']}/{item['problem']}"
                )

    problem_invalid_count = sum(1 for problem in problems if not problem["valid"])
    problem_error_count = sum(len(problem["errors"]) for problem in problems)
    acceptance_error_count = len(acceptance_errors)
    failure_count = problem_error_count + acceptance_error_count
    payload = {
        "valid": failure_count == 0,
        "failure_count": failure_count,
        "problem_invalid_count": problem_invalid_count,
        "acceptance_error_count": acceptance_error_count,
        "max_front_size_seen": max_front_size_seen,
        "classic_mode": args.classic_mode,
        "scalar_qd_mode": args.scalar_qd_mode,
        "pareto_qd_mode": args.pareto_qd_mode,
        "problems": problems,
        "acceptance_errors": acceptance_errors,
    }
    json_path = args.run_root / "pareto_front_validation.json"
    report_path = args.run_root / "pareto_front_validation.md"
    json_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    _write_report(report_path, payload)
    return 0 if payload["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
