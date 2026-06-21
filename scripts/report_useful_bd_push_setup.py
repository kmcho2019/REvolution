#!/usr/bin/env python3
"""Prepare setup artifacts for the useful-BD research push."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
REVAMP_ROOT = (
    REPO_ROOT
    / "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push"
)
DEFAULT_CANDIDATE_AUDIT = (
    REPO_ROOT
    / "exp/diversity_check/restarted_report_20260621_075346_UTC/candidate_audit.parquet"
)
DEFAULT_WP0_DESCRIPTOR_ROWS = (
    REPO_ROOT
    / "exp/diversity_check/wp0_stnod_sr_replay_20260621_041018_UTC/"
    / "wp0_descriptor_rows.parquet"
)
DEFAULT_OUTPUT_ROOT = REPO_ROOT / "exp/useful_bd_push"
REQUIRED_METHODS = {
    "classic_revolution",
    "landing_smooth_qd_manual_bd",
    "random_descriptor_qd",
    "synthesis_trajectory_nod",
    "sr_random_relu_pca_qd",
}
FORCE_INCLUDE = {
    "RTLLM/Prob045_alu",
    "VerilogEval-Spec-to-RTL/Prob153_gshare",
}
DEFAULT_SUBSET_SIZE = 10


@dataclass(frozen=True)
class SetupPaths:
    output_root: Path
    docs_root: Path
    setup_dir: Path
    docs_table_dir: Path


def build_setup(
    *,
    candidate_audit: Path,
    wp0_descriptor_rows: Path,
    output_root: Path,
    docs_root: Path,
    timestamp: str,
    subset_size: int,
) -> dict[str, Any]:
    """Build repeatable setup tables for the useful-BD push."""

    assert candidate_audit.is_file(), candidate_audit
    assert wp0_descriptor_rows.is_file(), wp0_descriptor_rows
    assert subset_size >= len(FORCE_INCLUDE), subset_size
    paths = setup_paths(output_root, docs_root, timestamp)
    audit = pd.read_parquet(candidate_audit)
    wp0_rows = pd.read_parquet(wp0_descriptor_rows)
    candidates = screening_candidates(audit)
    frozen = select_subset(candidates, subset_size)
    holdout = select_holdout(candidates, frozen, max(0, len(candidates) - subset_size))
    inventory = source_inventory(candidate_audit, wp0_descriptor_rows, audit, wp0_rows)
    context = run_context(paths, timestamp, frozen, holdout, inventory)
    write_artifacts(paths, candidates, frozen, holdout, inventory, context)
    append_ledger(paths.output_root / "run_ledger.jsonl", context)
    return context


def setup_paths(output_root: Path, docs_root: Path, timestamp: str) -> SetupPaths:
    setup_dir = output_root / f"setup_{timestamp}"
    docs_table_dir = docs_root / "tables"
    setup_dir.mkdir(parents=True, exist_ok=True)
    docs_table_dir.mkdir(parents=True, exist_ok=True)
    (output_root / "envs").mkdir(parents=True, exist_ok=True)
    (output_root / "sources").mkdir(parents=True, exist_ok=True)
    return SetupPaths(output_root, docs_root, setup_dir, docs_table_dir)


def screening_candidates(audit: pd.DataFrame) -> pd.DataFrame:
    required = {
        "corpus",
        "method",
        "problem_id",
        "candidate_id",
        "valid_ppa",
        "area",
        "power",
        "eff_clk_period",
        "canonical_netlist_hash",
        "motif_signature_hash",
    }
    assert not required.difference(audit.columns), sorted(required.difference(audit.columns))
    compared = audit.loc[
        audit["corpus"].eq("auto_bd_standard_results")
        & audit["problem_id"].map(is_standard_problem)
    ].copy()
    assert not compared.empty, "missing compared Auto-BD candidate rows"
    rows: list[dict[str, Any]] = []
    for problem_id, group in compared.groupby("problem_id", sort=True):
        valid = group.loc[group["valid_ppa"].eq(True)]
        methods = sorted(set(group["method"].dropna().astype(str)))
        unique_netlists = nonempty_nunique(valid["canonical_netlist_hash"])
        valid_count = int(len(valid))
        duplicate_rate = 1.0 - unique_netlists / valid_count if valid_count else 1.0
        rows.append(
            {
                "problem_id": problem_id,
                "stratum": problem_stratum(problem_id),
                "available_methods": ",".join(methods),
                "method_count": len(methods),
                "generated_count": int(len(group)),
                "valid_ppa_count": valid_count,
                "classic_valid_ppa_count": int(
                    (
                        group["method"].eq("classic_revolution")
                        & group["valid_ppa"].eq(True)
                    ).sum()
                ),
                "manual_valid_ppa_count": int(
                    (
                        group["method"].eq("landing_smooth_qd_manual_bd")
                        & group["valid_ppa"].eq(True)
                    ).sum()
                ),
                "ppa_variance": ppa_variance(valid),
                "pareto_size": pareto_size(valid),
                "unique_netlist_count": unique_netlists,
                "unique_family_count": nonempty_nunique(valid["motif_signature_hash"]),
                "duplicate_rate": duplicate_rate,
                "missing_artifact_penalty": int(not REQUIRED_METHODS.issubset(methods)),
                "force_include": problem_id in FORCE_INCLUDE,
            }
        )
    frame = pd.DataFrame(rows)
    for column in ("ppa_variance", "pareto_size", "unique_family_count"):
        frame[f"{column}_rank"] = frame[column].rank(method="average", pct=True)
    frame["duplicate_rate_rank"] = frame["duplicate_rate"].rank(method="average", pct=True)
    frame["selection_score"] = (
        frame["ppa_variance_rank"]
        + frame["pareto_size_rank"]
        + frame["unique_family_count_rank"]
        - frame["duplicate_rate_rank"]
        - frame["missing_artifact_penalty"]
    )
    return frame.sort_values(["selection_score", "valid_ppa_count"], ascending=False)


def select_subset(candidates: pd.DataFrame, subset_size: int) -> pd.DataFrame:
    selected: list[str] = []
    reasons: dict[str, str] = {}
    forced = candidates.loc[candidates["force_include"].eq(True)]
    for problem_id in forced["problem_id"].astype(str).tolist():
        selected.append(problem_id)
        reasons[problem_id] = "forced_prior_signal"
    for stratum, group in candidates.groupby("stratum", sort=True):
        if len(selected) >= subset_size:
            break
        if any(str(candidates.loc[candidates["problem_id"].eq(pid), "stratum"].iloc[0]) == stratum for pid in selected):
            continue
        row = group.sort_values("selection_score", ascending=False).iloc[0]
        selected.append(str(row["problem_id"]))
        reasons[str(row["problem_id"])] = f"stratum_seed:{stratum}"
    for row in candidates.sort_values("selection_score", ascending=False).to_dict("records"):
        if len(selected) >= subset_size:
            break
        problem_id = str(row["problem_id"])
        if problem_id in selected:
            continue
        selected.append(problem_id)
        reasons[problem_id] = "score_fill"
    assert len(selected) == subset_size, selected
    frame = candidates.loc[candidates["problem_id"].isin(selected)].copy()
    frame["selection_reason"] = frame["problem_id"].map(reasons)
    frame["screening_rank"] = frame["problem_id"].map(
        {problem_id: index + 1 for index, problem_id in enumerate(selected)}
    )
    return frame.sort_values("screening_rank")


def select_holdout(
    candidates: pd.DataFrame,
    frozen: pd.DataFrame,
    holdout_size: int,
) -> pd.DataFrame:
    if holdout_size == 0:
        return candidates.head(0).copy()
    frozen_ids = set(frozen["problem_id"])
    holdout = (
        candidates.loc[~candidates["problem_id"].isin(list(frozen_ids))]
        .head(holdout_size)
        .copy()
    )
    holdout["selection_reason"] = "same_rule_holdout"
    holdout["screening_rank"] = np.arange(len(holdout), dtype=np.int64) + 1
    return holdout


def source_inventory(
    candidate_audit: Path,
    wp0_descriptor_rows: Path,
    audit: pd.DataFrame,
    wp0_rows: pd.DataFrame,
) -> pd.DataFrame:
    rows = [
        inventory_row("candidate_audit", candidate_audit, len(audit)),
        inventory_row("wp0_descriptor_rows", wp0_descriptor_rows, len(wp0_rows)),
        {
            "source_name": "aspdac_release_copy",
            "path": (
                "exp/diversity_check/aspdac2026_submission_source/"
                "REvolution-aspdac2026-submission/exp"
            ),
            "exists": Path(
                "exp/diversity_check/aspdac2026_submission_source/"
                "REvolution-aspdac2026-submission/exp"
            ).is_dir(),
            "rows": "",
            "sha256": "",
            "notes": "local copied ASP-DAC source run root",
        },
    ]
    return pd.DataFrame(rows)


def inventory_row(source_name: str, path: Path, rows: int) -> dict[str, Any]:
    return {
        "source_name": source_name,
        "path": path.as_posix(),
        "exists": path.is_file(),
        "rows": rows,
        "sha256": sha256_file(path),
        "notes": "replay input",
    }


def run_context(
    paths: SetupPaths,
    timestamp: str,
    frozen: pd.DataFrame,
    holdout: pd.DataFrame,
    inventory: pd.DataFrame,
) -> dict[str, Any]:
    return {
        "version": 1,
        "timestamp": timestamp,
        "git_branch": git_output("rev-parse", "--abbrev-ref", "HEAD"),
        "git_head": git_output("rev-parse", "HEAD"),
        "dirty_status": git_output("status", "--short", "--untracked-files=all").splitlines(),
        "output_root": paths.output_root.as_posix(),
        "setup_dir": paths.setup_dir.as_posix(),
        "docs_table_dir": paths.docs_table_dir.as_posix(),
        "frozen_subset_size": int(len(frozen)),
        "holdout_size": int(len(holdout)),
        "frozen_problem_ids": frozen["problem_id"].tolist(),
        "holdout_problem_ids": holdout["problem_id"].tolist(),
        "source_inventory": inventory.to_dict("records"),
    }


def write_artifacts(
    paths: SetupPaths,
    candidates: pd.DataFrame,
    frozen: pd.DataFrame,
    holdout: pd.DataFrame,
    inventory: pd.DataFrame,
    context: dict[str, Any],
) -> None:
    write_table_pair(candidates, paths, "screening_subset_candidates.csv")
    write_table_pair(frozen, paths, "frozen_screening_subset.csv")
    write_table_pair(holdout, paths, "holdout_screening_subset.csv")
    write_table_pair(inventory, paths, "source_inventory.csv")
    (paths.setup_dir / "run_context.json").write_text(
        json.dumps(context, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (paths.output_root / "README.md").write_text(output_readme(paths), encoding="utf-8")


def write_table_pair(frame: pd.DataFrame, paths: SetupPaths, name: str) -> None:
    frame.to_csv(paths.setup_dir / name, index=False)
    frame.to_csv(paths.docs_table_dir / name, index=False)


def append_ledger(path: Path, context: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(context, sort_keys=True) + "\n")


def output_readme(paths: SetupPaths) -> str:
    return "\n".join(
        [
            "# Useful-BD Push Outputs",
            "",
            "This ignored experiment root stores replay setup and method run outputs.",
            "",
            f"- Latest setup root: `{paths.setup_dir}`",
            "- `run_ledger.jsonl` is append-only.",
            "- `envs/` holds isolated uv environments when repo `.venv` is too constrained.",
            "- `sources/` holds external method checkouts before any submodule decision.",
            "",
        ]
    )


def is_standard_problem(problem_id: object) -> bool:
    text = str(problem_id)
    return text.startswith("RTLLM/") or text.startswith("VerilogEval-Spec-to-RTL/")


def problem_stratum(problem_id: str) -> str:
    lower = problem_id.lower()
    if any(token in lower for token in ("ram", "rom", "fifo", "buffer", "gshare")):
        return "memory_interface"
    if any(token in lower for token in ("fsm", "traffic", "sequence", "circuit", "m2014")):
        return "control_sequential"
    if any(token in lower for token in ("shift", "parallel", "serial", "lfsr")):
        return "bit_vector"
    return "arithmetic_datapath"


def ppa_variance(valid: pd.DataFrame) -> float:
    if valid.empty:
        return 0.0
    values = valid[["area", "power", "eff_clk_period"]].dropna().to_numpy(dtype=float)
    if values.size == 0:
        return 0.0
    means = np.abs(values.mean(axis=0)) + 1e-12
    return float(np.mean(values.std(axis=0) / means))


def pareto_size(valid: pd.DataFrame) -> int:
    values = valid[["area", "power", "eff_clk_period"]].dropna().to_numpy(dtype=float)
    count = 0
    for index, point in enumerate(values):
        dominated = any(
            other_index != index
            and bool(np.all(other <= point))
            and bool(np.any(other < point))
            for other_index, other in enumerate(values)
        )
        if not dominated:
            count += 1
    return count


def nonempty_nunique(series: pd.Series) -> int:
    values = series.dropna().astype(str)
    values = values.loc[values.ne("") & values.ne("None") & values.ne("nan")]
    return int(values.nunique())


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_output(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=REPO_ROOT, text=True).strip()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-audit", type=Path, default=DEFAULT_CANDIDATE_AUDIT)
    parser.add_argument("--wp0-descriptor-rows", type=Path, default=DEFAULT_WP0_DESCRIPTOR_ROWS)
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    parser.add_argument("--docs-root", type=Path, default=REVAMP_ROOT)
    parser.add_argument("--timestamp", required=True)
    parser.add_argument("--subset-size", type=int, default=DEFAULT_SUBSET_SIZE)
    args = parser.parse_args(argv)
    summary = build_setup(
        candidate_audit=args.candidate_audit,
        wp0_descriptor_rows=args.wp0_descriptor_rows,
        output_root=args.output_root,
        docs_root=args.docs_root,
        timestamp=args.timestamp,
        subset_size=args.subset_size,
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
