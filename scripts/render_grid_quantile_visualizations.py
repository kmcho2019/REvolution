#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from revolution.qd.visualization import write_grid_quantile_visualizations_from_artifacts


def _problem_roots(run_root: Path) -> list[Path]:
    roots = []
    for path in run_root.rglob("archive_space.json"):
        payload = json.loads(path.read_text(encoding="utf-8"))
        if payload.get("archive_type") == "grid_quantile":
            roots.append(path.parent)
    return sorted(roots)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Regenerate grid_quantile visualizations from run artifacts.",
    )
    parser.add_argument("--run-root", type=Path, required=True)
    args = parser.parse_args()

    roots = _problem_roots(args.run_root)
    for root in roots:
        write_grid_quantile_visualizations_from_artifacts(root)
    print(json.dumps({"run_root": str(args.run_root), "problem_count": len(roots)}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
