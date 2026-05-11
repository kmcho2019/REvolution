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


STRICT_VISUAL_CASES: tuple[tuple[str, str, str, str], ...] = (
    ("sequential_ppa_3d", "RTLLM/Prob015_multi_pipe_8bit", "ppa", "3d"),
    ("sequential_archive_3d", "VerilogEval-Spec-to-RTL/Prob151_review2015_fsm", "archive", "3d"),
    ("combinational_ppa_2d", "RTLLM/Prob004_adder_8bit", "ppa", "2d"),
    ("combinational_projected_archive", "VerilogEval-Spec-to-RTL/Prob135_m2014_q6b", "archive", "2d_slab"),
)


REFERENCE_SCREENSHOTS: tuple[tuple[str, Path], ...] = (
    ("demo_v4", Path("exp/visualization_reference_screenshots/demo_v4_1440x1000.png")),
    ("baseline_prob151", Path("exp/visualization_reference_screenshots/existing_grid_quantile_prob151_1440x1000.png")),
    ("baseline_prob135", Path("exp/visualization_reference_screenshots/existing_grid_quantile_prob135_1440x1000.png")),
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
    if manifest.get("schema_version") != "qd_ppa_viewer.v2":
        errors.append("manifest schema_version is not qd_ppa_viewer.v2")
    defaults = manifest.get("viewer_defaults", {})
    if defaults.get("coordinate_mode") != "raw":
        errors.append("coordinate mode default is not raw")
    if defaults.get("coordinate_modes") != ["raw", "improvement", "normalized"]:
        errors.append("coordinate mode order is not raw | improvement | normalized")
    if defaults.get("ppa_scale_mode") != "current":
        errors.append("PPA scale default is not current")
    if defaults.get("ppa_scale_modes") != ["current", "final"]:
        errors.append("PPA scale mode order is not current | final")
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
        "rankScopeSelect",
        "sampleUniverseSelect",
        "rankFilterSelect",
        "rankGuideMethodSelect",
        "rankGuideColorSelect",
        "projectedRankGuidesSelect",
        "data-ppa-scale=\"current\"",
        "data-ppa-scale=\"final\"",
        "setPpaScaleMode",
        "colorModeSelect",
        "color-quick",
        "rank-guide",
        "ppaLegend",
        "perspectiveLockBtn",
        "autoRotateBtn",
        "explodeLayersBtn",
        "resetBtn",
        "mode_global_pareto_member",
        "viewer_pooled_pareto_member",
        "axisDetail",
        "cutoffs",
        "Z-slice layers",
        "exploded_layers",
    )
    for token in required_tokens:
        if token not in html:
            errors.append(f"HTML missing required control/token: {token}")
    if strict:
        errors.extend(_validate_html_scene_contract(html))

    for problem in manifest.get("problems", []):
        dataset_path = viewer_root / problem["dataset_path"]
        if not dataset_path.is_file():
            errors.append(f"missing dataset: {problem['dataset_path']}")
            continue
        dataset = _load_json(dataset_path)
        errors.extend(_validate_dataset(dataset, viewer_root=viewer_root, strict=strict))

    if run_playwright:
        errors.extend(_playwright_smoke(viewer_root, strict=strict))

    _write_validation(viewer_root, errors)
    return errors


def _validate_html_scene_contract(html: str) -> list[str]:
    errors: list[str] = []
    required_tokens = (
        "__QD_PPA_VIEWER_DEBUG__",
        "qd_ppa_viewer_debug.v2",
        "custom_scene_canvas",
        "scene_type: 'archive'",
        "scene_type: 'ppa'",
        "dimensionality: '3d'",
        "dimensionality: '2d'",
        "drawArchive(",
        "drawPpa3d(",
        "drawPpa2d(",
        "drawPpaFrame3d(",
        "drawPpaShadedPoint(",
        "drawPpaSampleAxisTicks3d(",
        "drawPpaRankGuides2d(",
        "drawPpaRankGuides3d(",
        "effectiveRankGuideMode(",
        "effectiveRankGuideMethodName(",
        "effectiveRankGuideColorScheme(",
        "projectedRankGuideOverlayEnabled(",
        "rankGuideSamples(",
        "frontEnvelope2d(",
        "pchipGuide2d(",
        "smooth2dGuide(",
        "delaunayTriangles2d(",
        "drawDelaunayMesh(",
        "drawRankGuideVertices(",
        "techniqueShapeLegend(",
        "layerCellTooltip(",
        "showTooltip(",
        "ppaReferenceCoord(",
        "sampleAxisLabels(",
        "reference_visible:",
        "fitness_shaded:",
        "fitness_palette:",
        "point_glyph_mode:",
        "linked_fade_mode:",
        "makeProjector(",
        "rotatePoint(",
        "hoverFirstArchiveCell",
        "hoverFirstArchiveSample",
        "hoverFirstLayerCell",
        "hoverFirstPpaPoint",
        "setColorMode",
        "setRankGuideMode",
        "setRankGuideMethod",
        "setRankGuideColorScheme",
        "setProjectedRankGuides",
        "setPpaScaleMode",
        "ppaScaleLimits(",
        "ppaScaleSamples(",
        "ppa_scale_mode:",
        "ppa_scale_step:",
        "ppa_scale_rank_filter:",
        "ppa_limits:",
        "rankColor(",
        "rankRadius(",
        "fitnessRange(",
        "viridisColor(",
        "techniqueRadiusScale(",
        "referenceAxisLabels(",
        "highlighted_sample_ids",
        "highlighted_cell_id",
        "color_mode:",
        "rank_guide_mode:",
        "rank_guide_method:",
        "rank_guide_color_scheme:",
        "rank_guide_count:",
        "rank_guide_projection_mode:",
        "rank_guide_signature:",
        "rank_guide_surface_mode:",
        "rank_guide_triangle_count:",
        "rank_guide_projected_overlay:",
        "rank_guide_projected_count:",
        "rank_guide_projected_vertex_count:",
        "rank_guide_projected_vertex_shapes:",
        "rank_radius_preview:",
        "technique_radius_preview:",
        "reference_axis_labels:",
        "hovered_sample_axis_labels:",
        "reference_tooltip_preview:",
        "camera:",
        "z_range:",
        "visible_layer_count:",
        "advancedPanel",
    )
    for token in required_tokens:
        if token not in html:
            errors.append(f"strict HTML missing scene/debug contract token: {token}")
    if "getContext('2d')" in html and "drawPpa3d(" not in html:
        errors.append("strict HTML looks like a flat 2D-only canvas viewer")
    return errors


