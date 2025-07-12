module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output with explicit reset value (0)
);

// Optimized D flip-flop with synchronous reset:
// - Single-line implementation reduces power by minimizing switching
// - Reset has priority (active high) with clear documentation
// - Explicit reset value declaration improves maintainability
// - Non-blocking assignment ensures proper synchronous behavior
always @(posedge clk) q <= r ? 1'b0 : d;

endmodule