#!/usr/bin/env python3
"""Package the T31 fail-feedback repair holdout audit."""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path

import scripts.package_t30_holdout_front_audit as holdout
from scripts.package_t28_t26_family_audit import write_csv

T30_CLASSIC_MODE = "classic_revolution/seed_1001/openai_gpt-oss-120b"
T30_T26_MODE = "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b"
T31_MODE = "sr_raw_fail_feedback_repair_qd/seed_1001/openai_gpt-oss-120b"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--t30-run-root", required=True, type=Path)
    parser.add_argument("--t31-run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    methods = build_methods(args.t30_run_root, args.t31_run_root)
    old_methods = holdout.METHODS
    old_prefix = holdout.OUTPUT_PREFIX
    old_title = holdout.FIGURE_TITLE_PREFIX
    holdout.METHODS = methods
    holdout.OUTPUT_PREFIX = "t31_holdout"
    holdout.FIGURE_TITLE_PREFIX = "T31 Holdout"
    try:
        live_rows = [
            holdout.live_problem_row(Path("."), method, problem)
            for method in methods
            for problem in holdout.PROBLEMS
        ]
        live_aggregate_rows = holdout.aggregate_live_rows(live_rows)
        live_delta_rows = comparison_rows(live_aggregate_rows)
        candidates = [
            candidate
            for method in methods
            for problem in holdout.PROBLEMS
            for candidate in holdout.collect_problem_candidates(Path("."), method, problem)
        ]
        family_rows = holdout.family_problem_rows(candidates)
        family_aggregate_rows = holdout.aggregate_family_rows(family_rows)
        family_delta_rows = comparison_rows(family_aggregate_rows)

        write_csv(table_dir / "t31_holdout_live_problem_metrics.csv", live_rows)
        write_csv(table_dir / "t31_holdout_live_aggregate_metrics.csv", live_aggregate_rows)
        write_csv(table_dir / "t31_holdout_live_comparison_deltas.csv", live_delta_rows)
        write_csv(table_dir / "t31_holdout_family_candidate_rows.csv", holdout.candidate_rows(candidates))
        write_csv(table_dir / "t31_holdout_family_problem_metrics.csv", family_rows)
        write_csv(table_dir / "t31_holdout_family_aggregate_metrics.csv", family_aggregate_rows)
        write_csv(table_dir / "t31_holdout_family_comparison_deltas.csv", family_delta_rows)
        write_csv(table_dir / "t31_holdout_method_manifest.csv", manifest_rows(methods))
        copy_validation(args.t31_run_root, table_dir)
        holdout.write_figures(live_rows, live_aggregate_rows, candidates, family_aggregate_rows, figure_dir)
    finally:
        holdout.METHODS = old_methods
        holdout.OUTPUT_PREFIX = old_prefix
        holdout.FIGURE_TITLE_PREFIX = old_title
    return 0


def build_methods(t30_run_root: Path, t31_run_root: Path) -> tuple[dict[str, str], ...]:
    t30_root = t30_run_root.resolve()
    t31_root = t31_run_root.resolve()
    return (
        {
            "method": "classic_revolution",
            "label": "Classic",
            "mode": str(t30_root / T30_CLASSIC_MODE),
            "color": "#4e79a7",
        },
        {
            "method": "sr_raw_conservative_exploit_qd",
            "label": "T26 conservative exploit",
            "mode": str(t30_root / T30_T26_MODE),
            "color": "#e15759",
        },
        {
            "method": "sr_raw_fail_feedback_repair_qd",
            "label": "T31 fail-feedback repair",
            "mode": str(t31_root / T31_MODE),
            "color": "#59a14f",
        },
    )


def comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method"]: row for row in rows}
    metrics = [
        key
        for key in rows[0]
        if key
        not in {
            "method",
            "method_label",
            "problem_count",
        }
    ]
    output = []
    for method in ("sr_raw_conservative_exploit_qd", "sr_raw_fail_feedback_repair_qd"):
        output.extend(holdout.comparison_rows(by_method, method, tuple(metrics)))
    return output


def manifest_rows(methods: tuple[dict[str, str], ...]) -> list[dict[str, str]]:
    return [
        {
            "method": method["method"],
            "method_label": method["label"],
            "source_run_root": method["mode"],
            "benchmark": holdout.BENCHMARK,
        }
        for method in methods
    ]


def copy_validation(t31_run_root: Path, table_dir: Path) -> None:
    json_path = t31_run_root / "pareto_front_validation.json"
    md_path = t31_run_root / "pareto_front_validation.md"
    assert json_path.is_file()
    assert md_path.is_file()
    shutil.copyfile(json_path, table_dir / "t31_holdout_pareto_validation.json")
    shutil.copyfile(md_path, table_dir / "t31_holdout_pareto_validation.md")


if __name__ == "__main__":
    raise SystemExit(main())
