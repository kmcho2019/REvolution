#!/usr/bin/env python3
"""Write normalized common-evaluation tables from Phase 03.1 viewer data."""

from __future__ import annotations

import argparse
import csv
import json
import math
import shutil
from pathlib import Path
from typing import Any


NOT_AVAILABLE = "not_available"

METHOD_FIELDS = [
    "method_key",
    "method_family",
    "seed",
    "benchmark",
    "problem",
    "budget_shape",
    "generated_count",
    "syntax_valid_count",
    "functional_count",
    "synthesis_valid_count",
    "valid_ppa_count",
    "unique_valid_netlist_count",
    "pareto_point_count",
    "global_ppa_hv",
    "hv_auc",
    "passive_archive_coverage",
    "passive_archive_qd_score",
    "passive_archive_qd_auc",
    "passive_archive_coverage_auc",
    "pareto_cell_count",
    "pareto_spread",
    "unique_front_family_count",
    "reference_beating_count",
    "classic_covered",
    "method_covered",
    "reference_ppa_valid",
    "comparison_status",
    "valid_ppa_yield_status",
    "runtime_seconds",
    "notes",
]

PASSIVE_FIELDS = [
    "method_key",
    "seed",
    "benchmark",
    "problem",
    "descriptor_profile",
    "cell_count",
    "occupied_cell_count",
    "passive_archive_coverage",
    "passive_archive_qd_score",
    "pareto_cell_count",
    "unique_front_family_count",
    "pareto_spread",
    "passive_archive_qd_auc",
    "passive_archive_coverage_auc",
    "hv_auc",
    "notes",
]

CELL_FIELDS = (
    "final_fixed_archive_cell_id",
    "archive_cell_id",
    "native_archive_cell_id",
)


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def read_json(path: Path) -> dict[str, Any]:
    data = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(data, dict)
    return data


def write_csv(path: Path, fields: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: object) -> str:
    if value is None:
        return NOT_AVAILABLE
    if isinstance(value, float):
        assert math.isfinite(value)
        return f"{value:.12g}"
    return str(value)


def parse_method_families(values: list[str]) -> dict[str, str]:
    families: dict[str, str] = {}
    for value in values:
        method, family = value.split("=", 1)
        assert method
        assert family
        families[method] = family
    return families


def cell_count(archive: dict[str, Any]) -> int:
    value = archive.get("num_cells")
    if isinstance(value, int):
        return value
    axes = archive["axes"]
    total = 1
    for axis in axes:
        total *= int(axis["effective_bins"])
    return total


def sample_cell_id(sample: dict[str, Any]) -> str:
    for field in CELL_FIELDS:
        value = sample.get(field)
        if value not in ("", None):
            return str(value)
    return ""


def sample_quality(sample: dict[str, Any]) -> float:
    value = sample["quality_score"]
    assert value is not None
    parsed = float(value)
    assert math.isfinite(parsed)
    return max(0.0, parsed)


def is_front_sample(sample: dict[str, Any]) -> bool:
    if sample.get("viewer_pooled_pareto_member") is True:
        return True
    return sample.get("pareto_rank_final") == 1


def front_spread(samples: list[dict[str, Any]], axis_names: list[str]) -> str:
    front = [sample for sample in samples if sample_cell_id(sample) and is_front_sample(sample)]
    if not front:
        return NOT_AVAILABLE
    values_by_axis: list[list[float]] = []
    for axis in axis_names:
        axis_values = []
        for sample in front:
            descriptors = sample["descriptor_values"]
            if axis not in descriptors or descriptors[axis] is None:
                return NOT_AVAILABLE
            axis_values.append(float(descriptors[axis]))
        values_by_axis.append(axis_values)
    spread = sum(max(values) - min(values) for values in values_by_axis)
    return fmt(spread)


def auc(points: list[tuple[int, float]]) -> str:
    assert points
    ordered = sorted(points)
    if len(ordered) == 1:
        return fmt(ordered[0][1])
    total = 0.0
    for (x0, y0), (x1, y1) in zip(ordered, ordered[1:]):
        total += (x1 - x0) * (y0 + y1) / 2.0
    span = ordered[-1][0] - ordered[0][0]
    assert span > 0
    return fmt(total / span)


def hv_auc(stats_by_step: dict[str, Any], method: str) -> str:
    points = []
    for step, stats in stats_by_step.items():
        if step == "final" or method not in stats:
            continue
        value = stats[method]["hypervolume"]["value"]
        points.append((int(step), float(value)))
    if not points:
        return NOT_AVAILABLE
    return auc(points)


def passive_metrics(
    samples: list[dict[str, Any]],
    archive: dict[str, Any],
    seed: str,
    benchmark: str,
    problem: str,
    method: str,
    hv_auc_value: str,
) -> dict[str, str]:
    projected = [sample for sample in samples if sample_cell_id(sample)]
    descriptor_profile = archive["descriptor_profile"]
    total_cells = cell_count(archive)
    if not projected:
        return {
            "method_key": method,
            "seed": seed,
            "benchmark": benchmark,
            "problem": problem,
            "descriptor_profile": descriptor_profile,
            "cell_count": fmt(total_cells),
            "occupied_cell_count": NOT_AVAILABLE,
            "passive_archive_coverage": NOT_AVAILABLE,
            "passive_archive_qd_score": NOT_AVAILABLE,
            "pareto_cell_count": NOT_AVAILABLE,
            "unique_front_family_count": NOT_AVAILABLE,
            "pareto_spread": NOT_AVAILABLE,
            "passive_archive_qd_auc": NOT_AVAILABLE,
            "passive_archive_coverage_auc": NOT_AVAILABLE,
            "hv_auc": hv_auc_value,
            "notes": "descriptor_projection_missing",
        }

    cells = sorted({sample_cell_id(sample) for sample in projected})
    best_by_cell: dict[str, float] = {}
    for sample in projected:
        cell = sample_cell_id(sample)
        best_by_cell[cell] = max(best_by_cell.get(cell, 0.0), sample_quality(sample))

    generations = sorted({int(sample["generation"]) for sample in projected})
    qd_points = []
    coverage_points = []
    for generation in generations:
        seen = [sample for sample in projected if int(sample["generation"]) <= generation]
        seen_cells = {sample_cell_id(sample) for sample in seen}
        seen_best = {}
        for sample in seen:
            cell = sample_cell_id(sample)
            seen_best[cell] = max(seen_best.get(cell, 0.0), sample_quality(sample))
        qd_points.append((generation, sum(seen_best.values())))
        coverage_points.append((generation, len(seen_cells) / total_cells))

    notes = []
    if "canonical_netlist_hash" not in projected[0]:
        notes.append("candidate_level_no_canonical_dedup")

    axis_names = [str(axis["name"]) for axis in archive["axes"]]
    return {
        "method_key": method,
        "seed": seed,
        "benchmark": benchmark,
        "problem": problem,
        "descriptor_profile": descriptor_profile,
        "cell_count": fmt(total_cells),
        "occupied_cell_count": fmt(len(cells)),
        "passive_archive_coverage": fmt(len(cells) / total_cells),
        "passive_archive_qd_score": fmt(sum(best_by_cell.values())),
        "pareto_cell_count": fmt(len({sample_cell_id(sample) for sample in projected if is_front_sample(sample)})),
        "unique_front_family_count": NOT_AVAILABLE,
        "pareto_spread": front_spread(projected, axis_names),
        "passive_archive_qd_auc": auc(qd_points),
        "passive_archive_coverage_auc": auc(coverage_points),
        "hv_auc": hv_auc_value,
        "notes": ";".join(notes),
    }


def reference_beating_count(samples: list[dict[str, Any]], objective_keys: list[str]) -> int:
    count = 0
    for sample in samples:
        if all(float(sample[key]) >= 0.0 for key in objective_keys):
            count += 1
    return count


