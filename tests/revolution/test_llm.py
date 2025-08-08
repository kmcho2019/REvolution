import asyncio
from unittest.mock import AsyncMock, MagicMock

import pytest

from revolution.llm import LLMInterface, LLMRequest


@pytest.mark.asyncio
async def test_llm_generate_response_success(mocker):
    """
    Tests a successful LLM response generation and parsing.
    """
    # Arrange: Mock the AsyncOpenAI client and its methods
    mock_choice = MagicMock()
    mock_choice.message.content = (
        "```thought\nTest thought.\n```\n```code\nTest code.\n```"
    )

    mock_completion = MagicMock()
    mock_completion.choices = [mock_choice]

    # The create method is a coroutine, so it needs to be an AsyncMock
    mock_create = AsyncMock(return_value=mock_completion)

    # We mock the entire client's `chat.completions.create` method
    mock_client_instance = MagicMock()
    mock_client_instance.chat.completions.create = mock_create

    # The client itself is an async context manager
    mock_async_context_manager = AsyncMock()
    mock_async_context_manager.__aenter__.return_value = mock_client_instance

    mocker.patch("revolution.llm.AsyncOpenAI", return_value=mock_async_context_manager)

    llm = LLMInterface(api_key="fake_key", model_name="test_model")

    # Action
    thought, code = await llm.generate_response("some prompt")

    # Assert
    assert thought == "Test thought."
    assert code == "Test code."
    # Ensure the API call counter was incremented
    result_dict = await llm.get_and_reset_usage_stats()
    assert result_dict["api_calls"] == 1


# ---------------------------
# Helpers
# ---------------------------


def make_chat_completion(choice_texts, prompt_tokens=7, completion_tokens=11):
    """Build a ChatCompletion-like mock object with .choices and .usage."""
    comp = MagicMock()
    choices = []
    for txt in choice_texts:
        ch = MagicMock()
        ch.message.content = txt
        choices.append(ch)
    comp.choices = choices
    usage = MagicMock()
    usage.prompt_tokens = prompt_tokens
    usage.completion_tokens = completion_tokens
    comp.usage = usage
    return comp


def patch_async_openai(mocker, side_effect_or_value):
    """
    Patch AsyncOpenAI to return an async context manager whose
    chat.completions.create will either return a value, raise from a list,
    or raise a single exception.
    """
    mock_create = AsyncMock()
    if isinstance(side_effect_or_value, list):
        # AsyncMock will raise exceptions found in the list as side effects.
        mock_create.side_effect = side_effect_or_value
    elif isinstance(side_effect_or_value, Exception):

        async def _raise(*args, **kwargs):
            raise side_effect_or_value

        mock_create.side_effect = _raise
    else:
        mock_create.return_value = side_effect_or_value

    client = MagicMock()
    client.chat.completions.create = mock_create

    cm = AsyncMock()
    cm.__aenter__.return_value = client
    mocker.patch("revolution.llm.AsyncOpenAI", return_value=cm)
    return mock_create


@pytest.fixture
def patch_simple_exceptions(mocker):
    """Replace exception classes in module with simple Exception subclasses for easy raising."""

    class Simple(Exception):
        pass

    class APIConn(Simple):
        pass

    class Rate(Simple):
        pass

    class Timeout(Simple):
        pass

    class Internal(Simple):
        pass

    class BadReq(Simple):
        pass

    mocker.patch("revolution.llm.APIConnectionError", APIConn)
    mocker.patch("revolution.llm.RateLimitError", Rate)
    mocker.patch("revolution.llm.APITimeoutError", Timeout)
    mocker.patch("revolution.llm.InternalServerError", Internal)
    mocker.patch("revolution.llm.BadRequestError", BadReq)

    return {
        "APIConnectionError": APIConn,
        "RateLimitError": Rate,
        "APITimeoutError": Timeout,
        "InternalServerError": Internal,
        "BadRequestError": BadReq,
    }


# ---------------------------
# Init / backend config
# ---------------------------


def test_init_requires_api_key_except_vllm():
    with pytest.raises(ValueError):
        LLMInterface(api_key=None, api_backend="openai")
    # vllm is allowed without a key
    llm = LLMInterface(api_key=None, api_backend="vllm")
    assert llm.client_args["base_url"].startswith("http://localhost")


