#!/usr/bin/env python3
"""Generate RealBench reference-PPA files by synthesizing each golden design.

Reference PPA for RealBench was never produced (unlike RTLLM, which ships
``<problem>_ppa.txt`` files). The engine reads reference PPA ONLY from a
pre-synthesized ``<realbench_root>/<problem>_ppa.txt`` file
(``algorithm.py:_calculate_reference_ppa``); with no file, ``ref_ppa_metric`` is
empty and ``quality_mode`` collapses to ``functional_only`` so PPA-improvement
ratios cannot be computed.

This script closes that gap by synthesizing each manifest golden through the SAME
Yosys + OpenROAD flow used to score evolved candidates
(``SynthesisEvaluator._run_synthesis`` + ``_parse_ppa_log``), so reference numbers
are flow-consistent with candidate PPA. For each synthesizable module it writes
``<output_root>/<problem>_ppa.txt`` in the canonical format::

    tns,wns,eff_clk_period,power,area
    <tns>,<wns>,<eff_clk_period>,<power>,<area>

Note on the functional gate: the candidate flow runs a *post-synthesis* functional
re-simulation before accepting PPA. That gate is intentionally skipped here — the
golden is correct by construction (manifest ``harness_validated``), and the gate
is currently broken for RealBench netlists by a verilator TIMESCALEMOD/WIDTHTRUNC
strictness mismatch on the Yosys-emitted netlist (a separate harness bug that
also blocks candidate PPA scoring). The PPA numbers themselves come from the
identical synthesis + parser the candidate flow uses, so they remain consistent.

With ``--patch-manifest`` it records ``ppa_path`` + ``supports_synthesis`` on each
successful manifest entry, which flips ``supports_reference_ppa`` ->
``ppa_mode=reference_normalized`` -> ``quality_mode=ppa`` for subsequent runs.

Example::

    python scripts/generate_realbench_reference_ppa.py \
        --realbench-root data/bench/RealBench_v4_synth --patch-manifest
"""
from __future__ import annotations

import argparse
import json
import shutil
import tempfile
from pathlib import Path

from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.runtime.candidate_evaluator import CandidateEvaluator, CandidateWorkItem
from revolution.runtime.realbench_adapter import (
    build_realbench_problem_context,
    build_realbench_problem_spec,
)
from revolution.verilator_evaluation import VerilatorEvaluator

_PPA_KEYS = ("tns", "wns", "eff_clk_period", "power", "area")


def _select_problems(manifest: dict, explicit: list[str] | None) -> list[dict]:
    """Pick the manifest entries to synthesize (synth-capable + harness-validated)."""
    problems = manifest["problems"]
    if explicit:
        wanted = set(explicit)
        return [p for p in problems if p["problem_name"] in wanted]
    return [
        p
        for p in problems
        if p.get("supports_synthesis") and p.get("harness_validated")
    ]


def _build_evaluator(
    realbench_root: Path,
    record: dict,
    synthesis_evaluator: SynthesisEvaluator,
    sim_timeout_s: int,
) -> CandidateEvaluator:
    """Construct the candidate evaluator (for aux/define/top-module resolution)
    exactly as scripts/run_backend.py does, so synthesis inputs match candidates."""
    context = build_realbench_problem_context(
        benchmark_name="RealBench",
        problem_name=record["problem_name"],
        realbench_root=str(realbench_root),
        realbench_record=record,
    )
    problem_spec = build_realbench_problem_spec(
        context,
        realbench_record=record,
        supports_reference_ppa=False,  # generating it now; none exists yet
    )
    functional_evaluator: VerilogEvaluator = VerilatorEvaluator(
        default_simulation_timeout_seconds=sim_timeout_s,
    )
    return CandidateEvaluator(
        context=context,
        problem_description=context.problem_description,
        verilog_evaluator=functional_evaluator,
        synthesis_evaluator=synthesis_evaluator,
        ref_ppa_metrics={},
        problem_spec=problem_spec,
        evaluation_mode="strict_ablation",
    )


