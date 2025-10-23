/**
 * 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit width (as specified)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Simple, flat implementation
 */

module TopModule (
    input clk,          // Clock input
    input reset,        // Synchronous reset (active high)
    input [7:0] d,      // 8-bit data input
    output reg [7:0] q  // 8-bit data output
);

    // Register with synchronous reset
    always @(posedge clk) begin
        q <= reset ? 8'b0 : d;
    end

endmodule