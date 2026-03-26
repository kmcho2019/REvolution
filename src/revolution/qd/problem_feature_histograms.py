from __future__ import annotations

from dataclasses import dataclass
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")

from matplotlib.lines import Line2D
from matplotlib.patches import Patch
import matplotlib.pyplot as plt
import numpy as np


DEFAULT_OUTPUT_SUBDIR = "qd_feature_histograms"
DEFAULT_HISTOGRAM_BINS = 16
DEFAULT_DPI = 180


@dataclass(frozen=True)
class SuccessfulQDObservation:
    candidate_id: str
    generation: int
    quality_score: float
    descriptor_values: dict[str, float]
    decision: str


@dataclass(frozen=True)
class CVTHistogramAxis:
    name: str
    values: tuple[float, ...]
    centroid_positions: tuple[float, ...]
    division_positions: tuple[float, ...]
    bin_edges: tuple[float, ...]
    x_limits: tuple[float, float]
    cumulative_histograms: tuple[tuple[int, ...], ...]


@dataclass(frozen=True)
class CVTProblemFeatureHistogramArtifacts:
    problem_dir: str
    output_dir: str
    generated_files: tuple[str, ...]
    success_count: int
    generations: tuple[int, ...]
    axes: tuple[str, ...]
    centroid_count: int
    warmup_successes: int | None
    initialization_generation: int | None


def write_problem_feature_histograms(
    *,
    problem_dir: str | Path,
    output_subdir: str = DEFAULT_OUTPUT_SUBDIR,
    bins: int = DEFAULT_HISTOGRAM_BINS,
    dpi: int = DEFAULT_DPI,
) -> CVTProblemFeatureHistogramArtifacts:
    problem_root = Path(problem_dir)
    if not problem_root.is_dir():
        raise ValueError(f"Problem directory does not exist: {problem_root}")
    if bins <= 0:
        raise ValueError("Histogram bins must be > 0.")

    archive_context = _load_cvt_archive_context(problem_root)
    observations = _load_successful_qd_observations(problem_root, archive_context["axes"])
    if not observations:
        raise ValueError(f"No qd_archive_event.json files found under {problem_root}")

    generations = _load_generations(problem_root, observations)
    initialization_generation = _infer_initialization_generation(observations)
    axes = _build_histogram_axes(
        axis_names=archive_context["axes"],
        observations=observations,
        generations=generations,
        raw_centroids=archive_context["raw_centroids"],
        bins=bins,
    )

    output_dir = problem_root / output_subdir
    output_dir.mkdir(parents=True, exist_ok=True)

    benchmark = problem_root.parent.name
    problem = problem_root.name
    title_prefix = f"{benchmark} / {problem}"

    final_path = output_dir / "final_feature_histograms.png"
    historical_path = output_dir / "historical_feature_histograms.png"
    summary_path = output_dir / "summary.json"

    _write_final_histograms(
        path=final_path,
        title_prefix=title_prefix,
        axes=axes,
        success_count=len(observations),
        centroid_count=len(archive_context["raw_centroids"]),
        bins=bins,
        dpi=dpi,
    )
    _write_historical_histograms(
        path=historical_path,
        title_prefix=title_prefix,
        axes=axes,
        generations=generations,
        centroid_count=len(archive_context["raw_centroids"]),
        initialization_generation=initialization_generation,
        bins=bins,
        dpi=dpi,
    )

    summary_payload = {
        "benchmark": benchmark,
        "problem": problem,
        "problem_dir": str(problem_root),
        "output_dir": str(output_dir),
        "archive_type": "cvt",
        "centroids_initialized": archive_context["centroids_initialized"],
        "success_count": len(observations),
        "generation_count": len(generations),
        "generations": list(generations),
        "centroid_count": len(archive_context["raw_centroids"]),
        "warmup_successes": archive_context["warmup_successes"],
        "initialization_generation": initialization_generation,
        "histogram_bins": bins,
        "notes": _build_summary_notes(
            centroids_initialized=archive_context["centroids_initialized"],
        ),
        "generated_files": [
            str(final_path),
            str(historical_path),
        ],
        "axes": [
            {
                "name": axis.name,
                "value_count": len(axis.values),
                "x_min": axis.x_limits[0],
                "x_max": axis.x_limits[1],
                "centroid_count": len(axis.centroid_positions),
                "unique_centroid_position_count": len(_count_positions(axis.centroid_positions)),
                "division_count": len(axis.division_positions),
                "centroid_positions": list(axis.centroid_positions),
                "centroid_position_counts": [
                    {"position": position, "count": count}
                    for position, count in _count_positions(axis.centroid_positions)
                ],
                "division_positions": list(axis.division_positions),
            }
            for axis in axes
        ],
    }
    summary_path.write_text(json.dumps(summary_payload, indent=2), encoding="utf-8")

    return CVTProblemFeatureHistogramArtifacts(
        problem_dir=str(problem_root),
        output_dir=str(output_dir),
        generated_files=(str(final_path), str(historical_path), str(summary_path)),
        success_count=len(observations),
        generations=tuple(generations),
        axes=tuple(axis.name for axis in axes),
        centroid_count=len(archive_context["raw_centroids"]),
        warmup_successes=archive_context["warmup_successes"],
        initialization_generation=initialization_generation,
    )


