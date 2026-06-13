from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_realbench_manifest.py"
)
_SPEC = importlib.util.spec_from_file_location("build_realbench_manifest", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
build_realbench_manifest = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_realbench_manifest", build_realbench_manifest)
_SPEC.loader.exec_module(build_realbench_manifest)


def _write_module_task(
    source_root: Path,
    family: str,
    module: str,
    *,
    support_files: dict[str, str] | None = None,
    testbench_top: str = "tb",
) -> None:
    task_dir = source_root / family / module
    verification = task_dir / "verification"
    verification.mkdir(parents=True, exist_ok=True)
    (task_dir / f"{module}.md").write_text(f"# Spec for {module}\n", encoding="utf-8")
    (task_dir / f"{module}.v").write_text(
        f"module {module}(input a, output b);\nassign b = a;\nendmodule\n",
        encoding="utf-8",
    )
    (verification / f"{module}_testbench.sv").write_text(
        f"module {testbench_top}();\nendmodule\n", encoding="utf-8"
    )
    (verification / f"{module}_stimulus_gen.sv").write_text(
        "module stimulus_gen();\nendmodule\n", encoding="utf-8"
    )
    (verification / f"{module}_ref.sv").write_text(
        f"module ref_{module}(input a, output b);\nassign b = a;\nendmodule\n",
        encoding="utf-8",
    )
    for name, content in (support_files or {}).items():
        (verification / name).write_text(content, encoding="utf-8")


def _write_source_tree(tmp_path: Path) -> Path:
    source_root = tmp_path / "RealBenchSource"
    source_root.mkdir(parents=True)
    (source_root / "benchmark_info.py").write_text(
        "benchmark_info = {\n"
        "    'sdc': {'sd_leaf': [], 'sd_parent': ['sd_leaf']},\n"
        "    'e203_hbirdv2': {'e203_leaf': []},\n"
        "}\n",
        encoding="utf-8",
    )
    defines_dir = source_root / "sdc" / "sd_defines"
    defines_dir.mkdir(parents=True)
    (defines_dir / "sd_defines.md").write_text("`SD_BUS_W is 4\n", encoding="utf-8")
    e203_defines = source_root / "e203_hbirdv2" / "e203_defines"
    e203_defines.mkdir(parents=True)
    (e203_defines / "e203_defines.md").write_text("e203 defines doc\n", encoding="utf-8")
    e203_config = source_root / "e203_hbirdv2" / "config"
    e203_config.mkdir(parents=True)
    (e203_config / "config.md").write_text("e203 config doc\n", encoding="utf-8")

    _write_module_task(
        source_root,
        "sdc",
        "sd_leaf",
        support_files={"sd_defines.v": "`define SD_BUS_W 4\n"},
        testbench_top="tb_sd_leaf",
    )
    _write_module_task(
        source_root,
        "sdc",
        "sd_parent",
        support_files={
            "sd_defines.v": "`define SD_BUS_W 4\n",
            "sd_leaf.v": "module sd_leaf(input a, output b);\nassign b=a;\nendmodule\n",
        },
    )
    _write_module_task(source_root, "e203_hbirdv2", "e203_leaf")
    return source_root


def test_generate_manifest_builds_entries_and_tree(tmp_path):
    source_root = _write_source_tree(tmp_path)
    output_root = tmp_path / "out"
    output_root.mkdir()

    manifest = build_realbench_manifest.generate_manifest(
        source_root=source_root,
        output_root=output_root,
    )

    assert manifest["subset_counts"] == {"sdc": 2, "e203_hbirdv2": 1}
    assert len(manifest["manifest_sha256"]) == 64
    by_name = {entry["problem_name"]: entry for entry in manifest["problems"]}

    leaf = by_name["sd_leaf"]
    assert leaf["family"] == "sdc"
    assert leaf["testbench_top_module"] == "tb_sd_leaf"
    assert leaf["aux_files"] == ["sdc/sd_leaf/support/sd_defines.v"]
    assert leaf["supports_synthesis"] is False  # has support files
    assert leaf["compile_defines"] == []
    prompt = (output_root / leaf["prompt_path"]).read_text(encoding="utf-8")
    assert "Spec for sd_leaf" in prompt
    assert "sd_defines.v" in prompt  # family note appended
    assert "`SD_BUS_W is 4" in prompt
    test_sv = (output_root / leaf["test_sv_path"]).read_text(encoding="utf-8")
    assert "module tb_sd_leaf" in test_sv
    assert "module stimulus_gen" in test_sv
    assert "module ref_sd_leaf" in test_sv

    parent = by_name["sd_parent"]
    assert parent["dependencies"] == ["sd_leaf"]
    assert len(parent["aux_files"]) == 2

    e203 = by_name["e203_leaf"]
    assert e203["compile_defines"] == ["DISABLE_SV_ASSERTION"]
    assert e203["supports_synthesis"] is True
    assert e203["size_signals"]["prompt_bytes"] > 0

    saved = json.loads(
        (output_root / "module_manifest.json").read_text(encoding="utf-8")
    )
    assert saved["manifest_sha256"] == manifest["manifest_sha256"]


def test_generate_manifest_is_deterministic(tmp_path):
    source_root = _write_source_tree(tmp_path)
    out_a = tmp_path / "out_a"
    out_b = tmp_path / "out_b"
    out_a.mkdir()
    out_b.mkdir()

    sha_a = build_realbench_manifest.generate_manifest(
        source_root=source_root, output_root=out_a
    )["manifest_sha256"]
    sha_b = build_realbench_manifest.generate_manifest(
        source_root=source_root, output_root=out_b
    )["manifest_sha256"]

    assert sha_a == sha_b


def test_generate_manifest_requires_decrypted_prompts(tmp_path):
    source_root = _write_source_tree(tmp_path)
    (source_root / "sdc" / "sd_leaf" / "sd_leaf.md").unlink()
    output_root = tmp_path / "out"
    output_root.mkdir()

    try:
        build_realbench_manifest.generate_manifest(
            source_root=source_root, output_root=output_root
        )
    except FileNotFoundError as exc:
        assert "make -C" in str(exc)
    else:
        raise AssertionError("expected FileNotFoundError for missing prompt")


def test_validate_entry_records_failure_reason(tmp_path, monkeypatch):
    source_root = _write_source_tree(tmp_path)
    output_root = tmp_path / "out"
    output_root.mkdir()
    manifest = build_realbench_manifest.generate_manifest(
        source_root=source_root, output_root=output_root
    )
    entry = manifest["problems"][0]

    class _FakeEvaluator:
        def __init__(self, **kwargs):
            pass

        def evaluate(self, *args, **kwargs):
            return {
                "status": "success",
                "simulation_stdout": "Hint: Total mismatched samples is 0 out of 9 samples\n",
            }

    import revolution.evaluation as evaluation_module

    monkeypatch.setattr(evaluation_module, "VerilogEvaluator", _FakeEvaluator)

    result = build_realbench_manifest.validate_entry_with_golden(output_root, entry)

    assert result["harness_validated"] is True
    assert result["harness_mismatch_count"] == 0
    assert result["harness_failure_reason"] is None


def test_verilator_fallback_rescues_iverilog_rejected_golden(tmp_path, monkeypatch):
    source_root = _write_source_tree(tmp_path)
    output_root = tmp_path / "out"
    output_root.mkdir()
    manifest = build_realbench_manifest.generate_manifest(
        source_root=source_root, output_root=output_root
    )
    entry = manifest["problems"][0]

    class _FailingIverilog:
        def __init__(self, **kwargs):
            pass

        def evaluate(self, *args, **kwargs):
            return {
                "status": "compilation_error",
                "compilation_stderr": "syntax error: assert property",
                "simulation_stdout": "",
            }

    class _PassingVerilator:
        def __init__(self, **kwargs):
            pass

        def evaluate(self, *args, **kwargs):
            return {
                "status": "success",
                "simulation_stdout": "Hint: Total mismatched samples is 0 out of 9 samples\n",
            }

    import revolution.evaluation as evaluation_module
    import revolution.verilator_evaluation as verilator_module

    monkeypatch.setattr(evaluation_module, "VerilogEvaluator", _FailingIverilog)
    monkeypatch.setattr(verilator_module, "VerilatorEvaluator", _PassingVerilator)

    rescued = build_realbench_manifest.validate_entry_with_golden(
        output_root, entry, verilator_fallback=True
    )
    assert rescued["harness_validated"] is True
    assert rescued["harness_status"] == "verilator_success"
    assert rescued["functional_harness_kind"] == "verilator_testbench"
    assert "assert property" in rescued["iverilog_failure_reason"]

    unrescued = build_realbench_manifest.validate_entry_with_golden(
        output_root, entry, verilator_fallback=False
    )
    assert unrescued["harness_validated"] is False
    assert "functional_harness_kind" not in unrescued


def test_verilator_primary_validates_and_times(tmp_path, monkeypatch):
    source_root = _write_source_tree(tmp_path)
    output_root = tmp_path / "out"
    output_root.mkdir()
    manifest = build_realbench_manifest.generate_manifest(
        source_root=source_root, output_root=output_root
    )
    entry = manifest["problems"][0]

    class _PassingVerilator:
        def __init__(self, **kwargs):
            pass

        def evaluate(self, *args, **kwargs):
            return {
                "status": "success",
                "simulation_stdout": "Hint: Total mismatched samples is 0 out of 9 samples\n",
            }

    import revolution.verilator_evaluation as verilator_module

    monkeypatch.setattr(verilator_module, "VerilatorEvaluator", _PassingVerilator)

    result = build_realbench_manifest.validate_entry_with_golden(
        output_root, entry, primary_harness="verilator"
    )

    assert result["harness_validated"] is True
    assert result["functional_harness_kind"] == "verilator_testbench"
    assert result["harness_duration_s"] >= 0.0
