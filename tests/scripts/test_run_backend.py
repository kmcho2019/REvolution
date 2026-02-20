import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from revolution.runtime.problem_context import ProblemContext  # noqa: E402
from scripts.run_backend import (  # noqa: E402
    _build_parser,
    _derive_seed,
    _load_reference_ppa_metrics,
    _resolve_prompt_profile,
)


def test_derive_seed_is_stable():
    assert _derive_seed(None, 3) is None
    assert _derive_seed(10, 0) == 10
    assert _derive_seed(10, 1) == 9983


def test_prompt_profile_defaults_by_backend():
    class Args:
        prompt_profile = None
        backend = "funsearch"

    args = Args()
    assert _resolve_prompt_profile(args) == "funsearch"
    args.backend = "revolution"
    assert _resolve_prompt_profile(args) == "default"
    args.prompt_profile = "custom"
    assert _resolve_prompt_profile(args) == "custom"


def test_backend_parser_accepts_funsearch_options():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "funsearch",
            "--evaluation_mode",
            "search_accelerated",
            "--accelerated_synthesis_top_k",
            "2",
            "--fs_num_islands",
            "8",
            "--fs_score_reducer",
            "mean",
            "--fs_feedback_policy",
            "fail_only",
        ]
    )
    assert args.backend == "funsearch"
    assert args.evaluation_mode == "search_accelerated"
    assert args.accelerated_synthesis_top_k == 2
    assert args.fs_num_islands == 8
    assert args.fs_score_reducer == "mean"
    assert args.fs_feedback_policy == "fail_only"


def test_backend_parser_defaults_funsearch_reducer_to_last_input():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(["--backend", "funsearch"])
    assert args.fs_score_reducer == "last_input"


def test_load_reference_ppa_metrics_parses_reference_file(tmp_path):
    bench = tmp_path / "bench" / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n-5.0,-0.4,0.7,0.05,100.0\n",
        encoding="utf-8",
    )
    context = ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob001",
        benchmark_path=bench,
        prompt_path=bench / "Prob001_prompt.txt",
        problem_description="desc",
        test_sv_path=bench / "Prob001_test.sv",
        ref_sv_path=bench / "Prob001_ref.sv",
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )
    metrics = _load_reference_ppa_metrics(context)
    assert metrics == {
        "tns": -5.0,
        "wns": -0.4,
        "eff_clk_period": 0.7,
        "power": 0.05,
        "area": 100.0,
    }
