#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportGeneralTypeIssues=false
"""Compute RTL diversity curves through validity funnels and budgets."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path

import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CANDIDATE_AUDIT = (
    REPO_ROOT
    / "exp/diversity_check/restarted_report_20260621_060721_UTC/"
    "candidate_audit.parquet"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp0_budget_funnel_curves"
CHECKPOINTS = (0.25, 0.50, 0.75, 1.00)
GROUP_COLUMNS = (
    "corpus",
    "descriptor_family",
    "method",
    "seed",
    "model",
    "benchmark",
    "problem_id",
)
FUNNELS = (
    ("generated", ()),
    ("functional", ("functionality_pass",)),
    ("synthesis_valid", ("functionality_pass", "synthesis_pass")),
    ("valid_ppa", ("functionality_pass", "synthesis_pass", "valid_ppa")),
    (
        "pareto_front",
        ("functionality_pass", "synthesis_pass", "valid_ppa", "pareto_member"),
    ),
)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    candidates = load_candidates(args.candidate_audit)
    curves = budget_funnel_curves(candidates)
    aggregate = aggregate_curves(curves)
    write_csv(args.output_dir / "budget_funnel_curves.csv", curves)
    write_csv(args.output_dir / "budget_funnel_aggregate.csv", aggregate)
    summary = build_summary(args.output_dir, candidates, curves, aggregate)
    (args.output_dir / "budget_funnel_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_markdown(args.output_dir / "budget_funnel_report.md", summary, aggregate)
    print(json.dumps(summary, indent=2, sort_keys=True))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--candidate-audit",
        type=Path,
        default=DEFAULT_CANDIDATE_AUDIT,
        help="candidate_audit.parquet or candidate_audit.csv from the report.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory for budget/funnel curve artifacts.",
    )
    return parser.parse_args()


def load_candidates(path: Path) -> pd.DataFrame:
    assert path.is_file(), f"missing candidate audit: {path}"
    frame = pd.read_parquet(path) if path.suffix == ".parquet" else pd.read_csv(path)
    missing = set(GROUP_COLUMNS).difference(frame.columns)
    missing.update(
        {
            "generation",
            "candidate_id",
            "functionality_pass",
            "synthesis_pass",
            "valid_ppa",
            "pareto_member",
            "style_cluster",
            "canonical_netlist_hash",
            "motif_signature_hash",
            "fitness",
        }.difference(frame.columns)
    )
    assert not missing, f"{path} missing columns: {sorted(missing)}"
    return frame


def budget_funnel_curves(candidates: pd.DataFrame) -> list[dict[str, object]]:
    rows = []
    groups = candidates.groupby(list(GROUP_COLUMNS), dropna=False, sort=True)
    for keys, group in groups:
        assert isinstance(keys, tuple)
        meta = dict(zip(GROUP_COLUMNS, keys, strict=True))
        ordered = group.sort_values(["generation", "candidate_id"])
        for fraction in CHECKPOINTS:
            prefix = ordered.head(math.ceil(len(ordered) * fraction))
            for funnel_name, columns in FUNNELS:
                subset = prefix.loc[stage_mask(prefix, columns)]
                rows.append(curve_row(meta, fraction, len(prefix), funnel_name, subset))
    return rows


def stage_mask(frame: pd.DataFrame, columns: tuple[str, ...]) -> pd.Series:
    mask = pd.Series(True, index=frame.index)
    for column in columns:
        mask &= frame[column].astype(bool)
    return mask


def curve_row(
    meta: dict[str, object],
    budget_fraction: float,
    prefix_count: int,
    funnel_name: str,
    subset: pd.DataFrame,
) -> dict[str, object]:
    return {
        **meta,
        "budget_fraction": budget_fraction,
        "prefix_candidate_count": prefix_count,
        "funnel": funnel_name,
        "candidate_count": int(len(subset)),
        "unique_style_clusters": unique_nonempty(subset, "style_cluster"),
        "unique_canonical_netlists": unique_nonempty(subset, "canonical_netlist_hash"),
        "unique_motif_signatures": unique_nonempty(subset, "motif_signature_hash"),
        "pareto_member_count": int(subset["pareto_member"].astype(bool).sum())
        if len(subset)
        else 0,
        "best_fitness": finite_max(subset["fitness"]) if len(subset) else "",
        "mean_fitness": finite_mean(subset["fitness"]) if len(subset) else "",
    }


def aggregate_curves(curves: list[dict[str, object]]) -> list[dict[str, object]]:
    frame = pd.DataFrame(curves)
    rows = []
    groups = frame.groupby(
        ["corpus", "descriptor_family", "method", "budget_fraction", "funnel"],
        dropna=False,
        sort=True,
    )
    for keys, group in groups:
        corpus, descriptor_family, method, budget_fraction, funnel = keys
        rows.append(
            {
                "corpus": corpus,
                "descriptor_family": descriptor_family,
                "method": method,
                "budget_fraction": budget_fraction,
                "funnel": funnel,
                "problem_group_count": int(len(group)),
                "total_candidate_count": int(group["candidate_count"].sum()),
                "mean_candidate_count": finite_mean(group["candidate_count"]),
                "mean_style_clusters": finite_mean(group["unique_style_clusters"]),
                "mean_canonical_netlists": finite_mean(group["unique_canonical_netlists"]),
                "mean_motif_signatures": finite_mean(group["unique_motif_signatures"]),
                "mean_pareto_members": finite_mean(group["pareto_member_count"]),
                "mean_best_fitness": finite_mean(group["best_fitness"]),
            }
        )
    return rows


def build_summary(
    output_dir: Path,
    candidates: pd.DataFrame,
    curves: list[dict[str, object]],
    aggregate: list[dict[str, object]],
) -> dict[str, object]:
    return {
        "version": 1,
        "output_dir": output_dir.as_posix(),
        "candidate_count": int(len(candidates)),
        "problem_group_count": int(candidates.groupby(list(GROUP_COLUMNS)).ngroups),
        "curve_rows": len(curves),
        "aggregate_rows": len(aggregate),
        "corpus_count": int(candidates["corpus"].nunique()),
        "descriptor_family_count": int(candidates["descriptor_family"].nunique()),
        "checkpoints": list(CHECKPOINTS),
        "funnels": [name for name, _ in FUNNELS],
        "artifacts": {
            "budget_funnel_curves_csv": (
                output_dir / "budget_funnel_curves.csv"
            ).as_posix(),
            "budget_funnel_aggregate_csv": (
                output_dir / "budget_funnel_aggregate.csv"
            ).as_posix(),
            "budget_funnel_report_md": (
                output_dir / "budget_funnel_report.md"
            ).as_posix(),
        },
    }


def write_markdown(
    path: Path,
    summary: dict[str, object],
    aggregate: list[dict[str, object]],
) -> None:
    full_budget_valid = [
        row
        for row in aggregate
        if row["budget_fraction"] == 1.0 and row["funnel"] == "valid_ppa"
    ]
    lines = [
        "# RTL Diversity Budget/Funnel Curves",
        "",
        f"- Candidate rows: {summary['candidate_count']}",
        f"- Problem groups: {summary['problem_group_count']}",
        f"- Curve rows: {summary['curve_rows']}",
        f"- Aggregate rows: {summary['aggregate_rows']}",
        f"- Checkpoints: {summary['checkpoints']}",
        f"- Funnels: {summary['funnels']}",
        "",
        "## Full-Budget Valid-PPA Aggregate",
        "",
        markdown_table(full_budget_valid),
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    if frame.empty:
        return 0
    values = frame[column].dropna().astype(str).str.strip()
    values = values.loc[~values.isin(["", "nan", "NaN", "None"])]
    return int(values.nunique())


def finite_values(values: pd.Series) -> list[float]:
    parsed = pd.to_numeric(values, errors="coerce")
    return [float(value) for value in parsed if not math.isnan(float(value))]


def finite_max(values: pd.Series) -> float | str:
    finite = finite_values(values)
    return max(finite) if finite else ""


def finite_mean(values: pd.Series) -> float | str:
    finite = finite_values(values)
    return sum(finite) / len(finite) if finite else ""


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    fieldnames = sorted({key for row in rows for key in row})
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def markdown_table(rows: list[dict[str, object]]) -> str:
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


if __name__ == "__main__":
    main()
