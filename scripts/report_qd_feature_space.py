#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
import math
import statistics
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt
import numpy as np
import yaml
from scipy.stats import spearmanr

IGNORED_SUMMARY_FILENAMES = {"archive_summary.json"}
TARGET_COLUMNS = ("quality_score", "g_P", "g_A", "g_T")
BENCHMARK_MARKERS = {
    "RTLLM": "o",
    "VerilogEval-Spec-to-RTL": "s",
    "RealBench": "^",
    "cvdp": "D",
}
RIDGE_ALPHAS = [0.01, 0.1, 1.0, 10.0, 100.0]


@dataclass(frozen=True)
class ProblemMetrics:
    backend: str
    benchmark: str
    problem: str
    functionality_rate: float
    synthesis_rate: float
    best_score: float | None
    runtime_seconds: float
    qd_archive_type: str | None
    qd_coverage: float | None
    qd_score: float | None
    qd_best_quality: float | None


@dataclass(frozen=True)
class FeatureStats:
    feature: str
    count: int
    finite_fraction: float
    unique_count: int
    unique_ratio: float
    nonzero_fraction: float
    min_value: float | None
    max_value: float | None
    mean_value: float | None
    stddev_value: float | None
    q25_value: float | None
    q75_value: float | None
    iqr_value: float | None
    normalized_range_coverage: float
    collapsed: bool
    near_collapsed: bool


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _safe_rate(value: Any) -> float:
    parsed = _safe_float(value)
    if parsed is None:
        return 0.0
    return max(0.0, parsed)


