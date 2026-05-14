from __future__ import annotations
# pyright: reportMissingModuleSource=false

from bisect import bisect_right
from concurrent.futures import ThreadPoolExecutor
import csv
from dataclasses import dataclass
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
from typing import Any

import yaml

from revolution.qd.ppa_visualization_metrics import (
    AssetMode,
    active_objective_keys,
    active_raw_metrics,
    finite_float,
    front_points,
    hypervolume_payload,
    pareto_ranks,
    rank_one_count,
)
from revolution.qd.ppa_visualization_viewer import write_viewer_html


@dataclass(frozen=True)
class BackendRun:
    name: str
    path: Path


@dataclass(frozen=True)
class VisualizationExportResult:
    viewer_root: Path
    manifest_path: Path
    dataset_paths: tuple[Path, ...]


def export_qd_ppa_visualization(
    *,
    run_root: Path,
    backend_runs: tuple[BackendRun, ...],
    archive_source_backend: str,
    output_dir: Path,
    subset_config: Path | None,
    selected_problem: str | None,
    asset_mode: AssetMode,
    strict: bool,
    recover_classic_descriptors: bool,
) -> VisualizationExportResult:
    assert backend_runs
    backend_paths = {backend.name: backend.path for backend in backend_runs}
    assert archive_source_backend in backend_paths
    if asset_mode not in ("cdn", "local", "inline"):
        raise AssertionError(f"unknown asset mode: {asset_mode}")

    output_dir.mkdir(parents=True, exist_ok=True)
    datasets_dir = output_dir / "datasets"
    datasets_dir.mkdir(parents=True, exist_ok=True)

    ppa_path = run_root / "final_analysis" / "ppa_distribution" / "data" / "ppa_candidates.csv"
    ref_path = run_root / "final_analysis" / "ppa_distribution" / "data" / "reference_ppa_metrics.csv"
    assert ppa_path.is_file()
    assert ref_path.is_file()

    ppa_rows = _read_csv(ppa_path)
    ref_rows = _read_csv(ref_path)
    references = {
        (row["benchmark"], row["problem"]): _reference_from_row(row)
        for row in ref_rows
    }
    selected = _selected_problems(
        subset_config=subset_config,
        selected_problem=selected_problem,
        available=sorted(references),
    )
    design_index = _load_design_index(run_root)
    descriptor_cache_path = output_dir / "descriptor_cache.json"
    descriptor_cache = _load_json_dict(descriptor_cache_path) if descriptor_cache_path.is_file() else {}

    grouped_rows = _group_ppa_rows(
        rows=ppa_rows,
        backend_names=set(backend_paths),
        selected=selected,
    )
    manifest_problems: list[dict[str, Any]] = []
    datasets: dict[str, dict[str, Any]] = {}
    dataset_paths: list[Path] = []
    for benchmark, problem in selected:
        key = (benchmark, problem)
        if key not in grouped_rows:
            if strict:
                raise AssertionError(f"no PPA rows for {benchmark}/{problem}")
            continue
        archive_problem_dir = _find_problem_dir(
            backend_paths[archive_source_backend],
            benchmark=benchmark,
            problem=problem,
            require_archive=True,
        )
        archive_context = _load_archive_context(archive_problem_dir, strict=strict)
        backend_contexts = {
            backend_name: _load_backend_context(
                backend_name=backend_name,
                backend_root=backend_root,
                benchmark=benchmark,
                problem=problem,
            )
            for backend_name, backend_root in backend_paths.items()
        }
        dataset = _build_problem_dataset(
            run_root=run_root,
            benchmark=benchmark,
            problem=problem,
            rows=grouped_rows[key],
            references=references,
            backend_paths=backend_paths,
            archive_source_backend=archive_source_backend,
            archive_context=archive_context,
            backend_contexts=backend_contexts,
            design_index=design_index,
            descriptor_cache=descriptor_cache,
            recover_classic_descriptors=recover_classic_descriptors,
        )
        dataset_name = f"{benchmark}__{problem}.json"
        dataset_path = datasets_dir / dataset_name
        dataset_path.write_text(json.dumps(dataset, indent=2, sort_keys=True), encoding="utf-8")
        dataset_paths.append(dataset_path)
        problem_key = f"{benchmark}/{problem}"
        manifest_problems.append(
            {
                "problem_key": problem_key,
                "benchmark": benchmark,
                "problem": problem,
                "circuit_type": dataset["circuit_type"],
                "dataset_path": f"datasets/{dataset_name}",
                "techniques": sorted(dataset["techniques"]),
            }
        )
        datasets[problem_key] = dataset
        if recover_classic_descriptors:
            descriptor_cache_path.write_text(
                json.dumps(descriptor_cache, indent=2, sort_keys=True),
                encoding="utf-8",
            )

    if recover_classic_descriptors:
        descriptor_cache_path.write_text(json.dumps(descriptor_cache, indent=2, sort_keys=True), encoding="utf-8")

    manifest = {
        "schema_version": "qd_ppa_viewer.v2",
        "run_root": str(run_root),
        "created_at": datetime.now(timezone.utc).isoformat(),
        "archive_source_backend": archive_source_backend,
        "asset_mode": asset_mode,
        "viewer_defaults": {
            "coordinate_mode": "raw",
            "coordinate_modes": ["raw", "improvement", "normalized"],
            "ppa_scale_mode": "current",
            "ppa_scale_modes": ["current", "final"],
            "rank_scope": "per_technique",
            "rank_scopes": ["per_technique", "pooled_visible"],
            "sample_universe": "all_ppa_valid",
            "sample_universes": [
                "all_ppa_valid",
                "final_archive_members",
                "viewer_pooled_pareto_members",
            ],
            "archive_geometry_perspective": "native_timeline",
            "archive_geometry_perspectives": ["native_timeline", "final_fixed"],
        },
        "source_artifacts": {
            "ppa_candidates.csv": _file_digest(ppa_path),
            "reference_ppa_metrics.csv": _file_digest(ref_path),
        },
        "problems": manifest_problems,
    }
    manifest_path = output_dir / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True), encoding="utf-8")
    legacy_standalone = output_dir / "index_standalone.html"
    if legacy_standalone.exists():
        legacy_standalone.unlink()
    write_viewer_html(
        output_dir / "index.html",
        manifest=manifest,
        datasets=datasets,
        asset_mode=asset_mode,
    )
    return VisualizationExportResult(
        viewer_root=output_dir,
        manifest_path=manifest_path,
        dataset_paths=tuple(dataset_paths),
    )


