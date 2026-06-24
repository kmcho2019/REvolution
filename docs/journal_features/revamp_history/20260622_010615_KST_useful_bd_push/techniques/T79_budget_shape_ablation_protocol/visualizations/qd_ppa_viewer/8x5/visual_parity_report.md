# QD/PPA Visual Parity Report

Non-strict Playwright render smoke was run for this viewer. The tracked
package retains the compare-mode render as `screenshot.png` and omits the
larger transient screenshot directory.

Strict Playwright interaction validation did not fully pass because the
generic checker expects the built-in `RTLLM/Prob004_adder_8bit` validation
problem and assumes denser archive cells than this T79 subset provides.
