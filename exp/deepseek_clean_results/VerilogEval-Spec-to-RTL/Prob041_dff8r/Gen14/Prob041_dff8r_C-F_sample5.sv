/**
 * 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Clean implementation with combinational/sequential separation
 * - Optimal power and area characteristics
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,          // Clock input
    input reset,        // Synchronous reset (active high)
    input [WIDTH-1:0] d,// Data input
    output reg [WIDTH-1:0] q // Data output
);

    // Combinational logic: reset multiplexer
    wire [WIDTH-1:0] next_q = reset ? {WIDTH{1'b0}} : d;

    // Sequential logic: clocked register
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule