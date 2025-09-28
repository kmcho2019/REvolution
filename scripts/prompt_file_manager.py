from __future__ import annotations

import argparse
import os
from typing import Dict, Iterable, Optional

# prompt_file_manager.py
# Script for exporting currently loaded prompts to text files.
#
# Usage:
# This script extracts the currently loaded prompts from the Python code and
# writes them to individual text files in a specified directory.
#
# Steps:
# 1. Update the `prompts_dict` with your actual prompts.
# 2. Set the `prompt_directory` variable to your desired output directory.
# 3. Run the script. It will create a .txt file for each prompt type in the specified directory.


## How to use it
'''
1. **One-time: generate initial files from your Python prompts**

```bash
python script/script_name.py init --profile default --write-missing
```

This fills `data/prompts/default/**` with the full set (system, evolve per strategy/mode, feedback). It won’t overwrite anything that already exists.

2. **Export a concatenated snapshot** (handy for PRs/reviews)

```bash
python script/script_name.py export --profile default --fill-missing-with-fallbacks --emit-concat data/prompts/default.all.txt
```

3. **Edit that single file, then import back to files**

```bash
python script/script_name.py import --profile default --from-concat data/prompts/default.all.txt --overwrite
```

4. **List what’s on disk**

```bash
python script/script_name.py list --profile default
```

---

## Notes

* The script depends on `PromptStore` from `src/revolution/prompt_store.py` (from my previous reply). Make sure that file exists and `src/` is on `PYTHONPATH` (or run with `python -m script.script_name …`).
* The fallback catalog mirrors your current inline prompts. If you later tweak the inline fallbacks in code, you can re-run `init --overwrite` to regenerate files.
* Once files exist, your engines will pick them up (and still fall back to inline strings only when a file is missing), so you can iterate on prompts without touching Python.
'''
"""
Utilities for managing file-based prompts.

Features:
- Write initial prompt files from a built-in fallback catalog (mirrors your current inline Python prompts).
- Export existing prompts to a concatenated file.
- Import from a concatenated file to prompt files.
- List known prompt keys.
- Optionally overwrite or only fill missing files.

Typical uses:
1) Generate initial prompt files (one-time bootstrapping):
   python script/script_name.py init --profile default --write-missing

2) Export all prompts (files + any missing filled by fallbacks) into one snapshot:
   python script/script_name.py export --profile default --emit-concat data/prompts/default.all.txt

3) Import from a concatenated file (reviewed/edited in PR) back to files:
   python script/script_name.py import --profile default --from-concat data/prompts/default.all.txt --overwrite
"""



# --- If your repo layout differs, adjust this import path accordingly ---
# Expecting: src/revolution/prompt_store.py (from my previous message)
try:
    from revolution.prompt_store import PromptStore, safe_format
except Exception as e:
    raise SystemExit(
        "ERROR: Could not import revolution.prompt_store. "
        "Make sure src/ is on PYTHONPATH or run as `python -m script.script_name ...`\n"
        f"Underlying error: {e}"
    )


# -------------------------------------------------------------------
# Fallback catalog: these mirror your current inline Python prompts.
# Keys map to files under data/prompts/<profile>/...:
#   system/whole.txt, system/diff.txt
#   evolve/<STRATEGY>/{whole|diff}.txt for M-F, M-S, M-E, M-R, M-I, C-F
#   feedback/rtl_system.txt, feedback/rtl_user.txt
#   feedback/placement_system.txt, feedback/placement_user.txt
#
# Placeholders available for formatting at runtime:
#   {context_json}, {file_to_edit}, {original_file}, {problem_def}, {code}, {simulation_log}
# -------------------------------------------------------------------

SYSTEM_WHOLE = """You are an expert Verilog design assistant.
Follow the JSON context, generate a full solution, and obey the output format.

CONTEXT_JSON:
{context_json}

Return exactly ONE JSON object:
{{
  "format": "eoh_v1",
  "mode": "whole",
  "thought": "<brief plan>",
  "code": "<full Verilog as one JSON string>"
}}

Rules: valid JSON only (no markdown). Escape newlines as \\n and quotes.
All content inside JSON strings must be properly escaped.
"""

