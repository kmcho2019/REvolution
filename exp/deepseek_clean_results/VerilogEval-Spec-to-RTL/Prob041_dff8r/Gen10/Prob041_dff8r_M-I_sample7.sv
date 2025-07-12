/**
 * Optimized D Flip-Flop Module with Synchronous Reset
 * 
 * Parameters:
 *   WIDTH - Data width (default: 1)
 * 
 * Ports:
 *   clk   - Clock input (posedge triggered)
 *   reset - Synchronous active-high reset
 *   d     - Data input
 *   q     - Data output
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

/**
 * Optimized Top Module with 8-bit DFF Array
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

    // Array implementation - most efficient for PPA
    DFF #(.WIDTH(8)) dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule