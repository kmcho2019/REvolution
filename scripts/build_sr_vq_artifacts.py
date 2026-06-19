#!/usr/bin/env python3
"""Build frozen synthesis-response VQ descriptor artifacts."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

from revolution.auto_bd.sr_pca_descriptor import (
    hash_json_payload,
    sr_raw_feature_axes,
    sr_raw_feature_values,
)
from revolution.auto_bd.sr_vq_descriptor import (
    SR_VQ_AXES,
    SrVqArtifact,
    fit_sr_vq_artifact,
    sr_vq_artifact_to_json,
    transform_sr_vq,
)
from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES

FORBIDDEN_SR_VQ_DESCRIPTOR_INPUTS = (
    "ppa",
    "reference_ppa",
    "fitness",
    "hypervolume",
    "testbench_pass_percentage",
    "problem_id",
)


def build_artifacts(
    *,
    standard_results_dir: Path,
    output_dir: Path,
    method_name: str,
    codebook_size: int,
    dimensions: int,
    kmeans_seed: int,
    kmeans_iterations: int,
) -> dict[str, Any]:
    """Fit SR-VQ artifacts from valid development candidates."""

    candidates = pd.read_parquet(standard_results_dir / "candidates.parquet")
    valid = candidates.loc[candidates["valid_ppa"].eq(True)].copy()
    assert not valid.empty
    axes = sr_raw_feature_axes()
    raw_rows: list[dict[str, Any]] = []
    train_rows: list[dict[str, Any]] = []
    for row in valid.to_dict("records"):
        netlist_path = Path(str(row["netlist_path"]))
        rtl_path = Path(str(row["rtl_path"]))
        assert netlist_path.is_file(), netlist_path
        stage_paths = _stage_verilog_paths(rtl_path)
        values = sr_raw_feature_values(
            final_netlist_text=netlist_path.read_text(encoding="utf-8", errors="ignore"),
            stage_verilog_paths=stage_paths,
        )
        raw_rows.append(
            {
                "problem_id": row["problem_id"],
                "candidate_id": row["candidate_id"],
                "generation": row["generation"],
                **{axis: values[axis] for axis in axes},
            }
        )
        train_rows.append(
            {
                "source_method_name": row["method_name"],
                "source_method_family": row["method_family"],
                "problem_id": row["problem_id"],
                "seed": row["seed"],
                "generation": row["generation"],
                "candidate_id": row["candidate_id"],
                "rtl_path": row["rtl_path"],
                "netlist_path": row["netlist_path"],
                "stage_dir": stage_paths[0].parent.as_posix(),
            }
        )

    matrix = np.array([[raw_row[axis] for axis in axes] for raw_row in raw_rows], dtype=float)
    artifact = fit_sr_vq_artifact(
        matrix,
        codebook_size=codebook_size,
        dimensions=dimensions,
        kmeans_seed=kmeans_seed,
        kmeans_iterations=kmeans_iterations,
    )
    descriptor_rows = [
        {
            "problem_id": raw_row["problem_id"],
            "candidate_id": raw_row["candidate_id"],
            "descriptor_version": artifact.descriptor_version,
            "descriptor_axes": json.dumps(list(SR_VQ_AXES[:dimensions])),
            "descriptor_vector": json.dumps(
                list(transform_sr_vq(artifact, {axis: raw_row[axis] for axis in axes}))
            ),
            "raw_feature_schema_version": artifact.raw_feature_schema_version,
            "feature_schema_hash": artifact.feature_schema_hash,
            "scaler_hash": artifact.scaler_hash,
            "codebook_hash": artifact.codebook_hash,
            "layout_hash": artifact.layout_hash,
            "descriptor_hash": artifact.descriptor_hash,
        }
        for raw_row in raw_rows
    ]
    output_dir.mkdir(parents=True, exist_ok=True)
    pd.DataFrame(train_rows).to_parquet(output_dir / "training_candidates.parquet", index=False)
    pd.DataFrame(raw_rows).to_parquet(output_dir / "raw_features.parquet", index=False)
    pd.DataFrame(descriptor_rows).to_parquet(output_dir / "training_descriptor_vectors.parquet", index=False)
    pd.DataFrame(codebook_rows(artifact)).to_parquet(output_dir / "codebook_regions.parquet", index=False)
    payload = {
        **sr_vq_artifact_to_json(artifact),
        "method_name": method_name,
        "fitting_protocol": "fixed_offline",
        "training_data": standard_results_dir.as_posix(),
        "training_candidate_count": len(train_rows),
        "training_candidate_list_hash": hash_json_payload({"training_candidates": train_rows}),
        "excluded_data": ["held_out_problems", "main_screening_candidates", "final_evaluation_candidates"],
        "forbidden_descriptor_inputs": list(FORBIDDEN_SR_VQ_DESCRIPTOR_INPUTS),
        "artifact_files": {
            "training_candidates": "training_candidates.parquet",
            "raw_features": "raw_features.parquet",
            "training_descriptor_vectors": "training_descriptor_vectors.parquet",
            "codebook_regions": "codebook_regions.parquet",
        },
    }
    artifact_name = f"{method_name.removesuffix('_qd')}_artifact.json"
    payload["artifact_file"] = artifact_name
    (output_dir / artifact_name).write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return payload


def codebook_rows(artifact: SrVqArtifact) -> list[dict[str, Any]]:
    """Return codebook-region labels for reports and sanity checks."""

    return [
        {
            "cluster_id": index,
            "training_count": artifact.cluster_counts[index],
            "layout_vector": json.dumps(list(artifact.centroid_layout[index])),
            "top_feature_axes": json.dumps(list(artifact.cluster_labels[index])),
        }
        for index in range(artifact.codebook_size)
    ]


def _stage_verilog_paths(rtl_path: Path) -> tuple[Path, ...]:
    stage_dirs = tuple(rtl_path.parent.glob("*.stnod.stages"))
    assert len(stage_dirs) == 1, rtl_path
    paths = tuple(stage_dirs[0] / f"{stage}.v" for stage in STNOD_STAGE_NAMES)
    assert all(path.is_file() for path in paths)
    return paths


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--standard-results-dir", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--method-name", default="sr_vq_codebook_qd")
    parser.add_argument("--codebook-size", type=int, default=16)
    parser.add_argument("--dimensions", type=int, default=3)
    parser.add_argument("--kmeans-seed", type=int, default=20260618)
    parser.add_argument("--kmeans-iterations", type=int, default=32)
    args = parser.parse_args(argv)

    payload = build_artifacts(
        standard_results_dir=args.standard_results_dir,
        output_dir=args.output_dir,
        method_name=args.method_name,
        codebook_size=args.codebook_size,
        dimensions=args.dimensions,
        kmeans_seed=args.kmeans_seed,
        kmeans_iterations=args.kmeans_iterations,
    )
    print(f"SR-VQ artifact -> {args.output_dir / payload['artifact_file']}")
    print(f"feature_schema_hash: {payload['feature_schema_hash']}")
    print(f"scaler_hash: {payload['scaler_hash']}")
    print(f"codebook_hash: {payload['codebook_hash']}")
    print(f"layout_hash: {payload['layout_hash']}")
    print(f"descriptor_hash: {payload['descriptor_hash']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
