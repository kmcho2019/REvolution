"""Audit realized T74 two-parent descriptor compatibility."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


NEAR_FRONT_DESCRIPTOR_DISTANCE_SQ = 6.75
ARCHIVE_FILES = ("archive_cells.csv", "global_pareto_archive.csv")
REQUIRED_COLUMNS = {
    "candidate_id",
    "generation",
    "parent_count",
    "requested_parent_count",
    "parent_arity",
    "quality_score",
    "descriptors_json",
    "parent_ids_json",
}
OUTPUT_COLUMNS = [
    "problem",
    "source_file",
    "candidate_id",
    "generation",
    "quality_score",
    "parent_ids_json",
    "descriptor_distance_sq",
    "within_near_front_threshold",
    "missing_parent_descriptor",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    return parser.parse_args()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        assert reader.fieldnames is not None
        assert REQUIRED_COLUMNS <= set(reader.fieldnames), path
        return list(reader)


def is_two_parent(row: dict[str, str]) -> bool:
    return "2" in {
        row["parent_count"],
        row["requested_parent_count"],
        row["parent_arity"],
    }


def descriptor_tuple(row: dict[str, str]) -> tuple[float, ...]:
    values = json.loads(row["descriptors_json"])
    assert isinstance(values, list)
    return tuple(float(value) for value in values)


def squared_distance(left: tuple[float, ...], right: tuple[float, ...]) -> float:
    assert len(left) == len(right)
    return sum((left_value - right_value) ** 2 for left_value, right_value in zip(left, right))


def main() -> None:
    args = parse_args()
    paths = sorted(
        path for name in ARCHIVE_FILES for path in args.run_root.rglob(name)
    )
    assert paths, args.run_root

    rows: list[tuple[Path, dict[str, str]]] = []
    descriptors: dict[str, tuple[float, ...]] = {}
    for path in paths:
        for row in read_csv(path):
            rows.append((path, row))
            descriptors[row["candidate_id"]] = descriptor_tuple(row)

    output_rows: list[dict[str, str]] = []
    for path, row in rows:
        if not is_two_parent(row):
            continue
        parent_ids = json.loads(row["parent_ids_json"])
        assert isinstance(parent_ids, list)
        parents = [str(parent_id) for parent_id in parent_ids]
        missing = len(parents) != 2 or any(parent not in descriptors for parent in parents)
        distance = ""
        within = ""
        if not missing:
            distance_value = squared_distance(descriptors[parents[0]], descriptors[parents[1]])
            distance = f"{distance_value:.12g}"
            within = str(distance_value <= NEAR_FRONT_DESCRIPTOR_DISTANCE_SQ).lower()
        output_rows.append(
            {
                "problem": path.parent.name,
                "source_file": path.name,
                "candidate_id": row["candidate_id"],
                "generation": row["generation"],
                "quality_score": row["quality_score"],
                "parent_ids_json": row["parent_ids_json"],
                "descriptor_distance_sq": distance,
                "within_near_front_threshold": within,
                "missing_parent_descriptor": str(missing).lower(),
            }
        )

    args.output_dir.mkdir(parents=True, exist_ok=True)
    csv_path = args.output_dir / "t74_two_parent_descriptor_audit.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=OUTPUT_COLUMNS)
        writer.writeheader()
        writer.writerows(output_rows)

    audited = [row for row in output_rows if row["descriptor_distance_sq"]]
    summary = {
        "run_root": str(args.run_root),
        "near_front_descriptor_distance_sq": NEAR_FRONT_DESCRIPTOR_DISTANCE_SQ,
        "artifact_files": len(paths),
        "candidate_rows": len(rows),
        "two_parent_rows": len(output_rows),
        "audited_two_parent_rows": len(audited),
        "compatible_two_parent_rows": sum(
            row["within_near_front_threshold"] == "true" for row in audited
        ),
        "missing_parent_descriptor_rows": sum(
            row["missing_parent_descriptor"] == "true" for row in output_rows
        ),
    }
    json_path = args.output_dir / "t74_two_parent_descriptor_audit_summary.json"
    json_path.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
