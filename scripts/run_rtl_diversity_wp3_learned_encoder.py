#!/usr/bin/env python3
"""Run a bounded WP3 learned-encoder diagnostic for RTL diversity."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any, cast

import numpy as np
import pandas as pd

NOVELTY_FRACTIONS = (0.0, 0.1, 0.25, 0.5)
FORBIDDEN_TRAINING_INPUTS = (
    "area",
    "power",
    "timing_or_clock_period",
    "fitness",
    "ppa_hypervolume_contribution",
    "valid_ppa",
    "problem_id",
    "candidate_id",
)


@dataclass(frozen=True)
class LinearEncoder:
    """Frozen linear bottleneck fitted without PPA labels."""

    input_mean: tuple[float, ...]
    input_std: tuple[float, ...]
    components: tuple[tuple[float, ...], ...]
    latent_mean: tuple[float, ...]
    latent_std: tuple[float, ...]


def run_diagnostic(
    *,
    artifact_dir: Path,
    output_dir: Path,
    latent_dim: int,
) -> dict[str, Any]:
    """Fit and evaluate the bounded learned encoder diagnostic.

    Args:
        artifact_dir: WP0/WP2 artifact directory containing descriptor rows.
        output_dir: Directory for generated WP3 diagnostic outputs.
        latent_dim: Linear bottleneck dimension.

    Returns:
        Summary payload written to `wp3_learned_encoder_summary.json`.
    """

    assert 1 <= latent_dim <= 4
    rows = load_training_rows(artifact_dir / "wp0_descriptor_rows.parquet")
    split_rows = add_problem_split(rows)
    train = split_rows.loc[split_rows["split"].eq("train")]
    holdout = split_rows.loc[split_rows["split"].eq("holdout")]
    assert len(train) and len(holdout)

    encoder = fit_linear_encoder(vector_matrix(train), latent_dim=latent_dim)
    encoded = add_representations(split_rows, encoder)
    replay = replay_rows(encoded)
    comparison = holdout_comparison(replay)
    summary = summary_payload(
        artifact_dir=artifact_dir,
        output_dir=output_dir,
        rows=encoded,
        encoder=encoder,
        replay=replay,
        comparison=comparison,
    )

    output_dir.mkdir(parents=True, exist_ok=True)
    encoded.to_parquet(output_dir / "wp3_learned_encoder_rows.parquet", index=False)
    replay.to_csv(output_dir / "wp3_learned_encoder_replay.csv", index=False)
    write_method_card(output_dir / "wp3_learned_encoder_card.md", summary)
    summary["artifact_sha256"] = {
        "wp3_learned_encoder_rows.parquet": sha256_file(
            output_dir / "wp3_learned_encoder_rows.parquet"
        ),
        "wp3_learned_encoder_replay.csv": sha256_file(
            output_dir / "wp3_learned_encoder_replay.csv"
        ),
        "wp3_learned_encoder_card.md": sha256_file(
            output_dir / "wp3_learned_encoder_card.md"
        ),
    }
    (output_dir / "wp3_learned_encoder_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    summary["artifact_sha256"]["wp3_learned_encoder_summary.json"] = sha256_file(
        output_dir / "wp3_learned_encoder_summary.json"
    )
    return summary


def load_training_rows(path: Path) -> pd.DataFrame:
    """Load valid rows with common-audit vectors for learned diagnostics."""

    assert path.is_file(), path
    frame = pd.read_parquet(path)
    required = {
        "method_name",
        "seed",
        "problem_id",
        "generation",
        "candidate_id",
        "valid_ppa",
        "fitness",
        "area",
        "power",
        "timing_or_clock_period",
        "canonical_netlist_hash",
        "motif_signature_hash",
        "common_audit_cell_id",
        "common_audit_descriptor_vector",
    }
    missing = required.difference(frame.columns)
    assert not missing, sorted(missing)
    rows = frame.loc[frame["valid_ppa"].astype(bool)].copy()
    rows["common_audit_dim"] = rows["common_audit_descriptor_vector"].map(vector_dim)
    rows = rows.loc[rows["common_audit_dim"].eq(4)].copy()
    assert len(rows), "no valid common-audit rows"
    return rows.reset_index(drop=True)


def add_problem_split(frame: pd.DataFrame) -> pd.DataFrame:
    """Add deterministic problem-level train/holdout split labels."""

    problems = sorted(frame["problem_id"].astype(str).unique())
    assert len(problems) >= 3
    holdout = {problem for index, problem in enumerate(problems) if index % 3 == 0}
    train = set(problems).difference(holdout)
    assert train and holdout
    split = frame.copy()
    split["split"] = split["problem_id"].map(
        lambda problem: "holdout" if str(problem) in holdout else "train"
    )
    return split


def fit_linear_encoder(matrix: np.ndarray, *, latent_dim: int) -> LinearEncoder:
    """Fit a frozen linear reconstruction bottleneck."""

    assert matrix.ndim == 2
    assert matrix.shape[0] > latent_dim
    mean = matrix.mean(axis=0)
    raw_std = matrix.std(axis=0)
    std = np.where(raw_std == 0.0, 1.0, raw_std)
    z = (matrix - mean) / std
    _u, _s, vh = np.linalg.svd(z, full_matrices=False)
    components = vh[:latent_dim].copy()
    latent = z @ components.T
    latent_mean = latent.mean(axis=0)
    raw_latent_std = latent.std(axis=0)
    latent_std = np.where(raw_latent_std == 0.0, 1.0, raw_latent_std)
    return LinearEncoder(
        input_mean=tuple(float(value) for value in mean),
        input_std=tuple(float(value) for value in std),
        components=tuple(tuple(float(value) for value in row) for row in components),
        latent_mean=tuple(float(value) for value in latent_mean),
        latent_std=tuple(float(value) for value in latent_std),
    )


def add_representations(frame: pd.DataFrame, encoder: LinearEncoder) -> pd.DataFrame:
    matrix = vector_matrix(frame)
    audit_z = standardize(matrix, encoder.input_mean, encoder.input_std)
    components = np.array(encoder.components, dtype=float)
    latent = audit_z @ components.T
    latent_z = standardize(latent, encoder.latent_mean, encoder.latent_std)
    rows = frame.copy()
    for index in range(audit_z.shape[1]):
        rows[f"audit_z_{index}"] = audit_z[:, index]
    for index in range(latent_z.shape[1]):
        rows[f"aurora_linear_ae_{index}"] = latent_z[:, index]
    reconstruction = (latent @ components) * np.array(encoder.input_std) + np.array(
        encoder.input_mean
    )
    rows["aurora_reconstruction_mse"] = np.mean((matrix - reconstruction) ** 2, axis=1)
    return rows


def replay_rows(frame: pd.DataFrame) -> pd.DataFrame:
    rows: list[dict[str, Any]] = []
    latent_columns = tuple(
        column for column in frame.columns if column.startswith("aurora_linear_ae_")
    )
    specs = (
        ("common_audit_z4", tuple(f"audit_z_{index}" for index in range(4))),
        (f"aurora_linear_ae{len(latent_columns)}", latent_columns),
    )
    groups = frame.groupby(["split", "method_name", "seed", "problem_id"], sort=True)
    for key, group in groups:
        split, method, seed, problem = cast(tuple[Any, Any, Any, Any], key)
        ordered = group.sort_values(["generation", "candidate_id"])
        fitness = numeric_series(ordered, "fitness")
        quality_floor = float(fitness.median())
        eligible = ordered.loc[fitness.ge(quality_floor)]
        pool_size = min(len(eligible), math.ceil(len(ordered) * 0.25))
        for representation, columns in specs:
            for novelty_fraction in NOVELTY_FRACTIONS:
                selected = novelty_selection(
                    eligible,
                    columns=columns,
                    pool_size=pool_size,
                    novelty_fraction=novelty_fraction,
                )
                rows.append(
                    {
                        "split": split,
                        "representation": representation,
                        "method_name": method,
                        "seed": int(seed),
                        "problem_id": problem,
                        "budget_fraction": 1.0,
                        "novelty_parent_fraction": novelty_fraction,
                        "quality_floor": "prefix_median_valid_fitness",
                        "quality_floor_value": quality_floor,
                        "valid_ppa_count": int(len(ordered)),
                        "selected_count": int(len(selected)),
                        "unique_canonical_netlists": unique_nonempty(
                            selected, "canonical_netlist_hash"
                        ),
                        "unique_motif_signatures": unique_nonempty(
                            selected, "motif_signature_hash"
                        ),
                        "occupied_common_audit_cells": unique_nonempty(
                            selected, "common_audit_cell_id"
                        ),
                        "pareto_size": pareto_size(selected),
                        "best_fitness": numeric_max(selected, "fitness"),
                        "mean_fitness": numeric_mean(selected, "fitness"),
                    }
                )
    return pd.DataFrame(rows)


def novelty_selection(
    eligible: pd.DataFrame,
    *,
    columns: tuple[str, ...],
    pool_size: int,
    novelty_fraction: float,
) -> pd.DataFrame:
    if eligible.empty or pool_size == 0:
        return eligible.head(0)
    quality_slots = min(len(eligible), math.ceil(pool_size * (1.0 - novelty_fraction)))
    selected = eligible.sort_values(
        ["fitness", "generation", "candidate_id"],
        ascending=[False, True, True],
    ).head(quality_slots)
    remaining = eligible.drop(index=list(selected.index))
    while len(selected) < pool_size and not remaining.empty:
        pick_index = farthest_candidate_index(selected, remaining, columns)
        selected = pd.concat([selected, remaining.loc[[pick_index]]])
        remaining = remaining.drop(index=[pick_index])
    return selected


def farthest_candidate_index(
    selected: pd.DataFrame,
    remaining: pd.DataFrame,
    columns: tuple[str, ...],
) -> object:
    selected_matrix = selected.loc[:, columns].to_numpy(dtype=float)
    best_index = remaining.index[0]
    best_distance = -math.inf
    best_fitness = -math.inf
    for index, row in remaining.iterrows():
        vector = np.array([float(row[column]) for column in columns], dtype=float)
        distance = float(np.linalg.norm(selected_matrix - vector, axis=1).min())
        fitness = float(row["fitness"])
        if (distance, fitness) > (best_distance, best_fitness):
            best_index = index
            best_distance = distance
            best_fitness = fitness
    return best_index


def holdout_comparison(replay: pd.DataFrame) -> dict[str, Any]:
    holdout = replay.loc[
        replay["split"].eq("holdout") & replay["novelty_parent_fraction"].eq(0.5)
    ]
    grouped = (
        holdout.groupby("representation", as_index=False)
        .agg(
            selected_count=("selected_count", "sum"),
            unique_canonical_netlists=("unique_canonical_netlists", "sum"),
            unique_motif_signatures=("unique_motif_signatures", "sum"),
            occupied_common_audit_cells=("occupied_common_audit_cells", "sum"),
            pareto_size=("pareto_size", "sum"),
            best_fitness=("best_fitness", "max"),
            mean_fitness=("mean_fitness", "mean"),
        )
        .set_index("representation")
    )
    common = grouped.loc["common_audit_z4"]
    aurora_name = next(
        str(name) for name in grouped.index if str(name).startswith("aurora_linear_ae")
    )
    aurora = grouped.loc[aurora_name]
    deltas = {
        "unique_canonical_netlists": int(
            aurora["unique_canonical_netlists"] - common["unique_canonical_netlists"]
        ),
        "unique_motif_signatures": int(
            aurora["unique_motif_signatures"] - common["unique_motif_signatures"]
        ),
        "occupied_common_audit_cells": int(
            aurora["occupied_common_audit_cells"] - common["occupied_common_audit_cells"]
        ),
        "pareto_size": int(aurora["pareto_size"] - common["pareto_size"]),
        "best_fitness": float(aurora["best_fitness"] - common["best_fitness"]),
    }
    pareto_gain = deltas["pareto_size"] / max(float(common["pareto_size"]), 1.0)
    canonical_gain = deltas["unique_canonical_netlists"] / max(
        float(common["unique_canonical_netlists"]), 1.0
    )
    verdict = (
        "diagnostic_follow_up"
        if canonical_gain >= 0.05
        and pareto_gain >= 0.05
        and deltas["best_fitness"] >= -1e-9
        else "diagnostic_only_no_proceed"
    )
    return {
        "holdout_novelty_fraction": 0.5,
        "aurora_representation": aurora_name,
        "aggregate": grouped.reset_index().to_dict("records"),
        "aurora_minus_common": deltas,
        "canonical_gain_fraction": canonical_gain,
        "pareto_gain_fraction": pareto_gain,
        "verdict": verdict,
    }


def summary_payload(
    *,
    artifact_dir: Path,
    output_dir: Path,
    rows: pd.DataFrame,
    encoder: LinearEncoder,
    replay: pd.DataFrame,
    comparison: dict[str, Any],
) -> dict[str, Any]:
    train = rows.loc[rows["split"].eq("train")]
    holdout = rows.loc[rows["split"].eq("holdout")]
    return {
        "version": 1,
        "family": "aurora_linear_autoencoder_probe",
        "artifact_dir": artifact_dir.as_posix(),
        "out_dir": output_dir.as_posix(),
        "training_protocol": "fixed_offline_problem_split",
        "fitting_inputs": ["common_audit_descriptor_vector"],
        "forbidden_training_inputs": list(FORBIDDEN_TRAINING_INPUTS),
        "train_candidate_count": int(len(train)),
        "holdout_candidate_count": int(len(holdout)),
        "train_problems": sorted(train["problem_id"].astype(str).unique()),
        "holdout_problems": sorted(holdout["problem_id"].astype(str).unique()),
        "input_dim": 4,
        "latent_dim": len(encoder.components),
        "encoder_hash": sha256_json(encoder_json(encoder)),
        "train_reconstruction_mse": float(train["aurora_reconstruction_mse"].mean()),
        "holdout_reconstruction_mse": float(
            holdout["aurora_reconstruction_mse"].mean()
        ),
        "latent_std": [
            float(rows[column].std())
            for column in rows.columns
            if column.startswith("aurora_linear_ae_")
        ],
        "replay_rows": int(len(replay)),
        "comparison": comparison,
    }


def write_method_card(path: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# WP3 Learned Encoder Diagnostic Card",
        "",
        f"- Family: `{summary['family']}`",
        "- Status: diagnostic-only replay probe.",
        "- Fitting input: `common_audit_descriptor_vector` only.",
        "- Forbidden fitting inputs: "
        + ", ".join(f"`{name}`" for name in summary["forbidden_training_inputs"]),
        f"- Train candidates: {summary['train_candidate_count']}",
        f"- Holdout candidates: {summary['holdout_candidate_count']}",
        f"- Encoder hash: `{summary['encoder_hash']}`",
        f"- Train reconstruction MSE: {summary['train_reconstruction_mse']:.6g}",
        f"- Holdout reconstruction MSE: {summary['holdout_reconstruction_mse']:.6g}",
        f"- Verdict: `{summary['comparison']['verdict']}`",
        "",
        "This probe tests whether a small frozen bottleneck over existing "
        "implementation vectors improves quality-gated novelty replay on held-out "
        "problems. It does not train on PPA labels and does not support active "
        "method promotion by itself.",
        "",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def vector_matrix(frame: pd.DataFrame) -> np.ndarray:
    return np.vstack(frame["common_audit_descriptor_vector"].map(vector_array).to_list())


def vector_dim(value: object) -> int:
    text = str(value).strip()
    if not text or text == "[]":
        return 0
    loaded = json.loads(text)
    assert isinstance(loaded, list), f"expected vector list: {text[:80]}"
    return len(loaded)


def vector_array(value: object) -> np.ndarray:
    text = str(value).strip()
    loaded = json.loads(text)
    assert isinstance(loaded, list), f"expected vector list: {text[:80]}"
    return np.array(loaded, dtype=float)


def standardize(
    matrix: np.ndarray,
    mean_values: tuple[float, ...],
    std_values: tuple[float, ...],
) -> np.ndarray:
    return (matrix - np.array(mean_values, dtype=float)) / np.array(
        std_values, dtype=float
    )


def pareto_size(frame: pd.DataFrame) -> int:
    if frame.empty:
        return 0
    points = frame.loc[:, ["area", "power", "timing_or_clock_period"]].to_numpy(
        dtype=float
    )
    finite = points[np.isfinite(points).all(axis=1)]
    if len(finite) == 0:
        return 0
    dominated = np.zeros(len(finite), dtype=bool)
    for index, point in enumerate(finite):
        dominated[index] = bool(
            np.any(np.all(finite <= point, axis=1) & np.any(finite < point, axis=1))
        )
    return int(np.count_nonzero(~dominated))


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    if frame.empty:
        return 0
    values = frame[column].fillna("").astype(str).str.strip()
    return int(values.loc[values.ne("")].nunique())


def numeric_max(frame: pd.DataFrame, column: str) -> float | None:
    values = numeric_series(frame, column).dropna()
    if values.empty:
        return None
    return float(values.max())


def numeric_mean(frame: pd.DataFrame, column: str) -> float | None:
    values = numeric_series(frame, column).dropna()
    if values.empty:
        return None
    return float(values.mean())


def numeric_series(frame: pd.DataFrame, column: str) -> pd.Series:
    values = pd.to_numeric(frame[column], errors="coerce")
    assert isinstance(values, pd.Series)
    return values.astype(float)


def encoder_json(encoder: LinearEncoder) -> dict[str, Any]:
    return {
        "input_mean": list(encoder.input_mean),
        "input_std": list(encoder.input_std),
        "components": [list(row) for row in encoder.components],
        "latent_mean": list(encoder.latent_mean),
        "latent_std": list(encoder.latent_std),
    }


def sha256_json(payload: dict[str, Any]) -> str:
    data = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact-dir", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--latent-dim", type=int, default=2)
    args = parser.parse_args(argv)

    summary = run_diagnostic(
        artifact_dir=args.artifact_dir,
        output_dir=args.output_dir,
        latent_dim=args.latent_dim,
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
