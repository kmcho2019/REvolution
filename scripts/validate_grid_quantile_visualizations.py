#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import hashlib
import importlib
import json
from pathlib import Path
from typing import Any


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _history_count(path: Path) -> int:
    return sum(1 for line in path.read_text(encoding="utf-8").splitlines() if line.strip())


def _csv_count(path: Path) -> int:
    with path.open(encoding="utf-8", newline="") as handle:
        return sum(1 for _ in csv.DictReader(handle))


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _pixel_variance(path: Path) -> float:
    mpimg = importlib.import_module("matplotlib.image")
    np = importlib.import_module("numpy")
    image = mpimg.imread(path)
    return float(np.var(image))


def _artifact_path(problem_root: Path, raw_path: str) -> Path:
    path = Path(raw_path)
    if path.is_absolute() or path.is_file():
        return path
    return problem_root / path


def validate_problem(problem_root: Path) -> list[str]:
    errors: list[str] = []
    manifest_path = problem_root / "grid_quantile_visualization_manifest.json"
    history_path = problem_root / "archive_history.jsonl"
    space_path = problem_root / "archive_space.json"
    cells_path = problem_root / "archive_cells.csv"
    summary_path = problem_root / "archive_summary.json"

    for path in (manifest_path, history_path, space_path, cells_path, summary_path):
        if not path.is_file():
            errors.append(f"missing {path.name}")
    if errors:
        return errors

    manifest = _load_json(manifest_path)
    space = _load_json(space_path)
    summary = _load_json(summary_path)
    assert space["archive_type"] == "grid_quantile"

    frame_paths = [_artifact_path(problem_root, path) for path in manifest["frames"]]
    if manifest["frame_count"] != len(frame_paths):
        errors.append("manifest frame_count does not match frame list")
    if len(frame_paths) != _history_count(history_path):
        errors.append("frame count does not match archive_history.jsonl")
    if manifest["effective_shape"] != summary.get("effective_shape", []):
        errors.append("manifest effective_shape does not match summary")
    if manifest["occupied_cells"] != summary["occupied_cells"]:
        errors.append("manifest occupied_cells does not match summary")
    if _csv_count(cells_path) != summary["occupied_cells"]:
        errors.append("archive_cells.csv row count does not match summary")

    if manifest.get("webm") is None and not manifest.get("encoder_warning"):
        errors.append("missing WebM and missing encoder warning")
    for frame_path in frame_paths:
        if not frame_path.is_file():
            errors.append(f"missing frame {frame_path}")
            continue
        if frame_path.stat().st_size <= 10 * 1024:
            errors.append(f"frame too small: {frame_path}")
        if _pixel_variance(frame_path) <= 0.0001:
            errors.append(f"blank frame: {frame_path}")

    source_artifacts = manifest.get("source_artifacts", {})
    for name, path in {
        "archive_history.jsonl": history_path,
        "archive_space.json": space_path,
        "archive_cells.csv": cells_path,
    }.items():
        recorded = source_artifacts.get(name)
        if not isinstance(recorded, dict):
            errors.append(f"missing source hash for {name}")
            continue
        if recorded.get("sha256") != _sha256(path):
            errors.append(f"stale source hash for {name}")
        if int(recorded.get("mtime_ns", 0)) != path.stat().st_mtime_ns:
            errors.append(f"stale source mtime for {name}")

    return errors


def _problem_roots(run_root: Path) -> list[Path]:
    manifests = run_root.rglob("grid_quantile_visualization_manifest.json")
    return sorted(path.parent for path in manifests)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate grid_quantile visualization artifacts.",
    )
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=None)
    args = parser.parse_args()

    results = []
    for problem_root in _problem_roots(args.run_root):
        errors = validate_problem(problem_root)
        results.append(
            {
                "problem_root": str(problem_root),
                "status": "invalid" if errors else "valid",
                "errors": errors,
            }
        )

    payload = {
        "run_root": str(args.run_root),
        "problem_count": len(results),
        "invalid_count": sum(1 for item in results if item["status"] == "invalid"),
        "results": results,
    }
    if args.output is not None:
        args.output.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    else:
        print(json.dumps(payload, indent=2))
    return 1 if payload["invalid_count"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