def _validate_dataset(dataset: dict[str, Any], *, viewer_root: Path, strict: bool) -> list[str]:
    errors: list[str] = []
    if dataset.get("schema_version") != "qd_ppa_problem.v2":
        return [f"{dataset.get('benchmark')}/{dataset.get('problem')} schema mismatch"]
    circuit_type = str(dataset["circuit_type"])
    objective_keys = active_objective_keys(circuit_type)
    samples = dataset["samples"]
    assert isinstance(samples, list)
    defaults = dataset.get("viewer_defaults", {})
    if defaults.get("ppa_scale_modes") != ["current", "final"]:
        errors.append(_prefix(dataset, "dataset PPA scale mode order is not current | final"))
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
        errors.extend(_check_rank_one(dataset, technique_samples, observed, objective_keys, f"{technique} step {step}"))
    if visible:
        expected = pareto_ranks(visible, objective_keys)
        observed = {
            sample["sample_id"]: sample["pareto_rank_by_step"]["pooled_visible"][step]
            for sample in visible
        }
        if observed != expected:
            errors.append(_prefix(dataset, f"pooled-visible ranks mismatch step {step}"))
        errors.extend(_check_contiguous(dataset, observed.values(), f"pooled step {step}"))
        errors.extend(_check_rank_one(dataset, visible, observed, objective_keys, f"pooled step {step}"))
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
    expected = list(range(1, max(values) + 1))
    if values != expected:
        return [_prefix(dataset, f"ranks not contiguous for {label}: {values}")]
    return []


def _check_rank_one(
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
        if ranks[sample["sample_id"]] != 1:
            continue
        if any(
            other_id != sample["sample_id"]
            and dominates_values(other, values[sample["sample_id"]], objective_keys)
            for other_id, other in values.items()
        ):
            errors.append(_prefix(dataset, f"rank-1 sample dominated for {label}"))
    return errors


def _playwright_smoke(viewer_root: Path, *, strict: bool) -> list[str]:
    try:
        from playwright.sync_api import sync_playwright  # type: ignore[reportMissingImports]
    except ImportError:
        return ["Playwright is not installed"]
    errors: list[str] = []
    report_lines = _visual_report_header()
    screenshot_dir = viewer_root / "screenshots"
    screenshot_dir.mkdir(parents=True, exist_ok=True)
    for screenshot in screenshot_dir.glob("*.png"):
        screenshot.unlink()
    manifest = _load_json(viewer_root / "manifest.json")
    problems = manifest["problems"]
    assert isinstance(problems, list) and problems
    problem_keys = {str(problem["problem_key"]) for problem in problems}
    combinational = next(
        (problem["problem_key"] for problem in problems if problem["circuit_type"] == "combinational"),
        None,
    )
    sequential = next(
        (problem["problem_key"] for problem in problems if problem["circuit_type"] == "sequential"),
        None,
    )
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch()
            page = browser.new_page(viewport={"width": 1440, "height": 1000})
            console_errors: list[str] = []
            page_errors: list[str] = []
            failed_requests: list[str] = []
            network_requests: list[str] = []
            page.on(
                "console",
                lambda message: console_errors.append(message.text) if message.type == "error" else None,
            )
            page.on("pageerror", lambda exc: page_errors.append(str(exc)))
            page.on("requestfailed", lambda request: failed_requests.append(request.url))
            page.on(
                "request",
                lambda request: network_requests.append(request.url)
                if request.url.startswith(("http://", "https://"))
                else None,
            )
            page.goto((viewer_root / "index.html").resolve().as_uri())
            page.wait_for_selector("#ppaCanvas")
            page.wait_for_function(
                "window.__QD_PPA_VIEWER_DEBUG__"
                " && window.__QD_PPA_VIEWER_DEBUG__.getState().schema === 'qd_ppa_viewer_debug.v2'"
            )
            _assert_runtime_contract(page, errors, "initial")
            _assert_default_layout(page, errors)
            _assert_auto_rotate(page, errors)
            if "classic" in _option_values(page, "#techniqueASelect"):
                page.click("#singleModeBtn")
                page.select_option("#techniqueASelect", "classic")
                _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "single_classic"))
            if "grid_quantile_pareto_journal_bd" in _option_values(page, "#techniqueASelect"):
                page.select_option("#techniqueASelect", "grid_quantile_pareto_journal_bd")
                _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "single_qd"))
            _select_compare(page, "classic", "grid_quantile_pareto_journal_bd", errors)
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "compare_classic_qd"))
            _assert_color_modes(page, screenshot_dir, errors, report_lines)
            if _debug_state(page).get("circuit_type") == "sequential":
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="rank_guides_3d_mesh_le2",
                    mode="2",
                    method="auto",
                    color_scheme="auto",
                    projected_overlay="off",
                    expected_method="delaunay_mesh_3d",
                    expected_color_scheme="rank",
                    expected_projection="3d_delaunay_mesh",
                    expected_surface="delaunay_mesh_3d",
                    require_mesh=True,
                    require_projected_overlay=False,
                    require_compare_techniques=True,
                )
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="rank_guides_3d_projected_le2",
                    mode="2",
                    method="projected_curves_3d",
                    color_scheme="technique",
                    projected_overlay="off",
                    expected_method="projected_curves_3d",
                    expected_color_scheme="technique",
                    expected_projection="3d_projected_curves",
                    expected_surface="none_projected_curves_only",
                    require_mesh=False,
                    require_projected_overlay=False,
                    require_compare_techniques=True,
                )
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="rank_guides_3d_mesh_projected_overlay",
                    mode="2",
                    method="auto",
                    color_scheme="rank",
                    projected_overlay="on",
                    expected_method="delaunay_mesh_3d",
                    expected_color_scheme="rank",
                    expected_projection="3d_delaunay_mesh",
                    expected_surface="delaunay_mesh_3d",
                    require_mesh=True,
                    require_projected_overlay=True,
                    require_compare_techniques=True,
                )
            _assert_rank_guides_disabled_outside_rank(page, errors)
            _assert_archive_hover_clears(page, errors)
            _assert_reference_hover(page, errors)
            _assert_ppa_scale_modes(page, screenshot_dir, errors, report_lines)
            for coordinate_mode in ("raw", "improvement", "normalized"):
                page.evaluate("mode => window.__QD_PPA_VIEWER_DEBUG__.setCoordinateMode(mode)", coordinate_mode)
                _assert_coordinate_mode(page, errors, coordinate_mode)
                scene = _debug_state(page).get("scenes", {}).get("ppa", {})
                if scene.get("rank_guide_mode") != "off":
                    if scene.get("rank_guide_coordinate_mode") != coordinate_mode:
                        errors.append(
                            "Playwright rank guide coordinate metadata did not follow "
                            f"{coordinate_mode}"
                        )
                    if int(scene.get("rank_guide_count", 0)) <= 0:
                        errors.append(f"Playwright rank guide count disappeared in {coordinate_mode} mode")
                _report_screenshot(
                    report_lines,
                    _viewer_screenshot(page, screenshot_dir, errors, f"coordinate_{coordinate_mode}"),
                )
            page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setCoordinateMode('raw')")
            if _debug_state(page).get("auto_rotate"):
                page.click("#autoRotateBtn")
            ppa_camera_before_lock = _debug_state(page).get("scenes", {}).get("ppa", {}).get("camera")
            page.click("#perspectiveLockBtn")
            _assert_locked_archive_cameras(page, errors, ppa_camera_before_lock)
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "locked"))
            if combinational is not None:
                page.evaluate("key => window.__QD_PPA_VIEWER_DEBUG__.setProblem(key)", combinational)
                _select_compare(page, "classic", "grid_quantile_pareto_journal_bd", errors)
                _assert_ppa_dimensionality(page, errors, label="combinational_2d", expected="2d")
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="combinational_2d_rank_guides_r1",
                    mode="1",
                    method="auto",
                    color_scheme="auto",
                    projected_overlay="off",
                    expected_method="pchip_2d",
                    expected_color_scheme="rank",
                    expected_projection="2d_line",
                    expected_surface="none",
                    require_mesh=False,
                    require_projected_overlay=False,
                    require_compare_techniques=False,
                )
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="combinational_2d_rank_guides_le2",
                    mode="2",
                    method="moving_average_trend",
                    color_scheme="rank",
                    projected_overlay="off",
                    expected_method="moving_average_trend",
                    expected_color_scheme="rank",
                    expected_projection="2d_line",
                    expected_surface="none",
                    require_mesh=False,
                    require_projected_overlay=False,
                    require_compare_techniques=True,
                )
                _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "combinational_2d"))
            if sequential is not None:
                page.evaluate("key => window.__QD_PPA_VIEWER_DEBUG__.setProblem(key)", sequential)
                _select_compare(page, "classic", "grid_quantile_pareto_journal_bd", errors)
                _assert_ppa_dimensionality(page, errors, label="sequential_3d", expected="3d")
                _assert_rank_guides(
                    page,
                    screenshot_dir,
                    errors,
                    report_lines,
                    label="sequential_3d_rank_guides_mesh",
                    mode="2",
                    method="auto",
                    color_scheme="auto",
                    projected_overlay="off",
                    expected_method="delaunay_mesh_3d",
                    expected_color_scheme="rank",
                    expected_projection="3d_delaunay_mesh",
                    expected_surface="delaunay_mesh_3d",
                    require_mesh=True,
                    require_projected_overlay=False,
                    require_compare_techniques=True,
                )
                _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "sequential_3d"))
            page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('1')")
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "rank1"))
            page.evaluate(
                "() => {"
                " document.getElementById('rankScopeSelect').value = 'pooled_visible';"
                " window.__QD_PPA_VIEWER_DEBUG__.setRankFilter("
                "   document.getElementById('rankFilterSelect').value"
                " );"
                "}"
            )
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "pooled_visible"))
            page.click("#explodeLayersBtn")
            state = _debug_state(page)
            if not state.get("exploded_layers"):
                errors.append("Playwright exploded layer toggle did not update debug state")
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "exploded_layers"))
            page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setAdvancedOpen(true)")
            state = _debug_state(page)
            if not state.get("advanced_open"):
                errors.append("Playwright advanced panel did not open")
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "advanced_open"))
            page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setAdvancedOpen(false)")
            problem_before_reset = _debug_state(page).get("problem_key")
            page.click("#resetBtn")
            _assert_reset_state(page, errors, problem_before_reset)
            _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "reset"))
            page.evaluate(
                "() => {"
                " document.getElementById('rankScopeSelect').value = 'per_technique';"
                " document.getElementById('sampleUniverseSelect').value = 'all_ppa_valid';"
                " window.__QD_PPA_VIEWER_DEBUG__.setCoordinateMode('raw');"
                " window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('all');"
                "}"
            )
            if strict:
                _strict_visual_matrix(page, problem_keys, screenshot_dir, errors, report_lines)
                if console_errors:
                    errors.extend(f"Playwright console error: {message}" for message in console_errors)
                if page_errors:
                    errors.extend(f"Playwright page error: {message}" for message in page_errors)
                if failed_requests:
                    errors.extend(f"Playwright request failed: {url}" for url in failed_requests)
                if network_requests:
                    errors.extend(f"Playwright strict mode made network request: {url}" for url in network_requests)
            browser.close()
    except Exception as exc:
        errors.append(f"Playwright smoke failed: {exc}")
    (viewer_root / "visual_parity_report.md").write_text("\n".join(report_lines) + "\n", encoding="utf-8")
    return errors


def _option_values(page: Any, selector: str) -> list[str]:
    return page.eval_on_selector_all(selector + " option", "(items) => items.map((item) => item.value)")


def _select_compare(page: Any, first: str, second: str, errors: list[str]) -> None:
    values = _option_values(page, "#techniqueASelect")
    if first not in values or second not in values:
        errors.append(f"Playwright compare techniques unavailable: {first}, {second}")
        return
    page.evaluate(
        "payload => window.__QD_PPA_VIEWER_DEBUG__.selectCompare(payload[0], payload[1])",
        [first, second],
    )


def _debug_state(page: Any) -> dict[str, Any]:
    state = page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.getState()")
    assert isinstance(state, dict)
    return state


def _assert_runtime_contract(page: Any, errors: list[str], label: str) -> None:
    state = _debug_state(page)
    if state.get("schema") != "qd_ppa_viewer_debug.v2":
        errors.append(f"{label}: debug schema mismatch")
    scenes = state.get("scenes", {})
    assert isinstance(scenes, dict)
    for scene_name in ("archiveA", "ppa"):
        scene = scenes.get(scene_name)
        if not isinstance(scene, dict):
            errors.append(f"{label}: missing debug scene {scene_name}")
            continue
        if scene.get("renderer") != "custom_scene_canvas":
            errors.append(f"{label}: {scene_name} does not report custom scene renderer")


def _assert_default_layout(page: Any, errors: list[str]) -> None:
    metrics = page.evaluate(
        "() => {"
        " const advanced = document.getElementById('advancedPanel');"
        " const advancedRect = advanced.getBoundingClientRect();"
        " const legend = document.getElementById('ppaLegend').getBoundingClientRect();"
        " const layout = document.getElementById('layout').getBoundingClientRect();"
        " const stats = document.querySelector('.bottom-stats').getBoundingClientRect();"
        " window.scrollTo(0, 9999);"
        " return {"
        "   advancedOpen: advanced.open,"
        "   advancedRect: {left: advancedRect.left, right: advancedRect.right, top: advancedRect.top, bottom: advancedRect.bottom},"
        "   legendRect: {left: legend.left, right: legend.right, top: legend.top, bottom: legend.bottom},"
        "   scrollY: window.scrollY,"
        "   innerHeight: window.innerHeight,"
        "   layoutTop: layout.top,"
        "   layoutBottom: layout.bottom,"
        "   statsBottom: stats.bottom"
        " };"
        "}"
    )
    assert isinstance(metrics, dict)
    if metrics.get("advancedOpen"):
        errors.append("Playwright default layout has advanced panel expanded")
    if int(metrics["scrollY"]) != 0:
        errors.append(f"Playwright default 1440x1000 layout is scrollable: scrollY={metrics['scrollY']}")
    if float(metrics["layoutTop"]) >= float(metrics["innerHeight"]) or float(metrics["statsBottom"]) <= 0:
        errors.append("Playwright default 1440x1000 layout panes are not visible")
    if _rects_overlap(metrics["advancedRect"], metrics["legendRect"]):
        errors.append("Playwright default layout overlaps the Advanced tab and PPA legend")


def _rects_overlap(first: dict[str, Any], second: dict[str, Any]) -> bool:
    return (
        float(first["left"]) < float(second["right"])
        and float(first["right"]) > float(second["left"])
        and float(first["top"]) < float(second["bottom"])
        and float(first["bottom"]) > float(second["top"])
    )


def _assert_coordinate_mode(page: Any, errors: list[str], expected: str) -> None:
    state = _debug_state(page)
    if state.get("coordinate_mode") != expected:
        errors.append(f"Playwright coordinate mode mismatch: expected {expected}, saw {state.get('coordinate_mode')}")


def _assert_ppa_scale_modes(
    page: Any,
    screenshot_dir: Path,
    errors: list[str],
    report_lines: list[str],
) -> None:
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setCoordinateMode('raw')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankGuideMode('off')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setPpaScaleMode('current')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('all')")
    _set_timeline_index(page, 0)
    current = _debug_state(page).get("scenes", {}).get("ppa", {})
    if current.get("ppa_scale_mode") != "current":
        errors.append(f"Playwright current PPA scale did not update scene metadata: {current.get('ppa_scale_mode')}")
    if current.get("ppa_scale_step") != _debug_state(page).get("step"):
        errors.append("Playwright current PPA scale step does not follow the timeline")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('1')")
    current_rank = _debug_state(page).get("scenes", {}).get("ppa", {})
    if current_rank.get("ppa_scale_rank_filter") != "1":
        errors.append("Playwright current PPA scale rank filter does not follow the rank controls")

    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setPpaScaleMode('final')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('all')")
    _set_timeline_index(page, 0)
    final_all = _debug_state(page).get("scenes", {}).get("ppa", {})
    final_all_limits = _ppa_limits_signature(final_all)
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('1')")
    final_rank = _debug_state(page).get("scenes", {}).get("ppa", {})
    final_rank_limits = _ppa_limits_signature(final_rank)
    _set_timeline_index(page, -1)
    final_last = _debug_state(page).get("scenes", {}).get("ppa", {})
    final_last_limits = _ppa_limits_signature(final_last)
    active = page.locator(".ppa-scale[data-ppa-scale='final']").evaluate("node => node.classList.contains('active')")
    if not active:
        errors.append("Playwright final PPA scale control is not visibly active")
    if final_all.get("ppa_scale_mode") != "final" or final_rank.get("ppa_scale_mode") != "final":
        errors.append("Playwright final PPA scale did not update scene metadata")
    if final_all.get("ppa_scale_step") != "final" or final_rank.get("ppa_scale_step") != "final":
        errors.append("Playwright final PPA scale is not anchored to the final step")
    if final_all.get("ppa_scale_rank_filter") != "all" or final_rank.get("ppa_scale_rank_filter") != "all":
        errors.append("Playwright final PPA scale is not anchored to all ranks")
    if not final_all_limits:
        errors.append("Playwright final PPA scale did not expose axis limits")
    if final_all_limits != final_rank_limits or final_rank_limits != final_last_limits:
        errors.append(
            "Playwright final PPA scale limits changed across rank filter or timeline: "
            f"{final_all_limits} -> {final_rank_limits} -> {final_last_limits}"
        )
    _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, "ppa_final_scale"))
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setPpaScaleMode('current')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankFilter('all')")
    _set_timeline_index(page, -1)


def _set_timeline_index(page: Any, index: int) -> None:
    page.evaluate(
        "index => {"
        " const slider = document.getElementById('timelineSlider');"
        " slider.value = String(index < 0 ? Number(slider.max) : index);"
        " slider.dispatchEvent(new Event('input', {bubbles: true}));"
        "}",
        index,
    )


def _ppa_limits_signature(scene: dict[str, Any]) -> list[list[float]]:
    limits = scene.get("ppa_limits")
    if not isinstance(limits, list):
        return []
    signature: list[list[float]] = []
    for axis in limits:
        if not isinstance(axis, list) or len(axis) != 2:
            return []
        signature.append([round(float(axis[0]), 9), round(float(axis[1]), 9)])
    return signature


