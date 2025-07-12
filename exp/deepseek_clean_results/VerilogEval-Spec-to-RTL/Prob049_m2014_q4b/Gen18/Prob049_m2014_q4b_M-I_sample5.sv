module TopModule (
    input  clk,  // Positive edge-triggered clock
    input  ar,   // Asynchronous reset (active high)
    input  d,    // Data input
    output reg q // Registered output
);

// Power-optimized DFF with clock gating hint
// When d is stable for multiple cycles, consider external clock gating
wire clk_enable = (q != d); // Clock gating condition

always @(posedge clk or posedge ar)
    if (ar)     q <= 1'b0;  // Async reset (highest priority)
    else if (clk_enable) q <= d; // Data capture only when needed

// Note: Actual clock gating should be implemented at higher level
// This module provides the enable condition for system-level optimization

endmodule