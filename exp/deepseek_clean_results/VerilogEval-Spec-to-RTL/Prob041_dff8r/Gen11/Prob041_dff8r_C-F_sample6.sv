/**
 * Optimized D Flip-Flop Module with Synchronous Reset
 * Combines best aspects of both examples
 * 
 * Parameters:
 *   WIDTH - Data width (default: 8)
 * 
 * Ports:
 *   clk   - Clock input (posedge triggered)
 *   reset - Synchronous active-high reset
 *   d     - Data input
 *   q     - Data output
 */
module DFF #(
    parameter WIDTH = 8
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

/**
 * Optimized Top Module with parameterized DFF array
 * Fuses best ideas from both examples
 * 
 * Ports:
 *   clk   - Clock input
 *   reset - Synchronous reset
 *   d     - 8-bit data input
 *   q     - 8-bit data output
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Parameterized array implementation - most efficient for PPA
    DFF dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule