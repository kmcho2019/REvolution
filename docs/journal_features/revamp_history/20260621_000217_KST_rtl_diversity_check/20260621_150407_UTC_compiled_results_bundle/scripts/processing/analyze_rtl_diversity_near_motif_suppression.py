#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportAttributeAccessIssue=false, reportGeneralTypeIssues=false
"""Analyze near-identical motif-vector duplicate suppression."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    hypervolume,
    objective_metrics_for_reference,
    pareto_front,
)

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CANDIDATE_AUDIT = (
    REPO_ROOT
    / "exp/diversity_check/restarted_report_20260621_071339_UTC/candidate_audit.parquet"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp2_near_motif_suppression"
THRESHOLDS = (0.0, 0.01, 0.025, 0.05)
MOTIF_KEYS = (
    "motif_arith_ratio",
    "motif_control_ratio",
    "motif_diversity",
    "motif_logic_ratio",
)


def main() -> None:
    args = parse_args()
    summary = run_analysis(args.candidate_audit, args.output_dir)
    print(json.dumps(summary, indent=2, sort_keys=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-audit", type=Path, default=DEFAULT_CANDIDATE_AUDIT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def run_analysis(candidate_audit: Path, output_dir: Path) -> dict[str, Any]:
    output_dir.mkdir(parents=True, exist_ok=True)
    candidates = load_candidates(candidate_audit)
    rows = near_motif_rows(candidates)
    aggregate = aggregate_rows(rows)
    rows.to_csv(output_dir / "near_motif_suppression.csv", index=False)
    aggregate.to_csv(output_dir / "near_motif_suppression_aggregate.csv", index=False)
    write_report(output_dir / "near_motif_suppression_report.md", rows, aggregate)
    summary = {
        "version": 1,
        "candidate_audit": candidate_audit.as_posix(),
        "output_dir": output_dir.as_posix(),
        "candidate_count": int(len(candidates)),
        "valid_ppa_count": int(candidates["valid_ppa"].astype(bool).sum()),
        "motif_vector_valid_count": int(motif_valid_mask(candidates).sum()),
        "group_count": int(
            candidates.loc[motif_valid_mask(candidates)]
            .groupby(["corpus", "descriptor_family", "method", "seed", "problem_id"])
            .ngroups
        ),
        "thresholds": list(THRESHOLDS),
        "rows": int(len(rows)),
        "aggregate_rows": int(len(aggregate)),
        "coverage_note": (
            "distance-based near-motif suppression only covers rows with "
            "stored motif_vector JSON; ASP-DAC and Auto-BD imported rows lack "
            "distance-bearing motif vectors in this audit"
        ),
        "artifacts": {
            "near_motif_suppression_csv": (
                output_dir / "near_motif_suppression.csv"
            ).as_posix(),
            "near_motif_suppression_aggregate_csv": (
                output_dir / "near_motif_suppression_aggregate.csv"
            ).as_posix(),
            "near_motif_suppression_report_md": (
                output_dir / "near_motif_suppression_report.md"
            ).as_posix(),
        },
    }
    summary["artifact_sha256"] = {
        "near_motif_suppression.csv": sha256_file(
            output_dir / "near_motif_suppression.csv"
        ),
        "near_motif_suppression_aggregate.csv": sha256_file(
            output_dir / "near_motif_suppression_aggregate.csv"
        ),
        "near_motif_suppression_report.md": sha256_file(
            output_dir / "near_motif_suppression_report.md"
        ),
    }
    (output_dir / "near_motif_suppression_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    summary["artifact_sha256"]["near_motif_suppression_summary.json"] = sha256_file(
        output_dir / "near_motif_suppression_summary.json"
    )
    return summary


def load_candidates(path: Path) -> pd.DataFrame:
    assert path.is_file(), f"missing candidate audit: {path}"
    frame = pd.read_parquet(path) if path.suffix == ".parquet" else pd.read_csv(path)
    required = {
        "corpus",
        "descriptor_family",
        "method",
        "seed",
        "problem_id",
        "generation",
        "candidate_id",
        "valid_ppa",
        "motif_vector",
        "motif_signature_hash",
        "canonical_netlist_hash",
        "area",
        "power",
        "eff_clk_period",
        "fitness",
        "reference_ppa_json",
    }
    missing = required.difference(frame.columns)
    assert not missing, f"candidate audit missing columns: {sorted(missing)}"
    return frame


def near_motif_rows(candidates: pd.DataFrame) -> pd.DataFrame:
    valid = candidates.loc[motif_valid_mask(candidates)].copy()
    valid["_motif_vector"] = valid["motif_vector"].map(motif_vector)
    rows: list[dict[str, Any]] = []
    groups = valid.groupby(
        ["corpus", "descriptor_family", "method", "seed", "problem_id"],
        sort=True,
    )
    for key, group in groups:
        corpus, family, method, seed, problem = key
        ordered = group.sort_values(["generation", "candidate_id"])
        baseline_hv = selected_hypervolume(ordered)
        baseline_pareto = len(pareto_front(improvement_points(ordered)))
        for threshold in THRESHOLDS:
            retained = suppress_near_motif(ordered, threshold)
            rows.append(
                {
                    "corpus": corpus,
                    "descriptor_family": family,
                    "method": method,
                    "seed": int(seed),
                    "problem_id": problem,
                    "motif_distance_threshold": threshold,
                    "valid_ppa_count": int(len(ordered)),
                    "retained_count": int(len(retained)),
                    "suppressed_near_motif_count": int(len(ordered) - len(retained)),
                    "retained_fraction": float(len(retained) / len(ordered)),
                    "unique_motif_signatures": unique_nonempty(
                        retained, "motif_signature_hash"
                    ),
                    "unique_canonical_netlists": unique_nonempty(
                        retained, "canonical_netlist_hash"
                    ),
                    "retained_pareto_size": len(pareto_front(improvement_points(retained))),
                    "baseline_pareto_size": baseline_pareto,
                    "retained_hypervolume": selected_hypervolume(retained),
                    "baseline_hypervolume": baseline_hv,
                    "retained_best_fitness": numeric_max(retained, "fitness"),
                    "baseline_best_fitness": numeric_max(ordered, "fitness"),
                }
            )
    return pd.DataFrame(rows)


def suppress_near_motif(group: pd.DataFrame, threshold: float) -> pd.DataFrame:
    selected_indices: list[Any] = []
    selected_vectors: list[np.ndarray] = []
    for index, row in group.iterrows():
        vector = row["_motif_vector"]
        assert isinstance(vector, np.ndarray)
        if not selected_vectors:
            selected_indices.append(index)
            selected_vectors.append(vector)
            continue
        distances = np.linalg.norm(np.vstack(selected_vectors) - vector, axis=1)
        if float(distances.min()) > threshold:
            selected_indices.append(index)
            selected_vectors.append(vector)
    return group.loc[selected_indices]


def aggregate_rows(rows: pd.DataFrame) -> pd.DataFrame:
    if rows.empty:
        return rows
    return (
        rows.groupby(
            ["corpus", "descriptor_family", "method", "motif_distance_threshold"],
            as_index=False,
        )
        .agg(
            problem_group_count=("problem_id", "count"),
            valid_ppa_count=("valid_ppa_count", "sum"),
            retained_count=("retained_count", "sum"),
            suppressed_near_motif_count=("suppressed_near_motif_count", "sum"),
            mean_retained_fraction=("retained_fraction", "mean"),
            retained_pareto_size=("retained_pareto_size", "sum"),
            baseline_pareto_size=("baseline_pareto_size", "sum"),
            retained_hypervolume=("retained_hypervolume", "sum"),
            baseline_hypervolume=("baseline_hypervolume", "sum"),
            retained_best_fitness=("retained_best_fitness", "max"),
            baseline_best_fitness=("baseline_best_fitness", "max"),
        )
        .assign(
            hypervolume_gain_fraction=lambda frame: (
                frame["retained_hypervolume"] - frame["baseline_hypervolume"]
            )
            / frame["baseline_hypervolume"].clip(lower=1e-12),
            pareto_gain_fraction=lambda frame: (
                frame["retained_pareto_size"] - frame["baseline_pareto_size"]
            )
            / frame["baseline_pareto_size"].clip(lower=1),
        )
    )


def write_report(path: Path, rows: pd.DataFrame, aggregate: pd.DataFrame) -> None:
    lines = [
        "# Near-Identical Motif Suppression",
        "",
        f"- Problem groups: {rows['problem_id'].nunique() if not rows.empty else 0}",
        f"- Rows: {len(rows)}",
        "",
        "## Aggregate",
        "",
        markdown_table(aggregate.to_dict("records") if not aggregate.empty else []),
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def motif_valid_mask(frame: pd.DataFrame) -> pd.Series:
    text = frame["motif_vector"].fillna("").astype(str).str.strip()
    return frame["valid_ppa"].astype(bool) & text.ne("") & ~text.isin(["[]", "None"])


def motif_vector(value: object) -> np.ndarray:
    loaded = json.loads(str(value))
    assert isinstance(loaded, dict), f"expected motif dict: {str(value)[:80]}"
    return np.array([float(loaded[key]) for key in MOTIF_KEYS], dtype=float)


def selected_hypervolume(frame: pd.DataFrame) -> float:
    return hypervolume(improvement_points(frame))


def improvement_points(frame: pd.DataFrame) -> list[tuple[float, ...]]:
    points = []
    for row in frame.to_dict("records"):
        ref = reference_metrics(row)
        metrics = objective_metrics_for_reference(ref)
        improvements = compute_candidate_improvements(row, ref, metrics)
        if improvements is not None:
            points.append(tuple(improvements[metric] for metric in metrics))
    return points


def reference_metrics(row: dict[str, Any]) -> dict[str, float]:
    raw = row["reference_ppa_json"]
    if raw:
        payload = json.loads(str(raw))
        if payload:
            return {key: float(value) for key, value in payload.items()}
    return {
        "area": max(float(row["area"]) * 1.2, 1.0),
        "power": max(float(row["power"]) * 1.2, 1e-9),
        "eff_clk_period": max(float(row["eff_clk_period"]) * 1.2, 1e-9),
    }


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    text = frame[column].fillna("").astype(str).str.strip()
    return int(text.loc[text.ne("")].nunique())


def numeric_max(frame: pd.DataFrame, column: str) -> float | None:
    values = pd.to_numeric(frame[column], errors="coerce").dropna()
    return None if values.empty else float(values.max())


def markdown_table(rows: list[dict[str, Any]]) -> str:
    if not rows:
        return "_No rows._"
    columns = list(rows[0])
    lines = [
        "| " + " | ".join(columns) + " |",
        "| " + " | ".join("---" for _ in columns) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(row[column]) for column in columns) + " |")
    return "\n".join(lines)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


if __name__ == "__main__":
    main()
