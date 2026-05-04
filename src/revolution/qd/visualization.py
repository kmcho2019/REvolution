from __future__ import annotations

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
    generated: list[str] = []
    frame_dir = output_dir / "grid_quantile_frames"
    slide_dir = output_dir / "grid_quantile_slides"
    frame_dir.mkdir(parents=True, exist_ok=True)
    slide_dir.mkdir(parents=True, exist_ok=True)
    snapshots = history or [
        {
            "generation": 0,
            "occupied_cells": archive.occupied_count(),
            "coverage": 0.0,
        }
    ]
    frame_paths = []
    for index, snapshot in enumerate(snapshots):
        frame_path = frame_dir / f"frame_{index:04d}.png"
        _write_grid_quantile_frame(frame_path, archive, snapshot, index, len(snapshots))
        frame_paths.append(frame_path)
        generated.append(str(frame_path))

    slide_indices = sorted({0, len(frame_paths) // 2, len(frame_paths) - 1})
    for slide_number, frame_index in enumerate(slide_indices):
        slide_path = slide_dir / f"slide_{slide_number:02d}.png"
        shutil.copyfile(frame_paths[frame_index], slide_path)
        generated.append(str(slide_path))

    manifest_path = output_dir / "grid_quantile_visualization_manifest.json"
    active_axes = [
        axis for axis, bins in zip(archive.axes, archive.effective_bins) if bins > 1
    ]
    collapsed_axes = list(archive.collapsed_axes) if archive.is_initialized else []
    manifest = {
        "archive_type": archive.archive_type,
        "initialized": archive.is_initialized,
        "frame_count": len(frame_paths),
        "occupied_cells": archive.occupied_count(),
        "frames": [str(path.relative_to(output_dir)) for path in frame_paths],
        "slides": [
            str((slide_dir / f"slide_{index:02d}.png").relative_to(output_dir))
            for index in range(len(slide_indices))
        ],
        "effective_shape": list(archive.effective_bins) if archive.is_initialized else [],
        "collapsed_axes": collapsed_axes,
        "rendered_axes": active_axes[:3],
        "visualization_mode": "3d" if len(active_axes) == 3 else "2d" if len(active_axes) == 2 else "skipped",
        "encoder_warning": "webm encoder unavailable; emitted full PNG frame sequence",
        "webm": None,
        "source_artifacts": _source_artifacts(output_dir),
    }
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    generated.append(str(manifest_path))

    html_path = output_dir / "grid_quantile_occupancy_evolution.html"
    html_path.write_text(_grid_quantile_html(manifest), encoding="utf-8")
    generated.append(str(html_path))
    return generated


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
    archive: GridQuantileArchive,
    snapshot: dict[str, Any],
    frame_index: int,
    frame_count: int,
) -> None:
    np = _load_numpy()
    plt = _load_pyplot()
    active_positions = [
        index for index, bins in enumerate(archive.effective_bins) if bins > 1
    ]
    fig = plt.figure(figsize=(7, 6))
    if not archive.is_initialized or len(active_positions) < 2:
        ax = fig.add_subplot(111)
        ax.text(
            0.5,
            0.5,
            "Warmup pending" if not archive.is_initialized else "Visualization skipped",
            ha="center",
            va="center",
            fontsize=16,
            transform=ax.transAxes,
        )
        ax.set_axis_off()
    elif len(active_positions) == 3:
        ax = fig.add_subplot(111, projection="3d")
        x_pos, y_pos, z_pos = active_positions
        xs: list[int] = []
        ys: list[int] = []
        zs: list[int] = []
        qualities: list[float] = []
        for cell_id, entry in archive.entries().items():
            indices = tuple(int(part) for part in cell_id.split(","))
            xs.append(indices[x_pos])
            ys.append(indices[y_pos])
            zs.append(indices[z_pos])
            qualities.append(float(entry.quality_score))
        scatter = ax.scatter(
            xs,
            ys,
            zs,
            c=qualities,
            cmap="viridis",
            s=120,
            edgecolors="black",
        )
        ax.set_xlabel(archive.axes[x_pos])
        ax.set_ylabel(archive.axes[y_pos])
        ax.set_zlabel(archive.axes[z_pos])
        ax.set_xticks(range(archive.effective_bins[x_pos]))
        ax.set_yticks(range(archive.effective_bins[y_pos]))
        ax.set_zticks(range(archive.effective_bins[z_pos]))
        ax.set_xlim(-0.5, archive.effective_bins[x_pos] - 0.5)
        ax.set_ylim(-0.5, archive.effective_bins[y_pos] - 0.5)
        ax.set_zlim(-0.5, archive.effective_bins[z_pos] - 0.5)
        ax.set_title("Grid Quantile Archive Occupancy")
        if qualities:
            fig.colorbar(scatter, ax=ax, shrink=0.72, label="quality_score")
    else:
        ax = fig.add_subplot(111)
        x_pos, y_pos = active_positions[:2]
        shape = (archive.effective_bins[y_pos], archive.effective_bins[x_pos])
        quality = np.full(shape, np.nan, dtype=float)
        for cell_id, entry in archive.entries().items():
            indices = tuple(int(part) for part in cell_id.split(","))
            x_index = indices[x_pos]
            y_index = indices[y_pos]
            row_index = archive.effective_bins[y_pos] - 1 - y_index
            current = quality[row_index, x_index]
            if np.isnan(current) or entry.quality_score > float(current):
                quality[row_index, x_index] = float(entry.quality_score)
        image = ax.imshow(np.ma.masked_invalid(quality), cmap="viridis", aspect="equal")
        ax.set_xlabel(archive.axes[x_pos])
        ax.set_ylabel(archive.axes[y_pos])
        ax.set_xticks(range(archive.effective_bins[x_pos]))
        ax.set_yticks(range(archive.effective_bins[y_pos]))
        ax.set_title("Grid Quantile Archive Occupancy")
        fig.colorbar(image, ax=ax, shrink=0.82, label="quality_score")
    fig.suptitle(
        f"Frame {frame_index + 1}/{frame_count} - generation {snapshot.get('generation')}",
        fontsize=10,
    )
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def _grid_quantile_html(manifest: dict[str, Any]) -> str:
    frames = manifest["frames"]
    options = "\n".join(
        f'<option value="{index}">Frame {index + 1}</option>'
        for index in range(len(frames))
    )
    frame_json = json.dumps(frames)
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Grid Quantile Occupancy Evolution</title>
  <style>
    body {{ margin: 0; font-family: system-ui, sans-serif; background: #f7f5ef; color: #1f2933; }}
    main {{ max-width: 980px; margin: 0 auto; padding: 24px; }}
    img {{ width: 100%; border: 1px solid #d8d3c4; background: white; }}
    .controls {{ display: flex; gap: 12px; align-items: center; margin: 16px 0; }}
    input[type=range] {{ flex: 1; }}
  </style>
</head>
<body>
<main>
  <h1>Grid Quantile Occupancy Evolution</h1>
  <div class="controls">
    <button id="play">Play</button>
    <input id="slider" type="range" min="0" max="{max(len(frames) - 1, 0)}" value="0">
    <select id="select">{options}</select>
  </div>
  <img id="frame" src="{frames[0] if frames else ''}" alt="Grid quantile frame">
</main>
<script>
const frames = {frame_json};
const image = document.getElementById("frame");
const slider = document.getElementById("slider");
const select = document.getElementById("select");
const play = document.getElementById("play");
let timer = null;
function show(index) {{
  slider.value = index;
  select.value = index;
  image.src = frames[index];
}}
slider.addEventListener("input", () => show(Number(slider.value)));
select.addEventListener("change", () => show(Number(select.value)));
play.addEventListener("click", () => {{
  if (timer) {{
    clearInterval(timer);
    timer = null;
    play.textContent = "Play";
    return;
  }}
  play.textContent = "Pause";
  timer = setInterval(() => {{
    const next = (Number(slider.value) + 1) % frames.length;
    show(next);
  }}, 700);
}});
</script>
</body>
</html>
"""


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
