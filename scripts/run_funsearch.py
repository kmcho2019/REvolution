#!/usr/bin/env python3
"""Convenience wrapper for running the FunSearch backend."""

from __future__ import annotations

import sys

from run_backend import main as run_backend_main


def main() -> int:
    argv = ["--backend", "funsearch", *sys.argv[1:]]
    return run_backend_main(argv)


if __name__ == "__main__":
    raise SystemExit(main())