def _assert_color_modes(
    page: Any,
    screenshot_dir: Path,
    errors: list[str],
    report_lines: list[str],
) -> None:
    for color_mode in ("fitness", "technique", "rank"):
        page.evaluate("mode => window.__QD_PPA_VIEWER_DEBUG__.setColorMode(mode)", color_mode)
        state = _debug_state(page)
        if state.get("color_mode") != color_mode:
            errors.append(f"Playwright color mode mismatch: expected {color_mode}, saw {state.get('color_mode')}")
        active = page.locator(f".color-quick[data-color-mode='{color_mode}']").evaluate(
            "node => node.classList.contains('active')"
        )
        if not active:
            errors.append(f"Playwright visible color control did not activate {color_mode}")
        legend = page.locator("#ppaLegend").inner_text().lower()
        if color_mode not in legend:
            errors.append(f"Playwright legend does not describe {color_mode} mode")
        if color_mode == "fitness" and "viridis" in legend:
            errors.append("Playwright fitness legend should not expose palette implementation")
        if color_mode == "fitness":
            if "-1.0" not in legend or "1.0" not in legend:
                errors.append("Playwright fitness legend does not show fixed [-1, 1] scale")
            if "visible sample range" not in legend:
                errors.append("Playwright fitness legend does not show separate sample range")
            if "outliers clipped" not in legend:
                errors.append("Playwright fitness legend does not document clipping")
            if "mean active ppa improvement" not in legend:
                errors.append("Playwright fitness legend does not name the metric")
        if "shape" not in legend or "classic" not in legend:
            errors.append(f"Playwright compare legend does not include technique shapes in {color_mode} mode")
        _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, f"color_{color_mode}"))
    colors = page.evaluate("() => [rankColor(1), rankColor(2), rankColor(3), rankColor(4)]")
    assert isinstance(colors, list)
    if len(set(colors)) != 4:
        errors.append(f"Playwright rank colors are not distinct: {colors}")
    palette = page.evaluate("() => [viridisColor(0, 1), viridisColor(1, 1)]")
    if palette != ["rgba(68,1,84,1)", "rgba(253,231,37,1)"]:
        errors.append(f"Playwright fitness palette is not viridis: {palette}")
    fitness_scale = page.evaluate(
        "() => [fitnessColor(-2, 1), fitnessColor(-1, 1), "
        "fitnessColor(0, 1), fitnessColor(1, 1), fitnessColor(2, 1)]"
    )
    expected_scale = [
        "rgba(68,1,84,1)",
        "rgba(68,1,84,1)",
        "rgba(33,145,140,1)",
        "rgba(253,231,37,1)",
        "rgba(253,231,37,1)",
    ]
    if fitness_scale != expected_scale:
        errors.append(f"Playwright fitness scale is not clipped [-1, 1]: {fitness_scale}")
    radii = _debug_state(page).get("rank_radius_preview")
    if not isinstance(radii, list) or len(radii) != 4:
        errors.append("Playwright rank radius preview is missing")
        return
    if not all(float(radii[index]) > float(radii[index + 1]) for index in range(3)):
        errors.append(f"Playwright rank radii are not monotonically decreasing: {radii}")
    technique_radii = dict(_debug_state(page).get("technique_radius_preview") or [])
    if technique_radii.get("classic") is not None:
        non_classic = [scale for name, scale in technique_radii.items() if name != "classic"]
        if non_classic and max(float(scale) for scale in non_classic) <= float(technique_radii["classic"]):
            errors.append(f"Playwright non-classic technique markers are not larger: {technique_radii}")
    state = _debug_state(page)
    reference_labels = state.get("reference_axis_labels")
    if not isinstance(reference_labels, list) or len(reference_labels) != 3:
        errors.append(f"Playwright sequential reference axis labels are missing: {reference_labels}")
    elif not all(str(label).startswith("ref ") and "=" in str(label) for label in reference_labels):
        errors.append(f"Playwright reference axis labels are malformed: {reference_labels}")
    reference_tooltip = str(state.get("reference_tooltip_preview") or "")
    if "area " not in reference_tooltip or "power " not in reference_tooltip or "eff " not in reference_tooltip:
        errors.append(f"Playwright reference tooltip no longer has full PPA data: {reference_tooltip}")


def _assert_rank_guides(
    page: Any,
    screenshot_dir: Path,
    errors: list[str],
    report_lines: list[str],
    *,
    label: str,
    mode: str,
    method: str,
    color_scheme: str,
    projected_overlay: str,
    expected_method: str,
    expected_color_scheme: str,
    expected_projection: str,
    expected_surface: str,
    require_mesh: bool,
    require_projected_overlay: bool,
    require_compare_techniques: bool,
) -> None:
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setColorMode('rank')")
    page.evaluate("mode => window.__QD_PPA_VIEWER_DEBUG__.setRankGuideMode(mode)", mode)
    page.evaluate("method => window.__QD_PPA_VIEWER_DEBUG__.setRankGuideMethod(method)", method)
    page.evaluate("scheme => window.__QD_PPA_VIEWER_DEBUG__.setRankGuideColorScheme(scheme)", color_scheme)
    page.evaluate("value => window.__QD_PPA_VIEWER_DEBUG__.setProjectedRankGuides(value)", projected_overlay)
    state = _debug_state(page)
    scene = state.get("scenes", {}).get("ppa", {})
    if state.get("color_mode") != "rank":
        errors.append(f"{label}: rank guides were not tested in rank color mode")
    if state.get("rank_guide_mode") != mode or state.get("effective_rank_guide_mode") != mode:
        errors.append(
            f"{label}: expected rank guide mode {mode}, saw "
            f"{state.get('rank_guide_mode')}/{state.get('effective_rank_guide_mode')}"
        )
    if scene.get("rank_guide_mode") != mode:
        errors.append(f"{label}: scene rank guide mode mismatch: {scene.get('rank_guide_mode')}")
    if state.get("effective_rank_guide_method") != expected_method:
        errors.append(
            f"{label}: expected effective rank guide method {expected_method}, "
            f"saw {state.get('effective_rank_guide_method')}"
        )
    if scene.get("rank_guide_method") != expected_method:
        errors.append(f"{label}: scene rank guide method mismatch: {scene.get('rank_guide_method')}")
    if state.get("effective_rank_guide_color_scheme") != expected_color_scheme:
        errors.append(
            f"{label}: expected guide color scheme {expected_color_scheme}, "
            f"saw {state.get('effective_rank_guide_color_scheme')}"
        )
    if scene.get("rank_guide_color_scheme") != expected_color_scheme:
        errors.append(f"{label}: scene guide color scheme mismatch: {scene.get('rank_guide_color_scheme')}")
    if scene.get("rank_guide_projection_mode") != expected_projection:
        errors.append(
            f"{label}: expected guide projection {expected_projection}, "
            f"saw {scene.get('rank_guide_projection_mode')}"
        )
    if scene.get("rank_guide_surface_mode") != expected_surface:
        errors.append(
            f"{label}: expected guide surface {expected_surface}, "
            f"saw {scene.get('rank_guide_surface_mode')}"
        )
    if int(scene.get("rank_guide_count", 0)) <= 0:
        errors.append(f"{label}: rank guide count is zero")
    if require_mesh and int(scene.get("rank_guide_triangle_count", 0)) <= 0:
        errors.append(f"{label}: Delaunay mesh rendered no triangles")
    if not require_mesh and int(scene.get("rank_guide_triangle_count", 0)) != 0:
        errors.append(f"{label}: non-mesh rank guide unexpectedly emitted triangles")
    if bool(scene.get("rank_guide_projected_overlay")) != require_projected_overlay:
        errors.append(f"{label}: projected overlay state mismatch: {scene.get('rank_guide_projected_overlay')}")
    projected_count = int(scene.get("rank_guide_projected_count", 0))
    projected_vertices = int(scene.get("rank_guide_projected_vertex_count", 0))
    if require_projected_overlay and (projected_count <= 0 or projected_vertices <= 0):
        errors.append(f"{label}: projected overlay did not render curves and vertices")
    if not require_projected_overlay and expected_method != "projected_curves_3d" and (projected_count != 0 or projected_vertices != 0):
        errors.append(f"{label}: projected overlay counts are nonzero while disabled")
    if require_projected_overlay:
        shapes = set(scene.get("rank_guide_projected_vertex_shapes", []))
        if not {"circle", "diamond"}.issubset(shapes):
            errors.append(f"{label}: projected overlay vertex shapes are incomplete: {sorted(shapes)}")
    if require_compare_techniques and len(scene.get("rank_guide_techniques", [])) < 2:
        errors.append(f"{label}: compare mode did not emit guides for both techniques")
    if not scene.get("rank_guide_signature"):
        errors.append(f"{label}: rank guide geometry signature is missing")
    _report_screenshot(report_lines, _viewer_screenshot(page, screenshot_dir, errors, label))


