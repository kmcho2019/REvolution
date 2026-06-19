#!/usr/bin/env python3
"""Build frozen synthesis-response PCA descriptor artifacts."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

from revolution.auto_bd.sr_pca_descriptor import (
    SR_PCA_AXES,
    fit_sr_random_relu_pca_artifact,
    fit_sr_raw_pca_artifact,
    hash_json_payload,
    sr_pca_artifact_to_json,
    sr_raw_feature_axes,
    sr_raw_feature_values,
    transform_sr_raw_pca,
)
from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES

FORBIDDEN_SR_DESCRIPTOR_INPUTS = (
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
    dimensions: int,
    random_feature_kind: str = "none",
    random_feature_count: int = 0,
    random_feature_seed: int = 0,
) -> dict[str, Any]:
    """Fit SR-PCA artifacts from valid development candidates."""

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
    if random_feature_kind == "none":
        artifact = fit_sr_raw_pca_artifact(matrix, dimensions=dimensions)
    elif random_feature_kind == "relu":
        artifact = fit_sr_random_relu_pca_artifact(
            matrix,
            dimensions=dimensions,
            random_feature_count=random_feature_count,
            random_feature_seed=random_feature_seed,
        )
    else:
        raise AssertionError(f"unknown random feature kind: {random_feature_kind}")
    descriptor_rows = [
        {
            "problem_id": raw_row["problem_id"],
            "candidate_id": raw_row["candidate_id"],
            "descriptor_version": artifact.descriptor_version,
            "descriptor_axes": json.dumps(list(SR_PCA_AXES[:dimensions])),
            "descriptor_vector": json.dumps(
                list(transform_sr_raw_pca(artifact, {axis: raw_row[axis] for axis in axes}))
            ),
            "raw_feature_schema_version": artifact.raw_feature_schema_version,
            "feature_schema_hash": artifact.feature_schema_hash,
            "scaler_hash": artifact.scaler_hash,
            "random_feature_map_kind": artifact.random_map.kind,
            "random_feature_count": artifact.random_map.feature_count,
            "random_feature_seed": artifact.random_map.seed,
            "random_feature_map_hash": artifact.random_map.random_feature_map_hash,
            "pca_hash": artifact.pca_hash,
            "descriptor_hash": artifact.descriptor_hash,
        }
        for raw_row in raw_rows
    ]
    output_dir.mkdir(parents=True, exist_ok=True)
    pd.DataFrame(train_rows).to_parquet(output_dir / "training_candidates.parquet", index=False)
    pd.DataFrame(raw_rows).to_parquet(output_dir / "raw_features.parquet", index=False)
    pd.DataFrame(descriptor_rows).to_parquet(output_dir / "training_descriptor_vectors.parquet", index=False)
    payload = {
        **sr_pca_artifact_to_json(artifact),
        "method_name": method_name,
        "fitting_protocol": "fixed_offline",
        "training_data": standard_results_dir.as_posix(),
        "training_candidate_count": len(train_rows),
        "training_candidate_list_hash": hash_json_payload({"training_candidates": train_rows}),
        "excluded_data": ["held_out_problems", "main_screening_candidates", "final_evaluation_candidates"],
        "forbidden_descriptor_inputs": list(FORBIDDEN_SR_DESCRIPTOR_INPUTS),
        "random_feature_map_kind": artifact.random_map.kind,
        "random_feature_count": artifact.random_map.feature_count,
        "random_feature_seed": artifact.random_map.seed,
        "random_feature_map_hash": artifact.random_map.random_feature_map_hash,
        "artifact_files": {
            "training_candidates": "training_candidates.parquet",
            "raw_features": "raw_features.parquet",
            "training_descriptor_vectors": "training_descriptor_vectors.parquet",
        },
    }
    artifact_name = f"{method_name.removesuffix('_qd')}_artifact.json"
    payload["artifact_file"] = artifact_name
    (output_dir / artifact_name).write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return payload


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
    parser.add_argument("--method-name", default="sr_raw_pca_qd")
    parser.add_argument("--dimensions", type=int, default=3)
    parser.add_argument("--random-feature-kind", choices=("none", "relu"), default="none")
    parser.add_argument("--random-feature-count", type=int, default=0)
    parser.add_argument("--random-feature-seed", type=int, default=0)
    args = parser.parse_args(argv)

    payload = build_artifacts(
        standard_results_dir=args.standard_results_dir,
        output_dir=args.output_dir,
        method_name=args.method_name,
        dimensions=args.dimensions,
        random_feature_kind=args.random_feature_kind,
        random_feature_count=args.random_feature_count,
        random_feature_seed=args.random_feature_seed,
    )
    print(f"SR-PCA artifact -> {args.output_dir / payload['artifact_file']}")
    print(f"feature_schema_hash: {payload['feature_schema_hash']}")
    print(f"scaler_hash: {payload['scaler_hash']}")
    print(f"pca_hash: {payload['pca_hash']}")
    print(f"descriptor_hash: {payload['descriptor_hash']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
