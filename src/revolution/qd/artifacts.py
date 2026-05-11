from __future__ import annotations

import csv
import json
import statistics
from pathlib import Path
from typing import Any

from revolution.algorithm import Heuristic
from revolution.qd.archive import CVTArchive, GridArchive, GridQuantileArchive
from revolution.qd.types import (
    ArchiveMember,
    GlobalParetoInsertResult,
    QDArchiveInsertResult,
    RankedArchiveMember,
)
from revolution.qd.visualization import QDVisualizationArtifacts, write_qd_visualizations


def write_legacy_archive_layout(
    *,
    path: str | Path,
    archive: GridArchive | CVTArchive | GridQuantileArchive,
) -> None:
    """Write the legacy layout file that older reports and tests still expect."""
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    if isinstance(archive, GridArchive):
        payload = {
            "archive_type": "grid",
            "num_cells": archive.num_cells,
            "axes": [
                {
                    "name": axis.name,
                    "bins": axis.bins,
                    "lower_bound": axis.lower_bound,
                    "upper_bound": axis.upper_bound,
                }
                for axis in archive.axes
            ],
        }
    elif isinstance(archive, GridQuantileArchive):
        payload = archive.describe_space()
    elif isinstance(archive, CVTArchive):
        scaler = archive.scaler
        payload = {
            "archive_type": "cvt",
            "num_cells": archive.num_cells,
            "axes": list(archive.axes),
            "initialized": archive.is_initialized,
            "warmup_successes": archive.warmup_successes,
            "warmup_buffer_size": archive.warmup_buffer_size(),
            "initialization_mode": archive.initialization_mode,
            "initialization_sample_count": archive.initialization_sample_count,
            "centroids": [list(centroid) for centroid in archive.centroids],
            "scaler": (
                {
                    "means": list(scaler.means),
                    "stds": list(scaler.stds),
                }
                if scaler is not None
                else None
            ),
        }
    else:
        raise TypeError(f"Unsupported archive type: {type(archive).__name__}")
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_archive_cells_csv(
    *,
    path: str | Path,
    ranked_members: list[tuple[str, RankedArchiveMember]],
) -> None:
    """Write the current archive set in one CSV row per archive member."""
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "cell_id",
        "member_index",
        "cell_member_count",
        "front_size",
        "pareto_rank",
        "crowding_distance",
        "candidate_id",
        "quality_score",
        "generation",
        "strategy",
        "parent_arity",
        "code_file_path",
        "g_P",
        "g_A",
        "g_T",
        "objectives_json",
        "descriptors_json",
        "parent_ids_json",
    ]
    front_sizes: dict[str, int] = {}
    for cell_id, _ in ranked_members:
        front_sizes[cell_id] = front_sizes.get(cell_id, 0) + 1
    member_indices: dict[str, int] = {}
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for cell_id, ranked_member in ranked_members:
            member = ranked_member.member
            candidate = member.payload
            member_index = member_indices.get(cell_id, 0)
            member_indices[cell_id] = member_index + 1
            objectives = dict(member.objectives)
            parent_ids = getattr(candidate, "parent_ids", [])
            writer.writerow(
                {
                    "cell_id": cell_id,
                    "member_index": member_index,
                    "cell_member_count": front_sizes[cell_id],
                    "front_size": front_sizes[cell_id],
                    "pareto_rank": ranked_member.pareto_rank,
                    "crowding_distance": ranked_member.crowding_distance,
                    "candidate_id": member.candidate_id,
                    "quality_score": float(member.quality_score),
                    "generation": getattr(candidate, "generation", None),
                    "strategy": getattr(candidate, "strategy", None),
                    "parent_arity": len(parent_ids),
                    "code_file_path": getattr(candidate, "code_file_path", None),
                    "g_P": float(objectives.get("g_P", 0.0)),
                    "g_A": float(objectives.get("g_A", 0.0)),
                    "g_T": float(objectives.get("g_T", 0.0)),
                    "objectives_json": json.dumps(objectives, sort_keys=True),
                    "descriptors_json": json.dumps(list(member.descriptors)),
                    "parent_ids_json": json.dumps(parent_ids),
                }
            )


