import asyncio
import random
import re
from collections.abc import Coroutine
from typing import Any, Literal, NotRequired, TypedDict
import json

from openai import (
    APIConnectionError,
    APITimeoutError,
    AsyncOpenAI,
    BadRequestError,
    InternalServerError,
    RateLimitError,
)
from openai.types.chat import ChatCompletion

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline


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
        system_prompt (str, optional): An optional system prompt to override
            the default.
    """

    prompt: str
    generation_mode: NotRequired[Literal["whole", "diff"]]
    system_prompt: NotRequired[str]


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
        max_retries: int = 15,
        base_delay: float = 2.0,
        port: int = 8000,
        vllm_host: str = "localhost",
        debug: bool = False,
    ) -> None:
        """
        :param api_key:      Your LLM API key (not required for 'vllm' backend).
        :param model_name:   Model identifier to send in the request.
        :param api_backend:  One of "openai", "openrouter", "deepseek", or "vllm".
        :param max_retries:  Maximum number of retry attempts for transient errors.
        :param base_delay:   Initial backoff delay in seconds (doubles each retry).
        :param port:         Port for the vLLM server (default: 8000).
        :param vllm_host:    Hostname or IP address for the vLLM server (default: "localhost").
        :param debug:       Enable debug mode for verbose logging. (Prints prompt+response)
        :raises ValueError:  If api_key is missing for non-vllm backends, or
                             api_backend is unsupported.
        """
        if not api_key and api_backend != "vllm":
            if api_backend != "local":
                raise ValueError("API key is required for LLMInterface initialization.")

        self.debug: bool = debug  # Store debug state

        self.api_backend: str = api_backend  # Backend API to use, e.g., "openai", "openrouter", "deepseek", etc.
        self.model_name: str = model_name
        self.max_retries: int = max_retries  # Maximum number of retries
        self.base_delay: float = base_delay  # Base delay in seconds for backoff

        # --- 로컬 모델 로딩 로직 (추가) ---
        self.local_pipeline = None
        if api_backend == "local":
            print(f"--- [LOCAL] Loading Model: {model_name} ---")
            # 연우님이 생성하신 Python 3.11 환경에서 실행됩니다
            self.tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
            self.model = AutoModelForCausalLM.from_pretrained(
                model_name,
                device_map="auto", # csdlab 서버의 GPU를 자동으로 할당합니다
                dtype=torch.float16,
                trust_remote_code=True
            )
            self.local_pipeline = pipeline(
                "text-generation",
                model=self.model,
                tokenizer=self.tokenizer
            )
            print("--- [LOCAL] Model Loaded Successfully ---")
        # --------------------------------

        self.client_args: dict[str, Any] = {
            "api_key": api_key,
            "timeout": 120.0 * 1000,
        }



        # Configure arguments for the AsyncOpenAI client based on the backend
        self.client_args: dict[str, Any] = {
            "api_key": api_key,
            "timeout": 120.0 * 1000,  # Set a reasonable timeout for API calls
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
            host = (vllm_host or "localhost").strip()
            if host.startswith(("http://", "https://")):
                base = host.rstrip("/")
                if not base.endswith("/v1"):
                    base = f"{base}/v1"
                self.client_args["base_url"] = base
            else:
                self.client_args["base_url"] = f"http://{host}:{port}/v1"
        elif api_backend == "local":
            pass
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

    def set_debug(self, enabled: bool) -> None:
        """
        Enable or disable debug logging at runtime.

        :param enabled: Set to True to turn on debug prints, False to turn them off.
        """
        self.debug = enabled
        if self.debug:
            print("--- Debug logging has been enabled. ---")
        else:
            print("--- Debug logging has been disabled. ---")

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
            self.code_prompt_tokens_count = 0
            self.code_completion_tokens_count = 0
            self.feedback_prompt_tokens_count = 0
            self.feedback_completion_tokens_count = 0
            return stats

    # A small helper to repair common LLM JSON mistakes (unescaped newlines/quotes, trailing commas)
    def _repair_json_like(self, s: str) -> dict[str, Any] | None:
        txt = s.strip()

        # strip common code fences
        if txt.startswith("```"):
            txt = re.sub(r"^```[a-zA-Z0-9]*\s*", "", txt)
            txt = re.sub(r"\s*```$", "", txt)

        # replace curly quotes with regular quotes
        txt = txt.replace("“", '"').replace("”", '"').replace("’", "'")

        # remove trailing commas before } or ]
        txt = re.sub(r",(\s*[}\]])", r"\1", txt)

        # escape raw newlines that occur inside quoted strings
        out = []
        in_str = False
        escaped = False
        for ch in txt:
            if in_str:
                if escaped:
                    out.append(ch)
                    escaped = False
                else:
                    if ch == '\\':
                        out.append(ch); escaped = True
                    elif ch == '"':
                        out.append(ch); in_str = False
                    elif ch == '\n':
                        out.append('\\n')
                    elif ch == '\r':
                        out.append('\\r')
                    else:
                        out.append(ch)
            else:
                out.append(ch)
                if ch == '"':
                    # begin string (if not escaped — but outside string, slash cannot escape)
                    in_str = True
        txt2 = "".join(out)

        try:
            return json.loads(txt2)
        except Exception:
            return None

    def _extract_json_obj(self, text: str) -> dict[str, Any] | None:
        """
        Try very hard to find a JSON object in `text`. Supports:
        - Raw JSON
        - Fenced ```json ... ``` blocks
        - 'first { ... last }' heuristic
        Returns dict or None.
        """
        # Try fenced JSON first
        m = re.search(r"```json\s*(\{[\s\S]*?\})\s*```", text, re.IGNORECASE)
        if m:
            blob = m.group(1)
            try:
                return json.loads(blob)
            except Exception:
                repaired = self._repair_json_like(blob)
                if repaired is not None:
                    return repaired

        # Try any fenced block that looks like JSON
        m2 = re.search(r"```[\w]*\s*(\{[\s\S]*?\})\s*```", text, re.IGNORECASE)
        if m2:
            blob = m2.group(1)
            try:
                return json.loads(blob)
            except Exception:
                repaired = self._repair_json_like(blob)
                if repaired is not None:
                    return repaired

        # Fallback: first '{' to last '}' slice
        start = text.find("{")
        end = text.rfind("}")
        if start != -1 and end != -1 and end > start:
            candidate = text[start : end + 1]
            try:
                return json.loads(candidate)
            except Exception:
                repaired = self._repair_json_like(candidate)
                if repaired is not None:
                    return repaired
        return None

    def _json_to_thought_code(self, obj: dict[str, Any]) -> tuple[str, str] | None:
        """
        Validate minimal schema and extract (thought, code).
        Accepts:
        - {"format":"eoh_v1", "mode":"whole|diff", "thought":str, "code":str|dict}
        - {"format":"eoh_v1", "mode":"diff", "thought":str, "edits":[...]}  # lenient
        Returns (thought, code_json_string) for diff, or (thought, code_str) for whole.
        """
        if not isinstance(obj, dict):
            return None

        thought = obj.get("thought")
        mode = obj.get("mode")
        code = obj.get("code")

        # lenient top-level edits for diff outputs that omit "code": { "edits": [...] }
        if code is None and obj.get("edits") and isinstance(obj["edits"], list):
            code = {"edits": obj["edits"]}

        if not isinstance(thought, str):
            return None

        # whole: must be a string
        if mode == "whole" and isinstance(code, str):
            return thought.strip(), code.strip()

        # diff: allow dict (we will re-serialize to JSON)
        if mode == "diff" and isinstance(code, dict):
            try:
                return thought.strip(), json.dumps(code, separators=(",", ":"))
            except Exception:
                return None

        # be permissive: if code is a string in diff (rare), still return
        if mode == "diff" and isinstance(code, str):
            return thought.strip(), code.strip()

        return None
    
    def _maybe_unescape_code(self, s: str) -> str:
        """
        If the model double-escapes or you occasionally skip the strict JSON path, 
        unescape once in the parser so everything downstream is already clean.
        """
        # If it already has plenty of real newlines, leave it alone
        if s.count("\\n") >= 2 and s.count("\n") <= max(1, s.count("\\n") // 4):
            try:
                return s.encode("utf-8").decode("unicode_escape")
            except Exception:
                return (s.replace("\\r\\n", "\n")
                        .replace("\\n", "\n")
                        .replace("\\t", "\t")
                        .replace('\\"', '"'))
        return s.replace("\r\n", "\n")


    def parse_thought_and_code(self, response_text: str) -> tuple[str, str]:
        """
        Flexibly extracts the "thought" and "code" blocks from a raw LLM completion.
        Format: {"format":"eoh_v1", "mode":"whole|diff", "thought":str, "code":str, ...}
        First try strict JSON; 
        - Raw JSON
        - Fenced ```json ... ``` blocks
        - 'first { ... last }' heuristic
        
        If not found, gracefully fall back to legacy
        ```thought``` / ```code``` parsing.

        This parser is designed to handle several common formats, including:
        1.  Standard ```thought ... ``` and ```code ... ``` blocks.
        2.  Markdown-style headers like **thought** or **Algorithm plan**.
        3.  Plain thought text that directly precedes a code block.

        It works by identifying the last python/code block and treating all
        preceding text as the thought process.

        :param response_text: Full text from the LLM.
        :return: A (thought, code) tuple. If parsing fails or a block is
                 missing, returns (full_text_with_warnings, full_text_with_warnings).
        """

        # JSON-first
        obj = self._extract_json_obj(response_text)
        if obj is not None:
            pair = self._json_to_thought_code(obj)
            if pair is not None:
                thought, code = pair
                # Normalize code once here to avoid escaped literals downstream
                code = self._maybe_unescape_code(code)
                return thought, code


        # Legacy fallback
        # Debug print to show the response text
        # print(f"Response text:\n{response_text}\n{'-' * 40}")

        # Regex to find the last code block, which can be marked as 'python' or 'code'
        code_block_pattern = re.compile(
            r"```(python|code)\s*\n(.*?)\n```", re.DOTALL | re.IGNORECASE
        )

        # Find all code blocks and use the last one as the definitive code
        code_matches = list(code_block_pattern.finditer(response_text))

        if not code_matches:
            # If no code block is found, we cannot parse.
            return self._handle_parse_failure(response_text, code_missing=True)

        # The definitive code is the content of the last matched code block
        last_match = code_matches[-1]
        code = last_match.group(2).strip()

        # The text before the last code block is considered the thought process
        potential_thought = response_text[: last_match.start()].strip()

        # Clean up the thought text by removing common headers and trailers
        # Remove headers like 'thought', '**thought**', 'Algorithm plan', etc.
        thought = re.sub(
            r"^(?:```thought|\*\*thought\*\*|thought|algorithm plan)\s*",
            "",
            potential_thought,
            flags=re.IGNORECASE,
        )

        thought = re.sub(
            r"(?:```code|\*\*code\*\*|code)\s*$",
            "",
            thought,
            flags=re.IGNORECASE,
        ).strip()

        # If after cleaning, thought is empty, it's a parsing issue.
        if not thought or not code:
            return self._handle_parse_failure(
                response_text, thought_missing=not thought, code_missing=not code
            )

        return thought, code

    def _handle_parse_failure(
        self,
        response_text: str,
        thought_missing: bool = False,
        code_missing: bool = False,
    ) -> tuple[str, str]:
        """
        Helper function to format a standardized failure response.
        """
        append_text = "\n\n--- WARNING: Parsing Issues ---\n"
        if thought_missing:
            print(
                f"Warning: Could not parse 'thought' from LLM response. Expected text before code block. Response:\n{response_text[:500]}..."
            )
            append_text += "Could not parse 'thought' from LLM response.(PARSE_ERROR)\n"
        if code_missing:
            print(
                f"Warning: Could not parse 'code' from LLM response. Expected ```code ... ``` or ```python ... ``` block. Response:\n{response_text[:500]}..."
            )
            append_text += "Could not parse 'code' from LLM response.(PARSE_ERROR)\n"

        response_text_with_issues = response_text + append_text
        return response_text_with_issues, response_text_with_issues


    def _strict_validate_eoh(self, text: str) -> tuple[bool, dict[str, Any], str | None]:
        """
        [FORMAT-ERROR] Strictly require a single JSON object with:
          - format == "eoh_v1"
          - mode in {"whole","diff"}
          - thought: str (non-empty)
          - code: str (non-empty, for whole) OR dict with 'edits': list[...] (for diff)

        Returns (ok, payload, error_message_or_None).
        On ok=True, payload = {"mode": "...", "thought": str, "code": str|dict}.
        """
        obj = self._extract_json_obj(text)
        if obj is None:
            return False, {}, "no JSON object found"

        if not isinstance(obj, dict):
            return False, {}, "top-level is not an object"

        if obj.get("format") != "eoh_v1":
            return False, {}, 'missing/invalid "format":"eoh_v1"'

        mode = obj.get("mode")
        if mode not in ("whole", "diff"):
            return False, {}, 'missing/invalid "mode" ("whole"|"diff")'

        thought = obj.get("thought")
        if not isinstance(thought, str) or not thought:
            return False, {}, 'missing/invalid "thought" (non-empty string required)'

        code = obj.get("code")
        if mode == "whole":
            if not isinstance(code, str) or not code:
                return False, {}, 'missing/invalid "code" (non-empty string required for whole)'
        else:  # diff
            if not isinstance(code, dict) or "edits" not in code or not isinstance(code["edits"], list):
                return False, {}, 'missing/invalid "code.edits" (list required for diff)'

        return True, {"mode": mode, "thought": thought, "code": code}, None

    async def generate_response(
        self,
        prompt: str,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        generation_mode: Literal["whole", "diff"] = "whole",
        system_prompt_override: str | None = None,
    ) -> tuple[str | None, str | None, dict[str, Any]]:
        """
        Generate a single (thought, code, meta) reply for a user prompt.

        thought: High-level design idea or conceptual plan.
        code: Complete, runnable Verilog/design implementation of the thought.
        meta: Handles API response metadata, checks for formatting issues.
            meta = {"format_ok": bool, "error": str|None, "raw": str, "parsed_mode": str|None}

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
        :param system_prompt_override: Optional custom system prompt to override the default.
        :type system_prompt_override: str | None
        :return: A (thought, code, meta) tuple, or (None, None, None) on failure.
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
                "You MUST provide your response as a single JSON object for each problem.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.\n'
                "The JSON object must have four keys:\n"
                '1. "format": "eoh_v1"\n'  # The format version of the response (The format version of the response currently eoh_v1)
                '2. "mode": "whole"\n'  # The mode of generation (The mode of generation either whole or diff, currently whole)
                '3. "thought": A string containing your concise design idea or conceptual plan.\n'
                '4. "code": A string containing the complete, runnable Verilog implementation of your thought.\n'
                "Rules:\n"
                "- The response must be valid JSON."
                "- Escape newlines in strings as \n and double quotes as \" as required by JSON."
                "- Do not include commentary outside the JSON.\n"
                "Example format:\n"
                '{\n'
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "My design plan is to use a finite state machine to control the traffic light sequence.",\n'
                '  "code": "module traffic_light(...);\\n  // ... verilog code ...\\nendmodule"\n'
                '}\n'
            )
        else:  # diff mode
            system_prompt_content = (
                "You are an expert Verilog design assistant that modifies code based on user requests.\n"
                "You will be given the file path, the file content, and instructions for what to change.\n"
                "Return exactly ONE JSON object and nothing else. Do not include Markdown code fences, backticks, or extra text.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.\n'
                "The JSON object must have four keys:\n"
                '1. "format": "eoh_v1"\n'  # The format version of the response (The format version of the response currently eoh_v1)
                '2. "mode": "diff"\n'  # The mode of generation (The mode of generation either whole or diff, currently diff)
                '3. "thought": A string containing your conceptual idea for the changes.\n'
                "4) \"code\": An object describing edits with this schema:\n\n"
                "\"code\": {\n"
                "  \"edits\": [\n"
                "    {\n"
                "      \"file\": \"<path/to/file.sv>\",\n"
                "      \"hunks\": [\n"
                "        { \"search\": \"<exact text to match>\\n\", \"replace\": \"<replacement text>\\n\" }\n"
                "      ]\n"
                "    }\n"
                "  ]\n"
                "}\n\n"
                "Rules:\n"
                "- The search text must match the existing file content exactly (including whitespace and comments).\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                "- To create a new file (e.g., from a Crossover strategy or initial generation), include an edit with an empty search: "
                "{ \"file\": \"new_file.sv\", \"hunks\": [ { \"search\": \"\", \"replace\": \"<full file contents>\\n\" } ] }.\n"
                "- Sometimes the file path may not be known, in which case you can use a placeholder like `new_file.sv`.\n"
                "- The response must be valid JSON (no Markdown, no backticks).\n"
                "- Escape newlines as \\n and quotes as needed.\n\n"
                "Example:\n"
                "{\n"
                "  \"format\": \"eoh_v1\",\n"
                "  \"mode\": \"diff\",\n"
                "  \"thought\": \"Import math to support new calculations.\",\n"
                "  \"code\": {\n"
                "    \"edits\": [\n"
                "      {\n"
                "        \"file\": \"mathweb/flask/app.py\",\n"
                "        \"hunks\": [\n"
                "          {\n"
                "            \"search\": \"from flask import Flask\\n\",\n"
                "            \"replace\": \"import math\\nfrom flask import Flask\\n\"\n"
                "          }\n"
                "        ]\n"
                "      }\n"
                "    ]\n"
                "  }\n"
                "}\n"
            )

        # If system_prompt_override is provided, use it instead of the default
        if system_prompt_override:
            system_prompt_content = system_prompt_override

        if self.api_backend == "local":
            try:
                # Transformers 파이프라인 형식에 맞게 메시지 구성
                messages = [
                    {"role": "system", "content": system_prompt_content},
                    {"role": "user", "content": prompt},
                ]
                
                # GPU 연산을 비동기 스레드에서 실행 (이벤트 루프 차단 방지)
                outputs = await asyncio.to_thread(
                    self.local_pipeline,
                    messages,
                    max_new_tokens=max_tokens,
                    do_sample=True,
                    temperature=temperature,
                    top_p=top_p,
                )
                
                # 모델 출력 텍스트 추출
                raw = outputs[0]["generated_text"][-1]["content"].strip()

                if self.debug:
                    print(f"\n--- DEBUG: RAW LOCAL OUTPUT ---\n{raw}\n")

                # 기존 검증 로직 활용
                format_ok, payload, err = self._strict_validate_eoh(raw)
                if format_ok:
                    mode = payload["mode"]
                    thought = (payload["thought"] or "").strip()
                    code = payload["code"]
                    code_str = self._maybe_unescape_code(code) if isinstance(code, str) else json.dumps(code, separators=(",", ":"))
                    return thought, code_str, {"format_ok": True, "error": None, "raw": raw, "parsed_mode": mode}

                # 실패 시 유연한 파싱 시도
                thought_loose, code_loose = self.parse_thought_and_code(raw)
                return thought_loose, code_loose, {"format_ok": False, "error": f"strict-parse failed: {err}", "raw": raw, "parsed_mode": None}

            except Exception as e:
                print(f"Local inference failed: {e}")
                return None, None, {"format_ok": False, "error": f"local-error: {e}", "raw": "", "parsed_mode": None}


        # --- DEBUG: Print the final input prompts ---
        if self.debug:
            print("\n" + "=" * 80)
            print("--- DEBUG: LLM INPUT (generate_response) ---")
            print(f"--- SYSTEM PROMPT ---\n{system_prompt_content}")
            print(f"\n--- USER PROMPT ---\n{prompt}")
            print("=" * 80 + "\n")

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

                    raw = (chat_completion.choices[0].message.content or "").strip()

                    # --- DEBUG: Print the raw model output ---
                    if self.debug:
                        print("\n" + "=" * 80)
                        print("--- DEBUG: RAW LLM OUTPUT (generate_response) ---")
                        print(raw)
                        print("=" * 80 + "\n")
                    
                    format_ok, payload, err = self._strict_validate_eoh(raw)
                    if format_ok:
                        mode = payload["mode"]
                        thought = (payload["thought"] or "").strip()
                        code = payload["code"]
                        # normalize code to string for downstream
                        code_str = self._maybe_unescape_code(code) if isinstance(code, str) else json.dumps(code, separators=(",", ":"))
                        return thought, code_str, {"format_ok": True, "error": None, "raw": raw, "parsed_mode": mode}

                    # fallback: lenient parse for convenience, but mark as error
                    thought_loose, code_loose = self.parse_thought_and_code(raw)

                    # If the response content is non-empty, return the leniently parsed values.
                    if raw:
                        return thought_loose, code_loose, {"format_ok": False, "error": f"strict-parse failed: {err}", "raw": raw, "parsed_mode": None}

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
                        return None, None, {"format_ok": False, "error": f"api-error: {e}", "raw": "", "parsed_mode": None}

                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(
                        f"An unexpected, error occurred in generate_response: {e}"
                    )
                    print(
                        f"OpenAI API call failed on attempt {attempt + 1}/{self.max_retries}: {e}"
                    )
                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        return None, None, {"format_ok": False, "error": f"api-error: {e}", "raw": "", "parsed_mode": None}

                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)
        print("Failed to generate a response after multiple retries.")
        return None, None, {"format_ok": False, "error": "exhausted-retries", "raw": "", "parsed_mode": None}

    # This new method uses the 'n' parameter for more efficient batching of identical prompts.
    async def generate_n_responses(
        self,
        prompt: str,
        n: int,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        generation_mode: Literal["whole", "diff"] = "whole",
        system_prompt_override: str | None = None,
    ) -> list[tuple[str | None, str | None, dict[str, Any]]]:
        """
        Generates 'n' different responses for a single prompt.

        With each response consisting of list of tuple (thought, code, meta) for a user prompt.

        thought: High-level design idea or conceptual plan.
        code: Complete, runnable Verilog/design implementation of the thought.
        meta: Handles API response metadata, checks for formatting issues.
            meta = {"format_ok": bool, "error": str|None, "raw": str, "parsed_mode": str|None}

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
        :param system_prompt_override: Optional custom system prompt to override the default.
        :type system_prompt_override: str | None
        :return: A list of (thought, code) tuples.
        """
        print(f"\n--- Sending Single-Prompt Batch Request for {n} responses ---")

        system_prompt_content = ""
        if generation_mode == "whole":
            system_prompt_content = (
                "You are an expert Verilog design assistant. "
                "Your role is to address Verilog-related problems posed by the user. "
                "You MUST provide your response as a single JSON object for each problem.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.\n'
                "The JSON object must have four keys:\n"
                '1. "format": "eoh_v1"\n'  # The format version of the response (The format version of the response currently eoh_v1)
                '2. "mode": "whole"\n'  # The mode of generation (The mode of generation either whole or diff, currently whole)
                '3. "thought": A string containing your concise design idea or conceptual plan.\n'
                '4. "code": A string containing the complete, runnable Verilog implementation of your thought.\n'
                "Rules:\n"
                "- The response must be valid JSON."
                "- Escape newlines in strings as \n and double quotes as \" as required by JSON."
                "- Do not include commentary outside the JSON.\n"
                "Example format:\n"
                '{\n'
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "My design plan is to use a finite state machine to control the traffic light sequence.",\n'
                '  "code": "module traffic_light(...);\\n  // ... verilog code ...\\nendmodule"\n'
                '}\n'
            )
        else:  # diff mode
            system_prompt_content = (
                "You are an expert Verilog design assistant that modifies code based on user requests.\n"
                "You will be given the file path, the file content, and instructions for what to change.\n"
                "Return exactly ONE JSON object and nothing else. Do not include Markdown code fences, backticks, or extra text.\n"
                r'All content inside JSON strings, must be properly escaped. This means every literal double quote `"` must become `\\"` and every literal newline must become `\\n`.\n'
                "The JSON object must have four keys:\n"
                '1. "format": "eoh_v1"\n'  # The format version of the response (The format version of the response currently eoh_v1)
                '2. "mode": "diff"\n'  # The mode of generation (The mode of generation either whole or diff, currently diff)
                '3. "thought": A string containing your conceptual idea for the changes.\n'
                "4) \"code\": An object describing edits with this schema:\n\n"
                "\"code\": {\n"
                "  \"edits\": [\n"
                "    {\n"
                "      \"file\": \"<path/to/file.sv>\",\n"
                "      \"hunks\": [\n"
                "        { \"search\": \"<exact text to match>\\n\", \"replace\": \"<replacement text>\\n\" }\n"
                "      ]\n"
                "    }\n"
                "  ]\n"
                "}\n\n"
                "Rules:\n"
                "- The search text must match the existing file content exactly (including whitespace and comments).\n"
                "- Use multiple hunks per file if needed.\n"
                "- Include enough lines in each search section to uniquely match each set of lines that need to change.\n"
                "- Keep search/replace hunks concise.\n"
                "- Break large search/replace hunks into a series of smaller hunks that each change a small portion of the file.\n"
                "- Include just the changing lines, and a few surrounding lines if needed for uniqueness.\n"
                "- Do not include long runs of unchanging lines in search/replace hunks.\n"
                "- To create a new file (e.g., from a Crossover strategy or initial generation), include an edit with an empty search: "
                "{ \"file\": \"new_file.sv\", \"hunks\": [ { \"search\": \"\", \"replace\": \"<full file contents>\\n\" } ] }.\n"
                "- Sometimes the file path may not be known, in which case you can use a placeholder like `new_file.sv`.\n"
                "- The response must be valid JSON (no Markdown, no backticks).\n"
                "- Escape newlines as \\n and quotes as needed.\n\n"
                "Example:\n"
                "{\n"
                "  \"format\": \"eoh_v1\",\n"
                "  \"mode\": \"diff\",\n"
                "  \"thought\": \"Import math to support new calculations.\",\n"
                "  \"code\": {\n"
                "    \"edits\": [\n"
                "      {\n"
                "        \"file\": \"mathweb/flask/app.py\",\n"
                "        \"hunks\": [\n"
                "          {\n"
                "            \"search\": \"from flask import Flask\\n\",\n"
                "            \"replace\": \"import math\\nfrom flask import Flask\\n\"\n"
                "          }\n"
                "        ]\n"
                "      }\n"
                "    ]\n"
                "  }\n"
                "}\n"
            )

        # If system_prompt_override is provided, use it instead of the default
        if system_prompt_override:
            system_prompt_content = system_prompt_override

        if self.api_backend == "local":
            results = []
            print(f"--- [LOCAL] Generating {n} responses concurrently ---")
            
            # n개의 응답을 개별적으로 생성하도록 태스크 생성
            tasks = [
                self.generate_response(
                    prompt, temperature, top_p, max_tokens, 
                    generation_mode, system_prompt_override
                ) for _ in range(n)
            ]
            
            # 모든 태스크를 동시에 실행
            results = await asyncio.gather(*tasks)
            return results
        
        # --- DEBUG: Print the final input prompts ---
        if self.debug:
            print("\n" + "=" * 80)
            print(f"--- DEBUG: LLM INPUT (generate_n_responses, n={n}) ---")
            print(f"--- SYSTEM PROMPT ---\n{system_prompt_content}")
            print(f"\n--- USER PROMPT ---\n{prompt}")
            print("=" * 80 + "\n")

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

                    # --- DEBUG: Print the raw model outputs ---
                    if self.debug:
                        print("\n" + "=" * 80)
                        print("--- DEBUG: RAW LLM OUTPUT (generate_n_responses) ---")
                        for i, choice in enumerate(chat_completion.choices):
                            print(
                                f"\n--- Response {i + 1}/{len(chat_completion.choices)} ---"
                            )
                            print(choice.message.content)
                        print("=" * 80 + "\n")

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
                        out = []
                        for ch in chat_completion.choices:
                            raw = (ch.message.content or "").strip()
                            ok_format, payload, err = self._strict_validate_eoh(raw)
                            if ok_format:
                                mode = payload["mode"]
                                thought = (payload["thought"] or "").strip()
                                code = payload["code"]
                                code_str = self._maybe_unescape_code(code) if isinstance(code, str) else json.dumps(code, separators=(",", ":"))
                                out.append((thought, code_str, {"format_ok": True, "error": None, "raw": raw, "parsed_mode": mode}))
                            else:
                                # If content is not empty, add a failed response
                                if raw:
                                    thought_loose, code_loose = self.parse_thought_and_code(raw)
                                    out.append((thought_loose, code_loose, {"format_ok": False, "error": f"strict-parse failed: {err}", "raw": raw, "parsed_mode": None}))

                        # Concurrently request the remaining responses.
                        num_remaining = n - len(out)
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
                                system_prompt_override=system_prompt_override,
                            )
                            for _ in range(num_remaining)
                        ]
                        remaining_results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {num_remaining} individual requests completed ---"
                        )
                        return out + remaining_results
                    # *** END: WORKAROUND ***

                    # Parse each of the 'n' choices in the response
                    # Parse the responses.
                    out = []
                    for ch in chat_completion.choices:
                        raw = (ch.message.content or "").strip()
                        ok_format, payload, err = self._strict_validate_eoh(raw)
                        if ok_format:
                            mode = payload["mode"]
                            thought = (payload["thought"] or "").strip()
                            code = payload["code"]
                            code_str = self._maybe_unescape_code(code) if isinstance(code, str) else json.dumps(code, separators=(",", ":"))
                            out.append((thought, code_str, {"format_ok": True, "error": None, "raw": raw, "parsed_mode": mode}))
                        else:
                            # If content is not empty, add a failed response
                            if raw:
                                thought_loose, code_loose = self.parse_thought_and_code(raw)
                                out.append((thought_loose, code_loose, {"format_ok": False, "error": f"strict-parse failed: {err}", "raw": raw, "parsed_mode": None}))
                    return out

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
                                system_prompt_override=system_prompt_override,
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
                                system_prompt_override=system_prompt_override,
                            )
                            for _ in range(n)
                        ]
                        results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {n} individual requests completed ---"
                        )
                        return results
                    else:
                        # Try again with just self.generate_response just in case of other issues.
                        print(
                            f"BadRequestError occurred: {e}. Retrying with individual requests."
                        )
                        # The individual 'generate_response' calls will handle their own retries and counting.
                        tasks = [
                            self.generate_response(
                                prompt,
                                temperature,
                                top_p,
                                max_tokens,
                                generation_mode=generation_mode,
                                system_prompt_override=system_prompt_override,
                            )
                            for _ in range(n)
                        ]
                        results = await asyncio.gather(*tasks)
                        print(
                            f"--- Fallback with {n} individual requests completed ---"
                        )
                        return results

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
                        fail_dict = {"format_ok": False, "error": str(e) + " Maximum retries reached", "raw": "", "parsed_mode": None}
                        return [(None, None, fail_dict)] * n  # Return failures

                    # Exponential backoff with jitter
                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

                except Exception as e:
                    print(
                        f"An unexpected, error occurred in generate_n_responses: {e}"
                    )

                    if attempt + 1 == self.max_retries:
                        print("Max retries reached. Failing the request.")
                        fail_dict = {"format_ok": False, "error": str(e) + " Maximum retries reached", "raw": "", "parsed_mode": None}
                        return [(None, None, fail_dict)] * n  # Return failures

                    # Exponential backoff with jitter
                    delay = (self.base_delay * 2**attempt) + random.uniform(0, 1)
                    print(f"Waiting for {delay:.2f} seconds before retrying...")
                    await asyncio.sleep(delay)

        print("Failed to generate responses after multiple retries.")
        fail_dict = {"format_ok": False, "error": "Max retries reached", "raw": "", "parsed_mode": None}
        return [(None, None, fail_dict)] * n  # Return failures if all retries fail

    async def generate_feedback(
        self,
        problem_def: str,
        verilog_code: str,
        simulation_log: str,
        temperature: float = 1.0,
        top_p: float = 0.95,
        max_tokens: int = 2048,
        system_prompt_override: str | None = None,
        user_prompt_override: str | None = None,
    ) -> dict[str, int | str | None]:
        """
        Analyzes Verilog code against a problem and simulation log to provide feedback.

        :param problem_def: The high-level problem description.
        :type problem_def: str
        :param verilog_code: The user's Verilog code submission.
        :type verilog_code: str
        :param simulation_log: The log output from simulating the code.
        :type simulation_log: str
        :param temperature: Sampling temperature for the feedback model.
        :type temperature: float
        :param top_p: Nucleus sampling threshold.
        :type top_p: float
        :param max_tokens: Maximum tokens for the feedback response.
        :type max_tokens: int
        :param system_prompt_override: Optional custom system prompt to override the default.
        :type system_prompt_override: str | None
        :param user_prompt_override: Optional custom user prompt to override the default.
        :type user_prompt_override: str | None
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
            "Your task is to analyze the submission and provide feedback as a single JSON object. First, determine if the simulation log indicates a success or a failure.\n\n"
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
            "The JSON object must have three keys:\n"
            '1. "score": An integer from 0 to 10 based on the scoring criteria.\n'
            '2. "justification": A brief, one or two-sentence justification for your score.\n'
            '3. "analysis": Your detailed analysis. For failures, explain the bugs. For successes (score 10), provide PPA optimization feedback. **Remember: Do NOT suggest any fixes or write corrected code in this section.**\n\n'
            "Example format:\n"
            '{\n'
            '  "score": 7,\n'
            '  "justification": "The code is syntactically correct but fails one of the corner case tests related to reset logic.",\n'
            '  "analysis": "The main functional error is in the always_ff block for the state register. The reset condition does not correctly initialize the `count` variable to zero, leading to functional mismatches when reset is asserted mid-operation. Additionally, for PPA, consider using a one-hot encoding for the state machine which might improve timing performance."\n'
            '}\n'
        )

        # If a custom system prompt is provided, use it instead of the default
        if system_prompt_override:
            system_prompt_content = system_prompt_override

        user_prompt = (
            "I wrote some Verilog code to solve a given problem. "
            "Please analyze the code and provide your feedback in the requested JSON format.\n\n"
            "Problem Description:\n"
            '{\n'
            f'  "problem": {problem_def},\n'
            f'  "code": {verilog_code},\n'
            f'  "simulation_log": {simulation_log}\n'
            '}\n\n'
        )

        # If a custom user prompt is provided, use it instead of the default
        if user_prompt_override:
            user_prompt = user_prompt_override

        # --- DEBUG: Print the final input prompts ---
        if self.debug:
            print("\n" + "=" * 80)
            print("--- DEBUG: LLM INPUT (generate_feedback) ---")
            print(f"--- SYSTEM PROMPT ---\n{system_prompt_content}")
            print(f"\n--- USER PROMPT ---\n{user_prompt}")
            print("=" * 80 + "\n")

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

                    raw_content = chat_completion.choices[0].message.content

                    # --- DEBUG: Print the raw model output ---
                    if self.debug:
                        print("\n" + "=" * 80)
                        print("--- DEBUG: RAW LLM OUTPUT (generate_feedback) ---")
                        print(raw_content)
                        print("=" * 80 + "\n")

                    if raw_content:
                        return self._parse_json_feedback_response(raw_content.strip())
                        # return self._parse_feedback_response(raw_content.strip())

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

    def _parse_json_feedback_response(self, response_text: str) -> dict[str, int | str | None]:
        """
        Robustly parses a JSON feedback response from the LLM.
        Uses _extract_json_obj to attempt to identify json and extract keys from it.
        """

        obj = self._extract_json_obj(response_text)
        if obj is not None:
            score = obj.get("score")
            # Ensure score is an integer if it exists
            if score is not None:
                score = int(score)
            else:
                score = 0 # Set 0 minimum score if score is None

            return {
                "score": score,
                "justification": obj.get("justification", "Parsing failed: 'justification' key missing."),
                "analysis": obj.get("analysis", "Parsing failed: 'analysis' key missing."),
            }

        else: # Could not parse json from response_text error
            print(f"No JSON block found in the feedback response.")
            return {
                "score": 0,
                "justification": "Failed to parse the LLM's JSON response.",
                "analysis": f"PARSE_ERROR\nRAW_RESPONSE:\n{response_text}",
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
    ) -> list[tuple[str | None, str | None, dict[str, Any]]]:
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
        :rtype: list[tuple[str | None, str | None, dict[str, Any]]]
        """
        print(f"\n--- Sending Batch LLM Request for {len(prompts)} prompts ---")
        tasks: list[Coroutine[Any, Any, tuple[str | None, str | None, dict[str, Any]]]] = [
            self.generate_response(
                p["prompt"],
                temperature,
                top_p,
                max_tokens,
                generation_mode=p.get("generation_mode", "whole"),
                system_prompt_override=p.get(
                    "system_prompt"
                ),  # Allows override of system prompt if LLMRequest is constructed with a custom prompt
            )
            for p in prompts
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Response Received ---")
        return results

    # Method for batching feedback generation requests
    async def generate_batch_feedback(
        self,
        feedback_requests,
        temperature,
        top_p,
        max_tokens,
        system_prompt_override: list[str] | None = None,
        user_prompt_override: list[str] | None = None,
    ):
        """
        Generates feedback for a batch of candidates concurrently.

        :param feedback_requests: A list of dictionaries, each with 'problem_def',
                                  'code', and 'simulation_log'.
        :param temperature: Sampling temperature.
        :param top_p: Nucleus sampling threshold.
        :param max_tokens: Maximum tokens to generate.
        :param system_prompt_override: Optional custom system prompt to override the default.
        :param user_prompt_override: Optional custom user prompt to override the default.
        :return: A list of feedback dictionaries.
        """
        print(
            f"\n--- Sending Batch LLM Feedback Request for {len(feedback_requests)} candidates ---"
        )

        # If the overrides are provided check that they are lists of the same length as feedback_requests
        if system_prompt_override and len(system_prompt_override) != len(
            feedback_requests
        ):
            raise ValueError(
                "system_prompt_override must be a list of the same length as feedback_requests"
            )
        if user_prompt_override and len(user_prompt_override) != len(feedback_requests):
            raise ValueError(
                "user_prompt_override must be a list of the same length as feedback_requests"
            )
        # Convert the feedback_requests and overrides to a list of tasks (feedback_requests, sys_prompt_overrides, user_prompt_overrides)
        feedback_overrides = [
            (
                req,
                system_prompt_override[i] if system_prompt_override else None,
                user_prompt_override[i] if user_prompt_override else None,
            )
            for i, req in enumerate(feedback_requests)
        ]

        tasks: list[Coroutine[Any, Any, dict[str, int | str | None]]] = [
            self.generate_feedback(
                req["problem_def"],
                req["code"],
                req["simulation_log"],
                temperature,
                top_p,
                max_tokens,
                system_prompt_override=sys_prompt_override,
                user_prompt_override=user_prompt_override,
            )
            for req, sys_prompt_override, user_prompt_override in feedback_overrides
        ]
        results = await asyncio.gather(*tasks)
        print("--- Batch LLM Feedback Received ---")
        return results
