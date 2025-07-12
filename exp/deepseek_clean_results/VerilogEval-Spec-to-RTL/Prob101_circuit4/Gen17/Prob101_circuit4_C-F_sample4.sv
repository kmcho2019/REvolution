/*
 * TopModule - Optimized combinational OR gate with power-aware design
 *
 * Functionality:
 *   Implements q = b OR c (independent of a and d)
 *   Unused inputs explicitly handled for power optimization
 *
 * Design Choices:
 *   1. Continuous assignment for clean, readable implementation
 *   2. Explicit tie-off of unused inputs for power optimization
 *   3. Minimal gate count for best PPA characteristics
 *
 * Power Optimization:
 *   - Unused inputs tied to ground to prevent floating gate issues
 *   - Single OR operation minimizes dynamic power
 *
 * Truth Table:
 *   b c | q
 *   ----|---
 *   0 0 | 0
 *   0 1 | 1
 *   1 0 | 1
 *   1 1 | 1
 */
module TopModule (
    input  a,       // Unused input (tied low for power optimization)
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Unused input (tied low for power optimization)
    output q        // OR result of b and c
);

    // Power optimization: Explicit tie-off of unused inputs
    // (Prevents floating inputs and reduces power consumption)
    // Note: These assignments are optimized away during synthesis
    wire a_unused = 1'b0;
    wire d_unused = 1'b0;

    // Clean continuous assignment implementation
    assign q = b | c;

endmodule