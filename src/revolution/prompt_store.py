"""
Prompt templates: placeholders, context, and file layout
========================================================

Overview
--------
Prompt files are plain text with Python-style braces placeholders, rendered by
`safe_format(template, **vars)` (a tolerant variant of `str.format_map`).
Unknown placeholders are **left intact** (e.g., `{some_future_key}` stays literal),
so adding/removing variables is low-risk.

Templates are stored under:  data/prompts/<profile>/<subdirs>/*.txt

Key → path mapping:
    "system/whole"      -> data/prompts/<profile>/system/whole.txt
    "evolve/M-F/diff"   -> data/prompts/<profile>/evolve/M-F/diff.txt
    "feedback/user" -> data/prompts/<profile>/feedback/user.txt
Dots or slashes are equivalent in keys (they normalize to slashes).


Placeholders (variables) by category
------------------------------------

1) Generation strategies (single-parent): M-F, M-S, M-E, M-R, M-I
   - WHOLE mode templates:
        Required/available:
            {context_json}   # Pretty-printed JSON with:
                              #   {
                              #     "task": "...",
                              #     "problem_description": "...",
                              #     "parent": {
                              #        "example": 1,
                              #        "thought": "...",
                              #        "code": "...",
                              #        "feedback": "...",
                              #        "ppa_metrics": {...}?   # if available
                              #     }
                              #   }
        (No {file_to_edit} or {original_file} in WHOLE mode.)

   - DIFF mode templates:
        Required/available:
            {context_json}   # As above, but also includes:
                              #   "file_to_edit": "<absolute/original path>",
                              #   "original_file": "<full text of the file>"
            {file_to_edit}   # Same path as in context_json
            {original_file}  # Same text as in context_json

   Notes:
     - Your engine already builds `context_obj` and injects it via {context_json}.
     - For DIFF mode the engine enforces patching a **single file** (`file_to_edit`).

2) Generation strategy (two-parent): C-F (Crossover / Fusion)
   - WHOLE mode templates:
        Required/available:
            {context_json}   # JSON payload:
                              #   {
                              #     "task": "fuse_two_successes",
                              #     "problem_description": "...",
                              #     "parents": [
                              #        { "example": 1, "thought": "...", "code": "...", "feedback": "...", "ppa_metrics": {...}? },
                              #        { "example": 2, "thought": "...", "code": "...", "feedback": "...", "ppa_metrics": {...}? }
                              #     ]
                              #   }
        (No file_to_edit/original_file in WHOLE mode.)

   - DIFF mode templates:
        Required/available:
            {context_json}   # Same structure as above, plus:
                              #   "file_to_edit": "<parent1 path>",    # base is always parent1
                              #   "original_file": "<parent1 code text>"
            {file_to_edit}   # path to parent1's file (the patch base)
            {original_file}  # full text of parent1's file

   Notes:
     - The engine always treats **parent1** as the base file to edit in DIFF mode.
     - Both parents are fully included inside {context_json} under "parents".
     - Templates generally don’t need extra placeholders for parent2; the model
       can read parent2’s code/metrics from {context_json}.

3) Feedback prompts (RTL / Placement)
   - Available placeholders:
        {problem_def}    # the problem description text
        {code}           # candidate code text
        {simulation_log} # logs/metrics text pre-formatted by the engine

   - These are used when calling `llm.generate_batch_feedback(...)` with
     `system_prompt_override` and/or `user_prompt_override`. When files are
     missing, the engine’s built-in defaults are used instead.

Rendering rules
---------------
- `safe_format(template, **vars)` fills placeholders. If a name is missing, it’s
  left verbatim, so templates are forward-compatible with future variables.
- Typical usage in the engines:
    tpl = self.prompts.read("evolve/M-I/whole")
    if tpl:
        return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
    else:
        return <fallback-inline-string>

Concatenated prompt files
-------------------------
We support a single “bundle” file that groups multiple prompts with clear
markers. Example:

    ===== PROMPT: evolve/M-F/whole =====
    <template text...>
    ===== END PROMPT =====

Use:
    PromptStore.load_from_concat(path, write_to_disk=True, overwrite=True)
    PromptStore.save_concat(path, keys=None)  # keys=None => all known files

Naming and profiles
-------------------
- Keep strategy/mode keys consistent:  evolve/<STRATEGY>/{whole|diff}
- System prompts:                        system/{whole|diff}
- Feedback (examples):                   feedback/system, feedback/user
- Profiles live under data/prompts/<profile>. Select a profile at engine init:
      EoHEngine(..., prompt_profile="default")

Template tips (practical)
-------------------------
- WHOLE mode: Use only {context_json}. Keep an explicit JSON contract in the
  template body so the model returns valid JSON (format, mode, thought, code).
- DIFF mode: Instruct exact SEARCH matching and include {file_to_edit}. Your
  diff-applier also accepts an empty "search" to append text; you can hint this
  behavior in the template if you want to allow appending helper code.
- C-F: Treat parent1 as “Example 1” (the base). Say so in the template text if
  needed, but you don’t need extra placeholders—the two parents are fully
  present in {context_json} under "parents".

Examples (minimal)
------------------
Single-parent, WHOLE:
    You are an expert Verilog design assistant.

    CONTEXT_JSON:
    {context_json}

    Return exactly ONE JSON object:
    {
      "format": "eoh_v1",
      "mode": "whole",
      "thought": "<plan>",
      "code": "<full Verilog string>"
    }

Single-parent, DIFF:
    You are an expert Verilog design assistant.

    CONTEXT_JSON:
    {context_json}

    Return exactly ONE JSON object:
    {
      "format": "eoh_v1",
      "mode": "diff",
      "thought": "<changes>",
      "code": {
        "edits": [
          { "file": "{file_to_edit}", "hunks": [
              { "search": "<exact text>\\n", "replace": "<new text>\\n" }
          ] }
        ]
      }
    }

C-F, DIFF (two parents; base is parent1):
    You are an expert Verilog design assistant.
    Edit Example 1 (parent1) by fusing superior ideas from Example 2.

    CONTEXT_JSON:
    {context_json}

    Return exactly ONE JSON object:
    {
      "format": "eoh_v1",
      "mode": "diff",
      "thought": "<fusion rationale>",
      "code": {
        "edits": [
          { "file": "{file_to_edit}", "hunks": [
              { "search": "<exact original>\\n", "replace": "<replacement>\\n" }
          ] }
        ]
      }
    }

"""
# src/revolution/prompt_store.py
from __future__ import annotations

