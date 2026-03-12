from __future__ import annotations

import json
import os
import re
import subprocess
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Any

from revolution.qd.scoring import (
    compute_partial_pass_fraction,
    compute_repair_score,
    functional_quality_score,
    normalize_code_hash,
)
from revolution.runtime.candidate_evaluator import CandidateEvaluation, CandidateWorkItem
from revolution.runtime.problem_context import ProblemContext


def load_cvdp_record(jsonl_path: str | Path, cvdp_id: str) -> dict[str, Any] | None:
    """Load one CVDP JSONL record by id."""
    path = Path(jsonl_path)
    if not path.is_file():
        return None
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            text = line.strip()
            if not text:
                continue
            try:
                payload = json.loads(text)
            except json.JSONDecodeError:
                continue
            if payload.get("id") == cvdp_id:
                return payload
    return None


def select_cvdp_ids(
    jsonl_path: str | Path,
    allowed_categories: list[str],
    selected_ids: list[str] | None = None,
) -> list[str]:
    """Select CVDP IDs filtered by categories and optional explicit id list."""
    path = Path(jsonl_path)
    if not path.is_file():
        return []

    allowed = {category.lower() for category in allowed_categories}
    selected_set = set(selected_ids) if selected_ids else None
    ids: list[str] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            text = line.strip()
            if not text:
                continue
            try:
                payload = json.loads(text)
            except json.JSONDecodeError:
                continue
            record_id = payload.get("id")
            if not isinstance(record_id, str) or not record_id:
                continue
            if selected_set is not None and record_id not in selected_set:
                continue
            categories = [str(c).lower() for c in payload.get("categories", [])]
            if any(category in allowed for category in categories):
                ids.append(record_id)
    return ids


def build_cvdp_problem_context(
    *,
    benchmark_name: str,
    cvdp_id: str,
    jsonl_path: str | Path,
    cvdp_record: dict[str, Any],
) -> ProblemContext:
    """Build a synthetic ProblemContext for CVDP records."""
    root = Path(jsonl_path).resolve().parent
    placeholder = root / f"{cvdp_id}.placeholder"
    prompt_text = str(cvdp_record.get("input", {}).get("prompt", "")).strip()
    return ProblemContext(
        benchmark_name=benchmark_name,
        problem_name=cvdp_id,
        benchmark_path=root,
        prompt_path=placeholder,
        problem_description=prompt_text,
        test_sv_path=placeholder,
        ref_sv_path=None,
        top_module_names_path=root / "synthesis_top_module_names.json",
    )


class CVDPEvaluator:
    """
    Runtime evaluator for CVDP harness-based functional checks.

    It follows the CandidateEvaluator API (`evaluate_candidate`/`evaluate_candidates`)
    so backends can swap it in transparently.
    """

    def __init__(
        self,
        *,
        context: ProblemContext,
        cvdp_jsonl_path: str,
        cvdp_id: str,
        simulation_timeout_s: int = 120,
        failure_score: float = float("-inf"),
        success_score: float = 1.0,
    ) -> None:
        self.context = context
        self.cvdp_jsonl_path = cvdp_jsonl_path
        self.cvdp_id = cvdp_id
        self.simulation_timeout_s = int(simulation_timeout_s)
        self.failure_score = float(failure_score)
        self.success_score = float(success_score)
        self.evaluation_mode = "strict_ablation"
        self.accelerated_synthesis_top_k = 0
        self.ref_ppa_metrics: dict[str, float] = {}

        record = load_cvdp_record(cvdp_jsonl_path, cvdp_id)
        if record is None:
            raise FileNotFoundError(
                f"CVDP id '{cvdp_id}' not found in JSONL: {cvdp_jsonl_path}"
            )
        self.cvdp_record = record
        self.problem_description = str(record.get("input", {}).get("prompt", ""))

    def _enrich_result(self, item: CandidateWorkItem, result: CandidateEvaluation) -> CandidateEvaluation:
        result.normalized_code_hash = normalize_code_hash(item.code)
        result.quality_mode = "functional_only"
        result.circuit_type = "unknown"
        result.partial_pass_fraction = compute_partial_pass_fraction(result.stage_statuses)
        quality_score, components = functional_quality_score(
            functional_score=result.score,
            structural_metrics=result.structural_metrics,
        )
        result.quality_score = quality_score
        result.score_components.update(components)
        result.archiveable = result.status == "success"
        if not result.archiveable:
            result.archive_rejection_reason = result.status
        result.repair_score = compute_repair_score(
            result.status,
            stage_statuses=result.stage_statuses,
            partial_pass_fraction=result.partial_pass_fraction,
        )
        return result

    def _normalize_code_text(self, source: str) -> str:
        source_norm = source.replace("\r\n", "\n")
        literal_newlines = source_norm.count("\\n")
        real_newlines = source_norm.count("\n")
        if literal_newlines >= 2 and real_newlines <= max(1, literal_newlines // 4):
            try:
                decoded = source_norm.encode("utf-8").decode("unicode_escape")
            except Exception:
                decoded = (
                    source_norm.replace("\\r\\n", "\n")
                    .replace("\\n", "\n")
                    .replace("\\t", "\t")
                    .replace('\\"', '"')
                )
            return decoded
        return source_norm

    def _materialize_harness(self, run_root: Path, candidate_code: str) -> dict[str, str]:
        harness_files = self.cvdp_record.get("harness", {}).get("files", {})
        output_context = self.cvdp_record.get("output", {}).get("context", {})
        if not isinstance(harness_files, dict) or not isinstance(output_context, dict):
            raise ValueError("Malformed CVDP record: missing harness/output context")
        if not output_context:
            raise ValueError("Malformed CVDP record: empty output.context")

        run_root.mkdir(parents=True, exist_ok=True)

        for relative_path, content in harness_files.items():
            path = run_root / relative_path
            path.parent.mkdir(parents=True, exist_ok=True)
            text = str(content)
            if relative_path == "src/.env":
                dut_rel = next(iter(output_context.keys()))
                dut_abs = (run_root / dut_rel).resolve()
                src_abs = (run_root / "src").resolve()
                updated_lines: list[str] = []
                for line in text.splitlines():
                    line_stripped = line.strip()
                    if line_stripped.startswith("VERILOG_SOURCES"):
                        updated_lines.append(f"VERILOG_SOURCES = {dut_abs.as_posix()}")
                    elif line_stripped.startswith("PYTHONPATH"):
                        updated_lines.append(f"PYTHONPATH = {src_abs.as_posix()}")
                    else:
                        updated_lines.append(line)
                text = "\n".join(updated_lines)
            path.write_text(text, encoding="utf-8")

        dut_rel = next(iter(output_context.keys()))
        dut_path = run_root / dut_rel
        dut_path.parent.mkdir(parents=True, exist_ok=True)
        dut_path.write_text(
            self._normalize_code_text(candidate_code),
            encoding="utf-8",
        )
        return {
            "dut_path": str(dut_path),
            "pytest_entry": str((run_root / "src" / "test_runner.py").resolve()),
            "log_path": str((run_root / "pytest.log").resolve()),
            "env_file": str((run_root / "src" / ".env").resolve()),
        }

    def _parse_envfile(self, env_path: Path) -> dict[str, str]:
        env: dict[str, str] = {}
        if not env_path.is_file():
            return env
        for raw_line in env_path.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip()
            if (value.startswith('"') and value.endswith('"')) or (
                value.startswith("'") and value.endswith("'")
            ):
                value = value[1:-1]
            env[key] = value
        return env

    def _run_pytest(
        self,
        *,
        run_root: Path,
        pytest_entry: str,
        log_path: str,
        env_file: str,
    ) -> tuple[str, str, str, int]:
        cmd = [
            "pytest",
            "-o",
            f"cache_dir={str((run_root / '.cache').resolve())}",
            pytest_entry,
            "-v",
            "-s",
        ]
        try:
            child_env = os.environ.copy()
            env_values = self._parse_envfile(Path(env_file))
            python_path = env_values.get("PYTHONPATH")
            if python_path:
                existing = child_env.get("PYTHONPATH", "")
                child_env["PYTHONPATH"] = (
                    python_path if not existing else python_path + os.pathsep + existing
                )
            for key, value in env_values.items():
                child_env[key] = value

            process = subprocess.run(
                cmd,
                cwd=str(run_root),
                capture_output=True,
                text=True,
                check=False,
                env=child_env,
                timeout=self.simulation_timeout_s,
            )
        except FileNotFoundError as exc:
            stderr = f"Pytest invocation failed: {exc}"
            Path(log_path).write_text(
                f"COMMAND: {' '.join(cmd)}\nSTDERR:\n{stderr}\n",
                encoding="utf-8",
            )
            return "simulation_error", "", stderr, 127
        except subprocess.TimeoutExpired:
            stderr = (
                f"Pytest timed out after {self.simulation_timeout_s} seconds for CVDP harness."
            )
            Path(log_path).write_text(
                f"COMMAND: {' '.join(cmd)}\nSTDERR:\n{stderr}\n",
                encoding="utf-8",
            )
            return "simulation_error", "", stderr, 124

        stdout = process.stdout or ""
        stderr = process.stderr or ""
        Path(log_path).write_text(
            f"COMMAND: {' '.join(cmd)}\n\nSTDOUT:\n{stdout}\n\nSTDERR:\n{stderr}\n",
            encoding="utf-8",
        )
        status = "success" if process.returncode == 0 else "simulation_error"
        return status, stdout, stderr, int(process.returncode)

    def evaluate_candidate(self, item: CandidateWorkItem) -> CandidateEvaluation:
        return self._evaluate_candidate_impl(item)

    def evaluate_candidates(
        self,
        items: list[CandidateWorkItem],
        *,
        candidate_workers: int = 0,
    ) -> list[CandidateEvaluation]:
        if candidate_workers > 1 and len(items) > 1:
            with ThreadPoolExecutor(max_workers=candidate_workers) as executor:
                futures = [executor.submit(self._evaluate_candidate_impl, item) for item in items]
                return [future.result() for future in futures]
        return [self._evaluate_candidate_impl(item) for item in items]

    def _evaluate_candidate_impl(self, item: CandidateWorkItem) -> CandidateEvaluation:
        base_stages = {
            "format": False,
            "diff": False,
            "syntax": False,
            "functionality": False,
            "synthesis": False,
            "synthesis_functionality": False,
            "ppa": False,
        }

        if item.initial_status == "failed_format":
            return self._enrich_result(item, CandidateEvaluation(
                status="failed_format",
                score=self.failure_score,
                stage_statuses=base_stages,
                feedback_payload={
                    "problem_def": self.problem_description,
                    "code": item.code,
                    "simulation_log": "Candidate failed format compliance checks.",
                },
            ))

        if item.initial_status == "failed_diff":
            stages = dict(base_stages)
            stages["format"] = True
            return self._enrich_result(item, CandidateEvaluation(
                status="failed_diff",
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload={
                    "problem_def": self.problem_description,
                    "code": item.code,
                    "simulation_log": "Candidate failed diff-application checks.",
                },
            ))

        stages = dict(base_stages)
        stages["format"] = True
        stages["diff"] = True

        candidate_dir = Path(item.code_file_path).parent
        run_root = candidate_dir / f"cvdp_harness_{uuid.uuid4().hex[:8]}"

        try:
            paths = self._materialize_harness(run_root, item.code)
            status, stdout, stderr, _returncode = self._run_pytest(
                run_root=run_root,
                pytest_entry=paths["pytest_entry"],
                log_path=paths["log_path"],
                env_file=paths["env_file"],
            )

            if status == "success":
                stages["syntax"] = True
                stages["functionality"] = True
                return self._enrich_result(item, CandidateEvaluation(
                    status="success",
                    score=self.success_score,
                    stage_statuses=stages,
                    feedback_payload={
                        "problem_def": self.problem_description,
                        "code": item.code,
                        "simulation_log": (
                            "CVDP cocotb harness passed. "
                            "Keep behavior intact while simplifying implementation where possible."
                        ),
                    },
                ))

            combined_log = f"STDOUT:\n{stdout}\n\nSTDERR:\n{stderr}"
            syntax_like = bool(
                re.search(
                    r"(syntax error|parse error|unexpected token|compilation error)",
                    combined_log,
                    re.IGNORECASE,
                )
            )
            if syntax_like:
                return self._enrich_result(item, CandidateEvaluation(
                    status="failed_syntax",
                    score=self.failure_score,
                    stage_statuses=stages,
                    feedback_payload={
                        "problem_def": self.problem_description,
                        "code": item.code,
                        "simulation_log": combined_log,
                    },
                ))

            stages["syntax"] = True
            return self._enrich_result(item, CandidateEvaluation(
                status="failed_functionality",
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload={
                    "problem_def": self.problem_description,
                    "code": item.code,
                    "simulation_log": combined_log,
                },
            ))
        except Exception as exc:
            return self._enrich_result(item, CandidateEvaluation(
                status="failed_functionality",
                score=self.failure_score,
                stage_statuses=stages,
                feedback_payload={
                    "problem_def": self.problem_description,
                    "code": item.code,
                    "simulation_log": f"CVDP evaluation exception: {exc}",
                },
            ))