def append_archive_history(
    *,
    path: str | Path,
    snapshot: dict[str, Any],
) -> None:
    """Append one QD archive snapshot to the JSONL history file."""
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(snapshot) + "\n")


def write_global_pareto_archive_csv(
    *,
    path: str | Path,
    members: list[ArchiveMember],
    benchmark: str,
    problem: str,
) -> None:
    """Write one row per global Pareto member for this problem run."""
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "candidate_id",
        "benchmark",
        "problem",
        "generation",
        "strategy",
        "parent_arity",
        "code_file_path",
        "quality_score",
        "g_P",
        "g_A",
        "g_T",
        "objectives_json",
        "descriptors_json",
        "parent_ids_json",
    ]
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for member in members:
            candidate = member.payload
            objectives = dict(member.objectives)
            parent_ids = getattr(candidate, "parent_ids", [])
            writer.writerow(
                {
                    "candidate_id": member.candidate_id,
                    "benchmark": benchmark,
                    "problem": problem,
                    "generation": getattr(candidate, "generation", None),
                    "strategy": getattr(candidate, "strategy", None),
                    "parent_arity": len(parent_ids),
                    "code_file_path": getattr(candidate, "code_file_path", None),
                    "quality_score": float(member.quality_score),
                    "g_P": float(objectives.get("g_P", 0.0)),
                    "g_A": float(objectives.get("g_A", 0.0)),
                    "g_T": float(objectives.get("g_T", 0.0)),
                    "objectives_json": json.dumps(objectives, sort_keys=True),
                    "descriptors_json": json.dumps(list(member.descriptors)),
                    "parent_ids_json": json.dumps(parent_ids),
                }
            )


