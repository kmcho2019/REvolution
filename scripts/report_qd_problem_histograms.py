#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.problem_feature_histograms import (  # noqa: E402
    DEFAULT_HISTOGRAM_BINS,
    DEFAULT_OUTPUT_SUBDIR,
    write_problem_feature_histograms,
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Generate per-problem CVT feature histogram figures for a QD run tree. "
            "The script scans the run root for problem directories containing CVT archive artifacts."
        )
    )
    parser.add_argument(
        "--run-root",
        required=True,
        help="Experiment root containing QD backend directories.",
    )
    parser.add_argument(
        "--output-subdir",
        default=DEFAULT_OUTPUT_SUBDIR,
        help=(
            "Name of the per-problem output subdirectory created under each problem "
            f"(default: {DEFAULT_OUTPUT_SUBDIR})."
        ),
    )
    parser.add_argument(
        "--bins",
        type=int,
        default=DEFAULT_HISTOGRAM_BINS,
        help=f"Histogram bin count for each feature axis (default: {DEFAULT_HISTOGRAM_BINS}).",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    run_root = Path(args.run_root).resolve()
    if not run_root.is_dir():
        raise SystemExit(f"Run root does not exist: {run_root}")

    processed = 0
    skipped: list[dict[str, str]] = []
    for problem_dir in discover_cvt_problem_dirs(run_root):
        try:
            artifacts = write_problem_feature_histograms(
                problem_dir=problem_dir,
                output_subdir=args.output_subdir,
                bins=args.bins,
            )
        except Exception as exc:  # pragma: no cover - surfaced through stdout and exit code
            skipped.append(
                {
                    "problem_dir": str(problem_dir),
                    "reason": str(exc),
                }
            )
            continue
        processed += 1
        print(
            json.dumps(
                {
                    "problem_dir": artifacts.problem_dir,
                    "output_dir": artifacts.output_dir,
                    "success_count": artifacts.success_count,
                    "generation_count": len(artifacts.generations),
                    "centroid_count": artifacts.centroid_count,
                }
            )
        )

    print(
        json.dumps(
            {
                "run_root": str(run_root),
                "processed_problem_count": processed,
                "skipped_problem_count": len(skipped),
                "skipped": skipped,
            }
        )
    )
    return 0 if processed > 0 else 1


def discover_cvt_problem_dirs(run_root: Path) -> list[Path]:
    problem_dirs: list[Path] = []
    for centroids_path in sorted(run_root.rglob("centroids.json")):
        problem_dir = centroids_path.parent
        archive_space_path = problem_dir / "archive_space.json"
        if not archive_space_path.is_file():
            continue
        try:
            payload = json.loads(archive_space_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        if not isinstance(payload, dict):
            continue
        if payload.get("archive_type") != "cvt":
            continue
        problem_dirs.append(problem_dir)
    return problem_dirs


if __name__ == "__main__":
    raise SystemExit(main())
