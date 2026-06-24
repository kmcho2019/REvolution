from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()

    run_root = Path(args.run_root)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    backend_roots = list(run_root.glob("source_aligned_shape_density_qd/seed_1001/*"))
    assert len(backend_roots) == 1
    backend_root = backend_roots[0]

    summary_path = next(backend_root.glob("*_revolution_summary_results.txt"))
    summary_rows = _load_summary(summary_path)
    sto = _load_json(run_root / "single_thought_operator_validation.json")
    pareto = _load_json(run_root / "pareto_front_validation.json")

    rows = []
    parent_arity_counts: dict[str, int] = {}
    for problem_root in sorted(backend_root.glob("*/*")):
        if not problem_root.is_dir():
            continue
        suite = problem_root.parent.name
        problem = problem_root.name
        space = _load_json(problem_root / "archive_space.json")
        cells_path = problem_root / "archive_cells.csv"
        cell_rows = _load_cells(cells_path)
        for row in cell_rows:
            arity = row["parent_arity"]
            parent_arity_counts[arity] = parent_arity_counts.get(arity, 0) + 1
        collapsed_axes = [
            axis["name"] for axis in space["axes"] if bool(axis["collapsed"])
        ]
        rows.append(
            {
                "suite": suite,
                "problem": problem,
                "summary_status": summary_rows[problem]["status"],
                "best_score": summary_rows[problem]["best_score"],
                "archive_members": len(cell_rows),
                "occupied_cells": space["occupied_cells"],
                "num_cells": space["num_cells"],
                "max_front": max([int(row["front_size"]) for row in cell_rows] or [0]),
                "collapsed_axes": ";".join(collapsed_axes),
                "code_candidates": _count(problem_root, "code.sv"),
                "ppa_reports": _count(problem_root, "code_synthesis_report.ppa"),
            }
        )

    _write_csv(output_dir / "t73_live_screen_status.csv", rows)
    summary = {
        "run_root": str(run_root),
        "backend_root": str(backend_root),
        "summary_path": str(summary_path),
        "run_size_bytes": _du_bytes(run_root),
        "single_thought_operator_valid": sto["valid"],
        "pareto_front_valid": pareto["valid"],
        "success_count": sum(row["summary_status"] == "success" for row in rows),
        "failed_count": sum(row["summary_status"] != "success" for row in rows),
        "zero_member_problems": [
            f"{row['suite']}/{row['problem']}"
            for row in rows
            if int(row["archive_members"]) == 0
        ],
        "total_archive_members": sum(int(row["archive_members"]) for row in rows),
        "archive_parent_arity_counts": parent_arity_counts,
        "total_code_candidates": sum(int(row["code_candidates"]) for row in rows),
        "total_ppa_reports": sum(int(row["ppa_reports"]) for row in rows),
        "max_front_size_seen": pareto["max_front_size_seen"],
    }
    (output_dir / "t73_live_screen_summary.json").write_text(
        json.dumps(summary, indent=2) + "\n",
        encoding="utf-8",
    )


def _load_json(path: Path) -> dict:
    assert path.is_file(), path
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_summary(path: Path) -> dict[str, dict[str, str]]:
    rows = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        parts = line.split(",")
        assert len(parts) in {2, 5}
        score = parts[4] if len(parts) == 5 else ""
        rows[parts[0]] = {"status": parts[1], "best_score": score}
    return rows


def _load_cells(path: Path) -> list[dict[str, str]]:
    assert path.is_file(), path
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _count(root: Path, name: str) -> int:
    return sum(1 for _ in root.rglob(name))


def _du_bytes(root: Path) -> int:
    return sum(path.stat().st_size for path in root.rglob("*") if path.is_file())


if __name__ == "__main__":
    main()
