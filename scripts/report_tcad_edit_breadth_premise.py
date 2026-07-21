#!/usr/bin/env python3
"""Measure classic REvolution edit breadth against offspring validity."""

from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from difflib import SequenceMatcher
from pathlib import Path
from statistics import mean, median
from typing import Any, cast

import yaml
from scipy.stats import spearmanr


def _spearman(x: list[float], y: list[int]) -> tuple[float, float]:
    return cast(tuple[float, float], spearmanr(x, y))


def _write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _edit_ratio(parent_path: str, child_path: str) -> float:
    parent = Path(parent_path).read_text(encoding="utf-8").splitlines()
    child = Path(child_path).read_text(encoding="utf-8").splitlines()
    changed = sum(
        (parent_end - parent_start) + (child_end - child_start)
        for tag, parent_start, parent_end, child_start, child_end in SequenceMatcher(
            None, parent, child, autojunk=False
        ).get_opcodes()
        if tag != "equal"
    )
    assert parent or child
    return changed / (len(parent) + len(child))


def _read_classic(root: Path) -> tuple[int, list[dict[str, Any]]]:
    configs = sorted(root.rglob("*_revolution_config.yaml"))
    assert len(configs) == 1, configs
    config = yaml.safe_load(configs[0].read_text(encoding="utf-8"))
    assert config["search_mode"] == "revolution"
    assert config["generation_mode"] == "whole"
    assert config["classic_operator_kind"] == "eoh_strategies"
    assert config["eoh_success_operator_set"] == "classic"
    seed = int(config["seed"])

    rows: list[dict[str, Any]] = []
    logs = sorted(root.rglob("generation_log.jsonl"))
    assert len(logs) == 50, len(logs)
    for path in logs:
        seen: dict[str, dict[str, Any]] = {}
        records = [json.loads(line) for line in path.read_text().splitlines()]
        assert [record["generation"] for record in records] == list(range(6))
        for record in records:
            for candidate in record["generated_candidates"]:
                if (
                    record["generation"] > 0
                    and candidate["origin_pool"] == "success_pool"
                    and len(candidate["parent_ids"]) == 1
                ):
                    parent = seen[candidate["parent_ids"][0]]
                    rows.append(
                        {
                            "seed": seed,
                            "problem": path.parent.name,
                            "generation": record["generation"],
                            "operator": candidate["strategy"],
                            "status": candidate["status"],
                            "parent_id": parent["id"],
                            "child_id": candidate["id"],
                            "edit_ratio": _edit_ratio(
                                parent["code_file_path"],
                                candidate["code_file_path"],
                            ),
                            "rtl_valid": int(candidate["rtl_simulation_success"]),
                            "valid_ppa": int(candidate["ppa_success"]),
                        }
                    )
                seen[candidate["id"]] = candidate
    return seed, rows


