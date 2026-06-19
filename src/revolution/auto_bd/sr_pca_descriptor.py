from __future__ import annotations

import hashlib
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Literal, cast

import numpy as np

from revolution.auto_bd.motif_descriptor import (
    MOTIF_OCCUPANCY_AXES,
    motif_occupancy_descriptor_values,
)
from revolution.auto_bd.netlist_hash import netlist_cell_instances
from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES
from revolution.auto_bd.trajectory_descriptor import (
    STNOD_TRAJECTORY_AXES,
    synthesis_trajectory_descriptor_values,
)

SR_RAW_FEATURE_SCHEMA_VERSION = "synthesis_response_raw_v1"
SR_RAW_PCA_DESCRIPTOR_VERSION = "sr_raw_pca_v1"
SR_RANDOM_RELU_PCA_DESCRIPTOR_VERSION = "sr_random_relu_pca_v1"
SR_RFF_PCA_DESCRIPTOR_VERSION = "sr_rff_pca_v1"
SR_PCA_AXES = ("sr_pca_0", "sr_pca_1", "sr_pca_2", "sr_pca_3", "sr_pca_4")
RandomFeatureKind = Literal["none", "relu", "rff"]


@dataclass(frozen=True)
class SrPcaRandomMap:
    """Frozen random feature map applied after raw-feature standardization."""

    kind: RandomFeatureKind
    seed: int
    feature_count: int
    weights: tuple[tuple[float, ...], ...]
    bias: tuple[float, ...]
    random_feature_map_hash: str


@dataclass(frozen=True)
class SrPcaArtifact:
    """Frozen SR-PCA fitting artifact used to transform raw features."""

    descriptor_version: str
    raw_feature_schema_version: str
    raw_feature_axes: tuple[str, ...]
    constant_feature_axes: tuple[str, ...]
    scaler_mean: tuple[float, ...]
    scaler_std: tuple[float, ...]
    random_map: SrPcaRandomMap
    pca_components: tuple[tuple[float, ...], ...]
    explained_variance_ratio: tuple[float, ...]
    feature_schema_hash: str
    scaler_hash: str
    pca_hash: str
    descriptor_hash: str


def sr_raw_feature_axes() -> tuple[str, ...]:
    """Return the fixed synthesis-response raw feature schema."""

    count_axes = tuple(f"stage_{stage}_cell_count_log" for stage in STNOD_STAGE_NAMES)
    delta_axes = tuple(
        f"delta_{left}_to_{right}_cell_count_log"
        for left, right in zip(STNOD_STAGE_NAMES[:-1], STNOD_STAGE_NAMES[1:], strict=True)
    )
    stage_motif_axes = tuple(
        f"stage_{stage}_{axis}" for stage in STNOD_STAGE_NAMES for axis in MOTIF_OCCUPANCY_AXES
    )
    final_axes = ("final_cell_count_log", *tuple(f"final_{axis}" for axis in MOTIF_OCCUPANCY_AXES))
    return (*final_axes, *STNOD_TRAJECTORY_AXES, *count_axes, *delta_axes, *stage_motif_axes)


def sr_raw_feature_values(
    *,
    final_netlist_text: str,
    stage_verilog_paths: tuple[Path, ...],
) -> dict[str, float]:
    """Extract PPA-free synthesis-response raw features for one candidate."""

    assert len(stage_verilog_paths) == len(STNOD_STAGE_NAMES)
    assert all(path.is_file() for path in stage_verilog_paths)
    values: dict[str, float] = {}
    final_cell_count = len(netlist_cell_instances(final_netlist_text))
    values["final_cell_count_log"] = math.log1p(final_cell_count)
    for axis, value in motif_occupancy_descriptor_values(final_netlist_text).items():
        values[f"final_{axis}"] = value
    values.update(synthesis_trajectory_descriptor_values(stage_verilog_paths))

    count_logs: list[float] = []
    for stage, path in zip(STNOD_STAGE_NAMES, stage_verilog_paths, strict=True):
        text = path.read_text(encoding="utf-8", errors="ignore")
        count_log = math.log1p(len(netlist_cell_instances(text)))
        count_logs.append(count_log)
        values[f"stage_{stage}_cell_count_log"] = count_log
        for axis, value in motif_occupancy_descriptor_values(text).items():
            values[f"stage_{stage}_{axis}"] = value

    for index, (left, right) in enumerate(
        zip(STNOD_STAGE_NAMES[:-1], STNOD_STAGE_NAMES[1:], strict=True)
    ):
        values[f"delta_{left}_to_{right}_cell_count_log"] = count_logs[index + 1] - count_logs[index]

    axes = sr_raw_feature_axes()
    assert set(values) == set(axes)
    return values