def _synthesize_golden(
    realbench_root: Path,
    record: dict,
    synthesis_evaluator: SynthesisEvaluator,
    sim_timeout_s: int,
    synth_timeout_s: int,
) -> tuple[dict[str, float] | None, str]:
    """Synthesize the golden and parse PPA from the report. Returns (ppa, status)."""
    name = record["problem_name"]
    golden_path = realbench_root / record["golden_sv_path"]
    assert golden_path.is_file(), f"missing golden: {golden_path}"
    golden_code = golden_path.read_text(encoding="utf-8")
    evaluator = _build_evaluator(realbench_root, record, synthesis_evaluator, sim_timeout_s)
    workdir = Path(tempfile.mkdtemp(prefix=f"refppa_{name}_"))
    try:
        # Golden must be a .sv path so the flow derives a .syn.v netlist name.
        code_path = workdir / f"{name}.sv"
        code_path.write_text(golden_code, encoding="utf-8")
        item = CandidateWorkItem(code=golden_code, code_file_path=str(code_path))
        # Apply the same forced header include (e.g. e203_defines.v) candidates get.
        dut_path = evaluator._forced_header_path(item)
        netlist_path = str(code_path).replace(".sv", ".syn.v")
        report_base = str(code_path).rsplit(".", 1)[0]
        success, report_path = synthesis_evaluator._run_synthesis(
            dut_path,
            name,
            evaluator.synthesis_top_module_name,
            str(workdir),
            report_base,
            netlist_path,
            synthesis_timeout_s=synth_timeout_s,
            aux_files=tuple(evaluator.aux_source_files),
            include_dirs=tuple(evaluator.aux_include_dirs),
            defines=tuple(evaluator.compile_defines),
        )
        if not success:
            return None, "synthesis failed"
        parsed = synthesis_evaluator._parse_ppa_log(report_path)
        # Timing fields default to 0.0 (timing met / combinational); power+area required.
        ppa = {
            "tns": parsed.get("tns") or 0.0,
            "wns": parsed.get("wns") or 0.0,
            "eff_clk_period": parsed.get("eff_clk_period") or 0.0,
            "power": parsed.get("power"),
            "area": parsed.get("area"),
        }
        if ppa["power"] is None or ppa["area"] is None:
            return None, "report missing power/area"
        if float(ppa["power"]) == 0.0 or float(ppa["area"]) == 0.0:
            return None, "zero power/area (rejected by engine reader)"
        return {k: float(v) for k, v in ppa.items()}, "ok"
    finally:
        shutil.rmtree(workdir, ignore_errors=True)


def _write_ppa_file(output_root: Path, problem_name: str, ppa: dict[str, float]) -> Path:
    out = output_root / f"{problem_name}_ppa.txt"
    line = ",".join(f"{ppa[k]}" for k in _PPA_KEYS)
    out.write_text(",".join(_PPA_KEYS) + "\n" + line + "\n", encoding="utf-8")
    return out


def _patch_manifest(manifest_path: Path, manifest: dict, succeeded: dict[str, str]) -> None:
    """Add ppa_path + supports_synthesis to manifest entries that synthesized."""
    for entry in manifest["problems"]:
        rel = succeeded.get(entry["problem_name"])
        if rel is None:
            continue
        entry["ppa_path"] = rel
        entry["supports_synthesis"] = True
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--realbench-root", default="data/bench/RealBench_v4_synth")
    ap.add_argument("--output-root", default=None, help="Defaults to --realbench-root.")
    ap.add_argument("--problems", nargs="*", help="Explicit problem names; default = all synth-capable.")
    ap.add_argument("--limit", type=int, default=None, help="Process at most N problems (pilot).")
    ap.add_argument("--sim-timeout-s", type=int, default=600)
    ap.add_argument("--synth-timeout-s", type=int, default=900)
    ap.add_argument("--patch-manifest", action="store_true")
    args = ap.parse_args()

    realbench_root = Path(args.realbench_root).resolve()
    output_root = Path(args.output_root).resolve() if args.output_root else realbench_root
    manifest_path = realbench_root / "module_manifest.json"
    manifest = json.loads(manifest_path.read_text())

    problems = _select_problems(manifest, args.problems)
    if args.limit is not None:
        problems = problems[: args.limit]
    print(f"Synthesizing {len(problems)} golden design(s) from {realbench_root}", flush=True)

    synthesis_evaluator = SynthesisEvaluator()
    succeeded: dict[str, str] = {}
    failed: list[tuple[str, str]] = []
    for i, record in enumerate(problems, 1):
        name = record["problem_name"]
        print(f"\n[{i}/{len(problems)}] {name} ...", flush=True)
        try:
            ppa, status = _synthesize_golden(
                realbench_root, record, synthesis_evaluator, args.sim_timeout_s, args.synth_timeout_s
            )
        except Exception as exc:  # noqa: BLE001 - report and continue the batch
            failed.append((name, f"exception: {exc}"))
            print(f"    FAILED: {exc}", flush=True)
            continue
        if ppa is None:
            failed.append((name, status))
            print(f"    FAILED: {status}", flush=True)
            continue
        out = _write_ppa_file(output_root, name, ppa)
        succeeded[name] = (
            out.relative_to(realbench_root).as_posix() if output_root == realbench_root else str(out)
        )
        print(f"    OK -> {out.name}: {ppa}", flush=True)

    if args.patch_manifest and succeeded:
        _patch_manifest(manifest_path, manifest, succeeded)
        print(f"\nPatched manifest: {len(succeeded)} entries got ppa_path + supports_synthesis")

    print(f"\n=== Summary: {len(succeeded)} succeeded, {len(failed)} failed ===")
    for name, reason in failed:
        print(f"  FAIL {name}: {reason}")


if __name__ == "__main__":
    main()