def metric_rows(
    dataset: dict[str, Any],
    completeness: dict[tuple[str, str], dict[str, str]],
    seed: str,
    budget_shape: str,
    method_families: dict[str, str],
) -> tuple[list[dict[str, str]], list[dict[str, str]], dict[str, Any]]:
    benchmark = dataset["benchmark"]
    problem = dataset["problem"]
    key = (benchmark, problem)
    assert key in completeness
    gate = completeness[key]
    archive = dataset["archive_definition"]
    samples = dataset["samples"]
    stats_by_step = dataset["technique_stats_by_step"]
    objective_keys = dataset["objective_keys"]
    assert isinstance(samples, list)

    method_rows = []
    passive_rows = []
    for method in sorted(dataset["techniques"]):
        method_samples = [sample for sample in samples if sample["technique"] == method]
        final_stats = stats_by_step["final"][method]
        hv_auc_value = hv_auc(stats_by_step, method)
        passive = passive_metrics(
            method_samples,
            archive,
            seed,
            benchmark,
            problem,
            method,
            hv_auc_value,
        )
        passive_rows.append(passive)

        method_covered = "yes" if method_samples else "no"
        comparison_status = gate["comparison_status"]
        if gate["reference_ppa_valid"] == "yes" and method_covered == "no":
            comparison_status = "missing_method_coverage"
        method_rows.append(
            {
                "method_key": method,
                "method_family": method_families.get(method, "unknown"),
                "seed": seed,
                "benchmark": benchmark,
                "problem": problem,
                "budget_shape": budget_shape,
                "generated_count": NOT_AVAILABLE,
                "syntax_valid_count": NOT_AVAILABLE,
                "functional_count": NOT_AVAILABLE,
                "synthesis_valid_count": NOT_AVAILABLE,
                "valid_ppa_count": fmt(len(method_samples)),
                "unique_valid_netlist_count": NOT_AVAILABLE,
                "pareto_point_count": fmt(final_stats["rank1_count"]),
                "global_ppa_hv": fmt(final_stats["hypervolume"]["value"]),
                "hv_auc": hv_auc_value,
                "passive_archive_coverage": passive["passive_archive_coverage"],
                "passive_archive_qd_score": passive["passive_archive_qd_score"],
                "passive_archive_qd_auc": passive["passive_archive_qd_auc"],
                "passive_archive_coverage_auc": passive["passive_archive_coverage_auc"],
                "pareto_cell_count": passive["pareto_cell_count"],
                "pareto_spread": passive["pareto_spread"],
                "unique_front_family_count": NOT_AVAILABLE,
                "reference_beating_count": fmt(reference_beating_count(method_samples, objective_keys)),
                "classic_covered": gate["classic_valid_ppa"],
                "method_covered": method_covered,
                "reference_ppa_valid": gate["reference_ppa_valid"],
                "comparison_status": comparison_status,
                "valid_ppa_yield_status": gate["valid_ppa_yield_status"],
                "runtime_seconds": NOT_AVAILABLE,
                "notes": passive["notes"],
            }
        )

    config = {
        "benchmark": benchmark,
        "problem": problem,
        "descriptor_profile": archive["descriptor_profile"],
        "cell_count": cell_count(archive),
        "axis_names": [axis["name"] for axis in archive["axes"]],
        "effective_shape": archive["effective_shape"],
    }
    return method_rows, passive_rows, config


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--viewer-root", type=Path, required=True)
    parser.add_argument("--ppa-completeness", type=Path, required=True)
    parser.add_argument("--seed", required=True)
    parser.add_argument("--budget-shape", required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--method-family", action="append", default=[])
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    dataset_paths = sorted((args.viewer_root / "datasets").glob("*.json"))
    assert dataset_paths
    completeness = {
        (row["benchmark"], row["problem"]): row
        for row in read_csv(args.ppa_completeness)
    }
    method_families = parse_method_families(args.method_family)

    method_rows = []
    passive_rows = []
    archive_configs = []
    for path in dataset_paths:
        rows, archive_rows, config = metric_rows(
            read_json(path),
            completeness,
            args.seed,
            args.budget_shape,
            method_families,
        )
        method_rows.extend(rows)
        passive_rows.extend(archive_rows)
        archive_configs.append(config)

    args.output_dir.mkdir(parents=True, exist_ok=True)
    write_csv(args.output_dir / "method_problem_seed_metrics.csv", METHOD_FIELDS, method_rows)
    write_csv(args.output_dir / "passive_archive_metrics.csv", PASSIVE_FIELDS, passive_rows)
    shutil.copyfile(args.ppa_completeness, args.output_dir / "ppa_completeness.csv")
    config = {
        "schema_version": 1,
        "source_viewer_root": str(args.viewer_root),
        "scope": "per_problem_phase_03_1_viewer_archive",
        "duplicate_suppression": "canonical_netlist_hash_when_available",
        "problem_archives": archive_configs,
    }
    (args.output_dir / "passive_archive_config.json").write_text(
        json.dumps(config, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
