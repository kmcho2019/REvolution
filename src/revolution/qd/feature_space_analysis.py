"""Shared helpers for retrospective feature-space reporting.

The reporting scripts use this module to keep feature selection,
descriptive statistics, and lightweight embeddings in one place. The
helpers intentionally favor plain dictionaries and small functions so the
report scripts can stay easy to skim.
"""

from __future__ import annotations

import math
import statistics
from dataclasses import dataclass
from typing import Any

import numpy as np
from scipy.stats import spearmanr

from revolution.qd.descriptors import load_descriptor_profiles


TARGET_COLUMNS = ("quality_score", "g_P", "g_A", "g_T")
RIDGE_ALPHAS = [0.01, 0.1, 1.0, 10.0, 100.0]


@dataclass(frozen=True)
class FeatureStats:
    """Compact summary of how one feature behaves across a candidate set."""

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


@dataclass(frozen=True)
class EmbeddingFit:
    """A fitted 2D embedding that can be reused across plot subsets."""

    method: str
    requested_features: tuple[str, ...]
    usable_features: tuple[str, ...]
    points: tuple[tuple[float, float], ...]
    x_label: str
    y_label: str
    x_limits: tuple[float, float]
    y_limits: tuple[float, float]
    color_limits: tuple[float, float]
    note: str | None


def safe_float(value: Any) -> float | None:
    """Return a finite float or ``None`` for missing / invalid values."""

    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def candidate_feature_columns(
    rows: list[dict[str, Any]],
    *,
    excluded: set[str] | None = None,
) -> list[str]:
    """Collect numeric candidate columns that can be treated as features."""

    excluded_keys = set(excluded or set())
    cols: set[str] = set()
    for row in rows:
        for key, value in row.items():
            if key in excluded_keys or key in TARGET_COLUMNS:
                continue
            if isinstance(value, bool):
                continue
            if isinstance(value, (int, float)) and math.isfinite(float(value)):
                cols.add(key)
    return sorted(cols)


def values_for_feature(rows: list[dict[str, Any]], feature: str) -> list[float]:
    """Return all finite values for one feature across the provided rows."""

    values: list[float] = []
    for row in rows:
        parsed = safe_float(row.get(feature))
        if parsed is not None:
            values.append(parsed)
    return values


def global_range_by_feature(
    rows: list[dict[str, Any]],
    features: list[str],
) -> dict[str, float]:
    """Measure each feature's global min-to-max span across all rows."""

    ranges: dict[str, float] = {}
    for feature in features:
        values = values_for_feature(rows, feature)
        ranges[feature] = (max(values) - min(values)) if values else 0.0
    return ranges


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


def compute_feature_stats(
    rows: list[dict[str, Any]],
    feature: str,
    global_ranges: dict[str, float],
) -> FeatureStats:
    """Summarize feature coverage, spread, and collapse indicators."""

    total_count = len(rows)
    values = values_for_feature(rows, feature)
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
    global_range = global_ranges.get(feature, 0.0)
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


def stats_rows(stats_by_feature: list[FeatureStats]) -> list[dict[str, Any]]:
    """Convert ``FeatureStats`` objects into CSV-friendly dictionaries."""

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


def embedding_feature_matrix(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
) -> tuple[list[str], list[list[float]]]:
    """Build an embedding matrix with median fill for sparse-but-usable columns."""

    usable_cols: list[str] = []
    matrix_by_col: dict[str, list[float]] = {}
    for feature in feature_cols:
        values = [safe_float(row.get(feature)) for row in rows]
        finite_values = [value for value in values if value is not None]
        if len(finite_values) < max(3, math.ceil(0.9 * len(rows))):
            continue
        median = statistics.median(finite_values)
        matrix_by_col[feature] = [value if value is not None else median for value in values]
        usable_cols.append(feature)
    matrix = [[matrix_by_col[col][index] for col in usable_cols] for index in range(len(rows))]
    return usable_cols, matrix


def standardize_matrix(matrix: list[list[float]]) -> np.ndarray:
    """Standardize a dense feature matrix column-wise."""

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
    sample_count = x.shape[0]
    conditional = np.zeros((sample_count, sample_count), dtype=float)
    target_entropy = math.log(perplexity)
    for index in range(sample_count):
        mask = np.ones(sample_count, dtype=bool)
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
    sym = (conditional + conditional.T) / (2.0 * sample_count)
    sym = np.maximum(sym, 1e-12)
    return sym / np.sum(sym)


