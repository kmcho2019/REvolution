"""Verilator-5 functional harness (RealBench `verilator_testbench` path).

Mirrors ``VerilogEvaluator.evaluate``'s result contract so the engine's
status/parsing logic is reused unchanged: the candidate (plus optional
reference and support files) and the testbench are verilated into a
binary (``--binary --timing``), the binary is run under a timeout, and
stdout is returned for the engine's mismatch parsing. Per-candidate C++
compilation is seconds for small modules and minutes for the largest
RealBench cores - budget timeouts accordingly.
"""

from __future__ import annotations

import os
import subprocess
from typing import Any


class VerilatorEvaluator:
    """Compile-and-run functional evaluation through verilator 5."""

    def __init__(
        self,
        *,
        verilator_binary: str = "verilator",
        default_simulation_timeout_seconds: int = 120,
        default_build_timeout_seconds: int = 600,
    ) -> None:
        self.verilator_binary = verilator_binary
        self.default_simulation_timeout_seconds = int(default_simulation_timeout_seconds)
        self.default_build_timeout_seconds = int(default_build_timeout_seconds)

    def evaluate(
        self,
        generated_sv_file: str | list[str],
        test_sv_file: str,
        ref_sv_file: str | None,
        top_module_name: str = "tb",
        output_directory: str | None = None,
        simulation_timeout_seconds: int | None = None,
        include_dirs: list[str] | None = None,
        defines: list[str] | None = None,
        enable_vcd_probe: bool = False,
    ) -> dict[str, Any]:
        """Verilate and run one candidate; same result keys as the iverilog path.

        ``enable_vcd_probe`` exists only to match the iverilog evaluator's
        signature. Dynamic-activity descriptors source from ``icarus_vcd``,
        which the verilator harness cannot produce, so a True value here is a
        configuration error (a dynamic descriptor profile paired with a
        verilator-only benchmark) and is rejected rather than silently
        yielding empty dynamic metrics.
        """
        assert not enable_vcd_probe, (
            "VerilatorEvaluator does not support icarus_vcd dynamic-activity "
            "probing; use a static descriptor profile on verilator benchmarks."
        )

        dut_files = (
            [generated_sv_file]
            if isinstance(generated_sv_file, str)
            else list(generated_sv_file)
        )
        for path in dut_files + [test_sv_file]:
            if not os.path.isfile(path):
                return self._result(
                    "file_error", comp_stderr=f"file not found: {path}"
                )
        out_dir = output_directory or os.path.dirname(dut_files[0])
        os.makedirs(out_dir, exist_ok=True)
        obj_dir = os.path.join(out_dir, "verilator_obj")
        binary_path = os.path.join(obj_dir, "sim_bin")
        log_path = os.path.join(out_dir, "verilator_simulation.log")

        sources = list(dut_files) + [test_sv_file]
        if ref_sv_file:
            sources.append(ref_sv_file)
        command = [
            self.verilator_binary,
            "--binary",
            "--timing",
            "-Wno-fatal",
            "--top-module",
            top_module_name,
            "-Mdir",
            obj_dir,
            "-o",
            "sim_bin",
        ]
        for directory in include_dirs or []:
            command.append(f"+incdir+{directory}")
        for define in defines or []:
            command.append(f"-D{define}")
        command += sources

        try:
            build = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=self.default_build_timeout_seconds,
                cwd=out_dir,
            )
        except subprocess.TimeoutExpired:
            return self._result("compilation_error", comp_stderr="verilator build timeout")
        if build.returncode != 0 or not os.path.isfile(binary_path):
            return self._result(
                "compilation_error",
                comp_stdout=build.stdout,
                comp_stderr=build.stderr,
            )

        timeout = (
            self.default_simulation_timeout_seconds
            if simulation_timeout_seconds is None
            else int(simulation_timeout_seconds)
        )
        try:
            sim = subprocess.run(
                [binary_path],
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=out_dir,
            )
        except subprocess.TimeoutExpired:
            return self._result(
                "simulation_timeout",
                compiled_file_path=binary_path,
                comp_stdout=build.stdout,
                comp_stderr=build.stderr,
            )
        with open(log_path, "w", encoding="utf-8") as handle:
            handle.write(sim.stdout + sim.stderr)
        return self._result(
            "success",
            log_file_path=log_path,
            compiled_file_path=binary_path,
            comp_stdout=build.stdout,
            comp_stderr=build.stderr,
            sim_stdout=sim.stdout,
            sim_stderr=sim.stderr,
        )

    @staticmethod
    def _result(
        status: str,
        *,
        log_file_path: str | None = None,
        compiled_file_path: str | None = None,
        comp_stdout: str = "",
        comp_stderr: str = "",
        sim_stdout: str = "",
        sim_stderr: str = "",
    ) -> dict[str, Any]:
        return {
            "status": status,
            "log_file_path": log_file_path,
            "compiled_file_path": compiled_file_path,
            "compilation_stdout": comp_stdout,
            "compilation_stderr": comp_stderr,
            "simulation_stdout": sim_stdout,
            "simulation_stderr": sim_stderr,
            "vcd_file_path": None,
        }