def _load_cvt_archive_context(problem_root: Path) -> dict[str, Any]:
    centroids_path = problem_root / "centroids.json"
    if not centroids_path.is_file():
        raise ValueError(f"Missing centroids.json for CVT problem: {problem_root}")
    payload = _load_json_object(centroids_path)
    archive_type = payload.get("archive_type")
    if archive_type != "cvt":
        raise ValueError(f"Problem is not a CVT archive: {problem_root}")
    axes = payload.get("axes")
    if not isinstance(axes, list) or not axes or not all(isinstance(axis, str) for axis in axes):
        raise ValueError(f"Invalid centroid axes in {centroids_path}")
    initialized = bool(payload.get("initialized"))
    if not initialized:
        return {
            "axes": tuple(axes),
            "raw_centroids": np.empty((0, len(axes)), dtype=float),
            "warmup_successes": _safe_int(payload.get("warmup_successes")),
            "centroids_initialized": False,
        }
    centroids = payload.get("centroids")
    scaler = payload.get("scaler")
    if not isinstance(centroids, list) or not centroids:
        raise ValueError(f"Missing frozen CVT centroids for {problem_root}")
    if not isinstance(scaler, dict):
        raise ValueError(f"Missing scaler payload in {centroids_path}")
    means = scaler.get("means")
    stds = scaler.get("stds")
    if not isinstance(means, list) or not isinstance(stds, list):
        raise ValueError(f"Invalid scaler payload in {centroids_path}")
    if len(means) != len(axes) or len(stds) != len(axes):
        raise ValueError(f"Scaler dimensionality mismatch in {centroids_path}")

    centroid_matrix = np.asarray(centroids, dtype=float)
    if centroid_matrix.ndim != 2 or centroid_matrix.shape[1] != len(axes):
        raise ValueError(f"Invalid centroid matrix in {centroids_path}")
    means_array = np.asarray(means, dtype=float)
    stds_array = np.asarray(stds, dtype=float)
    raw_centroids = centroid_matrix * stds_array + means_array

    return {
        "axes": tuple(axes),
        "raw_centroids": raw_centroids,
        "warmup_successes": _safe_int(payload.get("warmup_successes")),
        "centroids_initialized": True,
    }


def _load_successful_qd_observations(
    problem_root: Path,
    axis_names: tuple[str, ...],
) -> list[SuccessfulQDObservation]:
    observations: list[SuccessfulQDObservation] = []
    for event_path in sorted(problem_root.rglob("qd_archive_event.json")):
        payload = _load_json_object(event_path)
        descriptor_values = payload.get("descriptor_values")
        if not isinstance(descriptor_values, dict):
            continue
        generation = _safe_int(payload.get("generation"))
        if generation is None:
            continue
        axis_payload: dict[str, float] = {}
        missing_axis = False
        for axis in axis_names:
            value = _safe_float(descriptor_values.get(axis))
            if value is None:
                missing_axis = True
                break
            axis_payload[axis] = value
        if missing_axis:
            continue
        observations.append(
            SuccessfulQDObservation(
                candidate_id=str(payload.get("candidate_id", event_path.parent.name)),
                generation=generation,
                quality_score=_safe_float(payload.get("quality_score")) or 0.0,
                descriptor_values=axis_payload,
                decision=str(payload.get("decision", "unknown")),
            )
        )
    observations.sort(key=lambda item: (item.generation, item.candidate_id))
    return observations


def _load_generations(
    problem_root: Path,
    observations: list[SuccessfulQDObservation],
) -> list[int]:
    history_path = problem_root / "archive_history.jsonl"
    generations = _load_jsonl_generation_values(history_path)
    if generations:
        return generations
    generation_log_path = problem_root / "generation_log.jsonl"
    generations = _load_jsonl_generation_values(generation_log_path)
    if generations:
        return generations
    return sorted({item.generation for item in observations})


def _load_jsonl_generation_values(path: Path) -> list[int]:
    if not path.is_file():
        return []
    generations: set[int] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        try:
            payload = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(payload, dict):
            continue
        generation = _safe_int(payload.get("generation"))
        if generation is not None:
            generations.add(generation)
    return sorted(generations)


def _infer_initialization_generation(
    observations: list[SuccessfulQDObservation],
) -> int | None:
    for observation in observations:
        if observation.decision != "warmup_buffered":
            return observation.generation
    return None


def _build_histogram_axes(
    *,
    axis_names: tuple[str, ...],
    observations: list[SuccessfulQDObservation],
    generations: list[int],
    raw_centroids: np.ndarray,
    bins: int,
) -> list[CVTHistogramAxis]:
    per_generation_values: dict[int, dict[str, list[float]]] = {
        generation: {axis: [] for axis in axis_names}
        for generation in generations
    }
    for observation in observations:
        bucket = per_generation_values.setdefault(
            observation.generation,
            {axis: [] for axis in axis_names},
        )
        for axis in axis_names:
            bucket[axis].append(observation.descriptor_values[axis])

    axes: list[CVTHistogramAxis] = []
    for axis_index, axis_name in enumerate(axis_names):
        values = tuple(
            observation.descriptor_values[axis_name] for observation in observations
        )
        centroid_positions = tuple(
            float(value) for value in sorted(raw_centroids[:, axis_index].tolist())
        )
        unique_centroid_positions = tuple(
            position for position, _ in _count_positions(centroid_positions)
        )
        division_positions = _sorted_unique(
            list(_projected_divisions(unique_centroid_positions))
        )
        x_limits = _compute_axis_limits(values, centroid_positions, division_positions)
        bin_edges = tuple(np.linspace(x_limits[0], x_limits[1], bins + 1))

        cumulative_values: list[float] = []
        cumulative_histograms: list[tuple[int, ...]] = []
        for generation in generations:
            cumulative_values.extend(per_generation_values.get(generation, {}).get(axis_name, []))
            histogram, _ = np.histogram(cumulative_values, bins=bin_edges)
            cumulative_histograms.append(tuple(int(value) for value in histogram.tolist()))

        axes.append(
            CVTHistogramAxis(
                name=axis_name,
                values=values,
                centroid_positions=centroid_positions,
                division_positions=division_positions,
                bin_edges=bin_edges,
                x_limits=x_limits,
                cumulative_histograms=tuple(cumulative_histograms),
            )
        )
    return axes


