/**
 * TopModule - 8-bit Register with Synchronous Reset
 * Simple implementation with:
 * - 8-bit input/output
 * - Positive edge-triggered flip-flops
 * - Synchronous active-high reset
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 8'b0;  // Synchronous reset to zero
        else       q <= d;     // Normal operation
    end

endmodule