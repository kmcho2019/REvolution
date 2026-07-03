from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import numpy as np

from revolution.auto_bd.sr_pca_descriptor import (
    SR_RAW_FEATURE_SCHEMA_VERSION,
    hash_json_payload,
    sr_raw_feature_axes,
)

SR_VQ_DESCRIPTOR_VERSION = "sr_vq_codebook_v1"
SR_VQ_AXES = ("sr_vq_0", "sr_vq_1", "sr_vq_2", "sr_vq_3", "sr_vq_4")


@dataclass(frozen=True)
class SrVqArtifact:
    """Frozen synthesis-response VQ codebook descriptor artifact."""

    descriptor_version: str
    raw_feature_schema_version: str
    raw_feature_axes: tuple[str, ...]
    constant_feature_axes: tuple[str, ...]
    scaler_mean: tuple[float, ...]
    scaler_std: tuple[float, ...]
    codebook_size: int
    kmeans_seed: int
    kmeans_iterations: int
    codebook_centroids: tuple[tuple[float, ...], ...]
    centroid_layout: tuple[tuple[float, ...], ...]
    cluster_counts: tuple[int, ...]
    cluster_labels: tuple[tuple[str, ...], ...]
    feature_schema_hash: str
    scaler_hash: str
    codebook_hash: str
    layout_hash: str
    descriptor_hash: str


def fit_sr_vq_artifact(
    matrix: np.ndarray,
    *,
    codebook_size: int,
    dimensions: int,
    kmeans_seed: int,
    kmeans_iterations: int,
) -> SrVqArtifact:
    """Fit a fixed offline VQ codebook over synthesis-response features."""

    axes = sr_raw_feature_axes()
    assert matrix.ndim == 2
    assert matrix.shape[1] == len(axes)
    assert 2 <= codebook_size <= matrix.shape[0]
    assert 1 <= dimensions <= len(SR_VQ_AXES)
    assert kmeans_iterations > 0
    mean = matrix.mean(axis=0)
    raw_std = matrix.std(axis=0)
    constant_mask = raw_std == 0.0
    std = raw_std.copy()
    std[constant_mask] = 1.0
    z = (matrix - mean) / std
    centroids = _fit_kmeans(z, codebook_size, kmeans_seed, kmeans_iterations)
    assignments = _nearest_centroid_indices(z, centroids)
    layout = _centroid_layout(centroids, dimensions)
    return _artifact_from_parts(
        raw_feature_axes=axes,
        constant_feature_axes=tuple(
            axis for axis, is_constant in zip(axes, constant_mask, strict=True) if is_constant
        ),
        scaler_mean=tuple(float(value) for value in mean),
        scaler_std=tuple(float(value) for value in std),
        codebook_size=codebook_size,
        kmeans_seed=kmeans_seed,
        kmeans_iterations=kmeans_iterations,
        codebook_centroids=tuple(tuple(float(value) for value in row) for row in centroids),
        centroid_layout=tuple(tuple(float(value) for value in row) for row in layout),
        cluster_counts=tuple(int(np.count_nonzero(assignments == index)) for index in range(codebook_size)),
        cluster_labels=tuple(_cluster_labels(axes, centroids[index]) for index in range(codebook_size)),
    )


def transform_sr_vq(
    artifact: SrVqArtifact,
    raw_values: dict[str, float],
) -> tuple[float, ...]:
    """Assign one raw synthesis-response vector to a frozen VQ centroid."""

    assert artifact.raw_feature_axes == sr_raw_feature_axes()
    vector = np.array([raw_values[axis] for axis in artifact.raw_feature_axes], dtype=float)
    mean = np.array(artifact.scaler_mean, dtype=float)
    std = np.array(artifact.scaler_std, dtype=float)
    centroids = np.array(artifact.codebook_centroids, dtype=float)
    centroid_index = int(_nearest_centroid_indices(((vector - mean) / std)[None, :], centroids)[0])
    return artifact.centroid_layout[centroid_index]


