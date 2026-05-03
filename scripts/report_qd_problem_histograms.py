#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

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

    processed, skipped = generate_problem_histogram_reports(
        run_root=run_root,
        output_subdir=args.output_subdir,
        bins=args.bins,
    )
    for payload in processed:
        print(json.dumps(payload))

    summary = {
        "run_root": str(run_root),
        "processed_problem_count": len(processed),
        "skipped_problem_count": len(skipped),
        "skipped": skipped,
    }
    print(json.dumps(summary))
    return 0 if processed else 1


def generate_problem_histogram_reports(
    *,
    run_root: Path,
    output_subdir: str = DEFAULT_OUTPUT_SUBDIR,
    bins: int = DEFAULT_HISTOGRAM_BINS,
) -> tuple[list[dict[str, Any]], list[dict[str, str]]]:
    processed: list[dict[str, Any]] = []
    skipped: list[dict[str, str]] = []
    for problem_dir in discover_cvt_problem_dirs(run_root):
        try:
            artifacts = write_problem_feature_histograms(
                problem_dir=problem_dir,
                output_subdir=output_subdir,
                bins=bins,
            )
        except Exception as exc:  # pragma: no cover - surfaced through stdout and exit code
            skipped.append(
                {
                    "problem_dir": str(problem_dir),
                    "reason": str(exc),
                }
            )
            continue
        processed.append(
            {
                "problem_dir": artifacts.problem_dir,
                "output_dir": artifacts.output_dir,
                "success_count": artifacts.success_count,
                "generation_count": len(artifacts.generations),
                "centroid_count": artifacts.centroid_count,
            }
        )
    return processed, skipped


def discover_cvt_problem_dirs(run_root: Path) -> list[Path]:
    problem_dirs: list[Path] = []
    for centroids_path in sorted(run_root.rglob("centroids.json")):
        problem_dir = centroids_path.parent
        if not _is_cvt_problem_dir(problem_dir):
            continue
        problem_dirs.append(problem_dir)
    return problem_dirs


def _is_cvt_problem_dir(problem_dir: Path) -> bool:
    payload = _load_json_dict(problem_dir / "archive_space.json")
    if payload is None:
        return False
    return payload.get("archive_type") == "cvt"


def _load_json_dict(path: Path) -> dict[str, Any] | None:
    if not path.is_file():
        return None
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None
    if not isinstance(payload, dict):
        return None
    return payload


if __name__ == "__main__":
    raise SystemExit(main())
