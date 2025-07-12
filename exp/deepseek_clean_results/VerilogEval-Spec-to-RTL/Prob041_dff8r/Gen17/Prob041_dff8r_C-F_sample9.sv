/**
 * 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit data width (fixed as per requirements)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Minimal implementation for optimal PPA
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 8'b0;
        else       q <= d;
    end

endmodule