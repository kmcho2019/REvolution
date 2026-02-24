import asyncio
import json
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
    mock_choice.message.content = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "whole",
            "thought": "Test thought.",
            "code": "Test code.",
        }
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
    thought, code, meta = await llm.generate_response("some prompt")

    # Assert
    assert thought == "Test thought."
    assert code == "Test code."
    assert meta["format_ok"] is True
    # Ensure the API call counter was incremented
    result_dict = await llm.get_and_reset_usage_stats()
    assert result_dict["api_calls"] == 1


@pytest.mark.asyncio
async def test_generate_batch_responses_dispatches_individual_prompts(mocker):
    llm = LLMInterface(api_key="fake")
    calls = []

    async def fake_generate(prompt, temperature, top_p, max_tokens, generation_mode="whole", system_prompt_override=None):
        calls.append((prompt, generation_mode, temperature, top_p, max_tokens))
        idx = len(calls)
        return (f"thought-{idx}", f"code-{idx}", {"format_ok": True})

    mocker.patch.object(
        llm,
        "generate_response",
        side_effect=fake_generate,
    )

    prompts: list[LLMRequest] = [
        {"prompt": "p1", "generation_mode": "whole"},
        {"prompt": "p2", "generation_mode": "diff", "system_prompt": "sys"},
    ]

    results = await llm.generate_batch_responses(
        prompts,
        temperature=0.7,
        top_p=0.9,
        max_tokens=512,
    )

    assert [r[0] for r in results] == ["thought-1", "thought-2"]
    assert calls[0][:2] == ("p1", "whole")
    assert calls[1][:2] == ("p2", "diff")
    # Temperature/top_p/max_tokens forwarded unchanged
    assert calls[0][2:] == (0.7, 0.9, 512)


@pytest.mark.asyncio
async def test_generate_batch_responses_honors_per_request_max_tokens(mocker):
    llm = LLMInterface(api_key="fake")
    calls = []

    async def fake_generate(
        prompt,
        temperature,
        top_p,
        max_tokens,
        generation_mode="whole",
        system_prompt_override=None,
    ):
        calls.append((prompt, generation_mode, max_tokens))
        return ("thought", "code", {"format_ok": True})

    mocker.patch.object(
        llm,
        "generate_response",
        side_effect=fake_generate,
    )

    prompts: list[LLMRequest] = [
        {"prompt": "p1", "generation_mode": "whole"},
        {"prompt": "p2", "generation_mode": "diff", "max_tokens": 123},
    ]

    await llm.generate_batch_responses(
        prompts,
        temperature=0.7,
        top_p=0.9,
        max_tokens=512,
    )
    assert calls == [("p1", "whole", 512), ("p2", "diff", 123)]


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


def test_vllm_custom_host_and_port():
    llm = LLMInterface(
        api_key=None,
        api_backend="vllm",
        port=9001,
        vllm_host="172.17.0.1",
    )
    assert llm.client_args["base_url"] == "http://172.17.0.1:9001/v1"


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
    text = json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T", "code": "C"})
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
    completion = make_chat_completion(
        [json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T", "code": "C"})]
    )
    create = patch_async_openai(mocker, completion)

    llm = LLMInterface(api_key="k", model_name="m")
    t, c, meta = await llm.generate_response("p", generation_mode="whole")
    assert (t, c) == ("T", "C")
    assert meta["format_ok"] is True and meta["parsed_mode"] == "whole"

    # Ensure system prompt for 'whole' was used
    msgs = create.call_args.kwargs["messages"]
    assert (
        msgs[0]["role"] == "system"
        and "expert Verilog design assistant" in msgs[0]["content"]
    )

    # Now check 'diff' content shows diff-format hints
    completion2 = make_chat_completion(
        [
            json.dumps(
                {
                    "format": "eoh_v1",
                    "mode": "diff",
                    "thought": "T2",
                    "code": {
                        "edits": [
                            {
                                "file": "mod.sv",
                                "hunks": [{"search": "old\n", "replace": "new\n"}],
                            }
                        ]
                    },
                }
            )
        ]
    )
    create.side_effect = [completion2]  # next call
    t2, c2, meta2 = await llm.generate_response("p2", generation_mode="diff")
    assert t2 == "T2"
    assert c2 == json.dumps(
        {
            "edits": [
                {
                    "file": "mod.sv",
                    "hunks": [{"search": "old\n", "replace": "new\n"}],
                }
            ]
        },
        separators=(",", ":"),
    )
    assert meta2["format_ok"] is True and meta2["parsed_mode"] == "diff"
    msgs2 = create.call_args.kwargs["messages"]
    assert "The search text must match the existing file content exactly" in msgs2[0]["content"]


def test_strict_validate_rejects_empty_diff_edits_and_hunks():
    llm = LLMInterface(api_key="k")
    bad_empty_edits = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "diff",
            "thought": "x",
            "code": {"edits": []},
        }
    )
    ok, _, err = llm._strict_validate_eoh(bad_empty_edits)
    assert ok is False
    assert "code.edits" in (err or "")

    bad_empty_hunks = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "diff",
            "thought": "x",
            "code": {"edits": [{"file": "a.sv", "hunks": []}]},
        }
    )
    ok2, _, err2 = llm._strict_validate_eoh(bad_empty_hunks)
    assert ok2 is False
    assert "hunks" in (err2 or "")