def _selected_problems(
    *,
    subset_config: Path | None,
    selected_problem: str | None,
    available: list[tuple[str, str]],
) -> list[tuple[str, str]]:
    if selected_problem is not None:
        if "/" not in selected_problem:
            raise AssertionError("selected problem must be BENCHMARK/PROBLEM")
        benchmark, problem = selected_problem.split("/", 1)
        return [(benchmark, problem)]
    if subset_config is None:
        return available
    payload = yaml.safe_load(subset_config.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    raw_items = payload["selected_problems"]
    assert isinstance(raw_items, list)
    selected: list[tuple[str, str]] = []
    for item in raw_items:
        assert isinstance(item, dict)
        selected.append((str(item["benchmark"]), str(item["problem"])))
    assert selected
    return selected


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def _read_optional_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _reference_from_row(row: dict[str, str]) -> dict[str, float | None]:
    return {
        "area": finite_float(row.get("ref_area")),
        "power": finite_float(row.get("ref_power")),
        "eff_clk_period": finite_float(row.get("ref_eff_clk_period")),
    }


def _group_ppa_rows(
    *,
    rows: list[dict[str, str]],
    backend_names: set[str],
    selected: list[tuple[str, str]],
) -> dict[tuple[str, str], list[dict[str, str]]]:
    selected_set = set(selected)
    grouped: dict[tuple[str, str], list[dict[str, str]]] = {}
    for row in rows:
        if row["backend"] not in backend_names:
            continue
        key = (row["benchmark"], row["problem"])
        if key not in selected_set:
            continue
        grouped.setdefault(key, []).append(row)
    return grouped


def _build_problem_dataset(
    *,
    run_root: Path,
    benchmark: str,
    problem: str,
    rows: list[dict[str, str]],
    references: dict[tuple[str, str], dict[str, float | None]],
    backend_paths: dict[str, Path],
    archive_source_backend: str,
    archive_context: dict[str, Any],
    backend_contexts: dict[str, dict[str, Any]],
    design_index: dict[tuple[str, str, str, str], dict[str, str]],
    descriptor_cache: dict[str, Any],
    recover_classic_descriptors: bool,
) -> dict[str, Any]:
    ref = references[(benchmark, problem)]
    circuit_type = _circuit_type(rows, ref)
    objective_keys = active_objective_keys(circuit_type)
    raw_metrics = active_raw_metrics(circuit_type)
    axis_names = _archive_axis_names(archive_context["space"])
    geometry_timeline = _archive_geometry_timeline(archive_context)
    classic_dir_matches = _classic_dir_matches(
        backend_paths=backend_paths,
        rows=rows,
        benchmark=benchmark,
        problem=problem,
    )
    if recover_classic_descriptors:
        _recover_classic_descriptors_for_problem(
            axis_names=axis_names,
            rows=rows,
            classic_dir_matches=classic_dir_matches,
            descriptor_cache=descriptor_cache,
        )

    samples: list[dict[str, Any]] = []
    for index, row in enumerate(rows):
        sample = _sample_from_row(
            run_root=run_root,
            row=row,
            row_index=index,
            circuit_type=circuit_type,
            ref=ref,
            objective_keys=objective_keys,
            raw_metrics=raw_metrics,
            archive_context=archive_context,
            geometry_timeline=geometry_timeline,
            backend_context=backend_contexts[row["backend"]],
            design_index=design_index,
            axis_names=axis_names,
            classic_dir_matches=classic_dir_matches,
            descriptor_cache=descriptor_cache,
            recover_classic_descriptors=recover_classic_descriptors,
        )
        if sample is not None:
            samples.append(sample)

    assert samples
    steps = sorted({int(sample["generation"]) for sample in samples})
    step_names = [str(step) for step in steps] + ["final"]
    _compute_rank_payloads(samples, step_names, objective_keys)
    cell_summaries = _cell_summaries_by_step(samples, step_names)
    native_cell_summaries = _cell_summaries_by_step(
        samples,
        step_names,
        cell_id_key="native_archive_cell_id",
        status_key="native_archive_projection_status",
        projection_type_key="native_projection_type",
    )
    technique_stats = _technique_stats_by_step(samples, step_names, objective_keys)
    techniques = sorted({sample["technique"] for sample in samples})
    source_paths = _problem_source_paths(
        run_root=run_root,
        archive_context=archive_context,
        backend_contexts=backend_contexts,
    )
    return {
        "schema_version": "qd_ppa_problem.v2",
        "benchmark": benchmark,
        "problem": problem,
        "circuit_type": circuit_type,
        "steps": steps + ["final"],
        "archive_source_backend": archive_source_backend,
        "archive_definition": archive_context["space"],
        "archive_projection": _archive_projection_metadata(archive_context["space"]),
        "reference_ppa": ref,
        "objective_keys": list(objective_keys),
        "raw_metrics": list(raw_metrics),
        "viewer_defaults": {
            "coordinate_mode": "raw",
            "coordinate_modes": ["raw", "improvement", "normalized"],
            "ppa_scale_mode": "current",
            "ppa_scale_modes": ["current", "final"],
            "rank_scope": "per_technique",
            "rank_scopes": ["per_technique", "pooled_visible"],
            "sample_universe": "all_ppa_valid",
            "sample_universes": [
                "all_ppa_valid",
                "final_archive_members",
                "viewer_pooled_pareto_members",
            ],
            "archive_geometry_perspective": "native_timeline",
            "archive_geometry_perspectives": ["native_timeline", "final_fixed"],
        },
        "techniques": {technique: {"label": technique} for technique in techniques},
        "samples": samples,
        "archive_geometry_perspectives": ["native_timeline", "final_fixed"],
        "archive_geometry_snapshots": geometry_timeline["snapshots"],
        "rebin_timeline_markers": geometry_timeline["markers"],
        "cell_summaries_by_step": cell_summaries,
        "cell_summaries_by_step_native_timeline": native_cell_summaries,
        "technique_stats_by_step": technique_stats,
        "source_artifacts": {
            path.name: _file_digest(path)
            for path in source_paths
            if path.is_file()
        },
    }


def _sample_from_row(
    *,
    run_root: Path,
    row: dict[str, str],
    row_index: int,
    circuit_type: str,
    ref: dict[str, float | None],
    objective_keys: tuple[str, ...],
    raw_metrics: tuple[str, ...],
    archive_context: dict[str, Any],
    geometry_timeline: dict[str, Any],
    backend_context: dict[str, Any],
    design_index: dict[tuple[str, str, str, str], dict[str, str]],
    axis_names: tuple[str, ...],
    classic_dir_matches: dict[tuple[str, str, str, str], dict[str, str]],
    descriptor_cache: dict[str, Any],
    recover_classic_descriptors: bool,
) -> dict[str, Any] | None:
    metrics = {metric: finite_float(row.get(metric)) for metric in ("area", "power", "eff_clk_period")}
    if any(metrics[metric] is None for metric in raw_metrics):
        return None
    gains = {
        "g_A": _gain(row, "g_A", ref["area"], metrics["area"]),
        "g_P": _gain(row, "g_P", ref["power"], metrics["power"]),
        "g_T": _gain(row, "g_T", ref["eff_clk_period"], metrics["eff_clk_period"]),
    }
    if any(gains[key] is None for key in objective_keys):
        return None

    backend = row["backend"]
    benchmark = row["benchmark"]
    problem = row["problem"]
    candidate_id = row["candidate_id"]
    design_row = design_index.get((backend, benchmark, problem, candidate_id), {})
    qd_event = backend_context["events"].get(candidate_id, {})
    archive_row = backend_context["archive_cells"].get(candidate_id, {})
    classic_match = classic_dir_matches.get((backend, benchmark, problem, candidate_id), {})
    code_file_path = _first_text(
        row.get("code_file_path"),
        design_row.get("code_file_path"),
        archive_row.get("code_file_path"),
        qd_event.get("code_file_path"),
        classic_match.get("code_file_path"),
    )
    candidate_dir = _first_text(
        row.get("candidate_dir"),
        design_row.get("candidate_dir"),
        classic_match.get("candidate_dir"),
        str(Path(code_file_path).parent) if code_file_path else "",
    )
    descriptors = _descriptor_values(
        axis_names=axis_names,
        design_row=design_row,
        archive_row=archive_row,
        qd_event=qd_event,
        code_file_path=code_file_path,
        descriptor_cache=descriptor_cache,
        recover=backend == "classic" and recover_classic_descriptors,
    )
    projection = _project_sample(
        archive_context["space"],
        descriptors=descriptors,
        technique=backend,
    )
    native_cell_id = _first_text(qd_event.get("cell_id"), archive_row.get("cell_id"))
    native_geometry_id = _geometry_id_for_generation(
        geometry_timeline,
        int(finite_float(row["generation"]) or 0),
    )
    native_status = "missing_descriptors"
    native_indices = None
    if native_cell_id and not native_cell_id.startswith("warmup:"):
        native_status = "native"
        native_indices = [int(part) for part in native_cell_id.split(",")]
    elif projection["archive_projection_status"] != "missing_descriptors":
        native_cell_id = projection["archive_cell_id"]
        native_indices = projection["archive_indices"]
        native_status = "projected"
    mode_global = candidate_id in backend_context["global_pareto_ids"]
    local_archive_member = bool(archive_row)
    quality_score = _first_float(
        row.get("score_from_run"),
        row.get("ppa_score"),
        design_row.get("quality_score"),
        archive_row.get("quality_score"),
        qd_event.get("quality_score"),
    )
    active_gains: list[float] = []
    for key in objective_keys:
        gain = gains[key]
        assert gain is not None
        active_gains.append(float(gain))
    sample = {
        "sample_id": f"{backend}:{benchmark}:{problem}:{candidate_id}:{row_index}",
        "technique": backend,
        "generation": int(finite_float(row["generation"]) or 0),
        "status": "ppa_valid",
        "candidate_id": candidate_id,
        "strategy": row.get("strategy", ""),
        "source": row.get("source", ""),
        "is_final_archive_member": local_archive_member,
        "mode_global_pareto_member": mode_global,
        "viewer_pooled_pareto_member": False,
        "candidate_dir": _relative_path(run_root, candidate_dir),
        "code_file_path": _relative_path(run_root, code_file_path),
        "area": metrics["area"],
        "power": metrics["power"],
        "eff_clk_period": metrics["eff_clk_period"] if circuit_type == "sequential" else None,
        "ref_area": ref["area"],
        "ref_power": ref["power"],
        "ref_eff_clk_period": ref["eff_clk_period"] if circuit_type == "sequential" else None,
        "g_A": gains["g_A"],
        "g_P": gains["g_P"],
        "g_T": gains["g_T"] if circuit_type == "sequential" else None,
        "mean_improvement": sum(active_gains) / len(active_gains),
        "descriptor_values": descriptors,
        "descriptor_tuple": [descriptors[name] for name in axis_names] if descriptors else None,
        "archive_cell_id": projection["archive_cell_id"],
        "archive_indices": projection["archive_indices"],
        "archive_projection_status": projection["archive_projection_status"],
        "projection_type": projection["projection_type"],
        "native_archive_cell_id": native_cell_id or None,
        "native_archive_indices": native_indices,
        "native_archive_geometry_id": native_geometry_id,
        "native_archive_projection_status": native_status,
        "native_projection_type": "native" if native_status == "native" else projection["projection_type"],
        "final_fixed_archive_cell_id": projection["archive_cell_id"],
        "final_fixed_archive_indices": projection["archive_indices"],
        "final_fixed_archive_geometry_id": geometry_timeline["final_geometry_id"],
        "final_fixed_projection_status": projection["archive_projection_status"],
        "pareto_rank_by_step": {"per_technique": {}, "pooled_visible": {}},
        "pareto_rank_final": None,
        "local_archive_member": local_archive_member,
        "local_cell_pareto_rank": _first_int(archive_row.get("pareto_rank")),
        "quality_score": quality_score,
        "mode_global_pareto_badge": mode_global,
    }
    for key in objective_keys:
        sample[key] = gains[key]
    return sample


def _gain(row: dict[str, str], key: str, ref_value: float | None, metric_value: float | None) -> float | None:
    value = finite_float(row.get(key))
    if value is not None:
        return value
    if ref_value is None or metric_value is None:
        return None
    denom = max(abs(ref_value), 1e-12)
    return (ref_value - metric_value) / denom


def _descriptor_values(
    *,
    axis_names: tuple[str, ...],
    design_row: dict[str, str],
    archive_row: dict[str, Any],
    qd_event: dict[str, Any],
    code_file_path: str,
    descriptor_cache: dict[str, Any],
    recover: bool,
) -> dict[str, float]:
    values = _descriptor_values_from_row(axis_names, design_row)
    if values:
        return values
    values = _descriptor_values_from_archive_row(axis_names, archive_row)
    if values:
        return values
    values = _descriptor_values_from_event(axis_names, qd_event)
    if values:
        return values
    if not recover or not code_file_path:
        return {}
    cached = descriptor_cache.get(code_file_path)
    if isinstance(cached, dict):
        values = {
            axis: float(cached[axis])
            for axis in axis_names
            if finite_float(cached.get(axis)) is not None
        }
        if len(values) == len(axis_names):
            return values
        return {}
    from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator

    metrics = GraphDescriptorEvaluator(yosys_timeout_seconds=30).extract_metrics(
        code_file_path=code_file_path,
        top_module_name=None,
    )
    descriptor_cache[code_file_path] = metrics
    values = {
        axis: float(metrics[axis])
        for axis in axis_names
        if finite_float(metrics.get(axis)) is not None
    }
    return values if len(values) == len(axis_names) else {}


def _recover_classic_descriptors_for_problem(
    *,
    axis_names: tuple[str, ...],
    rows: list[dict[str, str]],
    classic_dir_matches: dict[tuple[str, str, str, str], dict[str, str]],
    descriptor_cache: dict[str, Any],
) -> None:
    code_paths: list[str] = []
    for row in rows:
        if row["backend"] != "classic":
            continue
        match = classic_dir_matches.get((row["backend"], row["benchmark"], row["problem"], row["candidate_id"]), {})
        code_file_path = match.get("code_file_path", "")
        if not code_file_path:
            continue
        cached = descriptor_cache.get(code_file_path)
        if isinstance(cached, dict) and all(finite_float(cached.get(axis)) is not None for axis in axis_names):
            continue
        code_paths.append(code_file_path)
    unique_paths = sorted(set(code_paths))
    if not unique_paths:
        return
    tasks = [(code_file_path, axis_names) for code_file_path in unique_paths]
    with ThreadPoolExecutor(max_workers=4) as executor:
        for code_file_path, metrics in executor.map(_graph_metrics_for_code, tasks):
            descriptor_cache[code_file_path] = metrics


def _graph_metrics_for_code(task: tuple[str, tuple[str, ...]]) -> tuple[str, dict[str, float]]:
    from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator

    code_file_path, axis_names = task
    evaluator = GraphDescriptorEvaluator(yosys_timeout_seconds=30)
    if set(axis_names).issubset({"logic_depth", "ff_depth", "comb_width_log"}):
        payload = evaluator._load_yosys_json(Path(code_file_path), top_module_name=None)
        if payload is None:
            return code_file_path, {}
        graph = evaluator._build_graph_model(payload, top_module_name=None)
        metrics = evaluator._extract_journal_bd_metrics(graph)
        return code_file_path, metrics
    metrics = evaluator.extract_metrics(code_file_path=code_file_path, top_module_name=None)
    return code_file_path, metrics


def _descriptor_values_from_row(axis_names: tuple[str, ...], row: dict[str, str]) -> dict[str, float]:
    values = {
        axis: finite_float(row.get(axis))
        for axis in axis_names
    }
    if any(value is None for value in values.values()):
        return {}
    return {axis: float(value) for axis, value in values.items() if value is not None}


def _descriptor_values_from_archive_row(axis_names: tuple[str, ...], row: dict[str, Any]) -> dict[str, float]:
    raw = row.get("descriptors_json")
    if not raw:
        return {}
    payload = json.loads(str(raw)) if isinstance(raw, str) else raw
    if not isinstance(payload, list) or len(payload) != len(axis_names):
        return {}
    return {
        axis: float(value)
        for axis, value in zip(axis_names, payload, strict=True)
    }


def _descriptor_values_from_event(axis_names: tuple[str, ...], event: dict[str, Any]) -> dict[str, float]:
    graph = event.get("graph_metrics")
    if not isinstance(graph, dict):
        return {}
    values = {
        axis: finite_float(graph.get(axis))
        for axis in axis_names
    }
    if any(value is None for value in values.values()):
        return {}
    return {axis: float(value) for axis, value in values.items() if value is not None}


def _project_sample(
    space: dict[str, Any],
    *,
    descriptors: dict[str, float],
    technique: str,
) -> dict[str, Any]:
    if not descriptors:
        return {
            "archive_cell_id": None,
            "archive_indices": None,
            "archive_projection_status": "missing_descriptors",
            "projection_type": "none",
        }
    if not _archive_initialized(space):
        return {
            "archive_cell_id": None,
            "archive_indices": None,
            "archive_projection_status": "archive_uninitialized",
            "projection_type": "none",
        }
    archive_type = space["archive_type"]
    if archive_type == "grid_quantile":
        indices = [
            bisect_right([float(value) for value in axis.get("quantile_boundaries", [])], descriptors[axis["name"]])
            for axis in space["axes"]
        ]
    elif archive_type == "grid":
        indices = [_grid_index(axis, descriptors[axis["name"]]) for axis in space["axes"]]
    elif archive_type == "cvt":
        indices = [_nearest_cvt_centroid(space, descriptors)]
    else:
        raise AssertionError(f"unknown archive type: {archive_type}")
    return {
        "archive_cell_id": ",".join(str(index) for index in indices),
        "archive_indices": indices,
        "archive_projection_status": "projected" if technique == "classic" else "native",
        "projection_type": "posthoc" if technique == "classic" else "native",
    }


def _grid_index(axis: dict[str, Any], value: float) -> int:
    bins = int(axis["bins"])
    lower = float(axis["lower_bound"])
    upper = float(axis["upper_bound"])
    width = (upper - lower) / bins
    if value <= lower:
        return 0
    if value >= upper:
        return bins - 1
    return min(max(int((value - lower) / width), 0), bins - 1)


def _nearest_cvt_centroid(space: dict[str, Any], descriptors: dict[str, float]) -> int:
    geometry = space["space_geometry"]
    if not bool(geometry.get("initialized")):
        raise AssertionError("cvt archive source is not initialized")
    axes = _archive_axis_names(space)
    means = [float(value) for value in geometry["scaler_means"]]
    stds = [max(float(value), 1e-12) for value in geometry["scaler_stds"]]
    point = [
        (descriptors[axis] - mean) / std
        for axis, mean, std in zip(axes, means, stds, strict=True)
    ]
    centroids = geometry["centroids"]
    assert isinstance(centroids, list) and centroids
    distances = [
        sum((float(lhs) - float(rhs)) ** 2 for lhs, rhs in zip(point, centroid, strict=True))
        for centroid in centroids
    ]
    return min(range(len(distances)), key=lambda index: distances[index])


def _compute_rank_payloads(
    samples: list[dict[str, Any]],
    step_names: list[str],
    objective_keys: tuple[str, ...],
) -> None:
    for step_name in step_names:
        visible = _visible_samples(samples, step_name)
        by_technique: dict[str, list[dict[str, Any]]] = {}
        for sample in visible:
            by_technique.setdefault(str(sample["technique"]), []).append(sample)
        for technique_samples in by_technique.values():
            ranks = pareto_ranks(technique_samples, objective_keys)
            for sample in technique_samples:
                sample["pareto_rank_by_step"]["per_technique"][step_name] = ranks[sample["sample_id"]]
        pooled_ranks = pareto_ranks(visible, objective_keys)
        for sample in visible:
            sample["pareto_rank_by_step"]["pooled_visible"][step_name] = pooled_ranks[sample["sample_id"]]
    for sample in samples:
        sample["pareto_rank_final"] = sample["pareto_rank_by_step"]["per_technique"]["final"]
        sample["viewer_pooled_pareto_member"] = (
            sample["pareto_rank_by_step"]["pooled_visible"]["final"] == 1
        )


def _visible_samples(samples: list[dict[str, Any]], step_name: str) -> list[dict[str, Any]]:
    if step_name == "final":
        return list(samples)
    step = int(step_name)
    return [sample for sample in samples if int(sample["generation"]) <= step]


def _cell_summaries_by_step(
    samples: list[dict[str, Any]],
    step_names: list[str],
    *,
    cell_id_key: str = "archive_cell_id",
    status_key: str = "archive_projection_status",
    projection_type_key: str = "projection_type",
) -> dict[str, Any]:
    summaries: dict[str, Any] = {}
    for step_name in step_names:
        step_summary: dict[str, dict[str, Any]] = {}
        for sample in _visible_samples(samples, step_name):
            if sample[status_key] == "missing_descriptors" or sample[cell_id_key] is None:
                continue
            technique = sample["technique"]
            cell_id = sample[cell_id_key]
            assert cell_id is not None
            cells = step_summary.setdefault(technique, {})
            cell = cells.setdefault(
                cell_id,
                {
                    "cell_id": cell_id,
                    "sample_ids": [],
                    "sample_count": 0,
                    "rank1_count": 0,
                    "best_quality_score": None,
                    "best_mean_improvement": None,
                    "projection_type": sample[projection_type_key],
                },
            )
            cell["sample_ids"].append(sample["sample_id"])
            cell["sample_count"] += 1
            rank = sample["pareto_rank_by_step"]["per_technique"].get(step_name)
            if rank == 1:
                cell["rank1_count"] += 1
            quality = sample["quality_score"]
            if quality is not None and (
                cell["best_quality_score"] is None or quality > cell["best_quality_score"]
            ):
                cell["best_quality_score"] = quality
            mean_improvement = sample["mean_improvement"]
            if (
                cell["best_mean_improvement"] is None
                or mean_improvement > cell["best_mean_improvement"]
            ):
                cell["best_mean_improvement"] = mean_improvement
        summaries[step_name] = step_summary
    return summaries


def _technique_stats_by_step(
    samples: list[dict[str, Any]],
    step_names: list[str],
    objective_keys: tuple[str, ...],
) -> dict[str, Any]:
    payload: dict[str, Any] = {}
    techniques = sorted({sample["technique"] for sample in samples})
    for step_name in step_names:
        visible = _visible_samples(samples, step_name)
        step_stats: dict[str, Any] = {}
        pooled_ranks = {
            sample["sample_id"]: sample["pareto_rank_by_step"]["pooled_visible"][step_name]
            for sample in visible
        }
        pooled_front = [
            tuple(float(sample[key]) for key in objective_keys)
            for sample in visible
            if pooled_ranks[sample["sample_id"]] == 1
        ]
        step_stats["_pooled_visible"] = {
            "sample_count": len(visible),
            "rank1_count": rank_one_count(visible, pooled_ranks),
            "hypervolume": hypervolume_payload(pooled_front, objective_keys),
        }
        for technique in techniques:
            technique_samples = [
                sample
                for sample in visible
                if sample["technique"] == technique
            ]
            if not technique_samples:
                step_stats[technique] = {
                    "sample_count": 0,
                    "rank1_count": 0,
                    "pooled_rank1_contribution_count": 0,
                    "projected_archive_sample_count": 0,
                    "occupied_projected_cells": 0,
                    "hypervolume": hypervolume_payload([], objective_keys),
                }
                continue
            ranks = {
                sample["sample_id"]: sample["pareto_rank_by_step"]["per_technique"][step_name]
                for sample in technique_samples
            }
            cells = {
                sample["archive_cell_id"]
                for sample in technique_samples
                if sample["archive_cell_id"] is not None
            }
            step_stats[technique] = {
                "sample_count": len(technique_samples),
                "rank1_count": rank_one_count(technique_samples, ranks),
                "pooled_rank1_contribution_count": sum(
                    1
                    for sample in technique_samples
                    if pooled_ranks[sample["sample_id"]] == 1
                ),
                "projected_archive_sample_count": sum(
                    1
                    for sample in technique_samples
                    if sample["archive_cell_id"] is not None
                ),
                "occupied_projected_cells": len(cells),
                "hypervolume": hypervolume_payload(
                    front_points(technique_samples, ranks, objective_keys),
                    objective_keys,
                ),
            }
        payload[step_name] = step_stats
    return payload


def _load_design_index(run_root: Path) -> dict[tuple[str, str, str, str], dict[str, str]]:
    path = run_root / "final_analysis" / "design_space_analysis" / "successful_candidates.csv"
    if not path.is_file():
        return {}
    rows = _read_csv(path)
    return {
        (row["backend"], row["benchmark"], row["problem"], row["candidate_id"]): row
        for row in rows
    }


def _load_backend_context(
    *,
    backend_name: str,
    backend_root: Path,
    benchmark: str,
    problem: str,
) -> dict[str, Any]:
    problem_dir = _find_problem_dir(
        backend_root,
        benchmark=benchmark,
        problem=problem,
        require_archive=False,
    )
    if problem_dir is None:
        return {"events": {}, "archive_cells": {}, "global_pareto_ids": set(), "problem_dir": None}
    events: dict[str, dict[str, Any]] = {}
    for path in sorted(problem_dir.rglob("qd_archive_event.json")):
        payload = _load_json_dict(path)
        candidate_id = str(payload["candidate_id"])
        payload["code_file_path"] = str(path.parent / "code.sv")
        events[candidate_id] = payload
    archive_cells = _load_archive_cells(problem_dir / "archive_cells.csv")
    global_ids = _load_global_pareto_ids(problem_dir / "global_pareto_archive.csv")
    return {
        "events": events,
        "archive_cells": archive_cells,
        "global_pareto_ids": global_ids,
        "problem_dir": problem_dir,
        "backend_name": backend_name,
    }


def _load_archive_context(problem_dir: Path | None, *, strict: bool) -> dict[str, Any]:
    assert problem_dir is not None
    space_path = problem_dir / "archive_space.json"
    assert space_path.is_file()
    space = _load_json_dict(space_path)
    archive_type = space["archive_type"]
    if archive_type in ("grid_quantile", "grid"):
        pass
    elif archive_type == "cvt":
        geometry = space.get("space_geometry")
        assert isinstance(geometry, dict)
    else:
        raise AssertionError(f"unknown archive type: {archive_type}")
    return {
        "problem_dir": problem_dir,
        "space": space,
        "space_path": space_path,
        "archive_cells_path": problem_dir / "archive_cells.csv",
        "archive_history_path": problem_dir / "archive_history.jsonl",
    }


def _geometry_id(geometry: dict[str, Any]) -> str:
    encoded = json.dumps(geometry, sort_keys=True, separators=(",", ":")).encode(
        "utf-8"
    )
    return hashlib.sha256(encoded).hexdigest()


def _archive_geometry_timeline(archive_context: dict[str, Any]) -> dict[str, Any]:
    final_geometry = archive_context["space"]
    final_id = _geometry_id(final_geometry)
    snapshots_by_id: dict[str, dict[str, Any]] = {}
    markers: list[dict[str, Any]] = []
    history_path = archive_context["archive_history_path"]
    history = _load_jsonl(history_path) if history_path.is_file() else []
    for event in history:
        kind = str(event.get("event_kind", event.get("event_type", "")))
        if kind != "rebin":
            continue
        old_geometry = event["old_geometry"]
        new_geometry = event["new_geometry"]
        assert isinstance(old_geometry, dict)
        assert isinstance(new_geometry, dict)
        old_id = str(event.get("old_geometry_id") or _geometry_id(old_geometry))
        new_id = str(event.get("new_geometry_id") or _geometry_id(new_geometry))
        generation = int(event["generation"])
        snapshots_by_id.setdefault(
            old_id,
            {
                "geometry_id": old_id,
                "generation": generation,
                "rebin_count": int(event.get("total_rebin_count", 1)) - 1,
                "source": "rebin_old_geometry",
                "geometry": old_geometry,
            },
        )
        snapshots_by_id[new_id] = {
            "geometry_id": new_id,
            "generation": generation,
            "rebin_count": int(event.get("total_rebin_count", 1)),
            "source": "rebin_new_geometry",
            "geometry": new_geometry,
        }
        axis_results = [
            {
                "axis": result.get("axis"),
                "ks_p_value": result.get("ks_p_value"),
                "ks_statistic": result.get("ks_statistic"),
            }
            for result in event.get("axis_results", [])
            if isinstance(result, dict)
        ]
        markers.append(
            {
                "generation": generation,
                "trigger_axes": list(event.get("trigger_axes", [])),
                "corrected_p_threshold": event.get("corrected_p_threshold"),
                "axis_results": axis_results,
                "old_geometry_id": old_id,
                "new_geometry_id": new_id,
            }
        )
    snapshots_by_id[final_id] = {
        "geometry_id": final_id,
        "generation": "final",
        "rebin_count": int(final_geometry.get("total_rebin_count", len(markers)) or 0),
        "source": "final_archive_space",
        "geometry": final_geometry,
    }
    ordered = sorted(
        snapshots_by_id.values(),
        key=lambda item: (
            10**9 if item["generation"] == "final" else int(item["generation"]),
            int(item["rebin_count"]),
            str(item["source"]),
        ),
    )
    return {
        "snapshots": ordered,
        "markers": sorted(markers, key=lambda item: int(item["generation"])),
        "final_geometry_id": final_id,
    }


def _geometry_id_for_generation(
    geometry_timeline: dict[str, Any],
    generation: int,
) -> str:
    markers = geometry_timeline["markers"]
    if not markers:
        return str(geometry_timeline["final_geometry_id"])
    active = str(markers[0]["old_geometry_id"])
    for marker in markers:
        if generation < int(marker["generation"]):
            return active
        active = str(marker["new_geometry_id"])
    return active


def _load_archive_cells(path: Path) -> dict[str, dict[str, str]]:
    if not path.is_file():
        return {}
    rows = _read_optional_csv(path)
    return {row["candidate_id"]: row for row in rows}


def _load_global_pareto_ids(path: Path) -> set[str]:
    if not path.is_file():
        return set()
    return {row["candidate_id"] for row in _read_optional_csv(path)}


def _find_problem_dir(
    backend_root: Path,
    *,
    benchmark: str,
    problem: str,
    require_archive: bool,
) -> Path | None:
    candidates = sorted(
        path.parent
        for path in backend_root.rglob("archive_space.json" if require_archive else f"{problem}_summary.json")
        if path.parent.name == problem and path.parent.parent.name == benchmark
    )
    if candidates:
        return candidates[0]
    if require_archive:
        raise AssertionError(f"missing archive source problem dir: {backend_root} {benchmark}/{problem}")
    fallback = sorted(
        path
        for path in backend_root.rglob(problem)
        if path.is_dir() and path.name == problem and path.parent.name == benchmark
    )
    return fallback[0] if fallback else None


def _classic_dir_matches(
    *,
    backend_paths: dict[str, Path],
    rows: list[dict[str, str]],
    benchmark: str,
    problem: str,
) -> dict[tuple[str, str, str, str], dict[str, str]]:
    if "classic" not in backend_paths:
        return {}
    problem_dir = _find_problem_dir(
        backend_paths["classic"],
        benchmark=benchmark,
        problem=problem,
        require_archive=False,
    )
    if problem_dir is None:
        return {}
    candidates: dict[tuple[int, str, str], list[dict[str, str]]] = {}
    for metrics_path in sorted(problem_dir.glob("Gen*/*/code_synthesis_report.metrics.json")):
        payload = _load_json_dict(metrics_path)
        ppa = payload.get("ppa_metrics")
        if not isinstance(ppa, dict):
            continue
        gen_name = metrics_path.parent.parent.name
        generation = int(gen_name.removeprefix("Gen"))
        strategy = metrics_path.parent.name.rsplit("_", 1)[-1]
        key = (generation, strategy, _ppa_key(ppa))
        candidates.setdefault(key, []).append(
            {
                "candidate_dir": str(metrics_path.parent),
                "code_file_path": str(metrics_path.parent / "code.sv"),
                "metrics_json_path": str(metrics_path),
            }
        )
    matches: dict[tuple[str, str, str, str], dict[str, str]] = {}
    used: dict[tuple[int, str, str], int] = {}
    for row in rows:
        if row["backend"] != "classic":
            continue
        key = (int(finite_float(row["generation"]) or 0), row["strategy"], _ppa_key(row))
        choices = candidates.get(key, [])
        offset = used.get(key, 0)
        if offset >= len(choices):
            continue
        used[key] = offset + 1
        matches[(row["backend"], row["benchmark"], row["problem"], row["candidate_id"])] = choices[offset]
    return matches


def _ppa_key(values: dict[str, Any]) -> str:
    return "|".join(
        f"{metric}={float(values.get(metric, 0.0)):.12g}"
        for metric in ("area", "power", "eff_clk_period")
    )


def _circuit_type(rows: list[dict[str, str]], ref: dict[str, float | None]) -> str:
    row_types = {row.get("circuit_type", "") for row in rows if row.get("circuit_type")}
    if len(row_types) == 1:
        circuit_type = next(iter(row_types))
        if circuit_type in ("combinational", "sequential"):
            return circuit_type
    return "sequential" if ref["eff_clk_period"] not in (None, 0.0) else "combinational"


def _archive_axis_names(space: dict[str, Any]) -> tuple[str, ...]:
    axes = space["axes"]
    assert isinstance(axes, list) and axes
    return tuple(str(axis["name"]) for axis in axes)


def _archive_initialized(space: dict[str, Any]) -> bool:
    archive_type = space["archive_type"]
    if archive_type == "grid_quantile":
        return bool(space.get("initialized", False))
    if archive_type == "cvt":
        geometry = space.get("space_geometry")
        assert isinstance(geometry, dict)
        return bool(geometry.get("initialized", False))
    if archive_type == "grid":
        return True
    raise AssertionError(f"unknown archive type: {archive_type}")


def _archive_projection_metadata(space: dict[str, Any]) -> dict[str, Any]:
    archive_type = space["archive_type"]
    axes = _archive_axis_names(space)
    if not _archive_initialized(space):
        return {
            "rendering": "regular_cells",
            "projection_method": None,
            "disclaimer": "Archive bins were not initialized; PPA samples are shown without cell projection.",
        }
    if archive_type == "cvt" and len(axes) > 3:
        return {
            "rendering": "projected_grid",
            "projection_method": "axis_order_grid_projection",
            "disclaimer": "CVT coordinates are projected for display; distances are approximate.",
        }
    if archive_type == "cvt":
        return {
            "rendering": "true_centroid",
            "projection_method": None,
            "disclaimer": None,
        }
    if archive_type in ("grid", "grid_quantile"):
        return {
            "rendering": "regular_cells",
            "projection_method": None,
            "disclaimer": None,
        }
    raise AssertionError(f"unknown archive type: {archive_type}")


def _problem_source_paths(
    *,
    run_root: Path,
    archive_context: dict[str, Any],
    backend_contexts: dict[str, dict[str, Any]],
) -> list[Path]:
    paths = [
        run_root / "final_analysis" / "ppa_distribution" / "data" / "ppa_candidates.csv",
        run_root / "final_analysis" / "ppa_distribution" / "data" / "reference_ppa_metrics.csv",
        archive_context["space_path"],
        archive_context["archive_cells_path"],
    ]
    for context in backend_contexts.values():
        problem_dir = context.get("problem_dir")
        if isinstance(problem_dir, Path):
            paths.extend(
                [
                    problem_dir / "archive_cells.csv",
                    problem_dir / "global_pareto_archive.csv",
                    problem_dir / "archive_history.jsonl",
                ]
            )
    return paths


def _load_json_dict(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def _file_digest(path: Path) -> dict[str, Any]:
    return {
        "path": str(path),
        "mtime_ns": path.stat().st_mtime_ns,
        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _first_text(*values: Any) -> str:
    for value in values:
        if value not in (None, ""):
            return str(value)
    return ""


def _first_float(*values: Any) -> float | None:
    for value in values:
        parsed = finite_float(value)
        if parsed is not None:
            return parsed
    return None


def _first_int(value: Any) -> int | None:
    parsed = finite_float(value)
    if parsed is None:
        return None
    return int(parsed)


def _relative_path(root: Path, raw_path: str) -> str | None:
    if not raw_path:
        return None
    path = Path(raw_path)
    if not path.is_absolute():
        return raw_path
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)
