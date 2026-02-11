import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.run_backend import _build_parser, _derive_seed, _resolve_prompt_profile  # noqa: E402


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