def _assert_rank_guides_disabled_outside_rank(page: Any, errors: list[str]) -> None:
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setRankGuideMode('2')")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setColorMode('fitness')")
    state = _debug_state(page)
    scene = state.get("scenes", {}).get("ppa", {})
    if state.get("effective_rank_guide_mode") != "off":
        errors.append("Playwright rank guides are effective outside rank color mode")
    if int(scene.get("rank_guide_count", 0)) != 0:
        errors.append("Playwright rank guides render outside rank color mode")
    disabled = page.locator(".rank-guide[data-rank-guide='2']").evaluate("node => node.disabled")
    if not disabled:
        errors.append("Playwright rank guide controls are not disabled outside rank color mode")
    page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.setColorMode('rank')")


def _assert_auto_rotate(page: Any, errors: list[str]) -> None:
    first = _debug_state(page)
    first_camera = first.get("scenes", {}).get("archiveA", {}).get("camera", {})
    first_ppa = first.get("scenes", {}).get("ppa", {})
    first_ppa_camera = first_ppa.get("camera", {})
    page.wait_for_timeout(250)
    second = _debug_state(page)
    second_camera = second.get("scenes", {}).get("archiveA", {}).get("camera", {})
    second_ppa = second.get("scenes", {}).get("ppa", {})
    second_ppa_camera = second_ppa.get("camera", {})
    if first_camera.get("yaw") == second_camera.get("yaw"):
        errors.append("Playwright auto-rotate did not change archive camera yaw")
    if first_ppa.get("dimensionality") == "3d" and first_ppa_camera.get("yaw") == second_ppa_camera.get("yaw"):
        errors.append("Playwright auto-rotate did not change 3D PPA camera yaw")


def _assert_archive_hover_clears(page: Any, errors: list[str]) -> None:
    if not page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.hoverFirstArchiveCell('archiveA')"):
        errors.append("Playwright archive hover clear check found no occupied archive cell")
        return
    if not _move_to_empty_canvas_point(page, "archiveA", "#archiveCanvasA"):
        errors.append("Playwright archive hover clear check found no empty archive canvas point")
        return
    state = _debug_state(page)
    if state.get("highlighted_sample_ids") or state.get("highlighted_cell_id") is not None:
        errors.append("Playwright archive hover did not clear after moving off the cell")


def _assert_reference_hover(page: Any, errors: list[str]) -> None:
    tooltip = _hover_ppa_reference_with_mouse(page)
    if tooltip is None:
        errors.append("Playwright reference hover did not activate a tooltip")
        return
    if "area " not in tooltip or "power " not in tooltip or "eff " not in tooltip:
        errors.append(f"Playwright reference hover tooltip no longer has full PPA data: {tooltip}")


def _assert_locked_archive_cameras(page: Any, errors: list[str], ppa_camera_before: Any) -> None:
    state = _debug_state(page)
    scenes = state.get("scenes", {})
    assert isinstance(scenes, dict)
    archive_a = scenes.get("archiveA", {})
    archive_b = scenes.get("archiveB", {})
    if not archive_b:
        return
    if archive_a.get("camera") != archive_b.get("camera"):
        errors.append("Playwright locked archive cameras are not equal")
    if ppa_camera_before is not None and scenes.get("ppa", {}).get("camera") != ppa_camera_before:
        errors.append("Playwright perspective lock changed the PPA camera")


def _assert_reset_state(page: Any, errors: list[str], problem_before: Any) -> None:
    state = _debug_state(page)
    if state.get("problem_key") != problem_before:
        errors.append("Playwright reset changed the selected problem")
    if state.get("locked_perspective"):
        errors.append("Playwright reset did not clear perspective lock")
    if state.get("exploded_layers"):
        errors.append("Playwright reset did not clear exploded layers")


def _assert_ppa_dimensionality(page: Any, errors: list[str], *, label: str, expected: str) -> None:
    state = _debug_state(page)
    ppa = state.get("scenes", {}).get("ppa", {})
    if ppa.get("dimensionality") != expected:
        errors.append(f"{label}: expected PPA dimensionality {expected}, saw {ppa.get('dimensionality')}")
    if int(ppa.get("visible_sample_count", 0)) <= 0:
        errors.append(f"{label}: PPA scene has no visible samples")
    if not ppa.get("reference_visible"):
        errors.append(f"{label}: PPA scene does not show the reference PPA marker")
    if expected == "3d":
        z_range = ppa.get("z_range", [0, 0])
        if len(z_range) != 2 or float(z_range[1]) <= float(z_range[0]):
            errors.append(f"{label}: sequential PPA z range is not populated")
        if ppa.get("point_glyph_mode") != "shaded_3d_points":
            errors.append(f"{label}: sequential PPA points are not shaded 3D glyphs")
    elif ppa.get("point_glyph_mode") != "flat_2d_points":
        errors.append(f"{label}: combinational PPA points are not flat 2D glyphs")
    if ppa.get("fitness_palette") != "viridis":
        errors.append(f"{label}: PPA fitness palette is not viridis")


def _assert_sample_axis_labels(
    state: dict[str, Any],
    errors: list[str],
    *,
    label: str,
    expected_count: int,
    source: str,
) -> None:
    sample_labels = state.get("hovered_sample_axis_labels")
    if not isinstance(sample_labels, list) or len(sample_labels) != expected_count:
        errors.append(f"{label}: {source} did not expose sample axis labels: {sample_labels}")
        return
    if not all(str(item).startswith("sample ") and "=" in str(item) for item in sample_labels):
        errors.append(f"{label}: {source} sample axis labels are malformed: {sample_labels}")