import os
import re
from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional, Tuple


# ===== Concatenated-file markers (clear & grep-friendly) =====
# Example:
# ===== PROMPT: evolve/M-F/whole =====
# <content...>
# ===== END PROMPT =====
CONCAT_START_RE = re.compile(r"^\s*={5}\s*PROMPT\s*:\s*([A-Za-z0-9._/\-]+)\s*={5}\s*$")
CONCAT_END_RE   = re.compile(r"^\s*={5}\s*END\s*PROMPT\s*={5}\s*$")


def _normalize_key(key: str) -> str:
    """
    Normalize a key so 'system.whole' and 'system/whole' are treated the same.
    """
    key = key.strip().replace("\\", "/")
    key = key.replace(".", "/")
    key = re.sub(r"/+", "/", key).strip("/")
    return key


def _key_to_relpath(key: str) -> str:
    """
    Map 'evolve/M-F/whole' → 'evolve/M-F/whole.txt'
    """
    k = _normalize_key(key)
    return f"{k}.txt"


class _Missing(dict):
    """Safe formatter: leaves unknown placeholders intact (as {name})."""
    def __missing__(self, k: str) -> str:
        return "{" + k + "}"


def safe_format(template: str, **vars: object) -> str:
    """
    Like str.format_map but doesn't crash on missing keys.
    """
    return template.format_map(_Missing(vars))


@dataclass
class PromptStore:
    """
    Small on-disk prompt registry.

    - root_dir:  directory containing all prompt profiles (default 'data/prompts')
    - profile:   subfolder under root_dir (default 'default')
    """
    root_dir: str = "data/prompts"
    profile: str = "default"
    encoding: str = "utf-8"

    # -------- Paths --------
    @property
    def base_dir(self) -> str:
        return os.path.join(self.root_dir, self.profile)

    def _abs_path_for(self, key: str) -> str:
        rel = _key_to_relpath(key)
        return os.path.join(self.base_dir, rel)

    # -------- CRUD --------
    def has(self, key: str) -> bool:
        return os.path.exists(self._abs_path_for(key))

    def read(self, key: str) -> Optional[str]:
        p = self._abs_path_for(key)
        if not os.path.exists(p):
            return None
        with open(p, "r", encoding=self.encoding) as f:
            return f.read()

    def write(self, key: str, content: str) -> str:
        p = self._abs_path_for(key)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding=self.encoding) as f:
            f.write(content)
        return p

    def list_keys(self) -> List[str]:
        keys: List[str] = []
        for root, _, files in os.walk(self.base_dir):
            for fn in files:
                if not fn.endswith(".txt"):
                    continue
                abs_path = os.path.join(root, fn)
                rel_path = os.path.relpath(abs_path, self.base_dir)
                key = rel_path[:-4].replace("\\", "/")  # drop .txt
                keys.append(key)
        return sorted(keys)

    # -------- Concatenated file helpers --------
    def load_from_concat(self, file_path: str, write_to_disk: bool = False, overwrite: bool = True) -> Dict[str, str]:
        """
        Parse a concatenated file and return {key: content}.
        If write_to_disk=True, persists each section into its key's file.
        """
        with open(file_path, "r", encoding=self.encoding) as f:
            text = f.read()
        sections = self._parse_concat(text)
        if write_to_disk:
            for key, content in sections.items():
                if not overwrite and self.has(key):
                    continue
                self.write(key, content)
        return sections

    def save_concat(self, file_path: str, keys: Optional[Iterable[str]] = None) -> str:
        """
        Write a concatenated file from the current prompts.
        If keys is None, write all known keys.
        """
        if keys is None:
            keys = self.list_keys()
        blocks: List[str] = []
        for key in keys:
            content = self.read(key) or ""
            blocks.append(self._format_concat_block(key, content))
        os.makedirs(os.path.dirname(file_path) or ".", exist_ok=True)
        with open(file_path, "w", encoding=self.encoding) as f:
            f.write("\n\n".join(blocks) + "\n")
        return file_path

    # -------- Internals --------
    def _format_concat_block(self, key: str, content: str) -> str:
        key = _normalize_key(key)
        return (
            f"===== PROMPT: {key} =====\n"
            f"{content.rstrip()}\n"
            f"===== END PROMPT ====="
        )

    def _parse_concat(self, text: str) -> Dict[str, str]:
        out: Dict[str, str] = {}
        lines = text.splitlines()
        i = 0
        while i < len(lines):
            m = CONCAT_START_RE.match(lines[i])
            if not m:
                i += 1
                continue
            key = _normalize_key(m.group(1))
            i += 1
            buf: List[str] = []
            while i < len(lines) and not CONCAT_END_RE.match(lines[i]):
                buf.append(lines[i])
                i += 1
            if i == len(lines):
                raise ValueError(f"Unclosed prompt block for key: {key}")
            out[key] = "\n".join(buf).rstrip() + "\n"
            i += 1  # skip END
        return out
