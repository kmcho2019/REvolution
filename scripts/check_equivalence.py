#!/usr/bin/env python3
"""Yosys-based formal equivalence spot-check for showcased candidates.

P4 predeclares that showcased candidates and a sampled fraction of
archive elites are equivalence-checked against the benchmark reference
implementation - testbench passes are sampled, not formal. This wraps
yosys' equiv flow (prep -> equiv_make -> equiv_simple -> equiv_status)
and reports PROVEN / NOT_PROVEN per pair, with the raw yosys log saved
next to the report for audit.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import tempfile
from pathlib import Path

YOSYS_SCRIPT = """
read_verilog -sv {gold}
prep -top {top}
rename {top} gold_top
design -stash gold
read_verilog -sv {gate}
prep -top {top}
rename {top} gate_top
design -stash gate
design -copy-from gold -as gold_top gold_top
design -copy-from gate -as gate_top gate_top
equiv_make gold_top gate_top equiv_top
prep -top equiv_top
equiv_simple
equiv_induct
equiv_status -assert
"""


def check_pair(gold: Path, gate: Path, top: str) -> dict[str, object]:
    """Run the yosys equivalence flow for one gold/gate pair."""

    script = YOSYS_SCRIPT.format(gold=gold, gate=gate, top=top)
    with tempfile.NamedTemporaryFile("w", suffix=".ys", delete=False) as handle:
        handle.write(script)
        script_path = handle.name
    proc = subprocess.run(
        ["yosys", "-q", "-s", script_path],
        capture_output=True,
        text=True,
        timeout=600,
    )
    log = proc.stdout + proc.stderr
    # yosys -q suppresses the success banner; equiv_status -assert encodes
    # the verdict in the return code (nonzero on unproven $equiv cells).
    proven = proc.returncode == 0
    unproven = None
    for line in log.splitlines():
        if "unproven" in line.lower():
            unproven = line.strip()
    return {
        "gold": str(gold),
        "gate": str(gate),
        "top": top,
        "verdict": "PROVEN" if proven else "NOT_PROVEN",
        "returncode": proc.returncode,
        "unproven_detail": unproven,
        "log": log,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gold", type=Path, required=True, help="Reference .sv")
    parser.add_argument("--gate", type=Path, action="append", required=True,
                        help="Candidate .sv (repeatable).")
    parser.add_argument("--top", required=True, help="Top module name (same in both).")
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    args.output_dir.mkdir(parents=True, exist_ok=True)
    results = []
    for index, gate in enumerate(args.gate):
        result = check_pair(args.gold, gate, args.top)
        log_path = args.output_dir / f"equiv_{index:03d}_{gate.stem}.log"
        log_path.write_text(result.pop("log"), encoding="utf-8")
        result["log_path"] = str(log_path)
        results.append(result)
        print(f"{result['verdict']:<11} {gate}")

    report = {
        "top": args.top,
        "gold": str(args.gold),
        "pairs": results,
        "proven": sum(1 for r in results if r["verdict"] == "PROVEN"),
        "total": len(results),
    }
    (args.output_dir / "equivalence_report.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )
    print(f"{report['proven']}/{report['total']} proven -> {args.output_dir}")
    return 0 if report["proven"] == report["total"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
