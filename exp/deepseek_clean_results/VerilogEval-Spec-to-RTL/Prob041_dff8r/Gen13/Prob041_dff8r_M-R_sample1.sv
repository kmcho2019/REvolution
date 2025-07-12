/**
 * Refactored D Flip-Flop Module with Synchronous Reset
 * Uses explicit combinational/sequential separation
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

    wire [WIDTH-1:0] next_q;
    
    // Combinational logic: reset mux
    assign next_q = reset ? {WIDTH{1'b0}} : d;
    
    // Sequential logic: clocked register
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule

/**
 * Top Module remains unchanged as the interface is identical
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    DFF dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule