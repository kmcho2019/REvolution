#!/usr/bin/env python3
"""Generate the REvolution RealBench module-manifest tree.

Transforms the upstream RealBench dataset (``exp/RealBench``) into the
manifest layout consumed by ``revolution.runtime.realbench_adapter``:

- ``<output_root>/module_manifest.json`` with one entry per module task;
- per-task directories containing ``prompt.txt`` (decrypted spec plus the
  family defines notes exactly as upstream ``generate_problem.py`` builds
  them), ``test.sv`` (testbench + stimulus generator + reference model
  concatenated; the testbench compares the candidate DUT against
  ``ref_<module>``), ``golden.v`` (upstream reference implementation, kept
  out of the compile set because it shares the candidate's module name),
  and ``support/*.v`` (bundled dependency modules and defines headers that
  must be compiled or include-resolved with the candidate).

Determinism: tasks are discovered from upstream ``benchmark_info.py`` in
sorted order, outputs are byte-stable for a fixed source tree, and the
manifest embeds per-entry size signals plus a tree-level content hash so
locked subsets can detect dataset drift.

Prompts ship encrypted (``*.md.gpg``). Run ``make -C <source> decrypt``
first (upstream documents the passphrase in its Makefile); this script
fails with that instruction when decrypted ``*.md`` files are missing.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import sys
from pathlib import Path
from typing import Any

FAMILY_PROMPT_NOTES = {
    "sdc": [
        (
            "\nSome global variables involved in the document come from the "
            "file sd_defines.v. If you need to use them, please include this "
            "file.\n",
            "sdc/sd_defines/sd_defines.md",
        ),
    ],
    "e203_hbirdv2": [
        (
            "\nSome global variables involved in the document come from the "
            "file e203_defines.v. If you need to use them, please include "
            "this file.\n",
            "e203_hbirdv2/e203_defines/e203_defines.md",
        ),
        (
            "\nSome global variables involved in the document come from the "
            "file config.v. If you need to use them, please include this "
            "file.\n",
            "e203_hbirdv2/config/config.md",
        ),
    ],
}


def load_benchmark_info(source_root: Path) -> dict[str, dict[str, list[str]]]:
    """Import upstream benchmark_info.py and return its module-level table."""

    info_path = source_root / "benchmark_info.py"
    spec = importlib.util.spec_from_file_location("realbench_benchmark_info", info_path)
    if spec is None or spec.loader is None:
        raise FileNotFoundError(f"Cannot import benchmark info: {info_path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    info = getattr(module, "benchmark_info", None)
    if not isinstance(info, dict):
        raise ValueError(f"benchmark_info dict missing in {info_path}")
    return info


def build_prompt_text(source_root: Path, family: str, module: str) -> str:
    md_path = source_root / family / module / f"{module}.md"
    if not md_path.is_file():
        raise FileNotFoundError(
            f"Decrypted prompt missing: {md_path}. "
            f"Run `make -C {source_root} decrypt` first."
        )
    content = md_path.read_text(encoding="utf-8")
    for note, extra_rel in FAMILY_PROMPT_NOTES.get(family, []):
        extra_path = source_root / extra_rel
        extra_text = (
            extra_path.read_text(encoding="utf-8") if extra_path.is_file() else ""
        )
        content = content + note + extra_text
    return content.strip() + "\n"


_MODULE_DECL_RE = re.compile(r"^\s*module\s+([A-Za-z_][A-Za-z0-9_$]*)", re.MULTILINE)


def resolve_testbench_top(verification_dir: Path, module: str) -> str:
    """Return the first module declared in the task's testbench source.

    RealBench testbench top names vary per task (``tb``, ``tb_sd_bd``, ...),
    so the testbench file itself is authoritative.
    """

    testbench_path = verification_dir / f"{module}_testbench.sv"
    text = testbench_path.read_text(encoding="utf-8")
    match = _MODULE_DECL_RE.search(text)
    if match is None:
        raise ValueError(f"No module declaration found in {testbench_path}")
    return match.group(1)


def build_test_sv_text(verification_dir: Path, module: str) -> str:
    parts: list[str] = []
    for suffix in ("testbench", "stimulus_gen", "ref"):
        path = verification_dir / f"{module}_{suffix}.sv"
        if not path.is_file():
            raise FileNotFoundError(f"RealBench harness file missing: {path}")
        parts.append(
            f"// ---- {path.name} (RealBench harness) ----\n"
            + path.read_text(encoding="utf-8").strip()
            + "\n"
        )
    return "\n".join(parts)


def generate_module_task(
    *,
    source_root: Path,
    output_root: Path,
    family: str,
    module: str,
    dependencies: list[str],
) -> dict[str, Any]:
    task_source = source_root / family / module
    verification_dir = task_source / "verification"
    golden_path = task_source / f"{module}.v"
    if not golden_path.is_file():
        raise FileNotFoundError(f"RealBench golden source missing: {golden_path}")

    task_dir = output_root / family / module
    support_dir = task_dir / "support"
    task_dir.mkdir(parents=True, exist_ok=True)

    prompt_text = build_prompt_text(source_root, family, module)
    (task_dir / "prompt.txt").write_text(prompt_text, encoding="utf-8")

    test_sv_text = build_test_sv_text(verification_dir, module)
    test_sv_path = task_dir / "test.sv"
    test_sv_path.write_text(test_sv_text, encoding="utf-8")

    golden_text = golden_path.read_text(encoding="utf-8")
    (task_dir / "golden.v").write_text(golden_text, encoding="utf-8")

    support_files: list[str] = []
    support_bytes = 0
    for support_source in sorted(verification_dir.glob("*.v")):
        support_dir.mkdir(parents=True, exist_ok=True)
        target = support_dir / support_source.name
        text = support_source.read_text(encoding="utf-8")
        target.write_text(text, encoding="utf-8")
        support_files.append(str(target.relative_to(output_root)))
        support_bytes += len(text.encode("utf-8"))

    testbench_top_module = resolve_testbench_top(verification_dir, module)
    supports_synthesis = not dependencies and not support_files
    # e203 support sources guard SV assertions behind this upstream define;
    # iverilog cannot parse the guarded assertion bodies, so compile with the
    # upstream-sanctioned disable switch.
    compile_defines = ["DISABLE_SV_ASSERTION"] if family == "e203_hbirdv2" else []
    rel = task_dir.relative_to(output_root)
    return {
        "problem_name": module,
        "subset": "module",
        "family": family,
        "prompt_path": str(rel / "prompt.txt"),
        "test_sv_path": str(rel / "test.sv"),
        "golden_sv_path": str(rel / "golden.v"),
        "top_module": module,
        "testbench_top_module": testbench_top_module,
        "dependencies": list(dependencies),
        "aux_files": support_files,
        "compile_defines": compile_defines,
        "supports_synthesis": supports_synthesis,
        "supports_formal": False,
        "license_tag": "mit",
        "size_signals": {
            "prompt_bytes": len(prompt_text.encode("utf-8")),
            "test_sv_bytes": len(test_sv_text.encode("utf-8")),
            "golden_bytes": len(golden_text.encode("utf-8")),
            "support_bytes": support_bytes,
            "support_file_count": len(support_files),
        },
    }


def validate_entry_with_golden(
    output_root: Path,
    entry: dict[str, Any],
    *,
    simulation_timeout_s: int = 180,
    verilator_fallback: bool = False,
) -> dict[str, Any]:
    """Run the task's golden source through the strict iverilog harness.

    Records whether the unmodified upstream reference implementation passes
    the generated harness in this environment. Tasks whose golden fails are
    kept in the manifest with ``harness_validated: false`` so locked subsets
    can exclude them while reports stay honest about coverage.
    """

    import tempfile

    from revolution.evaluation import VerilogEvaluator
    from revolution.runtime.candidate_evaluator import parse_mismatch_count

    evaluator = VerilogEvaluator(
        iverilog_executable_path="iverilog",
        vvp_executable_path="vvp",
        default_simulation_timeout_seconds=simulation_timeout_s,
    )
    golden_path = output_root / str(entry["golden_sv_path"])
    aux_sources = [
        str(output_root / aux)
        for aux in entry.get("aux_files", [])
        if str(aux).endswith((".v", ".sv"))
    ]
    include_dirs = sorted({str(Path(path).parent) for path in aux_sources})
    defines = [str(d) for d in entry.get("compile_defines", [])]
    with tempfile.TemporaryDirectory() as tmp:
        candidate = Path(tmp) / f"{entry['problem_name']}.sv"
        candidate.write_text(golden_path.read_text(encoding="utf-8"), encoding="utf-8")
        result = evaluator.evaluate(
            [str(candidate), *aux_sources] if aux_sources else str(candidate),
            str(output_root / str(entry["test_sv_path"])),
            None,
            top_module_name=str(entry["testbench_top_module"]),
            include_dirs=include_dirs or None,
            defines=defines or None,
        )
    stdout = str(result.get("simulation_stdout", ""))
    mismatch_count = parse_mismatch_count(stdout)
    status = str(result.get("status", "unknown"))
    validated = status == "success" and mismatch_count == 0
    failure_reason = None
    if not validated:
        if status == "compilation_error":
            stderr = str(result.get("compilation_stderr", ""))
            failure_reason = "compile: " + stderr.strip().splitlines()[-1][:200] if stderr.strip() else "compile error"
        elif mismatch_count is None:
            failure_reason = f"no mismatch summary (status={status})"
        else:
            failure_reason = f"golden mismatches={mismatch_count} (status={status})"
    payload = {
        "harness_validated": validated,
        "harness_status": status,
        "harness_mismatch_count": mismatch_count,
        "harness_failure_reason": failure_reason,
    }
    if validated or not verilator_fallback:
        return payload

    # Retry iverilog-rejected goldens through the verilator-5 harness;
    # rescued tasks are marked so the runtime dispatches the matching
    # evaluator (functional_harness_kind -> VerilatorEvaluator).
    from revolution.verilator_evaluation import VerilatorEvaluator

    vl_evaluator = VerilatorEvaluator(
        default_simulation_timeout_seconds=simulation_timeout_s,
    )
    with tempfile.TemporaryDirectory() as tmp:
        candidate = Path(tmp) / f"{entry['problem_name']}.sv"
        candidate.write_text(golden_path.read_text(encoding="utf-8"), encoding="utf-8")
        vl_result = vl_evaluator.evaluate(
            [str(candidate), *aux_sources] if aux_sources else str(candidate),
            str(output_root / str(entry["test_sv_path"])),
            None,
            top_module_name=str(entry["testbench_top_module"]),
            output_directory=tmp,
            include_dirs=include_dirs or None,
            defines=defines or None,
        )
    vl_stdout = str(vl_result.get("simulation_stdout", ""))
    vl_mismatches = parse_mismatch_count(vl_stdout)
    if str(vl_result.get("status")) == "success" and vl_mismatches == 0:
        return {
            "harness_validated": True,
            "harness_status": "verilator_success",
            "harness_mismatch_count": 0,
            "harness_failure_reason": None,
            "functional_harness_kind": "verilator_testbench",
            "iverilog_failure_reason": failure_reason,
        }
    payload["verilator_fallback_reason"] = (
        f"status={vl_result.get('status')} mismatches={vl_mismatches}"
    )
    return payload


def generate_manifest(
    *,
    source_root: Path,
    output_root: Path,
    families: list[str] | None = None,
    validate: bool = False,
    validation_timeout_s: int = 180,
    verilator_fallback: bool = False,
) -> dict[str, Any]:
    info = load_benchmark_info(source_root)
    selected_families = sorted(families) if families else sorted(info)
    entries: list[dict[str, Any]] = []
    for family in selected_families:
        if family not in info:
            raise KeyError(f"Unknown RealBench family '{family}'")
        for module in sorted(info[family]):
            entry = generate_module_task(
                source_root=source_root,
                output_root=output_root,
                family=family,
                module=module,
                dependencies=[str(dep) for dep in info[family][module]],
            )
            if validate:
                entry.update(
                    validate_entry_with_golden(
                        output_root,
                        entry,
                        simulation_timeout_s=validation_timeout_s,
                        verilator_fallback=verilator_fallback,
                    )
                )
                print(
                    f"[validate] {module}: "
                    f"{'ok' if entry['harness_validated'] else entry['harness_failure_reason']}"
                )
            entries.append(entry)

    entries_blob = json.dumps(entries, sort_keys=True).encode("utf-8")
    manifest: dict[str, Any] = {
        "version": 1,
        "source_root": str(source_root),
        "subset_counts": _family_counts(entries),
        "manifest_sha256": hashlib.sha256(entries_blob).hexdigest(),
        "problems": entries,
    }
    if validate:
        validated_count = sum(1 for e in entries if e.get("harness_validated"))
        manifest["validation"] = {
            "validated_tasks": validated_count,
            "total_tasks": len(entries),
            "simulation_timeout_s": validation_timeout_s,
        }
    manifest_path = output_root / "module_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    return manifest


def _family_counts(entries: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for entry in entries:
        family = str(entry.get("family", "unknown"))
        counts[family] = counts.get(family, 0) + 1
    return counts


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--realbench-source",
        type=Path,
        default=Path("exp/RealBench"),
        help="Upstream RealBench checkout (prompts must be decrypted).",
    )
    parser.add_argument(
        "--output-root",
        type=Path,
        default=Path("data/bench/RealBench"),
        help="Generated manifest tree root.",
    )
    parser.add_argument(
        "--families",
        nargs="+",
        default=None,
        help="Optional family filter (default: all module families).",
    )
    parser.add_argument(
        "--validate",
        action="store_true",
        help="Run each task's golden source through the iverilog harness and "
        "record harness_validated per manifest entry.",
    )
    parser.add_argument(
        "--verilator-fallback",
        action="store_true",
        help="Retry iverilog-rejected goldens through the verilator-5 "
        "harness and mark rescued tasks functional_harness_kind="
        "verilator_testbench.",
    )
    parser.add_argument(
        "--validation-timeout-s",
        type=int,
        default=180,
        help="Per-task golden validation simulation timeout.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    source_root = args.realbench_source.resolve()
    if not (source_root / "benchmark_info.py").is_file():
        print(
            f"error: not a RealBench checkout (benchmark_info.py missing): {source_root}",
            file=sys.stderr,
        )
        return 2
    output_root = args.output_root.resolve()
    output_root.mkdir(parents=True, exist_ok=True)
    try:
        manifest = generate_manifest(
            source_root=source_root,
            output_root=output_root,
            families=args.families,
            validate=args.validate,
            validation_timeout_s=args.validation_timeout_s,
            verilator_fallback=args.verilator_fallback,
        )
    except FileNotFoundError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    counts = ", ".join(
        f"{family}={count}" for family, count in sorted(manifest["subset_counts"].items())
    )
    print(
        f"RealBench manifest: {len(manifest['problems'])} module tasks "
        f"({counts}) -> {output_root / 'module_manifest.json'}"
    )
    print(f"manifest_sha256: {manifest['manifest_sha256']}")
    if "validation" in manifest:
        validation = manifest["validation"]
        print(
            f"harness validation: {validation['validated_tasks']}/"
            f"{validation['total_tasks']} golden tasks pass strict iverilog"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
