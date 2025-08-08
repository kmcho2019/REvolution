from unittest.mock import AsyncMock, MagicMock

import pytest

from revolution.llm import LLMInterface


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
