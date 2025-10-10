import datetime
import json
from collections import defaultdict

import pytest

from revolution.algorithm import Heuristic
from revolution.logging import EoHLogger


def _strategy_stats_fail():
    return {
        "M-F": {"count": 0, "value": 0.0},
        "M-S": {"count": 0, "value": 0.0},
        "M-E": {"count": 0, "value": 0.0},
        "M-R": {"count": 0, "value": 0.0},
        "M-I": {"count": 0, "value": 0.0},
    }


def _strategy_stats_success():
    return {
        "M-S": {"count": 0, "value": 0.0},
        "M-E": {"count": 0, "value": 0.0},
        "M-R": {"count": 0, "value": 0.0},
        "M-I": {"count": 0, "value": 0.0},
        "C-F": {"count": 0, "value": 0.0},
    }


def test_logger_writes_generation_and_summary(tmp_path):
    logger = EoHLogger(
        problem_name="prob",
        benchmark_name="bench",
        model_name="model-x",
        save_path=str(tmp_path),
        ref_ppa={"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
        generation_mode="whole",
    )
    logger.meta_strategy_name = "ucb"

    cand = Heuristic("thought", "code", "feedback", strategy="M-S", status="success")
    cand.ppa_success = True
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 1.8}
    cand.score = 0.1

    fail_rewards = defaultdict(float, {"M-F": 1.0})
    success_rewards = defaultdict(float, {"M-S": 0.5})

    logger.log_generation(
        generation_num=0,
        candidates_this_gen=[cand],
        runtime_sec=1.25,
        llm_calls_this_gen=2,
        llm_prompt_tokens=30,
        llm_completion_tokens=40,
        llm_code_prompt_tokens=15,
        llm_code_completion_tokens=20,
        llm_feedback_prompt_tokens=5,
        llm_feedback_completion_tokens=6,
        llm_stat_dict={
            "api_calls": 2,
            "prompt_tokens": 30,
            "completion_tokens": 40,
            "code_prompt_tokens": 15,
            "code_completion_tokens": 20,
            "feedback_prompt_tokens": 5,
            "feedback_completion_tokens": 6,
        },
        fail_rewards_this_gen=fail_rewards,
        success_rewards_this_gen=success_rewards,
        fail_strategy_stats=_strategy_stats_fail(),
        success_strategy_stats=_strategy_stats_success(),
        strategy_avg_selection_probabilities={
            "fail": {"M-F": 1.0},
            "success": {"M-S": 1.0},
        },
    )

    assert logger.total_llm_api_calls == 2
    with open(logger.gen_log_path, "r", encoding="utf-8") as fh:
        log_line = json.loads(fh.readline())
    assert log_line["generation"] == 0
    assert log_line["llm_api_calls"] == 2
    assert log_line["average_strategy_probabilities"]["success"]["M-S"] == pytest.approx(1.0)
    assert log_line["status_counts_this_generation"]["success"] == 1

    start = datetime.datetime.now(datetime.timezone.utc)
    end = start + datetime.timedelta(seconds=5)
    logger.finalize_summary(
        start_utc=start,
        end_utc=end,
        total_runtime_sec=5.0,
        total_generations=1,
        final_ppa_pool=[cand],
    )

    with open(logger.summary_path, "r", encoding="utf-8") as fh:
        summary = json.load(fh)
    assert summary["total_generations"] == 1
    assert summary["strategy_selection_method"] == "ucb"
    assert summary["accumulated_diff_stats"]["attempts"] == 0
    assert len(summary["generation_statistics"]) == 1
    assert summary["final_population_ppa"]["best_score"] == pytest.approx(0.1)
