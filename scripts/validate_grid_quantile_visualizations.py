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


def _csv_cell_ids(path: Path) -> list[str]:
    with path.open(encoding="utf-8", newline="") as handle:
        return sorted(row["cell_id"] for row in csv.DictReader(handle))


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
    html_path = problem_root / "grid_quantile_occupancy_evolution.html"
    data_path = _artifact_path(problem_root, manifest.get("data_file", ""))
    data = _load_json(data_path) if data_path.is_file() else {}
    history_len = _history_count(history_path)
    expected_frames = history_len + 1
    if manifest["frame_count"] != len(frame_paths):
        errors.append("manifest frame_count does not match frame list")
    if len(frame_paths) != expected_frames:
        errors.append("frame count does not include one clean final frame")
    if manifest.get("timeline_frame_count") != expected_frames:
        errors.append("timeline frame count does not include one clean final frame")
    if manifest.get("history_frame_count") != history_len:
        errors.append("manifest history_frame_count does not match archive_history.jsonl")
    if not manifest.get("has_clean_final_frame"):
        errors.append("missing clean final visualization frame")
    if manifest["effective_shape"] != summary.get("effective_shape", []):
        errors.append("manifest effective_shape does not match summary")
    if manifest["occupied_cells"] != summary["occupied_cells"]:
        errors.append("manifest occupied_cells does not match summary")
    if _csv_count(cells_path) != summary["occupied_cells"]:
        errors.append("archive_cells.csv row count does not match summary")
    if sorted(manifest.get("final_cell_ids", [])) != _csv_cell_ids(cells_path):
        errors.append("manifest final_cell_ids do not match archive_cells.csv")
    if not data:
        errors.append("missing grid_quantile_evolution_data.json")
    elif len(data.get("frames", [])) != expected_frames:
        errors.append("evolution data frame count does not include clean final frame")
    elif not data["frames"][-1].get("final_clean_frame"):
        errors.append("evolution data final frame is not marked clean")
    elif data["frames"][-1].get("changed_cell_ids"):
        errors.append("clean final frame still has changed cells")

    history = [
        json.loads(line)
        for line in history_path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    occupied_sequence = [int(snapshot["occupied_cells"]) for snapshot in history]
    cell_count_sequence = manifest.get("cell_count_sequence", [])
    if cell_count_sequence[:history_len] != occupied_sequence:
        errors.append("manifest cell_count_sequence does not match history")
    if cell_count_sequence[-1:] != occupied_sequence[-1:]:
        errors.append("clean final frame cell count does not match final history")
    sample_sequence = manifest.get("sample_count_sequence", [])
    if any(rhs < lhs for lhs, rhs in zip(sample_sequence, sample_sequence[1:])):
        errors.append("sample_count_sequence decreases")
    if len(history) > 1 and not manifest.get("animation_checks", {}).get("has_state_progression"):
        errors.append("animation has no state progression")

    axes = [axis["name"] for axis in space["axes"]]
    if {"logic_depth", "ff_depth", "comb_width_log"}.issubset(axes):
        layout = manifest.get("axis_layout", {})
        if layout.get("x") != "logic_depth" or layout.get("y") != "comb_width_log":
            errors.append("journal axis layout does not keep logic/width on x/y")
        if layout.get("z") != "ff_depth":
            errors.append("journal axis layout does not keep ff_depth on z")
    active_axes = sum(1 for bins in space.get("effective_shape", []) if int(bins) > 1)
    expected_mode = "3d" if active_axes == 3 else "2d" if active_axes == 2 else "skipped"
    if manifest.get("visualization_mode") != expected_mode:
        errors.append("manifest visualization_mode does not match active axes")

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
    if not html_path.is_file():
        errors.append("missing interactive HTML")
    else:
        html = html_path.read_text(encoding="utf-8").lower()
        if "http://" in html or "https://" in html or "cdn" in html:
            errors.append("interactive HTML references network assets")
        required_tokens = (
            "genval",
            "covval",
            "bestval",
            "meanval",
            "sampval",
            "slicesgrid",
            "slice-layer",
            "z-slice layers",
            "flex-direction: column",
            "spinbtn",
            "statssizebtn",
            "drawaxisguides",
            "drawsamplemarker",
            "drawboundarytick",
            "drawaxisboundarylabels",
            "bd axes",
            "axis-desc",
            "axisdetailbtn",
            "details-open",
            "axisboundaries",
            "axis-detail",
            "axis-bins",
            "cutoffs",
            "intervaltext",
            "fitness",
            "gradient",
        )
        for token in required_tokens:
            if token not in html:
                errors.append(f"interactive HTML missing {token}")
        hidden_tokens = (
            "#legend { display: none",
            "#axisinfo { display: none",
            "#slices { display: none",
            "#title, #legend, #axisinfo, #slices { display: none",
        )
        for token in hidden_tokens:
            if token in html:
                errors.append(f"interactive HTML hides required panel: {token}")

    source_artifacts = manifest.get("source_artifacts", {})
    source_mtime = 0
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
        source_mtime = max(source_mtime, path.stat().st_mtime_ns)
    for output_path in [manifest_path, html_path, data_path, *frame_paths]:
        if output_path.is_file() and output_path.stat().st_mtime_ns < source_mtime:
            errors.append(f"stale generated output: {output_path.name}")

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
