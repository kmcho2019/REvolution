#!/usr/bin/env python3
"""Capture the exact tool and environment versions for the finals freeze.

P4 requires a provenance statement with exact versions of every tool in
the evaluation path. This records the EDA binaries, Python, and the key
Python packages, plus the git commit, into a JSON artifact that the
freeze and the manuscript cite.
"""

from __future__ import annotations

import argparse
import importlib.metadata
import json
import platform
import subprocess
import sys
from pathlib import Path

BINARIES = {
    "iverilog": ["iverilog", "-V"],
    "vvp": ["vvp", "-V"],
    "verilator": ["verilator", "--version"],
    "yosys": ["yosys", "-V"],
    "openroad": ["openroad", "-version"],
}
PACKAGES = ("openai", "numpy", "scipy", "pyyaml", "matplotlib")


def binary_version(command: list[str]) -> str:
    try:
        proc = subprocess.run(command, capture_output=True, text=True, timeout=30)
    except (FileNotFoundError, subprocess.TimeoutExpired) as exc:
        return f"unavailable ({type(exc).__name__})"
    line = (proc.stdout or proc.stderr).strip().splitlines()
    return line[0][:200] if line else f"rc={proc.returncode}"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)

    git_commit = subprocess.run(
        ["git", "rev-parse", "HEAD"], capture_output=True, text=True
    ).stdout.strip()
    payload = {
        "git_commit": git_commit,
        "python": sys.version.split()[0],
        "platform": platform.platform(),
        "binaries": {name: binary_version(cmd) for name, cmd in BINARIES.items()},
        "packages": {
            name: _package_version(name) for name in PACKAGES
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    for name, version in payload["binaries"].items():
        print(f"{name}: {version}")
    print(f"Provenance -> {args.output}")
    return 0


def _package_version(name: str) -> str:
    try:
        return importlib.metadata.version(name)
    except importlib.metadata.PackageNotFoundError:
        return "not installed"


if __name__ == "__main__":
    raise SystemExit(main())