def test_backend_base_urls():
    llm = LLMInterface(api_key="k", api_backend="openai")
    assert "base_url" not in llm.client_args

    llm = LLMInterface(api_key="k", api_backend="openrouter")
    assert "openrouter.ai" in llm.client_args["base_url"]

    llm = LLMInterface(api_key="k", api_backend="deepseek")
    assert "api.deepseek.com" in llm.client_args["base_url"]

    llm = LLMInterface(api_key="k", api_backend="gemini")
    assert "generativelanguage.googleapis.com" in llm.client_args["base_url"]

    with pytest.raises(ValueError):
        LLMInterface(api_key="k", api_backend="madeup")


# ---------------------------
# parse_thought_and_code
# ---------------------------


def test_parse_thought_and_code_happy_path():
    llm = LLMInterface(api_key="k")
    text = "```thought\nT\n```\n```code\nC\n```"
    t, c = llm.parse_thought_and_code(text)
    assert t == "T" and c == "C"


def test_parse_thought_and_code_missing_blocks_returns_warning(capsys):
    llm = LLMInterface(api_key="k")
    # No code block
    text = "```thought\nT\n```"
    t, c = llm.parse_thought_and_code(text)
    assert "--- WARNING: Parsing Issues ---" in t and t == c
    assert "(PARSE_ERROR)" in t
    # No thought nor code
    t2, c2 = llm.parse_thought_and_code("hello")
    assert "--- WARNING: Parsing Issues ---" in t2 and t2 == c2


# ---------------------------
# _update_stats + get_and_reset
# ---------------------------


@pytest.mark.asyncio
async def test_update_stats_concurrent_and_reset():
    llm = LLMInterface(api_key="k")
    comp1 = make_chat_completion(["x"], prompt_tokens=3, completion_tokens=5)
    comp2 = make_chat_completion(["y"], prompt_tokens=2, completion_tokens=4)
    await asyncio.gather(
        llm._update_stats(comp1, n_calls=2, completion_type="code"),
        llm._update_stats(comp2, n_calls=1, completion_type="feedback"),
    )
    # Overall counters
    stats = await llm.get_and_reset_usage_stats()
    assert stats["api_calls"] == 3
    assert stats["prompt_tokens"] == 3 + 2
    assert stats["completion_tokens"] == 5 + 4
    assert stats["code_prompt_tokens"] == 3
    assert stats["code_completion_tokens"] == 5
    assert stats["feedback_prompt_tokens"] == 2
    assert stats["feedback_completion_tokens"] == 4
    # After reset, these are zeroed:
    stats2 = await llm.get_and_reset_usage_stats()
    assert (
        stats2["api_calls"] == 0
        and stats2["prompt_tokens"] == 0
        and stats2["completion_tokens"] == 0
    )
    # NOTE: code/feedback subcounters are not reset by get_and_reset (current behavior)


# ---------------------------
# generate_response
# ---------------------------


@pytest.mark.asyncio
async def test_generate_response_success_and_system_prompt_modes(mocker):
    completion = make_chat_completion(["```thought\nT\n```\n```code\nC\n```"])
    create = patch_async_openai(mocker, completion)

    llm = LLMInterface(api_key="k", model_name="m")
    t, c = await llm.generate_response("p", generation_mode="whole")
    assert (t, c) == ("T", "C")

    # Ensure system prompt for 'whole' was used
    msgs = create.call_args.kwargs["messages"]
    assert (
        msgs[0]["role"] == "system"
        and "expert Verilog design assistant" in msgs[0]["content"]
    )

    # Now check 'diff' content shows diff-format hints
    completion2 = make_chat_completion(["```thought\nT2\n```\n```code\nC2\n```"])
    create.side_effect = [completion2]  # next call
    t2, c2 = await llm.generate_response("p2", generation_mode="diff")
    assert (t2, c2) == ("T2", "C2")
    msgs2 = create.call_args.kwargs["messages"]
    assert (
        "SEARCH/REPLACE" in msgs2[0]["content"] or "diff format" in msgs2[0]["content"]
    )


@pytest.mark.asyncio
async def test_generate_response_empty_content_then_success(mocker):
    empty = make_chat_completion(["  "])
    good = make_chat_completion(["```thought\nA\n```\n```code\nB\n```"])
    create = patch_async_openai(mocker, [empty, good])
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=2)
    t, c = await llm.generate_response("prompt")
    assert (t, c) == ("A", "B")
    assert create.await_count == 2  # retried once


@pytest.mark.asyncio
async def test_generate_response_retriable_then_success(
    mocker, patch_simple_exceptions
):
    BadRate = patch_simple_exceptions["RateLimitError"]
    create = patch_async_openai(
        mocker,
        [BadRate("x"), make_chat_completion(["```thought\nT\n```\n```code\nC\n```"])],
    )
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=2)
    t, c = await llm.generate_response("p")
    assert (t, c) == ("T", "C")
    assert create.await_count == 2
    assert mock_sleep.await_count == 1


