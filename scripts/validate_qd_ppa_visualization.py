#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import importlib
import json
import math
import os
from pathlib import Path
import sys
from typing import Any

import yaml

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

from revolution.qd.ppa_visualization_metrics import (  # noqa: E402
    active_objective_keys,
    dominates_values,
    pareto_ranks,
)


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_subset(config_path: Path | None) -> set[str]:
    if config_path is None:
        return set()
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    items = payload["selected_problems"]
    assert isinstance(items, list)
    return {f"{item['benchmark']}/{item['problem']}" for item in items}


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_viewer(
    *,
    viewer_root: Path,
    subset_config: Path | None,
    strict: bool,
    allow_cdn: bool,
    run_playwright: bool,
) -> list[str]:
    errors: list[str] = []
    manifest_path = viewer_root / "manifest.json"
    html_path = viewer_root / "index.html"
    if not manifest_path.is_file():
        return ["missing manifest.json"]
    if not html_path.is_file():
        return ["missing index.html"]
    manifest = _load_json(manifest_path)
    if manifest.get("schema_version") != "qd_ppa_viewer.v1":
        errors.append("manifest schema_version is not qd_ppa_viewer.v1")
    defaults = manifest.get("viewer_defaults", {})
    if defaults.get("coordinate_mode") != "raw":
        errors.append("coordinate mode default is not raw")
    if defaults.get("coordinate_modes") != ["raw", "improvement", "normalized"]:
        errors.append("coordinate mode order is not raw | improvement | normalized")
    if defaults.get("rank_scope") != "per_technique":
        errors.append("rank scope default is not per_technique")
    if defaults.get("sample_universe") != "all_ppa_valid":
        errors.append("sample universe default is not all_ppa_valid")

    subset_keys = _load_subset(subset_config)
    manifest_keys = {problem["problem_key"] for problem in manifest.get("problems", [])}
    missing_subset = sorted(subset_keys - manifest_keys)
    if missing_subset:
        errors.append(f"manifest missing subset problems: {missing_subset}")

    html = html_path.read_text(encoding="utf-8")
    if strict and not allow_cdn and ("http://" in html or "https://" in html):
        errors.append("strict HTML references network assets")
    required_tokens = (
        "problemSelect",
        "techniqueASelect",
        "techniqueBSelect",
        "singleModeBtn",
        "compareModeBtn",
        "timelineSlider",
        "finalSnapshotBtn",
        "raw",
        "improvement",
        "normalized",
        "rank-scope",
        "sampleUniverseSelect",
        "rankFilterSelect",
        "perspectiveLockBtn",
        "autoRotateBtn",
        "explodeLayersBtn",
        "resetBtn",
        "scatterLegend",
        "mode_global_pareto_member",
        "viewer_pooled_pareto_member",
        "axis-detail",
        "cutoffs",
        "z-slice layers",
        "exploded layer",
    )
    for token in required_tokens:
        if token not in html:
            errors.append(f"HTML missing required control/token: {token}")

    for problem in manifest.get("problems", []):
        dataset_path = viewer_root / problem["dataset_path"]
        if not dataset_path.is_file():
            errors.append(f"missing dataset: {problem['dataset_path']}")
            continue
        dataset = _load_json(dataset_path)
        errors.extend(_validate_dataset(dataset, viewer_root=viewer_root, strict=strict))

    if run_playwright:
        errors.extend(_playwright_smoke(viewer_root))

    _write_validation(viewer_root, errors)
    return errors