def _write_final_histograms(
    *,
    path: Path,
    title_prefix: str,
    axes: list[CVTHistogramAxis],
    success_count: int,
    centroid_count: int,
    bins: int,
    dpi: int,
) -> None:
    fig, subplot_axes = _build_subplot_grid(len(axes), panel_height=3.5)
    show_centroid_overlays = centroid_count > 0
    legend_handles = [
        Patch(facecolor="#4C78A8", edgecolor="white", label="Successful candidates"),
    ]
    if show_centroid_overlays:
        legend_handles.extend(
            [
                Line2D(
                    [0],
                    [0],
                    color="#9C755F",
                    linestyle="--",
                    linewidth=1.0,
                    label="Projected 1D CVT division",
                ),
                Line2D(
                    [0],
                    [0],
                    marker="v",
                    color="#D62728",
                    markersize=6,
                    linestyle="None",
                    label="Final centroid projection",
                ),
            ]
        )
    for axis_plot, axis_data in zip(subplot_axes, axes):
        counts, _, _ = axis_plot.hist(
            axis_data.values,
            bins=axis_data.bin_edges,
            color="#4C78A8",
            alpha=0.9,
            edgecolor="white",
            linewidth=0.6,
        )
        y_top = max(float(max(counts)) if len(counts) else 0.0, 1.0)
        for boundary in axis_data.division_positions:
            axis_plot.axvline(
                boundary,
                color="#9C755F",
                linestyle="--",
                linewidth=0.9,
                alpha=0.55,
                zorder=1,
            )
        centroid_counts = _count_positions(axis_data.centroid_positions)
        if centroid_counts:
            marker_y = y_top * 0.98
            stem_y = y_top * 0.90
            centroid_x = [position for position, _ in centroid_counts]
            axis_plot.vlines(
                centroid_x,
                stem_y,
                marker_y,
                color="#D62728",
                linewidth=0.9,
                alpha=0.75,
                zorder=4,
            )
            axis_plot.scatter(
                centroid_x,
                [marker_y] * len(centroid_x),
                marker="v",
                s=18,
                color="#D62728",
                alpha=0.9,
                zorder=5,
                clip_on=False,
            )
            for position, count in centroid_counts:
                if count > 1:
                    axis_plot.text(
                        position,
                        marker_y + (y_top * 0.04),
                        f"x{count}",
                        ha="center",
                        va="bottom",
                        fontsize=7,
                        color="#8C1D18",
                    )
        axis_plot.set_title(axis_data.name)
        axis_plot.set_xlabel(axis_data.name)
        axis_plot.set_ylabel("Successful candidates")
        axis_plot.set_xlim(axis_data.x_limits)
        axis_plot.grid(True, axis="y", alpha=0.25)
    for unused_axis in subplot_axes[len(axes):]:
        unused_axis.axis("off")

    title = (
        f"{title_prefix}\n"
        f"Final successful-candidate histograms with projected CVT centroid/division overlays "
        f"({success_count} successes, {centroid_count} centroids, {bins} bins)"
    )
    footer = "Division lines are 1D projected Voronoi midpoints derived from the final frozen CVT centroids."
    legend_columns = 3
    if not show_centroid_overlays:
        title = (
            f"{title_prefix}\n"
            f"Final successful-candidate histograms without centroid overlays "
            f"({success_count} successes, centroids not initialized, {bins} bins)"
        )
        footer = "This CVT archive never froze centroids, so the plots only show successful-candidate distributions."
        legend_columns = 1
    fig.suptitle(title, fontsize=14, y=0.995)
    fig.legend(
        handles=legend_handles,
        loc="upper center",
        ncol=legend_columns,
        bbox_to_anchor=(0.5, 0.955),
    )
    fig.text(0.5, 0.015, footer, ha="center", va="bottom", fontsize=9)
    fig.subplots_adjust(
        left=0.06,
        right=0.98,
        bottom=0.07,
        top=0.87,
        wspace=0.28,
        hspace=0.48,
    )
    fig.savefig(path, dpi=dpi)
    plt.close(fig)


def _write_historical_histograms(
    *,
    path: Path,
    title_prefix: str,
    axes: list[CVTHistogramAxis],
    generations: list[int],
    centroid_count: int,
    initialization_generation: int | None,
    bins: int,
    dpi: int,
) -> None:
    fig, subplot_axes = _build_subplot_grid(len(axes), panel_height=4.0)
    show_centroid_overlays = centroid_count > 0
    legend_handles: list[Any] = []
    if show_centroid_overlays:
        legend_handles.extend(
            [
                Line2D(
                    [0],
                    [0],
                    color="#9C755F",
                    linestyle="--",
                    linewidth=1.0,
                    label="Projected 1D CVT division",
                ),
                Line2D(
                    [0],
                    [0],
                    marker="v",
                    color="#D62728",
                    markersize=6,
                    linestyle="None",
                    label="Final centroid projection",
                ),
            ]
        )
    heatmap_max = max(
        (
            max((max(row) for row in axis.cumulative_histograms), default=0)
            for axis in axes
        ),
        default=0,
    )
    heatmap_max = max(heatmap_max, 1)
    colorbar_image = None
    y_min = generations[0] - 0.5
    y_max = generations[-1] + 0.5
    tick_step = max(1, math.ceil(len(generations) / 8))
    y_ticks = generations[::tick_step]
    if generations[-1] not in y_ticks:
        y_ticks = [*y_ticks, generations[-1]]

    for axis_plot, axis_data in zip(subplot_axes, axes):
        matrix = np.asarray(axis_data.cumulative_histograms, dtype=float)
        image = axis_plot.imshow(
            matrix,
            aspect="auto",
            origin="lower",
            extent=[
                axis_data.x_limits[0],
                axis_data.x_limits[1],
                y_min,
                y_max,
            ],
            cmap="Blues",
            vmin=0.0,
            vmax=float(heatmap_max),
            interpolation="nearest",
        )
        colorbar_image = image
        for boundary in axis_data.division_positions:
            axis_plot.axvline(
                boundary,
                color="#9C755F",
                linestyle="--",
                linewidth=0.9,
                alpha=0.65,
                zorder=3,
            )
        centroid_counts = _count_positions(axis_data.centroid_positions)
        if centroid_counts:
            centroid_row = y_max + 0.12
            centroid_x = [position for position, _ in centroid_counts]
            axis_plot.scatter(
                centroid_x,
                [centroid_row] * len(centroid_x),
                marker="v",
                s=18,
                color="#D62728",
                alpha=0.9,
                zorder=4,
                clip_on=False,
            )
            for position, count in centroid_counts:
                if count > 1:
                    axis_plot.text(
                        position,
                        centroid_row + 0.08,
                        f"x{count}",
                        ha="center",
                        va="bottom",
                        fontsize=7,
                        color="#8C1D18",
                        clip_on=False,
                    )
        if initialization_generation is not None:
            axis_plot.axhline(
                initialization_generation - 0.5,
                color="black",
                linewidth=0.8,
                alpha=0.35,
            )
        axis_plot.set_title(axis_data.name)
        axis_plot.set_xlabel(axis_data.name)
        axis_plot.set_ylabel("Generation")
        axis_plot.set_xlim(axis_data.x_limits)
        axis_plot.set_ylim(y_min, y_max + 0.25)
        axis_plot.set_yticks(y_ticks)
        axis_plot.grid(False)
    for unused_axis in subplot_axes[len(axes):]:
        unused_axis.axis("off")

    fig.subplots_adjust(
        left=0.06,
        right=0.88,
        bottom=0.07,
        top=0.86,
        wspace=0.28,
        hspace=0.52,
    )
    if colorbar_image is not None:
        colorbar_axis = fig.add_axes([0.905, 0.14, 0.018, 0.66])
        fig.colorbar(
            colorbar_image,
            cax=colorbar_axis,
            label="Cumulative successful candidates",
        )
    title = (
        f"{title_prefix}\n"
        f"Cumulative successful-candidate histograms by generation with projected CVT overlays "
        f"({centroid_count} centroids, {bins} bins)"
    )
    if initialization_generation is not None:
        title = (
            f"{title_prefix}\n"
            f"Cumulative successful-candidate histograms by generation with projected CVT overlays "
            f"({centroid_count} centroids, {bins} bins, active from generation {initialization_generation})"
        )
    footer = "Rows are cumulative generation-end histograms with fixed per-axis x-ranges for direct alignment."
    legend_columns = 2
    if not show_centroid_overlays:
        title = (
            f"{title_prefix}\n"
            f"Cumulative successful-candidate histograms by generation without centroid overlays "
            f"(centroids not initialized, {bins} bins)"
        )
        footer = (
            "Rows are cumulative generation-end histograms. This CVT archive never froze centroids, "
            "so only successful-candidate distributions are shown."
        )
    fig.suptitle(title, fontsize=14, y=0.995)
    if legend_handles:
        fig.legend(
            handles=legend_handles,
            loc="upper center",
            ncol=legend_columns,
            bbox_to_anchor=(0.5, 0.955),
        )
    fig.text(0.5, 0.015, footer, ha="center", va="bottom", fontsize=9)
    fig.savefig(path, dpi=dpi)
    plt.close(fig)