@pytest.mark.asyncio
async def test_generate_response_max_retries_fails(mocker, patch_simple_exceptions):
    APIConn = patch_simple_exceptions["APIConnectionError"]
    create = patch_async_openai(
        mocker, [APIConn("boom"), APIConn("boom"), APIConn("boom")]
    )
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=3)
    t, c = await llm.generate_response("p")
    assert (t, c) == (None, None)
    assert create.await_count == 3
    assert mock_sleep.await_count == 2  # between attempts


@pytest.mark.asyncio
async def test_generate_response_bad_request_immediate_fail(
    mocker, patch_simple_exceptions
):
    BadReq = patch_simple_exceptions["BadRequestError"]
    create = patch_async_openai(mocker, BadReq("nope"))
    llm = LLMInterface(api_key="k", max_retries=3)
    t, c = await llm.generate_response("p")
    assert (t, c) == (None, None)
    assert create.await_count == 1


# ---------------------------
# generate_n_responses
# ---------------------------


@pytest.mark.asyncio
async def test_generate_n_responses_success_counts_and_parsing(mocker):
    n = 3
    texts = [
        "```thought\nT1\n```\n```code\nC1\n```",
        "```thought\nT2\n```\n```code\nC2\n```",
        "```thought\nT3\n```\n```code\nC3\n```",
    ]
    completion = make_chat_completion(texts, prompt_tokens=9, completion_tokens=12)
    patch_async_openai(mocker, completion)

    llm = LLMInterface(api_key="k")
    out = await llm.generate_n_responses("p", n=n)
    assert out == [("T1", "C1"), ("T2", "C2"), ("T3", "C3")]

    # Stats: api_calls += n (n_calls=n), tokens add once from usage (current implementation)
    stats = await llm.get_and_reset_usage_stats()
    assert stats["api_calls"] == n
    assert stats["prompt_tokens"] == 9
    assert stats["completion_tokens"] == 12


@pytest.mark.asyncio
async def test_generate_n_responses_partial_then_fallback(mocker):
    # API returns only 1 choice even though n=3, then we fallback to two individual calls.
    first = make_chat_completion(["```thought\nA\n```\n```code\nB\n```"])
    create = patch_async_openai(mocker, first)

    llm = LLMInterface(api_key="k")
    # Patch generate_response for the fallback remainder
    llm.generate_response = AsyncMock(side_effect=[("T2", "C2"), ("T3", "C3")])

    out = await llm.generate_n_responses("p", n=3)
    assert out == [("A", "B"), ("T2", "C2"), ("T3", "C3")]
    assert llm.generate_response.await_count == 2


@pytest.mark.asyncio
async def test_generate_n_responses_badrequest_invalid_n_fallback(
    mocker, patch_simple_exceptions
):
    BadReq = patch_simple_exceptions["BadRequestError"]
    create = patch_async_openai(
        mocker, BadReq("Invalid n value (currently only n = 1 is supported)")
    )
    llm = LLMInterface(api_key="k")
    llm.generate_response = AsyncMock(
        side_effect=[("X1", "Y1"), ("X2", "Y2"), ("X3", "Y3")]
    )
    out = await llm.generate_n_responses("p", n=3)
    assert out == [("X1", "Y1"), ("X2", "Y2"), ("X3", "Y3")]
    assert llm.generate_response.await_count == 3
    assert create.await_count == 1  # single failed try with n>1


@pytest.mark.asyncio
async def test_generate_n_responses_badrequest_gemini_limit_fallback(
    mocker, patch_simple_exceptions
):
    BadReq = patch_simple_exceptions["BadRequestError"]
    create = patch_async_openai(
        mocker, BadReq("Invalid value of n: should be between 1 and 8, got 10")
    )
    llm = LLMInterface(api_key="k")
    llm.generate_response = AsyncMock(side_effect=[("g1", "h1")] * 10)
    out = await llm.generate_n_responses("p", n=10)
    assert len(out) == 10 and all(pair == ("g1", "h1") for pair in out)
    assert llm.generate_response.await_count == 10
    assert create.await_count == 1


@pytest.mark.asyncio
async def test_generate_n_responses_retriable_errors_until_fail(
    mocker, patch_simple_exceptions
):
    Rate = patch_simple_exceptions["RateLimitError"]
    create = patch_async_openai(mocker, [Rate("rl")] * 3)
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=3)
    out = await llm.generate_n_responses("p", n=4)
    assert out == [(None, None)] * 4
    assert create.await_count == 3
    # sleeps between attempts: 2 times (between 1->2 and 2->3)
    assert mock_sleep.await_count == 2