def sr_vq_artifact_to_json(artifact: SrVqArtifact) -> dict[str, Any]:
    """Return a JSON-serializable VQ artifact payload."""

    return {
        "descriptor_version": artifact.descriptor_version,
        "raw_feature_schema_version": artifact.raw_feature_schema_version,
        "raw_feature_axes": list(artifact.raw_feature_axes),
        "constant_feature_axes": list(artifact.constant_feature_axes),
        "scaler_mean": list(artifact.scaler_mean),
        "scaler_std": list(artifact.scaler_std),
        "codebook_size": artifact.codebook_size,
        "kmeans_seed": artifact.kmeans_seed,
        "kmeans_iterations": artifact.kmeans_iterations,
        "codebook_centroids": [list(row) for row in artifact.codebook_centroids],
        "centroid_layout": [list(row) for row in artifact.centroid_layout],
        "cluster_counts": list(artifact.cluster_counts),
        "cluster_labels": [list(row) for row in artifact.cluster_labels],
        "feature_schema_hash": artifact.feature_schema_hash,
        "scaler_hash": artifact.scaler_hash,
        "codebook_hash": artifact.codebook_hash,
        "layout_hash": artifact.layout_hash,
        "descriptor_hash": artifact.descriptor_hash,
    }


def sr_vq_artifact_from_json(payload: dict[str, Any]) -> SrVqArtifact:
    """Load and self-verify a frozen VQ artifact payload."""

    artifact = _artifact_from_parts(
        raw_feature_axes=tuple(str(value) for value in payload["raw_feature_axes"]),
        constant_feature_axes=tuple(str(value) for value in payload["constant_feature_axes"]),
        scaler_mean=tuple(float(value) for value in payload["scaler_mean"]),
        scaler_std=tuple(float(value) for value in payload["scaler_std"]),
        codebook_size=int(payload["codebook_size"]),
        kmeans_seed=int(payload["kmeans_seed"]),
        kmeans_iterations=int(payload["kmeans_iterations"]),
        codebook_centroids=tuple(tuple(float(value) for value in row) for row in payload["codebook_centroids"]),
        centroid_layout=tuple(tuple(float(value) for value in row) for row in payload["centroid_layout"]),
        cluster_counts=tuple(int(value) for value in payload["cluster_counts"]),
        cluster_labels=tuple(tuple(str(value) for value in row) for row in payload["cluster_labels"]),
    )
    assert artifact.feature_schema_hash == payload["feature_schema_hash"]
    assert artifact.scaler_hash == payload["scaler_hash"]
    assert artifact.codebook_hash == payload["codebook_hash"]
    assert artifact.layout_hash == payload["layout_hash"]
    assert artifact.descriptor_hash == payload["descriptor_hash"]
    return artifact


def _fit_kmeans(
    matrix: np.ndarray,
    codebook_size: int,
    seed: int,
    iterations: int,
) -> np.ndarray:
    centroids = _initial_centroids(matrix, codebook_size, seed)
    for _ in range(iterations):
        assignments = _nearest_centroid_indices(matrix, centroids)
        updated = centroids.copy()
        for index in range(codebook_size):
            members = matrix[assignments == index]
            if len(members):
                updated[index] = members.mean(axis=0)
        if np.allclose(updated, centroids):
            return updated
        centroids = updated
    return centroids


def _initial_centroids(matrix: np.ndarray, codebook_size: int, seed: int) -> np.ndarray:
    rng = np.random.default_rng(seed)
    selected = [int(rng.integers(0, matrix.shape[0]))]
    while len(selected) < codebook_size:
        distances = np.min(_squared_distances(matrix, matrix[selected]), axis=1)
        selected.append(int(np.argmax(distances)))
    return matrix[selected].copy()


def _nearest_centroid_indices(matrix: np.ndarray, centroids: np.ndarray) -> np.ndarray:
    return np.argmin(_squared_distances(matrix, centroids), axis=1)


def _squared_distances(matrix: np.ndarray, centroids: np.ndarray) -> np.ndarray:
    delta = matrix[:, None, :] - centroids[None, :, :]
    return np.sum(delta * delta, axis=2)