def _validate_dataset(dataset: dict[str, Any], *, viewer_root: Path, strict: bool) -> list[str]:
    errors: list[str] = []
    if dataset.get("schema_version") != "qd_ppa_problem.v1":
        return [f"{dataset.get('benchmark')}/{dataset.get('problem')} schema mismatch"]
    circuit_type = str(dataset["circuit_type"])
    objective_keys = active_objective_keys(circuit_type)
    samples = dataset["samples"]
    assert isinstance(samples, list)
    if not samples:
        errors.append(_prefix(dataset, "dataset has no samples"))
        return errors
    for sample in samples:
        errors.extend(_validate_sample(dataset, sample, objective_keys))
    for step in [str(step) for step in dataset["steps"]]:
        errors.extend(_validate_step_ranks(dataset, samples, step, objective_keys))
        errors.extend(_validate_step_hypervolume(dataset, step))
    errors.extend(_validate_projection(dataset, strict=strict))
    errors.extend(_validate_source_hashes(dataset))
    return errors


def _validate_sample(
    dataset: dict[str, Any],
    sample: dict[str, Any],
    objective_keys: tuple[str, ...],
) -> list[str]:
    errors: list[str] = []
    required = (
        "sample_id",
        "technique",
        "generation",
        "status",
        "candidate_id",
        "area",
        "power",
        "g_A",
        "g_P",
        "pareto_rank_by_step",
        "archive_projection_status",
    )
    for key in required:
        if key not in sample:
            errors.append(_prefix(dataset, f"sample missing {key}: {sample.get('sample_id')}"))
    if sample.get("status") != "ppa_valid":
        errors.append(_prefix(dataset, "non-PPA-valid sample exported"))
    for key in objective_keys:
        value = sample.get(key)
        if value is None or not math.isfinite(float(value)):
            errors.append(_prefix(dataset, f"sample missing finite objective {key}: {sample.get('sample_id')}"))
    if sample.get("archive_projection_status") == "missing_descriptors" and sample.get("archive_cell_id") is not None:
        errors.append(_prefix(dataset, "missing descriptor sample has archive cell"))
    return errors


def _validate_step_ranks(
    dataset: dict[str, Any],
    samples: list[dict[str, Any]],
    step: str,
    objective_keys: tuple[str, ...],
) -> list[str]:
    errors: list[str] = []
    visible = _visible(samples, step)
    by_technique: dict[str, list[dict[str, Any]]] = {}
    for sample in visible:
        by_technique.setdefault(str(sample["technique"]), []).append(sample)
    for technique, technique_samples in by_technique.items():
        expected = pareto_ranks(technique_samples, objective_keys)
        observed = {
            sample["sample_id"]: sample["pareto_rank_by_step"]["per_technique"][step]
            for sample in technique_samples
        }
        if observed != expected:
            errors.append(_prefix(dataset, f"per-technique ranks mismatch for {technique} step {step}"))
        errors.extend(_check_contiguous(dataset, observed.values(), f"{technique} step {step}"))
        errors.extend(_check_rank_zero(dataset, technique_samples, observed, objective_keys, f"{technique} step {step}"))
    if visible:
        expected = pareto_ranks(visible, objective_keys)
        observed = {
            sample["sample_id"]: sample["pareto_rank_by_step"]["pooled_visible"][step]
            for sample in visible
        }
        if observed != expected:
            errors.append(_prefix(dataset, f"pooled-visible ranks mismatch step {step}"))
        errors.extend(_check_contiguous(dataset, observed.values(), f"pooled step {step}"))
        errors.extend(_check_rank_zero(dataset, visible, observed, objective_keys, f"pooled step {step}"))
    return errors


def _validate_step_hypervolume(dataset: dict[str, Any], step: str) -> list[str]:
    errors: list[str] = []
    stats = dataset["technique_stats_by_step"][step]
    for technique, payload in stats.items():
        hv = payload["hypervolume"]
        value = hv["value"]
        if value is None or not math.isfinite(float(value)) or float(value) < 0.0:
            errors.append(_prefix(dataset, f"invalid hypervolume for {technique} step {step}"))
        method = hv.get("method")
        if method not in ("exact_recursive", "deterministic_monte_carlo"):
            errors.append(_prefix(dataset, f"hypervolume missing accepted method for {technique} step {step}"))
        if method == "deterministic_monte_carlo" and (
            hv.get("seed") is None or hv.get("sample_count") is None
        ):
            errors.append(_prefix(dataset, f"Monte Carlo hypervolume missing metadata for {technique} step {step}"))
        if "reference_point" not in hv:
            errors.append(_prefix(dataset, f"hypervolume missing reference point for {technique} step {step}"))
    return errors


