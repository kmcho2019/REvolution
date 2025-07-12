/**
 * Optimized 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Fixed 8-bit width (simplifies design)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Flat implementation for better PPA
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Synchronous reset implementation
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule