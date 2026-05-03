#!/usr/bin/env python3
"""Retrospective design-space report for classic and QD RTL runs.

This script intentionally stays standalone so it can be used directly on
completed run roots or from the bundled ``final_analysis/`` flow. The
implementation favors small helpers, stable filenames, and explicit
markdown structure so the generated output is easy to browse after long
experiments.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt
import yaml
from matplotlib import colors

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

from revolution.qd.design_space_report_support import (  # noqa: E402
    CandidateRow,
    FeatureBasis,
    FeatureSelectionArtifacts,
    PlotArtifact,
    ProblemScope,
    ReportSection,
    SectionGroup,
    TocEntry,
    add_right_margin_colorbar,
    all_generations,
    axis_limits,
    candidate_row_key,
    color_bounds,
    heading_anchor,
    problem_key,
    relative_markdown_path,
    safe_float,
    subplot_grid,
    write_csv,
    append_toc,
)
from revolution.qd.feature_space_analysis import (  # noqa: E402
    EmbeddingFit,
    candidate_feature_columns,
    compute_feature_stats,
    explicit_profile,
    fit_embedding_model,
    global_range_by_feature,
    profile_feature_scores,
    profile_features_from_config,
    recommended_profile,
)
from revolution.qd.successful_candidate_catalog import (  # noqa: E402
    ProblemRunContext,
    SuccessfulCandidateCatalog,
    catalog_rows,
    export_fieldnames,
    load_successful_candidate_catalog,
    recover_candidate_features,
)


FEATURE_EXCLUDED_COLUMNS = {
    "backend",
    "benchmark",
    "problem",
    "circuit_type",
    "search_mode",
    "archive_type",
    "descriptor_profile",
    "generation",
    "generation_views_available",
    "source",
    "candidate_id",
    "strategy",
    "score",
    "quality_score",
    "color_score",
    "origin_pool",
    "generated_mode",
    "decision",
    "inserted",
    "replaced",
    "cell_id",
    "is_final_elite",
    "area",
    "power",
    "eff_clk_period",
    "tns",
    "wns",
    "report_path",
    "candidate_dir",
    "code_file_path",
    "metrics_json_path",
    "qd_event_path",
    "vcd_file_path",
    "has_qd_event",
    "has_metrics_json",
    "has_code_file",
    "has_vcd_file",
    "has_structural_metrics",
    "has_rtl_metrics",
    "has_graph_metrics",
    "has_dynamic_metrics",
    "has_physical_metrics",
    "warning_messages",
}
RESERVED_DIR_NAMES = {
    "analysis",
    "feature_analysis",
    "hard_iteration_analysis",
    "pareto_analysis",
    "evolutionary_reports",
    "final_analysis",
    "design_space_analysis",
}
PPA_PAIR_LABELS = {
    "area": "Area",
    "power": "Power",
    "eff_clk_period": "Performance",
    "g_A": "g_A",
    "g_P": "g_P",
    "g_T": "g_T",
}
FEATURE_METHOD_LABELS = {
    "pca": "PCA",
    "tsne": "t-SNE",
}


@dataclass(frozen=True)
class FeaturePlotContext:
    """One reusable feature-space comparison with stable fitted embeddings."""

    label: str
    slug: str
    backends: tuple[str, ...]
    feature_basis: FeatureBasis
    row_index_by_key: dict[tuple[str, str, str, str, str, int | None], int]
    fits_by_method: dict[str, EmbeddingFit]
    warnings: tuple[str, ...] = ()


@dataclass(frozen=True)
class ProblemReportPayload:
    """Machine-readable metadata for one per-problem report."""

    benchmark: str
    problem: str
    circuit_type: str
    report_path: str
    candidate_count: int
    generation_count: int
    warnings: list[str]
    pairwise_feature_comparisons: list[dict[str, Any]]


def _load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
    """Load the frozen benchmark/problem list from a subset YAML file."""

    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    selected = payload.get("selected_problems") or []
    problems: list[tuple[str, str]] = []
    for entry in selected:
        if not isinstance(entry, dict):
            continue
        benchmark = entry.get("benchmark")
        problem = entry.get("problem")
        if isinstance(benchmark, str) and isinstance(problem, str):
            problems.append((benchmark, problem))
    if not problems:
        raise ValueError(f"No selected problems found in subset config '{config_path}'.")
    return problems


def _discover_backend_runs(run_root: Path) -> list[tuple[str, Path]]:
    """Discover backend run directories beneath a finished comparison root."""

    backend_runs: list[tuple[str, Path]] = []
    for child in sorted(run_root.iterdir()):
        if not child.is_dir() or child.name in RESERVED_DIR_NAMES:
            continue
        if not any(path.name.endswith("_summary.json") for path in child.rglob("*_summary.json")):
            continue
        backend_runs.append((child.name, child.resolve()))
    if not backend_runs:
        raise ValueError(f"No backend run directories found under {run_root}")
    return backend_runs


def _parse_backend_runs(mappings: list[str]) -> list[tuple[str, Path]]:
    """Parse repeated ``--backend_run name=path`` mappings."""

    backend_runs: list[tuple[str, Path]] = []
    for mapping in mappings:
        if "=" not in mapping:
            raise ValueError(
                f"Invalid --backend_run '{mapping}'. Expected format <backend>=<path>."
            )
        backend, path_str = mapping.split("=", 1)
        root = Path(path_str).expanduser().resolve()
        if not root.is_dir():
            raise FileNotFoundError(f"Experiment path not found: {root}")
        backend_runs.append((backend, root))
    if not backend_runs:
        raise ValueError("At least one --backend_run mapping is required.")
    return backend_runs


def _plot_artifact(label: str, payload: dict[str, Any]) -> PlotArtifact:
    return PlotArtifact(
        label=label,
        path=payload.get("path"),
        note=payload.get("note"),
    )


def _context_map(
    catalog: SuccessfulCandidateCatalog,
) -> dict[tuple[str, str, str], ProblemRunContext]:
    return {
        (context.backend, context.benchmark, context.problem): context
        for context in catalog.problem_runs
    }


def _backend_contexts(
    catalog: SuccessfulCandidateCatalog,
) -> dict[str, list[ProblemRunContext]]:
    grouped: dict[str, list[ProblemRunContext]] = {}
    for context in catalog.problem_runs:
        grouped.setdefault(context.backend, []).append(context)
    return grouped


def _feature_method_label(method: str) -> str:
    return FEATURE_METHOD_LABELS[method]


def _scope_label(generation: int, mode: str) -> str:
    return f"Gen {generation} {'local' if mode == 'local' else 'accumulated'}"


def _problem_scopes(problem_rows: list[CandidateRow], generations: list[int]) -> list[ProblemScope]:
    scopes: list[ProblemScope] = []
    for generation in generations:
        local_rows = [row for row in problem_rows if row.get("generation") == generation]
        accumulated_rows = [
            row
            for row in problem_rows
            if row.get("generation") is not None and int(row["generation"]) <= generation
        ]
        scopes.append(
            ProblemScope(
                generation=generation,
                mode="local",
                label=_scope_label(generation, "local"),
                rows=local_rows,
            )
        )
        scopes.append(
            ProblemScope(
                generation=generation,
                mode="accumulated",
                label=_scope_label(generation, "accumulated"),
                rows=accumulated_rows,
            )
        )
    return scopes


def _problem_ppa_pairs(circuit_type: str) -> list[tuple[str, str]]:
    if circuit_type == "combinational":
        return [("power", "area")]
    return [
        ("power", "area"),
        ("power", "eff_clk_period"),
        ("area", "eff_clk_period"),
    ]


def _aggregate_ppa_pairs(circuit_type: str, basis: str) -> list[tuple[str, str]]:
    if basis == "normalized":
        if circuit_type == "combinational":
            return [("g_P", "g_A")]
        return [("g_P", "g_A"), ("g_P", "g_T"), ("g_A", "g_T")]
    return _problem_ppa_pairs(circuit_type)


def _select_feature_payload(
    *,
    candidate_rows: list[CandidateRow],
    explicit_features: list[str],
    feature_profile: str | None,
    min_profile_features: int,
) -> dict[str, Any]:
    """Resolve the global feature subset used for all-backend plots."""

    if explicit_features:
        deduped = list(dict.fromkeys(explicit_features))
        return explicit_profile(deduped, selection_mode="explicit")
    if feature_profile:
        resolved = profile_features_from_config(profile_name=feature_profile)
        return explicit_profile(
            resolved,
            selection_mode="profile",
            profile_name=feature_profile,
        )

    feature_cols = candidate_feature_columns(
        candidate_rows,
        excluded=FEATURE_EXCLUDED_COLUMNS,
    )
    global_ranges = global_range_by_feature(candidate_rows, feature_cols)
    backend_feature_stats: dict[str, list[Any]] = {}
    for backend in sorted({str(row["backend"]) for row in candidate_rows}):
        backend_rows = [row for row in candidate_rows if row["backend"] == backend]
        backend_feature_stats[backend] = [
            compute_feature_stats(backend_rows, feature, global_ranges)
            for feature in feature_cols
        ]
    scores = profile_feature_scores(
        candidate_rows,
        feature_cols,
        backend_feature_stats,
    )
    return recommended_profile(scores, min_features=min_profile_features)


def _global_feature_basis(feature_payload: dict[str, Any]) -> FeatureBasis:
    selection_mode = str(feature_payload["selection_mode"])
    profile_name = feature_payload.get("feature_profile")
    if selection_mode == "profile" and isinstance(profile_name, str) and profile_name:
        label = f"{profile_name} descriptor profile"
    elif selection_mode == "explicit":
        label = "explicit report feature subset"
    else:
        label = "recommended report feature subset"
    features = tuple(feature_payload["selected_non_target_features"])
    return FeatureBasis(
        label=label,
        source=selection_mode,
        features=features,
        profile_name=profile_name if isinstance(profile_name, str) else None,
    )


def _slug_value(text: str) -> str:
    return heading_anchor(text).replace("-", "_")


def _context_is_qd(context: ProblemRunContext) -> bool:
    if context.archive_type is not None:
        return True
    if context.descriptor_profile is not None:
        return True
    if context.search_mode is None:
        return False
    return "qd" in context.search_mode.lower()


def _resolve_anchor_backend(
    backends: list[str],
    catalog: SuccessfulCandidateCatalog,
) -> tuple[str | None, list[str]]:
    if "classic" in backends:
        return "classic", []
    grouped = _backend_contexts(catalog)
    non_qd_backends = [
        backend
        for backend in backends
        if grouped.get(backend) and all(not _context_is_qd(context) for context in grouped[backend])
    ]
    if len(non_qd_backends) == 1:
        return non_qd_backends[0], []
    if not non_qd_backends:
        return None, [
            "Could not resolve a classical anchor backend for pairwise feature plots."
        ]
    return None, [
        "Found multiple non-QD candidate backends for pairwise feature plots: "
        f"{', '.join(non_qd_backends)}."
    ]


def _context_feature_basis(
    *,
    descriptor_profile: str | None,
    descriptor_axes: tuple[str, ...],
    fallback_features: list[str],
    warning_label: str,
) -> tuple[FeatureBasis, list[str]]:
    """Resolve the feature basis for one QD-oriented comparison."""

    warnings: list[str] = []
    if descriptor_profile:
        try:
            features = tuple(profile_features_from_config(profile_name=descriptor_profile))
            return (
                FeatureBasis(
                    label=f"{descriptor_profile} descriptor profile",
                    source="descriptor_profile",
                    features=features,
                    profile_name=descriptor_profile,
                ),
                warnings,
            )
        except ValueError:
            warnings.append(
                f"{warning_label}: unknown descriptor profile '{descriptor_profile}', "
                "falling back to archived axes or global selected features."
            )
    if descriptor_axes:
        return (
            FeatureBasis(
                label="archived QD axes",
                source="archive_axes",
                features=tuple(dict.fromkeys(descriptor_axes)),
                profile_name=descriptor_profile,
            ),
            warnings,
        )
    warnings.append(
        f"{warning_label}: no descriptor profile or archived axes were found, "
        "falling back to the global report feature subset."
    )
    return (
        FeatureBasis(
            label="global report feature subset",
            source="global_fallback",
            features=tuple(fallback_features),
            profile_name=None,
        ),
        warnings,
    )


def _pairwise_requested_features(
    problem_runs: tuple[ProblemRunContext, ...],
) -> tuple[list[str], list[str]]:
    """Collect descriptor-basis features needed for pairwise comparisons."""

    requested: list[str] = []
    warnings: list[str] = []
    for context in problem_runs:
        if context.descriptor_profile:
            try:
                requested.extend(profile_features_from_config(profile_name=context.descriptor_profile))
            except ValueError:
                warnings.append(
                    "Could not load descriptor profile "
                    f"'{context.descriptor_profile}' for {context.backend}/{context.problem}."
                )
        requested.extend(context.descriptor_axes)
    return list(dict.fromkeys(requested)), warnings


def _embedding_context(
    *,
    label: str,
    slug: str,
    rows: list[CandidateRow],
    backends: list[str],
    feature_basis: FeatureBasis,
    feature_methods: list[str],
    warnings: list[str] | None = None,
) -> FeaturePlotContext:
    deduped_features = list(dict.fromkeys(feature_basis.features))
    fits_by_method = {
        method: fit_embedding_model(rows, deduped_features, method=method)
        for method in feature_methods
    }
    row_index_by_key = {
        candidate_row_key(row): index
        for index, row in enumerate(rows)
    }
    return FeaturePlotContext(
        label=label,
        slug=slug,
        backends=tuple(backends),
        feature_basis=feature_basis,
        row_index_by_key=row_index_by_key,
        fits_by_method=fits_by_method,
        warnings=tuple(warnings or []),
    )


def _problem_pairwise_contexts(
    *,
    problem_rows: list[CandidateRow],
    contexts_by_backend: dict[str, ProblemRunContext],
    anchor_backend: str | None,
    global_feature_cols: list[str],
    feature_methods: list[str],
) -> tuple[list[FeaturePlotContext], list[str]]:
    contexts: list[FeaturePlotContext] = []
    warnings: list[str] = []
    if anchor_backend is None:
        warnings.append(
            "Skipped pairwise feature plots because no classical anchor backend was available."
        )
        return contexts, warnings
    if anchor_backend not in contexts_by_backend:
        warnings.append(
            f"Skipped pairwise feature plots because anchor backend '{anchor_backend}' "
            "was not present for this problem."
        )
        return contexts, warnings

    for backend, context in sorted(contexts_by_backend.items()):
        if backend == anchor_backend or not _context_is_qd(context):
            continue
        pair_rows = [
            row
            for row in problem_rows
            if row.get("backend") in {anchor_backend, backend}
        ]
        anchor_rows = [row for row in pair_rows if row.get("backend") == anchor_backend]
        qd_rows = [row for row in pair_rows if row.get("backend") == backend]
        if not anchor_rows or not qd_rows:
            warnings.append(
                f"Skipped pairwise feature plots for {anchor_backend} vs {backend} "
                "because one side had no successful candidates."
            )
            continue
        feature_basis, basis_warnings = _context_feature_basis(
            descriptor_profile=context.descriptor_profile,
            descriptor_axes=context.descriptor_axes,
            fallback_features=global_feature_cols,
            warning_label=f"{anchor_backend} vs {backend}",
        )
        contexts.append(
            _embedding_context(
                label=f"{anchor_backend} vs {backend}",
                slug=_slug_value(f"{anchor_backend}_vs_{backend}"),
                rows=pair_rows,
                backends=[anchor_backend, backend],
                feature_basis=feature_basis,
                feature_methods=feature_methods,
                warnings=basis_warnings,
            )
        )
    if not contexts:
        warnings.append("No QD backends were eligible for pairwise feature plots in this problem.")
    return contexts, warnings


def _aggregate_pairwise_contexts(
    *,
    rows: list[CandidateRow],
    benchmark: str | None,
    circuit_type: str,
    anchor_backend: str | None,
    backend_contexts: dict[str, list[ProblemRunContext]],
    global_feature_cols: list[str],
    feature_methods: list[str],
) -> tuple[list[FeaturePlotContext], list[str]]:
    contexts: list[FeaturePlotContext] = []
    warnings: list[str] = []
    if anchor_backend is None:
        return contexts, warnings
    anchor_backend_contexts = backend_contexts.get(anchor_backend)
    if not anchor_backend_contexts:
        return contexts, warnings

    for backend, contexts_for_backend in sorted(backend_contexts.items()):
        if backend == anchor_backend or not contexts_for_backend:
            continue
        if not any(_context_is_qd(context) for context in contexts_for_backend):
            continue
        scope_rows = [
            row
            for row in rows
            if row.get("circuit_type") == circuit_type
            and row.get("backend") in {anchor_backend, backend}
            and (benchmark is None or row.get("benchmark") == benchmark)
        ]
        anchor_rows = [row for row in scope_rows if row.get("backend") == anchor_backend]
        qd_rows = [row for row in scope_rows if row.get("backend") == backend]
        if not anchor_rows or not qd_rows:
            continue
        profile_names = sorted(
            {
                context.descriptor_profile
                for context in contexts_for_backend
                if context.descriptor_profile
            }
        )
        descriptor_profile = profile_names[0] if profile_names else None
        descriptor_axes = tuple(
            dict.fromkeys(
                axis
                for context in contexts_for_backend
                for axis in context.descriptor_axes
            )
        )
        feature_basis, basis_warnings = _context_feature_basis(
            descriptor_profile=descriptor_profile,
            descriptor_axes=descriptor_axes,
            fallback_features=global_feature_cols,
            warning_label=f"{anchor_backend} vs {backend} aggregate",
        )
        contexts.append(
            _embedding_context(
                label=f"{anchor_backend} vs {backend}",
                slug=_slug_value(f"{anchor_backend}_vs_{backend}"),
                rows=scope_rows,
                backends=[anchor_backend, backend],
                feature_basis=feature_basis,
                feature_methods=feature_methods,
                warnings=basis_warnings,
            )
        )
    return contexts, warnings


def _feature_basis_notes(feature_basis: FeatureBasis) -> tuple[str, ...]:
    features_text = ", ".join(feature_basis.features) if feature_basis.features else "none"
    notes = [f"feature basis: `{feature_basis.label}`", f"features: `{features_text}`"]
    return tuple(notes)


def _pairwise_summary_payload(context: FeaturePlotContext) -> dict[str, Any]:
    qd_backend = context.backends[1] if len(context.backends) > 1 else None
    return {
        "anchor_backend": context.backends[0] if context.backends else None,
        "qd_backend": qd_backend,
        "descriptor_profile": context.feature_basis.profile_name,
        "feature_basis_source": context.feature_basis.source,
        "feature_basis_label": context.feature_basis.label,
        "feature_basis_features": list(context.feature_basis.features),
        "methods": sorted(context.fits_by_method.keys()),
        "warnings": list(context.warnings),
    }


def _circuit_type_for_problem(
    rows: list[CandidateRow],
    contexts: dict[str, ProblemRunContext],
) -> str:
    for context in contexts.values():
        return context.circuit_type
    for row in rows:
        circuit_type = row.get("circuit_type")
        if isinstance(circuit_type, str):
            return circuit_type
    return "sequential"


def _problem_generation_status(
    backends: list[str],
    contexts: dict[str, ProblemRunContext],
) -> dict[str, bool]:
    return {
        backend: bool(contexts.get(backend) and contexts[backend].generation_views_available)
        for backend in backends
    }


def _plot_backend_faceted_scatter(
    *,
    rows: list[CandidateRow],
    backends: list[str],
    x_key: str,
    y_key: str,
    output_path: Path,
    title: str,
    generation_status: dict[str, bool] | None = None,
) -> dict[str, Any]:
    """Render one backend-faceted 2D scatter plot with a shared right-side colorbar."""

    if not rows:
        return {"path": None, "note": "no_rows"}
    rows_count, cols = subplot_grid(len(backends))
    fig, axes = plt.subplots(rows_count, cols, figsize=(cols * 5.0, rows_count * 4.2))
    axes_list = list(axes.flatten()) if hasattr(axes, "flatten") else [axes]

    x_values = [value for row in rows if (value := safe_float(row.get(x_key))) is not None]
    y_values = [value for row in rows if (value := safe_float(row.get(y_key))) is not None]
    x_limits = axis_limits(x_values)
    y_limits = axis_limits(y_values)
    color_low, color_high = color_bounds(rows)
    norm = colors.Normalize(vmin=color_low, vmax=color_high)
    mappable = plt.cm.ScalarMappable(norm=norm, cmap="viridis")
    mappable.set_array([])

    for axis, backend in zip(axes_list, backends, strict=False):
        backend_rows = [row for row in rows if row.get("backend") == backend]
        valid_points = [
            (
                x_value,
                y_value,
                safe_float(row.get("color_score")) or 0.0,
            )
            for row in backend_rows
            if (x_value := safe_float(row.get(x_key))) is not None
            and (y_value := safe_float(row.get(y_key))) is not None
        ]
        if valid_points:
            axis.scatter(
                [point[0] for point in valid_points],
                [point[1] for point in valid_points],
                c=[point[2] for point in valid_points],
                cmap="viridis",
                norm=norm,
                alpha=0.85,
                edgecolors="none",
            )
        else:
            message = "No data"
            if generation_status is not None and not generation_status.get(backend, True):
                message = "Generation log unavailable"
            axis.text(0.5, 0.5, message, ha="center", va="center", transform=axis.transAxes)
        axis.set_title(f"{backend} (n={len(valid_points)})")
        axis.set_xlabel(PPA_PAIR_LABELS.get(x_key, x_key))
        axis.set_ylabel(PPA_PAIR_LABELS.get(y_key, y_key))
        axis.set_xlim(*x_limits)
        axis.set_ylim(*y_limits)
        axis.grid(True, alpha=0.25)

    for axis in axes_list[len(backends):]:
        axis.axis("off")

    fig.suptitle(title)
    fig.tight_layout(rect=(0.0, 0.0, 0.88, 0.95))
    add_right_margin_colorbar(
        fig=fig,
        mappable=mappable,
        axes=axes_list[: len(backends)],
        label="fitness / quality score",
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=180)
    plt.close(fig)
    return {"path": output_path, "note": None}


def _plot_backend_faceted_scatter_3d(
    *,
    rows: list[CandidateRow],
    backends: list[str],
    x_key: str,
    y_key: str,
    z_key: str,
    output_path: Path,
    title: str,
    generation_status: dict[str, bool] | None = None,
) -> dict[str, Any]:
    """Render one backend-faceted 3D scatter plot with a shared right-side colorbar."""

    if not rows:
        return {"path": None, "note": "no_rows"}
    rows_count, cols = subplot_grid(len(backends))
    fig = plt.figure(figsize=(cols * 5.5, rows_count * 4.8))
    color_low, color_high = color_bounds(rows)
    norm = colors.Normalize(vmin=color_low, vmax=color_high)
    mappable = plt.cm.ScalarMappable(norm=norm, cmap="viridis")
    mappable.set_array([])

    x_limits = axis_limits([value for row in rows if (value := safe_float(row.get(x_key))) is not None])
    y_limits = axis_limits([value for row in rows if (value := safe_float(row.get(y_key))) is not None])
    z_limits = axis_limits([value for row in rows if (value := safe_float(row.get(z_key))) is not None])
    axes_list: list[Any] = []

    for index, backend in enumerate(backends, start=1):
        axis: Any = fig.add_subplot(rows_count, cols, index, projection="3d")
        axes_list.append(axis)
        backend_rows = [row for row in rows if row.get("backend") == backend]
        valid_points = [
            (
                x_value,
                y_value,
                z_value,
                safe_float(row.get("color_score")) or 0.0,
            )
            for row in backend_rows
            if (x_value := safe_float(row.get(x_key))) is not None
            and (y_value := safe_float(row.get(y_key))) is not None
            and (z_value := safe_float(row.get(z_key))) is not None
        ]
        if valid_points:
            axis.scatter(
                [point[0] for point in valid_points],
                [point[1] for point in valid_points],
                [point[2] for point in valid_points],
                c=[point[3] for point in valid_points],
                cmap="viridis",
                norm=norm,
                alpha=0.85,
                edgecolors="none",
            )
        else:
            message = "No data"
            if generation_status is not None and not generation_status.get(backend, True):
                message = "Generation log unavailable"
            axis.text2D(0.5, 0.5, message, ha="center", va="center", transform=axis.transAxes)
        axis.set_title(f"{backend} (n={len(valid_points)})")
        axis.set_xlabel(PPA_PAIR_LABELS.get(x_key, x_key))
        axis.set_ylabel(PPA_PAIR_LABELS.get(y_key, y_key))
        axis.set_zlabel(PPA_PAIR_LABELS.get(z_key, z_key))
        axis.set_xlim(*x_limits)
        axis.set_ylim(*y_limits)
        axis.set_zlim(*z_limits)

    fig.suptitle(title)
    fig.tight_layout(rect=(0.0, 0.0, 0.88, 0.95))
    add_right_margin_colorbar(
        fig=fig,
        mappable=mappable,
        axes=fig.axes[: len(backends)],
        label="fitness / quality score",
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=180)
    plt.close(fig)
    return {"path": output_path, "note": None}


def _plot_feature_embedding(
    *,
    rows: list[CandidateRow],
    context: FeaturePlotContext,
    method: str,
    output_path: Path,
    title: str,
    generation_status: dict[str, bool] | None = None,
) -> dict[str, Any]:
    """Render one stable feature-space embedding for a subset of the fitted rows."""

    fit = context.fits_by_method[method]
    if fit.note is not None:
        return {"path": None, "note": fit.note}
    if not rows:
        return {"path": None, "note": "no_rows"}
    rows_count, cols = subplot_grid(len(context.backends))
    fig, axes = plt.subplots(rows_count, cols, figsize=(cols * 5.0, rows_count * 4.2))
    axes_list = list(axes.flatten()) if hasattr(axes, "flatten") else [axes]
    norm = colors.Normalize(vmin=fit.color_limits[0], vmax=fit.color_limits[1])
    mappable = plt.cm.ScalarMappable(norm=norm, cmap="viridis")
    mappable.set_array([])

    for axis, backend in zip(axes_list, context.backends, strict=False):
        backend_rows = [row for row in rows if row.get("backend") == backend]
        backend_points: list[tuple[float, float]] = []
        backend_colors: list[float] = []
        for row in backend_rows:
            index = context.row_index_by_key.get(candidate_row_key(row))
            if index is None or index >= len(fit.points):
                continue
            backend_points.append(fit.points[index])
            backend_colors.append(safe_float(row.get("color_score")) or 0.0)
        if backend_points:
            axis.scatter(
                [point[0] for point in backend_points],
                [point[1] for point in backend_points],
                c=backend_colors,
                cmap="viridis",
                norm=norm,
                alpha=0.85,
                edgecolors="none",
            )
        else:
            message = "No data"
            if generation_status is not None and not generation_status.get(backend, True):
                message = "Generation log unavailable"
            axis.text(0.5, 0.5, message, ha="center", va="center", transform=axis.transAxes)
        axis.set_title(f"{backend} (n={len(backend_points)})")
        axis.set_xlabel(fit.x_label)
        axis.set_ylabel(fit.y_label)
        axis.set_xlim(*fit.x_limits)
        axis.set_ylim(*fit.y_limits)
        axis.grid(True, alpha=0.25)

    for axis in axes_list[len(context.backends):]:
        axis.axis("off")

    fig.suptitle(title)
    fig.tight_layout(rect=(0.0, 0.0, 0.88, 0.95))
    add_right_margin_colorbar(
        fig=fig,
        mappable=mappable,
        axes=axes_list[: len(context.backends)],
        label="fitness / quality score",
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=180)
    plt.close(fig)
    return {"path": output_path, "note": None}


def _scope_file_stem(prefix: str, scope: ProblemScope) -> str:
    return f"{prefix}_gen{scope.generation:03d}_{scope.mode}"


def _end_state_file_stem(prefix: str) -> str:
    return f"{prefix}_end_state"


def _generate_ppa_section(
    *,
    benchmark: str,
    problem: str,
    circuit_type: str,
    scope: ProblemScope,
    include_3d: bool,
    backends: list[str],
    output_dir: Path,
    generation_status: dict[str, bool],
) -> ReportSection:
    plots: list[PlotArtifact] = []
    stem = _scope_file_stem("ppa", scope)
    for x_key, y_key in _problem_ppa_pairs(circuit_type):
        plot = _plot_backend_faceted_scatter(
            rows=scope.rows,
            backends=backends,
            x_key=x_key,
            y_key=y_key,
            output_path=output_dir / f"{stem}_{x_key}_{y_key}.png",
            title=(
                f"{benchmark}/{problem} {scope.label}: "
                f"{PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}"
            ),
            generation_status=generation_status,
        )
        plots.append(_plot_artifact(f"{PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}", plot))
    if include_3d and circuit_type == "sequential":
        plot = _plot_backend_faceted_scatter_3d(
            rows=scope.rows,
            backends=backends,
            x_key="power",
            y_key="area",
            z_key="eff_clk_period",
            output_path=output_dir / f"{stem}_3d.png",
            title=f"{benchmark}/{problem} {scope.label}: full PPA space",
            generation_status=generation_status,
        )
        plots.append(_plot_artifact("3D PPA", plot))
    return ReportSection(title=f"{scope.label} PPA", plots=plots)


def _feature_plot_title(
    *,
    benchmark: str,
    problem: str,
    scope_label: str,
    context: FeaturePlotContext,
    method: str,
) -> str:
    return (
        f"{benchmark}/{problem} {scope_label}: "
        f"{_feature_method_label(method)} {context.label} on {context.feature_basis.label}"
    )


def _generate_feature_section(
    *,
    benchmark: str,
    problem: str,
    scope: ProblemScope,
    context: FeaturePlotContext,
    output_dir: Path,
    generation_status: dict[str, bool],
    prefix: str,
) -> ReportSection:
    plots: list[PlotArtifact] = []
    stem = f"{_scope_file_stem(prefix, scope)}"
    for method in sorted(context.fits_by_method):
        plot = _plot_feature_embedding(
            rows=scope.rows,
            context=context,
            method=method,
            output_path=output_dir / f"{stem}_{method}.png",
            title=_feature_plot_title(
                benchmark=benchmark,
                problem=problem,
                scope_label=scope.label,
                context=context,
                method=method,
            ),
            generation_status=generation_status,
        )
        plots.append(_plot_artifact(_feature_method_label(method), plot))
    return ReportSection(
        title=f"{scope.label} features",
        plots=plots,
        notes=_feature_basis_notes(context.feature_basis),
    )


def _generate_end_state_ppa_section(
    *,
    benchmark: str,
    problem: str,
    problem_rows: list[CandidateRow],
    circuit_type: str,
    backends: list[str],
    output_dir: Path,
    generation_status: dict[str, bool],
) -> ReportSection:
    plots: list[PlotArtifact] = []
    stem = _end_state_file_stem("ppa")
    for x_key, y_key in _problem_ppa_pairs(circuit_type):
        plot = _plot_backend_faceted_scatter(
            rows=problem_rows,
            backends=backends,
            x_key=x_key,
            y_key=y_key,
            output_path=output_dir / f"{stem}_{x_key}_{y_key}.png",
            title=(
                f"{benchmark}/{problem} end-state-only: "
                f"{PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}"
            ),
            generation_status=generation_status,
        )
        plots.append(_plot_artifact(f"{PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}", plot))
    return ReportSection(title="End-state-only PPA", plots=plots)


def _generate_end_state_feature_section(
    *,
    benchmark: str,
    problem: str,
    rows: list[CandidateRow],
    context: FeaturePlotContext,
    output_dir: Path,
    generation_status: dict[str, bool],
    prefix: str,
) -> ReportSection:
    plots: list[PlotArtifact] = []
    stem = _end_state_file_stem(prefix)
    for method in sorted(context.fits_by_method):
        plot = _plot_feature_embedding(
            rows=rows,
            context=context,
            method=method,
            output_path=output_dir / f"{stem}_{method}.png",
            title=(
                f"{benchmark}/{problem} end-state-only: "
                f"{_feature_method_label(method)} {context.label} on {context.feature_basis.label}"
            ),
            generation_status=generation_status,
        )
        plots.append(_plot_artifact(_feature_method_label(method), plot))
    return ReportSection(
        title="End-state-only features",
        plots=plots,
        notes=_feature_basis_notes(context.feature_basis),
    )


def _append_report_section(
    *,
    lines: list[str],
    report_path: Path,
    section: ReportSection,
    level: str,
) -> None:
    lines.append(f"{level} {section.title}")
    lines.append("")
    for note in section.notes:
        lines.append(f"- {note}")
    if section.notes:
        lines.append("")
    for plot in section.plots:
        rel = relative_markdown_path(plot.path, report_path)
        if rel:
            lines.append(f"- `{plot.label}`: ![]({rel})")
        else:
            lines.append(f"- `{plot.label}`: `{plot.note or 'skipped'}`")
    lines.append("")


def _append_section_group(
    *,
    lines: list[str],
    report_path: Path,
    group: SectionGroup,
    level: str,
    section_level: str,
) -> None:
    lines.append(f"{level} {group.title}")
    lines.append("")
    for note in group.notes:
        lines.append(f"- {note}")
    if group.notes:
        lines.append("")
    if not group.sections:
        lines.append("- no plots were generated")
        lines.append("")
        return
    for section in group.sections:
        _append_report_section(
            lines=lines,
            report_path=report_path,
            section=section,
            level=section_level,
        )


def _problem_report_toc_entries_from_groups(
    *,
    pairwise_feature_groups: list[SectionGroup],
    warnings: list[str],
) -> list[TocEntry]:
    entries = [
        TocEntry("Quick Reference", heading_anchor("Quick Reference")),
        TocEntry("PPA Chronology", heading_anchor("PPA Chronology")),
        TocEntry("All-backend feature space", heading_anchor("All-backend feature space")),
    ]
    for group in pairwise_feature_groups:
        entries.append(TocEntry(group.title, heading_anchor(group.title)))
    if warnings:
        entries.append(TocEntry("Notes", heading_anchor("Notes")))
    return entries


def _write_problem_report(
    *,
    report_path: Path,
    benchmark: str,
    problem: str,
    circuit_type: str,
    backends: list[str],
    candidate_rows: list[CandidateRow],
    generation_status: dict[str, bool],
    quick_reference_sections: list[ReportSection],
    ppa_sections: list[ReportSection],
    all_backend_feature_sections: list[ReportSection],
    pairwise_feature_groups: list[SectionGroup],
    warnings: list[str],
) -> None:
    """Write one per-problem markdown report with a TOC and quick reference."""

    lines = [
        f"# {benchmark} / {problem}",
        "",
        f"- circuit_type: `{circuit_type}`",
        f"- successful_candidates: `{len(candidate_rows)}`",
        f"- backends: `{', '.join(backends)}`",
        "",
        "## Backend counts",
        "",
    ]
    for backend in backends:
        backend_rows = [row for row in candidate_rows if row["backend"] == backend]
        generation_note = (
            "generation plots enabled"
            if generation_status.get(backend, False)
            else "end-state-only"
        )
        lines.append(f"- `{backend}`: `{len(backend_rows)}` successes, `{generation_note}`")
    lines.append("")
    append_toc(
        lines,
        _problem_report_toc_entries_from_groups(
            pairwise_feature_groups=pairwise_feature_groups,
            warnings=warnings,
        ),
    )
    _append_section_group(
        lines=lines,
        report_path=report_path,
        group=SectionGroup(title="Quick Reference", sections=quick_reference_sections),
        level="##",
        section_level="###",
    )
    _append_section_group(
        lines=lines,
        report_path=report_path,
        group=SectionGroup(title="PPA Chronology", sections=ppa_sections),
        level="##",
        section_level="###",
    )
    _append_section_group(
        lines=lines,
        report_path=report_path,
        group=SectionGroup(title="All-backend feature space", sections=all_backend_feature_sections),
        level="##",
        section_level="###",
    )
    for group in pairwise_feature_groups:
        _append_section_group(
            lines=lines,
            report_path=report_path,
            group=group,
            level="##",
            section_level="###",
        )
    if warnings:
        lines.extend(["## Notes", ""])
        for warning in warnings:
            lines.append(f"- {warning}")
        lines.append("")
    report_path.write_text("\n".join(lines), encoding="utf-8")


def _generate_problem_outputs(
    *,
    benchmark: str,
    problem: str,
    problem_rows: list[CandidateRow],
    contexts_by_backend: dict[str, ProblemRunContext],
    global_feature_basis: FeatureBasis,
    feature_methods: list[str],
    include_3d: bool,
    backends: list[str],
    anchor_backend: str | None,
    output_dir: Path,
) -> ProblemReportPayload:
    """Generate one per-problem report plus all linked plot artifacts."""

    report_path = output_dir / "report.md"
    generation_status = _problem_generation_status(backends, contexts_by_backend)
    circuit_type = _circuit_type_for_problem(problem_rows, contexts_by_backend)
    generations = all_generations(problem_rows)
    warnings: list[str] = []
    quick_reference_sections: list[ReportSection] = []
    ppa_sections: list[ReportSection] = []
    all_backend_feature_sections: list[ReportSection] = []
    pairwise_feature_groups: list[SectionGroup] = []

    all_backend_context = _embedding_context(
        label="all backends",
        slug="all_backends",
        rows=problem_rows,
        backends=backends,
        feature_basis=global_feature_basis,
        feature_methods=feature_methods,
    )
    pairwise_contexts, pairwise_warnings = _problem_pairwise_contexts(
        problem_rows=problem_rows,
        contexts_by_backend=contexts_by_backend,
        anchor_backend=anchor_backend,
        global_feature_cols=list(global_feature_basis.features),
        feature_methods=feature_methods,
    )
    warnings.extend(pairwise_warnings)
    for context in pairwise_contexts:
        warnings.extend(context.warnings)

    if generations:
        final_generation = generations[-1]
        pairwise_sections_by_slug: dict[str, list[ReportSection]] = {
            context.slug: []
            for context in pairwise_contexts
        }
        final_pairwise_sections: dict[str, ReportSection] = {}
        final_ppa_section: ReportSection | None = None
        final_all_backend_section: ReportSection | None = None

        for scope in _problem_scopes(problem_rows, generations):
            ppa_section = _generate_ppa_section(
                benchmark=benchmark,
                problem=problem,
                circuit_type=circuit_type,
                scope=scope,
                include_3d=include_3d,
                backends=backends,
                output_dir=output_dir,
                generation_status=generation_status,
            )
            ppa_sections.append(ppa_section)
            all_backend_section = _generate_feature_section(
                benchmark=benchmark,
                problem=problem,
                scope=scope,
                context=all_backend_context,
                output_dir=output_dir,
                generation_status=generation_status,
                prefix="features",
            )
            all_backend_feature_sections.append(all_backend_section)
            for context in pairwise_contexts:
                pair_scope_rows = [
                    row
                    for row in scope.rows
                    if row.get("backend") in set(context.backends)
                ]
                pair_section = _generate_feature_section(
                    benchmark=benchmark,
                    problem=problem,
                    scope=scope,
                    context=context,
                    output_dir=output_dir,
                    generation_status=generation_status,
                    prefix=f"features_{context.slug}",
                )
                if not pair_scope_rows:
                    pair_section = ReportSection(
                        title=pair_section.title,
                        plots=[
                            PlotArtifact(label=plot.label, path=None, note="no_rows")
                            for plot in pair_section.plots
                        ],
                        notes=pair_section.notes,
                    )
                pairwise_sections_by_slug[context.slug].append(pair_section)

            if scope.mode == "accumulated" and scope.generation == final_generation:
                final_ppa_section = ppa_section
                final_all_backend_section = all_backend_section
                for context in pairwise_contexts:
                    final_pairwise_sections[context.slug] = pairwise_sections_by_slug[context.slug][-1]

        if final_ppa_section is not None:
            quick_reference_sections.append(final_ppa_section)
        if final_all_backend_section is not None:
            quick_reference_sections.append(final_all_backend_section)
        for context in pairwise_contexts:
            final_section = final_pairwise_sections.get(context.slug)
            if final_section is not None:
                quick_reference_sections.append(final_section)

        for context in pairwise_contexts:
            pairwise_feature_groups.append(
                SectionGroup(
                    title=context.label,
                    sections=pairwise_sections_by_slug[context.slug],
                    notes=_feature_basis_notes(context.feature_basis),
                )
            )
    elif problem_rows:
        warnings.append(
            "Generation log unavailable for all backends; wrote end-state-only pooled views."
        )
        end_state_ppa = _generate_end_state_ppa_section(
            benchmark=benchmark,
            problem=problem,
            problem_rows=problem_rows,
            circuit_type=circuit_type,
            backends=backends,
            output_dir=output_dir,
            generation_status=generation_status,
        )
        end_state_all_backend = _generate_end_state_feature_section(
            benchmark=benchmark,
            problem=problem,
            rows=problem_rows,
            context=all_backend_context,
            output_dir=output_dir,
            generation_status=generation_status,
            prefix="features",
        )
        ppa_sections = [end_state_ppa]
        all_backend_feature_sections = [end_state_all_backend]
        quick_reference_sections.extend([end_state_ppa, end_state_all_backend])
        for context in pairwise_contexts:
            pair_rows = [
                row for row in problem_rows if row.get("backend") in set(context.backends)
            ]
            section = _generate_end_state_feature_section(
                benchmark=benchmark,
                problem=problem,
                rows=pair_rows,
                context=context,
                output_dir=output_dir,
                generation_status=generation_status,
                prefix=f"features_{context.slug}",
            )
            quick_reference_sections.append(section)
            pairwise_feature_groups.append(
                SectionGroup(
                    title=context.label,
                    sections=[section],
                    notes=_feature_basis_notes(context.feature_basis),
                )
            )
    else:
        warnings.append("No successful candidates were found for this problem.")

    _write_problem_report(
        report_path=report_path,
        benchmark=benchmark,
        problem=problem,
        circuit_type=circuit_type,
        backends=backends,
        candidate_rows=problem_rows,
        generation_status=generation_status,
        quick_reference_sections=quick_reference_sections,
        ppa_sections=ppa_sections,
        all_backend_feature_sections=all_backend_feature_sections,
        pairwise_feature_groups=pairwise_feature_groups,
        warnings=warnings,
    )
    return ProblemReportPayload(
        benchmark=benchmark,
        problem=problem,
        circuit_type=circuit_type,
        report_path=str(report_path),
        candidate_count=len(problem_rows),
        generation_count=len(generations),
        warnings=warnings,
        pairwise_feature_comparisons=[
            _pairwise_summary_payload(context)
            for context in pairwise_contexts
        ],
    )


def _aggregate_group_rows(
    rows: list[CandidateRow],
    *,
    benchmark: str | None,
    circuit_type: str,
) -> list[CandidateRow]:
    return [
        row
        for row in rows
        if row.get("circuit_type") == circuit_type
        and (benchmark is None or row.get("benchmark") == benchmark)
    ]


def _aggregate_toc_entries(sections: list[ReportSection]) -> list[TocEntry]:
    return [TocEntry(section.title, heading_anchor(section.title)) for section in sections]


def _write_aggregate_report(
    *,
    report_path: Path,
    sections: list[ReportSection],
) -> None:
    lines = [
        "# Aggregate Design-Space Views",
        "",
        "Raw pooled PPA plots mix different problems and units. Treat those figures as qualitative-only.",
        "",
        "Pairwise feature plots use the QD backend's descriptor basis when that metadata is available.",
        "",
    ]
    append_toc(lines, _aggregate_toc_entries(sections))
    for section in sections:
        _append_report_section(lines=lines, report_path=report_path, section=section, level="##")
    report_path.write_text("\n".join(lines), encoding="utf-8")


def _generate_aggregate_outputs(
    *,
    rows: list[CandidateRow],
    backends: list[str],
    global_feature_basis: FeatureBasis,
    feature_methods: list[str],
    aggregate_ppa_basis: str,
    output_dir: Path,
    anchor_backend: str | None,
    catalog: SuccessfulCandidateCatalog,
) -> dict[str, Any]:
    basis_order = ["normalized", "raw"] if aggregate_ppa_basis == "both" else [aggregate_ppa_basis]
    sections: list[ReportSection] = []
    pairwise_summaries: list[dict[str, Any]] = []
    benchmarks = sorted({str(row["benchmark"]) for row in rows})
    backend_contexts = _backend_contexts(catalog)

    for benchmark in [None, *benchmarks]:
        benchmark_label = benchmark or "overall"
        for circuit_type in ("combinational", "sequential"):
            scope_rows = _aggregate_group_rows(rows, benchmark=benchmark, circuit_type=circuit_type)
            if not scope_rows:
                continue

            for basis in basis_order:
                scoped_rows = scope_rows
                if basis == "raw":
                    scoped_rows = [
                        row
                        for row in scope_rows
                        if safe_float(row.get("area")) is not None
                        and safe_float(row.get("power")) is not None
                    ]
                plots: list[PlotArtifact] = []
                for x_key, y_key in _aggregate_ppa_pairs(circuit_type, basis):
                    plot = _plot_backend_faceted_scatter(
                        rows=scoped_rows,
                        backends=backends,
                        x_key=x_key,
                        y_key=y_key,
                        output_path=output_dir / f"{benchmark_label}_{circuit_type}_{basis}_{x_key}_{y_key}.png",
                        title=(
                            f"{benchmark_label} {circuit_type} {basis}: "
                            f"{PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}"
                        ),
                    )
                    plots.append(
                        _plot_artifact(
                            f"{basis} {PPA_PAIR_LABELS[x_key]} vs {PPA_PAIR_LABELS[y_key]}",
                            plot,
                        )
                    )
                sections.append(
                    ReportSection(
                        title=f"{benchmark_label} / {circuit_type} / {basis} PPA",
                        plots=plots,
                    )
                )

            all_backend_context = _embedding_context(
                label="all backends",
                slug=f"{benchmark_label}_{circuit_type}_all_backends",
                rows=scope_rows,
                backends=backends,
                feature_basis=global_feature_basis,
                feature_methods=feature_methods,
            )
            feature_plots: list[PlotArtifact] = []
            for method in feature_methods:
                plot = _plot_feature_embedding(
                    rows=scope_rows,
                    context=all_backend_context,
                    method=method,
                    output_path=output_dir / f"{benchmark_label}_{circuit_type}_features_{method}.png",
                    title=(
                        f"{benchmark_label} {circuit_type}: "
                        f"{_feature_method_label(method)} all backends on {global_feature_basis.label}"
                    ),
                )
                feature_plots.append(_plot_artifact(f"feature {_feature_method_label(method)}", plot))
            sections.append(
                ReportSection(
                    title=f"{benchmark_label} / {circuit_type} / feature space",
                    plots=feature_plots,
                    notes=_feature_basis_notes(global_feature_basis),
                )
            )

            pairwise_contexts, pairwise_warnings = _aggregate_pairwise_contexts(
                rows=rows,
                benchmark=benchmark,
                circuit_type=circuit_type,
                anchor_backend=anchor_backend,
                backend_contexts=backend_contexts,
                global_feature_cols=list(global_feature_basis.features),
                feature_methods=feature_methods,
            )
            for warning in pairwise_warnings:
                sections.append(
                    ReportSection(
                        title=f"{benchmark_label} / {circuit_type} / pairwise feature note",
                        plots=[],
                        notes=(warning,),
                    )
                )
            for context in pairwise_contexts:
                pairwise_summaries.append(
                    {
                        "benchmark": benchmark,
                        "circuit_type": circuit_type,
                        **_pairwise_summary_payload(context),
                    }
                )
                plots: list[PlotArtifact] = []
                pair_rows = [
                    row
                    for row in scope_rows
                    if row.get("backend") in set(context.backends)
                ]
                for method in feature_methods:
                    plot = _plot_feature_embedding(
                        rows=pair_rows,
                        context=context,
                        method=method,
                        output_path=(
                            output_dir
                            / f"{benchmark_label}_{circuit_type}_{context.slug}_features_{method}.png"
                        ),
                        title=(
                            f"{benchmark_label} {circuit_type}: "
                            f"{_feature_method_label(method)} {context.label} on {context.feature_basis.label}"
                        ),
                    )
                    plots.append(_plot_artifact(_feature_method_label(method), plot))
                sections.append(
                    ReportSection(
                        title=f"{benchmark_label} / {circuit_type} / {context.label}",
                        plots=plots,
                        notes=_feature_basis_notes(context.feature_basis),
                    )
                )

    report_path = output_dir / "report.md"
    _write_aggregate_report(report_path=report_path, sections=sections)
    return {
        "report_path": str(report_path),
        "section_count": len(sections),
        "pairwise_feature_comparisons": pairwise_summaries,
    }


def _resolve_feature_methods(feature_methods: list[str] | None) -> list[str]:
    if not feature_methods:
        return ["pca", "tsne"]
    return list(dict.fromkeys(feature_methods))


def _resolve_output_dir(
    *,
    run_root: Path | None,
    output_dir: Path | None,
) -> Path:
    if output_dir is not None:
        resolved_output_dir = output_dir.resolve()
        resolved_output_dir.mkdir(parents=True, exist_ok=True)
        return resolved_output_dir
    if run_root is None:
        raise ValueError("output_dir is required when backend_runs are provided directly.")
    resolved_output_dir = (run_root.resolve() / "design_space_analysis").resolve()
    resolved_output_dir.mkdir(parents=True, exist_ok=True)
    return resolved_output_dir


def _resolve_feature_selection(
    *,
    catalog: SuccessfulCandidateCatalog,
    explicit_features: list[str],
    feature_profile: str | None,
    min_profile_features: int,
) -> tuple[list[CandidateRow], dict[str, Any], list[str]]:
    """Recover required features first, then select the global report basis."""

    recovery_features: list[str] = []
    if explicit_features:
        recovery_features.extend(explicit_features)
    elif feature_profile is not None:
        recovery_features.extend(profile_features_from_config(profile_name=feature_profile))
    pairwise_features, pairwise_warnings = _pairwise_requested_features(catalog.problem_runs)
    recovery_features.extend(pairwise_features)
    recovery_warnings = recover_candidate_features(
        list(catalog.candidates),
        requested_features=list(dict.fromkeys(recovery_features)) or None,
    )
    candidate_rows = catalog_rows(catalog)
    feature_payload = _select_feature_payload(
        candidate_rows=candidate_rows,
        explicit_features=explicit_features,
        feature_profile=feature_profile,
        min_profile_features=min_profile_features,
    )
    return candidate_rows, feature_payload, pairwise_warnings + recovery_warnings


def _write_feature_selection_artifacts(
    *,
    output_dir: Path,
    candidate_rows: list[CandidateRow],
    feature_payload: dict[str, Any],
) -> FeatureSelectionArtifacts:
    recommended_profile_path = output_dir / "recommended_profile.json"
    recommended_profile_path.write_text(json.dumps(feature_payload, indent=2), encoding="utf-8")
    if feature_payload.get("feature_scores"):
        write_csv(
            output_dir / "recommended_profile_scores.csv",
            list(feature_payload["feature_scores"]),
            [
                "feature",
                "eligible",
                "predictive_score",
                "diversity_score",
                "stability_score",
                "composite_score",
                "collapsed_in_backend_count",
                "finite_fraction",
                "normalized_range_coverage",
                "unique_ratio",
            ],
        )
    candidate_csv_path = output_dir / "successful_candidates.csv"
    write_csv(candidate_csv_path, candidate_rows, export_fieldnames(candidate_rows))
    return FeatureSelectionArtifacts(
        recommended_profile_path=recommended_profile_path,
        candidate_csv_path=candidate_csv_path,
    )


def _generate_problem_reports(
    *,
    problems: list[tuple[str, str]],
    candidate_rows: list[CandidateRow],
    contexts: dict[tuple[str, str, str], ProblemRunContext],
    global_feature_basis: FeatureBasis,
    feature_methods: list[str],
    include_3d: bool,
    backends: list[str],
    anchor_backend: str | None,
    output_dir: Path,
) -> list[dict[str, Any]]:
    reports: list[dict[str, Any]] = []
    for benchmark, problem in problems:
        problem_rows = [row for row in candidate_rows if problem_key(row) == (benchmark, problem)]
        contexts_by_backend = {
            backend: contexts[(backend, benchmark, problem)]
            for backend in backends
            if (backend, benchmark, problem) in contexts
        }
        problem_output_dir = output_dir / "problems" / benchmark / problem
        problem_output_dir.mkdir(parents=True, exist_ok=True)
        payload = _generate_problem_outputs(
            benchmark=benchmark,
            problem=problem,
            problem_rows=problem_rows,
            contexts_by_backend=contexts_by_backend,
            global_feature_basis=global_feature_basis,
            feature_methods=feature_methods,
            include_3d=include_3d,
            backends=backends,
            anchor_backend=anchor_backend,
            output_dir=problem_output_dir,
        )
        reports.append(
            {
                "benchmark": payload.benchmark,
                "problem": payload.problem,
                "circuit_type": payload.circuit_type,
                "report_path": payload.report_path,
                "candidate_count": payload.candidate_count,
                "generation_count": payload.generation_count,
                "warnings": payload.warnings,
                "pairwise_feature_comparisons": payload.pairwise_feature_comparisons,
            }
        )
    return reports


def _write_top_report(
    *,
    report_path: Path,
    backends: list[str],
    candidate_count: int,
    anchor_backend: str | None,
    feature_payload: dict[str, Any],
    aggregate_report_path: Path,
    problem_reports: list[dict[str, Any]],
    candidate_csv_path: Path,
    recommended_profile_path: Path,
    warnings: list[str],
) -> None:
    toc_entries = [
        TocEntry("Reports", heading_anchor("Reports")),
        TocEntry("Problems", heading_anchor("Problems")),
    ]
    if warnings:
        toc_entries.append(TocEntry("Warnings", heading_anchor("Warnings")))
    lines = [
        "# Design-Space Analysis",
        "",
        f"- backends: `{', '.join(backends)}`",
        f"- successful_candidates: `{candidate_count}`",
        f"- classical_anchor_backend: `{anchor_backend or 'unresolved'}`",
        f"- feature_selection_mode: `{feature_payload['selection_mode']}`",
        f"- selected_features: `{', '.join(feature_payload['selected_non_target_features']) or 'none'}`",
        "",
    ]
    append_toc(lines, toc_entries)
    lines.extend(
        [
            "## Reports",
            "",
            f"- aggregate: [report.md]({relative_markdown_path(aggregate_report_path, report_path)})",
            f"- successful candidates: [successful_candidates.csv]({relative_markdown_path(candidate_csv_path, report_path)})",
            "- recommended profile: "
            f"[recommended_profile.json]({relative_markdown_path(recommended_profile_path, report_path)})",
            "- all-backend feature plots use the report's selected feature subset",
            "- pairwise classic-vs-QD feature plots use the QD backend's descriptor basis when available",
            "",
            "## Problems",
            "",
        ]
    )
    for payload in problem_reports:
        rel = relative_markdown_path(Path(payload["report_path"]), report_path)
        lines.append(f"- `{payload['benchmark']}/{payload['problem']}`: [report.md]({rel})")
    if warnings:
        lines.extend(["", "## Warnings", ""])
        for warning in warnings:
            lines.append(f"- {warning}")
        lines.append("")
    report_path.write_text("\n".join(lines), encoding="utf-8")


def generate_design_space_analysis(
    *,
    subset_config: Path,
    backend_runs: list[tuple[str, Path]] | None = None,
    run_root: Path | None = None,
    output_dir: Path | None = None,
    feature_profile: str | None = None,
    explicit_features: list[str] | None = None,
    feature_methods: list[str] | None = None,
    aggregate_ppa_basis: str = "both",
    include_3d: bool = False,
    min_profile_features: int = 7,
) -> dict[str, Any]:
    """Generate the full retrospective design-space report bundle."""

    subset_config = subset_config.resolve()
    explicit_features = explicit_features or []
    feature_methods = _resolve_feature_methods(feature_methods)

    resolved_backend_runs = backend_runs
    if resolved_backend_runs is None:
        if run_root is None:
            raise ValueError("run_root is required when backend_runs are not provided.")
        resolved_backend_runs = _discover_backend_runs(run_root.resolve())

    resolved_output_dir = _resolve_output_dir(run_root=run_root, output_dir=output_dir)
    problems = _load_subset_problems(subset_config)
    backend_roots = {backend: root.resolve() for backend, root in resolved_backend_runs}
    catalog = load_successful_candidate_catalog(
        backend_roots=backend_roots,
        allowed_problems=set(problems),
    )

    problem_runs_by_backend: dict[str, int] = {backend: 0 for backend in backend_roots}
    for context in catalog.problem_runs:
        problem_runs_by_backend[context.backend] += 1
    for backend, count in problem_runs_by_backend.items():
        if count == 0:
            raise ValueError(
                f"No selected problem summaries found under backend root '{backend_roots[backend]}'."
            )

    candidate_rows, feature_payload, recovery_warnings = _resolve_feature_selection(
        catalog=catalog,
        explicit_features=explicit_features,
        feature_profile=feature_profile,
        min_profile_features=min_profile_features,
    )
    global_feature_basis = _global_feature_basis(feature_payload)
    feature_artifacts = _write_feature_selection_artifacts(
        output_dir=resolved_output_dir,
        candidate_rows=candidate_rows,
        feature_payload=feature_payload,
    )

    contexts = _context_map(catalog)
    backends = [backend for backend, _ in resolved_backend_runs]
    anchor_backend, anchor_warnings = _resolve_anchor_backend(backends, catalog)
    problem_reports = _generate_problem_reports(
        problems=problems,
        candidate_rows=candidate_rows,
        contexts=contexts,
        global_feature_basis=global_feature_basis,
        feature_methods=feature_methods,
        include_3d=include_3d,
        backends=backends,
        anchor_backend=anchor_backend,
        output_dir=resolved_output_dir,
    )

    aggregate_payload = _generate_aggregate_outputs(
        rows=candidate_rows,
        backends=backends,
        global_feature_basis=global_feature_basis,
        feature_methods=feature_methods,
        aggregate_ppa_basis=aggregate_ppa_basis,
        output_dir=resolved_output_dir / "aggregate",
        anchor_backend=anchor_backend,
        catalog=catalog,
    )

    warnings = list(
        dict.fromkeys(
            list(catalog.warnings)
            + anchor_warnings
            + recovery_warnings
            + [
                warning
                for report in problem_reports
                for warning in report["warnings"]
            ]
        )
    )
    top_report_path = resolved_output_dir / "report.md"
    _write_top_report(
        report_path=top_report_path,
        backends=backends,
        candidate_count=len(candidate_rows),
        anchor_backend=anchor_backend,
        feature_payload=feature_payload,
        aggregate_report_path=Path(aggregate_payload["report_path"]),
        problem_reports=problem_reports,
        candidate_csv_path=feature_artifacts.candidate_csv_path,
        recommended_profile_path=feature_artifacts.recommended_profile_path,
        warnings=warnings,
    )

    summary = {
        "subset_config": str(subset_config),
        "output_dir": str(resolved_output_dir),
        "backend_runs": [
            {"backend": backend, "root": str(root)}
            for backend, root in resolved_backend_runs
        ],
        "candidate_count": len(candidate_rows),
        "classical_anchor_backend": anchor_backend,
        "feature_selection": feature_payload,
        "successful_candidates_csv": str(feature_artifacts.candidate_csv_path),
        "recommended_profile_path": str(feature_artifacts.recommended_profile_path),
        "aggregate": aggregate_payload,
        "problems": problem_reports,
        "pairwise_feature_comparisons": [
            {
                "benchmark": report["benchmark"],
                "problem": report["problem"],
                **comparison,
            }
            for report in problem_reports
            for comparison in report["pairwise_feature_comparisons"]
        ],
        "warnings": warnings,
    }
    summary_path = resolved_output_dir / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return {
        "report_path": str(top_report_path),
        "summary_path": str(summary_path),
        "summary": summary,
    }


def build_argument_parser() -> argparse.ArgumentParser:
    """Build the CLI parser for the standalone design-space report script."""

    parser = argparse.ArgumentParser(
        description="Generate retrospective design-space analysis for classical and QD runs.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "  python scripts/report_design_space_analysis.py \\\n"
            "    --run-root exp/hard_iteration_qd/<run_tag> \\\n"
            "    --subset-config data/configs/hard_iteration_subset.yaml\n\n"
            "  python scripts/report_design_space_analysis.py \\\n"
            "    --subset-config data/configs/hard_iteration_subset.yaml \\\n"
            "    --backend_run classic=exp/.../classic \\\n"
            "    --backend_run cvt_struct=exp/.../cvt_struct \\\n"
            "    --feature-profile implemented_structural_fixed_5d\n\n"
            "Explicit --feature values override --feature-profile when both are present.\n"
            "Aggregate raw pooled PPA plots remain qualitative-only because units differ across problems.\n"
            "Per-problem feature plots include both all-backend views and classic-vs-one-QD pairwise comparisons."
        ),
    )
    parser.add_argument(
        "--run-root",
        type=Path,
        default=None,
        help=(
            "Finished comparison root that already contains backend subdirectories. "
            "Use this when the report should auto-discover classic and QD backends."
        ),
    )
    parser.add_argument(
        "--backend_run",
        action="append",
        default=[],
        help=(
            "Backend mapping in the form <name>=<experiment_path>. Repeat this flag "
            "to compare multiple explicit backend roots."
        ),
    )
    parser.add_argument(
        "--subset-config",
        type=Path,
        required=True,
        help="Frozen subset YAML that lists the benchmark/problem pairs to analyze.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=None,
        help="Optional output directory. Defaults to <run-root>/design_space_analysis.",
    )
    parser.add_argument(
        "--feature-profile",
        default=None,
        help=(
            "Descriptor profile name to load from the descriptor-profile config. "
            "Ignored when explicit --feature values are provided."
        ),
    )
    parser.add_argument(
        "--feature",
        action="append",
        default=[],
        help=(
            "Explicit feature to keep in the global all-backend embedding space. "
            "Repeat for multiple features. This takes precedence over --feature-profile."
        ),
    )
    parser.add_argument(
        "--feature-method",
        action="append",
        choices=("pca", "tsne"),
        default=[],
        help="Embedding method to emit. Repeat for multiple methods. Defaults to PCA + t-SNE.",
    )
    parser.add_argument(
        "--aggregate-ppa-basis",
        choices=("normalized", "raw", "both"),
        default="both",
        help=(
            "Aggregate PPA basis to plot across problems. Raw pooled plots are "
            "qualitative-only because units differ across problems."
        ),
    )
    parser.add_argument(
        "--include-3d",
        action="store_true",
        help="Also emit 3D sequential PPA scatters in per-problem reports.",
    )
    parser.add_argument(
        "--min-profile-features",
        type=int,
        default=7,
        help=(
            "Minimum number of non-target features to keep when auto-selecting a "
            "recommended profile."
        ),
    )
    return parser


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()
    if args.run_root is None and not args.backend_run:
        parser.error("one of --run-root or --backend_run is required")
    if args.run_root is not None and args.backend_run:
        parser.error("use either --run-root or --backend_run, not both")
    backend_runs = None
    if args.backend_run:
        backend_runs = _parse_backend_runs(args.backend_run)
    result = generate_design_space_analysis(
        subset_config=args.subset_config,
        backend_runs=backend_runs,
        run_root=args.run_root,
        output_dir=args.output_dir,
        feature_profile=args.feature_profile,
        explicit_features=args.feature,
        feature_methods=args.feature_method or None,
        aggregate_ppa_basis=args.aggregate_ppa_basis,
        include_3d=args.include_3d,
        min_profile_features=args.min_profile_features,
    )
    print(
        json.dumps(
            {
                "report_path": result["report_path"],
                "summary_path": result["summary_path"],
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