def write_global_pareto_summary(
    *,
    path: str | Path,
    members: list[ArchiveMember],
    objective_names: tuple[str, ...],
) -> None:
    """Write compact global Pareto archive summary statistics."""
    payload = {
        "total_global_pareto_members": len(members),
        "global_pareto_size": len(members),
        "objective_names": list(objective_names),
        "candidate_ids": [member.candidate_id for member in members],
    }
    Path(path).write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_qd_summary_files(
    *,
    summary_path: str | Path,
    metrics_path: str | Path,
    output_dir: str | Path,
    history: list[dict[str, Any]],
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    ref_ppa_metrics: dict[str, float],
    descriptor_profile: str | None,
    descriptor_axes: tuple[str, ...],
    global_pareto_size: int,
    descriptor_health_files: tuple[str, str] | None = None,
) -> QDVisualizationArtifacts:
    """Write summary JSON files and generate the current QD visualization set."""
    visualization_artifacts = write_qd_visualizations(
        output_dir=output_dir,
        history=history,
        archive=archive,
        ref_ppa_metrics=ref_ppa_metrics,
    )
    latest = history[-1] if history else {
        "archive_type": archive.archive_type,
        "occupied_cells": archive.occupied_count(),
        "num_cells": archive.num_cells,
        "coverage": archive.occupied_count() / max(archive.num_cells, 1),
        "qd_score": 0.0,
        "best_quality": None,
        "mean_quality": None,
    }
    summary_payload = {
        "archive_type": archive.archive_type,
        "cell_mode": getattr(archive, "cell_mode"),
        "max_elites_per_cell": getattr(archive, "max_elites_per_cell"),
        "objective_names": list(getattr(archive, "objective_names")),
        "num_cells": archive.num_cells,
        "occupied_cells": latest["occupied_cells"],
        "total_archive_members": latest.get("total_archive_members", len(archive.members())),
        "archive_member_count": latest.get("archive_member_count", len(archive.members())),
        "fail_pool_size": latest.get("fail_pool_size", 0),
        "success_pool_size": latest.get("success_pool_size", 0),
        "mean_front_size": latest.get("mean_front_size", 0.0),
        "max_front_size": latest.get("max_front_size", 0),
        "global_pareto_size": latest.get("global_pareto_size", global_pareto_size),
        "coverage": latest["coverage"],
        "coverage_fail_share": latest.get("coverage_fail_share"),
        "p_fail_cap": latest.get("p_fail_cap"),
        "effective_fail_share": latest.get("effective_fail_share"),
        "total_budget": latest.get("total_budget"),
        "generated_candidate_count": latest.get("generated_candidate_count"),
        "planned_parent_source_counts": latest.get("planned_parent_source_counts", {}),
        "generated_parent_source_counts": latest.get("generated_parent_source_counts", {}),
        "qd_score": latest["qd_score"],
        "best_quality": latest["best_quality"],
        "mean_quality": latest["mean_quality"],
        "descriptor_profile": descriptor_profile,
        "descriptor_axes": list(descriptor_axes),
        "descriptor_health_files": (
            {
                "json": descriptor_health_files[0],
                "report": descriptor_health_files[1],
            }
            if descriptor_health_files is not None
            else None
        ),
        "history_length": len(history),
        "visualization_files": list(visualization_artifacts.generated_files),
    }
    if isinstance(archive, GridQuantileArchive):
        summary_payload.update(
            {
                "initialized": archive.is_initialized,
                "warmup_successes": archive.warmup_successes,
                "warmup_buffer_size": archive.warmup_buffer_size(),
                "initialization_sample_count": archive.initialization_sample_count,
                "intended_num_cells": archive.intended_num_cells,
                "effective_shape": list(archive.effective_bins)
                if archive.is_initialized
                else [],
                "collapsed_axes": list(archive.collapsed_axes)
                if archive.is_initialized
                else [],
            }
        )
    metrics_payload = {
        "archive_type": archive.archive_type,
        "cell_mode": getattr(archive, "cell_mode"),
        "max_elites_per_cell": getattr(archive, "max_elites_per_cell"),
        "objective_names": list(getattr(archive, "objective_names")),
        "num_cells": archive.num_cells,
        "occupied_cells": latest["occupied_cells"],
        "total_archive_members": latest.get("total_archive_members", len(archive.members())),
        "archive_member_count": latest.get("archive_member_count", len(archive.members())),
        "fail_pool_size": latest.get("fail_pool_size", 0),
        "success_pool_size": latest.get("success_pool_size", 0),
        "mean_front_size": latest.get("mean_front_size", 0.0),
        "max_front_size": latest.get("max_front_size", 0),
        "global_pareto_size": latest.get("global_pareto_size", global_pareto_size),
        "coverage": latest["coverage"],
        "coverage_fail_share": latest.get("coverage_fail_share"),
        "p_fail_cap": latest.get("p_fail_cap"),
        "effective_fail_share": latest.get("effective_fail_share"),
        "total_budget": latest.get("total_budget"),
        "generated_candidate_count": latest.get("generated_candidate_count"),
        "planned_parent_source_counts": latest.get("planned_parent_source_counts", {}),
        "generated_parent_source_counts": latest.get("generated_parent_source_counts", {}),
        "qd_score": latest["qd_score"],
        "best_quality": latest["best_quality"],
        "mean_quality": latest["mean_quality"],
        "descriptor_profile": descriptor_profile,
        "descriptor_axes": list(descriptor_axes),
        "descriptor_health_files": (
            {
                "json": descriptor_health_files[0],
                "report": descriptor_health_files[1],
            }
            if descriptor_health_files is not None
            else None
        ),
        "history_length": len(history),
        "latest_snapshot": latest,
        "history": history,
        "visualization_files": list(visualization_artifacts.generated_files),
    }
    if isinstance(archive, GridQuantileArchive):
        metrics_payload.update(
            {
                "initialized": archive.is_initialized,
                "warmup_successes": archive.warmup_successes,
                "warmup_buffer_size": archive.warmup_buffer_size(),
                "initialization_sample_count": archive.initialization_sample_count,
                "intended_num_cells": archive.intended_num_cells,
                "effective_shape": list(archive.effective_bins)
                if archive.is_initialized
                else [],
                "collapsed_axes": list(archive.collapsed_axes)
                if archive.is_initialized
                else [],
            }
        )
    Path(summary_path).write_text(json.dumps(summary_payload, indent=2), encoding="utf-8")
    Path(metrics_path).write_text(json.dumps(metrics_payload, indent=2), encoding="utf-8")
    return visualization_artifacts