def _build_summary_notes(*, centroids_initialized: bool) -> list[str]:
    notes = [
        "Division markers are 1D projected Voronoi midpoints along each axis, not exact full-dimensional CVT cell boundaries.",
    ]
    if centroids_initialized:
        notes.insert(
            0,
            "Centroid and division overlays use the final frozen CVT centroids projected back into raw feature units.",
        )
        notes.append(
            "The current CVT implementation freezes centroids after warmup, so historical plots show cumulative distributions against fixed final centroid projections.",
        )
        return notes
    notes.insert(
        0,
        "This CVT archive never froze centroids, so the histograms show successful-candidate distributions without centroid or division overlays.",
    )
    return notes


def _build_subplot_grid(count: int, *, panel_height: float) -> tuple[Any, list[Any]]:
    columns = min(3, max(1, count))
    rows = math.ceil(count / columns)
    fig, axes = plt.subplots(
        rows,
        columns,
        figsize=(6.0 * columns, panel_height * rows),
        squeeze=False,
    )
    return fig, [axis for row in axes for axis in row]


def _compute_axis_limits(
    values: tuple[float, ...],
    centroid_positions: tuple[float, ...],
    division_positions: tuple[float, ...],
) -> tuple[float, float]:
    finite_values = [
        value
        for value in (*values, *centroid_positions, *division_positions)
        if math.isfinite(value)
    ]
    if not finite_values:
        return (-1.0, 1.0)
    lower = min(finite_values)
    upper = max(finite_values)
    if math.isclose(lower, upper, rel_tol=1e-9, abs_tol=1e-12):
        pad = max(abs(lower) * 0.05, 1e-3)
        return lower - pad, upper + pad
    pad = (upper - lower) * 0.05
    return lower - pad, upper + pad


def _projected_divisions(centroid_positions: tuple[float, ...]) -> tuple[float, ...]:
    if len(centroid_positions) < 2:
        return ()
    return tuple(
        (left + right) / 2.0
        for left, right in zip(centroid_positions[:-1], centroid_positions[1:])
    )


def _sorted_unique(values: list[float]) -> tuple[float, ...]:
    unique: list[float] = []
    for value in sorted(values):
        if not unique or not math.isclose(value, unique[-1], rel_tol=1e-9, abs_tol=1e-12):
            unique.append(float(value))
    return tuple(unique)


def _count_positions(positions: tuple[float, ...]) -> tuple[tuple[float, int], ...]:
    counts: list[tuple[float, int]] = []
    for position in positions:
        if counts and math.isclose(position, counts[-1][0], rel_tol=1e-9, abs_tol=1e-12):
            counts[-1] = (counts[-1][0], counts[-1][1] + 1)
            continue
        counts.append((float(position), 1))
    return tuple(counts)


def _load_json_object(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError(f"Expected JSON object in {path}")
    return payload


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _safe_int(value: Any) -> int | None:
    try:
        return int(value)
    except (TypeError, ValueError):
        return None
