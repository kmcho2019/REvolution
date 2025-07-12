module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output with default reset value (documentation)
);

// Optimized D flip-flop with synchronous reset:
// - Reset has priority (active high)
// - Single-line implementation reduces power by minimizing switching
// - Explicit reset value declaration improves maintainability
always @(posedge clk) q <= r ? 1'b0 : d;

endmodule