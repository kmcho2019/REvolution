/**
 * TopModule - Optimized 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - 8-bit width (default, can be parameterized if needed)
 * - Positive edge-triggered D flip-flops
 * - Synchronous active-high reset (sets output to 0)
 * - Optimal PPA characteristics
 * - Clean hierarchical structure
 * 
 * PPA Considerations:
 * - Single DFF array implementation for best area/power
 * - Efficient synchronous reset implementation
 * - Zero timing violations expected
 */

module DFF #(
    parameter WIDTH = 8  // Default to 8 bits for this application
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk) begin
        q <= reset ? {WIDTH{1'b0}} : d;  // Optimal reset implementation
    end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Optimal single instance implementation
    DFF dff_array (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule