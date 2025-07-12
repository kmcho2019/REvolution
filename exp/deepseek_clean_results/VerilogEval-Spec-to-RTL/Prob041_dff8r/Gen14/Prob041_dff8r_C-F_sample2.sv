/**
 * 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit data width (fixed)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Clean, minimal implementation
 */

module TopModule (
    input clk,          // Clock input
    input reset,        // Synchronous reset (active high)
    input [7:0] d,      // 8-bit data input
    output reg [7:0] q  // 8-bit data output
);

    // Synchronous reset implementation
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;  // Clear all bits on reset
        else
            q <= d;     // Normal operation
    end

endmodule