SYSTEM_DIFF = """You are an expert Verilog design assistant.
Use the JSON context to propose precise edits.

CONTEXT_JSON:
{context_json}

Return exactly ONE JSON object:
{{
  "format": "eoh_v1",
  "mode": "diff",
  "thought": "<summary of changes>",
  "code": {{
    "edits": [
      {{ "file": "{file_to_edit}", "hunks": [
          {{ "search": "<exact original>\\n", "replace": "<replacement>\\n" }}
      ] }}
    ]
  }}
}}

Rules: valid JSON only; exact SEARCH match; escape newlines as \\n. Keep hunks minimal but unique.
All content inside JSON strings must be properly escaped.
"""

EVOLVE_WHOLE_COMMON = """You are an expert Verilog design assistant.
{task_line}

CONTEXT_JSON:
{context_json}

Return exactly ONE JSON object and nothing else:
{{
  "format": "eoh_v1",
  "mode": "whole",
  "thought": "<brief explanation / plan>",
  "code": "<full, runnable Verilog as one JSON string>"
}}
Rules: valid JSON only (no markdown). Escape newlines as \\n and quotes.
All content inside JSON strings must be properly escaped.
"""

EVOLVE_DIFF_COMMON = """You are an expert Verilog design assistant.
{task_line}

CONTEXT_JSON:
{context_json}

Return exactly ONE JSON object and nothing else:
{{
  "format": "eoh_v1",
  "mode": "diff",
  "thought": "<brief explanation of the changes>",
  "code": {{
    "edits": [
      {{ "file": "{file_to_edit}", "hunks": [
          {{ "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }}
      ] }}
    ]
  }}
}}
Rules: valid JSON only; exact SEARCH match; escape newlines as \\n.
Use multiple hunks if needed. Keep hunks concise and uniquely matching.
All content inside JSON strings must be properly escaped.
"""

TASK_LINES = {
    "M-F": "Fix the failed attempt using the context below.",
    "M-S": "Simplify the previous solution while preserving functionality.",
    "M-E": "Explore a substantially different architectural idea.",
    "M-R": "Refactor to a cleaner structure while preserving intent.",
    "M-I": "Improve correctness (if failed) and/or PPA QoR (if succeeded).",
    "C-F": "Fuse the best ideas from two successful solutions into one.",
}

FEEDBACK_RTL_SYS = """You are a senior Verilog code reviewer. Given a problem definition, a candidate code, and logs, produce JSON feedback with keys:
- "score" (0..10), 
- "justification" (1-2 sentences),
- "analysis" (detailed, but DO NOT include complete corrected code).
"""

FEEDBACK_RTL_USER = """Problem Definition:
{problem_def}

Candidate Code:
{code}

Logs:
{simulation_log}

Return exactly one JSON object with keys: score (0..10), justification, analysis.
"""

FEEDBACK_PLACEMENT_SYS = """You are a VLSI Physical Design expert specializing in placement legalization algorithms.
Given a problem description, a Python legalization script, and an evaluation log, return a JSON object with keys:
- "score" (0..10),
- "justification",
- "analysis" (no full corrected code; high-level guidance only).
"""

FEEDBACK_PLACEMENT_USER = """Problem:
{problem_def}

Code:
{code}

Evaluation Log:
{simulation_log}

Return exactly one JSON object with keys: score (0..10), justification, analysis.
"""

def build_fallback_catalog() -> Dict[str, str]:
    catalog: Dict[str, str] = {}

    # System prompts
    catalog["system/whole"] = SYSTEM_WHOLE
    catalog["system/diff"] = SYSTEM_DIFF

    # Evolve prompts (whole + diff) for each strategy
    for strat, task_line in TASK_LINES.items():
        catalog[f"evolve/{strat}/whole"] = EVOLVE_WHOLE_COMMON.format(
            task_line=task_line, context_json="{context_json}"
        )
        catalog[f"evolve/{strat}/diff"] = EVOLVE_DIFF_COMMON.format(
            task_line=task_line, context_json="{context_json}",
            file_to_edit="{file_to_edit}",
        )

    # Feedback prompts
    catalog["feedback/rtl_system"] = FEEDBACK_RTL_SYS
    catalog["feedback/rtl_user"]   = FEEDBACK_RTL_USER
    catalog["feedback/placement_system"] = FEEDBACK_PLACEMENT_SYS
    catalog["feedback/placement_user"]   = FEEDBACK_PLACEMENT_USER

    return catalog


# -------------------- Command handlers --------------------