def test_strict_validate_normalizes_top_level_edits_and_infers_diff_mode():
    llm = LLMInterface(api_key="k")
    payload = json.dumps(
        {
            "format": "eoh_v1",
            "thought": "x",
            "edits": [
                {
                    "file": "a.sv",
                    "hunks": [{"search": "old\n", "replace": "new\n"}],
                }
            ],
        }
    )
    ok, normalized, err = llm._strict_validate_eoh(payload)
    assert ok is True, err
    assert normalized["mode"] == "diff"
    assert isinstance(normalized["code"], dict)
    assert normalized["code"]["edits"][0]["file"] == "a.sv"


def test_strict_validate_rejects_multi_file_diff_payload():
    llm = LLMInterface(api_key="k")
    payload = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "diff",
            "thought": "x",
            "code": {
                "edits": [
                    {"file": "a.sv", "hunks": [{"search": "a\n", "replace": "b\n"}]},
                    {"file": "b.sv", "hunks": [{"search": "x\n", "replace": "y\n"}]},
                ]
            },
        }
    )
    ok, _, err = llm._strict_validate_eoh(payload)
    assert ok is False
    assert "single-file diff expected" in (err or "")


@pytest.mark.asyncio
async def test_generate_response_empty_content_then_success(mocker):
    empty = make_chat_completion(["  "])
    good = make_chat_completion(
        [json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "A", "code": "B"})]
    )
    create = patch_async_openai(mocker, [empty, good])
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=2)
    t, c, meta = await llm.generate_response("prompt")
    assert (t, c) == ("A", "B")
    assert meta["format_ok"] is True
    assert create.await_count == 2  # retried once


@pytest.mark.asyncio
async def test_generate_response_empty_content_respects_empty_retry_budget(mocker):
    empty = make_chat_completion(["  "])
    create = patch_async_openai(mocker, [empty, empty, empty, empty])
    llm = LLMInterface(api_key="k", max_retries=10, max_empty_response_attempts=2)
    t, c, meta = await llm.generate_response("prompt")
    assert (t, c) == (None, None)
    assert meta["format_ok"] is False
    assert meta["error"] == "empty-response-retries-exhausted"
    assert create.await_count == 2


@pytest.mark.asyncio
async def test_generate_response_retriable_then_success(
    mocker, patch_simple_exceptions
):
    BadRate = patch_simple_exceptions["RateLimitError"]
    create = patch_async_openai(
        mocker,
        [
            BadRate("x"),
            make_chat_completion(
                [json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T", "code": "C"})]
            ),
        ],
    )
    # no-op sleep
    mock_sleep = AsyncMock()
    pytest.MonkeyPatch().setattr(
        "revolution.llm.asyncio.sleep", mock_sleep, raising=False
    )

    llm = LLMInterface(api_key="k", max_retries=2)
    t, c, meta = await llm.generate_response("p")
    assert (t, c) == ("T", "C")
    assert meta["format_ok"] is True
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
    t, c, meta = await llm.generate_response("p")
    assert (t, c) == (None, None)
    assert meta["format_ok"] is False
    assert create.await_count == 3
    assert mock_sleep.await_count == 2  # between attempts


@pytest.mark.asyncio
async def test_generate_response_bad_request_immediate_fail(
    mocker, patch_simple_exceptions
):
    BadReq = patch_simple_exceptions["BadRequestError"]
    create = patch_async_openai(mocker, BadReq("nope"))
    llm = LLMInterface(api_key="k", max_retries=3)
    t, c, meta = await llm.generate_response("p")
    assert (t, c) == (None, None)
    assert meta["format_ok"] is False
    assert create.await_count == llm.max_retries


# ---------------------------
# generate_n_responses
# ---------------------------


@pytest.mark.asyncio
async def test_generate_n_responses_success_counts_and_parsing(mocker):
    n = 3
    texts = [
        json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T1", "code": "C1"}),
        json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T2", "code": "C2"}),
        json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "T3", "code": "C3"}),
    ]
    completion = make_chat_completion(texts, prompt_tokens=9, completion_tokens=12)
    patch_async_openai(mocker, completion)

    llm = LLMInterface(api_key="k")
    out = await llm.generate_n_responses("p", n=n)
    assert [(t, c) for t, c, _ in out] == [("T1", "C1"), ("T2", "C2"), ("T3", "C3")]

    # Stats: api_calls += n (n_calls=n), tokens add once from usage (current implementation)
    stats = await llm.get_and_reset_usage_stats()
    assert stats["api_calls"] == n
    assert stats["prompt_tokens"] == 9
    assert stats["completion_tokens"] == 12


