#!/usr/bin/env python3
"""Verify MasterRTL pretrained artifacts for the T76 gate."""

from __future__ import annotations

import csv
import hashlib
import importlib
import importlib.util
import json
import os
import pickle
import subprocess
import sys
import warnings
from pathlib import Path
from types import ModuleType
from typing import Any, cast

import numpy as np


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
MASTER = ROOT / "exp/external_repos/MasterRTL"
RTLTIMER = ROOT / "exp/external_repos/RTL-Timer"
SAVED_MODEL = MASTER / "ML_model/saved_model"
SAVED_DATA = MASTER / "ML_model/saved_data"

XGB_TARGETS = ("Area", "Power", "WNS", "TNS")


def main() -> None:
    assert MASTER.is_dir()
    assert RTLTIMER.is_dir()
    os.chdir(MASTER / "ML_model/infer")

    tables = TECHNIQUE / "tables"
    tables.mkdir(exist_ok=True)
    rows, predictions = verify_masterrtl(load_preprocess())
    rtltimer_rows, rtltimer_summary = inventory_rtltimer()
    write_csv(tables / "masterrtl_model_inventory.csv", rows)
    write_json(tables / "masterrtl_example_predictions.json", predictions)
    write_csv(tables / "rtltimer_artifact_inventory.csv", rtltimer_rows)
    write_json(tables / "rtltimer_artifact_summary.json", rtltimer_summary)
    write_json(tables / "t76_verification_summary.json", summary(rows, rtltimer_summary))


def verify_masterrtl(preprocess: Any) -> tuple[list[dict[str, object]], dict[str, Any]]:
    rows: list[dict[str, object]] = []
    predictions: dict[str, Any] = {
        "masterrtl_commit": git_head(MASTER),
        "rtltimer_commit": git_head(RTLTIMER),
        "targets": {},
    }
    for target in XGB_TARGETS:
        model_path = SAVED_MODEL / f"xgboost_{target}_model.pkl"
        x, label = preprocess.load_data_test(target)
        features = np.asarray(x, dtype=float)
        assert features.ndim == 2
        model, model_warnings = load_pickle(model_path)
        assert int(model.n_features_in_) == features.shape[1]
        pred = np.asarray(model.predict(features), dtype=float)
        leaves = np.asarray(model.apply(features))
        rows.append(
            model_row(
                model_path,
                f"xgboost_{target}",
                "pickle",
                "loaded",
                type(model).__name__,
                features.shape,
                int(model.n_features_in_),
                pred,
                leaves,
                model_warnings,
            )
        )
        predictions["targets"][target] = {
            "feature_shape": list(features.shape),
            "label": np.asarray(label).tolist(),
            "prediction": pred.tolist(),
            "leaf_shape": list(leaves.shape),
            "unique_leaf_ids": int(len(set(leaves.reshape(-1).tolist()))),
            "warnings": model_warnings,
        }

    rows.extend(verify_random_forest())
    return rows, predictions


def verify_random_forest() -> list[dict[str, object]]:
    model_path = SAVED_MODEL / "rfr_model.pkl"
    rows: list[dict[str, object]] = []
    rows.append(failed_loader_row(model_path, "rfr_timing", "pickle", load_pickle))
    model, model_warnings = load_joblib(model_path)
    features = load_rf_features()[:128]
    assert int(model.n_features_in_) == features.shape[1]
    pred = np.asarray(model.predict(features), dtype=float)
    leaves = np.asarray(model.apply(features))
    rows.append(
        model_row(
            model_path,
            "rfr_timing",
            "joblib",
            "loaded",
            type(model).__name__,
            features.shape,
            int(model.n_features_in_),
            pred,
            leaves,
            model_warnings,
        )
    )
    return rows


def load_rf_features() -> np.ndarray:
    with (SAVED_DATA / "feat_all_lst.pkl").open("rb") as handle:
        features = pickle.load(handle)
    return np.asarray(features, dtype=float)


def failed_loader_row(
    path: Path,
    model_name: str,
    loader: str,
    load_fn: Any,
) -> dict[str, object]:
    try:
        load_fn(path)
    except Exception as error:
        return {
            "model": model_name,
            "loader": loader,
            "status": "failed",
            "path": str(path.relative_to(ROOT)),
            "size_bytes": path.stat().st_size,
            "sha256": sha256(path),
            "class": "",
            "feature_shape": "",
            "expected_features": "",
            "prediction_mean": "",
            "prediction_std": "",
            "prediction_min": "",
            "prediction_max": "",
            "leaf_shape": "",
            "unique_leaf_ids": "",
            "warnings": "",
            "error": f"{type(error).__name__}: {error}",
        }
    raise AssertionError(f"{loader} unexpectedly loaded {path}")


