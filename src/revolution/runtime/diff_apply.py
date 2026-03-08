from __future__ import annotations

import json
import math
import os
import re
from dataclasses import dataclass
from difflib import SequenceMatcher
from typing import Any, Iterator, Literal, cast


DiffApplyPolicy = Literal["strict", "hybrid", "fuzzy"]


@dataclass(frozen=True)
class DiffApplyConfig:
    """Configuration for JSON/legacy diff application behavior."""

    policy: DiffApplyPolicy = "hybrid"
    similarity_threshold: float = 0.86
    fuzzy_margin: float = 0.03
    length_scale: float = 0.1
    allow_dots: bool = True


class DiffApplier:
    """
    Reusable diff applier shared by backend implementations.

    Supports both:
    - JSON edits (`{"code": {"edits": ...}}` or `{"edits": ...}`)
    - legacy SEARCH/REPLACE fenced diffs.
    """

    def __init__(self, config: DiffApplyConfig | None = None) -> None:
        cfg = config or DiffApplyConfig()
        self.policy = cfg.policy
        self.similarity_threshold = float(cfg.similarity_threshold)
        self.fuzzy_margin = float(cfg.fuzzy_margin)
        self.length_scale = float(cfg.length_scale)
        self.allow_dots = bool(cfg.allow_dots)
        self._last_diff_apply_diagnostics: dict[str, Any] = {}
        self._last_replace_diagnostics: dict[str, Any] = {}
        self._reset_diff_apply_diagnostics()

    @property
    def last_diff_diagnostics(self) -> dict[str, Any]:
        return dict(self._last_diff_apply_diagnostics)

    @property
    def last_replace_diagnostics(self) -> dict[str, Any]:
        return dict(self._last_replace_diagnostics)

    def _reset_diff_apply_diagnostics(self) -> None:
        self._last_diff_apply_diagnostics = {
            "reason_code": None,
            "reason": None,
            "phase": None,
            "matching_policy": self.policy,
            "hunks": [],
        }
        self._last_replace_diagnostics = {}

    def _set_replace_diag(
        self,
        *,
        phase: str,
        reason_code: str | None,
        reason: str | None,
        details: dict[str, Any] | None = None,
    ) -> None:
        self._last_replace_diagnostics = {
            "phase": phase,
            "reason_code": reason_code,
            "reason": reason,
            "details": details or {},
        }

    def _set_diff_failure(self, reason_code: str, reason: str, phase: str | None = None) -> None:
        self._last_diff_apply_diagnostics["reason_code"] = reason_code
        self._last_diff_apply_diagnostics["reason"] = reason
        if phase is not None:
            self._last_diff_apply_diagnostics["phase"] = phase

    def _diff_targets_match(self, edit_file: str, target_file_path: str) -> bool:
        """Return whether a diff edit targets the requested single-file artifact.

        CodeEvolve diff prompts name the editable artifact as `code.sv`, while the
        evaluator passes the concrete artifact path from the run directory. Accept
        either the exact path or the logical single-file basename so phase-1
        backends do not fail valid one-file edits just because the artifact root
        is run-specific.
        """

        normalized_edit = os.path.normpath(edit_file)
        normalized_target = os.path.normpath(target_file_path)
        if normalized_edit == normalized_target:
            return True
        return os.path.basename(normalized_edit) == os.path.basename(normalized_target)

    def _parse_diff_block(self, diff_text: str) -> Iterator[tuple[str, str, str]]:
        lines = diff_text.splitlines(keepends=True)
        i = 0
        while i < len(lines):
            while i < len(lines) and not lines[i].strip():
                i += 1
            if i >= len(lines):
                break

            file_path = lines[i].strip().strip("`")
            i += 1
            if not file_path:
                continue

            if i < len(lines) and lines[i].strip().startswith("```"):
                i += 1

            while i < len(lines) and lines[i].strip() != "<<<<<<< SEARCH":
                i += 1
            if i >= len(lines):
                break

            i += 1
            search_block: list[str] = []
            while i < len(lines) and lines[i].strip() != "=======":
                search_block.append(lines[i])
                i += 1
            if i >= len(lines):
                break

            i += 1
            replace_block: list[str] = []
            while i < len(lines) and lines[i].strip() != ">>>>>>> REPLACE":
                replace_block.append(lines[i])
                i += 1
            if i >= len(lines):
                break

            i += 1
            if i < len(lines) and lines[i].strip().startswith("```"):
                i += 1
            yield file_path, "".join(search_block), "".join(replace_block)

    def _strip_quoted_wrapping(self, text: str, fname: str | None = None) -> str:
        if not text:
            return text

        lines = text.splitlines()
        if not lines:
            return text

        if fname:
            base = os.path.basename(fname)
            head = lines[0].strip().strip("`").rstrip(":")
            if head == base or head == fname:
                lines = lines[1:] if len(lines) > 1 else []

        if (
            len(lines) >= 2
            and lines[0].strip().startswith("```")
            and lines[-1].strip().startswith("```")
        ):
            lines = lines[1:-1]

        out = "\n".join(lines)
        if out and not out.endswith("\n"):
            out += "\n"
        return out

    def _find_all_exact_spans(self, text: str, needle: str) -> list[tuple[int, int]]:
        spans: list[tuple[int, int]] = []
        if not needle:
            return spans
        start = 0
        while True:
            idx = text.find(needle, start)
            if idx < 0:
                break
            spans.append((idx, idx + len(needle)))
            start = idx + 1
        return spans

    def _replace_span(self, text: str, start: int, end: int, replacement: str) -> str:
        return text[:start] + replacement + text[end:]

    def _normalize_ws_line(self, line: str) -> str:
        return re.sub(r"[ \t]+", "", line.strip())

    def _prep_lines(self, s: str) -> tuple[str, list[str]]:
        if s and not s.endswith("\n"):
            s += "\n"
        return s, s.splitlines(keepends=True)

    def _replace_whitespace_normalized(
        self,
        whole: str,
        part: str,
        replace: str,
    ) -> tuple[str | None, dict[str, Any]]:
        whole, whole_lines = self._prep_lines(whole)
        part, part_lines = self._prep_lines(part)
        _replace, replace_lines = self._prep_lines(replace)

        n = len(part_lines)
        if n == 0 or len(whole_lines) < n:
            return None, {
                "reason_code": "search_not_found",
                "reason": "no whitespace-normalized windows available",
                "match_count": 0,
            }

        part_norm = [self._normalize_ws_line(x) for x in part_lines]
        matches: list[tuple[int, int]] = []
        for i in range(0, len(whole_lines) - n + 1):
            cand_norm = [self._normalize_ws_line(x) for x in whole_lines[i : i + n]]
            if cand_norm == part_norm:
                matches.append((i, i + n))

        if not matches:
            return None, {
                "reason_code": "search_not_found",
                "reason": "no whitespace-normalized match found",
                "match_count": 0,
            }
        if len(matches) > 1:
            return None, {
                "reason_code": "ambiguous_whitespace_match",
                "reason": f"whitespace-normalized search block matched {len(matches)} regions",
                "match_count": len(matches),
                "matches": [{"start_line": s, "end_line": e} for s, e in matches[:8]],
            }

        start_line, end_line = matches[0]
        updated = "".join(whole_lines[:start_line] + replace_lines + whole_lines[end_line:])
        return updated, {
            "reason_code": None,
            "reason": None,
            "match_count": 1,
            "window": {"start_line": start_line, "end_line": end_line},
        }

    def _try_dotdotdots(self, whole: str, part: str, replace: str) -> str | None:
        if not self.allow_dots:
            return None

        dots_re = re.compile(r"(^\s*\.\.\.\n)", re.MULTILINE | re.DOTALL)

        part_pieces = re.split(dots_re, part)
        replace_pieces = re.split(dots_re, replace)
        if len(part_pieces) != len(replace_pieces):
            return None
        if len(part_pieces) == 1:
            return None

        if not all(
            part_pieces[i] == replace_pieces[i] for i in range(1, len(part_pieces), 2)
        ):
            return None

        part_chunks = [part_pieces[i] for i in range(0, len(part_pieces), 2)]
        replace_chunks = [replace_pieces[i] for i in range(0, len(replace_pieces), 2)]

        w = whole
        for p, r in zip(part_chunks, replace_chunks):
            if not p and not r:
                continue
            if not p and r:
                if not w.endswith("\n"):
                    w += "\n"
                w += r
                continue
            if w.count(p) != 1:
                return None
            w = w.replace(p, r, 1)
        return w

    def _replace_closest_edit_distance(
        self,
        whole_lines: list[str],
        part: str,
        part_lines: list[str],
        replace_lines: list[str],
    ) -> tuple[str | None, dict[str, Any]]:
        min_len = max(1, math.floor(len(part_lines) * (1.0 - self.length_scale)))
        max_len = max(min_len, math.ceil(len(part_lines) * (1.0 + self.length_scale)))

        ranked: list[tuple[float, int, int]] = []
        for length in range(min_len, max_len + 1):
            for i in range(0, len(whole_lines) - length + 1):
                cand = "".join(whole_lines[i : i + length])
                ratio = SequenceMatcher(None, cand, part).ratio()
                ranked.append((ratio, i, i + length))

        if not ranked:
            return None, {
                "best_ratio": 0.0,
                "second_ratio": 0.0,
                "reason_code": "no_candidates",
                "reason": "no fuzzy windows available for search block",
            }

        ranked.sort(key=lambda x: x[0], reverse=True)
        best_ratio, best_i, best_j = ranked[0]
        second_ratio = ranked[1][0] if len(ranked) > 1 else 0.0
        top_candidates = [
            {"ratio": ratio, "start_line": i, "end_line": j}
            for ratio, i, j in ranked[:5]
        ]

        if best_ratio < self.similarity_threshold:
            return None, {
                "best_ratio": best_ratio,
                "second_ratio": second_ratio,
                "top_candidates": top_candidates,
                "reason_code": "fuzzy_below_threshold",
                "reason": (
                    f"best fuzzy ratio {best_ratio:.4f} is below threshold "
                    f"{self.similarity_threshold:.4f}"
                ),
            }

        if len(ranked) > 1 and (best_ratio - second_ratio) < self.fuzzy_margin:
            return None, {
                "best_ratio": best_ratio,
                "second_ratio": second_ratio,
                "top_candidates": top_candidates,
                "reason_code": "ambiguous_fuzzy_match",
                "reason": (
                    f"best-second fuzzy ratio gap {(best_ratio-second_ratio):.4f} "
                    f"is below required margin {self.fuzzy_margin:.4f}"
                ),
            }

        return "".join(whole_lines[:best_i] + replace_lines + whole_lines[best_j:]), {
            "best_ratio": best_ratio,
            "second_ratio": second_ratio,
            "top_candidates": top_candidates,
            "reason_code": None,
            "reason": None,
            "window": {"start": best_i, "end": best_j},
        }

    def _do_replace(
        self,
        content: str,
        original: str,
        updated: str,
        filename: str | None = None,
    ) -> str | None:
        if content is None:
            self._set_replace_diag(
                phase="invalid_input",
                reason_code="invalid_content",
                reason="content is None",
            )
            return None

        if not original.strip():
            self._set_replace_diag(
                phase="append",
                reason_code=None,
                reason=None,
                details={"append_len": len(updated)},
            )
            return (content or "") + updated

        original = self._strip_quoted_wrapping(original, filename)
        updated = self._strip_quoted_wrapping(updated, filename)

        exact_spans = self._find_all_exact_spans(content, original)
        exact_count = len(exact_spans)
        if exact_count == 1:
            span = exact_spans[0]
            self._set_replace_diag(
                phase="exact_unique",
                reason_code=None,
                reason=None,
                details={
                    "exact_match_count": exact_count,
                    "match_span": {"start": span[0], "end": span[1]},
                },
            )
            return self._replace_span(content, span[0], span[1], updated)

        if exact_count > 1 and self.policy == "strict":
            self._set_replace_diag(
                phase="exact_ambiguous",
                reason_code="ambiguous_exact_match",
                reason=f"exact search block occurs {exact_count} times",
                details={"exact_match_count": exact_count},
            )
            return None

        if self.policy == "strict":
            self._set_replace_diag(
                phase="strict_no_match",
                reason_code="search_not_found",
                reason="strict diff policy did not find a unique exact match",
            )
            return None

        ws_result, ws_diag = self._replace_whitespace_normalized(content, original, updated)
        if ws_result is not None:
            self._set_replace_diag(
                phase="whitespace_normalized",
                reason_code=None,
                reason=None,
                details=ws_diag,
            )
            return ws_result
        if ws_diag.get("reason_code") == "ambiguous_whitespace_match":
            self._set_replace_diag(
                phase="whitespace_normalized",
                reason_code="ambiguous_whitespace_match",
                reason=ws_diag.get("reason"),
                details=ws_diag,
            )
            return None

        if self.allow_dots:
            try:
                dot_result = self._try_dotdotdots(content, original, updated)
            except Exception:
                dot_result = None
            if dot_result is not None:
                self._set_replace_diag(
                    phase="dotdotdots",
                    reason_code=None,
                    reason=None,
                )
                return dot_result

        whole, whole_lines = self._prep_lines(content)
        part, part_lines = self._prep_lines(original)
        _replace, replace_lines = self._prep_lines(updated)
        fuzzy_result, fuzzy_diag = self._replace_closest_edit_distance(
            whole_lines, part, part_lines, replace_lines
        )
        if fuzzy_result is not None:
            self._set_replace_diag(
                phase="fuzzy",
                reason_code=None,
                reason=None,
                details=fuzzy_diag,
            )
            return fuzzy_result

        self._set_replace_diag(
            phase="fuzzy",
            reason_code=fuzzy_diag.get("reason_code") or "search_not_found",
            reason=fuzzy_diag.get("reason") or "no fuzzy candidate passed guarded checks",
            details=fuzzy_diag,
        )
        return None

    def _apply_json_edits(
        self,
        original_content: str,
        edits_obj: dict[str, Any],
        target_file_path: str | None = None,
    ) -> str | None:
        self._last_diff_apply_diagnostics["matching_policy"] = self.policy
        edits = edits_obj.get("edits")
        if not isinstance(edits, list) or not edits:
            self._set_diff_failure(
                "invalid_json_diff",
                "JSON diff payload is missing a non-empty 'edits' list.",
                phase="json_validate",
            )
            return None
        if any(not isinstance(e, dict) for e in edits):
            self._set_diff_failure(
                "invalid_json_diff",
                "JSON diff payload contains non-object edit entries.",
                phase="json_validate",
            )
            return None

        chosen_edits: list[dict[str, Any]] = []
        if target_file_path:
            chosen_edits = [
                cast(dict[str, Any], e)
                for e in edits
                if isinstance(e, dict)
                and isinstance(e.get("file"), str)
                and self._diff_targets_match(cast(str, e["file"]), target_file_path)
            ]
            if not chosen_edits:
                self._set_diff_failure(
                    "target_file_not_found",
                    (
                        f"JSON diff contained {len(edits)} edit blocks but none targeted "
                        f"requested file '{target_file_path}'."
                    ),
                    phase="json_select_edit",
                )
                return None
            non_target_edits = [
                e
                for e in edits
                if isinstance(e, dict)
                and isinstance(e.get("file"), str)
                and not self._diff_targets_match(cast(str, e["file"]), target_file_path)
            ]
            if non_target_edits:
                self._set_diff_failure(
                    "multi_file_edit_not_allowed",
                    (
                        "Diff payload edited multiple files. "
                        "Current diff mode expects a single target file edit."
                    ),
                    phase="json_select_edit",
                )
                return None
        else:
            if len(edits) != 1:
                self._set_diff_failure(
                    "multi_file_edit_not_allowed",
                    "JSON diff provided multiple edit blocks without an explicit target file.",
                    phase="json_select_edit",
                )
                return None
            chosen_edits = [cast(dict[str, Any], edits[0])]

        chosen_file = cast(str | None, chosen_edits[0].get("file"))
        hunks: list[dict[str, Any]] = []
        for edit_idx, edit in enumerate(chosen_edits):
            edit_hunks = edit.get("hunks")
            if not isinstance(edit_hunks, list) or not edit_hunks:
                self._set_diff_failure(
                    "invalid_json_diff",
                    f"JSON diff edit[{edit_idx}] is missing a non-empty 'hunks' list.",
                    phase="json_validate",
                )
                return None
            for hunk in edit_hunks:
                if not isinstance(hunk, dict):
                    self._set_diff_failure(
                        "invalid_json_diff",
                        f"Malformed hunk object: {hunk}",
                        phase="json_validate",
                    )
                    return None
                hunks.append(hunk)

        normalized_hunks: list[dict[str, str]] = []
        exact_hunk_windows: list[tuple[int, int, int]] = []
        for hunk_idx, h in enumerate(hunks):
            search = h.get("search", "")
            replace = h.get("replace", "")
            if not isinstance(search, str) or not isinstance(replace, str):
                self._set_diff_failure(
                    "invalid_json_diff",
                    "JSON diff hunk requires string 'search' and 'replace' fields.",
                    phase="json_validate",
                )
                return None
            if search and not search.endswith("\n"):
                search += "\n"
            if replace and not replace.endswith("\n"):
                replace += "\n"
            normalized_hunks.append({"search": search, "replace": replace})

            if search.strip():
                spans = self._find_all_exact_spans(original_content, search)
                if len(spans) == 1:
                    s0, e0 = spans[0]
                    for ps, pe, prev_idx in exact_hunk_windows:
                        if not (e0 <= ps or s0 >= pe):
                            self._set_diff_failure(
                                "overlap_conflict",
                                (
                                    f"Hunk {hunk_idx} overlaps previously matched "
                                    f"hunk {prev_idx} in original content."
                                ),
                                phase="json_preflight",
                            )
                            return None
                    exact_hunk_windows.append((s0, e0, hunk_idx))

        new_content = original_content
        for hunk_idx, hunk in enumerate(normalized_hunks):
            search = hunk["search"]
            replace = hunk["replace"]
            result = self._do_replace(new_content, search, replace, filename=chosen_file)
            if result is None:
                replace_diag = dict(self._last_replace_diagnostics)
                self._last_diff_apply_diagnostics["hunks"].append(
                    {
                        "hunk_index": hunk_idx,
                        "search_preview": search[:160],
                        "replace_preview": replace[:160],
                        "result": "failed",
                        "replace_diagnostics": replace_diag,
                    }
                )
                self._set_diff_failure(
                    replace_diag.get("reason_code") or "hunk_apply_failed",
                    replace_diag.get("reason") or "A diff hunk did not match uniquely.",
                    phase=replace_diag.get("phase"),
                )
                return None

            self._last_diff_apply_diagnostics["hunks"].append(
                {
                    "hunk_index": hunk_idx,
                    "search_preview": search[:160],
                    "replace_preview": replace[:160],
                    "result": "applied",
                    "replace_diagnostics": dict(self._last_replace_diagnostics),
                }
            )
            new_content = result

        return new_content

    def apply(
        self,
        original_content: str,
        diff_text: str,
        *,
        target_file_path: str | None = None,
    ) -> str | None:
        """Apply a JSON/legacy diff payload to `original_content`."""

        self._reset_diff_apply_diagnostics()
        self._last_diff_apply_diagnostics["target_file_path"] = target_file_path

        try:
            obj = json.loads(diff_text)
            if isinstance(obj, dict):
                edits_obj = obj
                if isinstance(obj.get("code"), dict) and "edits" in obj["code"]:
                    edits_obj = cast(dict[str, Any], obj["code"])
                if "edits" in edits_obj:
                    updated = self._apply_json_edits(
                        original_content,
                        edits_obj,
                        target_file_path,
                    )
                    if updated is not None:
                        self._last_diff_apply_diagnostics["phase"] = "json"
                    return updated
        except Exception as exc:
            if diff_text.lstrip().startswith("{"):
                self._set_diff_failure(
                    "json_parse_error",
                    f"Diff payload looked like JSON but could not be parsed: {exc}",
                    phase="json_parse",
                )
                return None

        self._last_diff_apply_diagnostics["phase"] = "legacy"
        search_markers = len(re.findall(r"(?m)^\s*<<<<<<< SEARCH\s*$", diff_text))
        middle_markers = len(re.findall(r"(?m)^\s*=======\s*$", diff_text))
        replace_markers = len(re.findall(r"(?m)^\s*>>>>>>> REPLACE\s*$", diff_text))
        if search_markers == 0 and replace_markers == 0:
            self._set_diff_failure(
                "legacy_parse_error",
                "Could not parse any valid SEARCH/REPLACE diff blocks.",
                phase="legacy_parse",
            )
            return None
        if not (search_markers == middle_markers == replace_markers):
            self._set_diff_failure(
                "legacy_delimiter_mismatch",
                (
                    "Malformed legacy diff delimiters: "
                    f"SEARCH={search_markers}, MID={middle_markers}, REPLACE={replace_markers}"
                ),
                phase="legacy_parse",
            )
            return None

        new_content = original_content
        edits = list(self._parse_diff_block(diff_text))
        if not edits:
            self._set_diff_failure(
                "legacy_parse_error",
                "Could not parse any valid SEARCH/REPLACE diff blocks.",
                phase="legacy_parse",
            )
            return None

        for file_path, search_block, replace_block in edits:
            search_block = search_block.rstrip("\n")
            if not search_block.endswith("\n"):
                search_block += "\n"
            if not replace_block.endswith("\n"):
                replace_block += "\n"

            result = self._do_replace(new_content, search_block, replace_block, filename=file_path)
            if result is None:
                replace_diag = dict(self._last_replace_diagnostics)
                self._last_diff_apply_diagnostics["hunks"].append(
                    {
                        "hunk_index": len(self._last_diff_apply_diagnostics["hunks"]),
                        "file": file_path,
                        "result": "failed",
                        "search_preview": search_block[:160],
                        "replace_preview": replace_block[:160],
                        "replace_diagnostics": replace_diag,
                    }
                )
                self._set_diff_failure(
                    replace_diag.get("reason_code") or "hunk_apply_failed",
                    replace_diag.get("reason") or "Legacy diff hunk failed to apply.",
                    phase=replace_diag.get("phase"),
                )
                return None

            self._last_diff_apply_diagnostics["hunks"].append(
                {
                    "hunk_index": len(self._last_diff_apply_diagnostics["hunks"]),
                    "file": file_path,
                    "result": "applied",
                    "search_preview": search_block[:160],
                    "replace_preview": replace_block[:160],
                    "replace_diagnostics": dict(self._last_replace_diagnostics),
                }
            )
            new_content = result
        return new_content