# ---------------------------
# generate_feedback + parser
# ---------------------------


@pytest.mark.asyncio
async def test_generate_feedback_success_and_stats(mocker):
    txt = (
        "<SCORE>\n10\n</SCORE>\n\n"
        "<JUSTIFICATION>\nAll good\n</JUSTIFICATION>\n\n"
        "<ANALYSIS>\nDiscuss PPA.\n</ANALYSIS>"
    )
    completion = make_chat_completion([txt], prompt_tokens=4, completion_tokens=8)
    patch_async_openai(mocker, completion)

    llm = LLMInterface(api_key="k")
    out = await llm.generate_feedback("prob", "code", "log")
    assert out == {"score": 10, "justification": "All good", "analysis": "Discuss PPA."}

    stats = await llm.get_and_reset_usage_stats()
    # Even for feedback, overall counters are incremented
    assert stats["api_calls"] == 1
    assert stats["prompt_tokens"] == 4
    assert stats["completion_tokens"] == 8


def test_parse_feedback_response_fallback_when_tags_missing():
    llm = LLMInterface(api_key="k")
    raw = "some freeform text"
    parsed = llm._parse_feedback_response(raw)
    assert parsed["score"] is None
    assert parsed["justification"] == "Parsing failed."
    assert parsed["analysis"] == raw


@pytest.mark.asyncio
async def test_generate_feedback_retriable_then_success(
    mocker, patch_simple_exceptions
):
    Timeout = patch_simple_exceptions["APITimeoutError"]
    completion = make_chat_completion(
        ["<SCORE>7</SCORE><JUSTIFICATION>ok</JUSTIFICATION><ANALYSIS>stuff</ANALYSIS>"]
    )
    create = patch_async_openai(mocker, [Timeout("t"), completion])
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=2)
    out = await llm.generate_feedback("prob", "code", "log")
    assert out["score"] == 7
    assert create.await_count == 2
    assert mock_sleep.await_count == 1


@pytest.mark.asyncio
async def test_generate_feedback_max_retries_failure(mocker, patch_simple_exceptions):
    Internal = patch_simple_exceptions["InternalServerError"]
    create = patch_async_openai(mocker, [Internal("x"), Internal("x"), Internal("x")])
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=3)
    out = await llm.generate_feedback("prob", "code", "log")
    assert out["score"] == 0
    justification = out["justification"]
    if isinstance(justification, str):
        assert "failed after multiple retries" in justification.lower()
    else:
        pytest.fail(
            f"Expected justification to be a string, got {type(justification)}: {justification}"
        )
    assert create.await_count == 3
    assert mock_sleep.await_count == 2


# ---------------------------
# Batch APIs
# ---------------------------


@pytest.mark.asyncio
async def test_generate_batch_responses_dispatch_and_modes(mocker):
    llm = LLMInterface(api_key="k")
    # Spy/patch generate_response so we don't touch the network
    llm.generate_response = AsyncMock(
        side_effect=[("t1", "c1"), ("t2", "c2"), ("t3", "c3")]
    )
    prompts: list[LLMRequest] = [
        {"prompt": "p1"},  # default whole
        {"prompt": "p2", "generation_mode": "diff"},
        {"prompt": "p3"},
    ]
    out = await llm.generate_batch_responses(
        prompts, temperature=0.2, top_p=0.9, max_tokens=99
    )
    assert out == [("t1", "c1"), ("t2", "c2"), ("t3", "c3")]
    # Ensure the 'diff' mode was passed to the second call
    args_list = llm.generate_response.call_args_list
    assert args_list[1].kwargs["generation_mode"] == "diff"


@pytest.mark.asyncio
async def test_generate_batch_feedback_dispatch(mocker):
    llm = LLMInterface(api_key="k")
    llm.generate_feedback = AsyncMock(
        side_effect=[
            {"score": 1, "justification": "a", "analysis": "x"},
            {"score": 2, "justification": "b", "analysis": "y"},
        ]
    )
    reqs = [
        {"problem_def": "P1", "verilog_code": "V1", "simulation_log": "L1"},
        {"problem_def": "P2", "verilog_code": "V2", "simulation_log": "L2"},
    ]
    out = await llm.generate_batch_feedback(
        reqs, temperature=0.4, top_p=0.9, max_tokens=50
    )
    assert out[0]["score"] == 1 and out[1]["score"] == 2