def model_row(
    path: Path,
    model_name: str,
    loader: str,
    status: str,
    class_name: str,
    feature_shape: tuple[int, ...],
    expected_features: int,
    prediction: np.ndarray,
    leaves: np.ndarray,
    model_warnings: list[str],
) -> dict[str, object]:
    return {
        "model": model_name,
        "loader": loader,
        "status": status,
        "path": str(path.relative_to(ROOT)),
        "size_bytes": path.stat().st_size,
        "sha256": sha256(path),
        "class": class_name,
        "feature_shape": "x".join(str(item) for item in feature_shape),
        "expected_features": expected_features,
        "prediction_mean": float(prediction.mean()),
        "prediction_std": float(prediction.std()),
        "prediction_min": float(prediction.min()),
        "prediction_max": float(prediction.max()),
        "leaf_shape": "x".join(str(item) for item in leaves.shape),
        "unique_leaf_ids": int(len(set(leaves.reshape(-1).tolist()))),
        "warnings": " | ".join(model_warnings),
        "error": "",
    }


def load_pickle(path: Path) -> tuple[Any, list[str]]:
    with warnings.catch_warnings(record=True) as records:
        warnings.simplefilter("always")
        with path.open("rb") as handle:
            model = pickle.load(handle)
    return model, format_warnings(records)


def load_joblib(path: Path) -> tuple[Any, list[str]]:
    joblib = cast(Any, importlib.import_module("joblib"))

    with warnings.catch_warnings(record=True) as records:
        warnings.simplefilter("always")
        model = joblib.load(path)
    return model, format_warnings(records)


def load_preprocess() -> ModuleType:
    path = MASTER / "ML_model/infer/preprocess.py"
    spec = importlib.util.spec_from_file_location("masterrtl_preprocess", path)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def format_warnings(records: list[warnings.WarningMessage]) -> list[str]:
    messages: list[str] = []
    for item in records:
        text = " ".join(str(item.message).split())
        message = f"{item.category.__name__}: {text}"
        if message not in messages:
            messages.append(message)
    return messages


def inventory_rtltimer() -> tuple[list[dict[str, object]], dict[str, object]]:
    roots = (
        RTLTIMER / "RTL_pwr_model",
        RTLTIMER / "RTL_timing_model",
        RTLTIMER / "preprocess/feat_label_pwr",
        RTLTIMER / "preprocess/feat_label_timing",
    )
    rows: list[dict[str, object]] = []
    checkpoint_rows = 0
    for root in roots:
        assert root.is_dir()
        for path in sorted(item for item in root.rglob("*") if item.is_file()):
            role = rtltimer_role(path)
            if role == "model_checkpoint_candidate":
                checkpoint_rows += 1
            rows.append(
                {
                    "path": str(path.relative_to(ROOT)),
                    "role": role,
                    "size_bytes": path.stat().st_size,
                    "sha256": sha256(path),
                }
            )
    summary = {
        "rtltimer_commit": git_head(RTLTIMER),
        "inventoried_files": len(rows),
        "model_checkpoint_candidates": checkpoint_rows,
        "pretrained_checkpoint_status": "not_confirmed",
        "note": (
            "The local RTL-Timer tree has model scripts and TinyRocket feature/"
            "label artifacts, but no confirmed packaged pretrained checkpoint "
            "under RTL_pwr_model or RTL_timing_model."
        ),
    }
    return rows, summary


def rtltimer_role(path: Path) -> str:
    if path.suffix == ".py":
        return "model_or_preprocess_script"
    if path.suffix in {".json", ".pkl"} and "feat_label" in str(path):
        return "example_feature_label_artifact"
    if path.suffix in {".joblib", ".pt", ".pth", ".onnx", ".model"}:
        return "model_checkpoint_candidate"
    return "support_artifact"


def summary(
    rows: list[dict[str, object]],
    rtltimer_summary: dict[str, object],
) -> dict[str, object]:
    loaded = [row for row in rows if row["status"] == "loaded"]
    failed = [row for row in rows if row["status"] == "failed"]
    zero_xgb = [
        row["model"]
        for row in loaded
        if str(row["model"]).startswith("xgboost_")
        and row["prediction_std"] == 0.0
        and row["prediction_mean"] == 0.0
    ]
    return {
        "tier": "T0_verification_gate_partial",
        "masterrtl_commit": git_head(MASTER),
        "rtltimer_commit": git_head(RTLTIMER),
        "loaded_model_rows": len(loaded),
        "failed_model_rows": len(failed),
        "zero_tinyrocket_xgboost_predictions": zero_xgb,
        "rtltimer_pretrained_checkpoint_status": rtltimer_summary[
            "pretrained_checkpoint_status"
        ],
        "decision": (
            "MasterRTL pretrained artifacts are real and loadable through the "
            "verified isolated environment, but candidate-output variation and "
            "upstream parity still gate any live pretrained-model BD claim."
        ),
    }


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_head(path: Path) -> str:
    return subprocess.check_output(
        ["git", "-C", str(path), "rev-parse", "HEAD"],
        text=True,
    ).strip()


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(rows[0].keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, data: object) -> None:
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
