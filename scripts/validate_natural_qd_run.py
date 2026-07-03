#!/usr/bin/env python3
"""Validate one natural-QD-push run root against the push run contract.

Checks, per the natural_qd_push plan (2026-07-03):

- every manifest ``(benchmark, problem)`` maps to exactly one problem dir
  with a non-empty ``generation_log.jsonl`` under the run root;
- zero ``single_thought_operator`` candidates; classic arms use only the
  EoH suite; QD arms may additionally emit ``M-T`` (the QD engine's
  thought-mutation lane under ``eoh_strategies`` — the 20260630 corrected
  suite accepted it, and the audit CSV keeps its count visible);
- QD arms (``--arm qd``) carry ``archive_summary.json`` and
  ``qd_metrics.json`` in every problem dir; classic arms
  (``--arm classic``) carry neither;
- every ``--expect-config KEY=VALUE`` matches the run's resolved
  ``*_revolution_config.yaml`` (the registered-card-vs-run guard that
  the unfaithful first anchor showed is needed);
- per-problem and total ``llm_api_calls`` are reported (budget-parity
  visibility; informational, not a gate).

Writes a JSON report and exits nonzero on any violation.
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

import yaml

EOH_STRATEGIES = frozenset({"M-S", "M-R", "M-I", "C-F", "M-E", "M-F"})
ALLOWED_BY_ARM = {
    "classic": EOH_STRATEGIES | {"initial"},
    "qd": EOH_STRATEGIES | {"initial", "M-T"},
}
QD_ARTIFACTS = ("archive_summary.json", "qd_metrics.json")


def load_manifest(path: Path) -> list[tuple[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return [(row["benchmark"], row["problem"]) for row in rows]


def problem_dirs(run_root: Path) -> dict[tuple[str, str], Path]:
    """Map (benchmark, problem) to its problem dir via generation logs."""
    found: dict[tuple[str, str], Path] = {}
    for log_path in sorted(run_root.rglob("generation_log.jsonl")):
        problem_dir = log_path.parent
        key = (problem_dir.parent.name, problem_dir.name)
        assert key not in found, f"duplicate problem dir for {key}"
        found[key] = problem_dir
    return found


def config_errors(run_root: Path, expected: list[str]) -> list[str]:
    """Check KEY=VALUE expectations against the resolved run config."""
    if not expected:
        return []
    config_paths = sorted(run_root.rglob("*_revolution_config.yaml"))
    if not config_paths:
        return ["no *_revolution_config.yaml under run root"]
    config = yaml.safe_load(config_paths[0].read_text(encoding="utf-8"))
    assert isinstance(config, dict)
    errors: list[str] = []
    for item in expected:
        key, _, want = item.partition("=")
        assert want, f"--expect-config needs KEY=VALUE, got {item!r}"
        if key not in config:
            errors.append(f"config key {key!r} missing")
        elif str(config[key]) != want:
            errors.append(f"config {key}={config[key]!r}, expected {want!r}")
    return errors


def llm_call_totals(problem_dirs: dict[tuple[str, str], Path]) -> dict[str, int]:
    """Sum generation-log llm_api_calls per problem (budget visibility)."""
    totals: dict[str, int] = {}
    for (_, problem), problem_dir in sorted(problem_dirs.items()):
        lines = (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8")
        rows = [json.loads(line) for line in lines.splitlines() if line.strip()]
        totals[problem] = sum(int(row["llm_api_calls"]) for row in rows)
    totals["TOTAL"] = sum(totals.values())
    return totals


def strategy_errors(problem_dir: Path, arm: str) -> list[str]:
    """Aggregate per-generation strategy counts and flag forbidden ones."""
    allowed = ALLOWED_BY_ARM[arm]
    lines = (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8")
    rows = [json.loads(line) for line in lines.splitlines() if line.strip()]
    if not rows:
        return [f"{problem_dir.name}: empty generation_log.jsonl"]
    errors: list[str] = []
    for row in rows:
        counts = row["strategy_counts_this_generation"]
        assert isinstance(counts, dict)
        for strategy, count in counts.items():
            if strategy not in allowed and int(count) > 0:
                errors.append(
                    f"{problem_dir.name}: generation {row['generation']} used"
                    f" forbidden strategy {strategy!r} ({count}x)"
                )
    return errors


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--arm", choices=["classic", "qd"], required=True)
    parser.add_argument(
        "--expect-config",
        action="append",
        default=[],
        help="KEY=VALUE to assert against the resolved run config YAML.",
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    assert args.run_root.is_dir(), args.run_root

    manifest = load_manifest(args.manifest)
    found = problem_dirs(args.run_root)
    errors: list[str] = []
    errors.extend(config_errors(args.run_root, args.expect_config))

    for key in manifest:
        if key not in found:
            errors.append(f"missing problem dir for {key[0]}/{key[1]}")
    for key in found:
        if key not in manifest:
            errors.append(f"unexpected problem dir {key[0]}/{key[1]}")

    for key, problem_dir in sorted(found.items()):
        if key not in manifest:
            continue
        errors.extend(strategy_errors(problem_dir, args.arm))
        for artifact in QD_ARTIFACTS:
            present = (problem_dir / artifact).is_file()
            if args.arm == "qd" and not present:
                errors.append(f"{key[1]}: missing QD artifact {artifact}")
            if args.arm == "classic" and present:
                errors.append(f"{key[1]}: classic arm has QD artifact {artifact}")

    report = {
        "run_root": str(args.run_root),
        "arm": args.arm,
        "manifest": str(args.manifest),
        "checked_problems": len(manifest),
        "found_problems": len(found),
        "expected_config": list(args.expect_config),
        "llm_api_calls": llm_call_totals(
            {key: path for key, path in found.items() if key in set(manifest)}
        ),
        "errors": errors,
        "status": "fail" if errors else "pass",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"validate_natural_qd_run: {report['status']} ({len(errors)} error(s))")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
