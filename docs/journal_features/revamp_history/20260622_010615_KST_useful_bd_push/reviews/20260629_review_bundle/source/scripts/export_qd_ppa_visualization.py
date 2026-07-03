#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))

from revolution.qd.ppa_visualization_export import (  # noqa: E402
    BackendRun,
    export_qd_ppa_visualization,
)


def _backend_run(value: str) -> BackendRun:
    if "=" not in value:
        raise argparse.ArgumentTypeError(f"expected NAME=PATH, got {value!r}")
    name, raw_path = value.split("=", 1)
    if not name:
        raise argparse.ArgumentTypeError("backend name must not be empty")
    return BackendRun(name=name, path=Path(raw_path).expanduser().resolve())


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Export linked QD archive and PPA/Pareto visualization data.",
    )
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument("--backend_run", action="append", type=_backend_run, required=True)
    parser.add_argument("--archive_source_backend", required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--subset-config", type=Path)
    parser.add_argument("--problem")
    parser.add_argument(
        "--asset-mode",
        choices=("cdn", "local", "inline"),
        default="inline",
    )
    parser.add_argument("--strict", action="store_true")
    parser.add_argument(
        "--no-classic-descriptor-recovery",
        action="store_true",
        help="Do not run graph descriptor recovery for classic candidates.",
    )
    args = parser.parse_args()

    result = export_qd_ppa_visualization(
        run_root=args.run_root.resolve(),
        backend_runs=tuple(args.backend_run),
        archive_source_backend=args.archive_source_backend,
        output_dir=args.output_dir.resolve(),
        subset_config=args.subset_config.resolve() if args.subset_config else None,
        selected_problem=args.problem,
        asset_mode=args.asset_mode,
        strict=bool(args.strict),
        recover_classic_descriptors=not bool(args.no_classic_descriptor_recovery),
    )
    print(f"viewer_root={result.viewer_root}")
    print(f"manifest={result.manifest_path}")
    print(f"datasets={len(result.dataset_paths)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