def _strict_visual_matrix(
    page: Any,
    problem_keys: set[str],
    screenshot_dir: Path,
    errors: list[str],
    report_lines: list[str],
) -> None:
    report_lines.extend(["", "## Required Matrix", ""])
    for label, problem_key, scene_kind, expected_dimensionality in STRICT_VISUAL_CASES:
        if problem_key not in problem_keys:
            errors.append(f"strict Playwright missing required validation problem: {problem_key}")
            continue
        page.evaluate("key => window.__QD_PPA_VIEWER_DEBUG__.setProblem(key)", problem_key)
        _select_compare(page, "classic", "grid_quantile_pareto_journal_bd", errors)
        screenshot_path = _viewer_screenshot(page, screenshot_dir, errors, label)
        state = _debug_state(page)
        scene = state["scenes"]["ppa"] if scene_kind == "ppa" else state["scenes"]["archiveA"]
        if scene.get("dimensionality") != expected_dimensionality:
            errors.append(
                f"{label}: expected {expected_dimensionality}, saw {scene.get('dimensionality')}"
            )
        if scene_kind == "archive":
            if int(scene.get("visible_layer_count", 0)) <= 0:
                errors.append(f"{label}: archive scene reports no layers")
            if int(scene.get("archive_sample_hit_count", 0)) <= 0:
                errors.append(f"{label}: archive scene has no sample-level hit targets")
            if not scene.get("fitness_shaded"):
                errors.append(f"{label}: archive scene does not report fitness shading")
            if scene.get("fitness_palette") != "viridis":
                errors.append(f"{label}: archive fitness palette is not viridis")
            if label == "sequential_archive_3d" and scene.get("collapsed_axes"):
                errors.append(f"{label}: full 3D archive unexpectedly reports collapsed axes")
            if label == "combinational_projected_archive" and "ff_depth" not in scene.get("collapsed_axes", []):
                errors.append(f"{label}: projected archive does not report collapsed ff_depth")
            if not page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.hoverFirstArchiveCell('archiveA')"):
                errors.append(f"{label}: archive hover bridge found no occupied cell")
            hover = _debug_state(page)
            if not hover.get("highlighted_sample_ids"):
                errors.append(f"{label}: archive hover did not highlight PPA samples")
            ppa_scene = hover.get("scenes", {}).get("ppa", {})
            if ppa_scene.get("linked_fade_mode") != "dim_unselected_samples":
                errors.append(f"{label}: archive hover did not dim unselected PPA samples")
            _report_screenshot(
                report_lines,
                _viewer_screenshot(page, screenshot_dir, errors, f"{label}_archive_hover"),
            )
            if not page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.hoverFirstArchiveSample('archiveA')"):
                errors.append(f"{label}: archive sample hover bridge found no sample")
            sample_hover = _debug_state(page)
            if len(sample_hover.get("highlighted_sample_ids", [])) != 1:
                errors.append(f"{label}: archive sample hover did not isolate one sample")
            if not _hover_first_archive_sample_with_mouse(page, "archiveA", "#archiveCanvasA"):
                errors.append(f"{label}: real mouse hover did not activate an archive sample tooltip")
            if not page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.hoverFirstLayerCell('A')"):
                errors.append(f"{label}: layer-panel hover bridge found no occupied cell")
            layer_hover = _debug_state(page)
            if not layer_hover.get("highlighted_sample_ids") or layer_hover.get("highlighted_cell_id") is None:
                errors.append(f"{label}: layer-panel hover did not map to cell samples")
            layer_tooltip = _hover_first_layer_cell_with_mouse(page, "A")
            if layer_tooltip is None:
                errors.append(f"{label}: real layer-panel hover did not show a tooltip")
            elif "cell indices " not in layer_tooltip or "samples " not in layer_tooltip or "best fitness " not in layer_tooltip:
                errors.append(f"{label}: layer-panel tooltip is incomplete: {layer_tooltip}")
            _report_screenshot(
                report_lines,
                _viewer_screenshot(page, screenshot_dir, errors, f"{label}_layer_hover"),
            )
        else:
            if int(scene.get("visible_sample_count", 0)) <= 0:
                errors.append(f"{label}: PPA scene reports no visible samples")
            if not scene.get("reference_visible"):
                errors.append(f"{label}: PPA scene does not report a reference marker")
            _assert_rank_guides(
                page,
                screenshot_dir,
                errors,
                report_lines,
                label=f"{label}_rank_guides",
                mode="2",
                method="auto",
                color_scheme="auto",
                projected_overlay="off",
                expected_method="delaunay_mesh_3d" if expected_dimensionality == "3d" else "pchip_2d",
                expected_color_scheme="rank",
                expected_projection="3d_delaunay_mesh" if expected_dimensionality == "3d" else "2d_line",
                expected_surface="delaunay_mesh_3d" if expected_dimensionality == "3d" else "none",
                require_mesh=expected_dimensionality == "3d",
                require_projected_overlay=False,
                require_compare_techniques=True,
            )
            state = _debug_state(page)
            scene = state["scenes"]["ppa"]
            if not page.evaluate("window.__QD_PPA_VIEWER_DEBUG__.hoverFirstPpaPoint()"):
                errors.append(f"{label}: PPA hover bridge found no sample")
            hover = _debug_state(page)
            if hover.get("highlighted_cell_id") is None:
                errors.append(f"{label}: PPA hover did not identify an archive cell")
            expected_label_count = 3 if expected_dimensionality == "3d" else 2
            _assert_sample_axis_labels(
                hover,
                errors,
                label=label,
                expected_count=expected_label_count,
                source="PPA hover bridge",
            )
            if not _hover_first_ppa_point_with_mouse(page):
                errors.append(f"{label}: real mouse hover did not activate a PPA sample tooltip")
            mouse_hover = _debug_state(page)
            _assert_sample_axis_labels(
                mouse_hover,
                errors,
                label=label,
                expected_count=expected_label_count,
                source="real mouse hover",
            )
            state = mouse_hover
            scene = state["scenes"]["ppa"]
            _report_screenshot(
                report_lines,
                _viewer_screenshot(page, screenshot_dir, errors, f"{label}_ppa_hover"),
            )
        metadata = _scene_report_metadata(state, scene_kind, scene)
        report_lines.append(
            f"- `{label}`: `{problem_key}` -> `{scene.get('dimensionality')}` "
            f"([screenshot]({screenshot_path.relative_to(screenshot_dir.parent)}))\n"
            f"  - debug: `{json.dumps(metadata, sort_keys=True)}`"
        )


