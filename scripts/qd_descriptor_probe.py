#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.descriptors import (  # noqa: E402
    descriptor_requirements,
    resolve_descriptor_axes,
    summarize_descriptor_axes,
)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Inspect the configured QD descriptor axes and requirements.",
    )
    parser.add_argument("--profile", type=str, default=None)
    parser.add_argument("--axes", nargs="+", default=None)
    parser.add_argument("--descriptor_file", type=str, default=None)
    parser.add_argument(
        "--archive_type",
        type=str,
        default="grid",
        choices=["grid", "cvt", "grid_quantile"],
    )
    parser.add_argument(
        "--circuit_type",
        type=str,
        default="unknown",
        choices=["sequential", "combinational", "unknown"],
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    axes = resolve_descriptor_axes(
        profile_name=args.profile,
        explicit_axes=args.axes,
        descriptor_file=args.descriptor_file,
        archive_type=args.archive_type,
        circuit_type=args.circuit_type,
    )
    payload = {
        "axes": axes,
        "requirements": descriptor_requirements(axes),
        "summary": summarize_descriptor_axes(axes),
    }
    print(json.dumps(payload, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
