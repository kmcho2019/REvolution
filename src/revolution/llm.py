import asyncio
import random
import re
from collections.abc import Coroutine
from typing import Any, Literal, NotRequired, TypedDict

from openai import (
    APIConnectionError,
    APITimeoutError,
    AsyncOpenAI,
    BadRequestError,
    InternalServerError,
    RateLimitError,
)
from openai.types.chat import ChatCompletion


# Define the precise shape of an LLM request dictionary
class LLMRequest(TypedDict):
    """
    Defines the structure for a single request to the language model.

    This dictionary specifies the prompt and the mode of generation to be used
    for producing code or text.

    Attributes:
        prompt (str): The required prompt string to be sent to the LLM.
        generation_mode (Literal["whole", "diff"], optional): The strategy for
            code generation. 'whole' indicates the LLM should generate a
            complete file, while 'diff' indicates it should generate a patch
            in the diff format. Defaults to 'whole' if omitted.
    """

    prompt: str
    generation_mode: NotRequired[Literal["whole", "diff"]]


class LLMInterface:
    """
    Unified interface for calling an LLM backend (OpenAI, OpenRouter, DeepSeek, vLLM).

    Manages API-key configuration, retry/backoff logic, and parsing of
    “thought”/“code” blocks or structured feedback.
    """

    def __init__(
        self,
        api_key: str | None = None,
        model_name: str = "gpt-3.5-turbo",
        api_backend: str = "openai",
        max_retries: int = 10,
        base_delay: float = 2.0,
    ) -> None:
        """
        :param api_key:      Your LLM API key (not required for 'vllm' backend).
        :param model_name:   Model identifier to send in the request.
        :param api_backend:  One of "openai", "openrouter", "deepseek", or "vllm".
        :param max_retries:  Maximum number of retry attempts for transient errors.
        :param base_delay:   Initial backoff delay in seconds (doubles each retry).
        :raises ValueError:  If api_key is missing for non-vllm backends, or
                             api_backend is unsupported.
        """
        if not api_key and api_backend != "vllm":
            raise ValueError("API key is required for LLMInterface initialization.")

        self.api_backend: str = api_backend  # Backend API to use, e.g., "openai", "openrouter", "deepseek", etc.
        self.model_name: str = model_name
        self.max_retries: int = max_retries  # Maximum number of retries
        self.base_delay: float = base_delay  # Base delay in seconds for backoff

        # Configure arguments for the AsyncOpenAI client based on the backend
        self.client_args: dict[str, Any] = {
            "api_key": api_key,
            "timeout": 120.0,  # Set a reasonable timeout for API calls
        }

        if api_backend == "openai":
            # Default OpenAI, no extra args needed
            pass
        elif api_backend == "openrouter":
            self.client_args["base_url"] = "https://openrouter.ai/api/v1"
        elif api_backend == "deepseek":
            self.client_args["base_url"] = "https://api.deepseek.com"
        elif api_backend == "gemini":
            self.client_args["base_url"] = (
                "https://generativelanguage.googleapis.com/v1beta/openai"
            )
        elif api_backend == "vllm":
            self.client_args["base_url"] = (
                "http://localhost:8000/v1"  # Assuming that vLLM server is running locally
            )

        else:
            raise ValueError(
                f"Unsupported API backend: '{api_backend}'. Choose from 'openai', 'openrouter', 'deepseek'."
            )

        self.api_call_count: int = 0  # Initialize API call counter
        self.prompt_tokens_count = 0  # Initialize prompt tokens counter
        self.completion_tokens_count = 0  # Initialize completion tokens counter
        self.code_prompt_tokens_count = 0  # Initialize code prompt tokens counter
        self.code_completion_tokens_count = (
            0  # Initialize code completion tokens counter
        )
        self.feedback_prompt_tokens_count = (
            0  # Initialize feedback prompt tokens counter
        )
        self.feedback_completion_tokens_count = (
            0  # Initialize feedback completion tokens counter
        )
        self.lock: asyncio.Lock = (
            asyncio.Lock()
        )  # Make counter thread-safe with async calls

    # Method for managing API call count in a thread-safe manner
    async def _update_stats(
        self,
        completion: ChatCompletion,
        n_calls: int = 1,
        completion_type: Literal["code", "feedback"] = "code",
    ) -> None:
        """
        Thread-safe update of the internal counters for API calls and token usage.
        Dependeing on the completion type, it updates the respective token counters.

        :param completion: The ChatCompletion object from the API call.
        :param n_calls:    Number of calls to add (default: 1).
        :param completion_type: Type of completion ("code" or "feedback").
        """
        async with self.lock:
            self.api_call_count += n_calls
            if completion and completion.usage:
                self.prompt_tokens_count += completion.usage.prompt_tokens
                self.completion_tokens_count += completion.usage.completion_tokens
                if completion_type == "code":
                    self.code_prompt_tokens_count += completion.usage.prompt_tokens
                    self.code_completion_tokens_count += (
                        completion.usage.completion_tokens
                    )
                elif completion_type == "feedback":
                    self.feedback_prompt_tokens_count += completion.usage.prompt_tokens
                    self.feedback_completion_tokens_count += (
                        completion.usage.completion_tokens
                    )

    # Synchronous method that will be called my main engine thread
    async def get_and_reset_usage_stats(self) -> dict[str, int]:
        """
        Retrieve accumulated stats since the last reset, then zero them out.
        This operation is async to be thread-safe.

        :return: A dictionary with counts for API calls, prompt tokens, and completion tokens.
        """
        async with self.lock:
            stats = {
                "api_calls": self.api_call_count,
                "prompt_tokens": self.prompt_tokens_count,
                "completion_tokens": self.completion_tokens_count,
                "code_prompt_tokens": self.code_prompt_tokens_count,
                "code_completion_tokens": self.code_completion_tokens_count,
                "feedback_prompt_tokens": self.feedback_prompt_tokens_count,
                "feedback_completion_tokens": self.feedback_completion_tokens_count,
            }
            # Reset counters
            self.api_call_count = 0
            self.prompt_tokens_count = 0
            self.completion_tokens_count = 0
            return stats

    def parse_thought_and_code(self, response_text: str) -> tuple[str, str]:
        """
        Extract the “thought” and “code” blocks from a raw LLM completion.

        Expects:
            ```thought
            ...
            ```
            ```code
            ...
            ```

        :param response_text: Full text from the LLM.
        :return: A (thought, code) tuple, each `None` if parsing failed.
                 If either is missing, returns `(full_text_with_warnings, full_text_with_warnings)`.
        """
        thought_match = re.search(
            r"```thought\s*\n(.*?)\n```", response_text, re.DOTALL
        )
        code_match = re.search(r"```code\s*\n(.*?)\n```", response_text, re.DOTALL)

        thought = thought_match.group(1).strip() if thought_match else None
        code = code_match.group(1).strip() if code_match else None

        # When either thought or code is not found, we do not raise an exception.
        # Instead of raising exception ValueError for parsing issues or missing blocks,
        # we just return the original response text.
        # This allows the caller to handle the error gracefully, e.g., by logging it or
        # retrying with a different prompt.

        if thought is None or code is None:
            append_text = "\n\n--- WARNING: Parsing Issues ---\n"
            if thought is None:
                print(
                    f"Warning: Could not parse 'thought' from LLM response. Expected ```thought ... ``` block. Response:\n{response_text[:500]}..."
                )
                append_text += "Could not parse 'thought' from LLM response. Expected ```thought ... ``` block.(PARSE_ERROR)\n"
            if code is None:
                print(
                    f"Warning: Could not parse 'code' from LLM response. Expected ```code ... ``` block. Response:\n{response_text[:500]}..."
                )
                append_text += "Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)\n"

            # Append to the response text to indicate parsing issues
            response_text_with_issues = response_text + append_text
            return response_text_with_issues, response_text_with_issues
        else:
            return thought, code

    async def generate_response(
        self,
        prompt: str,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        generation_mode: Literal["whole", "diff"] = "whole",
    ) -> tuple[str | None, str | None]:
        """
        Generate a single (thought, code) reply for a user prompt.

        Handles API calls, retries on transient errors with exponential backoff,
        and parsing of the response.

        Retries on transient errors with exponential backoff + jitter.

        :param prompt:       The user`s Verilog/design question.
        :type prompt: str
        :param temperature:  Sampling temperature.
        :type temperature: float
        :param top_p:        Nucleus sampling threshold.
        :type top_p: float
        :param max_tokens:   Maximum tokens to generate.
        :type max_tokens: int
        :param generation_mode: Mode of generation, either "whole" or "diff".
        :type generation_mode: Literal["whole", "diff"]
        :return: A (thought, code) tuple, or (None, None) on failure.
        """
        # print(f"\n--- LLM Request ---")
        # print(f"Prompt (first 200 chars):\n{prompt[:200]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        full_response_text = ""

        system_prompt_content = ""
        if generation_mode == "whole":
            system_prompt_content = (
                "You are an expert Verilog design assistant. "
                "Your role is to address Verilog-related problems posed by the user. "
                "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
                "The 'thought' is your conceptual idea for solving the problem. "
                "The 'code' is the Verilog implementation of your 'thought'.\n"
                "Strictly format your response as follows:\n"
                "```thought\n"
                "[Your concise design idea (thought) here]\n"
                "```\n"
                "```code\n"
                "[Your complete, runnable Verilog implementation of the thought here]\n"
                "```"
            )
        else:  # diff mode
            system_prompt_content = (
                "You are an expert Verilog design assistant that modifies code based on user requests.\n"
                "You will be given the file path, the file content, and instructions for what to change.\n"
                "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
                "You MUST format your response with a `thought` block and a `code` block.\n"
                "The 'thought' is your conceptual idea for solving the problem. "
                "The 'code' is the contains the diff block containing the Verilog implementation for your 'thought'.\n"
                "Strictly format your response as follows:\n"
                "```thought\n"
                "[Your concise design idea (thought) here]\n"
                "```\n"
                "```code\n"
                "[diff block containing the Verilog implementation for your thought here]\n"
                "```"
                "The `code` block must contain *only* the edits in the specified diff format.\n"
                "The diff format for the `code` block is as follows:\n\n"
                "the/full/path/to/the/file.sv\n"
                "```\n"
                "<<<<<<< SEARCH\n"
                "A contiguous block of lines to search for.\n"
                "=======\n"
                "The lines to replace the SEARCH block with.\n"
                ">>>>>>> REPLACE\n"
                "```\n\n"
                "- The `SEARCH` block must match the existing file content *exactly*, including whitespace and comments.\n"
                "- You can use multiple `SEARCH/REPLACE` blocks for a single file.\n"
                "- To create a new file (e.g., from a Crossover strategy or initial generation), use a *SEARCH/REPLACE block* with:\n"
                "  - A new file path, including dir name if needed\n"
                "  - An empty `SEARCH` section\n"
                "  - The new file's contents in the `REPLACE` section\n"
                "- Sometimes the file path may not be known, in which case you can use a placeholder like `new_file.sv`.\n"
            )

        # Use 'async with' to manage the client's lifecycle correctly
        async with AsyncOpenAI(**self.client_args) as client:
            for attempt in range(self.max_retries):
                try:
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {
                                "role": "system",
                                "content": system_prompt_content,
                            },
                            {
                                "role": "user",
                                "content": prompt,
                            },
                        ],
                        model=self.model_name,
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p,
                    )
                    # Increment the API call count and token usage
                    await self._update_stats(
                        chat_completion, n_calls=1, completion_type="code"
                    )

                    content = chat_completion.choices[0].message.content

                    # If the response content is valid, parse it and return.
                    if content and content.strip():
                        full_response_text = content.strip()
                        thought, code = self.parse_thought_and_code(full_response_text)
                        return thought, code

                    # If content is None or empty, we'll treat it as a retriable issue.
                    # The code will fall through to the retry logic below.
                    print(
                        f"Warning: Received empty response from API on attempt {attempt + 1}/{self.max_retries}."
                    )

                except (
                    APIConnectionError,
                    RateLimitError,
                    APITimeoutError,
                    InternalServerError,
                ) as e:
                    print(
                        f"OpenAI API call failed on attempt {attempt + 1}/{self.max_retries}: {e}"
                    )
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        return None, None

                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(
                        f"An unexpected, non-retriable error occurred in generate_response: {e}"
                    )
                    return None, None
        print("Failed to generate a response after multiple retries.")
        return None, None

    # This new method uses the 'n' parameter for more efficient batching of identical prompts.
    async def generate_n_responses(
        self,
        prompt: str,
        n: int,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        generation_mode: Literal["whole", "diff"] = "whole",
    ) -> list[tuple[str | None, str | None]]:
        """
        Generates 'n' different responses for a single prompt.

        Attempts to use the 'n' parameter for a single, efficient API call.
        If the backend does not support 'n' > 1, it gracefully falls back
        to making 'n' individual, concurrent requests.

        :param prompt: The user's Verilog/design question.
        :type prompt: str
        :param n: The number of desired responses.
        :type n: int
        :param temperature: Sampling temperature.
        :type temperature: float
        :param top_p: Nucleus sampling threshold.
        :type top_p: float
        :param max_tokens: Maximum tokens to generate.
        :type max_tokens: int
        :param generation_mode: Mode of generation, either "whole" or "diff".
        :type generation_mode: Literal["whole", "diff"]
        :return: A list of (thought, code) tuples.
        """
        print(f"\n--- Sending Single-Prompt Batch Request for {n} responses ---")

        system_prompt_content = ""
        if generation_mode == "whole":
            system_prompt_content = (
                "You are an expert Verilog design assistant. "
                "Your role is to address Verilog-related problems posed by the user. "
                "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
                "The 'thought' is your conceptual idea for solving the problem. "
                "The 'code' is the Verilog implementation of your 'thought'.\n"
                "Strictly format your response as follows:\n"
                "```thought\n"
                "[Your concise design idea (thought) here]\n"
                "```\n"
                "```code\n"
                "[Your complete, runnable Verilog implementation of the thought here]\n"
                "```"
            )
        else:  # diff mode
            system_prompt_content = (
                "You are an expert Verilog design assistant that modifies code based on user requests.\n"
                "You will be given the file path, the file content, and instructions for what to change.\n"
                "For each problem, you must provide both a 'thought' and the corresponding 'code'. "
                "You MUST format your response with a `thought` block and a `code` block.\n"
                "The 'thought' is your conceptual idea for solving the problem. "
                "The 'code' is the contains the diff block containing the Verilog implementation for your 'thought'.\n"
                "Strictly format your response as follows:\n"
                "```thought\n"
                "[Your concise design idea (thought) here]\n"
                "```\n"
                "```code\n"
                "[diff block containing the Verilog implementation for your thought here]\n"
                "```"
                "The `code` block must contain *only* the edits in the specified diff format.\n"
                "The diff format for the `code` block is as follows:\n\n"
                "the/full/path/to/the/file.sv\n"
                "```\n"
                "<<<<<<< SEARCH\n"
                "A contiguous block of lines to search for.\n"
                "=======\n"
                "The lines to replace the SEARCH block with.\n"
                ">>>>>>> REPLACE\n"
                "```\n\n"
                "- The `SEARCH` block must match the existing file content *exactly*, including whitespace and comments.\n"
                "- You can use multiple `SEARCH/REPLACE` blocks for a single file.\n"
                "- To create a new file (e.g., from a Crossover strategy or initial generation), use a *SEARCH/REPLACE block* with:\n"
                "  - A new file path, including dir name if needed\n"
                "  - An empty `SEARCH` section\n"
                "  - The new file's contents in the `REPLACE` section\n"
                "- Sometimes the file path may not be known, in which case you can use a placeholder like `new_file.sv`.\n"
            )

        async with AsyncOpenAI(**self.client_args) as client:
            for attempt in range(self.max_retries):
                try:
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {"role": "system", "content": system_prompt_content},
                            {"role": "user", "content": prompt},
                        ],
                        model=self.model_name,
                        n=n,  # Request n completions
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p,
                    )
                    # Increment the API call count and token usage
                    await self._update_stats(
                        chat_completion, n_calls=n, completion_type="code"
                    )

                    # *** START: WORKAROUND FOR OPENROUTER AND SIMILAR APIS ***
                    # Check if the API returned fewer responses than requested. This handles
                    # providers like OpenRouter that don't raise an error for n > 1 but only
                    # return a single response.
                    num_responses_received = len(chat_completion.choices)
                    if num_responses_received < n:
                        print(
                            f"Warning: API returned {len(chat_completion.choices)}/{n} responses. Requesting remaining concurrently."
                        )
                        # Parse the responses that were successfully received.
                        parsed = [
                            self.parse_thought_and_code(c.message.content.strip())
                            for c in chat_completion.choices
                            if c.message.content
                        ]
                        # Concurrently request the remaining responses.
                        num_remaining = n - len(parsed)
                        print(
                            f"Falling back to {num_remaining} individual concurrent requests for the remainder."
                        )
                        tasks = [
                            self.generate_response(
                                prompt,
                                temperature,
                                top_p,
                                max_tokens,
                                generation_mode=generation_mode,
                            )
                            for _ in range(num_remaining)
                        ]
                        remaining_results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {num_remaining} individual requests completed ---"
                        )
                        return parsed + remaining_results
                    # *** END: WORKAROUND ***

                    # Parse each of the 'n' choices in the response
                    return [
                        self.parse_thought_and_code(c.message.content.strip())
                        for c in chat_completion.choices
                        if c.message.content
                    ]

                except BadRequestError as e:
                    # Found that DeepSeek API does not support 'n' > 1, so we need to handle this case.
                    # As of 2025/07/08, OpenAI's API supports 'n' > 1, DeepSeek does not.
                    # This is a workaround for APIs that do not support 'n' > 1.
                    # Example of error message:
                    # Error code: 400 - {'error': {'message': 'Invalid n value (currently only n = 1 is supported)', 'type': 'invalid_request_error', 'param': None, 'code': 'invalid_request_error'}}
                    # This is the key fallback logic and workaround for DeepSeek and potentially other APIs that do not support 'n' > 1.
                    error_message = str(e).lower()
                    if (
                        "invalid n value" in error_message
                        or "only n = 1 is supported" in error_message
                    ):
                        print(
                            f"Warning: API backend '{self.api_backend}' does not support n > 1. Falling back to {n} individual requests."
                        )

                        # The individual 'generate_response' calls will handle their own retries and counting.
                        tasks = [
                            self.generate_response(
                                prompt,
                                temperature,
                                top_p,
                                max_tokens,
                                generation_mode=generation_mode,
                            )
                            for _ in range(n)
                        ]
                        results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {n} individual requests completed ---"
                        )
                        return results
                    # Found that Gemini API does not support only support n(candidateCount) of 1~8.
                    # As of 2025/08/07, OpenAI's API supports 'n' > 1, while Gemini has a limit of 8.
                    # This is a workaround for APIs that have a limit on 'n'.
                    # Example of error message:
                    # Error code: Error code: 400 - [{'error': {'code': 400, 'message': 'Invalid value of n: should be between 1 and 8, got 10', 'status': 'INVALID_ARGUMENT'}}]
                    # This is the key fallback logic and workaround for Gemini and potentially other APIs that has a limit on 'n'.
                    elif (
                        "invalid value of n" in error_message
                        and "should be between 1 and 8" in error_message
                    ):
                        print(
                            f"Warning: API backend '{self.api_backend}' supports n only between 1 and 8. Falling back to {n} individual requests."
                        )

                        # The individual 'generate_response' calls will handle their own retries and counting.
                        tasks = [
                            self.generate_response(
                                prompt,
                                temperature,
                                top_p,
                                max_tokens,
                                generation_mode=generation_mode,
                            )
                            for _ in range(n)
                        ]
                        results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {n} individual requests completed ---"
                        )
                        return results
                    else:
                        # It's a different, non-retriable bad request.
                        print(
                            f"A non-retriable BadRequestError occurred in generate_n_responses: {e}"
                        )
                        return [(None, None)] * n

                except (
                    APIConnectionError,
                    RateLimitError,
                    APITimeoutError,
                    InternalServerError,
                ) as e:
                    print(
                        f"OpenAI API call failed on attempt {attempt + 1}/{self.max_retries}: {e}"
                    )
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        return [(None, None)] * n  # Return failures

                    # Exponential backoff with jitter
                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(
                        f"An unexpected, non-retriable error occurred in generate_n_responses: {e}"
                    )
                    return [(None, None)] * n
        print("Failed to generate responses after multiple retries.")
        return [(None, None)] * n  # Return failures if all retries fail

    async def generate_feedback(
        self,
        problem_def: str,
        verilog_code: str,
        simulation_log: str,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
    ) -> dict[str, int | str | None]:
        """
        Analyzes Verilog code against a problem and simulation log to provide feedback.

        :param problem_def: The high-level problem description.
        :param verilog_code: The user's Verilog code submission.
        :param simulation_log: The log output from simulating the code.
        :param temperature: Sampling temperature for the feedback model.
        :param top_p: Nucleus sampling threshold.
        :param max_tokens: Maximum tokens for the feedback response.
        :return: A dictionary containing 'score', 'justification', and 'analysis'.
        """
        # print(f"\n--- LLM Feedback Generation Request ---")
        # print(f"Verilog Code (first 200 chars):\n{verilog_code[:200]}...")
        # print(f"Simulation Log (first 500 chars):\n{simulation_log[:500]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        # --- System prompt content for the LLM ---
        system_prompt_content = (
            # Role is expanded from a debugging expert to a broader Verilog expert.
            "You are a Verilog expert specializing in design, debugging, and optimization. You will be given a problem description, Verilog code, and a simulation log.\n\n"
            # Logic is now conditional based on the simulation outcome.
            "Your task is to analyze the submission. First, determine if the simulation log indicates a success or a failure.\n\n"
            "**If the simulation log shows failures (functional or syntax errors):**\n"
            "1. Use the problem description to understand the high-level design intent.\n"
            "2. Analyze the Verilog code and simulation log to pinpoint the exact code sections causing the errors.\n"
            "3. For each issue, explain the cause from the code's perspective, linking the low-level error back to the original design intent. Cite all relevant code sections.\n\n"
            "**If the simulation log shows success:**\n"
            "1. Confirm that the code is functionally correct according to the problem description and log.\n"
            "2. Your analysis should then focus on providing feedback to improve the design's **Power, Performance, and Area (PPA)** metrics.\n"
            "3. Suggest potential optimizations by commenting on:\n"
            "   - **Performance (Timing):** Identify long critical paths, inefficient state machine encodings, or blocking assignments that could hinder high-frequency operation.\n"
            "   - **Power:** Point out areas of high switching activity or redundant logic that could be optimized for lower power consumption.\n"
            "   - **Area:** Comment on logic structures that might consume significant chip area and suggest more resource-efficient design patterns (e.g., using shifters instead of multipliers for powers of two, resource sharing).\n\n"
            "**CRITICAL RULE: Under no circumstances should you provide full, corrected code snippets. Your sole purpose is to analyze the existing code and provide high-level feedback, not to rewrite the solution.**\n\n"
            "After your analysis, you **must** provide a score for the code on a scale of 0 to 10 based on the following criteria:\n"
            # NEW: Definition for a score of 10 is updated to trigger PPA analysis.
            "* **10 points:** The code is functionally correct and passes all simulation tests. Your analysis for this score **must** focus on PPA improvements.\n"
            "* **1-9 points:** The code is syntactically correct but fails simulation. The score should reflect the severity and number of functional errors.\n"
            "* **0 points:** The code has syntax errors and would not compile.\n\n"
            "Your entire response **must** strictly follow this format, using the provided tags. Do not add any text outside the tags:\n"
            "```text\n"
            "<SCORE>\n"
            "[Your score from 0 to 10]\n"
            "</SCORE>\n\n"
            "<JUSTIFICATION>\n"
            "[A brief, one or two-sentence justification for your score. If successful, state that it's functionally correct.]\n"
            "</JUSTIFICATION>\n\n"
            "<ANALYSIS>\n"
            "[Your detailed analysis. For failures, explain the bugs. For successes (score 10), provide PPA optimization feedback. **Remember: Do NOT suggest any fixes or write corrected code in this section.**]\n"
            "</ANALYSIS>\n"
            "```"
        )

        user_prompt = (
            "I wrote some Verilog code to solve a given problem. "
            "Please analyze the code and provide your feedback in the requested format.\n\n"
            "Problem Description:\n"
            "```problem\n"
            f"{problem_def}\n"
            "```\n\n"
            "Verilog Code:\n"
            "```verilog\n"
            f"{verilog_code}\n"
            "```\n\n"
            "Simulation Log:\n"
            "```log\n"
            f"{simulation_log}\n"
            "```\n\n"
        )

        async with AsyncOpenAI(**self.client_args) as client:
            for attempt in range(self.max_retries):
                try:
                    chat_completion = await client.chat.completions.create(
                        messages=[
                            {"role": "system", "content": system_prompt_content},
                            {"role": "user", "content": user_prompt},
                        ],
                        model=self.model_name,
                        temperature=temperature,
                        max_tokens=max_tokens,
                        top_p=top_p,
                    )
                    # Increment the API call count and token usage
                    await self._update_stats(
                        chat_completion, n_calls=1, completion_type="feedback"
                    )
                    if chat_completion.choices[0].message.content:
                        return self._parse_feedback_response(
                            chat_completion.choices[0].message.content.strip()
                        )

                except (
                    APIConnectionError,
                    RateLimitError,
                    APITimeoutError,
                    InternalServerError,
                ) as e:
                    print(
                        f"OpenAI API call for feedback failed on attempt {attempt + 1}/{self.max_retries}: {e}"
                    )
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the feedback request.")
                        return {
                            "score": 0,
                            "justification": "LLM call for feedback failed after multiple retries.",
                            "analysis": f"Could not generate feedback due to a persistent API error: {e}",
                        }

                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(
                        f"An unexpected, non-retriable error occurred in generate_feedback: {e}"
                    )
                    return {
                        "score": 0,
                        "justification": "An unexpected error occurred during the LLM call.",
                        "analysis": f"Could not generate feedback due to an unexpected error: {e}",
                    }
        return {
            "score": 0,
            "justification": "LLM call for feedback failed.",
            "analysis": f"Could not generate feedback due to an API errors after {self.max_retries} attempts.",
        }

    def _parse_feedback_response(
        self, feedback_text: str
    ) -> dict[str, int | str | None]:
        # Helper to parse the structured feedback response
        # This function extracts the score, justification, and analysis from the LLM response
        parsed_feedback = {
            "score": None,
            "justification": "Parsing failed.",
            "analysis": feedback_text,  # Default to raw text if parsing fails
        }
        try:
            score_match = re.search(r"<SCORE>(.*?)</SCORE>", feedback_text, re.DOTALL)
            justification_match = re.search(
                r"<JUSTIFICATION>(.*?)</JUSTIFICATION>", feedback_text, re.DOTALL
            )
            analysis_match = re.search(
                r"<ANALYSIS>(.*?)</ANALYSIS>", feedback_text, re.DOTALL
            )

            if score_match:
                parsed_feedback["score"] = int(score_match.group(1).strip())
            if justification_match:
                parsed_feedback["justification"] = justification_match.group(1).strip()
            if analysis_match:
                parsed_feedback["analysis"] = analysis_match.group(1).strip()

        except Exception as e:
            print(f"Error parsing LLM feedback: {e}. Returning raw text.")

        return parsed_feedback

    # Method for batching code generation requests
    async def generate_batch_responses(
        self,
        prompts: list[LLMRequest],
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
    ) -> list[tuple[str | None, str | None]]:
        """
        Generates responses for a batch of different prompts concurrently.

        :param prompts: A list of prompt dictionaries(LLMRequest),
        each with a "prompt" and optional "generation_mode" key storing the prompt string and generation mode string.
        :type prompts: list[LLMRequest]
        :param temperature: Sampling temperature.
        :type temperature: float
        :param top_p: Nucleus sampling threshold.
        :type top_p: float
        :param max_tokens: Maximum tokens to generate.
        :type max_tokens: int
        :return: A list of (thought, code) tuples corresponding to each prompt.
        :rtype: list[tuple[str | None, str | None]]
        """
        print(f"\n--- Sending Batch LLM Request for {len(prompts)} prompts ---")
        tasks: list[Coroutine[Any, Any, tuple[str | None, str | None]]] = [
            self.generate_response(
                p["prompt"],
                temperature,
                top_p,
                max_tokens,
                generation_mode=p.get("generation_mode", "whole"),
            )
            for p in prompts
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Response Received ---")
        return results

    # Method for batching feedback generation requests
    async def generate_batch_feedback(
        self, feedback_requests, temperature, top_p, max_tokens
    ):
        """
        Generates feedback for a batch of candidates concurrently.

        :param feedback_requests: A list of dictionaries, each with 'problem_def',
                                  'verilog_code', and 'simulation_log'.
        :param temperature: Sampling temperature.
        :param top_p: Nucleus sampling threshold.
        :param max_tokens: Maximum tokens to generate.
        :return: A list of feedback dictionaries.
        """
        print(
            f"\n--- Sending Batch LLM Feedback Request for {len(feedback_requests)} candidates ---"
        )
        tasks: list[Coroutine[Any, Any, dict[str, int | str | None]]] = [
            self.generate_feedback(
                req["problem_def"],
                req["verilog_code"],
                req["simulation_log"],
                temperature,
                top_p,
                max_tokens,
            )
            for req in feedback_requests
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Feedback Received ---")
        return results