def _centroid_layout(centroids: np.ndarray, dimensions: int) -> np.ndarray:
    centered = centroids - centroids.mean(axis=0)
    _u, _singular_values, vh = np.linalg.svd(centered, full_matrices=False)
    components = vh[:dimensions].copy()
    for row in components:
        first_nonzero = next((value for value in row if abs(float(value)) > 1e-12), 0.0)
        if first_nonzero < 0:
            row *= -1
    layout = centered @ components.T
    if layout.shape[1] == dimensions:
        return layout
    padded = np.zeros((layout.shape[0], dimensions), dtype=float)
    padded[:, : layout.shape[1]] = layout
    return padded


def _cluster_labels(axes: tuple[str, ...], centroid: np.ndarray) -> tuple[str, ...]:
    order = np.argsort(-np.abs(centroid))
    return tuple(axes[int(index)] for index in order[:5])


def _artifact_from_parts(
    *,
    raw_feature_axes: tuple[str, ...],
    constant_feature_axes: tuple[str, ...],
    scaler_mean: tuple[float, ...],
    scaler_std: tuple[float, ...],
    codebook_size: int,
    kmeans_seed: int,
    kmeans_iterations: int,
    codebook_centroids: tuple[tuple[float, ...], ...],
    centroid_layout: tuple[tuple[float, ...], ...],
    cluster_counts: tuple[int, ...],
    cluster_labels: tuple[tuple[str, ...], ...],
) -> SrVqArtifact:
    assert raw_feature_axes == sr_raw_feature_axes()
    assert len(scaler_mean) == len(raw_feature_axes)
    assert len(scaler_std) == len(raw_feature_axes)
    assert all(value > 0.0 for value in scaler_std)
    assert codebook_size == len(codebook_centroids) == len(centroid_layout)
    assert codebook_size == len(cluster_counts) == len(cluster_labels)
    assert all(len(row) == len(raw_feature_axes) for row in codebook_centroids)
    assert len({len(row) for row in centroid_layout}) == 1
    feature_schema_hash = hash_json_payload(
        {
            "raw_feature_schema_version": SR_RAW_FEATURE_SCHEMA_VERSION,
            "raw_feature_axes": list(raw_feature_axes),
        }
    )
    scaler_hash = hash_json_payload(
        {
            "feature_schema_hash": feature_schema_hash,
            "scaler_mean": list(scaler_mean),
            "scaler_std": list(scaler_std),
            "constant_feature_axes": list(constant_feature_axes),
        }
    )
    codebook_hash = hash_json_payload(
        {
            "scaler_hash": scaler_hash,
            "codebook_size": codebook_size,
            "kmeans_seed": kmeans_seed,
            "kmeans_iterations": kmeans_iterations,
            "codebook_centroids": [list(row) for row in codebook_centroids],
            "cluster_counts": list(cluster_counts),
            "cluster_labels": [list(row) for row in cluster_labels],
        }
    )
    layout_hash = hash_json_payload(
        {
            "codebook_hash": codebook_hash,
            "centroid_layout": [list(row) for row in centroid_layout],
        }
    )
    descriptor_hash = hash_json_payload(
        {
            "descriptor_version": SR_VQ_DESCRIPTOR_VERSION,
            "layout_hash": layout_hash,
        }
    )
    return SrVqArtifact(
        descriptor_version=SR_VQ_DESCRIPTOR_VERSION,
        raw_feature_schema_version=SR_RAW_FEATURE_SCHEMA_VERSION,
        raw_feature_axes=raw_feature_axes,
        constant_feature_axes=constant_feature_axes,
        scaler_mean=scaler_mean,
        scaler_std=scaler_std,
        codebook_size=codebook_size,
        kmeans_seed=kmeans_seed,
        kmeans_iterations=kmeans_iterations,
        codebook_centroids=codebook_centroids,
        centroid_layout=centroid_layout,
        cluster_counts=cluster_counts,
        cluster_labels=cluster_labels,
        feature_schema_hash=feature_schema_hash,
        scaler_hash=scaler_hash,
        codebook_hash=codebook_hash,
        layout_hash=layout_hash,
        descriptor_hash=descriptor_hash,
    )
