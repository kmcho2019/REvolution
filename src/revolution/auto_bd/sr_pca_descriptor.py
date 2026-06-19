from __future__ import annotations

import hashlib
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any

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
SR_PCA_AXES = ("sr_pca_0", "sr_pca_1", "sr_pca_2", "sr_pca_3", "sr_pca_4")


@dataclass(frozen=True)
class SrPcaArtifact:
    """Frozen SR-PCA fitting artifact used to transform raw features."""

    descriptor_version: str
    raw_feature_schema_version: str
    raw_feature_axes: tuple[str, ...]
    constant_feature_axes: tuple[str, ...]
    scaler_mean: tuple[float, ...]
    scaler_std: tuple[float, ...]
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
    _u, singular_values, vh = np.linalg.svd(z, full_matrices=False)
    components = vh[:dimensions].copy()
    for row in components:
        first_nonzero = next((value for value in row if abs(float(value)) > 1e-12), 0.0)
        if first_nonzero < 0:
            row *= -1
    variances = singular_values**2
    total_variance = float(variances.sum())
    explained = variances[:dimensions] / total_variance
    constant_axes = tuple(axis for axis, is_constant in zip(axes, constant_mask, strict=True) if is_constant)
    return _artifact_from_parts(
        raw_feature_axes=axes,
        constant_feature_axes=constant_axes,
        scaler_mean=tuple(float(value) for value in mean),
        scaler_std=tuple(float(value) for value in std),
        pca_components=tuple(tuple(float(value) for value in row) for row in components),
        explained_variance_ratio=tuple(float(value) for value in explained),
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
    projected = components @ ((vector - mean) / std)
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
        "pca_components": [list(row) for row in artifact.pca_components],
        "explained_variance_ratio": list(artifact.explained_variance_ratio),
        "feature_schema_hash": artifact.feature_schema_hash,
        "scaler_hash": artifact.scaler_hash,
        "pca_hash": artifact.pca_hash,
        "descriptor_hash": artifact.descriptor_hash,
    }


def sr_pca_artifact_from_json(payload: dict[str, Any]) -> SrPcaArtifact:
    """Load an SR-PCA artifact payload and verify its self-hashes."""

    artifact = _artifact_from_parts(
        raw_feature_axes=tuple(str(value) for value in payload["raw_feature_axes"]),
        constant_feature_axes=tuple(str(value) for value in payload["constant_feature_axes"]),
        scaler_mean=tuple(float(value) for value in payload["scaler_mean"]),
        scaler_std=tuple(float(value) for value in payload["scaler_std"]),
        pca_components=tuple(tuple(float(value) for value in row) for row in payload["pca_components"]),
        explained_variance_ratio=tuple(float(value) for value in payload["explained_variance_ratio"]),
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
    pca_components: tuple[tuple[float, ...], ...],
    explained_variance_ratio: tuple[float, ...],
) -> SrPcaArtifact:
    assert raw_feature_axes == sr_raw_feature_axes()
    assert len(scaler_mean) == len(raw_feature_axes)
    assert len(scaler_std) == len(raw_feature_axes)
    assert all(value > 0.0 for value in scaler_std)
    assert pca_components
    assert all(len(row) == len(raw_feature_axes) for row in pca_components)
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
    pca_hash = hash_json_payload(
        {
            "scaler_hash": scaler_hash,
            "pca_components": [list(row) for row in pca_components],
            "explained_variance_ratio": list(explained_variance_ratio),
        }
    )
    descriptor_hash = hash_json_payload(
        {
            "descriptor_version": SR_RAW_PCA_DESCRIPTOR_VERSION,
            "pca_hash": pca_hash,
        }
    )
    return SrPcaArtifact(
        descriptor_version=SR_RAW_PCA_DESCRIPTOR_VERSION,
        raw_feature_schema_version=SR_RAW_FEATURE_SCHEMA_VERSION,
        raw_feature_axes=raw_feature_axes,
        constant_feature_axes=constant_feature_axes,
        scaler_mean=scaler_mean,
        scaler_std=scaler_std,
        pca_components=pca_components,
        explained_variance_ratio=explained_variance_ratio,
        feature_schema_hash=feature_schema_hash,
        scaler_hash=scaler_hash,
        pca_hash=pca_hash,
        descriptor_hash=descriptor_hash,
    )