@pytest.mark.asyncio
async def test_generate_n_responses_keeps_empty_choice_as_failed_entry(mocker):
    completion = make_chat_completion(["   "], prompt_tokens=2, completion_tokens=1)
    patch_async_openai(mocker, completion)
    llm = LLMInterface(api_key="k")
    out = await llm.generate_n_responses("p", n=1)
    assert len(out) == 1
    t, c, meta = out[0]
    assert t is None and c is None
    assert meta["format_ok"] is False
    assert meta["error"] == "empty-response"


@pytest.mark.asyncio
async def test_generate_n_responses_partial_then_fallback(mocker):
    # API returns only 1 choice even though n=3, then we fallback to two individual calls.
    first = make_chat_completion(
        [json.dumps({"format": "eoh_v1", "mode": "whole", "thought": "A", "code": "B"})]
    )
    create = patch_async_openai(mocker, first)

    llm = LLMInterface(api_key="k")
    # Patch generate_response for the fallback remainder
    llm.generate_response = AsyncMock(
        side_effect=[("T2", "C2", {"format_ok": True}), ("T3", "C3", {"format_ok": True})]
    )

    out = await llm.generate_n_responses("p", n=3)
    assert [(t, c) for t, c, _ in out] == [("A", "B"), ("T2", "C2"), ("T3", "C3")]
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
        side_effect=[
            ("X1", "Y1", {"format_ok": True}),
            ("X2", "Y2", {"format_ok": True}),
            ("X3", "Y3", {"format_ok": True}),
        ]
    )
    out = await llm.generate_n_responses("p", n=3)
    assert [(t, c) for t, c, _ in out] == [("X1", "Y1"), ("X2", "Y2"), ("X3", "Y3")]
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
    llm.generate_response = AsyncMock(
        side_effect=[("g1", "h1", {"format_ok": True})] * 10
    )
    out = await llm.generate_n_responses("p", n=10)
    assert len(out) == 10 and all((t, c) == ("g1", "h1") for t, c, _ in out)
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
    assert len(out) == 4
    for t, c, meta in out:
        assert (t, c) == (None, None)
        assert meta["format_ok"] is False
    assert create.await_count == 3
    # sleeps between attempts: 2 times (between 1->2 and 2->3)
    assert mock_sleep.await_count == 2


# ---------------------------
# generate_feedback + parser
# ---------------------------


@pytest.mark.asyncio
async def test_generate_feedback_success_and_stats(mocker):
    txt = json.dumps(
        {
            "score": 10,
            "justification": "All good",
            "analysis": "Discuss PPA.",
        }
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
        [json.dumps({"score": 7, "justification": "ok", "analysis": "stuff"})]
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
        side_effect=[
            ("t1", "c1", {"format_ok": True}),
            ("t2", "c2", {"format_ok": True}),
            ("t3", "c3", {"format_ok": True}),
        ]
    )
    prompts: list[LLMRequest] = [
        {"prompt": "p1"},  # default whole
        {"prompt": "p2", "generation_mode": "diff"},
        {"prompt": "p3"},
    ]
    out = await llm.generate_batch_responses(
        prompts, temperature=0.2, top_p=0.9, max_tokens=99
    )
    assert [(r[0], r[1]) for r in out] == [("t1", "c1"), ("t2", "c2"), ("t3", "c3")]
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
        {"problem_def": "P1", "code": "V1", "simulation_log": "L1"},
        {"problem_def": "P2", "code": "V2", "simulation_log": "L2"},
    ]
    out = await llm.generate_batch_feedback(
        reqs, temperature=0.4, top_p=0.9, max_tokens=50
    )
    assert out[0]["score"] == 1 and out[1]["score"] == 2


@pytest.mark.asyncio
async def test_generate_batch_feedback_validates_override_lengths():
    llm = LLMInterface(api_key="k")
    reqs = [{"problem_def": "P", "code": "C", "simulation_log": "L"}]

    with pytest.raises(ValueError):
        await llm.generate_batch_feedback(
            reqs,
            temperature=0.5,
            top_p=0.9,
            max_tokens=64,
            system_prompt_override=["sys", "extra"],
        )

    with pytest.raises(ValueError):
        await llm.generate_batch_feedback(
            reqs,
            temperature=0.5,
            top_p=0.9,
            max_tokens=64,
            user_prompt_override=["usr", "extra"],
        )


@pytest.mark.asyncio
async def test_generate_batch_feedback_forwards_overrides(mocker):
    llm = LLMInterface(api_key="k")
    llm.generate_feedback = AsyncMock(
        return_value={"score": 5, "justification": "ok", "analysis": "notes"}
    )
    reqs = [{"problem_def": "P", "code": "C", "simulation_log": "L"}]

    out = await llm.generate_batch_feedback(
        reqs,
        temperature=0.3,
        top_p=0.8,
        max_tokens=128,
        system_prompt_override=["sys"],
        user_prompt_override=["usr"],
    )

    assert out[0]["score"] == 5
    assert llm.generate_feedback.await_count == 1
    kwargs = llm.generate_feedback.await_args.kwargs
    assert kwargs["system_prompt_override"] == "sys"
    assert kwargs["user_prompt_override"] == "usr"