def fit_sr_raw_pca_artifact(
    matrix: np.ndarray,
    *,
    dimensions: int,
) -> SrPcaArtifact:
    """Fit a fixed offline PCA artifact over SR raw features."""

    return _fit_sr_pca_artifact(
        matrix,
        dimensions=dimensions,
        descriptor_version=SR_RAW_PCA_DESCRIPTOR_VERSION,
        random_map_kind="none",
        random_feature_count=0,
        random_feature_seed=0,
    )


def fit_sr_random_relu_pca_artifact(
    matrix: np.ndarray,
    *,
    dimensions: int,
    random_feature_count: int,
    random_feature_seed: int,
) -> SrPcaArtifact:
    """Fit fixed random-ReLU PCA over standardized SR raw features."""

    return _fit_sr_pca_artifact(
        matrix,
        dimensions=dimensions,
        descriptor_version=SR_RANDOM_RELU_PCA_DESCRIPTOR_VERSION,
        random_map_kind="relu",
        random_feature_count=random_feature_count,
        random_feature_seed=random_feature_seed,
    )


def fit_sr_rff_pca_artifact(
    matrix: np.ndarray,
    *,
    dimensions: int,
    random_feature_count: int,
    random_feature_seed: int,
) -> SrPcaArtifact:
    """Fit fixed random Fourier feature PCA over standardized SR features."""

    return _fit_sr_pca_artifact(
        matrix,
        dimensions=dimensions,
        descriptor_version=SR_RFF_PCA_DESCRIPTOR_VERSION,
        random_map_kind="rff",
        random_feature_count=random_feature_count,
        random_feature_seed=random_feature_seed,
    )


def _fit_sr_pca_artifact(
    matrix: np.ndarray,
    *,
    dimensions: int,
    descriptor_version: str,
    random_map_kind: RandomFeatureKind,
    random_feature_count: int,
    random_feature_seed: int,
) -> SrPcaArtifact:
    """Fit the shared SR-PCA artifact after optional random features."""

    axes = sr_raw_feature_axes()
    assert matrix.ndim == 2
    assert matrix.shape[0] > dimensions
    assert matrix.shape[1] == len(axes)
    assert 1 <= dimensions <= len(SR_PCA_AXES)
    mean = matrix.mean(axis=0)
    raw_std = matrix.std(axis=0)
    constant_mask = raw_std == 0.0
    std = raw_std.copy()
    std[constant_mask] = 1.0
    z = (matrix - mean) / std
    random_map = _fit_random_map(
        z.shape[1],
        random_map_kind,
        random_feature_count,
        random_feature_seed,
    )
    feature_matrix = _apply_random_map(random_map, z)
    _u, singular_values, vh = np.linalg.svd(feature_matrix, full_matrices=False)
    components = vh[:dimensions].copy()
    for row in components:
        first_nonzero = next((value for value in row if abs(float(value)) > 1e-12), 0.0)
        if first_nonzero < 0:
            row *= -1
    variances = singular_values**2
    total_variance = float(variances.sum())
    assert total_variance > 0.0
    explained = variances[:dimensions] / total_variance
    constant_axes = tuple(axis for axis, is_constant in zip(axes, constant_mask, strict=True) if is_constant)
    return _artifact_from_parts(
        raw_feature_axes=axes,
        constant_feature_axes=constant_axes,
        scaler_mean=tuple(float(value) for value in mean),
        scaler_std=tuple(float(value) for value in std),
        random_map=random_map,
        pca_components=tuple(tuple(float(value) for value in row) for row in components),
        explained_variance_ratio=tuple(float(value) for value in explained),
        descriptor_version=descriptor_version,
    )


def transform_sr_raw_pca(
    artifact: SrPcaArtifact,
    raw_values: dict[str, float],
) -> tuple[float, ...]:
    """Project one raw feature mapping with a frozen SR-PCA artifact."""

    assert tuple(raw_values) or raw_values
    assert tuple(artifact.raw_feature_axes) == sr_raw_feature_axes()
    vector = np.array([raw_values[axis] for axis in artifact.raw_feature_axes], dtype=float)
    mean = np.array(artifact.scaler_mean, dtype=float)
    std = np.array(artifact.scaler_std, dtype=float)
    components = np.array(artifact.pca_components, dtype=float)
    features = _apply_random_map(artifact.random_map, ((vector - mean) / std)[None, :])[0]
    projected = components @ features
    return tuple(float(value) for value in projected)