def cmd_init(store: PromptStore, write_missing: bool, overwrite: bool) -> None:
    """
    Write prompt files from the fallback catalog.
    - If write_missing=True and overwrite=False: fill only files that don't exist.
    - If overwrite=True: replace everything with the catalog.
    """
    catalog = build_fallback_catalog()
    wrote = 0
    for key, text in catalog.items():
        if not overwrite and store.has(key) and not write_missing:
            continue
        if not overwrite and store.has(key) and write_missing:
            # skip existing files
            continue
        store.write(key, text)
        wrote += 1
    print(f"[init] Wrote {wrote} file(s) into {store.base_dir} "
          f"(profile={store.profile}, overwrite={overwrite}, write_missing={write_missing}).")


def cmd_export(store: PromptStore, emit_concat: Optional[str], fill_missing_with_fallbacks: bool, overwrite: bool) -> None:
    """
    Export existing prompt files, optionally filling missing ones from the fallback catalog first.
    Then (optionally) write a concatenated snapshot.
    """
    if fill_missing_with_fallbacks:
        catalog = build_fallback_catalog()
        filled = 0
        for key, text in catalog.items():
            if not store.has(key):
                store.write(key, text)
                filled += 1
        print(f"[export] Filled {filled} missing file(s) from fallback catalog.")

    keys = store.list_keys()
    print(f"[export] Found {len(keys)} file-backed prompt(s) under {store.base_dir}.")
    if emit_concat:
        out = store.save_concat(emit_concat, keys=keys)
        print(f"[export] Wrote concatenated snapshot → {out}")


def cmd_import(store: PromptStore, from_concat: str, overwrite: bool) -> None:
    """
    Import prompts from a concatenated file into file-backed prompts.
    """
    sections = store.load_from_concat(from_concat, write_to_disk=True, overwrite=overwrite)
    print(f"[import] Imported {len(sections)} prompt(s) from {from_concat} "
          f"into {store.base_dir} (overwrite={overwrite}).")


def cmd_list(store: PromptStore) -> None:
    keys = store.list_keys()
    if not keys:
        print(f"[list] No prompt files found in {store.base_dir}")
        return
    print(f"[list] {len(keys)} prompt(s) in {store.base_dir}:")
    for k in keys:
        print(" -", k)


# -------------------- CLI --------------------

def main():
    parser = argparse.ArgumentParser(description="Prompt file manager")
    parser.add_argument("--root", default="data/prompts", help="Root folder for prompts (default: data/prompts)")
    parser.add_argument("--profile", default="default", help="Prompt profile subfolder (default: default)")

    sub = parser.add_subparsers(dest="cmd", required=True)

    # init
    p_init = sub.add_parser("init", help="Write initial prompt files from built-in catalog")
    p_init.add_argument("--write-missing", action="store_true", help="Only create files that do not exist")
    p_init.add_argument("--overwrite", action="store_true", help="Overwrite existing files")

    # export
    p_export = sub.add_parser("export", help="Export prompts, optionally fill missing, and/or write a concatenated snapshot")
    p_export.add_argument("--emit-concat", default=None, help="Path to write concatenated snapshot (e.g., data/prompts/default.all.txt)")
    p_export.add_argument("--fill-missing-with-fallbacks", action="store_true", help="If a key has no file, create it from the fallback catalog first")
    p_export.add_argument("--overwrite", action="store_true", help="(Unused here, kept for symmetry)")

    # import
    p_import = sub.add_parser("import", help="Import prompts from a concatenated file")
    p_import.add_argument("--from-concat", required=True, help="Concatenated prompts file to import")
    p_import.add_argument("--overwrite", action="store_true", help="Overwrite existing files")

    # list
    p_list = sub.add_parser("list", help="List file-backed prompt keys currently on disk")

    args = parser.parse_args()

    store = PromptStore(root_dir=os.path.abspath(args.root), profile=args.profile)

    if args.cmd == "init":
        cmd_init(store, write_missing=args.write_missing, overwrite=args.overwrite)
    elif args.cmd == "export":
        cmd_export(
            store,
            emit_concat=args.emit_concat,
            fill_missing_with_fallbacks=args.fill_missing_with_fallbacks,
            overwrite=args.overwrite,
        )
    elif args.cmd == "import":
        cmd_import(store, from_concat=args.from_concat, overwrite=args.overwrite)
    elif args.cmd == "list":
        cmd_list(store)
    else:
        parser.error("Unknown command")


if __name__ == "__main__":
    main()