def write_archive_space_files(
    *,
    json_path: str | Path,
    report_path: str | Path,
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    descriptor_profile: str | None,
    descriptor_axes: tuple[str, ...],
    occupied_cells: int,
    visualization_files: tuple[str, ...] = (),
) -> None:
    """Write machine-readable and human-readable archive-space descriptions."""
    payload = archive.describe_space()
    payload["descriptor_profile"] = descriptor_profile
    payload["descriptor_axes"] = list(descriptor_axes)
    payload["artifact_dir"] = str(Path(json_path).parent)
    payload["occupied_cells"] = occupied_cells
    payload["visualization_files"] = list(visualization_files)
    Path(json_path).write_text(json.dumps(payload, indent=2), encoding="utf-8")
    Path(report_path).write_text(_format_archive_space_report(payload), encoding="utf-8")


def write_descriptor_health_files(
    *,
    json_path: str | Path,
    report_path: str | Path,
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    descriptor_axes: tuple[str, ...],
    descriptor_profile: str | None,
    observations: list[dict[str, Any]],
) -> dict[str, Any]:
    """Write per-problem descriptor health diagnostics for the current run."""
    payload = _build_descriptor_health_payload(
        archive=archive,
        descriptor_axes=descriptor_axes,
        descriptor_profile=descriptor_profile,
        observations=observations,
    )
    Path(json_path).write_text(json.dumps(payload, indent=2), encoding="utf-8")
    Path(report_path).write_text(_format_descriptor_health_report(payload), encoding="utf-8")
    return payload


