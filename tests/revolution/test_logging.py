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


def test_logger_tracks_mode_estimates_and_diff_reason_counts(tmp_path):
    logger = EoHLogger(
        problem_name="prob",
        benchmark_name="bench",
        model_name="model-x",
        save_path=str(tmp_path),
        ref_ppa={"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
        generation_mode="diff",
    )

    diff_fail = Heuristic("thought", "code", "DIFF_APPLY_ERROR[ambiguous_fuzzy_match]: x", strategy="M-S", status="failed_diff")
    diff_fail.generated_mode = "diff"
    diff_fail.diff_apply_phase = "fuzzy"
    whole_ok = Heuristic("thought", "code", "feedback", strategy="M-F", status="success")
    whole_ok.generated_mode = "whole"
    whole_ok.ppa_success = True
    whole_ok.ppa_metrics = {"power": 0.8, "area": 80.0, "eff_clk_period": 1.7}
    whole_ok.score = 0.2

    logger.log_generation(
        generation_num=1,
        candidates_this_gen=[diff_fail, whole_ok],
        runtime_sec=1.0,
        llm_calls_this_gen=2,
        llm_prompt_tokens=100,
        llm_completion_tokens=50,
        llm_code_prompt_tokens=80,
        llm_code_completion_tokens=40,
        llm_feedback_prompt_tokens=20,
        llm_feedback_completion_tokens=10,
        llm_stat_dict={
            "api_calls": 2,
            "prompt_tokens": 100,
            "completion_tokens": 50,
            "code_prompt_tokens": 80,
            "code_completion_tokens": 40,
            "feedback_prompt_tokens": 20,
            "feedback_completion_tokens": 10,
        },
        fail_rewards_this_gen=defaultdict(float),
        success_rewards_this_gen=defaultdict(float),
        fail_strategy_stats=_strategy_stats_fail(),
        success_strategy_stats=_strategy_stats_success(),
        strategy_avg_selection_probabilities={"fail": {"M-F": 1.0}, "success": {"M-S": 1.0}},
    )

    with open(logger.gen_log_path, "r", encoding="utf-8") as fh:
        rec = json.loads(fh.readline())
    assert rec["failed_diff_reason_counts_generation"]["ambiguous_fuzzy_match"] == 1
    assert rec["candidates_by_mode"] == {"diff": 1, "whole": 1}
    assert rec["diff_phase_distribution_generation"] == {"fuzzy": 1}
    assert rec["llm_tokens_by_mode_estimate"]["diff"]["prompt_tokens"] == 50
    assert rec["llm_tokens_by_mode_estimate"]["whole"]["completion_tokens"] == 25
    assert rec["tokens_per_successful_candidate_by_mode_generation"]["whole"]["successful_candidates"] == 1

    start = datetime.datetime.now(datetime.timezone.utc)
    end = start + datetime.timedelta(seconds=2)
    logger.finalize_summary(
        start_utc=start,
        end_utc=end,
        total_runtime_sec=2.0,
        total_generations=1,
        final_ppa_pool=[whole_ok],
    )
    with open(logger.summary_path, "r", encoding="utf-8") as fh:
        summary = json.load(fh)
    assert summary["accumulated_diff_failure_reason_counts"]["ambiguous_fuzzy_match"] == 1
    assert summary["accumulated_diff_phase_distribution"] == {"fuzzy": 1}
    assert summary["accumulated_candidates_by_mode"] == {"diff": 1, "whole": 1}
    assert summary["tokens_per_successful_candidate_by_mode"]["whole"]["successful_candidates"] == 1
