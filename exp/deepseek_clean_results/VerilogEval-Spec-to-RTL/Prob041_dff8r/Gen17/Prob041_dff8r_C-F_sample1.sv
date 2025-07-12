/**
 * Optimized D Flip-Flop Module with Synchronous Reset
 * 
 * Features:
 * - Parameterized width (defaults to 8 bits for this application)
 * - Positive edge-triggered
 * - Synchronous active-high reset (sets all bits to 0)
 * - Efficient reset implementation using ternary operator
 * - Clean, maintainable structure
 */
module DFF #(
    parameter WIDTH = 8  // Default to 8 bits for this specific use case
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    q <= reset ? {WIDTH{1'b0}} : d;  // Efficient synchronous reset
end

endmodule

/**
 * Top Module - 8-bit Register with Optimal Implementation
 * 
 * PPA Considerations:
 * - Default single-block implementation for best power/area
 * - Option for individual flip-flops (commented) when needed
 * - Zero timing violations expected
 * - Efficient reset propagation
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Primary implementation: Single DFF instance (optimal for PPA)
DFF dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

/* Alternative implementation: Individual flip-flops (uncomment if needed)
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF #(.WIDTH(1)) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate
*/

endmodule