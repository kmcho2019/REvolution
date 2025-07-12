/**
 * TopModule - 8-bit Register with Synchronous Reset (Alternative Implementation)
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops implemented via continuous assignment
 * - Synchronous active-high reset (sets output to 0)
 * - Compact single-module implementation
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    reg [WIDTH-1:0] q_reg;

    // Continuous assignment for flip-flop behavior
    assign q = q_reg;

    // Flip-flop implementation via continuous assignment
    always @(posedge clk) begin
        q_reg <= reset ? {WIDTH{1'b0}} : d;
    end

endmodule