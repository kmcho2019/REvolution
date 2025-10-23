/**
 * Simplified 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit width (fixed for this application)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Flat implementation for better area efficiency
 * - Clean and minimal design
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