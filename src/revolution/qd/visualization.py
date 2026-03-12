from __future__ import annotations

from dataclasses import dataclass
import importlib
from pathlib import Path
from typing import Any

from revolution.qd.archive import CVTArchive, GridArchive
from revolution.qd.scoring import compute_ppa_gains


@dataclass(frozen=True)
class QDVisualizationArtifacts:
    """Collection of plot paths emitted for a QD archive snapshot."""

    generated_files: tuple[str, ...]


def write_qd_visualizations(
    *,
    output_dir: str | Path,
    history: list[dict[str, Any]],
    archive: GridArchive | CVTArchive,
    ref_ppa_metrics: dict[str, float],
) -> QDVisualizationArtifacts:
    """Write archive-history and final-archive plots for grid or CVT runs."""

    output_root = Path(output_dir)
    output_root.mkdir(parents=True, exist_ok=True)
    generated: list[str] = []

    generated.extend(_write_history_plots(output_root, history))
    entries = archive.entries()
    if not entries:
        return QDVisualizationArtifacts(generated_files=tuple(generated))

    if isinstance(archive, GridArchive):
        generated.extend(_write_grid_plots(output_root, archive, ref_ppa_metrics))
    else:
        generated.extend(_write_cvt_plots(output_root, archive, ref_ppa_metrics))
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
    if len(archive.axes) != 2:
        return generated
    shape = (archive.axes[1].bins, archive.axes[0].bins)
    occupancy = np.zeros(shape, dtype=float)
    quality = np.full(shape, np.nan, dtype=float)
    gain_maps = {
        axis: np.full(shape, np.nan, dtype=float)
        for axis in ("g_P", "g_A", "g_T")
    }

    for cell_id, entry in archive.entries().items():
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


def _parse_grid_cell_id(cell_id: str) -> tuple[int, int]:
    first, second = cell_id.split(",", 1)
    return int(first), int(second)


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
