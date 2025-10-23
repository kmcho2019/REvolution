/**
 * Optimized TopModule - 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Compact implementation for better PPA
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk)
        q <= reset ? {WIDTH{1'b0}} : d;

endmodule