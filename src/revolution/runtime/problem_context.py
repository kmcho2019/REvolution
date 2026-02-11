from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class ProblemContext:
    """Resolved on-disk context for a benchmark/problem pair."""

    benchmark_name: str
    problem_name: str
    benchmark_path: Path
    prompt_path: Path
    problem_description: str
    test_sv_path: Path
    ref_sv_path: Path | None
    top_module_names_path: Path


def default_benchmark_root() -> Path:
    return (Path(__file__).resolve().parents[3] / "data" / "bench").resolve()


def load_problem_context(
    benchmark_name: str,
    problem_name: str,
    benchmark_root: Path | str | None = None,
) -> ProblemContext:
    """Load prompt/test/reference paths for a benchmark problem."""
    root = Path(benchmark_root).resolve() if benchmark_root else default_benchmark_root()
    benchmark_path = (root / benchmark_name).resolve()
    if not benchmark_path.is_dir():
        raise FileNotFoundError(
            f"Benchmark directory not found: {benchmark_path}"
        )

    prompt_path = benchmark_path / f"{problem_name}_prompt.txt"
    if not prompt_path.is_file():
        raise FileNotFoundError(f"Problem prompt not found: {prompt_path}")

    problem_description = prompt_path.read_text(encoding="utf-8").strip()
    test_sv_path = benchmark_path / f"{problem_name}_test.sv"
    if not test_sv_path.is_file():
        raise FileNotFoundError(f"Problem testbench not found: {test_sv_path}")

    ref_candidate = benchmark_path / f"{problem_name}_ref.sv"
    ref_sv_path = ref_candidate if ref_candidate.is_file() else None
    top_module_names_path = benchmark_path / "synthesis_top_module_names.json"
    return ProblemContext(
        benchmark_name=benchmark_name,
        problem_name=problem_name,
        benchmark_path=benchmark_path,
        prompt_path=prompt_path,
        problem_description=problem_description,
        test_sv_path=test_sv_path,
        ref_sv_path=ref_sv_path,
        top_module_names_path=top_module_names_path,
    )


def resolve_top_module_name(context: ProblemContext, default: str = "TopModule") -> str:
    """Resolve synthesis top module mapping for the current problem."""
    path = context.top_module_names_path
    if not path.is_file():
        return default
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return default
    return str(data.get(context.problem_name, default))
