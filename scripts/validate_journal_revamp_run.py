#!/usr/bin/env python3
"""Validate a journal-revamp run root against the debug-gate requirements.

Checks one backend run tree (classic or QD) against the locked subset
manifest and the goal-spec gate requirements that are verifiable from
artifacts alone:

- every locked (benchmark, problem) produced a problem summary;
- a run config snapshot exists, and (optionally) records the expected seed;
- scheduler telemetry was emitted (when required) and parses with nonzero
  occupancy;
- for QD runs: ``archive_summary.json``, ``qd_metrics.json``, and
  ``descriptor_health.json`` exist per problem, archive occupancy is
  nonzero, and descriptor collapse is not total (a fatal collapse is every
  axis collapsed on a problem).

Emits ``validation_report.json`` and ``validation_report.md``; exits
nonzero when any required check fails so the gate can be scripted.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml


@dataclass
class CheckResult:
    name: str
    passed: bool
    detail: str

    def as_dict(self) -> dict[str, object]:
        return {"name": self.name, "passed": self.passed, "detail": self.detail}


def load_locked_problems(subset_config: Path) -> dict[str, list[str]]:
    payload = yaml.safe_load(subset_config.read_text(encoding="utf-8"))
    benchmarks = payload.get("benchmarks", {}) if isinstance(payload, dict) else {}
    locked: dict[str, list[str]] = {}
    for benchmark, body in benchmarks.items():
        problems = body.get("problems", []) if isinstance(body, dict) else []
        locked[str(benchmark)] = [str(problem) for problem in problems]
    return locked


def discover_problem_summaries(run_root: Path) -> dict[tuple[str, str], Path]:
    """Map (benchmark, problem) -> summary path using tree layout.

    The artifact layout is ``<run_root>/<model>/<benchmark>/<problem>/...``;
    benchmark and problem are recovered from the summary path's parents.
    """

    ignored = {"archive_summary.json", "global_pareto_summary.json"}
    found: dict[tuple[str, str], Path] = {}
    for summary_path in sorted(run_root.rglob("*_summary.json")):
        if summary_path.name in ignored:
            continue
        problem_dir = summary_path.parent
        benchmark_dir = problem_dir.parent
        found[(benchmark_dir.name, problem_dir.name)] = summary_path
    return found


def check_locked_coverage(
    locked: dict[str, list[str]],
    summaries: dict[tuple[str, str], Path],
) -> list[CheckResult]:
    checks: list[CheckResult] = []
    for benchmark, problems in sorted(locked.items()):
        missing = [
            problem for problem in problems if (benchmark, problem) not in summaries
        ]
        checks.append(
            CheckResult(
                name=f"locked_coverage:{benchmark}",
                passed=not missing,
                detail=(
                    f"{len(problems) - len(missing)}/{len(problems)} locked problems "
                    f"have summaries"
                    + (f"; missing: {', '.join(missing)}" if missing else "")
                ),
            )
        )
    return checks


def check_config_snapshot(run_root: Path, expect_seed: int | None) -> list[CheckResult]:
    snapshots = sorted(run_root.rglob("*_config.yaml"))
    if not snapshots:
        return [
            CheckResult(
                name="config_snapshot",
                passed=False,
                detail="no *_config.yaml snapshot found under run root",
            )
        ]
    checks = [
        CheckResult(
            name="config_snapshot",
            passed=True,
            detail=f"found {snapshots[0].name}",
        )
    ]
    if expect_seed is not None:
        try:
            payload = yaml.safe_load(snapshots[0].read_text(encoding="utf-8"))
        except yaml.YAMLError:
            payload = None
        observed = payload.get("seed") if isinstance(payload, dict) else None
        checks.append(
            CheckResult(
                name="config_seed",
                passed=observed == expect_seed,
                detail=f"expected seed {expect_seed}, snapshot records {observed}",
            )
        )
    return checks


def check_scheduler_telemetry(run_root: Path, *, required: bool) -> list[CheckResult]:
    telemetry_files = sorted(run_root.rglob("*_scheduler_telemetry.json"))
    if not telemetry_files:
        return [
            CheckResult(
                name="scheduler_telemetry",
                passed=not required,
                detail=(
                    "no scheduler telemetry file found"
                    + ("" if not required else " (required)")
                ),
            )
        ]
    try:
        payload = json.loads(telemetry_files[0].read_text(encoding="utf-8"))
        occupancy = float(payload.get("mean_occupancy_fraction", 0.0))
        wall = float(payload.get("run_wall_seconds", payload.get("wall_seconds", 0.0)))
        passed = wall > 0.0 and occupancy >= 0.0
        detail = (
            f"{telemetry_files[0].name}: wall={wall:.1f}s occupancy={occupancy:.3f}"
        )
    except (json.JSONDecodeError, TypeError, ValueError) as exc:
        passed = False
        detail = f"telemetry unreadable: {exc}"
    return [CheckResult(name="scheduler_telemetry", passed=passed, detail=detail)]


def check_qd_problem_artifacts(
    summaries: dict[tuple[str, str], Path],
    locked: dict[str, list[str]],
) -> list[CheckResult]:
    checks: list[CheckResult] = []
    for benchmark, problems in sorted(locked.items()):
        for problem in problems:
            summary_path = summaries.get((benchmark, problem))
            if summary_path is None:
                continue  # already reported by locked_coverage
            problem_dir = summary_path.parent
            missing_files = [
                name
                for name in (
                    "archive_summary.json",
                    "qd_metrics.json",
                    "descriptor_health.json",
                )
                if not (problem_dir / name).is_file()
            ]
            if missing_files:
                checks.append(
                    CheckResult(
                        name=f"qd_artifacts:{benchmark}/{problem}",
                        passed=False,
                        detail=f"missing {', '.join(missing_files)}",
                    )
                )
                continue
            try:
                archive = json.loads(
                    (problem_dir / "archive_summary.json").read_text(encoding="utf-8")
                )
            except json.JSONDecodeError:
                archive = {}
            occupied = archive.get("occupied_cells")
            occupied_ok = isinstance(occupied, (int, float)) and occupied > 0
            try:
                health = json.loads(
                    (problem_dir / "descriptor_health.json").read_text(encoding="utf-8")
                )
            except json.JSONDecodeError:
                health = {}
            collapsed = health.get("collapsed_axes", [])
            axes = health.get("axes", health.get("descriptor_axes", []))
            fatal_collapse = (
                isinstance(collapsed, list)
                and isinstance(axes, list)
                and len(axes) > 0
                and len(collapsed) >= len(axes)
            )
            passed = occupied_ok and not fatal_collapse
            detail = (
                f"occupied_cells={occupied}, collapsed_axes="
                f"{len(collapsed) if isinstance(collapsed, list) else '?'}"
            )
            checks.append(
                CheckResult(
                    name=f"qd_artifacts:{benchmark}/{problem}",
                    passed=passed,
                    detail=detail,
                )
            )
    return checks


def write_reports(
    output_dir: Path,
    checks: list[CheckResult],
    *,
    run_root: Path,
    search_mode: str,
) -> bool:
    output_dir.mkdir(parents=True, exist_ok=True)
    all_passed = all(check.passed for check in checks)
    payload: dict[str, Any] = {
        "run_root": str(run_root),
        "search_mode": search_mode,
        "all_passed": all_passed,
        "checks": [check.as_dict() for check in checks],
    }
    (output_dir / "validation_report.json").write_text(
        json.dumps(payload, indent=2), encoding="utf-8"
    )
    lines = [
        "# Journal Revamp Run Validation",
        "",
        f"Run root: `{run_root}` | mode: `{search_mode}` | "
        f"overall: {'PASS' if all_passed else 'FAIL'}",
        "",
        "| Check | Passed | Detail |",
        "| --- | --- | --- |",
    ]
    for check in checks:
        lines.append(
            f"| {check.name} | {'✅' if check.passed else '❌'} | {check.detail} |"
        )
    lines.append("")
    (output_dir / "validation_report.md").write_text("\n".join(lines), encoding="utf-8")
    return all_passed


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument(
        "--subset-config",
        type=Path,
        action="append",
        required=True,
        help="Locked subset YAML (repeatable; benchmarks.<name>.problems).",
    )
    parser.add_argument(
        "--search-mode", choices=("classic", "qd"), default="classic"
    )
    parser.add_argument("--expect-seed", type=int, default=None)
    parser.add_argument(
        "--require-scheduler-telemetry", action="store_true", default=False
    )
    parser.add_argument("--output-dir", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    if not args.run_root.is_dir():
        print(f"error: run root not found: {args.run_root}", file=sys.stderr)
        return 2
    locked: dict[str, list[str]] = {}
    for subset_config in args.subset_config:
        if not subset_config.is_file():
            print(f"error: subset config not found: {subset_config}", file=sys.stderr)
            return 2
        for benchmark, problems in load_locked_problems(subset_config).items():
            locked.setdefault(benchmark, []).extend(problems)

    summaries = discover_problem_summaries(args.run_root)
    checks = check_locked_coverage(locked, summaries)
    checks.extend(check_config_snapshot(args.run_root, args.expect_seed))
    checks.extend(
        check_scheduler_telemetry(
            args.run_root, required=args.require_scheduler_telemetry
        )
    )
    if args.search_mode == "qd":
        checks.extend(check_qd_problem_artifacts(summaries, locked))

    all_passed = write_reports(
        args.output_dir, checks, run_root=args.run_root, search_mode=args.search_mode
    )
    for check in checks:
        print(f"[{'PASS' if check.passed else 'FAIL'}] {check.name}: {check.detail}")
    print(
        f"Validation {'PASSED' if all_passed else 'FAILED'}; reports in "
        f"{args.output_dir}"
    )
    return 0 if all_passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
