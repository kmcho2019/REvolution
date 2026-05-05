from __future__ import annotations

from bisect import bisect_right
import csv
from dataclasses import dataclass
import hashlib
import importlib
from itertools import combinations
import json
from pathlib import Path
import shutil
from typing import Any

from revolution.qd.archive import CVTArchive, GridArchive, GridQuantileArchive
from revolution.qd.scoring import compute_ppa_gains


@dataclass(frozen=True)
class QDVisualizationArtifacts:
    """Collection of plot paths emitted for a QD archive snapshot."""

    generated_files: tuple[str, ...]


def write_qd_visualizations(
    *,
    output_dir: str | Path,
    history: list[dict[str, Any]],
    archive: GridArchive | CVTArchive | GridQuantileArchive,
    ref_ppa_metrics: dict[str, float],
) -> QDVisualizationArtifacts:
    """Write archive-history and final-archive plots for grid or CVT runs."""

    output_root = Path(output_dir)
    output_root.mkdir(parents=True, exist_ok=True)
    generated: list[str] = []

    generated.extend(_write_history_plots(output_root, history))
    if isinstance(archive, GridQuantileArchive):
        generated.extend(_write_grid_quantile_outputs(output_root, history, archive))
        return QDVisualizationArtifacts(generated_files=tuple(generated))

    entries = archive.entries()
    if not entries:
        return QDVisualizationArtifacts(generated_files=tuple(generated))

    if isinstance(archive, GridArchive):
        generated.extend(_write_grid_plots(output_root, archive, ref_ppa_metrics))
    elif isinstance(archive, CVTArchive):
        generated.extend(_write_cvt_plots(output_root, archive, ref_ppa_metrics))
    else:
        raise TypeError(f"Unsupported archive type: {type(archive).__name__}")
    return QDVisualizationArtifacts(generated_files=tuple(generated))


def refresh_grid_quantile_manifest_sources(output_dir: str | Path) -> None:
    output_root = Path(output_dir)
    manifest_path = output_root / "grid_quantile_visualization_manifest.json"
    if not manifest_path.is_file():
        return
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    manifest["source_artifacts"] = _source_artifacts(output_root)
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")


def write_grid_quantile_visualizations_from_artifacts(problem_root: str | Path) -> QDVisualizationArtifacts:
    output_dir = Path(problem_root)
    space_path = output_dir / "archive_space.json"
    history_path = output_dir / "archive_history.jsonl"
    assert space_path.is_file()
    assert history_path.is_file()
    space = json.loads(space_path.read_text(encoding="utf-8"))
    assert space["archive_type"] == "grid_quantile"
    history = [
        json.loads(line)
        for line in history_path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    generated = _write_grid_quantile_bundle(
        output_dir=output_dir,
        history=history,
        space=space,
        final_entries=_grid_quantile_csv_entries(output_dir),
        strict_events=True,
    )
    refresh_grid_quantile_manifest_sources(output_dir)
    return QDVisualizationArtifacts(generated_files=tuple(generated))


def _write_history_plots(output_dir: Path, history: list[dict[str, Any]]) -> list[str]:
    generated: list[str] = []
    if not history:
        return generated
    generated.append(
        _write_line_plot(
            output_dir / "coverage_vs_generation.png",
            history,
            metric_key="coverage",
            title="Archive Coverage vs Generation",
            ylabel="Coverage",
        )
    )
    generated.append(
        _write_line_plot(
            output_dir / "best_quality_vs_generation.png",
            history,
            metric_key="best_quality",
            title="Best Quality vs Generation",
            ylabel="Best Quality",
        )
    )
    generated.append(
        _write_line_plot(
            output_dir / "qd_score_vs_generation.png",
            history,
            metric_key="qd_score",
            title="QD Score vs Generation",
            ylabel="QD Score",
        )
    )
    return generated


def _write_line_plot(
    path: Path,
    history: list[dict[str, Any]],
    *,
    metric_key: str,
    title: str,
    ylabel: str,
) -> str:
    plt = _load_pyplot()
    generations = [int(entry.get("generation", index)) for index, entry in enumerate(history)]
    values = [float(entry.get(metric_key, 0.0) or 0.0) for entry in history]
    fig, ax = plt.subplots(figsize=(6, 4))
    ax.plot(generations, values, marker="o", linewidth=1.75)
    ax.set_title(title)
    ax.set_xlabel("Generation")
    ax.set_ylabel(ylabel)
    ax.grid(True, alpha=0.3)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _write_grid_plots(
    output_dir: Path,
    archive: GridArchive,
    ref_ppa_metrics: dict[str, float],
) -> list[str]:
    np = _load_numpy()
    generated: list[str] = []
    entries = archive.entries()
    if len(archive.axes) == 2:
        shape = (archive.axes[1].bins, archive.axes[0].bins)
        occupancy = np.zeros(shape, dtype=float)
        quality = np.full(shape, np.nan, dtype=float)
        gain_maps = {
            axis: np.full(shape, np.nan, dtype=float)
            for axis in ("g_P", "g_A", "g_T")
        }

        for cell_id, entry in entries.items():
            x_index, y_index = _parse_grid_cell_id(cell_id)
            row_index = archive.axes[1].bins - 1 - y_index
            occupancy[row_index, x_index] = 1.0
            quality[row_index, x_index] = float(entry.quality_score)
            gains = compute_ppa_gains(getattr(entry.payload, "ppa_metrics", {}), ref_ppa_metrics)
            for axis in gain_maps:
                gain_maps[axis][row_index, x_index] = float(gains.get(axis, 0.0))

        generated.append(
            _write_heatmap(
                output_dir / "grid_occupancy_heatmap.png",
                occupancy,
                title="Grid Archive Occupancy",
                xlabel=archive.axes[0].name,
                ylabel=archive.axes[1].name,
                cmap="Blues",
                fmt=".0f",
            )
        )
        generated.append(
            _write_heatmap(
                output_dir / "grid_quality_heatmap.png",
                quality,
                title="Grid Archive Quality",
                xlabel=archive.axes[0].name,
                ylabel=archive.axes[1].name,
                cmap="viridis",
            )
        )
        for axis, matrix in gain_maps.items():
            generated.append(
                _write_heatmap(
                    output_dir / f"grid_{axis}_heatmap.png",
                    matrix,
                    title=f"Grid Archive {axis} Gain",
                    xlabel=archive.axes[0].name,
                    ylabel=archive.axes[1].name,
                    cmap="coolwarm",
                )
            )
        return generated

    cell_indices = {
        cell_id: _parse_grid_cell_indices(cell_id)
        for cell_id in entries
    }
    generated.extend(
        _write_grid_marginal_plots(
            output_dir=output_dir,
            archive=archive,
            entries=entries,
            cell_indices=cell_indices,
        )
    )
    generated.extend(
        _write_grid_projection_plots(
            output_dir=output_dir,
            archive=archive,
            entries=entries,
            cell_indices=cell_indices,
        )
    )
    return generated


def _write_grid_quantile_outputs(
    output_dir: Path,
    history: list[dict[str, Any]],
    archive: GridQuantileArchive,
) -> list[str]:
    return _write_grid_quantile_bundle(
        output_dir=output_dir,
        history=history,
        space=archive.describe_space(),
        final_entries=_grid_quantile_archive_entries(archive),
        strict_events=False,
    )


def _write_grid_quantile_bundle(
    *,
    output_dir: Path,
    history: list[dict[str, Any]],
    space: dict[str, Any],
    final_entries: list[dict[str, Any]],
    strict_events: bool,
) -> list[str]:
    generated: list[str] = []
    frame_dir = output_dir / "grid_quantile_frames"
    slide_dir = output_dir / "grid_quantile_slides"
    frame_dir.mkdir(parents=True, exist_ok=True)
    slide_dir.mkdir(parents=True, exist_ok=True)
    snapshots = history or [
        {
            "generation": 0,
            "occupied_cells": len(final_entries),
            "num_cells": space["num_cells"],
            "coverage": 0.0,
        }
    ]
    events = _grid_quantile_events(output_dir)
    render = _grid_quantile_render_layout(space)
    timeline = _grid_quantile_timeline(
        history=snapshots,
        space=space,
        events=events,
        final_entries=final_entries,
        render=render,
        strict_events=strict_events,
    )
    frame_paths = []
    for index, frame in enumerate(timeline["frames"]):
        frame_path = frame_dir / f"frame_{index:04d}.png"
        _write_grid_quantile_frame(frame_path, timeline, frame, index, len(timeline["frames"]))
        frame_paths.append(frame_path)
        generated.append(str(frame_path))

    slide_indices = sorted({0, len(frame_paths) // 2, len(frame_paths) - 1})
    for slide_number, frame_index in enumerate(slide_indices):
        slide_path = slide_dir / f"slide_{slide_number:02d}.png"
        shutil.copyfile(frame_paths[frame_index], slide_path)
        generated.append(str(slide_path))

    manifest_path = output_dir / "grid_quantile_visualization_manifest.json"
    data_path = output_dir / "grid_quantile_evolution_data.json"
    data_path.write_text(json.dumps(timeline, indent=2), encoding="utf-8")
    generated.append(str(data_path))

    frames = timeline["frames"]
    final_frame = frames[-1]
    manifest = {
        "archive_type": space["archive_type"],
        "visualization_version": 2,
        "initialized": bool(space["initialized"]),
        "frame_count": len(frame_paths),
        "timeline_frame_count": len(frames),
        "history_frame_count": len(snapshots),
        "has_clean_final_frame": bool(frames[-1].get("final_clean_frame")),
        "occupied_cells": int(final_frame["occupied_cells"]),
        "frames": [str(path.relative_to(output_dir)) for path in frame_paths],
        "slides": [
            str((slide_dir / f"slide_{index:02d}.png").relative_to(output_dir))
            for index in range(len(slide_indices))
        ],
        "data_file": str(data_path.relative_to(output_dir)),
        "intended_shape": [axis["intended_bins"] for axis in space["axes"]],
        "effective_shape": list(space["effective_shape"]),
        "collapsed_axes": list(space["collapsed_axes"]),
        "axis_layout": render["axis_layout"],
        "rendered_axes": render["active_axis_names"],
        "slice_axis": render["slice_axis"],
        "slice_count": render["slice_count"],
        "visualization_mode": render["visualization_mode"],
        "cell_count_sequence": [int(frame["occupied_cells"]) for frame in frames],
        "sample_count_sequence": [int(frame["sample_count"]) for frame in frames],
        "final_cell_ids": sorted(cell["cell_id"] for cell in final_frame["cells"]),
        "animation_checks": {
            "has_multiple_frames": len(frames) > 1,
            "has_state_progression": len(
                {
                    (int(frame["occupied_cells"]), int(frame["sample_count"]))
                    for frame in frames
                }
            )
            > 1,
        },
        "encoder_warning": "webm encoder unavailable; emitted full PNG frame sequence",
        "webm": None,
        "source_artifacts": _source_artifacts(output_dir),
    }
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    generated.append(str(manifest_path))

    html_path = output_dir / "grid_quantile_occupancy_evolution.html"
    html_path.write_text(_grid_quantile_html(timeline), encoding="utf-8")
    generated.append(str(html_path))
    return generated


def _grid_quantile_archive_entries(archive: GridQuantileArchive) -> list[dict[str, Any]]:
    entries = []
    for cell_id, entry in archive.entries().items():
        entries.append(
            {
                "cell_id": cell_id,
                "candidate_id": entry.candidate_id,
                "quality_score": float(entry.quality_score),
                "generation": getattr(entry.payload, "generation", 0),
                "descriptor_tuple": list(entry.descriptors),
            }
        )
    return entries


def _grid_quantile_csv_entries(output_dir: Path) -> list[dict[str, Any]]:
    path = output_dir / "archive_cells.csv"
    assert path.is_file()
    entries = []
    with path.open(encoding="utf-8", newline="") as handle:
        for row in csv.DictReader(handle):
            entries.append(
                {
                    "cell_id": row["cell_id"],
                    "candidate_id": row["candidate_id"],
                    "quality_score": float(row["quality_score"]),
                    "generation": int(row["generation"] or 0),
                    "descriptor_tuple": json.loads(row["descriptors_json"]),
                }
            )
    return entries


def _grid_quantile_events(output_dir: Path) -> list[dict[str, Any]]:
    events = []
    for path in sorted(output_dir.rglob("qd_archive_event.json")):
        event = json.loads(path.read_text(encoding="utf-8"))
        assert event["archive_type"] == "grid_quantile"
        assert event["archive_insertion_index"] is not None
        event["_path"] = str(path.relative_to(output_dir))
        events.append(event)
    events.sort(
        key=lambda event: (
            int(event["generation"]),
            int(event["archive_insertion_index"]),
            event["_path"],
        )
    )
    return events


def _grid_quantile_render_layout(space: dict[str, Any]) -> dict[str, Any]:
    axis_names = [axis["name"] for axis in space["axes"]]
    effective_shape = list(space["effective_shape"])
    if len(axis_names) != 3 or len(effective_shape) != 3:
        return {
            "axis_layout": {},
            "axis_indices": [],
            "render_shape": [],
            "active_axis_names": [],
            "slice_axis": None,
            "slice_count": 0,
            "visualization_mode": "skipped",
            "skip_reason": "grid_quantile visualizer supports 3-axis journal profiles",
        }
    if {"logic_depth", "ff_depth", "comb_width_log"}.issubset(axis_names):
        render_names = ["logic_depth", "comb_width_log", "ff_depth"]
    else:
        render_names = axis_names[:3]
    axis_indices = [axis_names.index(name) for name in render_names]
    render_shape = [effective_shape[index] for index in axis_indices]
    active_axis_names = [
        name for name, bins in zip(render_names, render_shape) if int(bins) > 1
    ]
    mode = "3d" if len(active_axis_names) == 3 else "2d" if len(active_axis_names) == 2 else "skipped"
    slice_axis = "ff_depth" if "ff_depth" in axis_names else render_names[2]
    slice_count = int(effective_shape[axis_names.index(slice_axis)])
    return {
        "axis_layout": {"x": render_names[0], "y": render_names[1], "z": render_names[2]},
        "axis_indices": axis_indices,
        "render_shape": render_shape,
        "active_axis_names": active_axis_names,
        "slice_axis": slice_axis,
        "slice_count": max(slice_count, 1),
        "visualization_mode": mode,
        "skip_reason": None if mode != "skipped" else "fewer than two active axes",
    }


def _grid_quantile_indices(space: dict[str, Any], descriptors: list[float]) -> list[int]:
    if not space["initialized"]:
        return [0 for _ in space["axes"]]
    indices = []
    for axis, value in zip(space["axes"], descriptors):
        boundaries = [float(boundary) for boundary in axis["quantile_boundaries"]]
        indices.append(bisect_right(boundaries, float(value)))
    return indices


def _render_indices(indices: list[int], render: dict[str, Any]) -> list[int]:
    return [indices[index] for index in render["axis_indices"]]


def _grid_quantile_timeline(
    *,
    history: list[dict[str, Any]],
    space: dict[str, Any],
    events: list[dict[str, Any]],
    final_entries: list[dict[str, Any]],
    render: dict[str, Any],
    strict_events: bool,
) -> dict[str, Any]:
    event_by_id = {event["candidate_id"]: event for event in events}
    first_init_generation = None
    for snapshot in history:
        geometry = snapshot["grid_quantile_geometry"]
        if geometry["initialized"]:
            first_init_generation = int(snapshot["generation"])
            break
    if space["initialized"]:
        assert first_init_generation is not None

    replay_records = []
    for replay in space["warmup_replay_results"]:
        event = event_by_id.get(replay["candidate_id"])
        if strict_events:
            assert event is not None
        assert replay["archive_insertion_index"] is not None
        generation = int(event["generation"]) if event is not None else first_init_generation
        assert generation is not None
        replay_records.append(
            {
                "cell_id": replay["cell_id"],
                "candidate_id": replay["candidate_id"],
                "quality_score": float(replay["quality_score"]),
                "generation": generation,
                "archive_insertion_index": int(replay["archive_insertion_index"]),
                "descriptor_tuple": list(replay["descriptor_tuple"]),
                "decision": replay["decision"],
                "inserted": bool(replay["inserted"]),
            }
        )
    replay_records.sort(key=lambda item: int(item["archive_insertion_index"]))

    frame_payloads = []
    all_qualities = [
        float(item["quality_score"])
        for item in [*events, *replay_records, *final_entries]
    ]
    for snapshot_index, snapshot in enumerate(history):
        generation = int(snapshot["generation"])
        initialized = bool(snapshot["grid_quantile_geometry"]["initialized"])
        cells: dict[str, dict[str, Any]] = {}
        changed_cell_ids: set[str] = set()

        if initialized:
            for replay in replay_records:
                if replay["inserted"]:
                    cells[replay["cell_id"]] = _grid_quantile_cell_payload(render, replay)
                    if first_init_generation == generation:
                        changed_cell_ids.add(replay["cell_id"])
            for event in events:
                if event["decision"] == "warmup_buffered":
                    continue
                if int(event["generation"]) > generation:
                    continue
                if not event["inserted"] and not event["replaced"]:
                    continue
                cell_id = str(event["cell_id"])
                cells[cell_id] = _grid_quantile_cell_payload(render, event)
                if int(event["generation"]) == generation:
                    changed_cell_ids.add(cell_id)
            if not cells and generation >= int(history[-1]["generation"]):
                for entry in final_entries:
                    cells[entry["cell_id"]] = _grid_quantile_cell_payload(render, entry)

        samples = []
        for event in events:
            if int(event["generation"]) > generation:
                continue
            descriptors = list(event["descriptor_tuple"])
            indices = _grid_quantile_indices(space, descriptors)
            samples.append(
                {
                    "candidate_id": event["candidate_id"],
                    "generation": int(event["generation"]),
                    "quality_score": float(event["quality_score"]),
                    "decision": event["decision"],
                    "cell_id": event["cell_id"],
                    "indices": indices,
                    "render_indices": _render_indices(indices, render),
                    "current": int(event["generation"]) == generation,
                }
            )

        frame_cells = sorted(cells.values(), key=lambda item: item["cell_id"])
        for cell in frame_cells:
            cell["changed"] = cell["cell_id"] in changed_cell_ids
        frame_payloads.append(
            {
                "frame_index": snapshot_index,
                "generation": generation,
                "initialized": initialized,
                "phase": snapshot.get("phase", "warmup" if not initialized else "archive"),
                "occupied_cells": int(snapshot["occupied_cells"]),
                "num_cells": int(snapshot["num_cells"]),
                "coverage": float(snapshot["coverage"]),
                "best_quality": snapshot["best_quality"],
                "mean_quality": snapshot["mean_quality"],
                "qd_score": float(snapshot["qd_score"]),
                "new_filled_cells": int(snapshot.get("new_filled_cells", 0) or 0),
                "replaced_cells": int(snapshot.get("replaced_cells", 0) or 0),
                "sample_count": len(samples),
                "cells": frame_cells,
                "samples": samples,
                "changed_cell_ids": sorted(changed_cell_ids),
            }
        )
    if frame_payloads:
        final_frame = frame_payloads[-1]
        frame_payloads.append(
            {
                **final_frame,
                "frame_index": len(frame_payloads),
                "phase": "final_clean",
                "cells": [
                    {**cell, "changed": False}
                    for cell in final_frame["cells"]
                ],
                "samples": [
                    {**sample, "current": False}
                    for sample in final_frame["samples"]
                ],
                "changed_cell_ids": [],
                "final_clean_frame": True,
            }
        )

    return {
        "archive_type": "grid_quantile",
        "visualization_version": 2,
        "axes": [axis["name"] for axis in space["axes"]],
        "axis_details": [
            {
                "name": axis["name"],
                "effective_bins": int(axis["effective_bins"]),
                "quantile_boundaries": list(axis["quantile_boundaries"]),
                "intervals": list(axis["intervals"]),
                "collapsed": bool(axis["collapsed"]),
            }
            for axis in space["axes"]
        ],
        "axis_layout": render["axis_layout"],
        "render_axis_indices": render["axis_indices"],
        "render_shape": render["render_shape"],
        "effective_shape": list(space["effective_shape"]),
        "intended_shape": [axis["intended_bins"] for axis in space["axes"]],
        "collapsed_axes": list(space["collapsed_axes"]),
        "active_axis_names": render["active_axis_names"],
        "slice_axis": render["slice_axis"],
        "slice_count": render["slice_count"],
        "visualization_mode": render["visualization_mode"],
        "skip_reason": render["skip_reason"],
        "quality_min": min(all_qualities) if all_qualities else 0.0,
        "quality_max": max(all_qualities) if all_qualities else 1.0,
        "frames": frame_payloads,
    }


def _grid_quantile_cell_payload(render: dict[str, Any], record: dict[str, Any]) -> dict[str, Any]:
    indices = [int(part) for part in str(record["cell_id"]).split(",")]
    return {
        "cell_id": str(record["cell_id"]),
        "candidate_id": str(record["candidate_id"]),
        "quality_score": float(record["quality_score"]),
        "generation": int(record["generation"]),
        "descriptor_tuple": list(record["descriptor_tuple"]),
        "indices": indices,
        "render_indices": _render_indices(indices, render),
    }


def _file_digest(path: Path) -> dict[str, Any]:
    return {
        "mtime_ns": path.stat().st_mtime_ns,
        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _source_artifacts(output_dir: Path) -> dict[str, dict[str, Any]]:
    return {
        name: _file_digest(output_dir / name)
        for name in ("archive_history.jsonl", "archive_space.json", "archive_cells.csv")
        if (output_dir / name).is_file()
    }


def _write_grid_quantile_frame(
    path: Path,
    timeline: dict[str, Any],
    frame: dict[str, Any],
    frame_index: int,
    frame_count: int,
) -> None:
    np = _load_numpy()
    plt = _load_pyplot()
    shape = list(timeline.get("render_shape") or [1, 1, 1])
    active_positions = [index for index, bins in enumerate(shape) if int(bins) > 1]
    axis_layout = timeline.get("axis_layout", {})
    axis_labels = [axis_layout.get(axis, axis) for axis in ("x", "y", "z")]
    fig = plt.figure(figsize=(8, 6))
    if len(active_positions) < 2:
        ax = fig.add_subplot(111)
        ax.text(
            0.5,
            0.5,
            "Warmup pending" if not frame["initialized"] else "Degenerate archive",
            ha="center",
            va="center",
            fontsize=16,
            transform=ax.transAxes,
        )
        ax.set_axis_off()
    elif len(active_positions) == 3:
        ax = fig.add_subplot(111, projection="3d")
        for cell in frame["cells"]:
            x, y, z = cell["render_indices"]
            ax.bar3d(
                x - 0.42,
                y - 0.42,
                z - 0.42,
                0.84,
                0.84,
                0.84,
                color=plt.cm.viridis(_quality_t(timeline, cell["quality_score"])),
                alpha=0.62,
                edgecolor="#1f1c18" if cell.get("changed") else "#6b6055",
                linewidth=1.2 if cell.get("changed") else 0.45,
                shade=True,
            )
        if frame["samples"]:
            ax.scatter(
                [sample["render_indices"][0] for sample in frame["samples"]],
                [sample["render_indices"][1] for sample in frame["samples"]],
                [sample["render_indices"][2] for sample in frame["samples"]],
                c=[sample["quality_score"] for sample in frame["samples"]],
                cmap="viridis",
                vmin=timeline["quality_min"],
                vmax=timeline["quality_max"],
                s=[34 if sample["current"] else 16 for sample in frame["samples"]],
                edgecolors="black",
                linewidths=0.35,
                alpha=0.86,
            )
        ax.set_xlabel(axis_labels[0])
        ax.set_ylabel(axis_labels[1])
        ax.set_zlabel(f"{axis_labels[2]} (vertical)")
        ax.set_xticks(range(max(int(shape[0]), 1)))
        ax.set_yticks(range(max(int(shape[1]), 1)))
        ax.set_zticks(range(max(int(shape[2]), 1)))
        ax.set_xlim(-0.5, max(int(shape[0]), 1) - 0.5)
        ax.set_ylim(-0.5, max(int(shape[1]), 1) - 0.5)
        ax.set_zlim(-0.5, max(int(shape[2]), 1) - 0.5)
        ax.view_init(elev=26, azim=-42)
    else:
        ax = fig.add_subplot(111)
        x_pos, y_pos = active_positions[:2]
        matrix_shape = (max(int(shape[y_pos]), 1), max(int(shape[x_pos]), 1))
        quality = np.full(matrix_shape, np.nan, dtype=float)
        for cell in frame["cells"]:
            indices = cell["render_indices"]
            x_index = indices[x_pos]
            y_index = indices[y_pos]
            row_index = matrix_shape[0] - 1 - y_index
            current = quality[row_index, x_index]
            if np.isnan(current) or cell["quality_score"] > float(current):
                quality[row_index, x_index] = float(cell["quality_score"])
        image = ax.imshow(
            np.ma.masked_invalid(quality),
            cmap="viridis",
            aspect="equal",
            vmin=timeline["quality_min"],
            vmax=timeline["quality_max"],
        )
        for sample in frame["samples"]:
            indices = sample["render_indices"]
            ax.scatter(
                indices[x_pos],
                matrix_shape[0] - 1 - indices[y_pos],
                s=48 if sample["current"] else 20,
                c=[sample["quality_score"]],
                cmap="viridis",
                vmin=timeline["quality_min"],
                vmax=timeline["quality_max"],
                edgecolors="black",
                linewidths=0.35,
                alpha=0.82,
            )
        ax.set_xlabel(axis_labels[x_pos])
        ax.set_ylabel(axis_labels[y_pos])
        ax.set_xticks(range(matrix_shape[1]))
        ax.set_yticks(range(matrix_shape[0]))
        ax.set_yticklabels([str(index) for index in reversed(range(matrix_shape[0]))])
        fig.colorbar(image, ax=ax, shrink=0.82, label="quality_score")
    best = frame["best_quality"]
    best_text = "none" if best is None else f"{float(best):.3f}"
    fig.suptitle(
        (
            f"Frame {frame_index + 1}/{frame_count} - generation {frame['generation']} | "
            f"cells {frame['occupied_cells']} | samples {frame['sample_count']} | "
            f"best {best_text}"
        ),
        fontsize=10,
    )
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def _quality_t(timeline: dict[str, Any], value: float) -> float:
    low = float(timeline["quality_min"])
    high = float(timeline["quality_max"])
    if high <= low:
        return 0.75
    return max(0.0, min(1.0, (float(value) - low) / (high - low)))


def _grid_quantile_html(timeline: dict[str, Any]) -> str:
    data_json = json.dumps(timeline, separators=(",", ":"))
    html = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Grid Quantile MAP-Elites Evolution</title>
  <style>
    :root {
      --bg: #f5f2ea;
      --panel: rgba(255, 252, 246, 0.9);
      --border: rgba(40, 35, 30, 0.14);
      --text: #1f1c18;
      --dim: #70675d;
    }
    * { box-sizing: border-box; }
    html, body { height: 100%; margin: 0; overflow: hidden; }
    body {
      background: var(--bg);
      color: var(--text);
      font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
      font-size: 13px;
    }
    #canvas { position: fixed; inset: 0; width: 100vw; height: 100vh; cursor: grab; }
    #canvas:active { cursor: grabbing; }
    .panel {
      position: fixed;
      z-index: 2;
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: 12px;
      box-shadow: 0 10px 28px rgba(36, 28, 18, 0.09);
      backdrop-filter: blur(12px);
    }
    #title { top: 22px; left: 50%; transform: translateX(-50%); padding: 14px 24px; text-align: center; }
    #title h1 { margin: 0; font: 600 19px Georgia, serif; }
    #title .sub { margin-top: 4px; color: var(--dim); font-size: 10px; letter-spacing: 1.6px; text-transform: uppercase; }
    #stats { top: 14px; left: 14px; width: 142px; padding: 8px 9px; }
    #stats.full { width: 196px; }
    #legend { top: 18px; right: 18px; padding: 12px 14px; }
    #axisInfo {
      bottom: 22px; left: 18px; padding: 12px 14px; line-height: 1.8;
      max-width: min(390px, calc(100vw - 36px));
      max-height: calc(100vh - 160px);
      overflow-y: auto;
    }
    #slices { right: 18px; bottom: 22px; padding: 12px 14px; }
    #controls {
      left: 50%;
      bottom: 26px;
      transform: translateX(-50%);
      width: min(640px, calc(100vw - 44px));
      padding: 11px 14px;
      display: flex;
      gap: 12px;
      align-items: center;
    }
    .panel-head { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
    .label { color: var(--dim); font-size: 9px; letter-spacing: 1.6px; text-transform: uppercase; margin-bottom: 8px; }
    .panel-head .label { margin-bottom: 0; }
    .stat-row { display: flex; justify-content: space-between; gap: 10px; padding: 3px 0; border-bottom: 1px dashed var(--border); font-size: 10px; }
    .stat-row:last-child { border-bottom: 0; }
    #stats:not(.full) .optional-stat { display: none; }
    .stat-label { color: var(--dim); }
    .stat-value { font-weight: 700; font-variant-numeric: tabular-nums; }
    .mini-button {
      min-width: 38px; height: 22px; padding: 0 7px; border-radius: 6px;
      font-size: 9px; font-weight: 700;
    }
    button {
      min-width: 42px; height: 34px; border: 1px solid var(--border); border-radius: 8px;
      background: rgba(40, 30, 20, 0.05); color: var(--text); cursor: pointer;
      font: 700 11px ui-monospace, monospace; padding: 0 10px;
    }
    button:hover { background: rgba(40, 30, 20, 0.1); }
    input[type=range] { flex: 1; }
    #frameLabel { min-width: 92px; text-align: right; font-variant-numeric: tabular-nums; }
    .legend-wrap { display: flex; gap: 11px; align-items: center; }
    .gradient { width: 18px; height: 150px; border-radius: 4px; background: linear-gradient(to top,#440154,#365c8d,#1fa187,#a0da39,#fde725); }
    .ticks { height: 150px; display: flex; flex-direction: column; justify-content: space-between; color: var(--dim); font-size: 10px; }
    .axis-row { display: flex; gap: 8px; align-items: center; color: var(--dim); }
    .axis-name { color: var(--text); font-weight: 700; }
    .axis-desc { color: var(--text); }
    .axis-dot { width: 9px; height: 9px; border-radius: 2px; flex: 0 0 auto; }
    .axis-boundaries {
      margin-top: 9px; padding-top: 9px; border-top: 1px dashed var(--border);
      line-height: 1.45;
    }
    .axis-detail { margin-top: 7px; }
    .axis-detail-title { color: var(--text); font-size: 9px; font-weight: 800; }
    .axis-cutoffs, .axis-bins { color: var(--dim); font-size: 9px; }
    .slices-grid { display: flex; gap: 8px; align-items: flex-start; }
    .slice-layer { text-align: center; }
    .slice-label { text-align: center; color: var(--dim); font-size: 10px; margin-top: 6px; }
    .slice-grid { display: grid; gap: 2px; }
    .slice-cell { width: 14px; height: 14px; background: rgba(40, 30, 20, 0.08); border-radius: 2px; }
    @media (max-width: 860px) {
      #title { display: none; }
      #stats { top: 10px; left: 10px; width: 136px; }
      #legend { top: 10px; right: 10px; padding: 8px 9px; }
      #legend .gradient { width: 14px; height: 88px; }
      #legend .ticks { height: 88px; font-size: 9px; }
      #axisInfo {
        left: 10px; bottom: 88px; max-width: min(280px, calc(100vw - 20px));
        max-height: calc(100vh - 168px);
        padding: 8px 9px; line-height: 1.55;
      }
      #axisInfo .axis-row { gap: 5px; font-size: 9px; }
      #slices {
        right: 10px; bottom: 86px; max-width: min(300px, calc(100vw - 170px));
        padding: 8px 9px; overflow-x: auto;
      }
      #slices .label { margin-bottom: 6px; }
      .slices-grid { gap: 5px; }
      .slice-cell { width: 9px; height: 9px; }
      .slice-label { font-size: 8px; margin-top: 4px; }
      #controls {
        bottom: 10px; width: calc(100vw - 20px); gap: 6px; padding: 8px;
      }
      button { min-width: 38px; height: 30px; padding: 0 7px; }
      #frameLabel { min-width: 64px; font-size: 10px; }
    }
    @media (max-width: 560px) {
      #axisInfo { bottom: 140px; right: 10px; }
      #slices {
        left: 10px; right: auto; bottom: 74px;
        max-width: calc(100vw - 20px);
      }
    }
  </style>
</head>
<body>
<canvas id="canvas"></canvas>
<div class="panel" id="title">
  <h1>MAP-Elites Archive</h1>
  <div class="sub" id="subtitle"></div>
</div>
<div class="panel" id="stats">
  <div class="panel-head">
    <div class="label">Run state</div>
    <button class="mini-button" id="statsSizeBtn" title="Toggle run state size">More</button>
  </div>
  <div class="stat-row"><span class="stat-label">generation</span><span class="stat-value" id="genVal"></span></div>
  <div class="stat-row"><span class="stat-label">coverage</span><span class="stat-value" id="covVal"></span></div>
  <div class="stat-row optional-stat"><span class="stat-label">best fitness</span><span class="stat-value" id="bestVal"></span></div>
  <div class="stat-row optional-stat"><span class="stat-label">archive mean</span><span class="stat-value" id="meanVal"></span></div>
  <div class="stat-row optional-stat"><span class="stat-label">samples</span><span class="stat-value" id="sampVal"></span></div>
</div>
<div class="panel" id="legend">
  <div class="label" style="text-align:center">Fitness</div>
  <div class="legend-wrap">
    <div class="gradient"></div>
    <div class="ticks"><span id="qMax"></span><span id="qMid"></span><span id="qMin"></span></div>
  </div>
</div>
<div class="panel" id="axisInfo">
  <div class="label">BD axes</div>
  <div class="axis-row"><span class="axis-dot" style="background:#c2185b"></span><span class="axis-name">X</span><span>=</span><span class="axis-desc" id="xAxis"></span></div>
  <div class="axis-row"><span class="axis-dot" style="background:#2e7d32"></span><span class="axis-name">Y</span><span>=</span><span class="axis-desc" id="yAxis"></span></div>
  <div class="axis-row"><span class="axis-dot" style="background:#1565c0"></span><span class="axis-name">Z</span><span>=</span><span class="axis-desc" id="zAxis"></span></div>
  <div class="axis-boundaries" id="axisBoundaries"></div>
</div>
<div class="panel" id="slices">
  <div class="label" style="text-align:center">Z-slice layers</div>
  <div class="slices-grid" id="slicesGrid"></div>
</div>
<div class="panel" id="controls">
  <button id="resetBtn" title="Reset">Reset</button>
  <button id="playBtn" title="Play or pause">Play</button>
  <button id="spinBtn" title="Toggle natural spin">Spin</button>
  <input id="slider" type="range" min="0" max="0" value="0" step="1">
  <span id="frameLabel"></span>
</div>
<script>
const DATA = __DATA__;
const frames = DATA.frames || [];
const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");
const slider = document.getElementById("slider");
const playBtn = document.getElementById("playBtn");
const resetBtn = document.getElementById("resetBtn");
const spinBtn = document.getElementById("spinBtn");
const stats = document.getElementById("stats");
const statsSizeBtn = document.getElementById("statsSizeBtn");
let current = 0;
let playing = false;
let timer = 0;
let theta = -0.72;
let phi = 0.82;
let zoom = 1;
let dragging = false;
let lastX = 0;
let lastY = 0;
let naturalSpin = true;
const viridisStops = [
  [0.00,[68,1,84]],[0.13,[70,50,126]],[0.25,[54,92,141]],
  [0.38,[39,127,142]],[0.50,[31,161,135]],[0.63,[74,193,109]],
  [0.75,[160,218,57]],[1.00,[253,231,37]]
];
const shape = DATA.render_shape && DATA.render_shape.length ? DATA.render_shape : [1,1,1];
slider.max = Math.max(frames.length - 1, 0);
document.getElementById("subtitle").textContent =
  `${shape.join(" x ")} effective grid; z axis = ${DATA.axis_layout.z || "axis"}`;
document.getElementById("xAxis").textContent = DATA.axis_layout.x || "x";
document.getElementById("yAxis").textContent = DATA.axis_layout.y || "y";
document.getElementById("zAxis").textContent = `${DATA.axis_layout.z || "z"} (vertical)`;
document.getElementById("qMin").textContent = fmt(DATA.quality_min);
document.getElementById("qMid").textContent = fmt((DATA.quality_min + DATA.quality_max) / 2);
document.getElementById("qMax").textContent = fmt(DATA.quality_max);
spinBtn.textContent = naturalSpin ? "Spin on" : "Spin off";
statsSizeBtn.textContent = "More";
renderAxisBoundaries();

function fmt(value) {
  if (value === null || value === undefined || Number.isNaN(Number(value))) return "-";
  return Number(value).toFixed(3);
}
function fmtBound(value, edge) {
  if (value === null || value === undefined) return edge === "lower" ? "-inf" : "+inf";
  return fmt(value);
}
function intervalText(interval) {
  const left = interval.lower_bound === null ? "(" : interval.lower_inclusive ? "[" : "(";
  const right = interval.upper_bound === null ? ")" : interval.upper_inclusive ? "]" : ")";
  return `B${interval.index}: ${left}${fmtBound(interval.lower_bound, "lower")}, ${fmtBound(interval.upper_bound, "upper")}${right}`;
}
function renderAxisBoundaries() {
  const root = document.getElementById("axisBoundaries");
  const axes = DATA.axis_details || [];
  const rows = [["X", DATA.axis_layout.x], ["Y", DATA.axis_layout.y], ["Z", DATA.axis_layout.z]];
  root.innerHTML = "";
  for (const [label, name] of rows) {
    const axis = axes.find(item => item.name === name);
    if (!axis) continue;
    const section = document.createElement("div");
    section.className = "axis-detail";
    const title = document.createElement("div");
    title.className = "axis-detail-title";
    title.textContent = `${label} ${name}`;
    const cutoffs = document.createElement("div");
    cutoffs.className = "axis-cutoffs";
    const boundaryText = axis.quantile_boundaries.map(fmt).join(", ") || "none";
    cutoffs.textContent = `cutoffs: ${boundaryText}`;
    const bins = document.createElement("div");
    bins.className = "axis-bins";
    bins.textContent = `bins: ${axis.intervals.map(intervalText).join(" | ")}`;
    section.appendChild(title);
    section.appendChild(cutoffs);
    section.appendChild(bins);
    root.appendChild(section);
  }
}
function qualityT(value) {
  const lo = Number(DATA.quality_min), hi = Number(DATA.quality_max);
  if (hi <= lo) return 0.75;
  return Math.max(0, Math.min(1, (Number(value) - lo) / (hi - lo)));
}
function viridis(t) {
  t = Math.max(0, Math.min(1, t));
  for (let i = 0; i < viridisStops.length - 1; i++) {
    const [a, ca] = viridisStops[i], [b, cb] = viridisStops[i + 1];
    if (t >= a && t <= b) {
      const u = (t - a) / (b - a);
      return [
        ca[0] + (cb[0] - ca[0]) * u,
        ca[1] + (cb[1] - ca[1]) * u,
        ca[2] + (cb[2] - ca[2]) * u
      ];
    }
  }
  return [253, 231, 37];
}
function color(value, alpha = 1) {
  const [r, g, b] = viridis(qualityT(value));
  return `rgba(${r|0},${g|0},${b|0},${alpha})`;
}
function hash01(text, salt) {
  let h = 2166136261 + salt * 131;
  for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
  return ((h >>> 0) % 10000) / 10000;
}
function resize() {
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  canvas.width = Math.floor(window.innerWidth * dpr);
  canvas.height = Math.floor(window.innerHeight * dpr);
  canvas.style.width = `${window.innerWidth}px`;
  canvas.style.height = `${window.innerHeight}px`;
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  render();
}
function project(point) {
  const [x, y, z] = point;
  const c = Math.cos(theta), s = Math.sin(theta);
  const rx = x * c - y * s;
  const ry = x * s + y * c;
  const cp = Math.cos(phi), sp = Math.sin(phi);
  const sy = ry * cp - z * sp;
  const depth = ry * sp + z * cp;
  const scale = Math.min(window.innerWidth, window.innerHeight) * 0.18 * zoom;
  const perspective = 1 / Math.max(0.55, 1 + depth * 0.055);
  return {
    x: window.innerWidth / 2 + rx * scale * perspective,
    y: window.innerHeight * 0.56 + sy * scale * perspective,
    depth
  };
}
function centered(indices, offset = [0,0,0]) {
  return [0,1,2].map(i => Number(indices[i] || 0) + offset[i] - (Math.max(shape[i], 1) - 1) / 2);
}
function cubeCorners(indices) {
  const h = 0.45;
  const offsets = [[-h,-h,-h],[h,-h,-h],[-h,h,-h],[h,h,-h],[-h,-h,h],[h,-h,h],[-h,h,h],[h,h,h]];
  return offsets.map(offset => project(centered(indices, offset)));
}
function pathFace(points, fill, stroke, width = 1) {
  ctx.beginPath();
  ctx.moveTo(points[0].x, points[0].y);
  for (const p of points.slice(1)) ctx.lineTo(p.x, p.y);
  ctx.closePath();
  if (fill) { ctx.fillStyle = fill; ctx.fill(); }
  if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = width; ctx.stroke(); }
}
function drawCube(indices, fill, stroke, width) {
  const p = cubeCorners(indices);
  const faces = [[4,5,7,6],[2,3,7,6],[1,3,7,5],[0,1,3,2],[0,2,6,4],[0,1,5,4]];
  const sorted = faces.map(face => ({
    face,
    depth: face.reduce((sum, idx) => sum + p[idx].depth, 0) / face.length
  })).sort((a, b) => a.depth - b.depth);
  for (const item of sorted) pathFace(item.face.map(idx => p[idx]), fill, stroke, width);
}
function gridCells() {
  const cells = [];
  for (let x = 0; x < Math.max(shape[0], 1); x++) {
    for (let y = 0; y < Math.max(shape[1], 1); y++) {
      for (let z = 0; z < Math.max(shape[2], 1); z++) cells.push([x, y, z]);
    }
  }
  return cells.sort((a, b) => project(centered(a)).depth - project(centered(b)).depth);
}
function drawAxisLine(start, end, colorValue, label) {
  const a = project(start);
  const b = project(end);
  ctx.beginPath();
  ctx.moveTo(a.x, a.y);
  ctx.lineTo(b.x, b.y);
  ctx.strokeStyle = colorValue;
  ctx.lineWidth = 2.4;
  ctx.stroke();
  const angle = Math.atan2(b.y - a.y, b.x - a.x);
  ctx.beginPath();
  ctx.moveTo(b.x, b.y);
  ctx.lineTo(b.x - Math.cos(angle - 0.55) * 10, b.y - Math.sin(angle - 0.55) * 10);
  ctx.lineTo(b.x - Math.cos(angle + 0.55) * 10, b.y - Math.sin(angle + 0.55) * 10);
  ctx.closePath();
  ctx.fillStyle = colorValue;
  ctx.fill();
  ctx.font = "700 11px ui-monospace, monospace";
  ctx.fillStyle = colorValue;
  ctx.fillText(label, b.x + 8, b.y - 8);
}
function drawAxisGuides() {
  const base = centered([0,0,0], [-0.65,-0.65,-0.65]);
  drawAxisLine(base, centered([Math.max(shape[0] - 1, 0),0,0], [0.75,-0.65,-0.65]), "#c2185b", "X");
  drawAxisLine(base, centered([0,Math.max(shape[1] - 1, 0),0], [-0.65,0.75,-0.65]), "#2e7d32", "Y");
  drawAxisLine(base, centered([0,0,Math.max(shape[2] - 1, 0)], [-0.65,-0.65,0.75]), "#1565c0", "Z");
}
function drawSampleMarker(sample) {
  const jitter = [
    (hash01(sample.candidate_id, 1) - 0.5) * 0.48,
    (hash01(sample.candidate_id, 2) - 0.5) * 0.48,
    (hash01(sample.candidate_id, 3) - 0.5) * 0.32
  ];
  const p = project(centered(sample.render_indices, jitter));
  const floor = project(centered([sample.render_indices[0], sample.render_indices[1], 0], [jitter[0], jitter[1], -0.5]));
  ctx.beginPath();
  ctx.moveTo(floor.x, floor.y);
  ctx.lineTo(p.x, p.y);
  ctx.strokeStyle = "rgba(20,18,15,0.22)";
  ctx.lineWidth = sample.current ? 1.3 : 0.7;
  ctx.stroke();
  const size = sample.current ? 7 : 4.8;
  ctx.beginPath();
  ctx.moveTo(p.x, p.y - size);
  ctx.lineTo(p.x + size, p.y);
  ctx.lineTo(p.x, p.y + size);
  ctx.lineTo(p.x - size, p.y);
  ctx.closePath();
  ctx.fillStyle = color(sample.quality_score, sample.current ? 1 : 0.78);
  ctx.fill();
  ctx.strokeStyle = "rgba(20,18,15,0.82)";
  ctx.lineWidth = sample.current ? 1.4 : 0.7;
  ctx.stroke();
  ctx.beginPath();
  ctx.moveTo(p.x - size * 0.65, p.y);
  ctx.lineTo(p.x + size * 0.65, p.y);
  ctx.moveTo(p.x, p.y - size * 0.65);
  ctx.lineTo(p.x, p.y + size * 0.65);
  ctx.strokeStyle = "rgba(255,255,255,0.58)";
  ctx.lineWidth = 0.75;
  ctx.stroke();
}
function render() {
  ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);
  const frame = frames[current] || {cells: [], samples: []};
  for (const indices of gridCells()) drawCube(indices, null, "rgba(90,80,70,0.24)", 1);
  drawAxisGuides();
  const cells = [...frame.cells].sort((a, b) => {
    return project(centered(a.render_indices)).depth - project(centered(b.render_indices)).depth;
  });
  for (const cell of cells) {
    drawCube(
      cell.render_indices,
      color(cell.quality_score, cell.changed ? 0.72 : 0.48),
      cell.changed ? "rgba(20,18,15,0.95)" : "rgba(65,55,45,0.44)",
      cell.changed ? 2.2 : 1.0
    );
  }
  for (const sample of frame.samples) drawSampleMarker(sample);
}
function updateStats() {
  const frame = frames[current] || {};
  document.getElementById("genVal").textContent = `${frame.generation ?? 0}`;
  const total = frame.num_cells || 0;
  const pct = total ? `${Math.round((frame.occupied_cells || 0) / total * 100)}%` : "0%";
  document.getElementById("covVal").textContent = `${frame.occupied_cells || 0} / ${total} (${pct})`;
  document.getElementById("bestVal").textContent = fmt(frame.best_quality);
  document.getElementById("meanVal").textContent = fmt(frame.mean_quality);
  document.getElementById("sampVal").textContent = `${frame.sample_count || 0}`;
  document.getElementById("frameLabel").textContent = `frame ${current + 1} / ${frames.length}`;
  slider.value = String(current);
  updateSlices(frame);
}
function updateSlices(frame) {
  const root = document.getElementById("slicesGrid");
  root.innerHTML = "";
  const zCount = Math.max(shape[2] || 1, 1);
  const xCount = Math.max(shape[0] || 1, 1);
  const yCount = Math.max(shape[1] || 1, 1);
  const best = new Map();
  for (const cell of frame.cells || []) best.set(cell.render_indices.join(","), cell.quality_score);
  for (let z = 0; z < zCount; z++) {
    const wrap = document.createElement("div");
    wrap.className = "slice-layer";
    const grid = document.createElement("div");
    grid.className = "slice-grid";
    grid.style.gridTemplateColumns = `repeat(${xCount}, 14px)`;
    for (let y = yCount - 1; y >= 0; y--) {
      for (let x = 0; x < xCount; x++) {
        const box = document.createElement("div");
        box.className = "slice-cell";
        const q = best.get(`${x},${y},${z}`);
        if (q !== undefined) box.style.background = color(q, 1);
        grid.appendChild(box);
      }
    }
    const label = document.createElement("div");
    label.className = "slice-label";
    label.textContent = `${DATA.axis_layout.z || "z"} ${z}`;
    wrap.appendChild(grid);
    wrap.appendChild(label);
    root.appendChild(wrap);
  }
}
function show(index) {
  current = Math.max(0, Math.min(frames.length - 1, Number(index)));
  updateStats();
  render();
}
playBtn.addEventListener("click", () => {
  playing = !playing;
  playBtn.textContent = playing ? "Pause" : "Play";
  if (playing) {
    timer = window.setInterval(() => {
      if (current >= frames.length - 1) show(0);
      else show(current + 1);
    }, 850);
  } else {
    clearInterval(timer);
  }
});
spinBtn.addEventListener("click", () => {
  naturalSpin = !naturalSpin;
  spinBtn.textContent = naturalSpin ? "Spin on" : "Spin off";
  render();
});
statsSizeBtn.addEventListener("click", () => {
  stats.classList.toggle("full");
  statsSizeBtn.textContent = stats.classList.contains("full") ? "Less" : "More";
});
resetBtn.addEventListener("click", () => {
  playing = false;
  clearInterval(timer);
  playBtn.textContent = "Play";
  theta = -0.72;
  phi = 0.82;
  zoom = 1;
  naturalSpin = true;
  spinBtn.textContent = "Spin on";
  show(0);
});
slider.addEventListener("input", () => { playing = false; clearInterval(timer); playBtn.textContent = "Play"; show(slider.value); });
canvas.addEventListener("mousedown", event => { dragging = true; lastX = event.clientX; lastY = event.clientY; naturalSpin = false; spinBtn.textContent = "Spin off"; });
window.addEventListener("mouseup", () => { dragging = false; });
window.addEventListener("mousemove", event => {
  if (!dragging) return;
  theta += (event.clientX - lastX) * 0.008;
  phi += (event.clientY - lastY) * 0.006;
  lastX = event.clientX;
  lastY = event.clientY;
  render();
});
canvas.addEventListener("wheel", event => {
  event.preventDefault();
  zoom = Math.max(0.45, Math.min(3.2, zoom - event.deltaY * 0.001));
  render();
}, {passive: false});
function animateView() {
  if (naturalSpin && !dragging) {
    theta += 0.0022;
    render();
  }
  window.requestAnimationFrame(animateView);
}
window.addEventListener("resize", resize);
resize();
show(0);
animateView();
</script>
</body>
</html>
"""
    return html.replace("__DATA__", data_json)


def _parse_grid_cell_id(cell_id: str) -> tuple[int, int]:
    first, second = cell_id.split(",", 1)
    return int(first), int(second)


def _parse_grid_cell_indices(cell_id: str) -> tuple[int, ...]:
    return tuple(int(part) for part in cell_id.split(","))


def _write_heatmap(
    path: Path,
    data: Any,
    *,
    title: str,
    xlabel: str,
    ylabel: str,
    cmap: str,
    fmt: str = ".2f",
) -> str:
    np = _load_numpy()
    plt = _load_pyplot()
    fig, ax = plt.subplots(figsize=(6, 5))
    masked = np.ma.masked_invalid(data)
    image = ax.imshow(masked, aspect="auto", cmap=cmap)
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    fig.colorbar(image, ax=ax, shrink=0.85)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _write_bar_plot(
    path: Path,
    values: list[float],
    *,
    title: str,
    xlabel: str,
    ylabel: str,
    color: str,
) -> str:
    plt = _load_pyplot()
    fig, ax = plt.subplots(figsize=(6, 4))
    positions = list(range(len(values)))
    ax.bar(positions, values, color=color, alpha=0.85)
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_xticks(positions)
    ax.set_xticklabels([str(index) for index in positions])
    ax.grid(True, axis="y", alpha=0.3)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _write_grid_marginal_plots(
    *,
    output_dir: Path,
    archive: GridArchive,
    entries: dict[str, Any],
    cell_indices: dict[str, tuple[int, ...]],
) -> list[str]:
    generated: list[str] = []
    for axis_position, axis in enumerate(archive.axes):
        occupancy_counts = [0.0 for _ in range(axis.bins)]
        best_quality = [float("-inf") for _ in range(axis.bins)]
        for cell_id, entry in entries.items():
            bin_index = cell_indices[cell_id][axis_position]
            occupancy_counts[bin_index] += 1.0
            best_quality[bin_index] = max(best_quality[bin_index], float(entry.quality_score))
        best_quality_values = [
            0.0 if value == float("-inf") else value
            for value in best_quality
        ]
        generated.append(
            _write_bar_plot(
                output_dir / f"grid_{axis.name}_occupancy_marginal.png",
                occupancy_counts,
                title=f"{axis.name} Occupancy Marginal",
                xlabel=f"{axis.name} bin",
                ylabel="Occupied cells",
                color="#4C78A8",
            )
        )
        generated.append(
            _write_bar_plot(
                output_dir / f"grid_{axis.name}_quality_marginal.png",
                best_quality_values,
                title=f"{axis.name} Best Quality Marginal",
                xlabel=f"{axis.name} bin",
                ylabel="Best quality",
                color="#59A14F",
            )
        )
    return generated


def _write_grid_projection_plots(
    *,
    output_dir: Path,
    archive: GridArchive,
    entries: dict[str, Any],
    cell_indices: dict[str, tuple[int, ...]],
) -> list[str]:
    np = _load_numpy()
    generated: list[str] = []
    for first_index, second_index in combinations(range(len(archive.axes)), 2):
        first_axis = archive.axes[first_index]
        second_axis = archive.axes[second_index]
        shape = (second_axis.bins, first_axis.bins)
        occupancy = np.zeros(shape, dtype=float)
        quality = np.full(shape, np.nan, dtype=float)
        for cell_id, entry in entries.items():
            indices = cell_indices[cell_id]
            x_index = indices[first_index]
            y_index = indices[second_index]
            row_index = second_axis.bins - 1 - y_index
            occupancy[row_index, x_index] += 1.0
            existing_quality = quality[row_index, x_index]
            candidate_quality = float(entry.quality_score)
            if np.isnan(existing_quality) or candidate_quality > float(existing_quality):
                quality[row_index, x_index] = candidate_quality
        prefix = f"grid_{first_axis.name}__{second_axis.name}"
        generated.append(
            _write_heatmap(
                output_dir / f"{prefix}_occupancy_projection.png",
                occupancy,
                title=f"Grid Occupancy Projection: {first_axis.name} vs {second_axis.name}",
                xlabel=first_axis.name,
                ylabel=second_axis.name,
                cmap="Blues",
                fmt=".0f",
            )
        )
        generated.append(
            _write_heatmap(
                output_dir / f"{prefix}_quality_projection.png",
                quality,
                title=f"Grid Quality Projection: {first_axis.name} vs {second_axis.name}",
                xlabel=first_axis.name,
                ylabel=second_axis.name,
                cmap="viridis",
            )
        )
    return generated


def _write_cvt_plots(
    output_dir: Path,
    archive: CVTArchive,
    ref_ppa_metrics: dict[str, float],
) -> list[str]:
    np = _load_numpy()
    generated: list[str] = []
    if not archive.is_initialized:
        return generated
    centroids = np.asarray(archive.centroids, dtype=float)
    projected_centroids = _project_points(centroids)
    entries = archive.entries()
    occupied_points: list[Any] = []
    qualities: list[float] = []
    gain_axes = {"g_P": [], "g_A": [], "g_T": []}
    for entry in entries.values():
        cell_id = archive.cell_id_for(entry.descriptors)
        occupied_points.append(projected_centroids[int(cell_id)])
        qualities.append(float(entry.quality_score))
        gains = compute_ppa_gains(getattr(entry.payload, "ppa_metrics", {}), ref_ppa_metrics)
        for axis in gain_axes:
            gain_axes[axis].append(float(gains.get(axis, 0.0)))

    occupied = np.asarray(occupied_points, dtype=float) if occupied_points else np.zeros((0, 2))
    generated.append(
        _write_scatter_plot(
            output_dir / "cvt_quality_projection.png",
            projected_centroids,
            occupied,
            qualities,
            title="CVT Archive Quality Projection",
            color_label="Quality",
        )
    )
    for axis, values in gain_axes.items():
        generated.append(
            _write_scatter_plot(
                output_dir / f"cvt_{axis}_projection.png",
                projected_centroids,
                occupied,
                values,
                title=f"CVT Archive {axis} Gain Projection",
                color_label=axis,
            )
        )
    return generated


def _project_points(points: Any) -> Any:
    np = _load_numpy()
    if points.size == 0:
        return np.zeros((0, 2))
    if points.ndim != 2:
        raise ValueError("Expected a 2D point matrix for projection.")
    if points.shape[1] == 1:
        return np.column_stack([points[:, 0], np.zeros(points.shape[0])])
    if points.shape[1] == 2:
        return points[:, :2]
    centered = points - points.mean(axis=0, keepdims=True)
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    basis = vh[:2].T
    return centered @ basis


def _write_scatter_plot(
    path: Path,
    centroids: Any,
    occupied: Any,
    values: list[float],
    *,
    title: str,
    color_label: str,
) -> str:
    plt = _load_pyplot()
    fig, ax = plt.subplots(figsize=(6, 5))
    if len(centroids) > 0:
        ax.scatter(
            centroids[:, 0],
            centroids[:, 1],
            s=16,
            c="lightgray",
            alpha=0.45,
            linewidths=0,
            label="Centroids",
        )
    if len(occupied) > 0:
        scatter = ax.scatter(
            occupied[:, 0],
            occupied[:, 1],
            c=values,
            cmap="viridis",
            s=40,
            edgecolors="black",
            linewidths=0.35,
            label="Occupied cells",
        )
        fig.colorbar(scatter, ax=ax, shrink=0.85, label=color_label)
    ax.set_title(title)
    ax.set_xlabel("Projection 1")
    ax.set_ylabel("Projection 2")
    ax.legend(loc="best")
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _load_numpy() -> Any:
    return importlib.import_module("numpy")


def _load_pyplot() -> Any:
    matplotlib = importlib.import_module("matplotlib")
    matplotlib.use("Agg")
    return importlib.import_module("matplotlib.pyplot")