def sr_pca_artifact_to_json(artifact: SrPcaArtifact) -> dict[str, Any]:
    """Return a JSON-serializable artifact payload."""

    return {
        "descriptor_version": artifact.descriptor_version,
        "raw_feature_schema_version": artifact.raw_feature_schema_version,
        "raw_feature_axes": list(artifact.raw_feature_axes),
        "constant_feature_axes": list(artifact.constant_feature_axes),
        "scaler_mean": list(artifact.scaler_mean),
        "scaler_std": list(artifact.scaler_std),
        "random_feature_map": {
            "kind": artifact.random_map.kind,
            "seed": artifact.random_map.seed,
            "feature_count": artifact.random_map.feature_count,
            "weights": [list(row) for row in artifact.random_map.weights],
            "bias": list(artifact.random_map.bias),
            "random_feature_map_hash": artifact.random_map.random_feature_map_hash,
        },
        "pca_components": [list(row) for row in artifact.pca_components],
        "explained_variance_ratio": list(artifact.explained_variance_ratio),
        "feature_schema_hash": artifact.feature_schema_hash,
        "scaler_hash": artifact.scaler_hash,
        "pca_hash": artifact.pca_hash,
        "descriptor_hash": artifact.descriptor_hash,
    }


def sr_pca_artifact_from_json(payload: dict[str, Any]) -> SrPcaArtifact:
    """Load an SR-PCA artifact payload and verify its self-hashes."""

    random_map = _random_map_from_json(payload.get("random_feature_map"))
    artifact = _artifact_from_parts(
        raw_feature_axes=tuple(str(value) for value in payload["raw_feature_axes"]),
        constant_feature_axes=tuple(str(value) for value in payload["constant_feature_axes"]),
        scaler_mean=tuple(float(value) for value in payload["scaler_mean"]),
        scaler_std=tuple(float(value) for value in payload["scaler_std"]),
        random_map=random_map,
        pca_components=tuple(tuple(float(value) for value in row) for row in payload["pca_components"]),
        explained_variance_ratio=tuple(float(value) for value in payload["explained_variance_ratio"]),
        descriptor_version=str(payload["descriptor_version"]),
    )
    assert artifact.feature_schema_hash == payload["feature_schema_hash"]
    assert artifact.scaler_hash == payload["scaler_hash"]
    assert artifact.pca_hash == payload["pca_hash"]
    assert artifact.descriptor_hash == payload["descriptor_hash"]
    return artifact