def tsne_embedding(x: np.ndarray, *, perplexity: float, max_iter: int = 500) -> np.ndarray:
    """Run a small deterministic t-SNE implementation for 2D visualization."""

    sample_count = x.shape[0]
    if sample_count < 3:
        raise ValueError("t-SNE requires at least 3 samples.")
    p = _tsne_probabilities(x, perplexity=perplexity)
    p *= 4.0
    rng = np.random.default_rng(42)
    y = rng.normal(loc=0.0, scale=1e-4, size=(sample_count, 2))
    velocity = np.zeros_like(y)
    learning_rate = max(50.0, sample_count / 12.0)
    for iteration in range(max_iter):
        distances = _pairwise_squared_distances(y)
        inv = 1.0 / (1.0 + distances)
        np.fill_diagonal(inv, 0.0)
        q = inv / np.maximum(np.sum(inv), 1e-12)
        grad = np.zeros_like(y)
        pq = p - q
        for index in range(sample_count):
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


def _axis_limits(values: list[float]) -> tuple[float, float]:
    if not values:
        return 0.0, 1.0
    low = min(values)
    high = max(values)
    if math.isclose(low, high):
        pad = max(abs(low) * 0.05, 1.0)
        return low - pad, high + pad
    pad = (high - low) * 0.05
    return low - pad, high + pad


def _color_limits(rows: list[dict[str, Any]]) -> tuple[float, float]:
    values = [parsed for row in rows if (parsed := safe_float(row.get("color_score"))) is not None]
    if not values:
        return 0.0, 1.0
    low = min(values)
    high = max(values)
    if math.isclose(low, high):
        high = low + 1.0
    return low, high


def _embedding_axis_labels(method: str) -> tuple[str, str]:
    if method == "pca":
        return "PC1", "PC2"
    if method == "tsne":
        return "t-SNE 1", "t-SNE 2"
    return "Component 1", "Component 2"


