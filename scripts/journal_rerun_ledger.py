#!/usr/bin/env python3
"""Append-only rerun ledger for journal-revamp experiments.

Every journal-relevant run launch (debug gate, repair experiment, probe,
final-gate arm) is recorded as one JSONL line with its purpose, run root,
seeds, git commit, and config-snapshot hash, so the manuscript's evidence
trail can be reconstructed and silent reruns are impossible.

Usage:
  python scripts/journal_rerun_ledger.py append \\
      --purpose debug_gate_classic --run-root exp/... --seeds 42 \\
      [--config-snapshot path] [--note "..."]
  python scripts/journal_rerun_ledger.py list
"""

from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import subprocess
from pathlib import Path

DEFAULT_LEDGER = (
    Path(__file__).resolve().parent.parent
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260612_005012_KST_journal_revamp"
    / "rerun_ledger.jsonl"
)


def _git_commit() -> str:
    try:
        return (
            subprocess.run(
                ["git", "rev-parse", "HEAD"],
                capture_output=True,
                text=True,
                check=True,
                cwd=Path(__file__).resolve().parent,
            ).stdout.strip()
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "unknown"


def append_entry(args: argparse.Namespace) -> int:
    entry = {
        "timestamp_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(
            timespec="seconds"
        ),
        "purpose": args.purpose,
        "run_root": str(args.run_root),
        "seeds": args.seeds,
        "git_commit": _git_commit(),
        "note": args.note,
    }
    if args.config_snapshot is not None and args.config_snapshot.is_file():
        entry["config_snapshot"] = str(args.config_snapshot)
        entry["config_snapshot_sha256"] = hashlib.sha256(
            args.config_snapshot.read_bytes()
        ).hexdigest()
    args.ledger.parent.mkdir(parents=True, exist_ok=True)
    with args.ledger.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(entry) + "\n")
    print(f"Ledger entry appended to {args.ledger}: {args.purpose}")
    return 0


def list_entries(args: argparse.Namespace) -> int:
    if not args.ledger.is_file():
        print(f"No ledger at {args.ledger}")
        return 0
    for line in args.ledger.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        try:
            entry = json.loads(line)
        except json.JSONDecodeError:
            continue
        print(
            f"{entry.get('timestamp_utc', '?')} | {entry.get('purpose', '?')} | "
            f"seeds={entry.get('seeds')} | {entry.get('run_root', '?')}"
        )
    return 0


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ledger", type=Path, default=DEFAULT_LEDGER)
    subparsers = parser.add_subparsers(dest="command", required=True)

    append_parser = subparsers.add_parser("append", help="Record one run launch.")
    append_parser.add_argument("--purpose", required=True)
    append_parser.add_argument("--run-root", type=Path, required=True)
    append_parser.add_argument("--seeds", type=int, nargs="+", required=True)
    append_parser.add_argument("--config-snapshot", type=Path, default=None)
    append_parser.add_argument("--note", default="")

    subparsers.add_parser("list", help="Print recorded entries.")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    if args.command == "append":
        return append_entry(args)
    return list_entries(args)


if __name__ == "__main__":
    raise SystemExit(main())