def hash_json_payload(payload: dict[str, Any]) -> str:
    """Hash a JSON payload with stable key ordering and compact separators."""

    text = json.dumps(payload, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def _artifact_from_parts(
    *,
    raw_feature_axes: tuple[str, ...],
    constant_feature_axes: tuple[str, ...],
    scaler_mean: tuple[float, ...],
    scaler_std: tuple[float, ...],
    random_map: SrPcaRandomMap,
    pca_components: tuple[tuple[float, ...], ...],
    explained_variance_ratio: tuple[float, ...],
    descriptor_version: str,
) -> SrPcaArtifact:
    assert raw_feature_axes == sr_raw_feature_axes()
    assert len(scaler_mean) == len(raw_feature_axes)
    assert len(scaler_std) == len(raw_feature_axes)
    assert all(value > 0.0 for value in scaler_std)
    assert pca_components
    feature_width = len(raw_feature_axes) if random_map.kind == "none" else random_map.feature_count
    assert all(len(row) == feature_width for row in pca_components)
    if descriptor_version == SR_RAW_PCA_DESCRIPTOR_VERSION:
        assert random_map.kind == "none"
    elif descriptor_version == SR_RANDOM_RELU_PCA_DESCRIPTOR_VERSION:
        assert random_map.kind == "relu"
    elif descriptor_version == SR_RFF_PCA_DESCRIPTOR_VERSION:
        assert random_map.kind == "rff"
    else:
        raise AssertionError(f"unknown SR-PCA descriptor version: {descriptor_version}")
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
    pca_hash_payload = {
        "scaler_hash": scaler_hash,
        "pca_components": [list(row) for row in pca_components],
        "explained_variance_ratio": list(explained_variance_ratio),
    }
    if descriptor_version != SR_RAW_PCA_DESCRIPTOR_VERSION:
        pca_hash_payload["random_feature_map_hash"] = random_map.random_feature_map_hash
    pca_hash = hash_json_payload(pca_hash_payload)
    descriptor_hash = hash_json_payload(
        {
            "descriptor_version": descriptor_version,
            "pca_hash": pca_hash,
        }
    )
    return SrPcaArtifact(
        descriptor_version=descriptor_version,
        raw_feature_schema_version=SR_RAW_FEATURE_SCHEMA_VERSION,
        raw_feature_axes=raw_feature_axes,
        constant_feature_axes=constant_feature_axes,
        scaler_mean=scaler_mean,
        scaler_std=scaler_std,
        random_map=random_map,
        pca_components=pca_components,
        explained_variance_ratio=explained_variance_ratio,
        feature_schema_hash=feature_schema_hash,
        scaler_hash=scaler_hash,
        pca_hash=pca_hash,
        descriptor_hash=descriptor_hash,
    )


def _fit_random_map(
    raw_width: int,
    kind: RandomFeatureKind,
    feature_count: int,
    seed: int,
) -> SrPcaRandomMap:
    if kind == "none":
        assert feature_count == 0
        return _none_random_map()
    if kind == "relu":
        assert feature_count > 0
        rng = np.random.default_rng(seed)
        scale = 1.0 / math.sqrt(raw_width)
        weights = rng.normal(0.0, scale, size=(feature_count, raw_width))
        bias = rng.normal(0.0, 1.0, size=feature_count)
        return _random_map_from_parts(
            kind="relu",
            seed=seed,
            feature_count=feature_count,
            weights=tuple(tuple(float(value) for value in row) for row in weights),
            bias=tuple(float(value) for value in bias),
        )
    if kind == "rff":
        assert feature_count > 0
        rng = np.random.default_rng(seed)
        weights = rng.normal(0.0, 1.0, size=(feature_count, raw_width))
        bias = rng.uniform(0.0, 2.0 * math.pi, size=feature_count)
        return _random_map_from_parts(
            kind="rff",
            seed=seed,
            feature_count=feature_count,
            weights=tuple(tuple(float(value) for value in row) for row in weights),
            bias=tuple(float(value) for value in bias),
        )
    raise AssertionError(f"unknown random feature kind: {kind}")


def _apply_random_map(random_map: SrPcaRandomMap, matrix: np.ndarray) -> np.ndarray:
    if random_map.kind == "none":
        return matrix
    if random_map.kind == "relu":
        weights = np.array(random_map.weights, dtype=float)
        bias = np.array(random_map.bias, dtype=float)
        return np.maximum(matrix @ weights.T + bias, 0.0)
    if random_map.kind == "rff":
        weights = np.array(random_map.weights, dtype=float)
        bias = np.array(random_map.bias, dtype=float)
        scale = math.sqrt(2.0 / random_map.feature_count)
        return scale * np.cos(matrix @ weights.T + bias)
    raise AssertionError(f"unknown random feature kind: {random_map.kind}")


def _random_map_from_json(payload: object) -> SrPcaRandomMap:
    if payload is None:
        return _none_random_map()
    assert isinstance(payload, dict)
    payload_dict = cast(dict[str, Any], payload)
    random_map = _random_map_from_parts(
        kind=str(payload_dict["kind"]),
        seed=int(payload_dict["seed"]),
        feature_count=int(payload_dict["feature_count"]),
        weights=tuple(tuple(float(value) for value in row) for row in payload_dict["weights"]),
        bias=tuple(float(value) for value in payload_dict["bias"]),
    )
    assert random_map.random_feature_map_hash == payload_dict["random_feature_map_hash"]
    return random_map


def _none_random_map() -> SrPcaRandomMap:
    return _random_map_from_parts(
        kind="none",
        seed=0,
        feature_count=0,
        weights=(),
        bias=(),
    )


def _random_map_from_parts(
    *,
    kind: str,
    seed: int,
    feature_count: int,
    weights: tuple[tuple[float, ...], ...],
    bias: tuple[float, ...],
) -> SrPcaRandomMap:
    if kind == "none":
        assert seed == 0
        assert feature_count == 0
        assert not weights
        assert not bias
    elif kind in {"relu", "rff"}:
        assert feature_count > 0
        assert len(weights) == feature_count
        assert len(bias) == feature_count
        assert len({len(row) for row in weights}) == 1
    else:
        raise AssertionError(f"unknown random feature kind: {kind}")
    typed_kind = _typed_random_feature_kind(kind)
    random_feature_map_hash = hash_json_payload(
        {
            "kind": typed_kind,
            "seed": seed,
            "feature_count": feature_count,
            "weights": [list(row) for row in weights],
            "bias": list(bias),
        }
    )
    return SrPcaRandomMap(
        kind=typed_kind,
        seed=seed,
        feature_count=feature_count,
        weights=weights,
        bias=bias,
        random_feature_map_hash=random_feature_map_hash,
    )


def _typed_random_feature_kind(kind: str) -> RandomFeatureKind:
    if kind == "none":
        return "none"
    if kind == "relu":
        return "relu"
    if kind == "rff":
        return "rff"
    raise AssertionError(f"unknown random feature kind: {kind}")