def _scene_report_metadata(state: dict[str, Any], scene_kind: str, scene: dict[str, Any]) -> dict[str, Any]:
    if scene_kind == "archive":
        return {
            "active_axes": scene.get("active_axes"),
            "archive_sample_hit_count": scene.get("archive_sample_hit_count"),
            "camera": scene.get("camera"),
            "collapsed_axes": scene.get("collapsed_axes"),
            "effective_shape": scene.get("effective_shape"),
            "fitness_palette": scene.get("fitness_palette"),
            "renderer": scene.get("renderer"),
            "selected_techniques": state.get("selected_techniques"),
            "visible_layer_count": scene.get("visible_layer_count"),
        }
    return {
        "axes": scene.get("axes"),
        "camera": scene.get("camera"),
        "color_mode": state.get("color_mode"),
        "fitness_palette": scene.get("fitness_palette"),
        "hovered_sample_axis_labels": state.get("hovered_sample_axis_labels"),
        "linked_fade_mode": scene.get("linked_fade_mode"),
        "point_glyph_mode": scene.get("point_glyph_mode"),
        "ppa_limits": scene.get("ppa_limits"),
        "ppa_scale_mode": scene.get("ppa_scale_mode"),
        "ppa_scale_rank_filter": scene.get("ppa_scale_rank_filter"),
        "ppa_scale_step": scene.get("ppa_scale_step"),
        "rank_guide_color_scheme": scene.get("rank_guide_color_scheme"),
        "rank_guide_count": scene.get("rank_guide_count"),
        "rank_guide_method": scene.get("rank_guide_method"),
        "rank_guide_mode": scene.get("rank_guide_mode"),
        "rank_guide_projected_count": scene.get("rank_guide_projected_count"),
        "rank_guide_projected_overlay": scene.get("rank_guide_projected_overlay"),
        "rank_guide_projected_vertex_count": scene.get("rank_guide_projected_vertex_count"),
        "rank_guide_projected_vertex_shapes": scene.get("rank_guide_projected_vertex_shapes"),
        "rank_guide_projection_mode": scene.get("rank_guide_projection_mode"),
        "rank_guide_surface_mode": scene.get("rank_guide_surface_mode"),
        "rank_guide_techniques": scene.get("rank_guide_techniques"),
        "rank_guide_triangle_count": scene.get("rank_guide_triangle_count"),
        "reference_visible": scene.get("reference_visible"),
        "renderer": scene.get("renderer"),
        "selected_techniques": state.get("selected_techniques"),
        "visible_sample_count": scene.get("visible_sample_count"),
        "z_range": scene.get("z_range"),
    }


def _hover_first_ppa_point_with_mouse(page: Any) -> bool:
    hit = page.evaluate("() => state.hitMaps.ppa.find(item => item.kind === 'ppaSample')")
    if not isinstance(hit, dict):
        return False
    rect = page.locator("#ppaCanvas").bounding_box()
    if not rect:
        return False
    page.mouse.move(float(rect["x"]) + float(hit["x"]), float(rect["y"]) + float(hit["y"]))
    page.wait_for_timeout(100)
    state = _debug_state(page)
    tooltip_display = page.locator("#tooltip").evaluate("node => getComputedStyle(node).display")
    return bool(state.get("highlighted_sample_ids")) and tooltip_display != "none"


def _hover_first_archive_sample_with_mouse(page: Any, scene_name: str, canvas_selector: str) -> bool:
    hit = page.evaluate(
        "scene => state.hitMaps[scene].find(item => item.kind === 'archiveSample')",
        scene_name,
    )
    if not isinstance(hit, dict):
        return False
    rect = page.locator(canvas_selector).bounding_box()
    if not rect:
        return False
    page.mouse.move(float(rect["x"]) + float(hit["x"]), float(rect["y"]) + float(hit["y"]))
    page.wait_for_timeout(100)
    state = _debug_state(page)
    tooltip_display = page.locator("#tooltip").evaluate("node => getComputedStyle(node).display")
    return len(state.get("highlighted_sample_ids", [])) == 1 and tooltip_display != "none"


def _hover_first_layer_cell_with_mouse(page: Any, label: str) -> str | None:
    cell = page.locator(f"#layerPanel{label} .layer-cell.occupied").first
    if cell.count() == 0:
        return None
    rect = cell.bounding_box()
    if not rect:
        return None
    page.mouse.move(float(rect["x"]) + float(rect["width"]) / 2, float(rect["y"]) + float(rect["height"]) / 2)
    page.wait_for_timeout(100)
    tooltip = page.locator("#tooltip")
    if tooltip.evaluate("node => getComputedStyle(node).display") == "none":
        return None
    return str(tooltip.inner_text())


def _hover_ppa_reference_with_mouse(page: Any) -> str | None:
    hit = page.evaluate("() => state.hitMaps.ppa.find(item => item.kind === 'ppaReference')")
    if not isinstance(hit, dict):
        return None
    rect = page.locator("#ppaCanvas").bounding_box()
    if not rect:
        return None
    page.mouse.move(float(rect["x"]) + float(hit["x"]), float(rect["y"]) + float(hit["y"]))
    page.wait_for_timeout(100)
    tooltip = page.locator("#tooltip")
    if tooltip.evaluate("node => getComputedStyle(node).display") == "none":
        return None
    return str(tooltip.inner_text())


def _move_to_empty_canvas_point(page: Any, scene_name: str, canvas_selector: str) -> bool:
    point = page.evaluate(
        "scene => {"
        " const canvas = document.querySelector('[data-scene=\"' + scene + '\"]');"
        " const rect = canvas.getBoundingClientRect();"
        " const hits = state.hitMaps[scene] || [];"
        " for (let y = 12; y < rect.height - 12; y += 18) {"
        "   for (let x = 12; x < rect.width - 12; x += 18) {"
        "     const inside = hits.some((hit) => Math.hypot(x - hit.x, y - hit.y) < hit.radius + 2);"
        "     if (!inside) return {x, y};"
        "   }"
        " }"
        " return null;"
        "}",
        scene_name,
    )
    if not isinstance(point, dict):
        return False
    rect = page.locator(canvas_selector).bounding_box()
    if not rect:
        return False
    page.mouse.move(float(rect["x"]) + float(point["x"]), float(rect["y"]) + float(point["y"]))
    page.wait_for_timeout(100)
    return True


def _visual_report_header() -> list[str]:
    lines = ["# QD/PPA Visual Parity Report", "", "## Reference Screenshots", ""]
    repo_root = Path(__file__).resolve().parents[1]
    for label, relative_path in REFERENCE_SCREENSHOTS:
        path = repo_root / relative_path
        status = "present" if path.is_file() else "missing"
        lines.append(f"- `{label}`: `{status}` `{relative_path}`")
    lines.extend(["", "## New Viewer Screenshots", ""])
    return lines


def _report_screenshot(report_lines: list[str], path: Path) -> None:
    report_lines.append(f"- `{path.stem}`: [screenshot]({path.relative_to(path.parent.parent)})")


def _viewer_screenshot(page: Any, screenshot_dir: Path, errors: list[str], name: str) -> Path:
    path = screenshot_dir / f"{name}.png"
    page.screenshot(path=str(path), full_page=False)
    if path.stat().st_size <= 20_000:
        errors.append(f"Playwright screenshot too small: {path.name}")
    if _pixel_variance(path) <= 0.0001:
        errors.append(f"Playwright screenshot blank: {path.name}")
    return path


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
