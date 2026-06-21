#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportGeneralTypeIssues=false, reportAttributeAccessIssue=false
"""Reconstruct WP0 ST-NOD/SR rows from Auto-BD standard results."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_AUTO_BD_ROOT = Path(
    "/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618"
) / "exp/auto_bd_research/main_screening_screening_seed3"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp0_stnod_sr_reconstruction"
METHODS = ("synthesis_trajectory_nod", "sr_random_relu_pca_qd")
CHECKPOINTS = (0.25, 0.50, 0.75, 1.00)
CANDIDATE_REQUIRED_COLUMNS = {
    "method_name",
    "problem_id",
    "seed",
    "generation",
    "candidate_id",
    "parent_id",
    "operator_name",
    "valid_ppa",
    "area",
    "power",
    "timing_or_clock_period",
    "fitness",
    "descriptor_vector",
    "common_audit_descriptor_vector",
    "archive_cell_id",
    "common_audit_cell_id",
    "canonical_netlist_hash",
    "motif_signature_hash",
}


def build_reconstruction(auto_bd_root: Path, output_dir: Path) -> dict[str, Any]:
    """Build WP0 reconstruction artifacts from Auto-BD standard results."""

    assert auto_bd_root.is_dir(), f"missing Auto-BD root: {auto_bd_root}"
    output_dir.mkdir(parents=True, exist_ok=True)

    candidates = load_candidates(auto_bd_root)
    events = load_qd_events(auto_bd_root)
    budget = budget_curve_rows(candidates)
    operators = operator_yield_rows(candidates)

    artifacts = {
        "reconstructed_rows_parquet": output_dir / "wp0_descriptor_rows.parquet",
        "reconstructed_rows_csv": output_dir / "wp0_descriptor_rows.csv",
        "budget_curves_csv": output_dir / "wp0_budget_curves.csv",
        "operator_yield_csv": output_dir / "wp0_operator_yield.csv",
        "qd_events_csv": output_dir / "wp0_qd_events.csv",
    }
    candidates.to_parquet(artifacts["reconstructed_rows_parquet"], index=False)
    candidates.to_csv(artifacts["reconstructed_rows_csv"], index=False)
    budget.to_csv(artifacts["budget_curves_csv"], index=False)
    operators.to_csv(artifacts["operator_yield_csv"], index=False)
    events.to_csv(artifacts["qd_events_csv"], index=False)

    summary = {
        "version": 1,
        "source_root": auto_bd_root.as_posix(),
        "output_dir": output_dir.as_posix(),
        "candidate_rows": int(len(candidates)),
        "event_rows": int(len(events)),
        "budget_rows": int(len(budget)),
        "operator_rows": int(len(operators)),
        "methods": method_summaries(candidates),
        "artifacts": {key: path.as_posix() for key, path in artifacts.items()},
        "artifact_sha256": {
            key: file_sha256(path) for key, path in artifacts.items()
        },
    }
    summary_path = output_dir / "wp0_reconstruction_summary.json"
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    return summary


def load_candidates(auto_bd_root: Path) -> pd.DataFrame:
    frames = []
    for method in METHODS:
        paths = sorted((auto_bd_root / method).glob("seed_*/standard_results/candidates.parquet"))
        assert paths, f"missing candidates.parquet for {method}"
        for path in paths:
            frame = pd.read_parquet(path)
            missing = CANDIDATE_REQUIRED_COLUMNS.difference(frame.columns)
            assert not missing, f"{path} missing columns: {sorted(missing)}"
            frame = frame.copy()
            frame.insert(0, "source_standard_results", path.parent.as_posix())
            frame.insert(1, "source_method", method)
            frame.insert(2, "source_seed_dir", path.parents[1].name)
            frame["row_order"] = np.arange(len(frame), dtype=np.int64)
            frame["descriptor_dim"] = frame["descriptor_vector"].map(vector_dim)
            frame["common_audit_dim"] = frame[
                "common_audit_descriptor_vector"
            ].map(vector_dim)
            frame["parent_id_nonempty"] = nonempty_mask(frame["parent_id"])
            frame["canonical_hash_nonempty"] = nonempty_mask(
                frame["canonical_netlist_hash"]
            )
            frames.append(frame)
    return pd.concat(frames, ignore_index=True)


def load_qd_events(auto_bd_root: Path) -> pd.DataFrame:
    rows: list[dict[str, object]] = []
    for method in METHODS:
        for path in sorted((auto_bd_root / method).glob("seed_*/revolution/**/qd_archive_event.json")):
            obj = json.loads(path.read_text())
            parts = path.relative_to(auto_bd_root / method).parts
            rows.append(
                {
                    "method_name": method,
                    "seed_dir": parts[0],
                    "event_path": path.as_posix(),
                    "candidate_id": str(obj["candidate_id"]),
                    "generation": obj.get("generation"),
                    "generated_mode": obj.get("generated_mode"),
                    "origin_pool": obj.get("origin_pool"),
                    "strategy": obj.get("strategy"),
                    "parent_count": obj.get("parent_count"),
                    "requested_parent_count": obj.get("requested_parent_count"),
                    "inserted": obj.get("inserted"),
                    "cell_id": obj.get("cell_id"),
                    "quality_score": obj.get("quality_score"),
                    "descriptor_values": json.dumps(
                        obj.get("descriptor_values", {}), sort_keys=True
                    ),
                    "objectives": json.dumps(obj.get("objectives", {}), sort_keys=True),
                }
            )
    return pd.DataFrame(rows)


def budget_curve_rows(candidates: pd.DataFrame) -> pd.DataFrame:
    rows: list[dict[str, object]] = []
    groups = candidates.groupby(["method_name", "seed", "problem_id"], sort=True)
    for (method, seed, problem), group in groups:
        ordered = group.sort_values(["generation", "row_order"])
        for fraction in CHECKPOINTS:
            prefix = ordered.head(math.ceil(len(ordered) * fraction))
            valid = prefix.loc[prefix["valid_ppa"].astype(bool)]
            unique_hashes = unique_nonempty(valid, "canonical_netlist_hash")
            rows.append(
                {
                    "method_name": method,
                    "seed": int(seed),
                    "problem_id": problem,
                    "budget_fraction": fraction,
                    "candidate_count": int(len(prefix)),
                    "valid_ppa_count": int(len(valid)),
                    "valid_ppa_rate": safe_rate(len(valid), len(prefix)),
                    "unique_canonical_netlists": unique_hashes,
                    "canonical_duplicate_count": int(len(valid) - unique_hashes),
                    "unique_motif_signatures": unique_nonempty(
                        valid, "motif_signature_hash"
                    ),
                    "occupied_internal_cells": unique_nonempty(valid, "archive_cell_id"),
                    "occupied_common_audit_cells": unique_nonempty(
                        valid, "common_audit_cell_id"
                    ),
                    "pareto_size": pareto_size(valid),
                    "best_fitness": numeric_max(valid, "fitness"),
                }
            )
    return pd.DataFrame(rows)


def operator_yield_rows(candidates: pd.DataFrame) -> pd.DataFrame:
    rows: list[dict[str, object]] = []
    groups = candidates.groupby(["method_name", "seed", "operator_name"], dropna=False)
    for (method, seed, operator), group in groups:
        valid = group.loc[group["valid_ppa"].astype(bool)]
        rows.append(
            {
                "method_name": method,
                "seed": int(seed),
                "operator_name": str(operator),
                "candidate_count": int(len(group)),
                "valid_ppa_count": int(len(valid)),
                "valid_ppa_rate": safe_rate(len(valid), len(group)),
                "unique_canonical_netlists": unique_nonempty(
                    valid, "canonical_netlist_hash"
                ),
                "occupied_common_audit_cells": unique_nonempty(
                    valid, "common_audit_cell_id"
                ),
                "best_fitness": numeric_max(valid, "fitness"),
                "mean_fitness": numeric_mean(valid, "fitness"),
            }
        )
    return pd.DataFrame(rows)


def method_summaries(candidates: pd.DataFrame) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for method, group in candidates.groupby("method_name", sort=True):
        valid = group.loc[group["valid_ppa"].astype(bool)]
        rows.append(
            {
                "method_name": method,
                "rows": int(len(group)),
                "seeds": int(group["seed"].nunique()),
                "problems": int(group["problem_id"].nunique()),
                "generations": [
                    int(group["generation"].min()),
                    int(group["generation"].max()),
                ],
                "valid_ppa_rows": int(len(valid)),
                "descriptor_rows": int((group["descriptor_dim"] > 0).sum()),
                "common_audit_rows": int((group["common_audit_dim"] > 0).sum()),
                "parent_id_rows": int(group["parent_id_nonempty"].sum()),
                "unique_canonical_netlists": unique_nonempty(
                    valid, "canonical_netlist_hash"
                ),
                "operators": sorted(group["operator_name"].astype(str).unique()),
            }
        )
    return rows


def vector_dim(value: object) -> int:
    if value is None:
        return 0
    if isinstance(value, (list, tuple)):
        return len(value)
    text = str(value).strip()
    if not text or text == "[]":
        return 0
    loaded = json.loads(text)
    assert isinstance(loaded, list), f"expected vector list: {text[:80]}"
    return len(loaded)


def nonempty_mask(series: pd.Series) -> pd.Series:
    return series.fillna("").astype(str).str.strip().ne("")


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    if frame.empty:
        return 0
    values = frame[column].fillna("").astype(str).str.strip()
    return int(values.loc[values.ne("")].nunique())


def numeric_max(frame: pd.DataFrame, column: str) -> float | None:
    if frame.empty:
        return None
    values = pd.to_numeric(frame[column], errors="coerce").dropna()
    if values.empty:
        return None
    return float(values.max())


def numeric_mean(frame: pd.DataFrame, column: str) -> float | None:
    if frame.empty:
        return None
    values = pd.to_numeric(frame[column], errors="coerce").dropna()
    if values.empty:
        return None
    return float(values.mean())


def pareto_size(valid: pd.DataFrame) -> int:
    metrics = valid[["area", "power", "timing_or_clock_period"]].apply(
        pd.to_numeric, errors="coerce"
    )
    values = metrics.dropna().to_numpy(dtype=float)
    if len(values) == 0:
        return 0
    count = 0
    for row in values:
        weakly_better = (values <= row).all(axis=1)
        strictly_better = (values < row).any(axis=1)
        if not bool((weakly_better & strictly_better).any()):
            count += 1
    return count


def safe_rate(numerator: int, denominator: int) -> float:
    assert denominator > 0
    return numerator / denominator


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--auto-bd-root", type=Path, default=DEFAULT_AUTO_BD_ROOT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    summary = build_reconstruction(args.auto_bd_root, args.output_dir)
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
