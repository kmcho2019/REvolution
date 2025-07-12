/**
 * TopModule - 8-bit Register with Synchronous Reset
 * 
 * Optimized Features:
 * - Fixed 8-bit width (as specified)
 * - Positive edge-triggered flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Direct implementation without submodules
 * - Minimal hierarchy for best PPA
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 8'b0;  // Synchronous reset to zero
        else       q <= d;      // Normal operation
    end

endmodule