def _validate_projection(dataset: dict[str, Any], *, strict: bool) -> list[str]:
    errors: list[str] = []
    samples = dataset["samples"]
    for step, tech_cells in dataset["cell_summaries_by_step"].items():
        for cells in tech_cells.values():
            for cell in cells.values():
                for sample_id in cell["sample_ids"]:
                    sample = next(item for item in samples if item["sample_id"] == sample_id)
                    if sample["archive_projection_status"] == "missing_descriptors":
                        errors.append(_prefix(dataset, f"missing descriptor sample appears in occupancy at {step}"))
    archive = dataset["archive_definition"]
    if (
        strict
        and archive["archive_type"] == "grid_quantile"
        and bool(archive.get("initialized", False))
    ):
        classic = [sample for sample in samples if sample["technique"] == "classic"]
        if classic:
            projected = [
                sample
                for sample in classic
                if sample["archive_projection_status"] != "missing_descriptors"
            ]
            coverage = len(projected) / len(classic)
            if coverage < 0.95:
                errors.append(_prefix(dataset, f"classic projection coverage below 95%: {coverage:.3f}"))
    if archive["archive_type"] == "cvt":
        projection = dataset["archive_projection"]
        axes = archive["axes"]
        if len(axes) <= 3 and projection.get("rendering") != "true_centroid":
            errors.append(_prefix(dataset, "cvt <=3D does not use true centroid rendering metadata"))
        if len(axes) > 3 and not projection.get("disclaimer"):
            errors.append(_prefix(dataset, "cvt >3D missing projection disclaimer"))
    return errors


def _validate_source_hashes(dataset: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    for name, recorded in dataset.get("source_artifacts", {}).items():
        path = Path(recorded["path"])
        if not path.is_file():
            errors.append(_prefix(dataset, f"source artifact missing: {name}"))
            continue
        if recorded["sha256"] != _sha256(path):
            errors.append(_prefix(dataset, f"source artifact hash stale: {name}"))
    return errors


def _visible(samples: list[dict[str, Any]], step: str) -> list[dict[str, Any]]:
    if step == "final":
        return list(samples)
    generation = int(step)
    return [sample for sample in samples if int(sample["generation"]) <= generation]


def _check_contiguous(dataset: dict[str, Any], ranks: Any, label: str) -> list[str]:
    values = sorted(set(int(rank) for rank in ranks))
    if not values:
        return []
    expected = list(range(max(values) + 1))
    if values != expected:
        return [_prefix(dataset, f"ranks not contiguous for {label}: {values}")]
    return []


def _check_rank_zero(
    dataset: dict[str, Any],
    samples: list[dict[str, Any]],
    ranks: dict[str, int],
    objective_keys: tuple[str, ...],
    label: str,
) -> list[str]:
    errors: list[str] = []
    values = {
        sample["sample_id"]: {key: float(sample[key]) for key in objective_keys}
        for sample in samples
    }
    for sample in samples:
        if ranks[sample["sample_id"]] != 0:
            continue
        if any(
            other_id != sample["sample_id"]
            and dominates_values(other, values[sample["sample_id"]], objective_keys)
            for other_id, other in values.items()
        ):
            errors.append(_prefix(dataset, f"rank-0 sample dominated for {label}"))
    return errors


def _playwright_smoke(viewer_root: Path) -> list[str]:
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        return ["Playwright is not installed"]
    errors: list[str] = []
    screenshot_dir = viewer_root / "screenshots"
    screenshot_dir.mkdir(parents=True, exist_ok=True)
    manifest = _load_json(viewer_root / "manifest.json")
    problems = manifest["problems"]
    assert isinstance(problems, list) and problems
    combinational = next(
        problem["problem_key"]
        for problem in problems
        if problem["circuit_type"] == "combinational"
    )
    sequential = next(
        problem["problem_key"]
        for problem in problems
        if problem["circuit_type"] == "sequential"
    )
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch()
            page = browser.new_page(viewport={"width": 1440, "height": 900})
            page.goto((viewer_root / "index.html").resolve().as_uri())
            page.wait_for_selector("#ppaCanvas")
            _viewer_screenshot(page, screenshot_dir, errors, "single_classic")
            page.click("#singleModeBtn")
            page.select_option("#techniqueASelect", "classic")
            _viewer_screenshot(page, screenshot_dir, errors, "single_classic")
            page.select_option("#techniqueASelect", "grid_quantile_pareto_journal_bd")
            _viewer_screenshot(page, screenshot_dir, errors, "single_qd")
            page.click("#compareModeBtn")
            page.select_option("#techniqueASelect", "classic")
            page.select_option("#techniqueBSelect", "grid_quantile_pareto_journal_bd")
            _viewer_screenshot(page, screenshot_dir, errors, "compare_classic_qd")
            page.click("#perspectiveLockBtn")
            _viewer_screenshot(page, screenshot_dir, errors, "locked")
            page.select_option("#problemSelect", combinational)
            _viewer_screenshot(page, screenshot_dir, errors, "combinational_2d")
            page.select_option("#problemSelect", sequential)
            _viewer_screenshot(page, screenshot_dir, errors, "sequential_3d")
            page.select_option("#rankFilterSelect", "0")
            _viewer_screenshot(page, screenshot_dir, errors, "rank0")
            page.click("[data-rank-scope='pooled_visible']")
            _viewer_screenshot(page, screenshot_dir, errors, "pooled_visible")
            page.click("#explodeLayersBtn")
            _viewer_screenshot(page, screenshot_dir, errors, "exploded_layers")
            browser.close()
    except Exception as exc:
        errors.append(f"Playwright smoke failed: {exc}")
    return errors


def _viewer_screenshot(page: Any, screenshot_dir: Path, errors: list[str], name: str) -> None:
    path = screenshot_dir / f"{name}.png"
    page.screenshot(path=str(path), full_page=True)
    if path.stat().st_size <= 20_000:
        errors.append(f"Playwright screenshot too small: {path.name}")
    if _pixel_variance(path) <= 0.0001:
        errors.append(f"Playwright screenshot blank: {path.name}")


def _pixel_variance(path: Path) -> float:
    mpimg = importlib.import_module("matplotlib.image")
    np = importlib.import_module("numpy")
    image = mpimg.imread(path)
    return float(np.var(image))


def _write_validation(viewer_root: Path, errors: list[str]) -> None:
    payload = {
        "status": "passed" if not errors else "failed",
        "error_count": len(errors),
        "errors": errors,
    }
    (viewer_root / "validation.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
    lines = ["# QD/PPA Viewer Validation", "", f"Status: **{payload['status']}**", ""]
    if errors:
        lines.extend(f"- {error}" for error in errors)
    else:
        lines.append("All checks passed.")
    (viewer_root / "validation.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def _prefix(dataset: dict[str, Any], message: str) -> str:
    return f"{dataset['benchmark']}/{dataset['problem']}: {message}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a QD/PPA viewer export.")
    parser.add_argument("--viewer-root", type=Path, required=True)
    parser.add_argument("--subset-config", type=Path)
    parser.add_argument("--strict", action="store_true")
    parser.add_argument("--allow-cdn", action="store_true")
    parser.add_argument("--playwright", action="store_true")
    args = parser.parse_args()
    errors = validate_viewer(
        viewer_root=args.viewer_root.resolve(),
        subset_config=args.subset_config.resolve() if args.subset_config else None,
        strict=bool(args.strict),
        allow_cdn=bool(args.allow_cdn),
        run_playwright=bool(args.playwright),
    )
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("QD/PPA viewer validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