def _binary_summary(rows: list[dict[str, Any]], outcome: str) -> dict[str, Any]:
    passed = [row["edit_ratio"] for row in rows if row[outcome]]
    failed = [row["edit_ratio"] for row in rows if not row[outcome]]
    correlation, pvalue = _spearman(
        [row["edit_ratio"] for row in rows], [row[outcome] for row in rows]
    )
    return {
        "outcome": outcome,
        "pass_count": len(passed),
        "pass_mean_edit_ratio": mean(passed),
        "pass_median_edit_ratio": median(passed),
        "fail_count": len(failed),
        "fail_mean_edit_ratio": mean(failed),
        "fail_median_edit_ratio": median(failed),
        "spearman_rho": float(correlation),
        "spearman_pvalue": float(pvalue),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", action="append", type=Path, required=True)
    parser.add_argument("--headline-manifest", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    assert len(args.classic_root) == 2

    rows: list[dict[str, Any]] = []
    seeds = []
    for root in args.classic_root:
        seed, root_rows = _read_classic(root)
        seeds.append(seed)
        rows.extend(root_rows)
    assert sorted(seeds) == [1001, 1002]
    assert len(rows) == 1900

    manifest = yaml.safe_load(args.headline_manifest.read_text(encoding="utf-8"))
    headline = {row["problem"] for row in manifest["selected_problems"]}
    assert len(headline) == 46

    status_rows = [_binary_summary(rows, outcome) for outcome in ("rtl_valid", "valid_ppa")]
    operator_rows = []
    for operator in ("M-E", "M-I", "M-R", "M-S"):
        selected = [row for row in rows if row["operator"] == operator]
        correlation, pvalue = _spearman(
            [row["edit_ratio"] for row in selected],
            [row["valid_ppa"] for row in selected],
        )
        operator_rows.append(
            {
                "operator": operator,
                "count": len(selected),
                "mean_edit_ratio": mean(row["edit_ratio"] for row in selected),
                "rtl_valid_rate": mean(row["rtl_valid"] for row in selected),
                "valid_ppa_rate": mean(row["valid_ppa"] for row in selected),
                "valid_ppa_spearman_rho": float(correlation),
                "valid_ppa_spearman_pvalue": float(pvalue),
            }
        )

    seed_rows = []
    for seed in sorted(seeds):
        selected = [row for row in rows if row["seed"] == seed]
        correlation, pvalue = _spearman(
            [row["edit_ratio"] for row in selected],
            [row["valid_ppa"] for row in selected],
        )
        seed_rows.append(
            {
                "seed": seed,
                "count": len(selected),
                "valid_ppa_spearman_rho": float(correlation),
                "valid_ppa_spearman_pvalue": float(pvalue),
            }
        )

    generation_rows = []
    for generation in range(1, 6):
        selected = [row for row in rows if row["generation"] == generation]
        correlation, pvalue = _spearman(
            [row["edit_ratio"] for row in selected],
            [row["valid_ppa"] for row in selected],
        )
        generation_rows.append(
            {
                "generation": generation,
                "count": len(selected),
                "valid_ppa_spearman_rho": float(correlation),
                "valid_ppa_spearman_pvalue": float(pvalue),
            }
        )

    bin_rows = []
    for lower, upper in ((0.0, 0.1), (0.1, 0.25), (0.25, 0.5), (0.5, 0.75), (0.75, 1.01)):
        selected = [row for row in rows if lower <= row["edit_ratio"] < upper]
        bin_rows.append(
            {
                "lower_inclusive": lower,
                "upper_exclusive": upper,
                "count": len(selected),
                "valid_ppa_rate": mean(row["valid_ppa"] for row in selected),
            }
        )

    by_problem: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in rows:
        if row["problem"] in headline:
            by_problem[row["problem"]].append(row)
    problem_rows = []
    for problem, selected in sorted(by_problem.items()):
        if len({row["valid_ppa"] for row in selected}) < 2:
            continue
        correlation, _ = _spearman(
            [row["edit_ratio"] for row in selected],
            [row["valid_ppa"] for row in selected],
        )
        passed = [row["edit_ratio"] for row in selected if row["valid_ppa"]]
        failed = [row["edit_ratio"] for row in selected if not row["valid_ppa"]]
        problem_rows.append(
            {
                "problem": problem,
                "count": len(selected),
                "spearman_rho": float(correlation),
                "pass_minus_fail_mean_edit_ratio": mean(passed) - mean(failed),
            }
        )
    assert len(problem_rows) == 31

    summary = {
        "scope": "fresh_H5_matched_classic_only",
        "seeds": sorted(seeds),
        "sample_definition": "one_parent_success_origin_offspring",
        "sample_count": len(rows),
        "format_failure_count": sum(
            row["status"] == "failed_format" for row in rows
        ),
        "edit_ratio_definition": "changed_parent_and_child_lines_over_total_parent_and_child_lines",
        "outcomes": status_rows,
        "seed_strata": seed_rows,
        "generation_strata": generation_rows,
        "headline_problem_strata": {
            "count": len(problem_rows),
            "median_spearman_rho": median(
                float(row["spearman_rho"]) for row in problem_rows
            ),
            "negative_rho_count": sum(
                float(row["spearman_rho"]) < 0 for row in problem_rows
            ),
            "positive_rho_count": sum(
                float(row["spearman_rho"]) > 0 for row in problem_rows
            ),
            "median_pass_minus_fail_mean_edit_ratio": median(
                float(row["pass_minus_fail_mean_edit_ratio"])
                for row in problem_rows
            ),
            "negative_pass_minus_fail_count": sum(
                float(row["pass_minus_fail_mean_edit_ratio"]) < 0
                for row in problem_rows
            ),
            "positive_pass_minus_fail_count": sum(
                float(row["pass_minus_fail_mean_edit_ratio"]) > 0
                for row in problem_rows
            ),
        },
        "interpretation": (
            "Classic-only association supports testing mutation representation; "
            "it does not establish that strict deltas improve validity or PPA."
        ),
    }

    args.output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(args.output_dir / "offspring_edit_breadth.csv", rows)
    _write_csv(args.output_dir / "outcome_summary.csv", status_rows)
    _write_csv(args.output_dir / "operator_summary.csv", operator_rows)
    _write_csv(args.output_dir / "seed_summary.csv", seed_rows)
    _write_csv(args.output_dir / "generation_summary.csv", generation_rows)
    _write_csv(args.output_dir / "edit_ratio_bins.csv", bin_rows)
    _write_csv(args.output_dir / "headline_problem_strata.csv", problem_rows)
    (args.output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )


if __name__ == "__main__":
    main()