def fit_embedding_model(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    *,
    method: str,
) -> EmbeddingFit:
    """Fit one shared embedding that can be reused by many subset plots."""

    if len(rows) < 3:
        return EmbeddingFit(
            method=method,
            requested_features=tuple(feature_cols),
            usable_features=(),
            points=(),
            x_label=_embedding_axis_labels(method)[0],
            y_label=_embedding_axis_labels(method)[1],
            x_limits=(0.0, 1.0),
            y_limits=(0.0, 1.0),
            color_limits=_color_limits(rows),
            note="too_few_successes",
        )
    usable_cols, matrix = embedding_feature_matrix(rows, feature_cols)
    axis_labels = _embedding_axis_labels(method)
    if len(usable_cols) < 2:
        return EmbeddingFit(
            method=method,
            requested_features=tuple(feature_cols),
            usable_features=tuple(usable_cols),
            points=(),
            x_label=axis_labels[0],
            y_label=axis_labels[1],
            x_limits=(0.0, 1.0),
            y_limits=(0.0, 1.0),
            color_limits=_color_limits(rows),
            note="too_few_varying_features",
        )
    x_scaled = standardize_matrix(matrix)
    note: str | None = None
    if method == "pca":
        _, _, vt = np.linalg.svd(x_scaled, full_matrices=False)
        points_array = x_scaled.dot(vt[:2].T)
    elif method == "tsne":
        if len(rows) < 6:
            note = "too_few_successes"
            points_array = np.empty((0, 2), dtype=float)
        else:
            perplexity = min(30, max(5, (len(rows) - 1) // 3))
            if perplexity >= len(rows):
                note = "invalid_perplexity_for_sample_count"
                points_array = np.empty((0, 2), dtype=float)
            else:
                points_array = tsne_embedding(x_scaled, perplexity=perplexity, max_iter=500)
    else:
        raise ValueError(f"Unsupported embedding method: {method}")
    if note is not None:
        return EmbeddingFit(
            method=method,
            requested_features=tuple(feature_cols),
            usable_features=tuple(usable_cols),
            points=(),
            x_label=axis_labels[0],
            y_label=axis_labels[1],
            x_limits=(0.0, 1.0),
            y_limits=(0.0, 1.0),
            color_limits=_color_limits(rows),
            note=note,
        )
    points = tuple((float(point[0]), float(point[1])) for point in points_array)
    x_limits = _axis_limits([point[0] for point in points])
    y_limits = _axis_limits([point[1] for point in points])
    return EmbeddingFit(
        method=method,
        requested_features=tuple(feature_cols),
        usable_features=tuple(usable_cols),
        points=points,
        x_label=axis_labels[0],
        y_label=axis_labels[1],
        x_limits=x_limits,
        y_limits=y_limits,
        color_limits=_color_limits(rows),
        note=None,
    )


def fit_embedding(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    *,
    method: str,
) -> dict[str, Any]:
    """Project candidate rows into a shared 2D embedding space."""

    fit = fit_embedding_model(rows, feature_cols, method=method)
    if fit.note is not None:
        return {
            "usable_features": list(fit.usable_features),
            "points": None,
            "note": fit.note,
        }
    return {
        "usable_features": list(fit.usable_features),
        "points": list(fit.points),
        "note": None,
    }


def spearman_feature_map(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    target: str,
) -> dict[str, float | None]:
    """Estimate per-feature monotonic association against one target."""

    correlations: dict[str, float | None] = {}
    target_values = [safe_float(row.get(target)) for row in rows]
    for feature in feature_cols:
        feature_values = [safe_float(row.get(feature)) for row in rows]
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
        if len({round(value, 12) for value in left}) <= 1:
            correlations[feature] = None
            continue
        if len({round(value, 12) for value in right}) <= 1:
            correlations[feature] = None
            continue
        corr_result: Any = spearmanr(left, right)
        corr = corr_result.correlation
        correlations[feature] = float(corr) if corr is not None and math.isfinite(float(corr)) else None
    return correlations


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


def run_ridge_regression(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    target: str,
) -> dict[str, Any]:
    """Fit a simple ridge baseline to explain one target from selected features."""

    usable_rows = [row for row in rows if safe_float(row.get(target)) is not None]
    if len(usable_rows) < 4 or not feature_cols:
        return {
            "target": target,
            "sample_count": len(usable_rows),
            "r2": None,
            "alpha": None,
            "coefficients": [],
        }
    usable_cols, matrix = embedding_feature_matrix(usable_rows, feature_cols)
    if not usable_cols:
        return {
            "target": target,
            "sample_count": len(usable_rows),
            "r2": None,
            "alpha": None,
            "coefficients": [],
        }
    y = [safe_float(row.get(target)) or 0.0 for row in usable_rows]
    x_scaled = standardize_matrix(matrix)
    y_array = np.asarray(y, dtype=float)
    y_mean = float(np.mean(y_array))
    y_std = float(np.std(y_array))
    if y_std == 0.0:
        return {
            "target": target,
            "sample_count": len(usable_rows),
            "r2": None,
            "alpha": None,
            "coefficients": [],
        }
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


def profile_feature_scores(
    rows: list[dict[str, Any]],
    feature_cols: list[str],
    backend_feature_stats: dict[str, list[FeatureStats]],
) -> list[dict[str, Any]]:
    """Rank candidate features by predictive value and diversity robustness."""

    global_ranges = global_range_by_feature(rows, feature_cols)
    global_stats = {
        feature: compute_feature_stats(rows, feature, global_ranges)
        for feature in feature_cols
    }
    scores: list[dict[str, Any]] = []
    targets = [
        target
        for target in TARGET_COLUMNS
        if target == "quality_score" or any(safe_float(row.get(target)) is not None for row in rows)
    ]
    per_target_corr = {
        target: spearman_feature_map(rows, feature_cols, target)
        for target in targets
    }
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
        eligible = True
        if stats.finite_fraction < 0.9:
            eligible = False
        if stats.collapsed:
            eligible = False
        if collapsed_in_backends >= 2:
            eligible = False
        predictive = max(
            [
                abs(corr)
                for corr in (
                    per_target_corr[target].get(feature)
                    for target in targets
                )
                if corr is not None
            ]
            or [0.0]
        )
        diversity = statistics.fmean(
            [
                stats.normalized_range_coverage,
                min(
                    1.0,
                    (stats.stddev_value or 0.0)
                    / max(abs(stats.mean_value or 0.0), 1e-6),
                ),
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


def recommended_profile(
    scores: list[dict[str, Any]],
    *,
    min_features: int,
    selection_mode: str = "auto",
    profile_name: str | None = None,
) -> dict[str, Any]:
    """Build a profile payload from ranked feature scores."""

    selected = [row["feature"] for row in scores if row.get("eligible")][:min_features]
    sequential_axes = list(selected) + ["g_P", "g_A", "g_T"]
    combinational_axes = [axis for axis in sequential_axes if axis != "g_T"]
    return {
        "selection_mode": selection_mode,
        "feature_profile": profile_name,
        "selected_non_target_features": selected,
        "sequential_axes": sequential_axes,
        "combinational_axes": combinational_axes,
        "feature_scores": scores,
    }


def explicit_profile(
    features: list[str],
    *,
    selection_mode: str,
    profile_name: str | None = None,
) -> dict[str, Any]:
    """Build a profile payload from an explicit feature list."""

    selected = [feature for feature in features if feature not in {"g_P", "g_A", "g_T"}]
    sequential_axes = list(selected) + ["g_P", "g_A", "g_T"]
    combinational_axes = [axis for axis in sequential_axes if axis != "g_T"]
    return {
        "selection_mode": selection_mode,
        "feature_profile": profile_name,
        "selected_non_target_features": selected,
        "sequential_axes": sequential_axes,
        "combinational_axes": combinational_axes,
        "feature_scores": [],
    }


def profile_features_from_config(
    *,
    profile_name: str,
    descriptor_file: str | None = None,
) -> list[str]:
    """Load a named descriptor profile from the descriptor config surface."""

    profiles = load_descriptor_profiles(descriptor_file)
    if profile_name not in profiles:
        raise ValueError(f"Unknown feature profile: {profile_name}")
    return list(profiles[profile_name])
