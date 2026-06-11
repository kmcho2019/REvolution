#!/usr/bin/env python3
"""Build the locked RealBench long-model probe manifest.

Selects the longest/densest harness-validated RealBench module tasks by a
deterministic size rank (prompt bytes + harness bytes + support bytes) from a
generated ``module_manifest.json``. The probe decides, per the journal-revamp
model policy, whether the local vLLM model is sufficient for RealBench final
claims or whether a symmetric DeepSeek arm is required; both models must run
this same locked task set with identical budgets and policies.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

import yaml

DEFAULT_ROOT = Path(__file__).resolve().parent.parent / "data" / "bench" / "RealBench"
DEFAULT_OUTPUT = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "configs"
    / "realbench_long_model_probe.yaml"
)


def task_size_rank(entry: dict[str, Any]) -> int:
    signals = entry.get("size_signals", {})
    if not isinstance(signals, dict):
        return 0
    return int(
        int(signals.get("prompt_bytes", 0))
        + int(signals.get("test_sv_bytes", 0))
        + int(signals.get("support_bytes", 0))
    )


def select_probe_tasks(
    manifest: dict[str, Any],
    *,
    probe_size: int,
    require_validated: bool = True,
) -> list[dict[str, Any]]:
    eligible = [
        entry
        for entry in manifest.get("problems", [])
        if isinstance(entry, dict)
        and str(entry.get("subset", "module")) == "module"
        and (not require_validated or entry.get("harness_validated", False))
    ]
    ranked = sorted(
        eligible,
        key=lambda entry: (-task_size_rank(entry), str(entry.get("problem_name", ""))),
    )
    return ranked[:probe_size]


def build_probe_payload(
    *,
    manifest: dict[str, Any],
    subset_name: str,
    probe_size: int,
    selected: list[dict[str, Any]],
    realbench_root: Path,
) -> dict[str, Any]:
    repo_root = Path(__file__).resolve().parent.parent
    try:
        root_display = str(realbench_root.relative_to(repo_root))
    except ValueError:
        root_display = str(realbench_root)
    problems = sorted(str(entry["problem_name"]) for entry in selected)
    return {
        "version": 1,
        "subset_name": subset_name,
        "selection": {
            "realbench_root": root_display,
            "manifest_sha256": str(manifest.get("manifest_sha256", "")),
            "require_harness_validated": True,
            "probe_size": probe_size,
            "rule": (
                "rank harness-validated module tasks by descending "
                "(prompt_bytes + test_sv_bytes + support_bytes), tie-break "
                "by problem_name, take first probe_size"
            ),
            "subset_size": len(problems),
        },
        "tasks": [
            {
                "problem_name": str(entry["problem_name"]),
                "family": str(entry.get("family", "unknown")),
                "size_rank_bytes": task_size_rank(entry),
            }
            for entry in sorted(
                selected,
                key=lambda e: (-task_size_rank(e), str(e.get("problem_name", ""))),
            )
        ],
        "benchmarks": {
            "RealBench": {
                "problems": problems,
            }
        },
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--realbench-root",
        type=Path,
        default=DEFAULT_ROOT,
        help="Generated RealBench manifest root.",
    )
    parser.add_argument(
        "--output-config",
        type=Path,
        default=DEFAULT_OUTPUT,
        help="Locked probe manifest output path (YAML).",
    )
    parser.add_argument(
        "--subset-name",
        type=str,
        default="realbench_long_model_probe_v1",
        help="Manifest subset_name field.",
    )
    parser.add_argument(
        "--probe-size",
        type=int,
        default=8,
        help="Number of longest tasks to lock into the probe.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    manifest_path = args.realbench_root.resolve() / "module_manifest.json"
    if not manifest_path.is_file():
        print(
            f"error: module_manifest.json not found under {args.realbench_root}; "
            "run scripts/build_realbench_manifest.py first.",
            file=sys.stderr,
        )
        return 2
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

    selected = select_probe_tasks(manifest, probe_size=args.probe_size)
    if len(selected) < args.probe_size:
        print(
            f"error: only {len(selected)} validated tasks available for a "
            f"{args.probe_size}-task probe",
            file=sys.stderr,
        )
        return 2

    payload = build_probe_payload(
        manifest=manifest,
        subset_name=args.subset_name,
        probe_size=args.probe_size,
        selected=selected,
        realbench_root=args.realbench_root.resolve(),
    )
    args.output_config.parent.mkdir(parents=True, exist_ok=True)
    args.output_config.write_text(
        yaml.safe_dump(payload, sort_keys=False),
        encoding="utf-8",
    )
    print(
        f"Locked RealBench long-model probe: {len(selected)} tasks -> "
        f"{args.output_config}"
    )
    for entry in payload["tasks"]:
        print(
            f"  {entry['problem_name']} ({entry['family']}, "
            f"{entry['size_rank_bytes']} bytes)"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
