import os
import re
import random
import asyncio
from typing import Optional, Tuple, List, Dict, Any

from openai import (
    OpenAI,
    AsyncOpenAI,
    APIConnectionError,
    RateLimitError,
    InternalServerError,
    APITimeoutError,
    BadRequestError,
)


class LLMInterface:
    def __init__(
        self,
        api_key=None,
        model_name="gpt-3.5-turbo",
        api_backend="openai",
        max_retries=10,
        base_delay=2,
    ):
        if not api_key and api_backend != "vllm":
            raise ValueError("API key is required for LLMInterface initialization.")

        self.api_backend = api_backend  # Backend API to use, e.g., "openai", "openrouter", "deepseek", etc.
        self.model_name = model_name
        self.max_retries = max_retries  # Maximum number of retries
        self.base_delay = base_delay  # Base delay in seconds for backoff

        # Configure arguments for the AsyncOpenAI client based on the backend
        self.client_args = {
            "api_key": api_key,
            "timeout": 120,
        }

        if api_backend == "openai":
            # Default OpenAI, no extra args needed
            pass
        elif api_backend == "openrouter":
            self.client_args["base_url"] = "https://openrouter.ai/api/v1"
        elif api_backend == "deepseek":
            self.client_args["base_url"] = "https://api.deepseek.com"
        elif api_backend == "vllm":
            self.client_args["base_url"] = (
                "http://localhost:8000/v1"  # Assuming that vLLM server is running locally
            )

        else:
            raise ValueError(
                f"Unsupported API backend: '{api_backend}'. Choose from 'openai', 'openrouter', 'deepseek'."
            )

        self.api_call_count = 0  # Initialize API call counter
        self.lock = asyncio.Lock()  # Make counter thread-safe with async calls

    # Method for managing API call count in a thread-safe manner
    async def _increment_call_count(self, n=1):
        async with self.lock:
            self.api_call_count += n

    # Synchronous method that will be called my main engine thread
    def get_and_reset_api_calls(self):
        count = self.api_call_count
        self.api_call_count = 0  # Reset the counter after getting the value
        return count

    def parse_thought_and_code(self, response_text):
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
        self, prompt, temperature=1.0, top_p=1.0, max_tokens=2048
    ):
        # print(f"\n--- LLM Request ---")
        # print(f"Prompt (first 200 chars):\n{prompt[:200]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        full_response_text = ""

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

        # Use 'async with' to manage the client's lifecycle correctly
        async with AsyncOpenAI(**self.client_args) as client:
            for attempt in range(self.max_retries):
                try:
                    # Increment the API call count
                    await self._increment_call_count()
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
                    full_response_text = chat_completion.choices[
                        0
                    ].message.content.strip()
                    thought, code = self.parse_thought_and_code(full_response_text)
                    return thought, code

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

    # This new method uses the 'n' parameter for more efficient batching of identical prompts.
    async def generate_n_responses(
        self, prompt, n, temperature=1.0, top_p=1.0, max_tokens=2048
    ):
        """
        Generates 'n' different responses for a single prompt in a single API call.
        """
        print(f"\n--- Sending Single-Prompt Batch Request for {n} responses ---")

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

        async with AsyncOpenAI(**self.client_args) as client:
            for attempt in range(self.max_retries):
                try:
                    # Increment the API call count
                    await self._increment_call_count(
                        n
                    )  # Increment by 'n' since we're requesting n completions
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

                    # *** START: WORKAROUND FOR OPENROUTER AND SIMILAR APIS ***
                    # Check if the API returned fewer responses than requested. This handles
                    # providers like OpenRouter that don't raise an error for n > 1 but only
                    # return a single response.
                    num_responses_received = len(chat_completion.choices)
                    if num_responses_received < n:
                        print(
                            f"Warning: API backend '{self.api_backend}' returned {num_responses_received} response(s) for a batch request of {n}."
                        )
                        print(
                            "This indicates a lack of full support for the 'n' parameter."
                        )

                        # Parse the responses that were successfully received.
                        parsed_results = [
                            self.parse_thought_and_code(c.message.content.strip())
                            for c in chat_completion.choices
                        ]

                        # Concurrently request the remaining responses.
                        num_remaining = n - num_responses_received
                        print(
                            f"Falling back to {num_remaining} individual concurrent requests for the remainder."
                        )

                        tasks = [
                            self.generate_response(
                                prompt, temperature, top_p, max_tokens
                            )
                            for _ in range(num_remaining)
                        ]
                        remaining_results = await asyncio.gather(*tasks)

                        # Combine the initial results with the fallback results.
                        parsed_results.extend(remaining_results)
                        print(
                            f"--- Fallback with {num_remaining} individual requests completed ---"
                        )
                        return parsed_results
                    # *** END: WORKAROUND ***

                    # Parse each of the 'n' choices in the response
                    parsed_results = []
                    for choice in chat_completion.choices:
                        full_response_text = choice.message.content.strip()
                        try:
                            thought, code = self.parse_thought_and_code(
                                full_response_text
                            )
                            parsed_results.append((thought, code))
                        except ValueError as e:
                            print(
                                f"Warning: Failed to parse one of the initial responses: {e}"
                            )
                            # Debug
                            # print(f"\nSystem prompt: \n{system_prompt_content}")
                            # print(f"\nUser prompt: \n{prompt}")
                            # print(f"\nFull response text: \n{full_response_text}...")  # Print the text for context
                            parsed_results.append((None, None))  # Add a failure marker

                    print("--- Single-Prompt Batch Response Received ---")
                    return parsed_results

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
                                prompt, temperature, top_p, max_tokens
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

    async def generate_feedback(
        self,
        problem_def,
        verilog_code,
        simulation_log,
        temperature=1.0,
        top_p=1.0,
        max_tokens=2048,
    ):
        """
        Verilog 코드, 시뮬레이션 로그, 문제 정의를 LLM에 보내 코드의 오류를 분석하고 점수를 매기게 합니다.
        점수, 채점 이유, 분석 내용이 포함된 딕셔너리를 반환합니다.
        """
        # print(f"\n--- LLM Feedback Generation Request ---")
        # print(f"Verilog Code (first 200 chars):\n{verilog_code[:200]}...")
        # print(f"Simulation Log (first 500 chars):\n{simulation_log[:500]}...")
        # print(f"Model: {self.model_name}, Temperature: {temperature}, Max Tokens: {max_tokens}, Top P: {top_p}")

        # --- 시스템 프롬프트 수정 ---
        # 점수 채점 및 포맷팅 지침이 추가되었습니다.
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
                    # Increment the API call count
                    await self._increment_call_count()
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
                    feedback_text = chat_completion.choices[0].message.content.strip()
                    # print("LLM Response Received. Parsing feedback...")
                    return self._parse_feedback_response(feedback_text)
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
            "analysis": f"Could not generate feedback due to an API error: {e}",
        }

    def _parse_feedback_response(self, feedback_text):
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
    async def generate_batch_responses(self, prompts, temperature, top_p, max_tokens):
        """
        Generates responses for a batch of prompts concurrently.
        """
        print(f"\n--- Sending Batch LLM Request for {len(prompts)} prompts ---")
        tasks = [
            self.generate_response(prompt, temperature, top_p, max_tokens)
            for prompt in prompts
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
        Each request is a dictionary with problem_def, verilog_code, and simulation_log.
        """
        print(
            f"\n--- Sending Batch LLM Feedback Request for {len(feedback_requests)} candidates ---"
        )
        tasks = [
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
