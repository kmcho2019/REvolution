from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

from revolution.algorithm import Heuristic
from revolution.qd.archive import CVTArchive, GridArchive
from revolution.qd.scoring import compute_ppa_gains
from revolution.qd.types import QDArchiveInsertResult
from revolution.qd.visualization import QDVisualizationArtifacts, write_qd_visualizations


def write_legacy_archive_layout(
    *,
    path: str | Path,
    archive: GridArchive | CVTArchive,
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
    else:
        scaler = archive.scaler
        payload = {
            "archive_type": "cvt",
            "num_cells": archive.num_cells,
            "axes": list(archive.axes),
            "initialized": archive.is_initialized,
            "warmup_successes": archive.warmup_successes,
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
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_archive_cells_csv(
    *,
    path: str | Path,
    entries: list[tuple[str, Any]],
    ref_ppa_metrics: dict[str, float],
) -> None:
    """Write the current elite set in one CSV row per occupied cell."""
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "cell_id",
        "candidate_id",
        "quality_score",
        "generation",
        "strategy",
        "code_file_path",
        "g_P",
        "g_A",
        "g_T",
        "descriptors_json",
        "parent_ids_json",
    ]
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for cell_id, entry in entries:
            candidate = entry.payload
            gains = compute_ppa_gains(candidate.ppa_metrics, ref_ppa_metrics)
            writer.writerow(
                {
                    "cell_id": cell_id,
                    "candidate_id": candidate.id,
                    "quality_score": float(entry.quality_score),
                    "generation": candidate.generation,
                    "strategy": candidate.strategy,
                    "code_file_path": candidate.code_file_path,
                    "g_P": float(gains.get("g_P", 0.0)),
                    "g_A": float(gains.get("g_A", 0.0)),
                    "g_T": float(gains.get("g_T", 0.0)),
                    "descriptors_json": json.dumps(list(entry.descriptors)),
                    "parent_ids_json": json.dumps(candidate.parent_ids),
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


def write_qd_summary_files(
    *,
    summary_path: str | Path,
    metrics_path: str | Path,
    output_dir: str | Path,
    history: list[dict[str, Any]],
    archive: GridArchive | CVTArchive,
    ref_ppa_metrics: dict[str, float],
    descriptor_profile: str | None,
    descriptor_axes: tuple[str, ...],
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
        "num_cells": archive.num_cells,
        "occupied_cells": latest["occupied_cells"],
        "coverage": latest["coverage"],
        "qd_score": latest["qd_score"],
        "best_quality": latest["best_quality"],
        "mean_quality": latest["mean_quality"],
        "descriptor_profile": descriptor_profile,
        "descriptor_axes": list(descriptor_axes),
        "history_length": len(history),
        "visualization_files": list(visualization_artifacts.generated_files),
    }
    metrics_payload = {
        "archive_type": archive.archive_type,
        "num_cells": archive.num_cells,
        "occupied_cells": latest["occupied_cells"],
        "coverage": latest["coverage"],
        "qd_score": latest["qd_score"],
        "best_quality": latest["best_quality"],
        "mean_quality": latest["mean_quality"],
        "descriptor_profile": descriptor_profile,
        "descriptor_axes": list(descriptor_axes),
        "history_length": len(history),
        "latest_snapshot": latest,
        "history": history,
        "visualization_files": list(visualization_artifacts.generated_files),
    }
    Path(summary_path).write_text(json.dumps(summary_payload, indent=2), encoding="utf-8")
    Path(metrics_path).write_text(json.dumps(metrics_payload, indent=2), encoding="utf-8")
    return visualization_artifacts


def write_archive_space_files(
    *,
    json_path: str | Path,
    report_path: str | Path,
    archive: GridArchive | CVTArchive,
    descriptor_profile: str | None,
    descriptor_axes: tuple[str, ...],
    occupied_cells: int,
    visualization_files: tuple[str, ...] = (),
) -> None:
    """Write machine-readable and human-readable archive-space descriptions."""
    payload = archive.describe_space()
    payload["descriptor_profile"] = descriptor_profile
    payload["descriptor_axes"] = list(descriptor_axes)
    payload["occupied_cells"] = occupied_cells
    payload["visualization_files"] = list(visualization_files)
    Path(json_path).write_text(json.dumps(payload, indent=2), encoding="utf-8")
    Path(report_path).write_text(_format_archive_space_report(payload), encoding="utf-8")


def write_candidate_archive_event(
    *,
    candidate: Heuristic,
    event_path: str | Path,
    archive: GridArchive | CVTArchive,
    archive_axes: tuple[str, ...],
    descriptor_tuple: tuple[float, ...],
    insert_result: QDArchiveInsertResult,
    before_occupied: int,
    after_occupied: int,
    before_qd_score: float,
    after_qd_score: float,
    ref_ppa_metrics: dict[str, float],
    space_reference_file: str | None,
) -> None:
    """Write one per-candidate archive-event record for successful QD candidates."""
    output_path = Path(event_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    descriptor_values = {
        axis: float(value) for axis, value in zip(archive_axes, descriptor_tuple)
    }
    gains = compute_ppa_gains(candidate.ppa_metrics, ref_ppa_metrics)
    assignment = archive.describe_assignment(descriptor_tuple)
    assignment.setdefault("cell_id", insert_result.cell_id)
    payload = {
        "candidate_id": candidate.id,
        "generation": candidate.generation,
        "strategy": candidate.strategy,
        "origin_pool": candidate.origin_pool,
        "generated_mode": candidate.generated_mode,
        "archive_type": archive.archive_type,
        "archive_axes": list(archive_axes),
        "quality_score": float(getattr(candidate, "quality_score", candidate.score)),
        "score_components": {
            "g_P": float(gains.get("g_P", 0.0)),
            "g_A": float(gains.get("g_A", 0.0)),
            "g_T": float(gains.get("g_T", 0.0)),
        },
        "structural_metrics": dict(getattr(candidate, "structural_metrics", {}) or {}),
        "rtl_metrics": dict(getattr(candidate, "rtl_metrics", {}) or {}),
        "physical_metrics": dict(getattr(candidate, "physical_metrics", {}) or {}),
        "descriptor_values": descriptor_values,
        "descriptor_tuple": list(descriptor_tuple),
        "cell_id": insert_result.cell_id,
        "assignment": assignment,
        "decision": insert_result.decision,
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
        f"- num_cells: `{payload['num_cells']}`",
        f"- occupied_cells: `{payload['occupied_cells']}`",
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
    else:
        geometry = payload["space_geometry"]
        scaler = geometry.get("scaler")
        lines.extend(
            [
                "## CVT Geometry",
                "",
                f"- warmup_successes: `{geometry['warmup_successes']}`",
                f"- initialized: `{geometry['initialized']}`",
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
    return "\n".join(lines) + "\n"
