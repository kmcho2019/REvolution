/**
 * TopModule - Optimized 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Optimal PPA characteristics
 * - Clean hierarchical structure
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk) begin
        q <= reset ? {WIDTH{1'b0}} : d;  // Optimized reset implementation
    end

endmodule

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Single instance implementation (optimal PPA)
    DFF #(.WIDTH(WIDTH)) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule