"""Shared helpers for retrospective design-space reporting.

The design-space report script needs a mix of small dataclasses, markdown
helpers, and plotting layout utilities. Keeping them here keeps the
script's top-level flow easier to skim.
"""

from __future__ import annotations

import csv
import math
import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Sequence

from matplotlib.axes import Axes
from matplotlib.cm import ScalarMappable
from matplotlib.figure import Figure


CandidateRow = dict[str, Any]


@dataclass(frozen=True)
class PlotArtifact:
    """One generated plot plus the label and note used in markdown."""

    label: str
    path: Path | None
    note: str | None = None


@dataclass(frozen=True)
class ReportSection:
    """One markdown section with optional notes and linked plots."""

    title: str
    plots: list[PlotArtifact]
    notes: tuple[str, ...] = ()


@dataclass(frozen=True)
class SectionGroup:
    """A higher-level markdown group made up of report sections."""

    title: str
    sections: list[ReportSection]
    notes: tuple[str, ...] = ()


@dataclass(frozen=True)
class ProblemScope:
    """One generation-local or accumulated reporting slice."""

    generation: int
    mode: str
    label: str
    rows: list[CandidateRow]


@dataclass(frozen=True)
class FeatureSelectionArtifacts:
    """Paths to the machine-readable artifacts emitted by the report."""

    recommended_profile_path: Path
    candidate_csv_path: Path


@dataclass(frozen=True)
class FeatureBasis:
    """The feature basis used for one feature-space comparison."""

    label: str
    source: str
    features: tuple[str, ...]
    profile_name: str | None = None


@dataclass(frozen=True)
class PairwiseFeatureComparison:
    """Classic-vs-QD comparison metadata for one feature-space view."""

    anchor_backend: str
    qd_backend: str
    feature_basis: FeatureBasis
    warnings: tuple[str, ...] = ()


@dataclass(frozen=True)
class TocEntry:
    """One short in-page markdown table-of-contents entry."""

    label: str
    anchor: str


def safe_float(value: Any) -> float | None:
    """Return a finite float or ``None`` for missing / invalid inputs."""

    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def relative_markdown_path(target: Path | None, report_path: Path) -> str | None:
    """Return a relative markdown path when possible."""

    if target is None:
        return None
    try:
        return Path(os.path.relpath(target, report_path.parent)).as_posix()
    except ValueError:
        return str(target)


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    """Write a stable CSV file with an explicit header."""

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def format_float(value: float | None, digits: int = 4) -> str:
    """Format a float for markdown summaries."""

    if value is None:
        return "N/A"
    return f"{value:.{digits}f}"


def candidate_row_key(row: CandidateRow) -> tuple[str, str, str, str, str, int | None]:
    """Build a stable identity key for one exported candidate row."""

    generation = safe_float(row.get("generation"))
    generation_value = int(generation) if generation is not None else None
    return (
        str(row.get("backend") or ""),
        str(row.get("benchmark") or ""),
        str(row.get("problem") or ""),
        str(row.get("candidate_id") or ""),
        str(row.get("source") or ""),
        generation_value,
    )


def problem_key(row: CandidateRow) -> tuple[str, str]:
    """Return the benchmark/problem identity for one candidate row."""

    return str(row["benchmark"]), str(row["problem"])


def all_generations(rows: list[CandidateRow]) -> list[int]:
    """Collect the sorted generation ids present in the candidate rows."""

    generations = {
        int(parsed)
        for row in rows
        if (parsed := safe_float(row.get("generation"))) is not None
    }
    return sorted(generations)


def color_bounds(rows: list[CandidateRow]) -> tuple[float, float]:
    """Compute stable color bounds from candidate color scores."""

    values = [
        parsed
        for row in rows
        if (parsed := safe_float(row.get("color_score"))) is not None
    ]
    if not values:
        return 0.0, 1.0
    low = min(values)
    high = max(values)
    if math.isclose(low, high):
        high = low + 1.0
    return low, high


def axis_limits(values: list[float]) -> tuple[float, float]:
    """Compute padded axis limits for a 1D list of values."""

    if not values:
        return 0.0, 1.0
    low = min(values)
    high = max(values)
    if math.isclose(low, high):
        pad = max(abs(low) * 0.05, 1.0)
        return low - pad, high + pad
    pad = (high - low) * 0.05
    return low - pad, high + pad


def subplot_grid(count: int) -> tuple[int, int]:
    """Choose a small rectangular subplot grid for backend facets."""

    cols = min(3, max(1, count))
    rows = math.ceil(count / cols)
    return rows, cols


def feature_axis_labels(method: str) -> tuple[str, str]:
    """Return human-readable axis labels for one embedding method."""

    if method == "pca":
        return "PC1", "PC2"
    if method == "tsne":
        return "t-SNE 1", "t-SNE 2"
    return "Component 1", "Component 2"


def add_right_margin_colorbar(
    *,
    fig: Figure,
    mappable: ScalarMappable,
    axes: Sequence[Axes],
    label: str,
) -> Axes:
    """Place a shared colorbar in a dedicated figure margin on the right."""

    visible_axes = [axis for axis in axes if axis.get_visible()]
    if not visible_axes:
        raise ValueError("At least one visible axis is required for a shared colorbar.")
    boxes = [axis.get_position() for axis in visible_axes]
    bottom = min(box.y0 for box in boxes)
    top = max(box.y1 for box in boxes)
    colorbar_left = min(max(box.x1 for box in boxes) + 0.02, 0.93)
    colorbar_width = 0.02
    colorbar_bottom = max(bottom, 0.08)
    colorbar_height = min(top, 0.92) - colorbar_bottom
    cax = fig.add_axes((colorbar_left, colorbar_bottom, colorbar_width, colorbar_height))
    fig.colorbar(mappable, cax=cax, label=label)
    return cax


def heading_anchor(text: str) -> str:
    """Build a simple GitHub-style markdown anchor for a heading."""

    lowered = text.strip().lower()
    collapsed = re.sub(r"[^\w\s-]", "", lowered)
    collapsed = re.sub(r"\s+", "-", collapsed)
    collapsed = re.sub(r"-{2,}", "-", collapsed)
    return collapsed.strip("-")


def append_toc(lines: list[str], entries: Iterable[TocEntry]) -> None:
    """Append a short markdown table of contents."""

    toc_entries = list(entries)
    if not toc_entries:
        return
    lines.extend(["## Contents", ""])
    for entry in toc_entries:
        lines.append(f"- [{entry.label}](#{entry.anchor})")
    lines.append("")
