/**
 * Enhanced 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Optional clock enable (active high)
 * - Clean hierarchical design
 * - Comprehensive documentation
 */

module DFF #(
    parameter WIDTH = 1
) (
    input clk,          // Clock input
    input reset,        // Synchronous reset (active high)
    input ce,           // Clock enable (active high)
    input [WIDTH-1:0] d,// Data input
    output reg [WIDTH-1:0] q // Data output
);

    // Parameter validation
    initial if (WIDTH < 1) $error("WIDTH must be at least 1");

    // Next state logic with synchronous reset
    wire [WIDTH-1:0] next_q = reset ? {WIDTH{1'b0}} : d;

    // Register with clock enable
    always @(posedge clk) begin
        if (ce) q <= next_q;
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

    // Instantiate parameterized DFF array
    DFF #(.WIDTH(WIDTH)) dff_array (
        .clk(clk),
        .reset(reset),
        .ce(1'b1),      // Default clock enable always on
        .d(d),
        .q(q)
    );

endmodule