def write_candidate_archive_event(
    *,
    candidate: Heuristic,
    event_path: str | Path,
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    archive_axes: tuple[str, ...],
    descriptor_tuple: tuple[float, ...],
    insert_result: QDArchiveInsertResult,
    before_occupied: int,
    after_occupied: int,
    before_qd_score: float,
    after_qd_score: float,
    space_reference_file: str | None,
    global_update: GlobalParetoInsertResult | None,
) -> None:
    """Write one per-candidate archive-event record for successful QD candidates."""
    output_path = Path(event_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    descriptor_values = {
        axis: float(value) for axis, value in zip(archive_axes, descriptor_tuple)
    }
    objectives = dict(insert_result.objectives or {})
    if insert_result.decision == "warmup_buffered":
        assignment = {
            "archive_type": archive.archive_type,
            "initialized": False,
            "descriptor_tuple": list(descriptor_tuple),
            "assignment_status": "warmup_pending",
        }
    else:
        assignment = archive.describe_assignment(descriptor_tuple)
    assignment.setdefault("cell_id", insert_result.cell_id)
    payload = {
        "candidate_id": candidate.id,
        "generation": candidate.generation,
        "strategy": candidate.strategy,
        "origin_pool": candidate.origin_pool,
        "generated_mode": candidate.generated_mode,
        "archive_type": archive.archive_type,
        "cell_mode": getattr(archive, "cell_mode"),
        "max_elites_per_cell": getattr(archive, "max_elites_per_cell"),
        "objective_names": list(insert_result.objective_names),
        "archive_axes": list(archive_axes),
        "quality_score": float(getattr(candidate, "quality_score", candidate.score)),
        "ppa_metrics": dict(getattr(candidate, "ppa_metrics", {}) or {}),
        "score_components": {
            "g_P": float(objectives.get("g_P", 0.0)),
            "g_A": float(objectives.get("g_A", 0.0)),
            "g_T": float(objectives.get("g_T", 0.0)),
        },
        "objectives": objectives,
        "structural_metrics": dict(getattr(candidate, "structural_metrics", {}) or {}),
        "rtl_metrics": dict(getattr(candidate, "rtl_metrics", {}) or {}),
        "dynamic_metrics": dict(getattr(candidate, "dynamic_metrics", {}) or {}),
        "graph_metrics": dict(getattr(candidate, "graph_metrics", {}) or {}),
        "physical_metrics": dict(getattr(candidate, "physical_metrics", {}) or {}),
        "descriptor_values": descriptor_values,
        "descriptor_tuple": list(descriptor_tuple),
        "generation_candidate_index": getattr(candidate, "generation_candidate_index", None),
        "archive_insertion_index": getattr(candidate, "archive_insertion_index", None),
        "candidate_directory_basename": output_path.parent.name,
        "cell_id": insert_result.cell_id,
        "member_index": insert_result.member_index,
        "front_size": insert_result.front_size,
        "cell_member_count": insert_result.front_size,
        "pareto_rank": insert_result.pareto_rank,
        "crowding_distance": insert_result.crowding_distance,
        "evicted_candidate_id": insert_result.evicted_candidate_id,
        "evicted_pareto_rank": insert_result.evicted_pareto_rank,
        "assignment": assignment,
        "decision": insert_result.decision,
        "local_insert_decision": insert_result.decision,
        "inserted": insert_result.inserted,
        "replaced": insert_result.replaced,
        "archive_occupied_before": before_occupied,
        "archive_occupied_after": after_occupied,
        "archive_qd_score_before": before_qd_score,
        "archive_qd_score_after": after_qd_score,
        "previous_elite": _candidate_summary(
            insert_result.previous_payload,
            insert_result.previous_descriptors,
        ),
        "current_cell_elite": _candidate_summary(
            insert_result.current_payload,
            insert_result.current_descriptors,
        ),
        "space_reference_file": space_reference_file,
    }
    if global_update is not None:
        payload.update(
            {
                "global_archive_inserted": global_update.inserted,
                "global_archive_reject_reason": global_update.reject_reason,
                "global_archive_removed_count": global_update.removed_count,
                "global_archive_size": global_update.archive_size,
            }
        )
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _candidate_summary(
    candidate: Heuristic | None,
    descriptors: tuple[float, ...] | None,
) -> dict[str, Any] | None:
    if candidate is None:
        return None
    quality_score = getattr(candidate, "quality_score", candidate.score)
    return {
        "candidate_id": candidate.id,
        "quality_score": float(quality_score) if quality_score is not None else None,
        "generation": candidate.generation,
        "strategy": candidate.strategy,
        "descriptor_tuple": list(descriptors) if descriptors is not None else None,
        "code_file_path": candidate.code_file_path,
    }


def _format_archive_space_report(payload: dict[str, Any]) -> str:
    lines = [
        "# Archive Space Report",
        "",
        f"- archive_type: `{payload['archive_type']}`",
        f"- cell_mode: `{payload.get('cell_mode')}`",
        f"- num_cells: `{payload['num_cells']}`",
        f"- occupied_cells: `{payload['occupied_cells']}`",
        f"- total_archive_members: `{payload.get('total_archive_members', payload['occupied_cells'])}`",
        f"- mean_front_size: `{payload.get('mean_front_size', 1.0)}`",
        f"- max_front_size: `{payload.get('max_front_size', 1)}`",
        f"- objective_names: `{', '.join(payload.get('objective_names', []))}`",
        f"- descriptor_profile: `{payload.get('descriptor_profile')}`",
        f"- descriptor_axes: `{', '.join(payload.get('descriptor_axes', []))}`",
        f"- assignment_rule: `{payload.get('assignment_rule', 'unknown')}`",
        "",
    ]
    if payload["archive_type"] == "grid":
        geometry = payload["space_geometry"]
        lines.extend(
            [
                "## Grid Geometry",
                "",
                f"- cell count derivation: `{geometry['cell_count_derivation']} = {geometry['total_cells']}`",
                f"- cell id format: `{payload.get('cell_id_format', 'unknown')}`",
                "",
                "## Axis Split",
                "",
            ]
        )
        for axis in payload["axes"]:
            lines.append(
                f"- `{axis['name']}`: {axis['bins']} bins over "
                f"[{axis['lower_bound']}, {axis['upper_bound']}]"
            )
        if len(payload["axes"]) != 2:
            lines.extend(
                [
                    "",
                    "## Visualization Note",
                    "",
                    "- 2-axis grids emit direct archive heatmaps.",
                    "- Multi-axis grids emit per-axis marginal plots and pairwise projected occupancy/quality heatmaps.",
                    "- Multi-axis plots are projections of the full grid, not a complete rendering of every higher-dimensional cell neighborhood.",
                ]
            )
    elif payload["archive_type"] == "grid_quantile":
        geometry = payload["space_geometry"]
        lines.extend(
            [
                "## Grid Quantile Geometry",
                "",
                f"- initialized: `{payload['initialized']}`",
                f"- warmup_successes: `{payload['warmup_successes']}`",
                f"- warmup_buffer_size: `{payload['warmup_buffer_size']}`",
                f"- initialization_sample_count: `{payload['initialization_sample_count']}`",
                f"- intended bins per axis: `{payload['intended_bins_per_axis']}`",
                f"- intended cells: `{payload['intended_num_cells']}`",
                f"- effective shape: `{payload.get('effective_shape', [])}`",
                f"- collapsed_axes: `{', '.join(payload.get('collapsed_axes', [])) or 'none'}`",
                f"- quantile_method: `{payload['quantile_method']}`",
                f"- quantile_boundaries_hash: `{payload.get('quantile_boundaries_hash')}`",
                f"- cell count derivation: `{geometry['effective_cell_count_derivation']} = {geometry['total_cells']}`",
                "- exact boundary values map to the higher bin",
                "",
                "## Axis Split",
                "",
            ]
        )
        for axis in payload["axes"]:
            lines.append(
                f"- `{axis['name']}`: intended={axis['intended_bins']}, "
                f"effective={axis['effective_bins']}, "
                f"boundaries={axis['quantile_boundaries']}, "
                f"collapsed={axis['collapsed']}"
            )
    elif payload["archive_type"] == "cvt":
        geometry = payload["space_geometry"]
        scaler = geometry.get("scaler")
        lines.extend(
            [
                "## CVT Geometry",
                "",
                f"- warmup_successes: `{geometry['warmup_successes']}`",
                f"- warmup_buffer_size: `{geometry['warmup_buffer_size']}`",
                f"- initialized: `{geometry['initialized']}`",
                f"- initialization_mode: `{geometry['initialization_mode']}`",
                f"- initialization_sample_count: `{geometry['initialization_sample_count']}`",
                f"- centroid_count: `{geometry['centroid_count']}`",
                "- cells are defined by nearest centroid after frozen scaling",
                "",
            ]
        )
        if scaler is not None:
            lines.extend(
                [
                    "## Frozen Scaler",
                    "",
                    f"- means: `{scaler['means']}`",
                    f"- stds: `{scaler['stds']}`",
                    "",
                ]
            )
        lines.extend(
            [
                "## Centroid Source",
                "",
                "- Full centroid coordinates are recorded in `centroids.json`.",
            ]
        )
        if geometry.get("initialization_mode") == "run_finalization_fallback":
            lines.extend(
                [
                    "",
                    "## Finalization Note",
                    "",
                    "- This archive did not hit its configured warmup threshold during the run.",
                    "- The final archive was initialized from the available warmup buffer at run end.",
                ]
            )
    else:
        raise ValueError(f"Unsupported archive_type '{payload['archive_type']}'.")
    return "\n".join(lines) + "\n"


def _build_descriptor_health_payload(
    *,
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    descriptor_axes: tuple[str, ...],
    descriptor_profile: str | None,
    observations: list[dict[str, Any]],
) -> dict[str, Any]:
    members = archive.members()
    archive_values_by_axis = {axis: [] for axis in descriptor_axes}
    for _, member in members:
        for axis, value in zip(descriptor_axes, member.descriptors):
            archive_values_by_axis[axis].append(float(value))

    observation_values_by_axis = {axis: [] for axis in descriptor_axes}
    decision_counts: dict[str, int] = {}
    for observation in observations:
        decision = str(observation.get("decision", "unknown"))
        decision_counts[decision] = decision_counts.get(decision, 0) + 1
        values = observation.get("descriptor_values", {})
        if not isinstance(values, dict):
            continue
        for axis in descriptor_axes:
            if axis not in values:
                continue
            observation_values_by_axis[axis].append(float(values[axis]))

    axis_health: list[dict[str, Any]] = []
    collapsed_axes: list[str] = []
    for axis in descriptor_axes:
        observation_stats = _value_stats(observation_values_by_axis.get(axis, []))
        archive_stats = _value_stats(archive_values_by_axis.get(axis, []))
        zero_in_archive = archive_stats["count"] > 0 and archive_stats["nonzero_fraction"] == 0.0
        low_unique_in_archive = archive_stats["count"] > 1 and archive_stats["unique_count"] <= 1
        collapsed = zero_in_archive or low_unique_in_archive
        if collapsed:
            collapsed_axes.append(axis)
        axis_health.append(
            {
                "axis": axis,
                "observation_stats": observation_stats,
                "archive_stats": archive_stats,
                "collapsed_in_archive": collapsed,
            }
        )

    return {
        "archive_type": archive.archive_type,
        "cell_mode": getattr(archive, "cell_mode"),
        "descriptor_profile": descriptor_profile,
        "descriptor_axes": list(descriptor_axes),
        "observation_count": len(observations),
        "archive_entry_count": len(members),
        "occupied_cells": archive.occupied_count(),
        "total_archive_members": len(members),
        "decision_counts": decision_counts,
        "collapsed_axes": collapsed_axes,
        "axis_health": axis_health,
    }


def _value_stats(values: list[float]) -> dict[str, Any]:
    if not values:
        return {
            "count": 0,
            "unique_count": 0,
            "nonzero_fraction": 0.0,
            "min": None,
            "max": None,
            "mean": None,
            "stddev": None,
        }
    unique_count = len({round(value, 12) for value in values})
    nonzero_fraction = sum(value != 0.0 for value in values) / len(values)
    stddev = statistics.pstdev(values) if len(values) > 1 else 0.0
    return {
        "count": len(values),
        "unique_count": unique_count,
        "nonzero_fraction": nonzero_fraction,
        "min": min(values),
        "max": max(values),
        "mean": statistics.fmean(values),
        "stddev": stddev,
    }


def _format_descriptor_health_report(payload: dict[str, Any]) -> str:
    lines = [
        "# Descriptor Health Report",
        "",
        f"- archive_type: `{payload['archive_type']}`",
        f"- descriptor_profile: `{payload.get('descriptor_profile')}`",
        f"- descriptor_axes: `{', '.join(payload.get('descriptor_axes', []))}`",
        f"- observation_count: `{payload['observation_count']}`",
        f"- archive_entry_count: `{payload['archive_entry_count']}`",
        f"- collapsed_axes: `{', '.join(payload['collapsed_axes']) if payload['collapsed_axes'] else 'none'}`",
        "",
        "## Decision Counts",
        "",
    ]
    decision_counts = payload.get("decision_counts", {})
    if decision_counts:
        for decision, count in sorted(decision_counts.items()):
            lines.append(f"- `{decision}`: {count}")
    else:
        lines.append("- no archive-handled successful candidates were recorded")
    lines.extend(
        [
            "",
            "## Axis Health",
            "",
        ]
    )
    for axis_payload in payload.get("axis_health", []):
        observation_stats = axis_payload["observation_stats"]
        archive_stats = axis_payload["archive_stats"]
        lines.extend(
            [
                f"### {axis_payload['axis']}",
                "",
                f"- collapsed_in_archive: `{axis_payload['collapsed_in_archive']}`",
                f"- observations: count={observation_stats['count']}, unique={observation_stats['unique_count']}, "
                f"nonzero_fraction={observation_stats['nonzero_fraction']:.4f}, "
                f"mean={_fmt_optional_float(observation_stats['mean'])}, "
                f"stddev={_fmt_optional_float(observation_stats['stddev'])}",
                f"- archive_elites: count={archive_stats['count']}, unique={archive_stats['unique_count']}, "
                f"nonzero_fraction={archive_stats['nonzero_fraction']:.4f}, "
                f"mean={_fmt_optional_float(archive_stats['mean'])}, "
                f"stddev={_fmt_optional_float(archive_stats['stddev'])}",
                "",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def _fmt_optional_float(value: float | None) -> str:
    if value is None:
        return "n/a"
    return f"{value:.4f}"