def _mean(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def _format_float(value: float | None, digits: int = 4) -> str:
    if value is None:
        return "N/A"
    return f"{value:.{digits}f}"


def _format_percent(value: float | None) -> str:
    if value is None:
        return "N/A"
    return f"{value * 100.0:.1f}%"


def _load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
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


def _canonical_summary_identity(summary_path: Path) -> tuple[str, str] | None:
    try:
        benchmark = summary_path.parent.parent.name
        problem = summary_path.parent.name
    except IndexError:
        return None
    if not benchmark or not problem:
        return None
    return benchmark, problem


def _canonical_event_identity(event_path: Path) -> tuple[str, str] | None:
    try:
        benchmark = event_path.parents[3].name
        problem = event_path.parents[2].name
    except IndexError:
        return None
    if not benchmark or not problem:
        return None
    return benchmark, problem


def _load_json_mapping(path: Path, *, warnings: list[str], label: str) -> dict[str, Any] | None:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        warnings.append(f"Skipped malformed {label}: {path} ({exc})")
        return None
    if not isinstance(payload, dict):
        warnings.append(f"Skipped non-object {label}: {path}")
        return None
    return payload


def _load_qd_archive_summary(summary_path: Path, *, warnings: list[str]) -> dict[str, Any]:
    archive_summary_path = summary_path.parent / "archive_summary.json"
    if not archive_summary_path.is_file():
        return {}
    payload = _load_json_mapping(
        archive_summary_path,
        warnings=warnings,
        label="archive summary",
    )
    if payload is None:
        return {}
    return payload


def _is_problem_summary_path(summary_path: Path) -> bool:
    return (
        summary_path.name.endswith("_summary.json")
        and summary_path.name not in IGNORED_SUMMARY_FILENAMES
    )


def _load_problem_metrics(
    backend: str,
    root: Path,
    *,
    allowed_problems: set[tuple[str, str]],
    warnings: list[str],
) -> dict[tuple[str, str], ProblemMetrics]:
    if not root.is_dir():
        raise ValueError(f"Backend root does not exist: {root}")
    rows: dict[tuple[str, str], ProblemMetrics] = {}
    for summary_path in sorted(root.rglob("*_summary.json")):
        if not _is_problem_summary_path(summary_path):
            continue
        payload = _load_json_mapping(
            summary_path,
            warnings=warnings,
            label="problem summary",
        )
        if payload is None:
            continue
        benchmark = payload.get("benchmark_name") or summary_path.parent.parent.name
        problem = payload.get("problem_name") or summary_path.parent.name
        if not isinstance(benchmark, str) or not isinstance(problem, str):
            continue
        problem_key = (benchmark, problem)
        if problem_key not in allowed_problems:
            continue
        canonical_identity = _canonical_summary_identity(summary_path)
        if canonical_identity != problem_key:
            warnings.append(
                "Skipped non-canonical problem summary outside selected problem directory: "
                f"{summary_path}"
            )
            continue
        rates = {}
        for rate_key in ("success_rates", "accumulated_success_rates"):
            value = payload.get(rate_key)
            if isinstance(value, dict):
                rates = value
                break
        archive_summary = _load_qd_archive_summary(summary_path, warnings=warnings)
        best_score_raw = payload.get("best_score")
        if best_score_raw is None:
            final_population = payload.get("final_population_ppa")
            if isinstance(final_population, dict):
                best_score_raw = final_population.get("best_score")
        rows[problem_key] = ProblemMetrics(
            backend=backend,
            benchmark=benchmark,
            problem=problem,
            functionality_rate=_safe_rate(
                rates.get("total_functionality", rates.get("functionality", 0.0))
            ),
            synthesis_rate=_safe_rate(
                rates.get("total_synthesis_ppa", rates.get("synthesis_ppa", rates.get("synthesis", 0.0)))
            ),
            best_score=_safe_float(best_score_raw),
            runtime_seconds=float(payload.get("total_runtime_seconds", 0.0) or 0.0),
            qd_archive_type=(
                archive_summary.get("archive_type")
                if isinstance(archive_summary.get("archive_type"), str)
                else None
            ),
            qd_coverage=_safe_float(archive_summary.get("coverage")),
            qd_score=_safe_float(archive_summary.get("qd_score")),
            qd_best_quality=_safe_float(archive_summary.get("best_quality")),
        )
    return rows


def _placeholder_metrics(backend: str, benchmark: str, problem: str) -> ProblemMetrics:
    return ProblemMetrics(
        backend=backend,
        benchmark=benchmark,
        problem=problem,
        functionality_rate=0.0,
        synthesis_rate=0.0,
        best_score=None,
        runtime_seconds=0.0,
        qd_archive_type=None,
        qd_coverage=None,
        qd_score=None,
        qd_best_quality=None,
    )


def _aggregate_backend(
    backend: str,
    problems: list[tuple[str, str]],
    metrics_by_problem: dict[tuple[str, str], ProblemMetrics],
) -> dict[str, Any]:
    ordered = [
        metrics_by_problem.get((benchmark, problem), _placeholder_metrics(backend, benchmark, problem))
        for benchmark, problem in problems
    ]
    solved_scores = [
        row.best_score for row in ordered if row.synthesis_rate > 0.0 and row.best_score is not None
    ]
    qd_coverages = [row.qd_coverage for row in ordered if row.qd_coverage is not None]
    qd_scores = [row.qd_score for row in ordered if row.qd_score is not None]
    qd_best_qualities = [row.qd_best_quality for row in ordered if row.qd_best_quality is not None]
    qd_archive_types = sorted({row.qd_archive_type for row in ordered if row.qd_archive_type})
    return {
        "backend": backend,
        "problem_count": len(ordered),
        "functionality_mean": _mean([row.functionality_rate for row in ordered]),
        "synthesis_mean": _mean([row.synthesis_rate for row in ordered]),
        "solved_problem_count": sum(1 for row in ordered if row.synthesis_rate > 0.0),
        "best_score_mean": _mean([value for value in solved_scores if value is not None]),
        "runtime_seconds_mean": _mean([row.runtime_seconds for row in ordered]),
        "qd_archive_types": qd_archive_types,
        "qd_coverage_mean": _mean([value for value in qd_coverages if value is not None]),
        "qd_score_mean": _mean([value for value in qd_scores if value is not None]),
        "qd_best_quality_mean": _mean([value for value in qd_best_qualities if value is not None]),
    }


def _write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def _load_archive_elites(root: Path) -> dict[tuple[str, str], set[str]]:
    elite_ids: dict[tuple[str, str], set[str]] = defaultdict(set)
    for cells_path in root.rglob("archive_cells.csv"):
        identity = _canonical_summary_identity(cells_path)
        if identity is None:
            continue
        benchmark, problem = identity
        with cells_path.open("r", encoding="utf-8", newline="") as handle:
            reader = csv.DictReader(handle)
            for row in reader:
                candidate_id = row.get("candidate_id")
                if candidate_id:
                    elite_ids[(benchmark, problem)].add(candidate_id)
    return elite_ids


def _flatten_numeric_metrics(payload: dict[str, Any]) -> dict[str, float]:
    flattened: dict[str, float] = {}
    for key in (
        "structural_metrics",
        "rtl_metrics",
        "dynamic_metrics",
        "physical_metrics",
        "descriptor_values",
        "score_components",
    ):
        metrics = payload.get(key)
        if not isinstance(metrics, dict):
            continue
        for metric_name, metric_value in metrics.items():
            if not isinstance(metric_name, str):
                continue
            parsed = _safe_float(metric_value)
            if parsed is not None:
                flattened[metric_name] = parsed
    return flattened


def _collect_qd_candidates(
    backend: str,
    root: Path,
    *,
    allowed_problems: set[tuple[str, str]],
    warnings: list[str],
) -> list[dict[str, Any]]:
    if not root.is_dir():
        raise ValueError(f"Backend root does not exist: {root}")
    elite_ids = _load_archive_elites(root)
    rows: list[dict[str, Any]] = []
    for event_path in sorted(root.rglob("qd_archive_event.json")):
        payload = _load_json_mapping(
            event_path,
            warnings=warnings,
            label="qd archive event",
        )
        if payload is None:
            continue
        identity = _canonical_event_identity(event_path)
        if identity is None:
            continue
        benchmark, problem = identity
        if (benchmark, problem) not in allowed_problems:
            continue
        features = _flatten_numeric_metrics(payload)
        quality_score = _safe_float(payload.get("quality_score"))
        if quality_score is None:
            continue
        row: dict[str, Any] = {
            "backend": backend,
            "benchmark": benchmark,
            "problem": problem,
            "candidate_id": str(payload.get("candidate_id", "")),
            "generation": int(payload.get("generation", 0) or 0),
            "strategy": str(payload.get("strategy", "")),
            "origin_pool": str(payload.get("origin_pool", "")),
            "generated_mode": str(payload.get("generated_mode", "")),
            "archive_type": str(payload.get("archive_type", "")),
            "quality_score": quality_score,
            "decision": str(payload.get("decision", "")),
            "inserted": bool(payload.get("inserted", False)),
            "replaced": bool(payload.get("replaced", False)),
            "cell_id": str(payload.get("cell_id", "")),
            "code_file_path": str(payload.get("current_cell_elite", {}).get("code_file_path") or ""),
            "is_final_elite": str(payload.get("candidate_id", "")) in elite_ids[(benchmark, problem)],
        }
        for metric_name, metric_value in features.items():
            row[metric_name] = metric_value
        rows.append(row)
    return rows


def _candidate_feature_columns(rows: list[dict[str, Any]]) -> list[str]:
    excluded = {
        "backend",
        "benchmark",
        "problem",
        "candidate_id",
        "generation",
        "strategy",
        "origin_pool",
        "generated_mode",
        "archive_type",
        "decision",
        "inserted",
        "replaced",
        "cell_id",
        "code_file_path",
        "is_final_elite",
    }
    cols: set[str] = set()
    for row in rows:
        for key, value in row.items():
            if key in excluded or key in TARGET_COLUMNS:
                continue
            if isinstance(value, (int, float)) and math.isfinite(float(value)):
                cols.add(key)
    return sorted(cols)


def _values_for_feature(rows: list[dict[str, Any]], feature: str) -> list[float]:
    values: list[float] = []
    for row in rows:
        parsed = _safe_float(row.get(feature))
        if parsed is not None:
            values.append(parsed)
    return values


def _quantile(sorted_values: list[float], q: float) -> float | None:
    if not sorted_values:
        return None
    if len(sorted_values) == 1:
        return sorted_values[0]
    index = (len(sorted_values) - 1) * q
    lower = math.floor(index)
    upper = math.ceil(index)
    if lower == upper:
        return sorted_values[lower]
    fraction = index - lower
    return sorted_values[lower] * (1.0 - fraction) + sorted_values[upper] * fraction


def _compute_feature_stats(
    rows: list[dict[str, Any]],
    feature: str,
    global_range_by_feature: dict[str, float],
) -> FeatureStats:
    total_count = len(rows)
    values = _values_for_feature(rows, feature)
    finite_fraction = (len(values) / total_count) if total_count else 0.0
    if not values:
        return FeatureStats(
            feature=feature,
            count=0,
            finite_fraction=finite_fraction,
            unique_count=0,
            unique_ratio=0.0,
            nonzero_fraction=0.0,
            min_value=None,
            max_value=None,
            mean_value=None,
            stddev_value=None,
            q25_value=None,
            q75_value=None,
            iqr_value=None,
            normalized_range_coverage=0.0,
            collapsed=True,
            near_collapsed=True,
        )
    sorted_values = sorted(values)
    unique_count = len({round(value, 12) for value in values})
    unique_ratio = unique_count / len(values)
    nonzero_fraction = sum(value != 0.0 for value in values) / len(values)
    min_value = sorted_values[0]
    max_value = sorted_values[-1]
    stddev_value = statistics.pstdev(values) if len(values) > 1 else 0.0
    q25_value = _quantile(sorted_values, 0.25)
    q75_value = _quantile(sorted_values, 0.75)
    iqr_value = (q75_value - q25_value) if q25_value is not None and q75_value is not None else None
    global_range = global_range_by_feature.get(feature, 0.0)
    normalized_range_coverage = 0.0
    if global_range > 0.0:
        normalized_range_coverage = max(0.0, (max_value - min_value) / global_range)
    collapsed = unique_count <= 1 or nonzero_fraction == 0.0
    near_collapsed = collapsed or normalized_range_coverage < 0.05
    return FeatureStats(
        feature=feature,
        count=len(values),
        finite_fraction=finite_fraction,
        unique_count=unique_count,
        unique_ratio=unique_ratio,
        nonzero_fraction=nonzero_fraction,
        min_value=min_value,
        max_value=max_value,
        mean_value=statistics.fmean(values),
        stddev_value=stddev_value,
        q25_value=q25_value,
        q75_value=q75_value,
        iqr_value=iqr_value,
        normalized_range_coverage=normalized_range_coverage,
        collapsed=collapsed,
        near_collapsed=near_collapsed,
    )


def _global_range_by_feature(rows: list[dict[str, Any]], features: list[str]) -> dict[str, float]:
    ranges: dict[str, float] = {}
    for feature in features:
        values = _values_for_feature(rows, feature)
        ranges[feature] = (max(values) - min(values)) if values else 0.0
    return ranges


def _stats_rows(stats_by_feature: list[FeatureStats]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for stats in stats_by_feature:
        rows.append(
            {
                "feature": stats.feature,
                "count": stats.count,
                "finite_fraction": stats.finite_fraction,
                "unique_count": stats.unique_count,
                "unique_ratio": stats.unique_ratio,
                "nonzero_fraction": stats.nonzero_fraction,
                "min": stats.min_value,
                "max": stats.max_value,
                "mean": stats.mean_value,
                "stddev": stats.stddev_value,
                "q25": stats.q25_value,
                "q75": stats.q75_value,
                "iqr": stats.iqr_value,
                "normalized_range_coverage": stats.normalized_range_coverage,
                "collapsed": stats.collapsed,
                "near_collapsed": stats.near_collapsed,
            }
        )
    return rows


def _write_histograms(
    path: Path,
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    *,
    title: str,
) -> str | None:
    if not feature_cols or not rows:
        return None
    cols = 4
    num_rows = math.ceil(len(feature_cols) / cols)
    fig, axes = plt.subplots(num_rows, cols, figsize=(cols * 4.5, num_rows * 3.0))
    axes_list = list(axes.flatten()) if hasattr(axes, "flatten") else [axes]
    elite_rows = [row for row in rows if bool(row.get("is_final_elite"))]
    for axis, feature in zip(axes_list, feature_cols):
        values = _values_for_feature(rows, feature)
        elite_values = _values_for_feature(elite_rows, feature)
        if values:
            bins = min(20, max(5, int(math.sqrt(len(values)))))
            axis.hist(values, bins=bins, color="#4c78a8", alpha=0.65, label="all success")
        if elite_values:
            bins = min(12, max(3, int(math.sqrt(len(elite_values)))))
            axis.hist(elite_values, bins=bins, color="#f58518", alpha=0.55, label="final elite")
        axis.set_title(feature)
        axis.grid(True, axis="y", alpha=0.25)
        if values and elite_values:
            axis.legend(fontsize=8)
    for axis in axes_list[len(feature_cols):]:
        axis.axis("off")
    fig.suptitle(title)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _embedding_feature_matrix(rows: list[dict[str, Any]], feature_cols: list[str]) -> tuple[list[str], list[list[float]]]:
    usable_cols: list[str] = []
    matrix_by_col: dict[str, list[float]] = {}
    for feature in feature_cols:
        values = [_safe_float(row.get(feature)) for row in rows]
        finite_values = [value for value in values if value is not None]
        if len(finite_values) < max(3, math.ceil(0.9 * len(rows))):
            continue
        median = statistics.median(finite_values)
        matrix_by_col[feature] = [value if value is not None else median for value in values]
        usable_cols.append(feature)
    matrix = [[matrix_by_col[col][index] for col in usable_cols] for index in range(len(rows))]
    return usable_cols, matrix


def _standardize_matrix(matrix: list[list[float]]) -> np.ndarray:
    x = np.asarray(matrix, dtype=float)
    means = np.mean(x, axis=0)
    stds = np.std(x, axis=0)
    stds[stds == 0.0] = 1.0
    return (x - means) / stds


def _pairwise_squared_distances(x: np.ndarray) -> np.ndarray:
    squared_norms = np.sum(np.square(x), axis=1)
    distances = squared_norms[:, None] + squared_norms[None, :] - 2.0 * x.dot(x.T)
    np.fill_diagonal(distances, 0.0)
    return np.maximum(distances, 0.0)


def _tsne_probabilities(x: np.ndarray, perplexity: float) -> np.ndarray:
    distances = _pairwise_squared_distances(x)
    n = x.shape[0]
    conditional = np.zeros((n, n), dtype=float)
    target_entropy = math.log(perplexity)
    for index in range(n):
        mask = np.ones(n, dtype=bool)
        mask[index] = False
        dist_row = distances[index, mask]
        beta = 1.0
        beta_min: float | None = None
        beta_max: float | None = None
        probs = np.ones_like(dist_row) / max(len(dist_row), 1)
        for _ in range(50):
            probs = np.exp(-dist_row * beta)
            probs_sum = float(np.sum(probs))
            if probs_sum <= 1e-12:
                probs = np.ones_like(dist_row) / max(len(dist_row), 1)
                break
            probs = probs / probs_sum
            entropy = math.log(probs_sum) + beta * float(np.sum(dist_row * probs))
            diff = entropy - target_entropy
            if abs(diff) < 1e-5:
                break
            if diff > 0.0:
                beta_min = beta
                beta = beta * 2.0 if beta_max is None else 0.5 * (beta + beta_max)
            else:
                beta_max = beta
                beta = beta * 0.5 if beta_min is None else 0.5 * (beta + beta_min)
        conditional[index, mask] = probs
    sym = (conditional + conditional.T) / (2.0 * n)
    sym = np.maximum(sym, 1e-12)
    return sym / np.sum(sym)


def _tsne_embedding(x: np.ndarray, *, perplexity: float, max_iter: int = 500) -> np.ndarray:
    n = x.shape[0]
    if n < 3:
        raise ValueError("t-SNE requires at least 3 samples.")
    p = _tsne_probabilities(x, perplexity=perplexity)
    p *= 4.0
    rng = np.random.default_rng(42)
    y = rng.normal(loc=0.0, scale=1e-4, size=(n, 2))
    velocity = np.zeros_like(y)
    learning_rate = max(50.0, n / 12.0)
    for iteration in range(max_iter):
        distances = _pairwise_squared_distances(y)
        inv = 1.0 / (1.0 + distances)
        np.fill_diagonal(inv, 0.0)
        q = inv / np.maximum(np.sum(inv), 1e-12)
        grad = np.zeros_like(y)
        pq = p - q
        for index in range(n):
            diff = y[index] - y
            factors = (pq[index, :] * inv[index, :])[:, None]
            grad[index] = 4.0 * np.sum(factors * diff, axis=0)
        momentum = 0.5 if iteration < 100 else 0.8
        velocity = momentum * velocity - learning_rate * grad
        y += velocity
        y -= np.mean(y, axis=0, keepdims=True)
        if iteration == 100:
            p /= 4.0
    return y


def _fit_ridge_weights(x: np.ndarray, y: np.ndarray, alpha: float) -> np.ndarray:
    regularizer = alpha * np.eye(x.shape[1], dtype=float)
    return np.linalg.solve(x.T.dot(x) + regularizer, x.T.dot(y))


def _cross_validated_ridge_alpha(x: np.ndarray, y: np.ndarray) -> float:
    sample_count = x.shape[0]
    fold_count = min(5, sample_count)
    if fold_count < 2:
        return RIDGE_ALPHAS[0]
    indices = np.arange(sample_count)
    folds = np.array_split(indices, fold_count)
    best_alpha = RIDGE_ALPHAS[0]
    best_error = float("inf")
    for alpha in RIDGE_ALPHAS:
        total_error = 0.0
        total_points = 0
        for fold in folds:
            train_mask = np.ones(sample_count, dtype=bool)
            train_mask[fold] = False
            x_train = x[train_mask]
            y_train = y[train_mask]
            x_val = x[fold]
            y_val = y[fold]
            if len(x_train) == 0 or len(x_val) == 0:
                continue
            weights = _fit_ridge_weights(x_train, y_train, alpha)
            preds = x_val.dot(weights)
            total_error += float(np.sum(np.square(preds - y_val)))
            total_points += len(x_val)
        mse = total_error / max(total_points, 1)
        if mse < best_error:
            best_error = mse
            best_alpha = alpha
    return best_alpha


def _scatter_embeddings(
    path: Path,
    points: list[tuple[float, float]],
    rows: list[dict[str, Any]],
    *,
    title: str,
) -> str:
    fig, ax = plt.subplots(figsize=(7, 5.5))
    quality_scores = [_safe_float(row.get("quality_score")) or 0.0 for row in rows]
    benchmarks = sorted({str(row.get("benchmark", "")) for row in rows})
    color_mappable = None
    for benchmark in benchmarks:
        mask = [index for index, row in enumerate(rows) if row.get("benchmark") == benchmark]
        if not mask:
            continue
        xs = [points[index][0] for index in mask]
        ys = [points[index][1] for index in mask]
        colors = [quality_scores[index] for index in mask]
        color_mappable = ax.scatter(
            xs,
            ys,
            c=colors,
            cmap="viridis",
            marker=BENCHMARK_MARKERS.get(benchmark, "o"),
            label=benchmark,
            alpha=0.85,
            edgecolors="none",
        )
    ax.set_title(title)
    ax.set_xlabel("component_1")
    ax.set_ylabel("component_2")
    ax.grid(True, alpha=0.25)
    if color_mappable is not None:
        fig.colorbar(color_mappable, ax=ax, label="fitness / quality_score")
    if benchmarks:
        ax.legend(loc="best", fontsize=8)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return str(path)


def _write_embeddings(path_root: Path, rows: list[dict[str, Any]], feature_cols: list[str]) -> dict[str, Any]:
    if len(rows) < 3:
        return {"usable_features": [], "pca_plot": None, "tsne_plot": None, "note": "too_few_successes"}
    usable_cols, matrix = _embedding_feature_matrix(rows, feature_cols)
    if len(usable_cols) < 2:
        return {"usable_features": usable_cols, "pca_plot": None, "tsne_plot": None, "note": "too_few_varying_features"}
    x_scaled = _standardize_matrix(matrix)

    _, _, vt = np.linalg.svd(x_scaled, full_matrices=False)
    pca_points = x_scaled.dot(vt[:2].T)
    pca_path = _scatter_embeddings(
        path_root / "pca_fitness.png",
        [(float(row[0]), float(row[1])) for row in pca_points],
        rows,
        title="PCA of successful designs",
    )

    tsne_path: str | None = None
    tsne_note: str | None = None
    if len(rows) >= 6:
        perplexity = min(30, max(5, (len(rows) - 1) // 3))
        if perplexity < len(rows):
            tsne_points = _tsne_embedding(x_scaled, perplexity=perplexity, max_iter=500)
            tsne_path = _scatter_embeddings(
                path_root / "tsne_fitness.png",
                [(float(row[0]), float(row[1])) for row in tsne_points],
                rows,
                title="t-SNE of successful designs",
            )
        else:
            tsne_note = "invalid_perplexity_for_sample_count"
    else:
        tsne_note = "too_few_successes"

    return {
        "usable_features": usable_cols,
        "pca_plot": pca_path,
        "tsne_plot": tsne_path,
        "note": tsne_note,
    }


def _spearman_feature_map(rows: list[dict[str, Any]], feature_cols: list[str], target: str) -> dict[str, float | None]:
    correlations: dict[str, float | None] = {}
    target_values = [_safe_float(row.get(target)) for row in rows]
    for feature in feature_cols:
        feature_values = [_safe_float(row.get(feature)) for row in rows]
        paired = [
            (feature_value, target_value)
            for feature_value, target_value in zip(feature_values, target_values)
            if feature_value is not None and target_value is not None
        ]
        if len(paired) < 3:
            correlations[feature] = None
            continue
        left = [pair[0] for pair in paired]
        right = [pair[1] for pair in paired]
        if len({round(value, 12) for value in left}) <= 1 or len({round(value, 12) for value in right}) <= 1:
            correlations[feature] = None
            continue
        corr = spearmanr(left, right).correlation
        correlations[feature] = float(corr) if corr is not None and math.isfinite(float(corr)) else None
    return correlations


def _run_ridge_regression(rows: list[dict[str, Any]], feature_cols: list[str], target: str) -> dict[str, Any]:
    usable_rows: list[dict[str, Any]] = []
    for row in rows:
        target_value = _safe_float(row.get(target))
        if target_value is None:
            continue
        usable_rows.append(row)
    if len(usable_rows) < 4 or not feature_cols:
        return {"target": target, "sample_count": len(usable_rows), "r2": None, "alpha": None, "coefficients": []}
    usable_cols, matrix = _embedding_feature_matrix(usable_rows, feature_cols)
    if not usable_cols:
        return {"target": target, "sample_count": len(usable_rows), "r2": None, "alpha": None, "coefficients": []}
    y = [_safe_float(row.get(target)) or 0.0 for row in usable_rows]
    x_scaled = _standardize_matrix(matrix)
    y_array = np.asarray(y, dtype=float)
    y_mean = float(np.mean(y_array))
    y_std = float(np.std(y_array))
    if y_std == 0.0:
        return {"target": target, "sample_count": len(usable_rows), "r2": None, "alpha": None, "coefficients": []}
    y_scaled = (y_array - y_mean) / y_std
    alpha = _cross_validated_ridge_alpha(x_scaled, y_scaled)
    weights = _fit_ridge_weights(x_scaled, y_scaled, alpha)
    predictions = x_scaled.dot(weights)
    coefficients = [
        {"feature": feature, "coefficient": float(coefficient)}
        for feature, coefficient in sorted(
            zip(usable_cols, weights, strict=True),
            key=lambda item: abs(float(item[1])),
            reverse=True,
        )
    ]
    residual = float(np.sum(np.square(y_scaled - predictions)))
    total = float(np.sum(np.square(y_scaled - np.mean(y_scaled))))
    r2 = 1.0 - (residual / total) if total > 0.0 else None
    return {
        "target": target,
        "sample_count": len(usable_rows),
        "r2": r2,
        "alpha": float(alpha),
        "coefficients": coefficients,
    }


def _per_backend_feature_summary(
    backend: str,
    rows: list[dict[str, Any]],
    output_dir: Path,
    global_ranges: dict[str, float],
) -> dict[str, Any]:
    feature_cols = _candidate_feature_columns(rows)
    stats = [_compute_feature_stats(rows, feature, global_ranges) for feature in feature_cols]
    stats_rows = _stats_rows(stats)
    _write_csv(
        output_dir / "feature_stats.csv",
        stats_rows,
        [
            "feature",
            "count",
            "finite_fraction",
            "unique_count",
            "unique_ratio",
            "nonzero_fraction",
            "min",
            "max",
            "mean",
            "stddev",
            "q25",
            "q75",
            "iqr",
            "normalized_range_coverage",
            "collapsed",
            "near_collapsed",
        ],
    )
    hist_path = _write_histograms(
        output_dir / "feature_histograms.png",
        rows,
        feature_cols,
        title=f"{backend}: successful design feature histograms",
    )
    embeddings = _write_embeddings(output_dir, rows, feature_cols)
    fitness_corr = _spearman_feature_map(rows, feature_cols, "quality_score")
    top_fitness = [
        {"feature": feature, "spearman": corr}
        for feature, corr in sorted(
            ((feature, corr) for feature, corr in fitness_corr.items() if corr is not None),
            key=lambda item: abs(float(item[1])),
            reverse=True,
        )[:10]
    ]
    payload = {
        "backend": backend,
        "success_count": len(rows),
        "final_elite_count": sum(1 for row in rows if bool(row.get("is_final_elite"))),
        "feature_count": len(feature_cols),
        "collapsed_features": [stats.feature for stats in stats if stats.collapsed],
        "near_collapsed_features": [stats.feature for stats in stats if stats.near_collapsed],
        "top_fitness_correlations": top_fitness,
        "histogram_file": hist_path,
        "embeddings": embeddings,
    }
    (output_dir / "summary.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
    return payload


def _write_backend_report(
    path: Path,
    backend_summary: dict[str, Any],
    feature_stats: list[FeatureStats],
) -> None:
    top_variable = sorted(
        feature_stats,
        key=lambda item: (item.normalized_range_coverage, item.stddev_value or 0.0),
        reverse=True,
    )[:10]
    lines = [
        f"# {backend_summary['backend']} feature-space report",
        "",
        f"- successful_candidates: `{backend_summary['success_count']}`",
        f"- final_elites: `{backend_summary['final_elite_count']}`",
        f"- feature_count: `{backend_summary['feature_count']}`",
        f"- collapsed_features: `{', '.join(backend_summary['collapsed_features']) if backend_summary['collapsed_features'] else 'none'}`",
        f"- near_collapsed_features: `{', '.join(backend_summary['near_collapsed_features']) if backend_summary['near_collapsed_features'] else 'none'}`",
        "",
        "## Top fitness correlations",
        "",
    ]
    if backend_summary["top_fitness_correlations"]:
        for row in backend_summary["top_fitness_correlations"]:
            lines.append(f"- `{row['feature']}`: `{row['spearman']:.4f}`")
    else:
        lines.append("- no valid fitness correlations")
    lines.extend([
        "",
        "## Highest-variation features",
        "",
    ])
    for stats in top_variable:
        lines.append(
            f"- `{stats.feature}`: coverage=`{stats.normalized_range_coverage:.4f}`, "
            f"stddev=`{_format_float(stats.stddev_value)}`, unique=`{stats.unique_count}`"
        )
    lines.extend([
        "",
        "## Plot files",
        "",
        f"- histogram: `{backend_summary.get('histogram_file') or 'n/a'}`",
        f"- PCA: `{backend_summary['embeddings'].get('pca_plot') or 'n/a'}`",
        f"- t-SNE: `{backend_summary['embeddings'].get('tsne_plot') or backend_summary['embeddings'].get('note') or 'n/a'}`",
        "",
    ])
    path.write_text("\n".join(lines), encoding="utf-8")


def _profile_feature_scores(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    backend_feature_stats: dict[str, list[FeatureStats]],
) -> list[dict[str, Any]]:
    global_ranges = _global_range_by_feature(rows, feature_cols)
    global_stats = {feature: _compute_feature_stats(rows, feature, global_ranges) for feature in feature_cols}
    scores: list[dict[str, Any]] = []
    targets = [target for target in TARGET_COLUMNS if target == "quality_score" or any(_safe_float(row.get(target)) is not None for row in rows)]
    per_target_corr = {target: _spearman_feature_map(rows, feature_cols, target) for target in targets}
    for feature in feature_cols:
        if feature in {"g_P", "g_A", "g_T"}:
            continue
        stats = global_stats[feature]
        collapsed_in_backends = sum(
            1
            for feature_stats in backend_feature_stats.values()
            for item in feature_stats
            if item.feature == feature and item.collapsed
        )
        if stats.finite_fraction < 0.9 or stats.collapsed or collapsed_in_backends >= 2:
            eligible = False
        else:
            eligible = True
        predictive = max(
            [abs(corr) for corr in (per_target_corr[target].get(feature) for target in targets) if corr is not None] or [0.0]
        )
        diversity = statistics.fmean(
            [
                stats.normalized_range_coverage,
                min(1.0, (stats.stddev_value or 0.0) / max(abs(stats.mean_value or 0.0), 1e-6)),
                stats.unique_ratio,
            ]
        )
        stability = stats.finite_fraction
        composite = 0.45 * predictive + 0.35 * diversity + 0.20 * stability
        scores.append(
            {
                "feature": feature,
                "eligible": eligible,
                "predictive_score": predictive,
                "diversity_score": diversity,
                "stability_score": stability,
                "composite_score": composite,
                "collapsed_in_backend_count": collapsed_in_backends,
                "finite_fraction": stats.finite_fraction,
                "normalized_range_coverage": stats.normalized_range_coverage,
                "unique_ratio": stats.unique_ratio,
            }
        )
    scores.sort(key=lambda item: (item["eligible"], item["composite_score"]), reverse=True)
    return scores


def _recommended_profile(scores: list[dict[str, Any]], min_features: int) -> dict[str, Any]:
    selected = [row["feature"] for row in scores if row["eligible"]][:min_features]
    sequential_axes = list(selected) + ["g_P", "g_A", "g_T"]
    combinational_axes = [axis for axis in sequential_axes if axis != "g_T"]
    return {
        "selected_non_target_features": selected,
        "sequential_axes": sequential_axes,
        "combinational_axes": combinational_axes,
        "feature_scores": scores,
    }


def _write_top_report(
    path: Path,
    backend_aggregates: list[dict[str, Any]],
    per_backend_payloads: dict[str, dict[str, Any]],
    regression_payload: dict[str, Any],
    profile_payload: dict[str, Any],
    warnings: list[str],
) -> None:
    lines = [
        "# QD Feature-Space Analysis",
        "",
        "## Backend aggregate comparison",
        "",
        "| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for agg in backend_aggregates:
        lines.append(
            "| {backend} | {func} | {synth} | {solved} | {best} | {runtime} | {cov} | {qd_score} |".format(
                backend=agg["backend"],
                func=_format_percent(agg.get("functionality_mean")),
                synth=_format_percent(agg.get("synthesis_mean")),
                solved=agg.get("solved_problem_count", 0),
                best=_format_float(agg.get("best_score_mean")),
                runtime=_format_float(agg.get("runtime_seconds_mean"), 1),
                cov=_format_percent(agg.get("qd_coverage_mean")),
                qd_score=_format_float(agg.get("qd_score_mean")),
            )
        )
    lines.extend([
        "",
        "## QD backend feature-space summary",
        "",
    ])
    for backend, payload in per_backend_payloads.items():
        lines.extend(
            [
                f"### {backend}",
                "",
                f"- successful_candidates: `{payload['success_count']}`",
                f"- final_elites: `{payload['final_elite_count']}`",
                f"- collapsed_features: `{', '.join(payload['collapsed_features']) if payload['collapsed_features'] else 'none'}`",
                f"- near_collapsed_features: `{', '.join(payload['near_collapsed_features']) if payload['near_collapsed_features'] else 'none'}`",
                f"- histogram: `{payload.get('histogram_file') or 'n/a'}`",
                f"- PCA: `{payload['embeddings'].get('pca_plot') or 'n/a'}`",
                f"- t-SNE: `{payload['embeddings'].get('tsne_plot') or payload['embeddings'].get('note') or 'n/a'}`",
                "",
            ]
        )
    lines.extend([
        "## Regression summary",
        "",
    ])
    for target, payload in regression_payload.items():
        lines.append(f"### {target}")
        lines.append("")
        lines.append(f"- sample_count: `{payload['sample_count']}`")
        lines.append(f"- ridge_alpha: `{_format_float(payload['alpha'])}`")
        lines.append(f"- ridge_r2: `{_format_float(payload['r2'])}`")
        lines.append("- top_coefficients:")
        top_coeffs = payload.get("coefficients", [])[:10]
        if top_coeffs:
            for coefficient in top_coeffs:
                lines.append(
                    f"  - `{coefficient['feature']}`: `{coefficient['coefficient']:.4f}`"
                )
        else:
            lines.append("  - none")
        lines.append("")
    lines.extend([
        "## Recommended large profile",
        "",
        f"- selected_non_target_features: `{', '.join(profile_payload['selected_non_target_features'])}`",
        f"- sequential_axes: `{', '.join(profile_payload['sequential_axes'])}`",
        f"- combinational_axes: `{', '.join(profile_payload['combinational_axes'])}`",
        "",
    ])
    if warnings:
        lines.extend([
            "## Warnings",
            "",
        ])
        for warning in warnings:
            lines.append(f"- {warning}")
        lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Generate deep QD feature-space analysis reports from finished run roots."
    )
    parser.add_argument("--subset-config", required=True, help="Frozen hard-subset YAML config.")
    parser.add_argument(
        "--backend_run",
        action="append",
        required=True,
        metavar="LABEL=PATH",
        help="Backend label and run root pair. May be repeated.",
    )
    parser.add_argument("--output-dir", required=True, help="Directory for analysis outputs.")
    parser.add_argument(
        "--min-profile-features",
        type=int,
        default=7,
        help="Minimum number of non-target features to keep in the recommended profile.",
    )
    return parser


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()

    subset_config = Path(args.subset_config).resolve()
    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    problems = _load_subset_problems(subset_config)
    allowed_problems = set(problems)
    backend_roots: dict[str, Path] = {}
    warnings: list[str] = []
    for item in args.backend_run:
        if "=" not in item:
            raise ValueError(f"Invalid --backend_run '{item}'. Expected LABEL=PATH.")
        label, path_str = item.split("=", 1)
        backend_roots[label] = Path(path_str).resolve()

    backend_problem_metrics: dict[str, dict[tuple[str, str], ProblemMetrics]] = {
        backend: _load_problem_metrics(
            backend,
            root,
            allowed_problems=allowed_problems,
            warnings=warnings,
        )
        for backend, root in backend_roots.items()
    }
    for backend, rows in backend_problem_metrics.items():
        if not rows:
            raise ValueError(
                f"No selected problem summaries found under backend root '{backend_roots[backend]}'."
            )
    backend_aggregates = [
        _aggregate_backend(backend, problems, backend_problem_metrics[backend])
        for backend in backend_roots
    ]

    problem_metric_rows: list[dict[str, Any]] = []
    for backend, metrics in backend_problem_metrics.items():
        for benchmark, problem in problems:
            row = metrics.get((benchmark, problem), _placeholder_metrics(backend, benchmark, problem))
            problem_metric_rows.append(
                {
                    "backend": backend,
                    "benchmark": benchmark,
                    "problem": problem,
                    "functionality_rate": row.functionality_rate,
                    "synthesis_rate": row.synthesis_rate,
                    "best_score": row.best_score,
                    "runtime_seconds": row.runtime_seconds,
                    "qd_archive_type": row.qd_archive_type,
                    "qd_coverage": row.qd_coverage,
                    "qd_score": row.qd_score,
                    "qd_best_quality": row.qd_best_quality,
                }
            )
    _write_csv(
        output_dir / "backend_problem_metrics.csv",
        problem_metric_rows,
        [
            "backend",
            "benchmark",
            "problem",
            "functionality_rate",
            "synthesis_rate",
            "best_score",
            "runtime_seconds",
            "qd_archive_type",
            "qd_coverage",
            "qd_score",
            "qd_best_quality",
        ],
    )

    qd_candidate_rows: list[dict[str, Any]] = []
    for backend, root in backend_roots.items():
        qd_candidate_rows.extend(
            _collect_qd_candidates(
                backend,
                root,
                allowed_problems=allowed_problems,
                warnings=warnings,
            )
        )

    candidate_fieldnames = sorted({key for row in qd_candidate_rows for key in row}) if qd_candidate_rows else []
    if candidate_fieldnames:
        _write_csv(output_dir / "qd_successful_candidates.csv", qd_candidate_rows, candidate_fieldnames)

    qd_feature_cols = _candidate_feature_columns(qd_candidate_rows)
    global_ranges = _global_range_by_feature(qd_candidate_rows, qd_feature_cols)
    per_backend_payloads: dict[str, dict[str, Any]] = {}
    backend_feature_stats: dict[str, list[FeatureStats]] = {}
    for backend in backend_roots:
        backend_rows = [row for row in qd_candidate_rows if row["backend"] == backend]
        if not backend_rows:
            continue
        backend_output_dir = output_dir / "backends" / backend
        feature_stats = [
            _compute_feature_stats(backend_rows, feature, global_ranges)
            for feature in _candidate_feature_columns(backend_rows)
        ]
        backend_feature_stats[backend] = feature_stats
        payload = _per_backend_feature_summary(backend, backend_rows, backend_output_dir, global_ranges)
        per_backend_payloads[backend] = payload
        _write_backend_report(backend_output_dir / "report.md", payload, feature_stats)

    regression_payload: dict[str, Any] = {}
    regression_dir = output_dir / "regression"
    regression_dir.mkdir(parents=True, exist_ok=True)
    regression_features = [feature for feature in qd_feature_cols if feature not in {"g_P", "g_A", "g_T"}]
    for target in TARGET_COLUMNS:
        if target == "g_T":
            eligible_rows = [row for row in qd_candidate_rows if _safe_float(row.get("g_T")) is not None]
            if not eligible_rows:
                continue
        else:
            eligible_rows = list(qd_candidate_rows)
        payload = _run_ridge_regression(eligible_rows, regression_features, target)
        regression_payload[target] = payload
        coeff_rows = payload.get("coefficients", [])
        if coeff_rows:
            _write_csv(
                regression_dir / f"{target}_coefficients.csv",
                coeff_rows,
                ["feature", "coefficient"],
            )

    profile_scores = _profile_feature_scores(qd_candidate_rows, regression_features, backend_feature_stats)
    recommended_profile = _recommended_profile(profile_scores, args.min_profile_features)
    (output_dir / "recommended_profile.json").write_text(
        json.dumps(recommended_profile, indent=2),
        encoding="utf-8",
    )
    if profile_scores:
        _write_csv(
            output_dir / "recommended_profile_scores.csv",
            profile_scores,
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

    summary = {
        "backend_aggregates": backend_aggregates,
        "qd_backends": per_backend_payloads,
        "regression": regression_payload,
        "recommended_profile": recommended_profile,
        "warnings": warnings,
    }
    (output_dir / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    _write_top_report(
        output_dir / "report.md",
        backend_aggregates,
        per_backend_payloads,
        regression_payload,
        recommended_profile,
        warnings,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
