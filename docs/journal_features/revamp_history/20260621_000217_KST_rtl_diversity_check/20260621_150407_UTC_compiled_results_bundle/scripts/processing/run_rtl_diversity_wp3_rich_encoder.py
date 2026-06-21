#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportGeneralTypeIssues=false
"""Run a richer implementation-only WP3 encoder diagnostic."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from dataclasses import dataclass
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
    / "exp/diversity_check/restarted_report_20260621_062641_UTC/candidate_audit.parquet"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp3_rich_encoder"
LEXICAL_FEATURES = (
    "rtl_line_count",
    "rtl_assign_count",
    "rtl_always_count",
    "rtl_case_count",
    "rtl_if_count",
    "rtl_ternary_count",
    "rtl_nonblocking_count",
    "rtl_blocking_count",
    "rtl_add_count",
    "rtl_mul_count",
    "rtl_wire_count",
    "rtl_reg_count",
    "rtl_comment_count",
)
VALIDITY_FEATURES = ("syntax_pass", "functionality_pass", "synthesis_pass")
MOTIF_KEYS = (
    "motif_arith_ratio",
    "motif_control_ratio",
    "motif_diversity",
    "motif_logic_ratio",
)
DESCRIPTOR_DIM = 5
STYLE_CLUSTERS = (
    "arithmetic_additive",
    "arithmetic_multiply",
    "auto_bd_control",
    "control_case",
    "control_if",
    "invalid_no_ppa",
    "mux_ternary",
    "other_structural",
    "register_sequential",
    "wire_assign",
)
NOVELTY_FRACTIONS = (0.0, 0.1, 0.25, 0.5)
DEFAULT_LATENT_DIMS = (8, 16)
FORBIDDEN_TRAINING_INPUTS = (
    "area",
    "power",
    "eff_clk_period",
    "fitness",
    "ppa_hypervolume_contribution",
    "valid_ppa",
    "pareto_member",
    "openroad_pass",
    "archive_cell_id",
    "problem_id",
    "candidate_id",
    "prompt_hash",
    "model",
    "model_id",
)


@dataclass(frozen=True)
class LinearEncoder:
    """Frozen linear bottleneck fitted without PPA labels."""

    latent_dim: int
    input_mean: tuple[float, ...]
    input_std: tuple[float, ...]
    components: tuple[tuple[float, ...], ...]
    latent_mean: tuple[float, ...]
    latent_std: tuple[float, ...]


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    summary = run_diagnostic(
        candidate_audit=args.candidate_audit,
        output_dir=args.output_dir,
        latent_dims=tuple(args.latent_dims),
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-audit", type=Path, default=DEFAULT_CANDIDATE_AUDIT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--latent-dims", type=int, nargs="+", default=DEFAULT_LATENT_DIMS)
    return parser.parse_args(argv)


def run_diagnostic(
    *,
    candidate_audit: Path,
    output_dir: Path,
    latent_dims: tuple[int, ...],
) -> dict[str, Any]:
    """Fit rich implementation-only bottlenecks and replay held-out novelty."""

    assert latent_dims
    rows = load_candidates(candidate_audit)
    rows = add_problem_split(rows)
    feature_frame, feature_columns = implementation_feature_frame(rows)
    train_mask = rows["split"].eq("train")
    train_matrix = feature_frame.loc[train_mask, feature_columns].to_numpy(dtype=float)
    full_matrix = feature_frame.loc[:, feature_columns].to_numpy(dtype=float)
    encoders = [fit_linear_encoder(train_matrix, latent_dim=dim) for dim in latent_dims]
    encoded = add_representations(rows, full_matrix, feature_columns, encoders)
    replay = replay_rows(encoded, encoders)
    comparison = holdout_comparison(replay, encoders)
    summary = summary_payload(
        candidate_audit=candidate_audit,
        output_dir=output_dir,
        rows=encoded,
        feature_columns=feature_columns,
        encoders=encoders,
        replay=replay,
        comparison=comparison,
    )

    output_dir.mkdir(parents=True, exist_ok=True)
    encoded.to_parquet(output_dir / "wp3_rich_encoder_rows.parquet", index=False)
    replay.to_csv(output_dir / "wp3_rich_encoder_replay.csv", index=False)
    write_method_card(output_dir / "wp3_rich_encoder_card.md", summary)
    write_feature_manifest(
        output_dir / "wp3_rich_encoder_feature_manifest.csv",
        feature_columns,
    )
    summary["artifact_sha256"] = {
        "wp3_rich_encoder_rows.parquet": sha256_file(
            output_dir / "wp3_rich_encoder_rows.parquet"
        ),
        "wp3_rich_encoder_replay.csv": sha256_file(
            output_dir / "wp3_rich_encoder_replay.csv"
        ),
        "wp3_rich_encoder_feature_manifest.csv": sha256_file(
            output_dir / "wp3_rich_encoder_feature_manifest.csv"
        ),
        "wp3_rich_encoder_card.md": sha256_file(
            output_dir / "wp3_rich_encoder_card.md"
        ),
    }
    (output_dir / "wp3_rich_encoder_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    summary["artifact_sha256"]["wp3_rich_encoder_summary.json"] = sha256_file(
        output_dir / "wp3_rich_encoder_summary.json"
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
        "syntax_pass",
        "functionality_pass",
        "synthesis_pass",
        "area",
        "power",
        "eff_clk_period",
        "fitness",
        "reference_ppa_json",
        "descriptor_vector",
        "canonical_netlist_hash",
        "motif_signature_hash",
        "motif_vector",
        "style_cluster",
        *LEXICAL_FEATURES,
    }
    missing = required.difference(frame.columns)
    assert not missing, f"candidate audit missing columns: {sorted(missing)}"
    return frame.reset_index(drop=True)


def add_problem_split(frame: pd.DataFrame) -> pd.DataFrame:
    problems = sorted(frame["problem_id"].astype(str).unique())
    assert len(problems) >= 3
    holdout = {problem for index, problem in enumerate(problems) if index % 3 == 0}
    rows = frame.copy()
    rows["split"] = rows["problem_id"].map(
        lambda problem: "holdout" if str(problem) in holdout else "train"
    )
    assert rows["split"].eq("train").any()
    assert rows["split"].eq("holdout").any()
    return rows


def implementation_feature_frame(
    rows: pd.DataFrame,
) -> tuple[pd.DataFrame, tuple[str, ...]]:
    frame = pd.DataFrame(index=rows.index)
    for column in LEXICAL_FEATURES:
        frame[column] = numeric_series(rows, column).fillna(0.0)
    for column in VALIDITY_FEATURES:
        frame[column] = rows[column].astype(bool).astype(float)
    descriptor = np.vstack(rows["descriptor_vector"].map(descriptor_values).to_list())
    for index in range(DESCRIPTOR_DIM):
        frame[f"descriptor_{index}"] = descriptor[:, index]
    motif = np.vstack(rows["motif_vector"].map(motif_values).to_list())
    for index, key in enumerate(MOTIF_KEYS):
        frame[key] = motif[:, index]
    for cluster in STYLE_CLUSTERS:
        frame[f"style_{cluster}"] = rows["style_cluster"].astype(str).eq(cluster).astype(float)
    frame["has_canonical_netlist_hash"] = nonempty(rows["canonical_netlist_hash"])
    frame["has_motif_signature_hash"] = nonempty(rows["motif_signature_hash"])
    feature_columns = tuple(frame.columns)
    return frame, feature_columns


def descriptor_values(value: object) -> np.ndarray:
    values = parse_list(value)
    padded = values[:DESCRIPTOR_DIM] + [0.0] * max(DESCRIPTOR_DIM - len(values), 0)
    return np.array(padded[:DESCRIPTOR_DIM], dtype=float)


def motif_values(value: object) -> np.ndarray:
    text = str(value).strip()
    if not text or text in {"[]", "nan", "None"}:
        return np.zeros(len(MOTIF_KEYS), dtype=float)
    loaded = json.loads(text)
    assert isinstance(loaded, dict), f"expected motif dict: {text[:80]}"
    return np.array([float(loaded.get(key, 0.0)) for key in MOTIF_KEYS], dtype=float)


def parse_list(value: object) -> list[float]:
    text = str(value).strip()
    if not text or text in {"[]", "nan", "None"}:
        return []
    loaded = json.loads(text)
    assert isinstance(loaded, list), f"expected descriptor list: {text[:80]}"
    return [float(item) for item in loaded]


def fit_linear_encoder(matrix: np.ndarray, *, latent_dim: int) -> LinearEncoder:
    assert matrix.ndim == 2
    assert 1 <= latent_dim <= matrix.shape[1]
    assert matrix.shape[0] > latent_dim
    mean = matrix.mean(axis=0)
    std = matrix.std(axis=0)
    std = np.where(std == 0.0, 1.0, std)
    z = (matrix - mean) / std
    _u, _s, vh = np.linalg.svd(z, full_matrices=False)
    components = vh[:latent_dim].copy()
    latent = z @ components.T
    latent_mean = latent.mean(axis=0)
    latent_std = latent.std(axis=0)
    latent_std = np.where(latent_std == 0.0, 1.0, latent_std)
    return LinearEncoder(
        latent_dim=latent_dim,
        input_mean=tuple(float(value) for value in mean),
        input_std=tuple(float(value) for value in std),
        components=tuple(tuple(float(value) for value in row) for row in components),
        latent_mean=tuple(float(value) for value in latent_mean),
        latent_std=tuple(float(value) for value in latent_std),
    )


def add_representations(
    rows: pd.DataFrame,
    matrix: np.ndarray,
    feature_columns: tuple[str, ...],
    encoders: list[LinearEncoder],
) -> pd.DataFrame:
    result = rows.copy()
    baseline = standardize(matrix, encoders[0].input_mean, encoders[0].input_std)
    for index, column in enumerate(feature_columns):
        result[f"implementation_z_{index:02d}_{column}"] = baseline[:, index]
    for encoder in encoders:
        z = standardize(matrix, encoder.input_mean, encoder.input_std)
        components = np.array(encoder.components, dtype=float)
        latent = z @ components.T
        latent_z = standardize(latent, encoder.latent_mean, encoder.latent_std)
        reconstruction = (latent @ components) * np.array(
            encoder.input_std, dtype=float
        ) + np.array(encoder.input_mean, dtype=float)
        result[f"rich_ae{encoder.latent_dim}_reconstruction_mse"] = np.mean(
            (matrix - reconstruction) ** 2,
            axis=1,
        )
        for index in range(encoder.latent_dim):
            result[f"rich_ae{encoder.latent_dim}_{index}"] = latent_z[:, index]
    return result


def replay_rows(frame: pd.DataFrame, encoders: list[LinearEncoder]) -> pd.DataFrame:
    valid = frame.loc[frame["valid_ppa"].astype(bool)].copy()
    specs = [
        (
            "implementation_z",
            tuple(column for column in frame.columns if column.startswith("implementation_z_")),
        )
    ]
    for encoder in encoders:
        specs.append(
            (
                f"rich_ae{encoder.latent_dim}",
                tuple(
                    f"rich_ae{encoder.latent_dim}_{index}"
                    for index in range(encoder.latent_dim)
                ),
            )
        )
    rows: list[dict[str, Any]] = []
    groups = valid.groupby(
        ["split", "corpus", "descriptor_family", "method", "seed", "problem_id"],
        dropna=False,
        sort=True,
    )
    for key, group in groups:
        split, corpus, family, method, seed, problem = key
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
                        "corpus": corpus,
                        "descriptor_family": family,
                        "method": method,
                        "seed": int(seed),
                        "problem_id": problem,
                        "representation": representation,
                        "novelty_parent_fraction": novelty_fraction,
                        "quality_floor_value": quality_floor,
                        "valid_ppa_count": int(len(ordered)),
                        "selected_count": int(len(selected)),
                        "valid_ppa_coverage_delta": 0.0,
                        "unique_canonical_netlists": unique_nonempty(
                            selected, "canonical_netlist_hash"
                        ),
                        "unique_motif_signatures": unique_nonempty(
                            selected, "motif_signature_hash"
                        ),
                        "unique_style_clusters": unique_nonempty(
                            selected, "style_cluster"
                        ),
                        "pareto_size": pareto_size(selected),
                        "hypervolume": selected_hypervolume(selected),
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
    selected_indices = list(selected.index)
    remaining = eligible.drop(index=selected_indices)
    if len(selected_indices) == pool_size or remaining.empty:
        return eligible.loc[selected_indices]

    selected_matrix = eligible.loc[selected_indices, columns].to_numpy(dtype=float)
    remaining_indices = remaining.index.to_numpy()
    remaining_matrix = remaining.loc[:, columns].to_numpy(dtype=float)
    remaining_fitness = numeric_series(remaining, "fitness").to_numpy(dtype=float)
    min_distances = distance_to_selected(remaining_matrix, selected_matrix)
    while len(selected_indices) < pool_size and len(remaining_indices):
        pick_position = best_novelty_position(min_distances, remaining_fitness)
        picked_index = remaining_indices[pick_position]
        selected_indices.append(picked_index)
        picked_vector = remaining_matrix[pick_position : pick_position + 1]
        keep = np.ones(len(remaining_indices), dtype=bool)
        keep[pick_position] = False
        remaining_indices = remaining_indices[keep]
        remaining_matrix = remaining_matrix[keep]
        remaining_fitness = remaining_fitness[keep]
        min_distances = np.minimum(
            min_distances[keep],
            distance_to_selected(remaining_matrix, picked_vector),
        )
    return eligible.loc[selected_indices]


def distance_to_selected(remaining: np.ndarray, selected: np.ndarray) -> np.ndarray:
    if len(remaining) == 0:
        return np.array([], dtype=float)
    distances = np.linalg.norm(remaining[:, None, :] - selected[None, :, :], axis=2)
    return distances.min(axis=1)


def best_novelty_position(distances: np.ndarray, fitness: np.ndarray) -> int:
    order = np.lexsort((fitness, distances))
    return int(order[-1])


def holdout_comparison(
    replay: pd.DataFrame,
    encoders: list[LinearEncoder],
) -> dict[str, Any]:
    holdout = replay.loc[
        replay["split"].eq("holdout") & replay["novelty_parent_fraction"].eq(0.5)
    ]
    grouped = (
        holdout.groupby("representation", as_index=False)
        .agg(
            selected_count=("selected_count", "sum"),
            unique_canonical_netlists=("unique_canonical_netlists", "sum"),
            unique_motif_signatures=("unique_motif_signatures", "sum"),
            unique_style_clusters=("unique_style_clusters", "sum"),
            pareto_size=("pareto_size", "sum"),
            hypervolume=("hypervolume", "sum"),
            best_fitness=("best_fitness", "max"),
            mean_fitness=("mean_fitness", "mean"),
        )
        .set_index("representation")
    )
    baseline = grouped.loc["implementation_z"]
    comparisons = []
    for encoder in encoders:
        name = f"rich_ae{encoder.latent_dim}"
        row = grouped.loc[name]
        hv_gain = float(row["hypervolume"] - baseline["hypervolume"])
        hv_gain_fraction = hv_gain / max(float(baseline["hypervolume"]), 1e-12)
        best_fitness_delta = float(row["best_fitness"] - baseline["best_fitness"])
        pareto_gain_fraction = float(row["pareto_size"] - baseline["pareto_size"]) / max(
            float(baseline["pareto_size"]),
            1.0,
        )
        valid_coverage_delta = 0.0
        verdict = (
            "diagnostic_follow_up"
            if hv_gain_fraction >= 0.10
            and best_fitness_delta >= -1e-9
            and valid_coverage_delta >= -0.05
            else "diagnostic_only_no_proceed"
        )
        comparisons.append(
            {
                "representation": name,
                "baseline": "implementation_z",
                "hypervolume_gain": hv_gain,
                "hypervolume_gain_fraction": hv_gain_fraction,
                "pareto_gain_fraction": pareto_gain_fraction,
                "best_fitness_delta": best_fitness_delta,
                "valid_ppa_coverage_delta": valid_coverage_delta,
                "verdict": verdict,
            }
        )
    return {
        "holdout_novelty_fraction": 0.5,
        "aggregate": grouped.reset_index().to_dict("records"),
        "comparisons": comparisons,
        "verdict": (
            "diagnostic_follow_up"
            if any(row["verdict"] == "diagnostic_follow_up" for row in comparisons)
            else "diagnostic_only_no_proceed"
        ),
    }


def summary_payload(
    *,
    candidate_audit: Path,
    output_dir: Path,
    rows: pd.DataFrame,
    feature_columns: tuple[str, ...],
    encoders: list[LinearEncoder],
    replay: pd.DataFrame,
    comparison: dict[str, Any],
) -> dict[str, Any]:
    train = rows.loc[rows["split"].eq("train")]
    holdout = rows.loc[rows["split"].eq("holdout")]
    encoder_rows = []
    for encoder in encoders:
        latent_columns = [f"rich_ae{encoder.latent_dim}_{i}" for i in range(encoder.latent_dim)]
        encoder_rows.append(
            {
                "representation": f"rich_ae{encoder.latent_dim}",
                "latent_dim": encoder.latent_dim,
                "encoder_hash": sha256_json(encoder_json(encoder)),
                "latent_std": list(encoder.latent_std),
                "train_reconstruction_mse": float(
                    train[f"rich_ae{encoder.latent_dim}_reconstruction_mse"].mean()
                ),
                "holdout_reconstruction_mse": float(
                    holdout[f"rich_ae{encoder.latent_dim}_reconstruction_mse"].mean()
                ),
                "pairwise_cosine": pairwise_cosine_summary(
                    rows.loc[:, latent_columns].to_numpy(dtype=float)
                ),
            }
        )
    return {
        "version": 1,
        "family": "aurora_rich_implementation_linear_autoencoder_probe",
        "candidate_audit": candidate_audit.as_posix(),
        "out_dir": output_dir.as_posix(),
        "training_protocol": "fixed_offline_problem_split_all_candidates",
        "fitting_inputs": list(feature_columns),
        "feature_groups": {
            "lexical": list(LEXICAL_FEATURES),
            "validity": list(VALIDITY_FEATURES),
            "descriptor": [f"descriptor_{index}" for index in range(DESCRIPTOR_DIM)],
            "motif": list(MOTIF_KEYS),
            "style": [f"style_{cluster}" for cluster in STYLE_CLUSTERS],
            "hash_availability": [
                "has_canonical_netlist_hash",
                "has_motif_signature_hash",
            ],
        },
        "forbidden_training_inputs": list(FORBIDDEN_TRAINING_INPUTS),
        "candidate_count": int(len(rows)),
        "train_candidate_count": int(len(train)),
        "holdout_candidate_count": int(len(holdout)),
        "valid_ppa_candidate_count": int(rows["valid_ppa"].astype(bool).sum()),
        "train_problem_count": int(train["problem_id"].astype(str).nunique()),
        "holdout_problem_count": int(holdout["problem_id"].astype(str).nunique()),
        "input_dim": len(feature_columns),
        "encoders": encoder_rows,
        "replay_rows": int(len(replay)),
        "comparison": comparison,
    }


def write_method_card(path: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# WP3 Rich Encoder Diagnostic Card",
        "",
        f"- Family: `{summary['family']}`",
        "- Status: diagnostic-only replay probe.",
        "- Training split: problem-held-out over all candidate rows.",
        f"- Input dimension: {summary['input_dim']}",
        "- Forbidden fitting inputs: "
        + ", ".join(f"`{name}`" for name in summary["forbidden_training_inputs"]),
        f"- Train candidates: {summary['train_candidate_count']}",
        f"- Holdout candidates: {summary['holdout_candidate_count']}",
        f"- Valid-PPA candidates for replay: {summary['valid_ppa_candidate_count']}",
        f"- Replay rows: {summary['replay_rows']}",
        f"- Verdict: `{summary['comparison']['verdict']}`",
        "",
        "This probe trains frozen linear bottlenecks on implementation-side "
        "features only: RTL lexical counts, syntax/function/synthesis stages, "
        "available descriptor vectors, netlist motif ratios, style clusters, "
        "and hash availability flags. It evaluates utility only after freezing "
        "the encoder, through held-out quality-gated replay.",
        "",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def write_feature_manifest(path: Path, feature_columns: tuple[str, ...]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["index", "feature"])
        writer.writeheader()
        for index, feature in enumerate(feature_columns):
            writer.writerow({"index": index, "feature": feature})


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


def pareto_size(frame: pd.DataFrame) -> int:
    points = improvement_points(frame)
    return len(pareto_front(points)) if points else 0


def pairwise_cosine_summary(matrix: np.ndarray) -> dict[str, float]:
    sample = matrix[: min(len(matrix), 512)]
    norms = np.linalg.norm(sample, axis=1)
    keep = norms > 0.0
    sample = sample[keep]
    norms = norms[keep]
    if len(sample) < 2:
        return {"sample_count": float(len(sample)), "mean": 1.0, "min": 1.0, "max": 1.0}
    normalized = sample / norms[:, None]
    values = normalized @ normalized.T
    upper = values[np.triu_indices(len(values), k=1)]
    return {
        "sample_count": float(len(sample)),
        "mean": float(upper.mean()),
        "min": float(upper.min()),
        "max": float(upper.max()),
    }


def standardize(
    matrix: np.ndarray,
    mean_values: tuple[float, ...],
    std_values: tuple[float, ...],
) -> np.ndarray:
    return (matrix - np.array(mean_values, dtype=float)) / np.array(
        std_values,
        dtype=float,
    )


def nonempty(values: pd.Series) -> pd.Series:
    text = values.fillna("").astype(str).str.strip()
    return text.ne("").astype(float)


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    if frame.empty:
        return 0
    text = frame[column].fillna("").astype(str).str.strip()
    return int(text.loc[text.ne("")].nunique())


def numeric_series(frame: pd.DataFrame, column: str) -> pd.Series:
    values = pd.to_numeric(frame[column], errors="coerce")
    assert isinstance(values, pd.Series)
    return values.astype(float)


def numeric_max(frame: pd.DataFrame, column: str) -> float | None:
    values = numeric_series(frame, column).dropna()
    return None if values.empty else float(values.max())


def numeric_mean(frame: pd.DataFrame, column: str) -> float | None:
    values = numeric_series(frame, column).dropna()
    return None if values.empty else float(values.mean())


def encoder_json(encoder: LinearEncoder) -> dict[str, Any]:
    return {
        "latent_dim": encoder.latent_dim,
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


if __name__ == "__main__":
    raise SystemExit(main())
